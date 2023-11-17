{$mode fpc}
unit kvideo;

interface

uses addr_util;

type
  TTextModeColor = (BLACK = $0,
                    BLUE = $1,
                    GREEN = $2,
                    CYAN = $3,
                    RED = $4,
                    MAGENTA = $5,
                    BROWN = $6,
                    LIGHT_GRAY = $7,
                    DARK_GRAY = $8,
                    LIGHT_BLUE = $9,	
                    LIGHT_GREEN = $a,	
                    LIGHT_CYAN = $b,	
                    LIGHT_RED = $c,	
                    PINK = $d,	
                    YELLOW = $e,	
                    WHITE = $f
                  );
  TKVideoDeviceType = (kvdevtVGA);
  TKVideoDeviceMode = (kvdevmTEXT, kvdevmFB);

  TKVideoDevice = record
    devicetype: TKVideoDeviceType;
    devicemode: TKVideoDeviceMode;
    vidmem: PChar;
    width: Integer;
    height: Integer;
  end;

procedure setup;

(*
 * @brief set the color to be used for writing in textmode from now on
 *)
procedure set_tm_color(const fore: TTextModeColor; const back: TTextModeColor);

(*
 * @brief pushes all lines which are on screen up by one
 *)
procedure textmode_push;

(*
 * @brief abstract putc implementation
 *)
procedure putc(const c: Char);

const
  VGA_TEXT_LOCATION = $b8000;

var
  cursor_x, cursor_y: Integer;
  vga_tm_color: Char;
  device: TKVideoDevice;

implementation

(*                     private procedures and functions                       *)

(*
 * @brief implements putc for a framebuffer vga device.
 *)
procedure _vga_fb_putc(const c: Char);
begin
  if device.devicemode <> kvdevmFB then
    exit;
  { TODO: Implement VGA Framebuffer }
end;

procedure _vga_tm_push;
var
  row, col, ix, new_ix: Integer;
begin
  for row := 1 to device.height - 1 do
  begin
    for col := 0 to device.width - 1 do
    begin
      ix := addr_util.vga_textmode_addr(col, row, device.width);
      new_ix := addr_util.vga_textmode_addr(col, row - 1, device.width);
      device.vidmem[new_ix] := device.vidmem[ix];
    end;
  end;
end;

(*
 * @brief implements putc for vga devices
 *)
procedure _vga_putc(const c: Char);
var
  ix: Integer;
begin
  if device.devicemode <> kvdevmTEXT then
    _vga_fb_putc(c);

  { offset = y * w * s + x * s }
  { y = row; w = columns per row; x = column; s = element_size = 2 }
  ix := addr_util.vga_textmode_addr(cursor_x, cursor_y, device.width);
  device.vidmem[ix] := c;
  device.vidmem[ix + 1 ] := vga_tm_color;
  cursor_x := cursor_x + 1;
end;

(******************************************************************************)
(*                     public procedures and functions                        *)

procedure setup;
begin
  case device.devicetype of
    kvdevtVGA: begin
      if device.devicemode = kvdevmTEXT then
        device.vidmem := PChar(VGA_TEXT_LOCATION);
    end;
  end;

  case device.devicemode of
    kvdevmTEXT: begin
      cursor_x := 0;
      cursor_y := 0;
    end;
  end;
end;

procedure set_tm_color(const fore: TTextModeColor; const back: TTextModeColor);
begin
  case device.devicetype of
    kvdevtVGA:
      vga_tm_color := Char((Ord(back) shl 4) or Ord(fore));
  end;
end;

procedure textmode_push;
begin
  case device.devicetype of
    kvdevtVGA: begin
      if device.devicemode = kvdevmTEXT then
        _vga_tm_push;
    end;
  end;
end;

procedure putc(const c: Char);
begin
  case Byte(c) of
    $0a: begin
      cursor_y := cursor_y + 1;
      if cursor_y >= device.height then
        textmode_push;
      exit;
    end;
    $0d: begin
      cursor_x := 0;
      exit;
    end;
  end;

  case device.devicetype of
    kvdevtVGA: _vga_putc(c);
  end;
end;

(******************************************************************************)

end.
