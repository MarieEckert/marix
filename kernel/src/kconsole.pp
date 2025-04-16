{$mode fpc}
unit kconsole;

interface

uses kvideo;

(*
 * @brief setup the kernel console. This will also setup kvideo for text mode
 * 
 * @param vga Sets if kvideo should be setup for VGA Text Mode.
 *)
function setup(vga: Boolean): Integer;

(*
 * @brief clears the kernel console
 *)
procedure clear;

(*
 * @brief prints a c-style string to the kernel console.
 *)
procedure print(const _str: PChar);

(*
 * @brief converts an int to a string and then prints it to the kernel console
 *)
procedure print_int(_int: Integer);

(*
 * @brief converts an int to a string and then prints it to the kernel console
 *)
procedure print_int_hex(_int: UInt64);

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

function setup(vga: Boolean): Integer;
begin
  if vga then
  begin
    _vga_setup;
    exit(0);
  end;

  exit(1);
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

procedure print_int(_int: Integer);
const
  MAX_DIGITS = 20;
var
  _str: array [0..MAX_DIGITS] of Char;
  digit_count: Integer;
begin
  if _int < 0 then
  begin
    kvideo.putc('-');
    _int := - _int;
  end;

  digit_count := 0;
  repeat
    _str[digit_count] := Char((_int mod 10) + Ord('0'));
    _int := _int div 10;
    Inc(digit_count);
  until _int = 0;

  for digit_count := digit_count - 1 downto 0 do
    kvideo.putc(_str[digit_count]);
end;

procedure print_int_hex(_int: UInt64);
const
  MAX_DIGITS = 32;
  DIGITS: array of Char = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
var
  ix: Integer;
  _str: array [0..MAX_DIGITS] of Char;
begin
  for ix := 0 to MAX_DIGITS - 1 do
    _str[ix] := '0';

  ix := 0;
  repeat
    _str[ix] := DIGITS[_int mod 16];
    _int := _int div 16;
    ix := ix + 1;
  until (_int = 0) or (ix >= MAX_DIGITS);

  for ix := MAX_DIGITS - 1 downto 0 do
    kvideo.putc(_str[ix]);
end;

end.
