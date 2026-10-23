param([Parameter(Mandatory=$true)][string]$Archive,
      [Parameter(Mandatory=$true)][string]$GameDirectory,
      [switch]$ValidateOnly,
      [string]$KeyFiles = '')
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\PluginKeyFiles.ps1"
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = $null
$backup = $null
$keepBackup = $false
$written = New-Object 'System.Collections.Generic.List[string]'
$existing = New-Object 'System.Collections.Generic.Dictionary[string,string]' ([StringComparer]::OrdinalIgnoreCase)
try {
    $root = [IO.Path]::GetFullPath($GameDirectory).TrimEnd('\','/') + '\'
    $requestedKeys = @()
    if ($KeyFiles) { $requestedKeys = $KeyFiles.Split('|') }
    $keys = @(ConvertTo-PluginKeyFiles $requestedKeys)
    $zip = [IO.Compression.ZipFile]::OpenRead($Archive)
    $entries = New-Object 'System.Collections.Generic.Dictionary[string,object]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $zip.Entries) {
        $name = $entry.FullName.Replace('/','\')
        if ($name -match '(^[\\/]|:|[\x00-\x1f]|(^|\\)\.\.(\\|$))' -or $name -match '(\.| )($|\\)') { throw 'Unsafe plugin archive path.' }
        if (!$name -or $name.EndsWith('\')) { continue }
        $path = [IO.Path]::GetFullPath([IO.Path]::Combine($root,$name))
        if (!$path.StartsWith($root,[StringComparison]::OrdinalIgnoreCase) -or $entries.ContainsKey($path)) { throw 'Invalid or duplicate archive path.' }
        $parent = [IO.Path]::GetDirectoryName($path)
        while ($parent -and $parent.Length -ge $root.TrimEnd('\').Length) {
            if ([IO.Directory]::Exists($parent) -and (([IO.File]::GetAttributes($parent) -band [IO.FileAttributes]::ReparsePoint) -ne 0)) { throw 'Plugin path contains a directory link.' }
            $parent = [IO.Path]::GetDirectoryName($parent)
        }
        if ([IO.File]::Exists($path) -and (([IO.File]::GetAttributes($path) -band [IO.FileAttributes]::ReparsePoint) -ne 0)) { throw 'Plugin target is a file link.' }
        $entries.Add($path,$entry)
    }
    if (!$entries.Count) { throw 'Plugin archive is empty.' }
    foreach ($key in $keys) {
        $target = Get-PluginKeyTarget $GameDirectory $key
        if (!$entries.ContainsKey($target)) { throw "Plugin archive is missing a key file: $key" }
    }
    if ($ValidateOnly) { exit 0 }
    $backup = Join-Path ([IO.Path]::GetTempPath()) ('BCL-plugin-backup-' + [Guid]::NewGuid().ToString('N'))
    [IO.Directory]::CreateDirectory($backup) | Out-Null
    foreach ($pair in $entries.GetEnumerator()) {
        $path = $pair.Key
        # Preserve existing plugin configuration; replace versioned binaries/assets.
        if ([IO.File]::Exists($path) -and ($path -match '\\BepInEx\\config\\' -or $path -match '\\BigCityLegacy\\config\\')) { continue }
        if ([IO.File]::Exists($path)) {
            $saved = Join-Path $backup ([Guid]::NewGuid().ToString('N'))
            [IO.File]::Copy($path,$saved); $existing.Add($path,$saved)
        }
        [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($path)) | Out-Null
        $written.Add($path)
        [IO.Compression.ZipFileExtensions]::ExtractToFile($pair.Value,$path,$true)
    }
    foreach ($key in $keys) {
        if (![IO.File]::Exists((Get-PluginKeyTarget $GameDirectory $key))) { throw "Installed plugin key file is missing: $key" }
    }
} catch {
    foreach ($path in $written) {
        try { if ($existing.ContainsKey($path)) { [IO.File]::Copy($existing[$path],$path,$true) } else { [IO.File]::Delete($path) } }
        catch { $keepBackup = $true; [Console]::Error.WriteLine('Rollback failed for ' + $path + ': ' + $_.Exception.Message + '; backup: ' + $backup) }
    }
    [Console]::Error.WriteLine($_.Exception.Message); exit 1
} finally {
    if ($zip) { $zip.Dispose() }
    if ($backup -and !$keepBackup -and [IO.Directory]::Exists($backup)) { [IO.Directory]::Delete($backup,$true) }
}
