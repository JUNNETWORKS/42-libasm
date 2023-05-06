global _ft_read

extern ___error

%include "stack_frame.mac"

section .text

; rdi: 1st argument. fd.
; rsi: 2nd argument. buf.
; rdx: 3rd argument. nbyte.
;
; system call numbers: https://github.com/apple/darwin-xnu/blob/xnu-4903.221.2/bsd/kern/syscalls.master
;
; ===== local variables =====
; [rbp - 0x04]: error number of read()
_ft_read:
    stack_frame_prologue 0x10
    mov rax, 0x2000003   ; 2 << 24 + 3
    syscall
    jc set_errno         ; FreeBSD ではシステムコールが失敗したとき、carry flag が立つ
    stack_frame_epilogue
    ret

set_errno:
    mov [rbp - 0x04], eax
    call ___error         ; ___error() が errno を格納するアドレスを返す
    mov r8d, DWORD [rbp - 0x04]
    mov [rax], DWORD r8d
    mov rax, -1           ; ft_read() の返り値
    stack_frame_epilogue
    ret