{$mode fpc}
unit kconsole;

interface

uses kvideo;

procedure setup(vga: Boolean);

procedure print(const _str: PChar; const count: Integer);

const
  MAXCOL = 80;
  MAXROW = 25;

implementation

procedure _vga_setup;
begin
  kvideo.device.devicetype := kvdevtVGA;
  kvideo.device.devicemode := kvdevmTEXT;
  kvideo.device.width := MAXCOL;
  kvideo.device.height := MAXROW;
end;

procedure setup(vga: Boolean);
begin
  if vga then
  begin
    _vga_setup;
    exit;
  end;
end;

procedure print(const _str: PChar; const count: Integer);
var
  i: Integer;
begin
  for i := 0 to count - 1 do
    kvideo.putc(_str[i]);
end;

end.
