global kernel_start

section .text
bits 64
kernel_start:
  mov rax, 0x2f592f412f4b2f4f
  mov qword [0xb8000], rax

  hlt
