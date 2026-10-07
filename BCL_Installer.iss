; ============================================================================
; BigCityLegacy Installer / Updater
; by LegacyTeam
;
; for Inno Setup 7.x
; ============================================================================

#define MyAppName "BigCityLegacy"

#define GameExe "game.exe"
#define SupportedGameVersion "9.4"

#define SupportedGameSHA256 "8C71E536AB169656AEAE13CCC0D1DD989516CD4648B1D14DB9B99D55430F15C0"

#define GitHubApiUrl "https://api.github.com/repos/LxgacyTeam/BigCityLegacy/releases/latest"
#define GitHubWebUrl "https://github.com/LxgacyTeam/BigCityLegacy"
#define WikiUrl "https://github.com/LxgacyTeam/BigCityLegacy/wiki"

#define TermsRtfUrlEn "https://github.com/LxgacyTeam/BigCityLegacy/raw/refs/heads/main/docs/NOTICE.rtf"
#define TermsRtfUrlRu "https://github.com/LxgacyTeam/BigCityLegacy/raw/refs/heads/main/docs/NOTICE_RU.rtf"
#define BepInExUrl "https://github.com/BepInEx/BepInEx/releases/download/v5.4.23.5/BepInEx_win_x64_5.4.23.5.zip"

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
AppVersion=1.0
AppPublisher=LegacyTeam

OutputBaseFilename=BigCityLegacyInstaller
Compression=zip
SolidCompression=yes

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

[Languages]

Name: "en"; \
    MessagesFile: "compiler:Default.isl"

Name: "ru"; \
    MessagesFile: "compiler:Languages\Russian.isl"

[CustomMessages]

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
en.ModInstall=Installing the latest BigCityLegacy version...
en.ModValidation=Verifying BigCityLegacy installation...

en.ModBackup=Backing up the existing BigCityLegacy version...
en.ModRollback=Restoring the previous BigCityLegacy version...

en.GitHubError=Could not obtain the latest BigCityLegacy release from GitHub.
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
en.LegalDownloadError=The terms of use and legal provisions could not be downloaded from GitHub. Check your Internet connection and the language-specific TermsRtfUrl setting.
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
ru.ModInstall=Установка BigCityLegacy...
ru.ModValidation=Проверка установки BigCityLegacy...

ru.ModBackup=Создание резервной копии текущей версии BigCityLegacy...
ru.ModRollback=Восстановление предыдущей версии BigCityLegacy...

ru.GitHubError=Не удалось получить последнюю версию BigCityLegacy с GitHub.
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
ru.LegalDownloadError=Не удалось загрузить условия использования и правовые положения с GitHub. Проверьте подключение к Интернету и URL RTF для выбранного языка.
ru.GitHubLink=GitHub
ru.WikiLink=Wiki
ru.RunGame=Запустить игру
ru.VisitWiki=Посетить Wiki



[Run]

Filename: "{code:GetGameExePath}"; \
    WorkingDir: "{code:GetGameDirectory}"; \
    Description: "{cm:RunGame}"; \
    Flags: nowait postinstall skipifsilent; \
    Check: ShouldOfferPostInstallActions

Filename: "{code:GetGameExePath}"; \
    WorkingDir: "{code:GetGameDirectory}"; \
    Flags: nowait; \
    Check: ShouldRunGameInSilent

Filename: "{#WikiUrl}"; \
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
  WelcomeGitHubLink: TNewStaticText;
  WelcomeWikiLink: TNewStaticText;
  ProgressPage: TOutputProgressWizardPage;

  LegalDocumentLoaded: Boolean;

  BepInExArchive: String;
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


function GetGameDirectory(Param: String): String;
begin
  Result := GameDir;
end;


function ShouldOfferPostInstallActions: Boolean;
begin
  Result := InstallationSucceeded and (GameDir <> '');
end;


procedure OpenGitHub(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec(
    '',
    '{#GitHubWebUrl}',
    '',
    '',
    SW_SHOWNORMAL,
    ewNoWait,
    ErrorCode
  );
end;


procedure OpenWiki(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec(
    '',
    '{#WikiUrl}',
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


function GetTermsRtfUrl: String;
begin
  if SameText(ActiveLanguage, 'ru') then
    Result := '{#TermsRtfUrlRu}'
  else
    Result := '{#TermsRtfUrlEn}';
end;


function EnsureLegalDocumentLoaded: Boolean;
var
  RtfPath: String;
  RtfData: AnsiString;
  RtfUrl: String;
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
  RtfUrl := GetTermsRtfUrl;

  try
    LegalViewer.Text := CustomMessage('LegalDownload');
    Log('Downloading legal RTF for language ' + ActiveLanguage + ': ' + RtfUrl);

    DownloadTemporaryFile(
      RtfUrl,
      'BigCityLegacy-terms-' + ActiveLanguage + '.rtf',
      '',
      nil
    );

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


function DownloadBepInEx: Boolean;
var
  ArchivePath: String;
begin
  Result := False;

  ArchivePath :=
    ExpandConstant('{tmp}\BepInEx.zip');

  DeleteFile(ArchivePath);

  ProgressPage.SetText(
    CustomMessage('BepInExDownload'),
    'BepInEx 5 x64'
  );

  try
    DownloadTemporaryFile(
      '{#BepInExUrl}',
      'BepInEx.zip',
      '',
      nil
    );

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
  ExitCode: Integer;
  ArchivePath: String;
begin
  Result := False;

  ArchivePath :=
    ExpandConstant('{tmp}\BepInEx.zip');

  ProgressPage.SetText(
    CustomMessage('BepInExInstall'),
    GameDir
  );

  if not TestArchive(ArchivePath) then
    Exit;

  if not Run7Zip(
    'x ' +
    Q(ArchivePath) +
    ' -o' + Q(GameDir) +
    ' -y',
    ExitCode
  ) then
    Exit;

  Result :=
    ExitCode = 0;
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

function ExtractFirstZipBrowserDownloadUrl(
  const Json: String): String;
var
  Marker: String;
  SearchPos: Integer;
  RelPos: Integer;
  P: Integer;
  StartPos: Integer;
  EndPos: Integer;
  Url: String;
begin
  Result := '';
  Marker := '"browser_download_url"';
  SearchPos := 1;

  while SearchPos <= Length(Json) do
  begin
    RelPos := Pos(Marker, Copy(Json, SearchPos, MaxInt));
    if RelPos = 0 then
      Exit;

    P := SearchPos + RelPos - 1 + Length(Marker);

    while (P <= Length(Json)) and (Json[P] <> ':') do
      Inc(P);

    if P > Length(Json) then
      Exit;

    Inc(P);

    while (P <= Length(Json)) and (Json[P] <> '"') do
      Inc(P);

    if P > Length(Json) then
      Exit;

    StartPos := P + 1;
    EndPos := StartPos;

    while EndPos <= Length(Json) do
    begin
      if (Json[EndPos] = '"') and
         ((EndPos = StartPos) or (Json[EndPos - 1] <> '\')) then
        Break;

      Inc(EndPos);
    end;

    if EndPos > Length(Json) then
      Exit;

    Url := Copy(Json, StartPos, EndPos - StartPos);

    if Pos('.zip', LowerCase(Url)) > 0 then
    begin
      Result := Url;
      Exit;
    end;

    SearchPos := EndPos + 1;
  end;
end;


function DownloadLatestMod: Boolean;
var
  ApiFile: String;
  Json: String;
  ModUrl: String;
begin
  Result := False;

  ApiFile :=
    ExpandConstant('{tmp}\github-release.json');

  DeleteFile(ApiFile);

  ProgressPage.SetText(
    CustomMessage('ModDownload'),
    'GitHub'
  );

  try

    DownloadTemporaryFile(
      '{#GitHubApiUrl}',
      'github-release.json',
      '',
      nil
    );

    if not FileExists(ApiFile) then
      RaiseException('GitHub API response was not downloaded.');

    Json :=
      ReadTextFile(ApiFile);

    if Json = '' then
      RaiseException('GitHub API returned an empty response.');

    ModUrl :=
      ExtractFirstZipBrowserDownloadUrl(Json);

    if ModUrl = '' then
      RaiseException(
        'No ZIP browser_download_url was found.'
      );

    Log('Latest mod URL: ' + ModUrl);

    ModArchive :=
      ExpandConstant('{tmp}\BigCityLegacy-latest.zip');

    DeleteFile(ModArchive);

    DownloadTemporaryFile(
      ModUrl,
      'BigCityLegacy-latest.zip',
      '',
      nil
    );

    if not FileExists(ModArchive) then
      RaiseException('Mod archive was not downloaded.');

    Result :=
      TestArchive(ModArchive);

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
var
  ExitCode: Integer;
begin
  Result := False;

  ModStageDir :=
    ExpandConstant('{tmp}\BigCityLegacy-ModStage');

  DelTree(
    ModStageDir,
    True,
    True,
    True
  );

  ForceDirectories(ModStageDir);

  ProgressPage.SetText(
    CustomMessage('ModInstall'),
    'Preparing files'
  );

  if not RunCommand(
    ExpandConstant('{tmp}\7za.exe'),
    'x ' +
    Q(ModArchive) +
    ' -o' + Q(ModStageDir) +
    ' -y',
    ModStageDir,
    ewWaitUntilTerminated,
    ExitCode
  ) then
    Exit;

  Result :=
    ExitCode = 0;
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

  if not ExtractModToStage then
    Exit;

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

    if not DownloadLatestMod then
    begin
      MsgBox(
        CustomMessage('GitHubError'),
        mbError,
        MB_OK
      );

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

    Params :=
      '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File ' +
      Q(ScriptPath) + ' ' +
      Q(Directory) + ' ' +
      Q(CustomMessage('SelectGameDirectory'));

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

    { The helper writes exactly one selected filesystem path to stdout.
      Use the last non-empty line defensively. }
    for I := 0 to GetArrayLength(Output.StdOut) - 1 do
    begin
      Line := Trim(Output.StdOut[I]);
      if Line <> '' then
        Directory := Line;
    end;

    Result := Directory <> '';
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

  { Classic-style first page: the standard Welcome page keeps the large
    wizard image on the left. The branding placeholders are in [Setup]. }

  WelcomeGitHubLink := TNewStaticText.Create(WizardForm);
  WelcomeGitHubLink.Parent := WizardForm.WelcomePage;
  WelcomeGitHubLink.Caption := CustomMessage('GitHubLink');
  WelcomeGitHubLink.AutoSize := True;
  WelcomeGitHubLink.Font.Style := [fsUnderline];
  WelcomeGitHubLink.Cursor := crHand;
  WelcomeGitHubLink.Left := WizardForm.WelcomeLabel2.Left;
  WelcomeGitHubLink.Top :=
    WizardForm.WelcomeLabel2.Top +
    WizardForm.WelcomeLabel2.Height +
    ScaleY(20);
  WelcomeGitHubLink.OnClick := @OpenGitHub;

  WelcomeWikiLink := TNewStaticText.Create(WizardForm);
  WelcomeWikiLink.Parent := WizardForm.WelcomePage;
  WelcomeWikiLink.Caption := CustomMessage('WikiLink');
  WelcomeWikiLink.AutoSize := True;
  WelcomeWikiLink.Font.Style := [fsUnderline];
  WelcomeWikiLink.Cursor := crHand;
  WelcomeWikiLink.Left := WelcomeGitHubLink.Left;
  WelcomeWikiLink.Top := WelcomeGitHubLink.Top + ScaleY(24);
  WelcomeWikiLink.OnClick := @OpenWiki;

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
end;


procedure CurPageChanged(CurPageID: Integer);
begin
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
  { /SILENT and /VERYSILENT always skip EULA. /SKIPEULA does the same
    for interactive installations. }
  Result := ShouldSkipEula and (PageID = LegalPage.ID);
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
  InstallationSucceeded := False;
  SelfDeleteRequested :=
    IsDisposableMode;

  if GetGameDirFromCommandLine <> '' then
  begin
    GameDir :=
      RemoveBackslashUnlessRoot(
        GetGameDirFromCommandLine
      );

    Result :=
      ValidateGameDirectory;

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