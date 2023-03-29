; Parameterübergabe in x86-x64 Assembler [NASM] unter Linux
; 
; Anhand dieses Beispielprogramms soll Call by value & Call by reference erläutert werden


section   .data
                msg1:        db        "Call by Referenz", 0x0A     
                len1:     equ $-msg1  
                msg2:        db	       "Call by value", 0x0A
                len2:     equ $-msg2                                               
                       
                x  dq 0x05                                                                 

section .text

global _start
_start:

; Main Funktion	------------------------------------------------

main:
 push rbp               ;	Stackframe der Main-Funktion initialisieren
 mov rbp, rsp					

; Call by Reference
test1:    												
 mov rdi, x							
 call byreference       ;	byreference(&x);
 cmp rax, 0x19						  
 jne test2							
 mov rsi, msg1						
 mov rdx, len1						
 push rdx							
 push rsi							
 call write							
	 	
; Call by Value	
test2:									
 mov rdi, 4							
 call byvalue           ;	y= byvalue(4)
 cmp rax, 0x10						
 jne end								  
 mov rsi, msg2							
 mov rdx, len2						
 push rdx							
 push rsi							
 call write							          
                
; Ende der Mainfunktion                
end: 
 mov rsp, rbp
 pop rbp							
 mov rax, 60            ; Sys_exit             
 mov rdi, 0             ; return (0)
 syscall                                        
		
; ----------------------------------------------------------------		
               
              
; printf:               
write:		
 push rbp							    
 mov rbp, rsp						  
 mov rax, 1           ;  Sys_write
 mov rdi, 1           ;  Filedrescriptor 1 : stdoutput
 mov rsi, [rbp+16]    ;  rsi = adresse des Strings
 mov rdx, [rbp+24]    ;  rdi = länge des Strings                                                   
 syscall								
 pop rbp								
 ret									

;---------------------------------
; byreference:					
; int x = 5;					
; byreference (&x);				


;  byreference( int * ptr)		
;	{							
;		(*ptr) *= (*ptr);		
;	}							
;---------------------------------

byreference:	
 push rbp
 mov rbp, rsp
 mov eax, dword [rdi]       ; eax = *ptr;
 mov edi, eax						
 imul eax, edi						
 mov dword [rdi], eax       ; *ptr = eax;									
 pop rbp
 ret


;---------------------------------
; byvalue:						
; int y = 4						
; y = byvalue(y);			    			


; byvalue(int val)				
; {								
;	val *= val;					
;	return (val);				
; }								
;---------------------------------	
byvalue:								
	push rbp							 
	mov rbp, rsp						
	mov eax, edi						 
	imul eax, eax           ; y= y * y;
	pop rbp                 ; returnwert in rax
	ret									


; ******************************EOF**************************************
