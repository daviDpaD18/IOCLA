section .data
    delim db " ,.", 10, 0

global get_words
global compare_func
global sort

extern strtok
extern strcmp
extern qsort
extern strlen
extern strcpy

section .text

compare_func: 
    enter 0, 0
    push esi

    mov eax, [ebp + 8]
    mov eax, [eax]  ;; dereferentiaza primul argument
    push eax
    call strlen
    add esp, 4  ;; lungimea primului cuvant
    mov esi, eax    ;; stocheaza in esi

    mov ecx, [ebp + 12] ;; afla lungimea celui de-al doilea cuvant
    mov ecx, [ecx]  ;; dereferentiaza al doilea arg
    push ecx
    call strlen
    add esp, 4

    mov ecx, eax
    mov eax, esi
    sub eax, ecx
    jne end_compare_func     ;; scaderea da rezultat dif de zero, returneaza-l

    ;; compara lexicografic (strcmp)
    mov eax, [ebp + 12]
    push dword [eax]
    mov eax, [ebp + 8]
    push dword [eax]
    call strcmp
    add esp, 8

end_compare_func:
    pop esi

    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    ;; pune parametri pe stiva pt qsort
    push compare_func

    mov ecx, [ebp + 16]
    push ecx
    mov edx, [ebp + 12]
    push edx
    mov eax, [ebp + 8]
    push eax

    call qsort
    add esp, 16

    leave
    ret


;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    push ebx
    ;; parseaza primul cuvant
    mov ebx, [ebp + 12]
    push delim
    mov eax, [ebp + 8]
    push eax
    call strtok
    add esp, 8

    push eax
    push dword [ebx]        ;; primul cuvant din vector
    call strcpy
    add esp, 8
    add ebx, 4  ;; du te la urmatorul cuvant

    mov ecx, [ebp + 16]
    sub ecx, 1
parse_words:
    test ecx, ecx
    je got_words
    push ecx

    ;; ia urmatorul cuvant
    push delim
    xor eax, eax
    push eax        ;; 0, adica null
    call strtok
    add esp, 8

    push eax
    push dword [ebx]
    call strcpy
    add esp, 8

    pop ecx
    sub ecx, 1
    add ebx, 4
    jmp parse_words
got_words:
    pop ebx
    leave
    ret
