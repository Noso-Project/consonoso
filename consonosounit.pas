unit consonosounit;

{$mode ObjFPC}{$H+}

INTERFACE

uses
  Classes, SysUtils,nosodebug,nosoblock;

Function VerifyStructure: integer;

var
  Homefolder : string;
  Datafolder : string;
  SettingsFilename : String = 'settings.conf';

IMPLEMENTATION

Function VerifyStructure: integer;
Begin
  Result := 0;
  if not directoryexists(homefolder) then
    if not CreateDir(homefolder) then Inc(Result);
  Datafolder := HomeFolder + 'NOSODATA';
  if not directoryexists(Datafolder) then
    if not CreateDir(Datafolder) then Inc(Result);
  //SetBlockDirectory(

End;

INITIALIZATION
Homefolder := {$ifdef windows}GetAppConfigDir(true) {$else} GetUserDir + '.nosonode/' {$endif};

FINALIZATION

END.

