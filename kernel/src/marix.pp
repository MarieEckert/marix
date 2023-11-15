{$mode fpc}
unit marix;

interface
  uses kconsole;

  procedure kernel_start; stdcall;

implementation

  procedure kernel_start; stdcall; [public, alias: 'kernel_start'];
  begin
    kconsole.setup(true);
    kconsole.print('early setup done!'#10);
    kconsole.print('> Booting marix'); 
    asm
      @loop:
      hlt
      jmp @loop
    end;
  end;
end.
