; ------------------------------------------------------
; print Funktion in x86-x64 Asm [Nasm] unter Linux     *
;                                                      *
; Zählt die Länge eines Nullterminierten Strings       *
; um diesen anschließend auszugeben                    *
; ------------------------------------------------------

mov rdi, string
call _print_nt

_print_nt:

 push rbp
 mov rbp, rsp
 sub rsp, 8
 mov qword[rbp-8], rdi
 mov rcx, 0              ; Counter
 mov bl, byte [rdi]  
 cmp bl, 0               ; Teste auf 0
 je _End_print_nt
  
_calclen:
 inc rdi ; nächster charakter
 inc rcx	; fuer Laenge
 mov bl, byte [rdi]  
 cmp bl, 0 ; Teste auf 0
 jne _calclen	
 mov rax, 1  ; Sys_write
 mov rdi, 1
 mov rsi, qword [rbp-8]  ; Adresse des Strings
 mov rdx, rcx            ; Länge des Strings
 syscall
		
_End_print_nt:	
  mov rsp, rbp
  pop rbp
  ret
