section .text
	global sort

sort:
	enter 0, 0

	mov ecx, [ebp + 8]	;n
	mov ebx, [ebp + 12]	;primul element
	
	
find_first:				;caut primul element
	mov esi, dword[ebx + ecx * 8]
	cmp esi, 1
	je found
	loop find_first

	;salvez pe stiva adresa elementului gasit 
found:
	lea eax, [ebx + ecx * 8]
	push eax	;salvez adresa primului nod pe stiva

	
find_next:		;modific campul next al fiecarui element
	inc esi		;elementul precedent + 1 devine elementul cautat
	mov edi, 0	;contor
	cmp edi , ecx
	jg exit

update_address:
	inc edi
	cmp esi, dword[ebx + (edi - 1) * 8]
	jne update_address
	lea eax, [ebx + (edi - 1) * 8]	;adresa nodului dorit
	mov [ebx + ecx * 8 + 4], eax	;actualizez campul next al elementului curent
	cmp esi, dword[ebp + 8]		;verific daca elementul cautat e ultimul
	je exit
	dec edi
	mov ecx, edi
	inc edi
	jmp find_next
	;nodul cautat devine nodul curent si repet

exit:
	pop eax		;iau adresa nodului cu valoarea 1
	leave
	ret