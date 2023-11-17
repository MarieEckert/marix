{$mode fpc}
unit kconsole;

interface

uses kvideo;

(*
 * @brief setup the kernel console. This will also setup kvideo for text mode
 * 
 * @param vga Sets if kvideo should be setup for VGA Text Mode.
 *)
procedure setup(vga: Boolean);

(*
 * @brief clears the kernel console
 *)
procedure clear;

(*
 * @brief prints a c-style string to the kernel console.
 *)
procedure print(const _str: PChar);

const
  MAXCOL = 80;
  MAXROW = 25;

  VGA_DEFAULT_KCONSOLECOLOR = $0F;

implementation

procedure _vga_setup;
begin
  kvideo.device.devicetype := kvdevtVGA;
  kvideo.device.devicemode := kvdevmTEXT;
  kvideo.device.width := MAXCOL;
  kvideo.device.height := MAXROW;
  kvideo.setup;

  kvideo.vga_tm_color := Char(VGA_DEFAULT_KCONSOLECOLOR);
end;

procedure setup(vga: Boolean);
begin
  if vga then
  begin
    _vga_setup;
    exit;
  end;
end;

procedure clear;
begin
  kvideo.cursor_x := 0;
  kvideo.cursor_y := 0;
  for kvideo.cursor_x := 0 to MAXROW - 1 do
    for kvideo.cursor_y := 0 to MAXCOL - 1 do
      kvideo.putc(' ');
  
  kvideo.cursor_x := 0;
  kvideo.cursor_y := 0;
end;

procedure print(const _str: PChar);
var
  i: Integer;
begin
  i := 0;
  while (_str[i] <> Char(0)) do
  begin
    kvideo.putc(_str[i]);
    i := i + 1;
  end;
end;

end.
