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

