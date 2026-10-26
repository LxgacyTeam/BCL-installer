param([Parameter(Mandatory=$true)][string]$Manifest,
      [Parameter(Mandatory=$true)][ValidateSet('GitHub','Codeberg')][string]$Source,
      [Parameter(Mandatory=$true)][string]$OutputFile,
      [string]$GameDirectory)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\PluginKeyFiles.ps1"
try {
    $data = Get-Content -LiteralPath $Manifest -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($data.version -ne 1 -or $data.plugins -isnot [Array]) { throw 'Unsupported plugin catalog format.' }
    if ($data.plugins.Count -gt 500) { throw 'Plugin catalog is too large.' }
    $lines = New-Object 'System.Collections.Generic.List[string]'
    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $provider = $Source.ToLowerInvariant()
    foreach ($plugin in $data.plugins) {
        foreach ($field in @('name','version','githubRepo','codebergRepo')) {
            $value = $plugin.$field
            if ($value -isnot [string] -or [string]::IsNullOrWhiteSpace($value) -or $value -match '[\x00-\x1f\x7f]') {
                throw "Invalid plugin field: $field"
            }
        }
        if ($plugin.name.Length -gt 128 -or $plugin.version.Length -gt 64 -or !$seen.Add($plugin.name)) { throw 'Invalid/duplicate plugin name.' }
        # A missing/null/blank download disables the plugin for that provider.
        foreach ($field in @('githubDl','codebergDl')) {
            $value = $plugin.$field
            if ($null -ne $value -and ($value -isnot [string] -or $value -match '[\x00-\x1f\x7f]')) {
                throw "Invalid plugin field: $field"
            }
        }
        $repo = $plugin.($provider + 'Repo')
        $download = $plugin.($provider + 'Dl')
        if ([string]::IsNullOrWhiteSpace($download)) { continue }
        foreach ($field in @('Repo','Dl')) {
            $url = $plugin.($provider + $field)
            $uri = $null
            if (![Uri]::TryCreate($url,[UriKind]::Absolute,[ref]$uri) -or $uri.Scheme -ne 'https' -or !$uri.Host -or $uri.UserInfo) {
                throw ("Plugin '{0}': {1}{2} must be an absolute HTTPS URL without credentials." -f $plugin.name,$provider,$field)
            }
        }
        $keys = @(ConvertTo-PluginKeyFiles $plugin.keyFiles)
        $installed = $false
        if ($GameDirectory) {
            foreach ($key in $keys) {
                # A partial installation also needs repair/update.
                if ([IO.File]::Exists((Get-PluginKeyTarget $GameDirectory $key))) { $installed = $true; break }
            }
        }
        $checked = $false
        if ($null -ne $plugin.isChecked) {
            if ($plugin.isChecked -isnot [bool]) { throw 'Plugin isChecked must be a JSON boolean.' }
            $checked = $plugin.isChecked
        }
        $size = ''
        if ($null -ne $plugin.size) {
            if (($plugin.size -isnot [int] -and $plugin.size -isnot [long]) -or $plugin.size -lt 0) {
                throw 'Plugin size must be a non-negative integer byte count.'
            }
            $size = $plugin.size.ToString([Globalization.CultureInfo]::InvariantCulture)
        }
        $lines.Add($plugin.name); $lines.Add($plugin.version); $lines.Add($repo); $lines.Add($download)
        $lines.Add(($keys -join '|')); $lines.Add($size); $lines.Add(([int]$checked).ToString()); $lines.Add(([int]$installed).ToString())
    }
    [IO.File]::WriteAllLines($OutputFile,$lines,(New-Object Text.UTF8Encoding($true)))
} catch { [Console]::Error.WriteLine($_.Exception.Message); exit 1 }
