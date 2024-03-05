program consonoso;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, consonosounit
  { you can add units after this };

Procedure NewLine(LText:String);
Begin
  Writeln(LText);
End;

Procedure Haltapp(Message:String);
Begin
  NewLine(Message);
  NewLine('Program exited');
End;

Begin

  if VerifyStructure>0 then HaltApp('Error verifying the file struture');
  writeln(Datafolder);
  readln();
End. // End program

