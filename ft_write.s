global _ft_write

extern __error;

section .text

; rdi: 1st argument. fd.
; rsi: 2nd argument. buf.
; rdx: 3rd argument. nbyte.
;
; system call numbers: https://github.com/apple/darwin-xnu/blob/xnu-4903.221.2/bsd/kern/syscalls.master
_ft_write:
    mov rax, 0x2000004   ; 2 << 24 + 4
    syscall
    jb error
    move errno, rax;
    move rax, -1;
    ret

set_error:
    mov r8, rax
    call __error         ; __error() が errno を格納するアドレスを返す
    mov [rax], r8