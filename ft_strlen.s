global _ft_strlen ; 他ファイルからアクセスするのにglobalラベルをつける

%include "stack_frame.mac"

section .text     ; テキスト領域

; rdi: 1st argument of ft_strlen()
; r8: value in this register will bre used to return value to caller
; r9b: 1byte register. use to load a peice of data from passed address
_ft_strlen:
  stack_frame_prologue 0x10
  xor r8, r8       ; len = 0

  loop:
    mov r9b, [rdi]
    cmp r9b, 0
    je return_len
    inc r8
    inc rdi
    jmp loop

  return_len:
    mov rax, r8
    stack_frame_epilogue
    ret
