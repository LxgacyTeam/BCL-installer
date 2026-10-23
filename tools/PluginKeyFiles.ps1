function ConvertTo-PluginKeyFiles($Value) {
    if ($null -eq $Value) { return }
    if ($Value -isnot [Array] -or $Value.Count -gt 64) { throw 'keyFiles must be an array with at most 64 paths.' }
    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($key in $Value) {
        if ($key -isnot [string] -or [string]::IsNullOrWhiteSpace($key) -or $key.Length -gt 1024 -or $key -match '[<>:"|?*\x00-\x1f\x7f]') {
            throw 'Invalid plugin key file.'
        }
        $normalized = $key.Replace('/','\')
        if ([IO.Path]::IsPathRooted($normalized)) { throw 'Plugin key files must be relative to BepInEx/plugins.' }
        foreach ($segment in $normalized.Split('\')) {
            if (!$segment -or $segment -eq '.' -or $segment -eq '..' -or $segment -match '[ .]$' -or
                $segment -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])($|\.)') { throw 'Unsafe plugin key file path.' }
        }
        if (!$seen.Add($normalized)) { throw 'Duplicate plugin key file.' }
        Write-Output $normalized
    }
}

function Get-PluginKeyTarget([string]$GameDirectory, [string]$KeyFile) {
    $root = [IO.Path]::GetFullPath((Join-Path $GameDirectory 'BepInEx\plugins')).TrimEnd('\','/') + '\'
    $target = [IO.Path]::GetFullPath([IO.Path]::Combine($root, $KeyFile))
    if (!$target.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { throw 'Plugin key file is outside BepInEx/plugins.' }
    return $target
}
