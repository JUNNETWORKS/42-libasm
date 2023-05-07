global _ft_list_size

%include "stack_frame.mac"

section .text

; int ft_list_size(t_list *begin_list);
;
; ===== arguments =====
; rdi: t_list *begin_list
;
; ===== local variables =====
; [rbp - 0x04]: int len
; [rbp - 0x0c]: t_list *current
_ft_list_size:
  stack_frame_prologue 0x10

  ; int len = 0
  MOV DWORD [rbp - 0x04], 0
  ; t_list current = begin_list
  MOV [rbp - 0x0c], rdi

  ; if (begin_list == NULL) return 0;
  CMP rdi, 0
  JE .ret

  .loop:
    ; if (current == NULL) return len;
    CMP QWORD [rbp - 0x0c], 0
    JE .ret

    ; current = current->next;
    MOV r8, [rbp - 0x0c]
    MOV r8, [r8 + 0x08]
    MOV [rbp - 0x0c], r8
    ; len += 1
    MOV r8d, [rbp - 0x04]
    INC r8d
    MOV [rbp - 0x04], r8d

    JMP .loop

  .ret:
    MOV eax, [rbp - 0x04]
    stack_frame_epilogue
    ret