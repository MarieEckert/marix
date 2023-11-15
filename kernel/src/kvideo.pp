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
  device: TKVideoDevice;

implementation

uses marix;

procedure setup;
begin
  case device.devicetype of
    kvdevtVGA: begin
      if device.devicemode = kvdevmTEXT then
        device.vidmem := PChar(VGA_TEXT_LOCATION);
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
begin
  if device.devicemode <> kvdevmTEXT then
    _vga_fb_putc(c);
  { TODO: Implement VGA Textmode output }
end;

procedure putc(const c: Char);
begin
  case device.devicetype of
    kvdevtVGA: _vga_putc(c);
  end;
end;

end.
