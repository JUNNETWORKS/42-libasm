global _ft_atoi_base, _is_valid_base

extern _ft_strlen

; create stack frame
; 1st argument is a total size of local variables
; rspを16で割り切れる数にしておかないと呼び出し規約違反になる
%macro push_stack_frame 1
  PUSH rbp
  MOV rbp, rsp
  SUB rsp, %1
%endmacro

%macro pop_stack_frame 1
  ; restore previous stack frame
  MOV rsp, rbp
  POP rbp
  ; remove bytes from stack
  ; https://www.felixcloutier.com/x86/ret
  RET %1
%endmacro

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
; [rbp - 8]:  char *str.
; [rbp - 16]: char *base.
; [rbp - 20]: int sign.
; [rbp - 24]: int base_len.
; [rbp - 28]: int num.
; [rbp - 32]: int idx.
;
_ft_atoi_base:
  push_stack_frame 0x20
  MOV [rbp - 8], rdi
  MOV [rbp - 16], rsi

  CMP [rbp - 8], BYTE 0
  JE .ret_zero

  ; bool _is_valid_base(char *base)
  MOV rdi, [rbp - 16]
  CALL _is_valid_base
  CMP RAX, 1
  JNE .ret_zero

  ; char *skip_spaces(char *str)
  MOV rdi, [rbp - 8]
  CALL skip_spaces
  MOV [rbp - 8], rax

  ; char *parse_sign(char *str, int *sign)
  MOV rdi, [rbp - 8]
  MOV r8, rbp
  SUB r8, 20
  MOV rsi, r8
  CALL parse_sign
  MOV [rbp - 8], rax

  ; ===== parse number ===== 
  ; base_len = strlen(base);
  MOV rdi, [rbp - 16]
  CALL _ft_strlen
  MOV [rbp - 24], rax

  ; num = 0
  MOV [rbp - 28], DWORD 0

  .loop:
    MOV r9, [rbp - 8]
    CMP [r9], BYTE 0

    ; idx = ft_strchr(base, *str);
    MOV rdi, [rbp - 16]
    MOV rsi, [r9]
    CALL ft_strchr
    MOV [rbp - 32], rax

    ; if (idx == -1) return sign * num;
    CMP [rbp - 32], DWORD -1
    JE .ret

    CMP [rbp - 20], DWORD 0
    JG .check_overflow   ; if sign > 0
    JL .check_underflow  ; if sign < 0
    .continue_parse_number:
    
    ; num = num * base_len + idx;
    MOV rax, [rbp - 28]
    MUL DWORD [rbp - 24]
    ADD rax, [rbp - 32]
    MOV [rbp - 28], rax

    ; str++;
    MOV r8, [rbp - 8]
    INC r8
    MOV [rbp - 8], r8

    JMP .loop


  ; if (num > (INT_MAX - idx) / base_len) return 0;
  .check_overflow:
    MOV rax, INT_MAX
    SUB rax, [rbp - 32]
    IDIV DWORD [rbp - 24]
    CMP [rbp - 28], rax
    JG .ret_zero


  ; if (-1 * num < (INT_MIN + idx) / base_len) return 0;
  .check_underflow:
    ; (INT_MIN + idx) / base_len
    MOV rax, INT_MIN
    ADD rax, [rbp - 32]
    IDIV DWORD [rbp - 24]
    MOV r8, rax
    ; -1 * num
    MOV rax, [rbp - 28]
    MOV r9, -1
    IMUL r9
    CMP rax, r8
    JL .ret_zero

  .ret_zero:
    MOV RAX, 0
    pop_stack_frame 0x20
  
  .ret:
    ; return sign * num;
    MOV rax, [rbp - 28]
    IMUL DWORD [rbp - 20]
    pop_stack_frame 0x20

; int ft_strchr(char *s, char c)
;
; 
; rdi: 1st argument. s.
; rsi: 2nd argument. c.
ft_strchr:
  XOR rax, rax
  .loop:
    CMP [rdi], BYTE 0
    JE .ret_not_found

    CMP [rdi], rsi
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
; [rbp - 8]: base.
;
_is_valid_base:
  push_stack_frame 0x10  ; 16バイトアライメント

  ; copy 1st argument to local variable
  MOV [rbp - 8], rdi

  ; return false if base == null
  CMP QWORD [rbp - 8], QWORD 0
  JE .ret_false

  ; return false if len(base) <= 1
  MOV rdi, [rbp - 8]
  CALL _ft_strlen
  CMP rax, 1
  JLE .ret_false

  .loop:
    ; loop condition
    MOV r8, [rbp - 8]
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
    CMP r8, 32
    JLE .ret_false
    ; base[i] == '+'
    CMP r8, 43
    JLE .ret_false
    ; base[i] == '-'
    CMP r8, 45
    JLE .ret_false
    ; base[i] == 127
    CMP r8, 127
    JLE .ret_false

    ; base++
    MOV r8, [rbp-8]
    INC r8
    MOV [rbp-8], r8

    JMP .loop

  ; return lables are positioned below
  .ret_true:
    MOV rax, 1
    JMP .return

  .ret_false:
    MOV rax, 0
    JMP .return

  .return:
    pop_stack_frame 0x10

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
      JE .ret
      JMP .continue_loop
  
  .ret:
    MOV rax, rdi
    RET

; char *parse_sign(char *str, int *sign)
;
; rdi: 1st argument. str.
; rsi: 1st argument. sign. the result is stored to this var.
parse_sign:
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