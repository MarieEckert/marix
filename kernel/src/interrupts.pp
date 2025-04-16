{$mode fpc}
unit interrupts;

{$asmmode att}

interface

uses kconsole;

type
  TIntHandler = procedure; cdecl;

  {$PACKRECORDS 1}
  TInterruptDescriptor = packed record
    offset_1: UInt16; // offset bits 0..15
    selector: UInt16; // a code segment selector in GDT or LDT
    ist: UInt8; // bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
    type_attributes: UInt8; // gate type, dpl, and p fields
    offset_2: UInt16; // offset bits 16..31
    offset_3: UInt32; // offset bits 32..63
    zero: UInt32; // reserved
  end;

  PInterruptDescriptor = ^TInterruptDescriptor;

  TIDTDescriptor = packed record
    limit: UInt16;
    table: PInterruptDescriptor;
  end;

procedure setup;

var
  idt: array [0..255] of TInterruptDescriptor;
  idt_descriptor: TIDTDescriptor;

implementation

procedure _isr_keyboard; [public, alias: '_isr_keyboard'];
label loop;
begin
  kconsole.print('INTERRUPT'#13#10);
  asm
    hlt
  end;
end;

function _make_id(const inthandler: Pointer; const flags: UInt8;
                   const segsel: UInt16): TInterruptDescriptor;
var
  test: UInt64;
begin
  { Funny type conversion bussiness; Not sure if this will work }
  _make_id.offset_1 := UInt16(UInt64(inthandler) and $FFFF);
  _make_id.offset_2 := UInt16((UInt64(inthandler) shr 16) and $FFFF);
  _make_id.offset_3 := UInt32((UInt64(inthandler) shr 32) and $FFFFFFFF);


  _make_id.type_attributes := flags;
  _make_id.selector := segsel;
  _make_id.zero := 0;
end;

procedure setup;
var
  i: Integer;
begin
  for i := 0 to 255 do
    idt[i] := _make_id(@_isr_keyboard, $8F, 8);

  idt_descriptor.limit := sizeof(idt) - 1;
  idt_descriptor.table := @idt;
  asm
    lidt idt_descriptor
  end;
end;

end.
