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
    woffs: Integer;
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
  device.woffs := 0;
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

  ix := cursor_y * device.width + cursor_x + device.woffs;
  device.vidmem[ix] := c;
  device.vidmem[ix + 1 ] := vga_tm_color;
  cursor_x := cursor_x + 1;
  device.woffs := device.woffs + 1;
end;

procedure putc(const c: Char);
begin
  case device.devicetype of
    kvdevtVGA: _vga_putc(c);
  end;
end;

end.
