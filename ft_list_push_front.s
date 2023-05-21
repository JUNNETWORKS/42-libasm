global _ft_list_push_front

extern _malloc

%include "stack_frame.mac"

section .text

;void ft_list_push_front(t_list **begin_list, void *data);
;
; ===== arguments =====
; rdi: 1st argument. begin_list
; rsi: 2nd argument. data
;
; ===== local varibales =====
; [rbp - 0x08]: t_list **begin_list
; [rbp - 0x10]: void *data
_ft_list_push_front:
  stack_frame_prologue 0x20
  MOV [rbp - 0x08], rdi
  MOV [rbp - 0x10], rsi

  ; if (begin_list == NULL) return;
  CMP QWORD [rbp - 0x08], 0
  JE .ret

  ; t_list *new_ele = malloc(sizeof(t_list));
  MOV edi, 0x10  ; sizeof(t_list*) + sizeof(void*) = 0x10(16) bytes
  call _malloc
  CMP rax, 0
  JE .ret

  ; new_ele->data = data;
  MOV r8, [rbp - 0x10]
  MOV QWORD [rax], r8

  ; new_ele->next = *begin_list;
  MOV r8, [rbp - 0x08]
  MOV r8, [r8]
  MOV QWORD [rax + 0x08], QWORD r8

  ; *begin_list = new_ele;
  MOV r8, [rbp - 0x08]
  MOV [r8], rax

  .ret:
    stack_frame_epilogue
    ret
  