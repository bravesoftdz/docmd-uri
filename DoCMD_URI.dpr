{** Program will create a new URI Scheme **}
program DoCMD_URI;
{$R *.RES}
uses
  SysUtils, Windows, Registry, SHFolder, ShellApi, Dialogs, StrUtils;

var
  I: integer;
  strFile, myParam: string;

function GetSpecialFolderPath(folder : integer) : string;
var path: array [0..1024] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0,folder,0,0,@path[0])) then
    Result := path
  else
    Result := '';
end;

{ Get full name of current exe}
function GetModName: String;
var
  fName: String;
  nsize: cardinal;
begin
  nsize := 1024;
  SetLength(fName,nsize);
  SetLength(fName,
    GetModuleFileName(
      hinstance,
      pchar(fName),
      nsize));
  Result := fName;
end;

{ Add Current directory to the %PATH% }
procedure doAddToPath();
var
  myReg: TRegistry;
  strPath, strDir: string;
begin
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_LOCAL_MACHINE;
    if myReg.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment\', FALSE) then
    begin
      strPath := myReg.ReadString('Path');
      strDir := ';' + ExtractFileDir(GetModName);
      if Pos(strDir, strPath) = 0 then
        myReg.WriteString('Path', strPath + strDir);
    end;
  finally
    myReg.Free;
  end;
end;

{ Register all the requiered files }
procedure doRegist(myFile: string; silent: Boolean);
var myReg: TRegistry;
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
          begin
            myReg.WriteString('', myFile + ' -A "%1"');
            CopyFile(PChar(GetModName),PChar(myFile), false);
            doAddToPath();
          end;
        end;
      end;
    end;
  finally
    myReg.Free;
  end;
  if not silent then
  begin
    ShowMessage('DoCMD URI Registered successfully');
  end;
end;

{ Remove all the previously registered files }
procedure undoRegist(myFile: string);
var myReg: TRegistry;
begin
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_CLASSES_ROOT;
    myReg.DeleteKey('DoCMD');
    DeleteFile(PChar(myFile));
  finally
    myReg.Free;
  end;
  ShowMessage('DoCMD URI removed successfully');
end;

{ Here is the action  }
procedure doAction(strCommand: string);
var intPos: Integer;
begin
  strCommand := AnsiReplaceStr(strCommand,'%20',' ');
  strCommand := Copy(strCommand,8,Length(strCommand));
  intPos := Pos(' ', strCommand);
  if intPos > 0 then
    ShellExecute(0, nil, PChar(Copy(strCommand,1,intPos)),
      PChar(Copy(strCommand, intPos+1, Length(strCommand))), nil, SW_SHOWNORMAL)
  else
    ShellExecute(0, nil, PChar(strCommand), '', nil, SW_SHOWNORMAL);
end;

begin
  strFile := GetSpecialFolderPath(36) + '\DoCMD.exe';
  if (ParamCount = 0) then
    doRegist(strFile, false)
  else
  begin
    for I := 1 to ParamCount do
    begin
      myParam := UpperCase(ParamStr(I));
      if (myParam = '-A')  or (myParam = '/A') then
        doAction(ParamStr(I+1))
      else if (myParam = '-REG') or (myParam = '/REG') then
        doRegist(strFile, false)
      else if (myParam = '-Q') or (myParam = '/Q') then
        doRegist(strFile, true)
      else if (myParam = '-DEL') or (myParam = '/DEL') then
        undoRegist(strFile);
    end;
  end;
end.
