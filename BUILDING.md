# Building online and offline installers

Use **Inno Setup 7.x**. The shared implementation is `BCL_Installer.iss`; `BCL_Installer_Offline.iss` defines `BCL_OFFLINE` and includes it, keeping validation, backup, rollback and configuration preservation identical.

```powershell
& 'C:\Program Files\Inno Setup 7\ISCC.exe' BCL_Installer.iss
& 'C:\Program Files\Inno Setup 7\ISCC.exe' BCL_Installer_Offline.iss
```

Outputs: `Output/BigCityLegacy_Installer.exe` and `Output/BigCityLegacy_Installer_Offline.exe`. Both welcome pages show a localized `Version: <Unix timestamp>` in the lower-left corner of the branding image. The UTC timestamp is captured at compilation time using Windows PowerShell, not when Setup starts.

The online welcome page stacks the selected repository link and Wiki link above the GitHub/Codeberg selector near the bottom edge. The offline welcome page stacks GitHub, Codeberg and Wiki links. In both builds, the welcome Wiki link and the final Visit Wiki checkbox open GitHub Wiki for English/Russian and Codeberg Chinese documentation for Chinese, independently of the selected download provider. Selecting the Chinese installer language defaults to Codeberg. `/SOURCE=GitHub` or `/SOURCE=Codeberg` overrides that default, including unattended use. An explicitly selected source (selector change or /SOURCE) is forwarded as `-repositorySource:<source>` when Setup launches the game; the mod stores it in PlayerPrefs. Setup does not write RepositorySource.json. When no source is explicitly selected, or when the game is launched outside Setup, the mod uses its saved choice or OS language/region default.

The optional plugins page loads `remote_config/PluginsList.json` from the selected provider. In interactive mode, `isChecked: true` preselects a plugin; missing, null or false leaves it unchecked. Users can change these choices; select an item and use the Repository button to open its repository. The manifest has `version: 1` and a `plugins` array; each entry provides `name`, `version`, `githubRepo`, `githubDl`, `codebergRepo`, `codebergDl`, and optionally `keyFiles`, `size` and `isChecked`. Only the selected provider's download URL is used. A missing, null, empty or whitespace-only `githubDl`/`codebergDl` hides that entry for the corresponding provider, including automatic silent updates; it does not trigger a fallback to the other provider. Nonempty download URLs retain HTTPS validation. The plugins page is skipped when the catalog is empty, missing, invalid or unavailable. Failed catalog requests are not repeated while navigating back and forward; changing the provider allows another attempt. Selected archives must be downloadable before installation can finish; unpublished example URLs are not usable payloads.

Plugin repository and download URLs can use any domain, including raw-file hosts, CDNs and separate mirrors. The selected provider only chooses the `githubRepo`/`githubDl` or `codebergRepo`/`codebergDl` fields; it does not restrict their hosts. URLs must be absolute HTTPS addresses without embedded credentials. URL errors identify the plugin and field in the setup log.

`size` is a non-negative JSON integer containing the plugin ZIP size in bytes, up to the signed 64-bit maximum. The plugins list shows it in a right-hand column using B, KiB, MiB, GiB and larger binary units (1 KiB = 1024 bytes). `6347954` displays as `6.05 MiB`, with the decimal separator following the system locale. Missing or null sizes leave the column empty; zero displays as `0 B`. Size metadata controls display only and does not replace ZIP/key-file validation. Offline entries have no catalog size metadata and leave the column empty.

The native game-directory dialog uses the ordinary filesystem view with an all-files filter. It accepts a selected file such as `game.exe` and returns its containing directory; confirming the prefilled filename selects the current directory even if that file is absent there. Setup validates the game directory afterwards. The helper returns the selected path through a UTF-8 BOM file instead of the console, avoiding OEM/ANSI conversions for Cyrillic and other Unicode names. File and archive operations also receive Unicode paths.

In `/SILENT` or `/VERYSILENT` online mode, installed additional plugins are updated automatically, without changing the arguments used by older BCL releases. Detection uses `keyFiles`, relative to `BepInEx/plugins`: finding at least one listed file selects that plugin, allowing a partial installation to be repaired. Plugins that are absent, or have no key files, are not installed automatically. Catalog `isChecked` defaults apply only to interactive installs; they do not select new plugins during silent updates or override `/noExtraUpdate`. Non-null `isChecked` values must be JSON booleans, not strings or numbers. The catalog version is reinstalled without a local version comparison. All declared key files must be present in the downloaded archive and after extraction. `/noExtraUpdate` disables this automatic selection and catalog request in silent mode; interactive checkbox choices are unaffected. If the catalog is unavailable, the setup log records that additional plugins could not be checked and the core update continues. A selected plugin's failed download or validation prevents successful completion and game restart.

Example plugin entry:

```json
{
  "name": "EnhancedCarTuning",
  "version": "1.0.0",
  "githubRepo": "https://github.com/LxgacyTeam/EnhancedCarTuning",
  "githubDl": "https://github.com/LxgacyTeam/EnhancedCarTuning/releases/download/1.0.0/BCL_EnhancedCarTuning-1.0.0.zip",
  "codebergRepo": "https://codeberg.org/LxgacyTeam/EnhancedCarTuning",
  "codebergDl": "https://codeberg.org/LxgacyTeam/EnhancedCarTuning/releases/download/1.0.0/BCL_EnhancedCarTuning-1.0.0.zip",
  "size": 6347954,
  "isChecked": true,
  "keyFiles": ["EnhancedCarTuning/EnhancedCarTuning.dll", "EnhancedCarTuning/EnhancedCarTuning.Resources.dll"]
}
```

BepInEx and BCL each use one progress bar for download and extraction: 0–50% for downloaded bytes and 50–100% for extracted bytes. In offline builds, extraction uses the entire 0–100% range. BCL is staged immediately after downloading, before plugin preflight and replacement of the existing installation; its validated stage is reused during installation. ZIP extraction uses Inno Setup's embedded 7-Zip engine (`ArchiveExtraction=full`).

Selected plugins show download progress from the actual transferred byte count (indeterminate while the server has not supplied a total size). Installation shows extraction progress by uncompressed bytes, including within large files. Each operation resets the bar for its plugin; completion is shown after key-file verification. Offline plugins show extraction progress too. Archive validation uses an indeterminate bar.

Selected archives are tested and validated before replacing the mod. Their paths are relative to the game root. Each plugin installation preserves existing configuration in `BepInEx/config` and `BigCityLegacy/config` and restores overwritten files if that plugin fails to install. Successfully installed plugins remain installed if a later plugin fails; the setup log identifies the failure. Game launch and successful completion are withheld on failure.

For Codeberg, the mod release is obtained from `/api/v1/repos/LxgacyTeam/BigCityLegacy/releases/latest`. Assets are selected by **name**, because Forgejo attachment URLs may have no `.zip` extension. Publish one binary ZIP `BigCityLegacy-<version>.zip`; source/offline ZIPs are excluded. BepInEx uses the file in the repository directly:

```text
https://codeberg.org/LxgacyTeam/bepinex5-releases-mirror/raw/branch/main/BepInEx_win_x64_5.4.23.5.zip
```

For GitHub, BepInEx continues to use the upstream 5.4.23.5 release. The selected Codeberg path does not fall back to GitHub. Legal notices use the selected download provider. Wiki navigation follows the installer language.

The offline build requires these files in `payload/`:

- `BepInEx.zip`: unmodified upstream `BepInEx_win_x64_5.4.23.5.zip`.
- `BigCityLegacy.zip`: compiled mod release ZIP, with the same layout as online releases.
- `NOTICE.rtf`, `NOTICE_RU.rtf`, and `NOTICE_ZH.rtf`: from the mod's `docs/`.

Release ZIP layout:

```text
BepInEx/plugins/BigCityLegacy/BigCityLegacy.dll
BepInEx/plugins/BigCityLegacy/LegacyUIFramework.dll
BigCityLegacy/config/ServerConfig.toml
BigCityLegacy/config/ServersList.json
BigCityLegacy/config/RespawnPoints.json
BigCityLegacy/events/<event name>.json
runServer.cmd
```

Replace payload files for each mod release before compiling the offline installer. Place optional installable plugin ZIPs in `offline_plugins/` before compilation. Their filenames are displayed on the plugins page, and every archive is embedded in the EXE. The directory may be empty; in that case the plugins page is skipped. Use descriptive filenames without apostrophes, such as `EnhancedCarTuning_1.0.0.zip`. Source archives are not installable plugins.

The offline executable contains no online download logic, source selector or online catalog helper. Repository and Wiki links open in the browser only when the user clicks them or selects Visit Wiki. It ignores `/SOURCE` and does not change the mod's saved provider. English, Russian and Simplified Chinese legal notices are embedded.

Existing configs and event files are never overwritten. If an old `Events.json` is present, bundled events are not seeded: the mod first migrates the user's collection. DLL replacement retains the existing backup/rollback behavior. Both installer builds copy `runServer.cmd` from the BCL archive to the game root if absent; an existing customized launcher is preserved. Archives from older releases without this script remain supported. The Windows installer does not copy `runServer.sh`.

Offline silent runs do not query the remote catalog or automatically select embedded plugins; the automatic plugin-update mechanism is part of the online updater.

Publish the **online** EXE as `BigCityLegacy_Installer.exe` in stable BCL-installer releases on both GitHub and Codeberg **before publishing the mod update**: older installer builds ignore `/SOURCE`. Git repository mirroring alone does not copy releases or attachments. The mod fetches the latest stable installer and invokes:

```text
BigCityLegacy_Installer.exe /GAME="C:\Games\MadOut2" /SILENT /SKIPEULA /RUNGAME /DISPOSABLE /SOURCE=Codeberg
```

`/GAME` is the game **directory**, not the path to game.exe. Existing Inno Setup silent behavior closes running game processes; successful updates restart the game and remove the disposable installer. The offline EXE is intentionally not used by the in-game updater.
