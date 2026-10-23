<p align="center">
  <picture>
    <img alt="bcl" src="branding/bcl-logo-512.png">
  </picture>
</p>

# BigCityLegacy Installer

##### Standalone Windows installer/updater for BigCityLegacy mod, powered by Inno Setup 7.x
---
**Features:**
- Automatic installation and initial setup of BepInEx
- Automatic download and installation/update of the latest BigCityLegacy version
- Validation of BepInEx installation and game version check
- Custom configs in BigCityLegacy\config are not overwritten during updates
- Silent mode with self-deletion
---

**Custom startup flags:**
```
/GAME="path\to\game" - specify path to game folder
/SOURCE=GitHub|Codeberg - repository source
/noExtraUpdate - disable automatic updates of installed additional plugins in silent online mode
/SKIPEULA - skip legal page 
/RUNGAME - launch game after successful installation. Works only with /SILENT or /VERYSILENT
/DISPOSABLE - automatic self-deletion of the installer after installation completes
```
In silent modes, all instances of the game terminate automatically without warning.

Silent update example:
```
BigCityLegacy_Installer.exe /GAME="C:\Games\MadOut2" /SILENT /SKIPEULA /RUNGAME /DISPOSABLE /SOURCE=Codeberg 
```


Online installation supports GitHub and Codeberg, including the BepInEx file mirror. The offline build embeds BepInEx, the mod and legal notices. See [BUILDING.md](BUILDING.md) for payload layout and release publishing.

## Sources, languages and plugins

The online installer supports GitHub and Codeberg, with English, Russian and Simplified Chinese UI. Chinese defaults to Codeberg. Optional plugins are selected on a separate page using `remote_config/PluginsList.json`; the Repository button opens the highlighted plugin. Silent online updates automatically reinstall the catalog versions of installed additional plugins detected by `keyFiles`, including partial installations. No additional argument is needed by older BCL updaters. Use `/noExtraUpdate` to update the core mod only.

The Windows launcher `runServer.cmd` is copied from the BCL archive to the game root if absent. An existing launcher is preserved. `runServer.sh` is not installed.

The offline installer uses embedded payloads only. Place optional plugin ZIPs in `offline_plugins/` before compiling; it offers those archives without source controls. GitHub, Codeberg and Wiki links are available on the welcome page. Empty or unavailable plugin lists are skipped. Wiki links follow the interface language (English/Russian: GitHub; Chinese: Codeberg). [Build and payload documentation](BUILDING.md).
