
section .data

section .text
	global checkers

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE
start:
    mov esi,eax
    mov edi,ebx
    cmp esi,0
    je latura_jos
    cmp esi,7
    je latura_sus
    cmp edi,0
    je stanga
    cmp edi,7
    je dreapta
    jmp mijloc

;;piesa e in mijloc dar am facut cv gresit

mijloc:
    mov edx, esi
    add ebx, 1
    mov ebp,edx
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    sub ebp, 2
    imul ebp, 8
    add ebp, ebx
    mov byte [ecx + ebp], 1
    ;;sub ebx, 2
    ;;add edx, ebx
    ;;mov byte [ecx + edx], 1
    ;;mov byte [ecx + ebp], 1

;;piesa e pe latura din dreapta
dreapta:
    mov edx, esi
    sub ebx, 1
    add edx, 1
    mov ebp,edx
    imul edx, 8
    add edx, ebp
    mov byte [ecx + edx], 1
    sub ebp, 2
    imul ebp, 8
    add ebp, ebx
    mov byte [ecx + ebp], 1
    jmp end
;;piesa e pe latura din stanga
stanga: 
    mov edx, esi
    add ebx, 1
    add edx, 1
    mov ebp,edx
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    sub ebp, 2
    imul ebp, 8
    add ebp, ebx
    mov byte [ecx + ebp], 1
    jmp end
;;piesa e pe latura de sus
latura_sus:
    cmp edi,0
    ;;e stanga sus
    je stanga_sus
    cmp edi,7
    ;;e dreapta sus
    je dreapta_sus
    ;;e sus dar nu e in colturi
    jmp sus
;;sus la mijloec
sus:
    mov edx, esi
    dec edx
    add ebx, 1
    mov ebp, edx
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    sub ebp, 2
    imul ebp, 8
    add ebp, ebx
    mov byte [ecx + ebp], 1
    jmp end
;;coltul stanga sus
stanga_sus:
    mov edx, esi
    sub edx, 1
    add ebx, 1
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    jmp end
;;dreapta sus
dreapta_sus:
    mov edx, esi
    dec edx
    sub ebx, 1
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    jmp end

;;
latura_jos:
    cmp edi,0 
    ;;e stanga jos
    je stanga_jos
    cmp edi,7
    ;;e dreapta jos
    je dreapta_jos
    ;;e jos dar nu e in colturi
    jmp jos

;;latura jos la mijloc
jos:
    mov edx, esi
    inc edx
    add ebx, 1
    mov ebp, edx
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    sub ebp, 2
    imul ebp, 8
    add ebp, ebx
    mov byte [ecx + ebp], 1
    jmp end
;;coltul stanga jos
stanga_jos:    
    mov edx, esi
    inc edx
    add ebx, 1
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    jmp end
;;coltul dreapta jos  
dreapta_jos:
    mov edx, esi
    inc edx
    sub ebx, 1
    imul edx, 8
    add edx, ebx
    mov byte [ecx + edx], 1
    jmp end
    ;; FREESTYLE ENDS HERE

end:    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY