param(
    [Parameter(Mandatory=$true)][string]$ReleaseFile,
    [string]$AssetName = ''
)
$ErrorActionPreference = 'Stop'
try {
    $release = Get-Content -LiteralPath $ReleaseFile -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($release.draft -or $release.prerelease) { throw 'A stable published release is required.' }
    $candidates = @($release.assets | Where-Object {
        if ($AssetName) { $_.name -ceq $AssetName }
        else { $_.name -match '^BigCityLegacy.*\.zip$' -and $_.name -notmatch '(?i)(src|source|offline)' }
    })
    if ($candidates.Count -ne 1) { throw "Expected one release asset, found $($candidates.Count)." }
    $url = [uri]$candidates[0].browser_download_url
    if (-not $url.IsAbsoluteUri -or $url.Scheme -ne 'https' -or -not $url.Host) { throw 'Asset URL must use HTTPS.' }
    [Console]::Out.WriteLine($url.AbsoluteUri)
    exit 0
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 2
}
