global _ft_strcpy

%include "stack_frame.mac"

section .text


;char *ft_strcpy(char * dst, const char * src) {
;  int i = 0;
;  while (src[i]) {
;    dst[i] = src[i];
;    i++;
;  }
;  dst[i] = src[i];
;  return dst;
;}

; rdi: 1st argument. dst.
; rsi: 2nd argument. src.
; r9b:  src[i]
;
; ===== local variables =====
; [ebp - 8]: char *s. 1st argument. dst
_ft_strcpy:
  stack_frame_prologue 0x10
  mov [rbp - 8], rdi

  loop:
    mov r9b, [rsi]
    mov [rdi], r9b
    inc rsi
    inc rdi

    cmp r9b, 0
    jne loop

  mov r9b, [rsi]
  mov [rdi], r9b

  mov rax, [rbp - 8]
  stack_frame_epilogue
  ret
