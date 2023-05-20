%include "../include/io.mac"
;;aceeasi ca anul trecut din tema mea , din tema 2
section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here

    ; pt a indexa cu ecx, se parcurg vectorii de la final la inceput
encrypt:
    mov al, byte [esi + ecx - 1]
    add al, dl  ;; adauga step-ul
    cmp al, 90  ;; compara cu Z
    jle lower_than_Z
    sub al, 26
lower_than_Z:
    ; pune caracterul in string, pe pozitie
    mov byte [edi + ecx - 1], al
    ; treci la urmatorul caracter
    loop encrypt
    ;; Your code ends here
    
    ;; DO NOT MODIFY


    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
