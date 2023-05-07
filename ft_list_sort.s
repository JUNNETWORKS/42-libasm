global _ft_list_sort, _ft_list_swap

%include "stack_frame.mac"

%define ofs_begin_list 0x08
%define ofs_cmp 0x10
%define ofs_list_len 0x14
%define ofs_i 0x18
%define ofs_head 0x20
%define ofs_prev 0x28
%define ofs_current 0x30
%define ofs_tmp 0x38

section .text

; void ft_list_sort(t_list **begin_list, int (*cmp)());
;
; ===== arguments =====
; rdi: t_list **begin_list
; rsi: int (*cmp)()
;
; ===== local variables =====
; [rbp - 0x08]: t_list **begin_list
; [rbp - 0x10]: int (*cmp)()
; [rbp - 0x14]: int list_len
; [rbp - 0x18]: int i
; [rbp - 0x20]: t_list *head
; [rbp - 0x28]: t_list *prev
; [rbp - 0x30]: t_list *current
; [rbp - 0x38]: t_list *tmp
; _ft_list_sort:
  ; stack_frame_prologue 0x40

  ; MOV [rbp - ofs_begin_list], rdi
  ; MOV [rbp - ofs_cmp], rsi

  ; ; if (!begin_list || !(*begin_list) || !cmp) return;
  ; CMP rdi, 0
  ; JE .ret
  ; CMP [rdi], 0
  ; JE .ret
  ; CMP rsi, 0
  ; JE .ret

  ; ; int lst_len = ft_list_size(*begin_list);
  ; MOV r8, [rbp - ofs_begin_list]
  ; MOV rdi, [r8]
  ; CALL _ft_list_size
  ; MOV [rbp - ofs_list_len], eax

  ; ; int i = 1
  ; MOV DWORD [rbp - ofs_i], DWORD 1
  ; ; t_list *head = *begin_list;
  ; MOV r8, [rbp - ofs_begin_list] ; r8: t_list**
  ; MOV r8, [r8]                   ; r8: t_list*
  ; MOV [rbp - ofs_head], r8

  ; .loop:
    ; // if (i >= list_len) break;
    ; MOV r8d, [rbp - ofs_i]
    ; CMP r8d, [rbp - ofs_list_len]
    ; JGE .set_head_and_ret

    ; ; t_list *prev;
    ; ; t_list *current;
    ; ; prev = NULL;
    ; ; current = head;
    ; MOV QWORD [rbp - ofs_prev], 0
    ; MOV r8, [rbp - ofs_head]
    ; MOV [rbp - ofs_current], r8

    ; .loop2:
      ; ; if (current->next == 0) break;
      ; MOV r8, [rbp - ofs_current]
      ; ADD r8, 0x8
      ; CMP [r8], 0
      ; JE .end_loop2

      ; ; if (cmp(current->data, current->next->data) > 0)
      ; MOV rdi, [rbp - ofs_current] ; t_list*
      ; MOV rdi, [rdi]               ; t_list.data*
      ; MOV r8, [rbp - ofs_current]  ; t_list*
      ; ADD r8, 0x8
      ; MOV r8, [r8]                 ; t_list.next*
      ; MOV rsi, [r8]                ; t_list*
      ; CALL [rbp - ofs_cmp]
      ; CMP rax, 0
      ; JG .a_is_gt_b
      ; JLE .a_is_le_b

      ; .a_is_gt_b:
        ; ; if (current == head) {
        ; ;   head = current->next;
        ; ; }
        ; MOV r8, [rbp - ofs_current] ; t_list*
        ; MOV r8, [r8]                ; t_list.data*
        ; MOV r9, [rbp - ofs_head]    ; t_list*
        ; JNE .skip_head_assignment
        ; MOV r8, [rbp - ofs_current] ; t_list*
        ; MOV r8, [r8 + 0x8]          ; t_list.next*
        ; MOV [r9], r8

        ; .skip_head_assignment:

        ; ; t_list *tmp = current->next;
        ; MOV r8, [rbp - ofs_current] ; t_list*
        ; MOV r8, [r8 + 0x8]          ; t_list.next*
        ; MOV [rbp - ofs_tmp], r8, 

        ; ; ft_list_swap(prev, current, current->next);
        ; MOV rdi, [rbp - ofs_prev]
        ; MOV rsi, [rbp - ofs_current]
        ; MOV rdx, r8
        ; CALL _ft_list_swap

        ; ; prev = tmp;
        ; MOV r8, [rbp - ofs_tmp]
        ; MOV [rbp - ofs_prev], r8

        ; JMP .continue_loop2

      ; .a_is_le_b:
        ; ; prev = current;
        ; MOV r8, [rbp - ofs_current] ; t_list*
        ; MOV [rbp - ofs_prev], r8
        ; ; current = current->next;
        ; MOV r8, [r8 + 0x08]         ; t_list.next*
        ; MOV [rbp - ofs_current], r8
        ; JMP .continue_loop2

      ; .continue_loop2

      ; JMP .loop2

    ; .end_loop2:

    ; MOV r8d, [rbp - ofs_i]
    ; INC r8d
    ; MOV [rbp - ofs_i], r8d

    ; JMP .loop

  ; .set_head_and_ret:
    ; MOV r8, [rbp - ofs_begin_list]
    ; MOV r9, [rbp - ofs_head]
    ; MOV [r8], r9

  ; .ret:
    ; stack_frame_epilogue
    ; RET

; // current と next を入れ替える
; void ft_list_swap(t_list *prev, t_list *current, t_list *next);
;
; ===== arguments =====
; rdi: t_list *prev
; rsi: t_list *current
; rdx: t_list *next
_ft_list_swap:
  stack_frame_prologue 0x10

  ; if (prev) prev->next = next;
  CMP rdi, 0
  JE .skip1
  MOV [rdi + 0x8], rdx
  .skip1

  ; if (next) {
  ;   current->next = next->next;
  ; } else {
  ;   current->next = NULL;
  ; }
  MOV QWORD [rsi + 0x08], 0
  CMP rdx, 0
  JE .next_is_null

  MOV r8, [rdx + 0x08]
  MOV [rsi + 0x08], r8

  .next_is_null:

  ; next->next = current;
  MOV [rdx + 0x08], rsi

  stack_frame_epilogue
  ret