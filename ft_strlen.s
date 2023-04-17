global _ft_strlen ; 他ファイルからアクセスするのにglobalラベルをつける

section .text     ; テキスト領域

; rdi: 1st argument of ft_strlen()
; r8: value in this register will bre used to return value to caller
; r9: current address
; r10b: 1byte register. use to load a peice of data from passed address
_ft_strlen:
  xor r8, r8       ; len = 0
  mov r9, rdi

  loop:
    mov r10b, [r9]
    cmp r10b, 0
    je return_len
    inc r8
    inc r9
    jmp loop

  return_len:
    mov rax, r8
    ret
