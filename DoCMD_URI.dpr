{** Program will create a new URI Scheme **}
program DoCMD_URI;
{$APPTYPE CONSOLE}
{$R *.RES}
uses
  SysUtils, Windows,
  ColorUtils in 'ColorUtils.pas';

var
  I: integer;
  commandFile, myParam: string;

{ Register all the requiered files }
procedure doRegist(myFile: string; silent: Boolean);
begin
  if not silent then
  begin
    writeln(' ');
    ColorWrite('DoCMD URI Registered successfully',14,True);
    writeln(' ');
  end;
end;

{ Remove all the previously registered files }
procedure undoRegist(myFile: string);
begin
  ColorWrite('DoCMD URI undoRegist',14,True);
end;

{ Remove all the previously registered files }
procedure doAction(myFile: string);
begin
  ColorWrite('DoCMD URI undoRegist',14,True);
end;

begin
  commandFile := '';
  if (ParamCount = 0) then
    doRegist(commandFile, false)
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
