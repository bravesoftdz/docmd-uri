{** Program will create a new URI Scheme **}
program DoCMD_URI;
{$APPTYPE CONSOLE}
{$R *.RES}
uses
  SysUtils, Windows, Registry,
  ColorUtils in 'ColorUtils.pas';

var
  I: integer;
  commandFile, myParam: string;

{ Register all the requiered files }
procedure doRegist(myFile: string; silent: Boolean);
var
  myReg: TRegistry;
begin
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_CLASSES_ROOT;
    myReg.CreateKey('DoCMD');
    if myReg.OpenKey('DoCMD', FALSE) then
    begin
      myReg.WriteString('', 'DoCMD URI');
      myReg.WriteString('URL Protocol', '');
      myReg.WriteString('Content Type', 'application/x-command');
      myReg.CreateKey('shell');
      if myReg.OpenKey('shell', FALSE) then
      begin
        myReg.WriteString('', 'open');
        myReg.CreateKey('open');
        if myReg.OpenKey('open', FALSE) then
        begin
          myReg.CreateKey('command');
          if myReg.OpenKey('command', FALSE) then
            myReg.WriteString('', myFile);
        end;

      end;
    end;
  finally
    myReg.Free;
  end;
  if not silent then
  begin
    writeln(' ');
    ColorWrite('DoCMD URI Registered successfully',14,True);
    writeln(' ');
  end;
end;

{ Remove all the previously registered files }
procedure undoRegist(myFile: string);
var
  myReg: TRegistry;
begin
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_LOCAL_MACHINE;
    myReg.DeleteKey('DoCMD');
    ColorWrite('DoCMD URI undoRegist',14,True);
  finally
    myReg.Free;
  end;

end;

{ Remove all the previously registered files }
procedure doAction(myFile: string);
begin
  ColorWrite('DoCMD URI undoRegist',14,True);
end;

begin
  commandFile := 'C:\Windows\DoCMD.vbs';
  if (ParamCount = 0) then
    undoRegist(commandFile)//doRegist(commandFile, false)
  else
  begin
    for I := 1 to ParamCount do
    begin
      myParam := UpperCase(ParamStr(I));
      if (myParam = '-A')  or (myParam = '/A') then
        doAction(commandFile)
      else if  (myParam = '-REG')  or (myParam = '/REG')  then
        doRegist(commandFile, false)
      else if  (myParam = '-Q')  or (myParam = '/Q')  then
        doRegist(commandFile, true)
      else if  (myParam = '-DEL')  or (myParam = '/DEL')  then
        undoRegist(commandFile);
    end;
  end;

  Readln;
end.
