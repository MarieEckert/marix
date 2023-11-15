{$mode fpc}
unit marix;

interface
  uses kconsole;

  procedure kernel_start; stdcall;

implementation

  procedure kernel_start; stdcall; [public, alias: 'kernel_start'];
  begin
    asm
      @loop:
      jmp @loop
    end;
  end;
end.
