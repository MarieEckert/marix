{$mode fpc}
unit addr_util;

interface

function vga_textmode_addr(const col: Integer; const row: Integer; 
                           const w: Integer): Integer;

implementation

function vga_textmode_addr(const col: Integer; const row: Integer; 
                           const w: Integer): Integer;
const
  ELEMENT_SIZE = 2;
begin
  vga_textmode_addr := row * w * ELEMENT_SIZE + col * ELEMENT_SIZE;
end;
end.
