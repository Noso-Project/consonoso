unit consonosounit;

{$mode ObjFPC}{$H+}

INTERFACE

uses
  Classes, SysUtils,nosodebug,nosoblock,nosogeneral,noso_TUI,nososettings,nosounit,
  nosoheaders, nosomasternodes;

Type
  ThreadUpdate = class(TThread)
    protected
      procedure Execute; override;
    public
      constructor Create(const CreatePaused: Boolean);
  end;

Function VerifyStructure: integer;
Procedure InitSettings();
Procedure InitFiles();

var
  Homefolder          : string;
  Datafolder          : string;
  LogsDirectory       : string= 'NOSODATA'+DirectorySeparator+'LOGS'+DirectorySeparator;
  DeepDebLogFilename  : string= 'deepdeb.txt';
  ConsoleLogFilename  : string= 'console.txt';
  UpdateThread        : ThreadUpdate;
  UseTUI              : boolean = true;
  LastLogLine         : string;

IMPLEMENTATION

{$REGION Thread update}

constructor ThreadUpdate.Create(const CreatePaused: Boolean);
Begin
  inherited Create(CreatePaused);
  FreeOnTerminate := True;
End;

procedure ThreadUpdate.Execute;
var
  counter : integer = 1;
Begin
  While not terminated do
    begin
    while GetLogLine('console',lastlogline) do
      begin
      if UseTUI then ToConsole(LastLogLine)
      else writeln(LastLogLine);
      end;
    sleep(100);
    end;
End;

{$ENDREGION Thread update}

Function VerifyStructure: integer;
Begin
  Result := 0;
  if not directoryexists(homefolder) then
    if not CreateDir(homefolder) then Inc(Result);

  Datafolder := HomeFolder + 'NOSODATA';
  if not directoryexists(Datafolder) then
    if not CreateDir(Datafolder) then Inc(Result);

  SetBlockDirectory(homefolder+BlockDirectory);
  if not directoryexists(BlockDirectory) then
    if not CreateDir(BlockDirectory) then Inc(Result);

  if not directoryexists(BlockDirectory+DBDirectory) then
    if not CreateDir(BlockDirectory+DBDirectory) then Inc(Result);

  LogsDirectory := Homefolder+LogsDirectory;
  if not directoryexists(LogsDirectory) then
    if not CreateDir(LogsDirectory) then Inc(Result);

  InitDeepDeb(LogsDirectory+DeepDebLogFilename,format('( %s - %s )',['Consopool', OSVersion]));
  CreateNewLog('console',LogsDirectory+ConsoleLogFilename);
End;

Procedure InitSettings();
Begin
  SetSettingsFilename(DataFolder+DirectorySeparator+'settings.conf');
  InitSetting('Autoserver','true','Enable node server at start');
  InitSetting('Autoupdate','false','Update automatically new releases');
  InitSetting('MNIP','','Masternode static IP');
  InitSetting('MNPort','8080','Masternode TCP port');
  InitSetting('MNFunds','','Masternode funds address');
  InitSetting('MNSign','','Masternode sign address');
  InitSetting('MNAutoIp','true','Use automatic IP detection for masternode');
  InitSetting('RPCAuto','false','Enable RPC server at start');
  InitSetting('RPCPort','8078','RPC server port');
  If not fileexists(SettingsFilename) then SaveSettings();
  LoadSettings();
End;

Procedure InitFiles();
Begin
  SetHeadersFileName(DataFolder+DirectorySeparator+'blchhead.nos');
  ToLog('console','Headers file ok');
  SetMasternodesFilename(DataFolder+DirectorySeparator+'masternodes.txt');
  ToLog('console','Masternodes file ok');
End;

INITIALIZATION
Homefolder := {$ifdef windows}GetAppConfigDir(true) {$else} GetUserDir + '.nosonode/' {$endif};

FINALIZATION

END.

