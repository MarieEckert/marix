unit marix;

interface

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
