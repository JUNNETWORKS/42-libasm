global _ft_write

extern ___error

section .text

; rdi: 1st argument. fd.
; rsi: 2nd argument. buf.
; rdx: 3rd argument. nbyte.
;
; system call numbers: https://github.com/apple/darwin-xnu/blob/xnu-4903.221.2/bsd/kern/syscalls.master
_ft_write:
    mov rax, 0x2000004   ; 2 << 24 + 4
    syscall
    jc set_errno         ; FreeBSD ではシステムコールが失敗したとき、carry flag が立つ
    ret

set_errno:
    push rax
    call ___error         ; ___error() が errno を格納するアドレスを返す
    pop qword[rax]
    mov rax, -1           ; ft_write() の返り値
    ret