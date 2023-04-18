global _ft_strcmp

section .text

;int ft_strcmp(const char *s1, const char *s2) {
;  int i = 0;
;  while (s1[i] || s2[i]) {
;    if (s1[i] - s2[i] != 0) {
;      return s1[i] - s2[i];
;    }
;    i++;
;  }
;  return 0;
;}

; rdi: 1st argument. s1.
; rsi: 2nd argument. s2.
; r8: *s1
; r9: *s2
_ft_strcmp:
  xor r8, r8
  xor r9, r9

  loop:
    mov r8b, [rdi]
    mov r9b, [rsi]

    cmp r8b, r9b
    jne return

    cmp r8b, 0
    je return
    cmp r9b, 0
    je return


    inc rdi
    inc rsi

    jmp loop
  
  return:
    mov rax, r8
    sub rax, r9
    ret