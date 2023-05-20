%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs

sort_procs:
	;; DO NOT MODIFY
	enter 0, 0
	pusha
	
	mov edx, [ebp + 8]           ; processes
	mov eax, [ebp + 12]          ; length
	;; DO NOT MODIFY
	
	;; Your code starts here
    
start:

    mov edi, 1
    mov esi, [ebp + 8]

;;iteram prin procese
sort_procs_inner_iter:

    ;;je sort_procs_inner_iter_end
    mov al, [esi + proc.prio]
    mov dx, [esi + proc.time]
    mov cx, [esi + proc.pid]

    cmp al, [esi + 5 + proc.prio] 
    jg procs_swap
    je time_cmp
    jl sort_procs_do_nothing

;;comparam timpii
time_cmp:
    cmp dx, word [esi + 5 + proc.time]
    jg procs_swap
    jl sort_procs_do_nothing
    je id_cmp

;;comparam id-urile
id_cmp:
    cmp cx, [esi + 5 + proc.pid]
    jg procs_swap
    jle sort_procs_do_nothing

;;daca nu se intampla nimic, trecem la urmatorul proces
sort_procs_do_nothing:
    add esi, 5
    add edi, 1

    mov eax, [ebp + 12]

    cmp edi, eax   
    jge end

    jmp sort_procs_inner_iter

;;interschimbam procesele
procs_swap:
    xchg al, byte [esi + 5 + proc.prio]
    xchg dx, word [esi + 5 + proc.time]
    xchg cx, word [esi + 5 + proc.pid]
    mov byte [esi + proc.prio], al
    mov word [esi + proc.time], dx
    mov word [esi + proc.pid], cx

    jmp start
end:
	
	
	;; Your code ends here
	
	;; DO NOT MODIFY
	popa
	leave
	ret
	;; DO NOT MODIFY