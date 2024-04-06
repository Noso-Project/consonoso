program consonoso;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, consonosounit,nosoblock,Noso_TUI,nosodebug,nosoconsensus
  { you can add units after this };

var
  counter       : integer;

  EndApp        : boolean = false;

Procedure NewLine(LText:String);
Begin
  Writeln(LText);
End;

{$REGION TUI}

Procedure DrawScreen();
Begin
  SetCursorMode(curhide);
  Cls(1,1,80,25);
  DWindow(1,1,80,12,'Consonoso',white,blue);
  DWindow(1,12,80,24,'Console',white,blue);
  VertLine(27,1,12,white,blue,true);
  VertLine(54,1,12,white,blue,true);
  SetConsole(2,13,79,23,white,black);
  CreateControl('P_Merkle','Merkle',2,2,8,white,black,alleft);
  CreateControl('P_Head','Head',2,3,8,white,black,alleft);
  CreateControl('P_Block','Block',2,4,8,white,black,alleft);
  CreateControl('P_LBHash','LBHash',2,5,8,white,black,alleft);
  CreateControl('P_Summary','Summary',2,6,8,white,black,alleft);
  CreateControl('P_PSOs','PSOs',2,7,8,white,black,alleft);
  CreateControl('P_CFG','CFG',2,8,8,white,black,alleft);
  CreateControl('P_GVTs','GVTs',2,9,8,white,black,alleft);
  CreateControl('P_MNs','MNodes',2,10,8,white,black,alleft);
  CreateControl('P_MNsCount','MNodes#',2,11,8,white,black,alleft);
  CreateControl('l_Merkle','',10,2,15,black,white,AlCenter);
  CreateControl('l_Head','',10,3,15,black,white,AlCenter);
  CreateControl('l_Block','',10,4,15,black,white,AlCenter);
  CreateControl('l_LBHash','',10,5,15,black,white,AlCenter);
  CreateControl('l_Summary','',10,6,15,black,white,AlCenter);
  CreateControl('l_PSOs','',10,7,15,black,white,AlCenter);
  CreateControl('l_CFG','',10,8,15,black,white,AlCenter);
  CreateControl('l_GVTs','',10,9,15,black,white,AlCenter);
  CreateControl('l_MNs','',10,10,15,black,white,AlCenter);
  CreateControl('l_MNsCount','',10,11,15,black,white,AlCenter);
  CreateControl('clock','00',55,25,25,yellow,black,alright);
End;

{$ENDREGION TUI}



Procedure Haltapp(Message:String);
Begin
  NewLine(Message);
  NewLine('Program exited');
End;

Begin
  for counter := 1 to paramCount() do
    begin
    if  UpperCase(paramStr(counter)) = '-TUI' then UseTUI := true;
    end;
  If UseTUI then
    begin
    InitializeTUI;
    DrawScreen;
    TUIThread := ThreadTUI.create(true);
    TUIThread.FreeOnTerminate:=true;
    //TUIThread.Start;
    end;
  if VerifyStructure>0 then HaltApp('Error verifying the file struture');
  UpdateThread := ThreadUpdate.create(true);
  UpdateThread.FreeOnTerminate:=true;
  UpdateThread.Start;
  ToLog('console','Files structure verified');
  InitSettings();
  ToLog('console','Settings loaded');
  InitFiles();
  StartAutoConsensus();
  If UseTUI then TUIThread.Start;

  ToLog('console','Press enter to finish');
  Readln();
  UpdateThread.Terminate;
  UpdateThread.WaitFor;

End. // End program

