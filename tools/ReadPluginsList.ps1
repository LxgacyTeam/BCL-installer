param([Parameter(Mandatory=$true)][string]$Manifest,
      [Parameter(Mandatory=$true)][ValidateSet('GitHub','Codeberg')][string]$Source,
      [Parameter(Mandatory=$true)][string]$OutputFile)
$ErrorActionPreference = 'Stop'
try {
    $data = Get-Content -LiteralPath $Manifest -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($data.version -ne 1 -or $data.plugins -isnot [Array]) { throw 'Unsupported plugin catalog format.' }
    if ($data.plugins.Count -gt 500) { throw 'Plugin catalog is too large.' }
    $lines = New-Object 'System.Collections.Generic.List[string]'
    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $provider = $Source.ToLowerInvariant()
    $hostName = if ($Source -eq 'Codeberg') { 'codeberg.org' } else { 'github.com' }
    foreach ($plugin in $data.plugins) {
        foreach ($field in @('name','version','githubRepo','githubDl','codebergRepo','codebergDl')) {
            $value = $plugin.$field
            if ($value -isnot [string] -or [string]::IsNullOrWhiteSpace($value) -or $value -match '[\x00-\x1f\x7f]') {
                throw "Invalid plugin field: $field"
            }
        }
        if ($plugin.name.Length -gt 128 -or $plugin.version.Length -gt 64 -or !$seen.Add($plugin.name)) { throw 'Invalid/duplicate plugin name.' }
        $repo = $plugin.($provider + 'Repo')
        $download = $plugin.($provider + 'Dl')
        foreach ($url in @($repo,$download)) {
            $uri = $null
            if (![Uri]::TryCreate($url,[UriKind]::Absolute,[ref]$uri) -or $uri.Scheme -ne 'https' -or $uri.Host -ne $hostName -or $uri.UserInfo) {
                throw 'Plugin URL must use HTTPS on the selected repository host.'
            }
        }
        $lines.Add($plugin.name); $lines.Add($plugin.version); $lines.Add($repo); $lines.Add($download)
    }
    [IO.File]::WriteAllLines($OutputFile,$lines,(New-Object Text.UTF8Encoding($true)))
} catch { [Console]::Error.WriteLine($_.Exception.Message); exit 1 }
