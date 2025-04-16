{$mode fpc}
unit marix;

interface
  uses kvideo, kconsole, interrupts;

  procedure kernel_start; stdcall;

implementation
  procedure kernel_start; stdcall; [public, alias: 'kernel_start'];
  var
    a, test: Integer;
  begin
    a := kconsole.setup(true);
    kconsole.clear;
    kconsole.print('early setup done!'#13#10);
    kconsole.print('> Booting marix'#13#10); 
    kconsole.print('>> Initializing IDT'#13#10);

    interrupts.setup;

    test := 1000 div a;

    asm
      @loop:
        hlt
        jmp @loop
    end;
  end;
end.
