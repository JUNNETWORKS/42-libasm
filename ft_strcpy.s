global _ft_strcpy

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
; r8:  a copy of dst pointer.
; r9b:  src[i]
_ft_strcpy:
  mov r8, rdi

  loop:
    mov r9b, [rsi]
    mov [rdi], r9b
    inc rsi
    inc rdi

    cmp r9b, 0
    jne loop

  mov r9b, [rsi]
  mov [rdi], r9b

  mov rax, rdi
  ret
