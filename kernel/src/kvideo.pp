{$mode fpc}
unit kvideo;

interface

type
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

(*
 * @brief implements putc for a framebuffer vga device.
 *)
procedure _vga_fb_putc(const c: Char);
begin
  if device.devicemode <> kvdevmFB then
    exit;
  { TODO: Implement VGA Framebuffer }
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
  ix := cursor_y * device.width * 2 + cursor_x * 2;
  device.vidmem[ix] := c;
  device.vidmem[ix + 1 ] := vga_tm_color;
  cursor_x := cursor_x + 1;
end;

procedure putc(const c: Char);
begin
  if c = Char($0a) then
  begin
    cursor_x := 0;
    cursor_y := cursor_y + 1;
    exit;
  end;
  case device.devicetype of
    kvdevtVGA: _vga_putc(c);
  end;
end;

end.
