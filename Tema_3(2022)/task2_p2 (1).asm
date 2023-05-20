section .text
	global par

clean_stack_and_bail:
	;; se ajunge aici daca sirul e invalid
	pop ecx
	cmp ecx, 0
	jne clean_stack_and_bail
	push dword 0
	pop eax
	ret
;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	xor edx, edx
	add edx, [esp + 8]
	xor ecx, ecx
	add ecx, [esp + 4]
	push dword 0

loop_par:
	cmp byte[edx], '('
	je push_bracket
	;; urmatoarea paranteza e inchisa
	cmp dword [esp], 0
	je clean_stack_and_bail
	add esp, 4
	jmp next_char

push_bracket:
	push dword 1

next_char:
	inc edx
	loop loop_par

	;; s-a procesat sirul, verifica daca stiva e goala
	pop ecx
	cmp ecx, 0	;; baza stivei
	jne clean_stack_and_bail
	push dword 1
	pop eax
	ret
