BITS 64
GLOBAL _start
SECTION .text
_start:
	mov rax, 1
	int 0x80

