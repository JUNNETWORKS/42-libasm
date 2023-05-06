global _ft_strdup

%include "stack_frame.mac"

extern _malloc, _ft_strlen, _ft_strcpy

section .text

; char *ft_strdup(const char *s) {
;   if (s == NULL)
;     return NULL;
;   int len = strlen(s);
;   char *ret = malloc(sizeof(char) * len + 1);
;   strcpy(ret, s);
;   return ret;
; }
;
; rdi: 1st argument. s.
;
; ===== local variables =====
; [rbp - 8]: char* s.
_ft_strdup:
    stack_frame_prologue 0x10
    mov [rbp - 0x8], rdi
    ; get length of s 
    call _ft_strlen
    mov rdi, rax

    ; allocate memory
    inc rdi
    call _malloc
    ; return NULL if memory allocation is failed
    cmp rax, 0
    je ret_null

    ; copy string
    mov rdi, rax
    mov rsi, [rbp - 8]
    call _ft_strcpy

    stack_frame_epilogue
    ret

ret_null:
    mov rax, 0
    stack_frame_epilogue
    ret