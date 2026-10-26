; ============================================================================
; BigCityLegacy Installer / Updater
; by LegacyTeam
;
; for Inno Setup 7.x
; ============================================================================

#define MyAppName "BigCityLegacy"
; UTC Unix timestamp is captured once by the compiler, never at installer startup.
#define BuildTimestamp ExecAndGetFirstLine(AddBackslash(SysPath) + "WindowsPowerShell\v1.0\powershell.exe", "-NoLogo -NoProfile -NonInteractive -Command " + AddQuotes("[DateTimeOffset]::UtcNow.ToUnixTimeSeconds()"))
#if Len(BuildTimestamp) < 10
  #error Failed to determine the installer build timestamp.
#endif

#define GameExe "game.exe"
#define SupportedGameVersion "9.4"

#define SupportedGameSHA256 "8C71E536AB169656AEAE13CCC0D1DD989516CD4648B1D14DB9B99D55430F15C0"

#ifndef BCL_OFFLINE
#define GitHubApiUrl "https://api.github.com/repos/LxgacyTeam/BigCityLegacy/releases/latest"
#define CodebergApiUrl "https://codeberg.org/api/v1/repos/LxgacyTeam/BigCityLegacy/releases/latest"
#define CodebergBepInExUrl "https://codeberg.org/LxgacyTeam/bepinex5-releases-mirror/raw/branch/main/BepInEx_win_x64_5.4.23.5.zip"
#define GitHubWebUrl "https://github.com/LxgacyTeam/BigCityLegacy"
#define WikiUrl "https://github.com/LxgacyTeam/BigCityLegacy/wiki"

#define TermsRtfUrlEn "https://github.com/LxgacyTeam/BigCityLegacy/raw/refs/heads/main/docs/NOTICE.rtf"
#define TermsRtfUrlRu "https://github.com/LxgacyTeam/BigCityLegacy/raw/refs/heads/main/docs/NOTICE_RU.rtf"
#define BepInExUrl "https://github.com/BepInEx/BepInEx/releases/download/v5.4.23.5/BepInEx_win_x64_5.4.23.5.zip"

#endif

#define BIECore "BepInEx\core\BepInEx.dll"
#define BIEConfig "BepInEx\config\BepInEx.cfg"
#define BIELog "BepInEx\LogOutput.log"
#define BIEDoorstop "doorstop_config.ini"
#define BIEWinHttp "winhttp.dll"

#define ModPluginDir "BepInEx\plugins\BigCityLegacy"
#define ModDll1 "BepInEx\plugins\BigCityLegacy\BigCityLegacy.dll"
#define ModDll2 "BepInEx\plugins\BigCityLegacy\LegacyUIFramework.dll"
#define ModConfigDir "BigCityLegacy\config"

#define FirstLaunchTimeoutMs 180000
#define PollIntervalMs 250

; ============================================================================

[Setup]

AppId={{6B7A8D10-7E6B-4A4D-9E2C-BIGCITYLEGACY}}
AppName={#MyAppName}
AppVerName={#MyAppName}
AppVersion=1.0.0
AppPublisher=LegacyTeam

#ifdef BCL_OFFLINE
OutputBaseFilename=BigCityLegacy_Installer_Offline
#else
OutputBaseFilename=BigCityLegacy_Installer
#endif
Compression=zip
SolidCompression=yes
ArchiveExtraction=full

WizardStyle=modern dynamic windows11
DisableWelcomePage=no

; --------------------------------------------------------------------------
; BRANDING
; --------------------------------------------------------------------------

WizardImageFile=branding\wizard-large-light.png
WizardImageFileDynamicDark=branding\wizard-large-dark.png
WizardSmallImageFile=branding\bcl-logo-512.png
WizardSmallImageFileDynamicDark=branding\bcl-logo-512.png
SetupIconFile=branding\bcl-logo.ico
; --------------------------------------------------------------------------

PrivilegesRequired=admin

ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64os

DisableProgramGroupPage=yes
Uninstallable=no

CreateAppDir=no
DefaultDirName={tmp}\BigCityLegacyInstaller
DisableDirPage=yes

SetupLogging=yes

[Files]

Source: "tools\7za.exe"; \
    DestDir: "{tmp}"; \
    Flags: dontcopy noencryption

Source: "tools\FolderPicker.ps1"; \
    DestDir: "{tmp}"; \
    Flags: dontcopy noencryption

#ifndef BCL_OFFLINE
Source: "tools\SelectReleaseAsset.ps1"; Flags: dontcopy noencryption
Source: "tools\ReadPluginsList.ps1"; Flags: dontcopy noencryption
#endif
Source: "tools\InstallPlugin.ps1"; Flags: dontcopy noencryption
Source: "tools\PluginKeyFiles.ps1"; Flags: dontcopy noencryption
#ifdef BCL_OFFLINE
Source: "payload\BepInEx.zip"; Flags: dontcopy noencryption
Source: "payload\BigCityLegacy.zip"; DestName: "BigCityLegacy-latest.zip"; Flags: dontcopy noencryption
Source: "payload\NOTICE.rtf"; Flags: dontcopy noencryption
Source: "payload\NOTICE_RU.rtf"; Flags: dontcopy noencryption
Source: "payload\NOTICE_ZH.rtf"; Flags: dontcopy noencryption
#define OfflineIndex 0
#define OfflineHandle
#define OfflineFound
#sub EmbedOfflinePlugin
  #define OfflineName FindGetFileName(OfflineHandle)
  #emit 'Source: "offline_plugins\' + OfflineName + '"; DestName: "BCL-plugin-' + Str(OfflineIndex) + '.zip"; Flags: dontcopy noencryption'
  #expr OfflineIndex++
#endsub
#for {OfflineHandle = OfflineFound = FindFirst(SourcePath + "offline_plugins\*.zip", 0); OfflineFound; OfflineFound = FindNext(OfflineHandle)} EmbedOfflinePlugin
#if OfflineHandle
  #call FindClose(OfflineHandle)
#endif
#endif

[Languages]

Name: "en"; \
    MessagesFile: "compiler:Default.isl"

Name: "ru"; \
    MessagesFile: "compiler:Languages\Russian.isl"

Name: "zh"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[CustomMessages]

en.BuildVersion=Version:
ru.BuildVersion=Версия:
zh.BuildVersion=版本：
en.PluginDownload=Downloading plugin...
ru.PluginDownload=Скачивание плагина...
zh.PluginDownload=正在下载插件...
en.PluginValidate=Validating plugin archive...
ru.PluginValidate=Проверка архива плагина...
zh.PluginValidate=正在验证插件压缩包...

en.SelectFolderButton=Select folder
ru.SelectFolderButton=Выбрать папку
zh.SelectFolderButton=选择文件夹
en.AllFilesFilter=All files
ru.AllFilesFilter=Все файлы
zh.AllFilesFilter=所有文件

en.GameDirectory=Game directory:
en.SelectGameDirectory=Select the root directory of the game.
en.GameDirectoryDescription=The selected directory must contain %1.
en.GameNotFound=The selected directory does not appear to contain the game.%n%nExpected:%n%1

en.GameRunningTitle=Game is running
en.GameRunning=Game is currently running.%n%nThe game must be closed before the mod can be installed or updated.%n%nDo you want the installer to close all instances of %1?

en.GameVersionWarningTitle=Compatibility mode
en.GameVersionWarning=The selected game version is different from the supported version %1.%n%nThe BigCityLegacy will still be installed, but it will run in compatibility mode with limited functionality.%n%nDo you want to continue?

en.BepInExDownload=Downloading BepInEx...
en.BepInExInstall=Installing BepInEx...
en.BepInExLaunch=Starting the game to initialize BepInEx...
en.BepInExValidation=Verifying BepInEx installation...

en.ModDownload=Downloading the latest BigCityLegacy version...
en.ModOffline=Preparing embedded BigCityLegacy files...
en.BepInExOffline=Preparing embedded BepInEx files...
en.LegalOffline=Loading included legal provisions...
en.ModInstall=Installing the latest BigCityLegacy version...
en.ModValidation=Verifying BigCityLegacy installation...

en.ModBackup=Backing up the existing BigCityLegacy version...
en.ModRollback=Restoring the previous BigCityLegacy version...

en.GitHubError=Could not obtain the BigCityLegacy release from the selected source.
en.DataSource=Data source for installation and updates:
en.BepInExError=Could not download or install BepInEx.
en.BepInExInitError=BepInEx did not initialize successfully within the expected time.
en.ModError=Could not install the latest version of the mod.

en.InstallComplete=Installation completed successfully.
en.UpdateComplete=Update completed successfully.

en.ConfigPreserved=Existing configuration files were preserved.

en.SelfDeleteFailed=The installer could not schedule its own deletion. You can delete the installer manually.

en.AbortInstallation=Installation was cancelled.

en.LegalTitle=Terms of use and legal provisions
en.LegalDescription=Please review the current terms before continuing.
en.LegalAccept=I have read and accept the terms of use and legal provisions.
en.LegalAcceptRequired=You must accept the terms of use and legal provisions to continue.
en.LegalDownload=Downloading the current legal provisions...
en.LegalDownloadError=The terms of use and legal provisions could not be loaded. Check the selected source or offline payload.
en.GitHubLink=GitHub
en.WikiLink=Wiki
en.RunGame=Launch the game
en.VisitWiki=Visit Wiki

ru.GameDirectory=Папка игры:
ru.SelectGameDirectory=Выберите корневую папку игры.
ru.GameDirectoryDescription=В выбранной папке должен находиться файл %1.
ru.GameNotFound=Выбранная папка не похожа на папку игры.%n%nОжидается:%n%1

ru.GameRunningTitle=Игра запущена
ru.GameRunning=Игра сейчас запущена.%n%nДля установки или обновления мода игру необходимо закрыть.%n%nЗакрыть все экземпляры %1?

ru.GameVersionWarningTitle=Режим совместимости
ru.GameVersionWarning=Выбрана версия игры, отличная от поддерживаемой версии %1.%n%nBigCityLegacy всё равно будет установлен, но будет работать в режиме совместимости с ограниченной функциональностью.%n%nПродолжить?

ru.BepInExDownload=Загрузка BepInEx...
ru.BepInExInstall=Установка BepInEx...
ru.BepInExLaunch=Запуск игры для инициализации BepInEx...
ru.BepInExValidation=Проверка установки BepInEx...

ru.ModDownload=Загрузка последней версии BigCityLegacy...
ru.ModOffline=Подготовка встроенных файлов BigCityLegacy...
ru.BepInExOffline=Подготовка встроенных файлов BepInEx...
ru.LegalOffline=Чтение включённых правовых положений...
ru.ModInstall=Установка BigCityLegacy...
ru.ModValidation=Проверка установки BigCityLegacy...

ru.ModBackup=Создание резервной копии текущей версии BigCityLegacy...
ru.ModRollback=Восстановление предыдущей версии BigCityLegacy...

ru.GitHubError=Не удалось получить версию BigCityLegacy из выбранного источника.
ru.DataSource=Источник данных для установки и обновлений:
ru.BepInExError=Не удалось скачать или установить BepInEx.
ru.BepInExInitError=BepInEx не удалось успешно инициализировать за отведённое время.
ru.ModError=Не удалось установить последнюю версию BigCityLegacy.

ru.InstallComplete=Установка успешно завершена.
ru.UpdateComplete=Обновление успешно завершено.

ru.ConfigPreserved=Существующие конфигурационные файлы сохранены.

ru.SelfDeleteFailed=Не удалось запланировать удаление установщика. Установщик можно удалить вручную.

ru.AbortInstallation=Установка отменена.

ru.LegalTitle=Условия использования и правовые положения
ru.LegalDescription=Ознакомьтесь с актуальными условиями перед продолжением.
ru.LegalAccept=Я прочитал(а) и принимаю условия использования и правовые положения.
ru.LegalAcceptRequired=Для продолжения необходимо принять условия использования и правовые положения.
ru.LegalDownload=Загрузка актуальных правовых положений...
ru.LegalDownloadError=Не удалось загрузить условия использования и правовые положения из выбранного источника. Проверьте подключение или офлайн-пакет.
ru.GitHubLink=GitHub
ru.WikiLink=Wiki
ru.RunGame=Запустить игру
ru.VisitWiki=Посетить Wiki



zh.GameDirectory=游戏目录：
zh.SelectGameDirectory=选择游戏根目录。
zh.GameDirectoryDescription=所选目录必须包含 %1。
zh.GameNotFound=所选目录中未找到游戏。%n%n需要的文件：%n%1
zh.GameRunningTitle=游戏正在运行
zh.GameRunning=游戏正在运行。%n%n安装或更新模组之前必须关闭游戏。%n%n是否关闭 %1 的所有实例？
zh.GameVersionWarningTitle=兼容模式
zh.GameVersionWarning=所选游戏版本与支持的版本 %1 不同。%n%nBigCityLegacy 将以功能受限的兼容模式运行。%n%n是否继续？
zh.BepInExDownload=正在下载 BepInEx...
zh.BepInExInstall=正在安装 BepInEx...
zh.BepInExLaunch=正在启动游戏以初始化 BepInEx...
zh.BepInExValidation=正在验证 BepInEx 安装...
zh.ModDownload=正在下载最新版本的 BigCityLegacy...
zh.ModOffline=正在准备内置的 BigCityLegacy 文件...
zh.BepInExOffline=正在准备内置的 BepInEx 文件...
zh.LegalOffline=正在加载内置的法律条款...
zh.ModInstall=正在安装 BigCityLegacy...
zh.ModValidation=正在验证 BigCityLegacy 安装...
zh.ModBackup=正在备份已安装的 BigCityLegacy...
zh.ModRollback=正在恢复之前的 BigCityLegacy 版本...
zh.GitHubError=无法从所选来源获取 BigCityLegacy 版本。
zh.DataSource=安装和更新的数据来源：
zh.BepInExError=无法下载或安装 BepInEx。
zh.BepInExInitError=BepInEx 未能在规定时间内完成初始化。
zh.ModError=无法安装模组。
zh.InstallComplete=安装成功。
zh.UpdateComplete=更新成功。
zh.ConfigPreserved=已保留现有配置文件。
zh.SelfDeleteFailed=无法安排自动删除安装程序。您可以手动删除它。
zh.AbortInstallation=安装已取消。
zh.LegalTitle=使用条款与法律声明
zh.LegalDescription=继续之前请阅读使用条款。
zh.LegalAccept=我已阅读并接受使用条款与法律声明。
zh.LegalAcceptRequired=必须接受使用条款与法律声明才能继续。
zh.LegalDownload=正在下载使用条款...
zh.LegalDownloadError=无法加载使用条款与法律声明。请检查数据来源或离线安装包。
zh.GitHubLink=GitHub
zh.WikiLink=文档
zh.RunGame=启动游戏
zh.VisitWiki=查看文档
en.PluginsTitle=Additional plugins
ru.PluginsTitle=Дополнительные плагины
zh.PluginsTitle=附加插件
en.PluginsDescription=Select optional plugins to install with BigCityLegacy.
ru.PluginsDescription=Выберите плагины для установки вместе с BigCityLegacy.
zh.PluginsDescription=选择要与 BigCityLegacy 一起安装的可选插件。
en.PluginsRepository=About the selected plugin
ru.PluginsRepository=О выбранном плагине
zh.PluginsRepository=关于所选插件
en.PluginsUnavailable=The plugin list could not be loaded. You can continue without additional plugins.
ru.PluginsUnavailable=Не удалось загрузить список плагинов. Можно продолжить без дополнительных плагинов.
zh.PluginsUnavailable=无法加载插件列表。您可以继续安装而不添加插件。
en.PluginsEmpty=No additional plugins are available.
ru.PluginsEmpty=Дополнительные плагины отсутствуют.
zh.PluginsEmpty=没有可用的附加插件。
en.PluginPrepare=Preparing selected plugins...
ru.PluginPrepare=Подготовка выбранных плагинов...
zh.PluginPrepare=正在准备所选插件...
en.PluginInstall=Installing selected plugins...
ru.PluginInstall=Установка выбранных плагинов...
zh.PluginInstall=正在安装所选插件...
en.PluginError=Could not prepare or install a selected plugin. See the setup log for details.
ru.PluginError=Не удалось подготовить или установить выбранный плагин. Подробности — в журнале установщика.
zh.PluginError=无法准备或安装所选插件。详情请查看安装日志。

[Run]

Filename: "{code:GetGameExePath}"; \
    Parameters: "{code:GetGameLaunchArgs}"; \
    WorkingDir: "{code:GetGameDirectory}"; \
    Description: "{cm:RunGame}"; \
    Flags: nowait postinstall skipifsilent; \
    Check: ShouldOfferPostInstallActions

Filename: "{code:GetGameExePath}"; \
    Parameters: "{code:GetGameLaunchArgs}"; \
    WorkingDir: "{code:GetGameDirectory}"; \
    Flags: nowait; \
    Check: ShouldRunGameInSilent

Filename: "{code:GetWikiUrl}"; \
    Description: "{cm:VisitWiki}"; \
    Flags: shellexec nowait postinstall skipifsilent unchecked; \
    Check: ShouldOfferPostInstallActions


[Code]

{ Folder selection uses an out-of-process native IFileDialog helper.
  Keeping COM out of Setup's process avoids both ABI/vtable hazards and
  Inno Setup custom-style hooks affecting the system dialog. }

var
  GameDir: String;

  GameDirPage: TInputDirWizardPage;
  LegalPage: TWizardPage;
  LegalViewer: TRichEditViewer;
  LegalAcceptCheck: TNewCheckBox;
  WelcomeBuildVersion: TLabel;
  WelcomeGitHubLink: TNewStaticText;
  WelcomeWikiLink: TNewStaticText;
#ifdef BCL_OFFLINE
  WelcomeCodebergLink: TNewStaticText;
#endif
#ifndef BCL_OFFLINE
  SourceLabel: TNewStaticText;
  SourceCombo: TNewComboBox;
  DataSource: String;
  ExplicitSource: Boolean;
#endif
  PluginsPage: TWizardPage;
  PluginsList: TNewCheckListBox;
#ifndef BCL_OFFLINE
  PluginRepoButton: TNewButton;
#endif
  PluginNames, PluginVersions, PluginRepos, PluginDownloads, PluginArchives, PluginKeyFiles: TStringList;
  PluginsLoaded: Boolean;
  ProgressPage: TOutputProgressWizardPage;
  PluginOutputError: Boolean;
  ModStageReady: Boolean;

  LegalDocumentLoaded: Boolean;

  ModArchive: String;
  ModStageDir: String;
  ModBackupArchive: String;

  ExistingBepInEx: Boolean;
  ExistingMod: Boolean;
  ModBackupCreated: Boolean;

  GameVersionIsSupported: Boolean;
  GameWasRunning: Boolean;

  InstallationSucceeded: Boolean;
  SelfDeleteRequested: Boolean;


// ============================================================================
// GENERAL HELPERS
// ============================================================================

function Q(const S: String): String;
begin
  Result := '"' + S + '"';
end;


function RelativePath(const S: String): String;
begin
  Result := AddBackslash(GameDir) + S;
end;


function RunCommand(
  const Exe,
  Params,
  WorkingDir: String;
  const WaitMode: TExecWait;
  var ExitCode: Integer): Boolean;
begin
  Result :=
    Exec(
      Exe,
      Params,
      WorkingDir,
      SW_HIDE,
      WaitMode,
      ExitCode
    );
end;


function Run7Zip(
  const Params: String;
  var ExitCode: Integer): Boolean;
begin
  Result :=
    RunCommand(
      ExpandConstant('{tmp}\7za.exe'),
      Params,
      GameDir,
      ewWaitUntilTerminated,
      ExitCode
    );
end;


function FileExistsRelative(const Path: String): Boolean;
begin
  Result := FileExists(RelativePath(Path));
end;


function DirExistsRelative(const Path: String): Boolean;
begin
  Result := DirExists(RelativePath(Path));
end;


function ReadTextFile(const Filename: String): String;
var
  Data: AnsiString;
begin
  Result := '';

  if LoadStringFromLockedFile(Filename, Data) then
    Result := String(Data);
end;


function GetGameExePath(Param: String): String;
begin
  Result := AddBackslash(GameDir) + '{#GameExe}';
end;


function GetGameLaunchArgs(Param: String): String;
begin
#ifdef BCL_OFFLINE
  Result := '';
#else
  Result := '';
  if ExplicitSource then Result := '-repositorySource:' + DataSource;
#endif
end;

function GetGameDirectory(Param: String): String;
begin
  Result := GameDir;
end;


function ShouldOfferPostInstallActions: Boolean;
begin
  Result := InstallationSucceeded and (GameDir <> '');
end;


function GetWikiUrl(Param: String): String;
begin
  if SameText(ActiveLanguage, 'zh') then
    Result := 'https://codeberg.org/LxgacyTeam/BigCityLegacy/src/branch/main/docs/README_ZH.md'
  else Result := 'https://github.com/LxgacyTeam/BigCityLegacy/wiki';
end;

#ifndef BCL_OFFLINE
function GetSelectedSource(Param: String): String;
begin
  Result := DataSource;
end;

function GetRepositoryUrl: String;
begin
  if SameText(DataSource, 'Codeberg') then
    Result := 'https://codeberg.org/LxgacyTeam/BigCityLegacy'
  else Result := '{#GitHubWebUrl}';
end;

function GetReleaseApiUrl: String;
begin
  if SameText(DataSource, 'Codeberg') then Result := '{#CodebergApiUrl}'
  else Result := '{#GitHubApiUrl}';
end;

procedure SourceChanged(Sender: TObject);
begin
  DataSource := SourceCombo.Items[SourceCombo.ItemIndex];
  ExplicitSource := True;
  PluginsLoaded := False;
  LegalDocumentLoaded := False;
  if LegalAcceptCheck <> nil then LegalAcceptCheck.Checked := False;
  WelcomeGitHubLink.Caption := DataSource;
end;

function SelectReleaseAsset(const JsonPath, AssetName: String): String;
var
  Output: TExecOutput;
  ExitCode, I: Integer;
begin
  Result := '';
  ExtractTemporaryFile('SelectReleaseAsset.ps1');
  if not ExecAndCaptureOutput(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'),
    '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ' +
    Q(ExpandConstant('{tmp}\SelectReleaseAsset.ps1')) + ' -ReleaseFile ' + Q(JsonPath) +
    ' -AssetName ' + Q(AssetName), ExpandConstant('{tmp}'), SW_HIDE,
    ewWaitUntilTerminated, ExitCode, Output) then Exit;
  if Output.Error or (ExitCode <> 0) then
  begin
    for I := 0 to GetArrayLength(Output.StdErr) - 1 do Log(Output.StdErr[I]);
    Exit;
  end;
  for I := 0 to GetArrayLength(Output.StdOut) - 1 do
    if Trim(Output.StdOut[I]) <> '' then Result := Trim(Output.StdOut[I]);
end;

#endif

procedure OpenGitHub(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec(
    '',
#ifdef BCL_OFFLINE
    'https://github.com/LxgacyTeam/BigCityLegacy',
#else
    GetRepositoryUrl,
#endif
    '',
    '',
    SW_SHOWNORMAL,
    ewNoWait,
    ErrorCode
  );
end;


#ifdef BCL_OFFLINE
procedure OpenCodeberg(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec('', 'https://codeberg.org/LxgacyTeam/BigCityLegacy', '', '',
    SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;
#endif

procedure OpenWiki(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec(
    '',
    GetWikiUrl(''),
    '',
    '',
    SW_SHOWNORMAL,
    ewNoWait,
    ErrorCode
  );
end;


function HasCommandLineSwitch(const SwitchName: String): Boolean;
var
  Cmd: String;
begin
  { The switches handled here do not take values. Padding the command line with
    spaces keeps /SKIPEULA from matching e.g. /SKIPEULAFOO. }
  Cmd := ' ' + UpperCase(GetCmdTail) + ' ';
  StringChangeEx(Cmd, #9, ' ', True);

  Result :=
    Pos(' /' + UpperCase(SwitchName) + ' ', Cmd) > 0;
end;


function ShouldSkipEula: Boolean;
begin
  Result := WizardSilent or HasCommandLineSwitch('SKIPEULA');
end;


function ShouldRunGameInSilent: Boolean;
begin
  Result :=
    WizardSilent and
    InstallationSucceeded and
    (GameDir <> '') and
    HasCommandLineSwitch('RUNGAME');
end;


#ifndef BCL_OFFLINE
function GetTermsRtfUrl: String;
var
  Name: String;
begin
  if SameText(ActiveLanguage, 'ru') then Name := 'NOTICE_RU.rtf' else if SameText(ActiveLanguage, 'zh') then Name := 'NOTICE_ZH.rtf' else Name := 'NOTICE.rtf';
  if SameText(DataSource, 'Codeberg') then
    Result := GetRepositoryUrl + '/raw/branch/main/docs/' + Name
  else Result := 'https://raw.githubusercontent.com/LxgacyTeam/BigCityLegacy/main/docs/' + Name;
end;

#endif

function EnsureLegalDocumentLoaded: Boolean;
var
  RtfPath: String;
  RtfData: AnsiString;
#ifndef BCL_OFFLINE
  RtfUrl: String;
#endif
begin
  { EULA is ignored for unattended installs and when /SKIPEULA is passed.
    In those cases, do not download the RTF or require acceptance. }
  if ShouldSkipEula then
  begin
    Result := True;
    Exit;
  end;

  Result := LegalDocumentLoaded;

  if Result then
    Exit;

  RtfPath := ExpandConstant('{tmp}\BigCityLegacy-terms-' + ActiveLanguage + '.rtf');
  DeleteFile(RtfPath);
#ifndef BCL_OFFLINE
  RtfUrl := GetTermsRtfUrl;
#endif

  try
#ifdef BCL_OFFLINE
    LegalViewer.Text := CustomMessage('LegalOffline');
#else
    LegalViewer.Text := CustomMessage('LegalDownload');
    Log('Downloading legal RTF for language ' + ActiveLanguage + ': ' + RtfUrl);
#endif

#ifdef BCL_OFFLINE
    if SameText(ActiveLanguage, 'ru') then
    begin
      ExtractTemporaryFile('NOTICE_RU.rtf');
      RtfPath := ExpandConstant('{tmp}\NOTICE_RU.rtf');
    end
    else if SameText(ActiveLanguage, 'zh') then
    begin
      ExtractTemporaryFile('NOTICE_ZH.rtf');
      RtfPath := ExpandConstant('{tmp}\NOTICE_ZH.rtf');
    end
    else
    begin
      ExtractTemporaryFile('NOTICE.rtf');
      RtfPath := ExpandConstant('{tmp}\NOTICE.rtf');
    end;
#else
    DownloadTemporaryFile(RtfUrl, 'BigCityLegacy-terms-' + ActiveLanguage + '.rtf', '', nil);
#endif

    if not FileExists(RtfPath) then
      RaiseException('Legal RTF file was not downloaded.');

    if not LoadStringFromFile(RtfPath, RtfData) then
      RaiseException('Legal RTF file could not be read.');

    if RtfData = '' then
      RaiseException('Legal RTF file is empty.');

    LegalViewer.RTFText := RtfData;
    LegalAcceptCheck.Enabled := True;
    LegalDocumentLoaded := True;
    Result := True;
  except
    Log('Could not download legal RTF: ' + GetExceptionMessage);
    LegalDocumentLoaded := False;
    LegalAcceptCheck.Enabled := False;
    Result := False;
  end;

  if not Result then
    LegalViewer.Text := CustomMessage('LegalDownloadError');
end;


function PrepareBundledTools: Boolean;
begin
  Result := False;

  try
    ExtractTemporaryFile('7za.exe');
    Result := FileExists(ExpandConstant('{tmp}\7za.exe'));
  except
    Log('Could not extract 7za.exe: ' + GetExceptionMessage);
  end;
end;


// ============================================================================
// CLI
// ============================================================================

function GetGameDirFromCommandLine: String;
begin
  Result :=
    ExpandConstant('{param:game|}');
end;


function IsDisposableMode: Boolean;
begin
  Result :=
    Pos(
      '/DISPOSABLE',
      UpperCase(GetCmdTail)
    ) > 0;
end;


// ============================================================================
// GAME VALIDATION
// ============================================================================

function ValidateGameDirectory: Boolean;
var
  GameExePath: String;
begin
  GameExePath :=
    AddBackslash(GameDir) + '{#GameExe}';

  Result := FileExists(GameExePath);

  if not Result then
  begin
    SuppressibleMsgBox(
      FmtMessage(
        CustomMessage('GameNotFound'), [GameExePath]
      ),
      mbError,
      MB_OK,
      0
    );
  end;
end;


function ValidateGameVersion: Boolean;
var
  GameExePath: String;
  ActualHash: String;
begin
  GameExePath :=
    AddBackslash(GameDir) + '{#GameExe}';

  ActualHash :=
    UpperCase(
      GetSHA256OfFile(GameExePath)
    );

  GameVersionIsSupported :=
    SameText(
      ActualHash,
      UpperCase('{#SupportedGameSHA256}')
    );

  Log('Game SHA256: ' + ActualHash);
  Log('Expected SHA256: ' + '{#SupportedGameSHA256}');

  Result := True;

  if not GameVersionIsSupported then
  begin
    Log('Game version does not match supported version.');

    if WizardSilent then
      Exit;

    if SuppressibleMsgBox(
      FmtMessage(
        CustomMessage('GameVersionWarning'), ['{#SupportedGameVersion}']
      ),
      mbInformation,
      MB_YESNO,
      IDNO
    ) <> IDYES then
    begin
      Result := False;
    end;
  end;
end;


// ============================================================================
// RUNNING GAME
// ============================================================================

function IsGameRunning: Boolean;
var
  ExitCode: Integer;
  Output: TExecOutput;
  I: Integer;
  GameExeUpper: String;
begin
  Result := False;

  GameExeUpper :=
    UpperCase('{#GameExe}');

  if not ExecAndCaptureOutput(
    ExpandConstant('{sys}\tasklist.exe'),
    '/FI "IMAGENAME eq {#GameExe}" /NH',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ExitCode,
    Output
  ) then
    Exit;

  if Output.Error then
    Exit;

  for I := 0 to GetArrayLength(Output.StdOut) - 1 do
  begin
    if Pos(
      GameExeUpper,
      UpperCase(Output.StdOut[I])
    ) > 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;


function KillAllGameInstances: Boolean;
var
  ExitCode: Integer;
begin
  Result := False;

  Log('Terminating all instances of {#GameExe}.');

  if not Exec(
    ExpandConstant('{sys}\taskkill.exe'),
    '/F /T /IM "{#GameExe}"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ExitCode
  ) then
    Exit;

  Sleep(1000);

  Result :=
    not IsGameRunning;
end;


function EnsureGameIsClosed: Boolean;
begin
  Result := True;

  GameWasRunning :=
    IsGameRunning;

  if not GameWasRunning then
    Exit;

  Log('Game is currently running.');

  if WizardSilent then
  begin
    { Automatic updater:
      forcibly close every game instance. }

    Result :=
      KillAllGameInstances;

    if not Result then
      Log('Could not terminate the game.');

    Exit;
  end;

  if SuppressibleMsgBox(
    FmtMessage(
      CustomMessage('GameRunning'), ['{#GameExe}']
    ),
    mbConfirmation,
    MB_YESNO,
    IDNO
  ) <> IDYES then
  begin
    Result := False;
    Exit;
  end;

  Result :=
    KillAllGameInstances;

  if not Result then
  begin
    MsgBox(
      'Could not close all game instances.',
      mbError,
      MB_OK
    );
  end;
end;


// ============================================================================
// BEPINEX
// ============================================================================

function ValidateBepInEx: Boolean;
begin
  Result :=
    FileExistsRelative('{#BIECore}') and
    FileExistsRelative('{#BIEConfig}') and
    FileExistsRelative('{#BIELog}') and
    FileExistsRelative('{#BIEDoorstop}') and
    FileExistsRelative('{#BIEWinHttp}');
end;


procedure StartPackageProgress;
begin
  ProgressPage.ProgressBar.Style := npbstNormal;
  ProgressPage.SetProgress(0, 1000);
end;

procedure StartPackageExtraction;
begin
  ProgressPage.ProgressBar.Style := npbstNormal;
#ifdef BCL_OFFLINE
  ProgressPage.SetProgress(0, 1000);
#else
  ProgressPage.SetProgress(500, 1000);
#endif
end;

#ifndef BCL_OFFLINE
function PackageDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
var
  DoneBytes, TotalBytes: Double;
begin
  if ProgressMax > 0 then
  begin
    ProgressPage.ProgressBar.Style := npbstNormal;
    DoneBytes := Progress;
    TotalBytes := ProgressMax;
    ProgressPage.SetProgress(Round((DoneBytes / TotalBytes) * 500), 1000);
  end
  else
  begin
    ProgressPage.SetProgress(0, 1000);
    ProgressPage.ProgressBar.Style := npbstMarquee;
  end;
  Result := not Terminated;
end;
#endif

function PackageExtractionProgress(const ArchiveName, FileName: String; const Progress, ProgressMax: Int64): Boolean;
var
  DoneBytes, TotalBytes: Double;
begin
  if ProgressMax > 0 then
  begin
    ProgressPage.ProgressBar.Style := npbstNormal;
    DoneBytes := Progress;
    TotalBytes := ProgressMax;
#ifdef BCL_OFFLINE
    ProgressPage.SetProgress(Round((DoneBytes / TotalBytes) * 1000), 1000);
#else
    ProgressPage.SetProgress(500 + Round((DoneBytes / TotalBytes) * 500), 1000);
#endif
  end;
  Result := not Terminated;
end;

function DownloadBepInEx: Boolean;
var
  ArchivePath: String;
#ifndef BCL_OFFLINE
  DownloadUrl: String;
#endif
begin
  Result := False;
  StartPackageProgress;

  ArchivePath :=
    ExpandConstant('{tmp}\BepInEx.zip');

  DeleteFile(ArchivePath);

  ProgressPage.SetText(
#ifdef BCL_OFFLINE
    CustomMessage('BepInExOffline'),
#else
    CustomMessage('BepInExDownload'),
#endif
    'BepInEx 5 x64'
  );

  try
#ifdef BCL_OFFLINE
    ExtractTemporaryFile('BepInEx.zip');
#else
    DownloadUrl := '{#BepInExUrl}';
    if SameText(DataSource, 'Codeberg') then
      DownloadUrl := '{#CodebergBepInExUrl}';
    DownloadTemporaryFile(DownloadUrl, 'BepInEx.zip', '', @PackageDownloadProgress);
#endif

    if not FileExists(ArchivePath) then
      RaiseException('BepInEx archive was not downloaded.');

    Result := True;

  except
    Log('BepInEx download failed: ' + GetExceptionMessage);
  end;
end;


function TestArchive(const ArchivePath: String): Boolean;
var
  ExitCode: Integer;
begin
  Result := False;

  if not FileExists(ArchivePath) then
    Exit;

  if not RunCommand(
    ExpandConstant('{tmp}\7za.exe'),
    't ' + Q(ArchivePath),
    ExpandConstant('{tmp}'),
    ewWaitUntilTerminated,
    ExitCode
  ) then
    Exit;

  Result := ExitCode = 0;

  if not Result then
    Log('7-Zip archive test failed: ' + ArchivePath);
end;


function ExtractBepInEx: Boolean;
var
  ArchivePath: String;
begin
  Result := False;
  ArchivePath := ExpandConstant('{tmp}\BepInEx.zip');
  ProgressPage.SetText(CustomMessage('BepInExInstall'), GameDir);
  StartPackageExtraction;
  if not TestArchive(ArchivePath) then Exit;
  try
    ExtractArchive(ArchivePath, GameDir, '', True, @PackageExtractionProgress);
    ProgressPage.SetProgress(1000, 1000);
    Result := True;
  except
    Log('BepInEx extraction failed: ' + GetExceptionMessage);
  end;
end;


function WaitForBepInExInitialization: Boolean;
var
  ElapsedMs: Integer;
  LogPath: String;
  ConfigPath: String;
  LogText: String;
  ResultCode: Integer;
begin
  Result := False;

  LogPath :=
    RelativePath('{#BIELog}');

  ConfigPath :=
    RelativePath('{#BIEConfig}');

  if FileExists(LogPath) then
    DeleteFile(LogPath);

  ProgressPage.SetText(
    CustomMessage('BepInExLaunch'),
    '{#GameExe}'
  );

  Log('Starting game for BepInEx initialization.');

  if not Exec(
    RelativePath('{#GameExe}'),
    '-batchmode -nographics',
    GameDir,
    SW_HIDE,
    ewNoWait,
    ResultCode
  ) then
  begin
    Log(
      'Could not start game: ' +
      SysErrorMessage(ResultCode)
    );
    Exit;
  end;

  ElapsedMs := 0;

  while ElapsedMs < {#FirstLaunchTimeoutMs} do
  begin
    if Terminated then
    begin
      Log('Setup was terminated while waiting for BepInEx.');
      Exit;
    end;

    if FileExists(LogPath) and
       FileExists(ConfigPath) then
    begin
      LogText :=
        ReadTextFile(LogPath);

      if LogText <> '' then
      begin
        Log('BepInEx initialization detected.');
        Result := True;
        Break;
      end;
    end;

    Sleep({#PollIntervalMs});
    ElapsedMs :=
      ElapsedMs + {#PollIntervalMs};
  end;

  if not Result then
    Log('Timed out waiting for BepInEx initialization.');

  Log('Closing all game instances after BepInEx initialization.');

  if not KillAllGameInstances then
    Log('Warning: game process could not be terminated.');

  Sleep(1000);
end;

function InstallBepInEx: Boolean;
begin
  Result := False;

  if not DownloadBepInEx then
    Exit;

  if not ExtractBepInEx then
    Exit;

  if not WaitForBepInExInitialization then
    Exit;

  ProgressPage.SetText(
    CustomMessage('BepInExValidation'),
    ''
  );

  Result :=
    ValidateBepInEx;
end;


// ============================================================================
// GITHUB
// ============================================================================

function DownloadLatestMod: Boolean;
#ifndef BCL_OFFLINE
var
  ApiFile, ModUrl: String;
#endif
begin
  Result := False;
  ModStageReady := False;
  StartPackageProgress;
#ifdef BCL_OFFLINE
  ProgressPage.SetText(CustomMessage('ModOffline'), '');
#else
  ProgressPage.SetText(CustomMessage('ModDownload'), DataSource);
#endif
  ModArchive := ExpandConstant('{tmp}\BigCityLegacy-latest.zip');
  DeleteFile(ModArchive);
  try
#ifdef BCL_OFFLINE
    ExtractTemporaryFile('BigCityLegacy-latest.zip');
#else
    ApiFile := ExpandConstant('{tmp}\repository-release.json');
    DeleteFile(ApiFile);
    DownloadTemporaryFile(GetReleaseApiUrl, 'repository-release.json', '', nil);
    ModUrl := SelectReleaseAsset(ApiFile, '');
    if ModUrl = '' then RaiseException('No unambiguous BigCityLegacy binary ZIP release asset found.');
    DownloadTemporaryFile(ModUrl, 'BigCityLegacy-latest.zip', '', @PackageDownloadProgress);
#endif
    Result := TestArchive(ModArchive);
  except
    Log('DownloadLatestMod failed: ' + GetExceptionMessage);
  end;
end;

// ============================================================================
// MOD VALIDATION
// ============================================================================

function ValidateMod: Boolean;
begin
  Result :=
    FileExistsRelative('{#ModDll1}') and
    FileExistsRelative('{#ModDll2}');
end;


// ============================================================================
// MOD BACKUP
// ============================================================================

function BackupExistingMod: Boolean;
var
  ExitCode: Integer;
  PluginDir: String;
begin
  Result := False;
  ModBackupCreated := False;

  PluginDir :=
    RelativePath('{#ModPluginDir}');

  if not DirExists(PluginDir) then
  begin
    Result := True;
    Exit;
  end;

  ModBackupArchive :=
    ExpandConstant('{tmp}\BigCityLegacy-mod-backup.7z');

  DeleteFile(ModBackupArchive);

  ProgressPage.SetText(
    CustomMessage('ModBackup'),
    '{#ModPluginDir}'
  );

  if not RunCommand(
    ExpandConstant('{tmp}\7za.exe'),
    'a -t7z ' +
    Q(ModBackupArchive) +
    ' ' +
    Q('{#ModPluginDir}'),
    GameDir,
    ewWaitUntilTerminated,
    ExitCode
  ) then
    Exit;

  if ExitCode <> 0 then
    Exit;

  ModBackupCreated := True;
  Result := True;
end;


function RemoveExistingMod: Boolean;
begin
  Result :=
    DelTree(
      RelativePath('{#ModPluginDir}'),
      True,
      True,
      True
    );
end;


function RestoreModBackup: Boolean;
var
  ExitCode: Integer;
begin
  Result := False;

  if not ModBackupCreated then
  begin
    Result := True;
    Exit;
  end;

  ProgressPage.SetText(
    CustomMessage('ModRollback'),
    ''
  );

  if not RunCommand(
    ExpandConstant('{tmp}\7za.exe'),
    'x ' +
    Q(ModBackupArchive) +
    ' -o' + Q(GameDir) +
    ' -y',
    GameDir,
    ewWaitUntilTerminated,
    ExitCode
  ) then
    Exit;

  Result :=
    ExitCode = 0;
end;


// ============================================================================
// MOD STAGING
// ============================================================================

function ExtractModToStage: Boolean;
begin
  Result := False;
  ModStageReady := False;
  ModStageDir := ExpandConstant('{tmp}\BigCityLegacy-ModStage');
  DelTree(ModStageDir, True, True, True);
  ForceDirectories(ModStageDir);
  ProgressPage.SetText(CustomMessage('ModInstall'), 'Preparing files');
  StartPackageExtraction;
  try
    ExtractArchive(ModArchive, ModStageDir, '', True, @PackageExtractionProgress);
    ModStageReady := True;
    ProgressPage.SetProgress(1000, 1000);
    Result := True;
  except
    Log('BCL extraction failed: ' + GetExceptionMessage);
  end;
end;

function PrepareLatestMod: Boolean;
begin
  Result := False;
  if not DownloadLatestMod then Exit;
  Result := ExtractModToStage;
end;


// ============================================================================
// CONFIG MERGE
// ============================================================================

function CopyConfigDirectory(
  const SourceDir,
  DestDir: String): Boolean;
var
  FindRec: TFindRec;
  SourcePath: String;
  DestPath: String;
begin
  Result := True;

  if not DirExists(SourceDir) then
    Exit;

  ForceDirectories(DestDir);

  if not FindFirst(
    AddBackslash(SourceDir) + '*',
    FindRec
  ) then
    Exit;

  try
    repeat

      if
        (FindRec.Name <> '.') and
        (FindRec.Name <> '..') then
      begin

        SourcePath :=
          AddBackslash(SourceDir) +
          FindRec.Name;

        DestPath :=
          AddBackslash(DestDir) +
          FindRec.Name;

        if
          (FindRec.Attributes and
           FILE_ATTRIBUTE_DIRECTORY) <> 0 then
        begin

          if not CopyConfigDirectory(
            SourcePath,
            DestPath
          ) then
          begin
            Result := False;
            Exit;
          end;

        end
        else
        begin

          { IMPORTANT:
            Never overwrite existing user configuration. }

          if not FileExists(DestPath) then
          begin
            if not CopyFile(
              SourcePath,
              DestPath,
              False
            ) then
            begin
              Result := False;
              Exit;
            end;
          end;

        end;
      end;

    until not FindNext(FindRec);

  finally
    FindClose(FindRec);
  end;
end;


function MergeModConfigs: Boolean;
var
  SourceConfigDir: String;
  DestConfigDir: String;
begin
  SourceConfigDir :=
    AddBackslash(ModStageDir) +
    '{#ModConfigDir}';

  DestConfigDir :=
    RelativePath('{#ModConfigDir}');

  Log('Merging config files.');
  Log('Source: ' + SourceConfigDir);
  Log('Destination: ' + DestConfigDir);

  Result :=
    CopyConfigDirectory(
      SourceConfigDir,
      DestConfigDir
    );
  { Legacy collections are migrated by the plugin first; do not mask custom events. }
  if Result and not FileExists(RelativePath('{#ModConfigDir}\Events.json')) and
    not FileExists(RelativePath('BigCityLegacy\Events.json')) and
    not FileExists(RelativePath('MadOutLegacy\Events.json')) then
    Result := CopyConfigDirectory(AddBackslash(ModStageDir) + 'BigCityLegacy\events',
      RelativePath('BigCityLegacy\events'));
end;


// ============================================================================
// INSTALL MOD
// ============================================================================

function InstallMod: Boolean;
var
  StagePluginDir: String;
  DestinationPluginDir: String;
begin
  Result := False;

  if not ModStageReady then
    if not ExtractModToStage then Exit;

  StagePluginDir :=
    AddBackslash(ModStageDir) +
    '{#ModPluginDir}';

  DestinationPluginDir :=
    RelativePath('{#ModPluginDir}');

  if not DirExists(StagePluginDir) then
  begin
    Log('Staged plugin directory does not exist.');
    Exit;
  end;

  { Plugin files are versioned files, so unlike configs they are
    intentionally replaced. }

  ForceDirectories(DestinationPluginDir);

  if not CopyFile(
    AddBackslash(StagePluginDir) +
      'BigCityLegacy.dll',
    AddBackslash(DestinationPluginDir) +
      'BigCityLegacy.dll',
    False
  ) then
    Exit;

  if not CopyFile(
    AddBackslash(StagePluginDir) +
      'LegacyUIFramework.dll',
    AddBackslash(DestinationPluginDir) +
      'LegacyUIFramework.dll',
    False
  ) then
    Exit;

  { Configs are merged separately and never overwrite user files. }

  if not MergeModConfigs then
    Exit;

  { Seed the Windows launcher without replacing a user's customized script.
    Linux launchers are intentionally not copied by the Windows installer. }
  if FileExists(AddBackslash(ModStageDir) + 'runServer.cmd') and
    not FileExists(RelativePath('runServer.cmd')) then
    if not CopyFile(AddBackslash(ModStageDir) + 'runServer.cmd', RelativePath('runServer.cmd'), True) then
    begin
      Log('Could not install runServer.cmd.');
      Exit;
    end;

  Result :=
    ValidateMod;
end;


// ============================================================================
// SELF DELETE
// ============================================================================

procedure ScheduleSelfDelete;
var
  SetupExe: String;
  ResultCode: Integer;
  Cmd: String;
begin
  SetupExe :=
    ExpandConstant('{srcexe}');

  { Wait for Setup to exit, then delete the executable. }

  Cmd :=
    '/C ping 127.0.0.1 -n 3 >nul & ' +
    'del /F /Q "' +
    SetupExe +
    '"';

  if not Exec(
    ExpandConstant('{cmd}'),
    Cmd,
    '',
    SW_HIDE,
    ewNoWait,
    ResultCode
  ) then
  begin
    Log('Could not schedule self-delete.');
  end;
end;


function FormatPluginSize(const BytesText: String): String;
var
  Bytes: Int64;
  Value: Double;
  UnitIndex: Integer;
  Units: String;
begin
  Result := '';
  if BytesText = '' then Exit;
  Bytes := StrToInt64(BytesText);
  if Bytes < 0 then Exit;
  if Bytes < 1024 then
  begin
    Result := BytesText + ' B';
    Exit;
  end;
  Value := Bytes;
  UnitIndex := 0;
  while (Value >= 1024) and (UnitIndex < 6) do
  begin
    Value := Value / 1024;
    UnitIndex := UnitIndex + 1;
  end;
  case UnitIndex of
    1: Units := 'KiB';
    2: Units := 'MiB';
    3: Units := 'GiB';
    4: Units := 'TiB';
    5: Units := 'PiB';
    6: Units := 'EiB';
  end;
  Result := Format('%.2f %s', [Value, Units]);
end;

procedure AddPlugin(const Name, Version, RepoUrl, DownloadUrl, Archive, KeyFiles, SizeBytes: String; Installed, DefaultChecked: Boolean);
var
  Caption: String;
  Checked: Boolean;
begin
  PluginNames.Add(Name);
  PluginVersions.Add(Version);
  PluginRepos.Add(RepoUrl);
  PluginDownloads.Add(DownloadUrl);
  PluginArchives.Add(Archive);
  PluginKeyFiles.Add(KeyFiles);
  Caption := Name;
  if Version <> '' then Caption := Caption + ' ' + Version;
  if WizardSilent then
    Checked := Installed and not HasCommandLineSwitch('NOEXTRAUPDATE')
  else
    Checked := DefaultChecked;
  PluginsList.AddCheckBox(Caption, FormatPluginSize(SizeBytes), 0,
    Checked, True, False, False, nil);
  if WizardSilent and Installed and not HasCommandLineSwitch('NOEXTRAUPDATE') then
    Log('Selected installed plugin for automatic update: ' + Name);
end;

#ifndef BCL_OFFLINE
procedure PluginSelectionChanged(Sender: TObject);
begin
  PluginRepoButton.Enabled := PluginsList.ItemIndex >= 0;
end;

procedure OpenPluginRepository(Sender: TObject);
var
  ErrorCode, Index: Integer;
begin
  Index := PluginsList.ItemIndex;
  if (Index >= 0) and (Index < PluginRepos.Count) then
    ShellExec('', PluginRepos[Index], '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;
#endif

procedure EnsurePluginsLoaded;
#ifndef BCL_OFFLINE
var
  Url, Manifest, OutputFile, CatalogError: String;
  Lines: TArrayOfString;
  Output: TExecOutput;
  ExitCode, I: Integer;
#endif
begin
  if PluginsLoaded then Exit;
  PluginsList.Items.Clear;
  PluginNames.Clear;
  PluginVersions.Clear;
  PluginRepos.Clear;
  PluginDownloads.Clear;
  PluginArchives.Clear;
  PluginKeyFiles.Clear;
#ifndef BCL_OFFLINE
  PluginRepoButton.Enabled := False;
#endif
  try
#ifdef BCL_OFFLINE
  #define OfflineIndex 0
  #sub ListOfflinePlugin
    #define OfflineName FindGetFileName(OfflineHandle)
    #if Pos("'", OfflineName) > 0
      #error Offline plugin filenames must not contain apostrophes.
    #endif
    #emit "    AddPlugin('" + RemoveFileExt(OfflineName) + "', '', '', '', 'BCL-plugin-" + Str(OfflineIndex) + ".zip', '', '', False, False);"
    #expr OfflineIndex++
  #endsub
  #for {OfflineHandle = OfflineFound = FindFirst(SourcePath + "offline_plugins\\*.zip", 0); OfflineFound; OfflineFound = FindNext(OfflineHandle)} ListOfflinePlugin
  #if OfflineHandle
    #call FindClose(OfflineHandle)
  #endif
#else
    if SameText(DataSource, 'Codeberg') then Url := GetRepositoryUrl + '/raw/branch/main/remote_config/PluginsList.json'
    else Url := 'https://raw.githubusercontent.com/LxgacyTeam/BigCityLegacy/main/remote_config/PluginsList.json';
    Manifest := ExpandConstant('{tmp}\BCL-PluginsList.json');
    OutputFile := ExpandConstant('{tmp}\BCL-PluginsList.txt');
    DeleteFile(Manifest);
    DeleteFile(OutputFile);
    DownloadTemporaryFile(Url, 'BCL-PluginsList.json', '', nil);
    ExtractTemporaryFile('ReadPluginsList.ps1');
    ExtractTemporaryFile('PluginKeyFiles.ps1');
    if not ExecAndCaptureOutput(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'),
      '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ' + Q(ExpandConstant('{tmp}\ReadPluginsList.ps1')) +
      ' -Manifest ' + Q(Manifest) + ' -Source ' + Q(DataSource) + ' -OutputFile ' + Q(OutputFile) + ' -GameDirectory ' + Q(GameDir),
      ExpandConstant('{tmp}'), SW_HIDE, ewWaitUntilTerminated, ExitCode, Output) then RaiseException('Cannot read plugin catalog.');
    if Output.Error or (ExitCode <> 0) then
    begin
      CatalogError := '';
      for I := 0 to GetArrayLength(Output.StdErr) - 1 do
      begin
        Log(Output.StdErr[I]);
        if (CatalogError = '') and (Trim(Output.StdErr[I]) <> '') then
          CatalogError := Trim(Output.StdErr[I]);
      end;
      RaiseException('Invalid plugin catalog. ' + CatalogError);
    end;
    if not LoadStringsFromFile(OutputFile, Lines) then RaiseException('Cannot read parsed plugin catalog.');
    if (GetArrayLength(Lines) mod 8) <> 0 then RaiseException('Incomplete plugin catalog.');
    I := 0;
    while I < GetArrayLength(Lines) do
    begin
      AddPlugin(Lines[I], Lines[I + 1], Lines[I + 2], Lines[I + 3], 'BCL-plugin-' + IntToStr(I div 8) + '.zip', Lines[I + 4], Lines[I + 5], Lines[I + 7] = '1', Lines[I + 6] = '1');
      I := I + 8;
    end;
#endif
    PluginsLoaded := True;
  except
    PluginsLoaded := True;
    Log('Plugin catalog failed: ' + GetExceptionMessage);
    PluginsList.Items.Clear;
    PluginNames.Clear;
    PluginVersions.Clear;
    PluginRepos.Clear;
    PluginDownloads.Clear;
    PluginArchives.Clear;
    PluginKeyFiles.Clear;
  end;
end;

procedure LoadPluginsForInstallation;
begin
#ifndef BCL_OFFLINE
  { Older BCL releases already invoke /SILENT without a plugin-update switch. }
  if WizardSilent and not HasCommandLineSwitch('NOEXTRAUPDATE') then
    EnsurePluginsLoaded;
#endif
end;

#ifndef BCL_OFFLINE
function PluginDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
var
  DoneBytes, TotalBytes: Double;
begin
  if ProgressMax > 0 then
  begin
    ProgressPage.ProgressBar.Style := npbstNormal;
    DoneBytes := Progress;
    TotalBytes := ProgressMax;
    ProgressPage.SetProgress(Round((DoneBytes / TotalBytes) * 1000), 1000);
  end
  else
  begin
    ProgressPage.SetProgress(0, 1000);
    ProgressPage.ProgressBar.Style := npbstMarquee;
  end;
  Result := True;
end;
#endif

procedure PluginInstallProgress(const S: String; const Error, FirstLine: Boolean);
var
  Value: Integer;
begin
  if Error then PluginOutputError := True;
  if not Error and (Pos('BCLPLUGINPROGRESS:', S) = 1) then
  begin
    Value := StrToIntDef(Copy(S, 19, Length(S)), -1);
    if (Value >= 0) and (Value <= 1000) then ProgressPage.SetProgress(Value, 1000);
  end
  else
    Log('Plugin: ' + S);
end;

function ProcessPlugin(const ArchivePath, KeyFiles: String; ValidateOnly: Boolean): Boolean;
var
  Params: String;
  ExitCode: Integer;
begin
  ExtractTemporaryFile('InstallPlugin.ps1');
  ExtractTemporaryFile('PluginKeyFiles.ps1');
  Params := '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ' +
    Q(ExpandConstant('{tmp}\InstallPlugin.ps1')) + ' -Archive ' + Q(ArchivePath) + ' -GameDirectory ' + Q(GameDir);
  if ValidateOnly then Params := Params + ' -ValidateOnly'
  else Params := Params + ' -ReportProgress';
  if KeyFiles <> '' then Params := Params + ' -KeyFiles ' + Q(KeyFiles);
  PluginOutputError := False;
  Result := ExecAndLogOutput(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'), Params,
    ExpandConstant('{tmp}'), SW_HIDE, ewWaitUntilTerminated, ExitCode, @PluginInstallProgress);
  if Result then Result := not PluginOutputError and (ExitCode = 0);
  if Result and not ValidateOnly then ProgressPage.SetProgress(1000, 1000);
end;

function PrepareSelectedPlugins: Boolean;
var
  I: Integer;
  ArchivePath: String;
begin
  Result := False;
  try
    for I := 0 to PluginNames.Count - 1 do
      if PluginsList.Checked[I] then
      begin
        ProgressPage.SetText(CustomMessage('PluginPrepare'), PluginNames[I]);
        ProgressPage.ProgressBar.Style := npbstNormal;
        ProgressPage.SetProgress(0, 1000);
        ArchivePath := ExpandConstant('{tmp}\') + PluginArchives[I];
        DeleteFile(ArchivePath);
#ifdef BCL_OFFLINE
        ExtractTemporaryFile(PluginArchives[I]);
#else
        ProgressPage.SetText(CustomMessage('PluginDownload'), PluginNames[I]);
        DownloadTemporaryFile(PluginDownloads[I], PluginArchives[I], '', @PluginDownloadProgress);
#endif
        ProgressPage.SetText(CustomMessage('PluginValidate'), PluginNames[I]);
        ProgressPage.SetProgress(0, 1000);
        ProgressPage.ProgressBar.Style := npbstMarquee;
        if not TestArchive(ArchivePath) or not ProcessPlugin(ArchivePath, PluginKeyFiles[I], True) then
          RaiseException('Invalid plugin archive: ' + PluginNames[I]);
      end;
    Result := True;
  except
    Log('PrepareSelectedPlugins failed: ' + GetExceptionMessage);
  end;
  ProgressPage.ProgressBar.Style := npbstNormal;
  ProgressPage.SetProgress(0, 1000);
end;

function InstallSelectedPlugins: Boolean;
var
  I: Integer;
begin
  Result := False;
  try
    for I := 0 to PluginNames.Count - 1 do
      if PluginsList.Checked[I] then
      begin
        ProgressPage.SetText(CustomMessage('PluginInstall'), PluginNames[I]);
        ProgressPage.ProgressBar.Style := npbstNormal;
        ProgressPage.SetProgress(0, 1000);
        if not ProcessPlugin(ExpandConstant('{tmp}\') + PluginArchives[I], PluginKeyFiles[I], False) then
          RaiseException('Cannot install plugin: ' + PluginNames[I]);
      end;
    Result := True;
  except
    Log('InstallSelectedPlugins failed: ' + GetExceptionMessage);
  end;
end;


// ============================================================================
// MAIN INSTALLATION
// ============================================================================

function PerformInstallation: Boolean;
begin
  Result := False;

  ProgressPage :=
    CreateOutputProgressPage(
      '{#MyAppName}',
      ''
    );

  ProgressPage.Show;

  try

    ProgressPage.SetText(
      CustomMessage('GameDirectory'),
      GameDir
    );

    if not PrepareBundledTools then
    begin
      MsgBox(
        'Could not extract the bundled 7-Zip executable.',
        mbError,
        MB_OK
      );
      Exit;
    end;

    if not ValidateGameDirectory then
      Exit;

    if not ValidateGameVersion then
      Exit;

    if not EnsureGameIsClosed then
      Exit;

    ExistingBepInEx :=
      ValidateBepInEx;

    ExistingMod :=
      ValidateMod;

    Log(
      'Existing BepInEx: ' +
      IntToStr(Integer(ExistingBepInEx))
    );

    Log(
      'Existing mod: ' +
      IntToStr(Integer(ExistingMod))
    );

    if not ExistingBepInEx then
    begin
      if not InstallBepInEx then
      begin
        MsgBox(
          CustomMessage('BepInExInitError'),
          mbError,
          MB_OK
        );

        Exit;
      end;

      if not ValidateBepInEx then
      begin
        MsgBox(
          CustomMessage('BepInExError'),
          mbError,
          MB_OK
        );

        Exit;
      end;
    end;

    if not PrepareLatestMod then
    begin
      MsgBox(
        CustomMessage('GitHubError'),
        mbError,
        MB_OK
      );

      Exit;
    end;

    LoadPluginsForInstallation;
    if not PrepareSelectedPlugins then
    begin
      SuppressibleMsgBox(CustomMessage('PluginError'), mbError, MB_OK, 0);
      Exit;
    end;

    if ExistingMod then
    begin
      if not BackupExistingMod then
      begin
        MsgBox(
          'Could not create a backup of the existing mod.',
          mbError,
          MB_OK
        );

        Exit;
      end;

      if not RemoveExistingMod then
      begin
        RestoreModBackup;

        MsgBox(
          'Could not remove the existing mod.',
          mbError,
          MB_OK
        );

        Exit;
      end;
    end;

    if not InstallMod then
    begin
      Log('New mod installation failed.');

      if ExistingMod then
      begin
        if not RestoreModBackup then
        begin
          MsgBox(
            'The new mod could not be installed and the previous ' +
            'version could not be restored.',
            mbError,
            MB_OK
          );
        end
        else
        begin
          MsgBox(
            'The new mod could not be installed.'#13#13 +
            'The previous version has been restored.',
            mbError,
            MB_OK
          );
        end;
      end
      else
      begin
        MsgBox(
          CustomMessage('ModError'),
          mbError,
          MB_OK
        );
      end;

      Exit;
    end;

    ProgressPage.SetText(
      CustomMessage('ModValidation'),
      ''
    );

    if not ValidateBepInEx then
    begin
      MsgBox(
        CustomMessage('BepInExError'),
        mbError,
        MB_OK
      );

      Exit;
    end;

    if not ValidateMod then
    begin
      if ExistingMod then
        RestoreModBackup;

      MsgBox(
        CustomMessage('ModError'),
        mbError,
        MB_OK
      );

      Exit;
    end;

    if not InstallSelectedPlugins then
    begin
      SuppressibleMsgBox(CustomMessage('PluginError'), mbError, MB_OK, 0);
      Exit;
    end;
    InstallationSucceeded := True;

    Result := True;

  finally

    ProgressPage.Hide;

  end;
end;


// ============================================================================
// MODERN FOLDER PICKER (native IFileDialog in a separate process)
// ============================================================================

function SelectFolderWithIFileDialog(var Directory: String): Boolean;
var
  ScriptPath: String;
  PowerShellPath: String;
  Params: String;
  ExitCode: Integer;
  Output: TExecOutput;
  I: Integer;
  Line: String;
  ResultPath: String;
  Selected: TArrayOfString;
begin
  Result := False;

  try
    ExtractTemporaryFile('FolderPicker.ps1');

    ScriptPath := ExpandConstant('{tmp}\FolderPicker.ps1');
    if not FileExists(ScriptPath) then
    begin
      Log('FolderPicker.ps1 was not extracted.');
      Exit;
    end;

    PowerShellPath :=
      ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe');

    if not FileExists(PowerShellPath) then
    begin
      Log('Windows PowerShell was not found: ' + PowerShellPath);
      Exit;
    end;

    ResultPath := ExpandConstant('{tmp}\BCL-SelectedFolder.txt');
    DeleteFile(ResultPath);
    Params :=
      '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ' +
      Q(ScriptPath);
    if Directory <> '' then Params := Params + ' -InitialDirectory ' + Q(Directory);
    Params := Params +
      ' -Title ' + Q(CustomMessage('SelectGameDirectory')) +
      ' -OutputFile ' + Q(ResultPath) +
      ' -OkButtonText ' + Q(CustomMessage('SelectFolderButton')) +
      ' -AllFilesText ' + Q(CustomMessage('AllFilesFilter')) +
      ' -GameFileName ' + Q('{#GameExe}');

    Log('Starting out-of-process native folder picker.');

    if not ExecAndCaptureOutput(
      PowerShellPath,
      Params,
      ExpandConstant('{tmp}'),
      SW_HIDE,
      ewWaitUntilTerminated,
      ExitCode,
      Output
    ) then
    begin
      Log('Could not start FolderPicker helper.');
      Exit;
    end;

    if Output.Error then
    begin
      Log('FolderPicker helper output capture failed.');
      Exit;
    end;

    if ExitCode <> 0 then
    begin
      { Exit code 1 means the user cancelled the dialog. Other non-zero
        values are helper failures; stderr is written to the Setup log. }
      if ExitCode <> 1 then
      begin
        Log('FolderPicker helper failed with exit code ' + IntToStr(ExitCode));
        for I := 0 to GetArrayLength(Output.StdErr) - 1 do
          if Output.StdErr[I] <> '' then
            Log('FolderPicker: ' + Output.StdErr[I]);
      end;
      Exit;
    end;

    { UTF-8 BOM avoids the PowerShell/OEM stdout code-page conversion. }
    if not LoadStringsFromFile(ResultPath, Selected) then Exit;
    if GetArrayLength(Selected) <> 1 then Exit;
    Line := Selected[0];
    if not DirExists(Line) then Exit;
    Directory := Line;
    Result := True;
  except
    Log('Native folder picker failed: ' + GetExceptionMessage);
  end;
end;


procedure GameDirBrowseButtonClick(Sender: TObject);
var
  Directory: String;
begin
  Directory := GameDirPage.Values[0];

  if SelectFolderWithIFileDialog(Directory) then
    GameDirPage.Values[0] := Directory;
end;


// ============================================================================
// WIZARD
// ============================================================================

procedure InitializeWizard;
begin
  LegalDocumentLoaded := False;

  WelcomeBuildVersion := TLabel.Create(WizardForm);
  WelcomeBuildVersion.Parent := WizardForm.WelcomePage;
  WelcomeBuildVersion.Caption := CustomMessage('BuildVersion') + ' {#BuildTimestamp}';
  WelcomeBuildVersion.AutoSize := True;
  WelcomeBuildVersion.Transparent := True;
  WelcomeBuildVersion.Font.Size := 8;
  WelcomeBuildVersion.Font.Color := clWhite;
  WelcomeBuildVersion.Left := ScaleX(8);
  WelcomeBuildVersion.Top := WizardForm.WelcomePage.ClientHeight - WelcomeBuildVersion.Height - ScaleY(8);
  WelcomeBuildVersion.Anchors := [akLeft, akBottom];

  { Classic-style first page: the standard Welcome page keeps the large
    wizard image on the left. The branding placeholders are in [Setup]. }

#ifndef BCL_OFFLINE
  if not ExplicitSource then
  begin
    if SameText(ActiveLanguage, 'zh') then DataSource := 'Codeberg' else DataSource := 'GitHub';
  end;
#endif
  WelcomeGitHubLink := TNewStaticText.Create(WizardForm);
  WelcomeGitHubLink.Parent := WizardForm.WelcomePage;
#ifdef BCL_OFFLINE
  WelcomeGitHubLink.Caption := 'GitHub';
#else
  WelcomeGitHubLink.Caption := DataSource;
#endif
  WelcomeGitHubLink.AutoSize := True;
  WelcomeGitHubLink.Font.Style := [fsUnderline];
  WelcomeGitHubLink.Cursor := crHand;
  WelcomeGitHubLink.Left := WizardForm.WelcomeLabel2.Left;
#ifdef BCL_OFFLINE
  WelcomeGitHubLink.Top := WizardForm.WelcomePage.ClientHeight - ScaleY(80);
#else
  WelcomeGitHubLink.Top := WizardForm.WelcomePage.ClientHeight - ScaleY(112);
#endif
  WelcomeGitHubLink.Anchors := [akLeft, akBottom];
  WelcomeGitHubLink.OnClick := @OpenGitHub;

#ifdef BCL_OFFLINE
  WelcomeCodebergLink := TNewStaticText.Create(WizardForm);
  WelcomeCodebergLink.Parent := WizardForm.WelcomePage;
  WelcomeCodebergLink.Caption := 'Codeberg';
  WelcomeCodebergLink.AutoSize := True;
  WelcomeCodebergLink.Font.Style := [fsUnderline];
  WelcomeCodebergLink.Cursor := crHand;
  WelcomeCodebergLink.Left := WelcomeGitHubLink.Left;
  WelcomeCodebergLink.Top := WelcomeGitHubLink.Top + ScaleY(24);
  WelcomeCodebergLink.Anchors := [akLeft, akBottom];
  WelcomeCodebergLink.OnClick := @OpenCodeberg;
#endif

  WelcomeWikiLink := TNewStaticText.Create(WizardForm);
  WelcomeWikiLink.Parent := WizardForm.WelcomePage;
  WelcomeWikiLink.Caption := CustomMessage('WikiLink');
  WelcomeWikiLink.AutoSize := True;
  WelcomeWikiLink.Font.Style := [fsUnderline];
  WelcomeWikiLink.Cursor := crHand;
  WelcomeWikiLink.Left := WelcomeGitHubLink.Left;
#ifdef BCL_OFFLINE
  WelcomeWikiLink.Top := WelcomeCodebergLink.Top + ScaleY(24);
#else
  WelcomeWikiLink.Top := WelcomeGitHubLink.Top + ScaleY(24);
#endif
  WelcomeWikiLink.Anchors := [akLeft, akBottom];
  WelcomeWikiLink.OnClick := @OpenWiki;

#ifndef BCL_OFFLINE
  SourceLabel := TNewStaticText.Create(WizardForm);
  SourceLabel.Parent := WizardForm.WelcomePage;
  SourceLabel.Left := WizardForm.WelcomeLabel2.Left;
  SourceLabel.Top := WelcomeWikiLink.Top + ScaleY(24);
  SourceLabel.Caption := CustomMessage('DataSource');
  SourceLabel.AutoSize := True;
  SourceLabel.Anchors := [akLeft, akBottom];
  SourceCombo := TNewComboBox.Create(WizardForm);
  SourceCombo.Parent := WizardForm.WelcomePage;
  SourceCombo.Left := SourceLabel.Left;
  SourceCombo.Top := SourceLabel.Top + ScaleY(22);
  SourceCombo.Width := ScaleX(210);
  SourceCombo.Anchors := [akLeft, akBottom];
  SourceCombo.Style := csDropDownList;
  SourceCombo.Items.Add('GitHub');
  SourceCombo.Items.Add('Codeberg');
  if SameText(DataSource, 'Codeberg') then SourceCombo.ItemIndex := 1 else SourceCombo.ItemIndex := 0;
  SourceCombo.OnChange := @SourceChanged;
#endif

  WizardForm.WelcomeLabel2.Height := WelcomeGitHubLink.Top - WizardForm.WelcomeLabel2.Top - ScaleY(12);

  LegalPage :=
    CreateCustomPage(
      wpWelcome,
      CustomMessage('LegalTitle'),
      CustomMessage('LegalDescription')
    );

  LegalViewer := TRichEditViewer.Create(LegalPage);
  LegalViewer.Parent := LegalPage.Surface;
  LegalViewer.Left := 0;
  LegalViewer.Top := 0;
  LegalViewer.Width := LegalPage.SurfaceWidth;
  LegalViewer.Height := LegalPage.SurfaceHeight - ScaleY(40);
  LegalViewer.Anchors := [akLeft, akTop, akRight, akBottom];
  LegalViewer.ReadOnly := True;
  LegalViewer.ScrollBars := ssVertical;
  LegalViewer.UseRichEdit := True;

  LegalAcceptCheck := TNewCheckBox.Create(LegalPage);
  LegalAcceptCheck.Parent := LegalPage.Surface;
  LegalAcceptCheck.Left := 0;
  LegalAcceptCheck.Top := LegalPage.SurfaceHeight - ScaleY(28);
  LegalAcceptCheck.Width := LegalPage.SurfaceWidth;
  LegalAcceptCheck.Anchors := [akLeft, akRight, akBottom];
  LegalAcceptCheck.Caption := CustomMessage('LegalAccept');
  LegalAcceptCheck.Checked := False;
  LegalAcceptCheck.Enabled := False;

  GameDirPage :=
    CreateInputDirPage(
      LegalPage.ID,
      CustomMessage('GameDirectory'),
      CustomMessage('SelectGameDirectory'),
      FmtMessage(
        CustomMessage('GameDirectoryDescription'), ['{#GameExe}']
      ),
      False,
      ''
    );

  GameDirPage.Add(
    CustomMessage('GameDirectory')
  );

  { Replace Inno Setup's built-in directory browser with the native
    Windows Vista+ IFileDialog folder picker. }
  GameDirPage.Buttons[0].OnClick := @GameDirBrowseButtonClick;

  if GameDir <> '' then
    GameDirPage.Values[0] := GameDir
  else
    GameDirPage.Values[0] := '';
  PluginNames := TStringList.Create;
  PluginVersions := TStringList.Create;
  PluginRepos := TStringList.Create;
  PluginDownloads := TStringList.Create;
  PluginArchives := TStringList.Create;
  PluginKeyFiles := TStringList.Create;
  PluginsPage := CreateCustomPage(GameDirPage.ID, CustomMessage('PluginsTitle'), CustomMessage('PluginsDescription'));
  PluginsList := TNewCheckListBox.Create(PluginsPage);
  PluginsList.Parent := PluginsPage.Surface;
#ifdef BCL_OFFLINE
  PluginsList.SetBounds(0, 0, PluginsPage.SurfaceWidth, PluginsPage.SurfaceHeight);
#else
  PluginsList.SetBounds(0, 0, PluginsPage.SurfaceWidth, PluginsPage.SurfaceHeight - ScaleY(40));
#endif
  PluginsList.Anchors := [akLeft, akTop, akRight, akBottom];
#ifndef BCL_OFFLINE
  PluginRepoButton := TNewButton.Create(PluginsPage);
  PluginRepoButton.Parent := PluginsPage.Surface;
  PluginRepoButton.SetBounds(PluginsPage.SurfaceWidth - ScaleX(180), PluginsPage.SurfaceHeight - ScaleY(30), ScaleX(180), ScaleY(20));
  PluginRepoButton.Anchors := [akRight, akBottom];
  PluginRepoButton.Caption := CustomMessage('PluginsRepository');
  PluginRepoButton.OnClick := @OpenPluginRepository;
  PluginRepoButton.Enabled := False;
  PluginsList.OnClick := @PluginSelectionChanged;
#endif
end;


procedure CurPageChanged(CurPageID: Integer);
begin
  if (CurPageID = PluginsPage.ID) and not WizardSilent then EnsurePluginsLoaded;
  if ShouldSkipEula then
    Exit;

  if CurPageID = LegalPage.ID then
  begin
    if not EnsureLegalDocumentLoaded then
      SuppressibleMsgBox(
        CustomMessage('LegalDownloadError'),
        mbError,
        MB_OK,
        0
      );
  end;
end;


function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := ShouldSkipEula and (PageID = LegalPage.ID);
  if PageID = PluginsPage.ID then
  begin
    if WizardSilent then Result := True
    else
    begin
      { Inspect the catalog before navigation so an empty page is never shown. }
      EnsurePluginsLoaded;
      Result := PluginNames.Count = 0;
    end;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  if (not ShouldSkipEula) and (CurPageID = LegalPage.ID) then
  begin
    if not LegalDocumentLoaded then
    begin
      if not EnsureLegalDocumentLoaded then
      begin
        SuppressibleMsgBox(
          CustomMessage('LegalDownloadError'),
          mbError,
          MB_OK,
          0
        );
        Result := False;
        Exit;
      end;
    end;

    if not LegalAcceptCheck.Checked then
    begin
      SuppressibleMsgBox(
        CustomMessage('LegalAcceptRequired'),
        mbInformation,
        MB_OK,
        0
      );
      Result := False;
      Exit;
    end;
  end;

  if CurPageID = GameDirPage.ID then
  begin

    GameDir :=
      RemoveBackslashUnlessRoot(
        GameDirPage.Values[0]
      );

    if not ValidateGameDirectory then
    begin
      Result := False;
      Exit;
    end;

  end;
end;


function InitializeSetup: Boolean;
begin
#ifndef BCL_OFFLINE
  DataSource := ExpandConstant('{param:SOURCE|GitHub}');
  ExplicitSource := ExpandConstant('{param:SOURCE|}') <> '';
  if SameText(DataSource, 'GitHub') then DataSource := 'GitHub'
  else if SameText(DataSource, 'Codeberg') then DataSource := 'Codeberg'
  else
  begin
    MsgBox('Invalid /SOURCE. Use GitHub or Codeberg.', mbError, MB_OK);
    Result := False;
    Exit;
  end;
#endif
  InstallationSucceeded := False;
  SelfDeleteRequested := IsDisposableMode;
  if GetGameDirFromCommandLine <> '' then
  begin
    GameDir := RemoveBackslashUnlessRoot(GetGameDirFromCommandLine);
    Result := ValidateGameDirectory;
    Exit;
  end;
  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin

  if CurStep = ssInstall then
  begin

    if not PerformInstallation then
      Abort;
  end;

end;


procedure DeinitializeSetup;
begin

  if
    InstallationSucceeded and
    SelfDeleteRequested then
  begin
    ScheduleSelfDelete;
  end;

end;
