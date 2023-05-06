global _ft_write

%include "stack_frame.mac"

extern ___error

section .text

; rdi: 1st argument. fd.
; rsi: 2nd argument. buf.
; rdx: 3rd argument. nbyte.
;
; system call numbers: https://github.com/apple/darwin-xnu/blob/xnu-4903.221.2/bsd/kern/syscalls.master
;
; ===== local variables =====
; [rbp - 0x04]: error number of write()
_ft_write:
    stack_frame_prologue 0x10
    mov rax, 0x2000004   ; 2 << 24 + 4
    syscall
    jc set_errno         ; FreeBSD ではシステムコールが失敗したとき、carry flag が立つ
    stack_frame_epilogue
    ret

set_errno:
    mov [rbp - 0x04], eax
    call ___error         ; ___error() が errno を格納するアドレスを返す
    mov r8d, DWORD [rbp - 0x04]
    mov [rax], DWORD r8d
    mov rax, -1           ; ft_write() の返り値
    stack_frame_epilogue
    ret