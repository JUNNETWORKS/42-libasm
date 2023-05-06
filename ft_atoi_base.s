global _ft_atoi_base, _is_valid_base, _parse_sign

extern _ft_strlen

%include "stack_frame.mac"

%define INT_MAX 2147483647
%define INT_MIN -2147483648 

section .text

; int ft_atoi_base(char *str, char *base)
;
; ===== arguments =====
; rdi: 1st argument. str.
; rsi: 2nd argument. base.
; 
; ===== local variables ===== 
; [rbp - 0x8]:  char *str.
; [rbp - 0x10]: char *base.
; [rbp - 0x14]: int sign.
; [rbp - 0x18]: int base_len.
; [rbp - 0x1c]: int num.
; [rbp - 0x20]: int idx.
;
_ft_atoi_base:
  stack_frame_prologue 0x20
  MOV [rbp - 0x8], rdi
  MOV [rbp - 0x10], rsi

  CMP QWORD [rbp - 0x8], 0
  JE .ret_zero

  ; bool _is_valid_base(char *base)
  MOV rdi, [rbp - 0x10]
  CALL _is_valid_base
  CMP rax, 1
  JNE .ret_zero

  ; char *skip_spaces(char *str)
  MOV rdi, [rbp - 0x8]
  CALL skip_spaces
  MOV [rbp - 0x8], rax

  ; char *parse_sign(char *str, int *sign)
  MOV rdi, [rbp - 0x8]
  MOV r8, rbp
  SUB r8, 20
  MOV rsi, r8
  CALL _parse_sign
  MOV [rbp - 0x8], rax

  ; ===== parse number ===== 
  ; base_len = strlen(base);
  MOV rdi, [rbp - 0x10]
  CALL _ft_strlen
  MOV [rbp - 0x18], eax

  ; ===== ここまで動作確認済み =====

  ; num = 0
  MOV DWORD [rbp - 0x1c], 0

  .loop:
    MOV r9, [rbp - 0x8]
    CMP [r9], BYTE 0

    ; idx = ft_strchr(base, *str);
    MOV rdi, [rbp - 0x10]
    MOV rsi, [r9]
    CALL ft_strchr
    MOV [rbp - 0x20], rax

    ; if (idx == -1) return sign * num;
    CMP [rbp - 0x20], DWORD -1
    JE .ret

    CMP [rbp - 0x14], DWORD 0
    JG .check_overflow   ; if sign > 0
    JL .check_underflow  ; if sign < 0
    .continue_parse_number:
    
    ; num = num * base_len + idx;
    MOV rax, [rbp - 0x1c]
    MUL DWORD [rbp - 0x18]
    ADD rax, [rbp - 0x20]
    MOV [rbp - 0x1c], rax

    ; str++;
    MOV r8, [rbp - 0x8]
    INC r8
    MOV [rbp - 0x8], r8

    JMP .loop

  ; if (num > (INT_MAX - idx) / base_len) return 0;
  .check_overflow:
    MOV rax, INT_MAX
    SUB rax, [rbp - 0x20]
    IDIV DWORD [rbp - 0x18]
    CMP [rbp - 0x1c], rax
    JG .ret_zero

  ; if (-1 * num < (INT_MIN + idx) / base_len) return 0;
  .check_underflow:
    ; (INT_MIN + idx) / base_len
    MOV rax, INT_MIN
    ADD rax, [rbp - 0x20]
    IDIV DWORD [rbp - 0x18]
    MOV r8, rax
    ; -1 * num
    MOV rax, [rbp - 0x1c]
    MOV r9, -1
    IMUL r9
    CMP rax, r8
    JL .ret_zero

  .ret_zero:
    MOV RAX, 0
    stack_frame_epilogue 
    ret

  .ret:
    ; return sign * num;
    MOV rax, [rbp - 0x1c]
    IMUL DWORD [rbp - 0x14]
    stack_frame_epilogue
    ret

; int ft_strchr(char *s, char c)
;
; 
; rdi: 1st argument. s.
; sil: 1 byte of rsi register. 2nd argument. c.
ft_strchr:
  XOR rax, rax
  .loop:
    CMP [rdi], BYTE 0
    JE .ret_not_found

    CMP [rdi], sil
    JE .ret_found

    INC rax
    INC rdi

    JMP .loop
  .ret_found:
    RET
  .ret_not_found:
    MOV rax, -1
    RET

; int _is_valid_base(char *base)
;
; ===== arguments =====
; rdi: 1st argument. base.
; 
; ===== local variables ===== 
; [rbp - 0x8]: base.
;
_is_valid_base:
  stack_frame_prologue 0x10

  ; copy 1st argument to local variable
  MOV [rbp - 0x8], rdi

  ; return false if base == null
  CMP QWORD [rbp - 0x8], QWORD 0
  JE .ret_false

  ; return false if len(base) <= 1
  MOV rdi, [rbp - 0x8]
  CALL _ft_strlen
  CMP rax, 1
  JLE .ret_false

  .loop:
    ; loop condition
    MOV r8, [rbp - 0x8]
    CMP BYTE [r8], BYTE 0
    JE .ret_true

    ; return false if (ft_strchr(base + i + 1, base[i]) != -1)
    MOV rdi, [rbp-8]
    INC rdi
    MOV r8, [rbp-8]
    MOV rsi, [r8]
    CALL ft_strchr
    CMP rax, -1
    JNE .ret_false

    ; return false if (base[i] <= 32 || base[i] == '+' || base[i] == '-' || base[i] == 127)
    MOV r8, [rbp-8]
    MOV r8, [r8]
    ; base[i] <= 32
    CMP r8b, 32
    JLE .ret_false
    ; base[i] == '+'
    CMP r8b, 43
    JE .ret_false
    ; base[i] == '-'
    CMP r8b, 45
    JE .ret_false
    ; base[i] == 127
    CMP r8b, 127
    JE .ret_false

    ; base++
    INC QWORD [rbp-8]

    JMP .loop

  ; return lables are positioned below
  .ret_true:
    MOV rax, 1
    JMP .return

  .ret_false:
    MOV rax, 0
    JMP .return

  .return:
    stack_frame_epilogue
    ret

; char *skip_spaces(char *str)
;
; rdi: 1st argument. str.
;
skip_spaces:
  .loop:
    CMP BYTE [rdi], BYTE 0
    JE .ret
    CMP BYTE [rdi], 32
    JG .is_127
    .continue_loop:
    INC rdi
    JMP .loop

    .is_127:
      CMP BYTE [rdi], BYTE 127
      JNE .ret
      JMP .continue_loop
  
  .ret:
    MOV rax, rdi
    RET

; char *parse_sign(char *str, int *sign)
;
; rdi: 1st argument. str.
; rsi: 2nd argument. sign. the result is stored to this var.
_parse_sign:
  MOV DWORD [rsi], DWORD 1
  .loop:
    CMP BYTE [rdi], BYTE 0
    JE .ret
    CMP BYTE [rdi], BYTE 43  ; *str < '+'
    JL .ret
    CMP BYTE [rdi], BYTE 45  ; *str > '-'
    JG .ret
    CMP BYTE [rdi], BYTE 44  ; *str == ','
    JE .ret

    CMP BYTE [rdi], BYTE 45
    JNE .skip_change_sign
    MOV DWORD [rsi], DWORD -1

    .skip_change_sign:

    INC rdi
    
    JMP .loop

  .ret:
    MOV rax, rdi
    RET