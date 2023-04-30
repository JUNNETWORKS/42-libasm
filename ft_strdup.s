global _ft_strdup

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
; r8:  s
; r9:  len of s
; r10:  allocated memory
_ft_strdup:
    ; return NULL if s is NULL
    cmp rdi, 0
    je ret_null

    ; get length of s 
    push rdi
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
    pop rsi
    call _ft_strcpy

    ret

ret_null:
    mov rax, 0
    ret