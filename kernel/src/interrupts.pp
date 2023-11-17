{$mode fpc}
unit interrupts;


interface

type
  TIntHandler = procedure;

  TInterruptDescriptor = record
    offset_1: UInt16; // offset bits 0..15
    selector: UInt16; // a code segment selector in GDT or LDT
    ist: UInt8; // bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
    type_attributes: UInt8; // gate type, dpl, and p fields
    offset_2: UInt16; // offset bits 16..31
    offset_3: UInt32; // offset bits 32..63
    zero: UInt32; // reserved
  end;

procedure setup;

var
  idt: array [0..255] of TInterruptDescriptor;

implementation

procedure _isr_keyboard;
begin
end;

function _make_id(const inthandler: Pointer; const flags: UInt8; 
                   const segsel: UInt16): TInterruptDescriptor;
begin
  { Funny type conversion bussiness; Not sure if this will work }
  _make_id.offset_1 := Cardinal(inthandler) shr 48;
  _make_id.offset_2 := Cardinal(inthandler) shr 32;
  _make_id.offset_3 := Cardinal(inthandler) shr 16;
  _make_id.type_attributes := flags;
  _make_id.selector := segsel;
  _make_id.zero := 0;
end;

procedure setup;
begin
 // idt[33] := _make_id(@_isr_keyboard, );

  asm
    lidt idt
  end;
end;

end.
