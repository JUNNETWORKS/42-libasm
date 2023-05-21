global _ft_list_remove_if

extern _free

%include "stack_frame.mac"

%define ofs_begin_list 0x08  ; t_list **
%define ofs_data_ref 0x10    ; void *
%define ofs_cmp 0x18         ; int (*cmp)()
%define ofs_free_fct 0x20    ; void (*free_fct)()
%define ofs_prev 0x28        ; t_list *prev
%define ofs_current 0x30     ; t_list *current
%define ofs_tmp 0x38         ; t_list *tmp

section .text

; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
;
; ===== arguments =====
; rdi: 1st argument. begin_list
; rsi: 2nd argument. data_ref
; rdx: 3rd argument. cmp
; rcx: 4th argument. free_fct
;
;void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *)) {
;  if (begin_list == NULL || cmp == NULL || free_fct ==  NULL) {
;    return;
;  }
;  t_list *prev = NULL;
;  t_list *current = *begin_list;
;  t_list *tmp;
;  while (current != NULL) {
;    if (cmp(current->data, data_ref) == 0) {
;      tmp = current;
;      current = current->next;
;      if (prev == NULL) {
;        *begin_list = current;
;      } else {
;        prev->next = current;
;      }
;      free_fct(tmp->data);
;      free(tmp);
;    } else {
;      prev = current;
;      current = current->next;
;    }
;  }
;}
_ft_list_remove_if:
  stack_frame_prologue 0x40

  MOV [rbp - ofs_begin_list], rdi
  MOV [rbp - ofs_data_ref], rsi
  MOV [rbp - ofs_cmp], rdx
  MOV [rbp - ofs_free_fct], rcx

  ;  if (begin_list == NULL || cmp == NULL || free_fct ==  NULL) return;
  CMP rdi, 0
  JE .ret
  CMP rdx, 0
  JE .ret
  CMP rcx, 0
  JE .ret

  ; t_list *prev = NULL;
  MOV QWORD [rbp - ofs_prev], 0
  ; t_list *current = *begin_list;
  MOV rdi, [rbp - ofs_begin_list]
  MOV rdi, [rdi]
  MOV [rbp - ofs_current], rdi

  .loop:
    ; while (current != NULL) {
    CMP QWORD [rbp - ofs_current], 0
    JE .ret

    ; if (cmp(current->data, data_ref) == 0) {
    MOV rdi, [rbp - ofs_current]
    MOV rdi, [rdi + 0x0]
    MOV rsi, [rbp - ofs_data_ref]
    CALL [rbp - ofs_cmp]
    CMP rax, 0
    JNE .is_different

    .is_same:
      ; tmp = current;
      MOV r9, [rbp - ofs_current]
      MOV [rbp - ofs_tmp], r9
      ; current = current->next;
      MOV r9, [r9 + 0x08]
      MOV [rbp - ofs_current], r9
      
      CMP QWORD [rbp - ofs_prev], 0
      JE .prev_is_null

      ; if (prev != NULL) prev->next = current;
      MOV r8, [rbp - ofs_prev]
      MOV r9, [rbp - ofs_current]
      MOV [r8 + 0x08], r9
      JMP .after_prev_treatment

      .prev_is_null:
      ; if (prev == NULL) *begin_list = current;
        MOV r8, [rbp - ofs_current]
        MOV r9, [rbp - ofs_begin_list]
        MOV [r9], r8

      .after_prev_treatment:
        ; free_fct(tmp->data);
        MOV rdi, [rbp - ofs_tmp]
        MOV rdi, [rdi + 0x0]
        CALL [rbp - ofs_free_fct]
        ; free(tmp);
        MOV rdi, [rbp - ofs_tmp]
        CALL _free
        JMP .loop

    .is_different:
      ; prev = current;
      MOV r8, [rbp - ofs_current]
      MOV [rbp - ofs_prev], r8
      ; current = current->next;
      MOV r8, [r8 + 0x08]
      MOV [rbp - ofs_current], r8
      JMP .loop

  .ret:
    stack_frame_epilogue
    RET