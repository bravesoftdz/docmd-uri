{**
Program will create a new URI Scheme
**}
program DoCMD_URI;

{$APPTYPE CONSOLE}
{$R *.RES}
uses
  SysUtils, Windows,
  ColorUtils in 'ColorUtils.pas';

begin
  writeln(' ');
  ColorWrite('DoCMD_URI',14,True);
  writeln(' ');
  Readln;
end.
