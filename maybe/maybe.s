BITS 64
GLOBAL _start
SECTION .text

__NR_exit: dd 1
__NR_write: dd 4

msg:
    db "Micro true.", 10, 10, "Usage: [--help] [other options ignored]", 10

; register allocation: rax, rdi, rsi, rdx needed for syscalls,
; reserved: rcx, r11, rax,
; available: r8, r9, r10, r11, r12, r13, r14

_start:
    pop r8          ; argc
    cmp r8, 1       ; == 1?
    je done         ; if so, we're done, otherwise...

    ; definitions:
    mov r9, 0x00706c65682d2d00 ; "--help\0" << 8

    ; argument parsing:
    pop r10         ; first kill the app name
    pop r11         ; then grab the first argument's address
    mov r12, [r11]  ; load its first eight bytes directly into the register
    shl r12, 8      ; << 8

    cmp r9, r12     ; see if we got our --help
    jne done        ; if not, just exit

    ; printing help:
    mov rax, 1      ; write
    mov rdi, 1      ; ..to stdout
    mov rsi, msg    ; ..our message
    mov rdx, 53     ; ..which is this long
    syscall         ; ..please

done:
    mov rax, 60     ; exit
    xor rdi, rdi    ; ..with zero
    syscall         ; ..please
