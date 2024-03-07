unit nososettings;

{$mode ObjFPC}{$H+}

INTERFACE

uses
  Classes, SysUtils, strutils;

Type

  TSetting = Record
    name    : string;
    value   : string;
    Comment : string;
    end;

Procedure SetSettingsFilename(name:string);
Procedure InitSetting(Name,value,comment:string);
Function GetSetInt(name:string):int64;
Function GetSetStr(name:string):string;
Function GetSetBool(name:string):boolean;
Procedure SaveSettings();
Procedure LoadSettings();

var
  ArraySettings     : Array of TSetting;
  SettingsFilename  : string = 'config.conf';
  SetsFile          : TextFile;
  CS_Settings       : TRTLCriticalSection;

IMPLEMENTATION

Procedure SetSettingsFilename(name:string);
Begin
  SettingsFilename := name;
  AssignFile(SetsFile, SettingsFilename);
End;

Procedure InitSetting(Name,value,comment:string);
Begin
  EnterCriticalSection(CS_Settings);
  SetLength(ArraySettings,Length(ArraySettings)+1);
  ArraySettings[Length(ArraySettings)-1].name    := name;
  ArraySettings[Length(ArraySettings)-1].value   := value;
  ArraySettings[Length(ArraySettings)-1].Comment := comment;
  LeaveCriticalSection(CS_Settings);
End;

Function GetSetInt(name:string):int64;
var
  counter : integer;
Begin
  result := 0;
  EnterCriticalSection(CS_Settings);
  for counter := 0 to high(ArraySettings) do
    if UpperCase(ArraySettings[counter].name) = Uppercase(name) then
      begin
      result := StrToInt64Def(ArraySettings[counter].value,0);
      break;
      end;
  LeaveCriticalSection(CS_Settings);
End;

Function GetSetStr(name:string):string;
var
  counter : integer;
Begin
  result := '';
  EnterCriticalSection(CS_Settings);
  for counter := 0 to high(ArraySettings) do
    if UpperCase(ArraySettings[counter].name) = Uppercase(name) then
      begin
      result := ArraySettings[counter].value;
      break;
      end;
  LeaveCriticalSection(CS_Settings);
End;

Function GetSetBool(name:string):boolean;
var
  counter : integer;
Begin
  result := false;
  EnterCriticalSection(CS_Settings);
  for counter := 0 to high(ArraySettings) do
    if UpperCase(ArraySettings[counter].name) = Uppercase(name) then
      begin
      result := StrTOBoolDef(ArraySettings[counter].value,False);
      break;
      end;
  LeaveCriticalSection(CS_Settings);
End;

Procedure SaveSettings();
var
  counter : integer;
Begin
  EnterCriticalSection(CS_Settings);
  Rewrite(SetsFile);
  for counter := 0 to high(ArraySettings) do
    begin
    writeln(SetsFile,format('# %s',[ArraySettings[counter].Comment]));
    writeln(SetsFile,format('%s %s',[ArraySettings[counter].name,ArraySettings[counter].value]));
    writeln(Setsfile,'');
    end;
  CloseFile(SetsFile);
  EnterCriticalSection(CS_Settings);
End;

Procedure LoadSettings();
var
  LLine   : string;
  DataArr : array of string;
  Counter : integer;
Begin
  EnterCriticalSection(CS_Settings);
  reset(SetsFile);
  While not eof(SetsFile) do
     begin
     Readln(SetsFile,LLine);
     DataArr := SplitString(LLine,' ');
     for counter := 0 to high(ArraySettings) do
       begin
       if Uppercase(DataArr[0]) = Uppercase(ArraySettings[counter].name) then
         begin
         ArraySettings[counter].value:= DataArr[1];
         end;
       end;
     end;
  CloseFile(SetsFile);
  EnterCriticalSection(CS_Settings);
End;

INITIALIZATION
  SetLength(ArraySettings,0);
  AssignFile(SetsFile, SettingsFilename);
  InitCriticalSection(CS_Settings);

FINALIZATION
  DoneCriticalSection(CS_Settings);

END.{End unit}

