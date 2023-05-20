section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	xor eax, eax
	xor ecx, ecx
	add eax, [esp + 4]
	add ecx, [esp + 8]	; ia a si b de pe stiva
	;; aplica algoritmul lui euclid, in mod iterativ, pentru a afla intai cmmdc

	;; asigura-te ca a > b
	cmp eax, ecx
	jge start_gcd
	xchg eax, ecx

start_gcd:
	;; repeta cat timp b este mai mare decat zero
	cmp ecx, 0
	jz stop_gcd
	push ecx
	
	push dword 0
	pop edx	;; zeroizeaza edx pt impartire
	div ecx	;; edx contine a%b
	mov ecx, edx	;; b = r
	pop eax
	jmp start_gcd

stop_gcd:
	;; cmmdc e in eax
	push eax
	xor eax, eax
	xor ecx, ecx
	add eax, [esp + 8]
	add ecx, [esp + 12]	; ia a si b de pe stiva
	xor edx, edx
	mul ecx		;; a * b
	pop ecx		;; scoate cmmdc de pe stiva
	xor edx, edx
	div ecx

	ret
