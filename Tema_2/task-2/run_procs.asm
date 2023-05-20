%include "../include/io.mac"

    ;;
    ;;   TODO: Declare 'avg' struct to match its C counterpart
    ;;
struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

    ;;
struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0
    extern sort_procs
section .text
    global run_procs


run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY   ; sort processes by priority

start:

    ;; Your code starts here
    mov edi , 1
    mov esi , [ebp + 8]
    xor eax, eax


loop1:
    mov al, [esi + proc.prio]
    mov dx, [esi + proc.time]
    mov cx, [esi + proc.pid]
    cmp al, 1
    je prio1
    cmp al, 2
    je prio2
    cmp al, 3
    je prio3
    cmp al, 4
    je prio4
    cmp al, 5
    je prio5

    jmp make_avg





prio1: 
    add  [prio_result], dword 1
    add [time_result], dx
    add esi, 5
    add edi, 1
    cmp edi, ebx
    jg make_avg
    jmp loop1

prio2:
    add  [prio_result + 4], dword 1
    add  [time_result + 4], dx
    add esi, 5
    add edi, 1
    cmp edi, ebx
    jg make_avg
    jmp loop1

prio3:
    add  [prio_result + 8], dword 1
    add  [time_result + 8], dx
    add esi, 5
    add edi, 1
    cmp edi, ebx
    jg make_avg
    jmp loop1

prio4:
    add  [prio_result + 12], dword 1
    add  [time_result + 12], dx
    add esi, 5
    add edi, 1
    cmp edi, ebx
    jg make_avg
    jmp loop1

prio5:
    add  [prio_result + 16], dword 1
    add  [time_result + 16], dx
    add esi, 5
    add edi, 1
    cmp edi, ebx
    jg make_avg
    jmp loop1

make_avg:
    mov ecx, 0
    xor edi, edi
    xor edx, edx
    xor eax, eax
    mov edi, [ebp + 16]

loop_avg:    
    cmp ecx, 5
    jge end
    mov ebx, [prio_result + 4 * ecx]
    xor edx, edx
    mov eax, [time_result + 4 * ecx]
    cmp ebx, 0
    je zero
    div ebx
    mov [edi + avg_size * ecx +  avg.quo], ax
    mov [edi + avg_size * ecx +  avg.remain], dx
    inc ecx
    jmp loop_avg

zero:
    mov [edi + avg_size * ecx +  avg.quo], dword 0
    mov [edi + avg_size * ecx +  avg.remain], dword 0
    inc ecx
    jmp loop_avg

 
    ;; Your code ends here
end:   
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY