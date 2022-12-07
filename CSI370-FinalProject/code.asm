; A program that compares various sorting algorithms written in Assembly and C++
; CSI370 - Final Project
; Author: Cameron LaBounty & Hunter Gale
; Date: 12/7/2022

_inplaceMerge PROTO

.CODE
asmBubbleSort PROC
	push rbp
	call asmBubbleSort2
	pop rbp
	ret
asmBubbleSort ENDP

asmBubbleSort2 PROC
    push rbp                                            ; push base pointer
    sub rsp, 20h                                        ; allocate 32 bytes of shadow space

    mov [rsp + 20h], rcx                                ; store *array* in shadow space
	mov [rsp + 18h], rdx                                ; store *length* in shadow space

    xor rax, rax                                        ; set rax to 0 for outerLoop counter (i)
    outerLoop:                                          ; label for outerLoop
        xor rbx, rbx                                    ; set rbx to 0 for innerLoop counter (j)
        innerLoop:                                      ; label for innerLoop
            mov r8, [rsp + 20h]                         ; set r8 to *array*
            lea rcx, [r8 + rbx * SDWORD]                ; set rcx to the address of array[j]
            lea rdx, [r8 + rbx * SDWORD + SDWORD]       ; set rdx to the address of array[j + 1]
            mov r8d, SDWORD PTR [rcx]                   ; set r8d to the value of array[j]
            mov r9d, SDWORD PTR [rdx]                   ; set r9d to the value of array[j + 1]
            
            cmp r8d, r9d                                ; compare the value of array[j] and the value of array[j + 1]
            jbe skipSwap                                ; skip swap if array[j] <= array[j + 1]
            call asmSwap                                ; swap otherwise
            skipSwap:                                   ; label for skipping swap

            mov r8, [rsp + 18h]                         ; set r8 to *length*
            dec r8                                      ; set r8 to (*length* - 1)
            sub r8, rax                                 ; set r8 to (*length* - 1 - i)

            inc rbx                                     ; increment innerLoop counter
            cmp rbx, r8                                 ; compare the innerLoop counter and (*length* - 1 - i)
            jne innerLoop                               ; continue looping if j < (*length* - 1 - i)

        mov r8, [rsp + 18h]                             ; set r8 to *length*
        dec r8                                          ; set r8 to (*length* - 1)

        inc rax                                         ; increment outerLoop counter
		cmp rax, r8                                     ; compare the outerLoop counter and (*length* - 1)
		jne outerLoop                                   ; continue looping if i < (*length* - 1)

    add rsp, 20h                                        ; restore stack pointer
    pop rbp                                             ; pop base pointer
    ret                                                 ; return from function
asmBubbleSort2 ENDP

asmSelectionSort PROC
	push rbp

	; rcx (array)
	; rdx (N)
	; mov r9d, SDWORD PTR [rcx + r10 * SDWORD] (r9d = array[r10])

	pop rbp
	ret
asmSelectionSort ENDP

asmBucketSort PROC
	push rbp

	; rcx (array)
	; rdx (N)
	; mov r9d, SDWORD PTR [rcx + r10 * SDWORD] (r9d = array[r10])

	pop rbp
	ret
asmBucketSort ENDP

asmQuickSort PROC
	push rbp
	sub rsp, 20h

	; rcx (array)
	; rdx (start)
	; r8 (end)
	; mov r9d, SDWORD PTR [rcx + r10 * SDWORD] (r9d = array[r10])

	add rsp, 20h
	pop rbp
	ret
asmQuickSort ENDP

asmMergeSort PROC
	push rbp
	call asmMergeSortRecursive
	pop rbp
	ret
asmMergeSort ENDP

asmMergeSortRecursive PROC
	push rbp						; push base pointer
	sub rsp, 20h					; allocate 32 bytes of shadow space

	mov [rsp + 20h], rcx			; store *array* in shadow space
	mov [rsp + 18h], rdx			; store *start* in shadow space
	mov [rsp + 10h], r8				; store *end* in shadow space

	; Base Case
	cmp rdx, r8						; compare *start* and *end*
	jae done						; base case reached if (*start* >= *end*)

	; Recursive Case
	xor rdx, rdx					; set rdx to 0
	mov rax, [rsp + 18h]			; move *start* to rax
	add rax, [rsp + 10h]			; set numerator to (*start* + *end*)
	mov rcx, 2						; set denominator to 2
	div rcx							; run (*start* + *end*) / 2
	mov [rsp + 8h], rax				; store *middle* in shadow space

	mov rcx, [rsp + 20h]			; set rcx to *array*
	mov rdx, [rsp + 18h]			; set rdx to *start*
	mov r8, [rsp + 8h]				; set r8 to *middle*
	call asmMergeSortRecursive		; sort left half of the array

	mov rcx, [rsp + 20h]			; set rcx to *array*
	mov rdx, [rsp + 8h]				; set rdx to *middle*
	inc rdx							; set rdx to (*middle* + 1)
	mov r8, [rsp + 10h]				; set r8 to *end*
	call asmMergeSortRecursive		; sort right half of the array

	mov rcx, [rsp + 20h]			; set rcx to *array*
	mov rdx, [rsp + 18h]			; set rdx to *start*
	mov r8, [rsp + 8h]				; set r8 to *middle*
	mov r9, [rsp + 10h]				; set r9 to *end*
	call _inplaceMerge				; merge the two halves of the array

	done:							; label for Base Case

	add rsp, 20h					; restore stack pointer
	pop rbp							; pop base pointer
	ret								; return from function
asmMergeSortRecursive ENDP

asmSwap PROC
    push rbp            ; push base pointer
    mov [rcx], r9d      ; move the value of *num2* to the address of *num1*
    mov [rdx], r8d      ; move the value of *num1* to the address of *num2*
    pop rbp             ; pop base pointer
    ret                 ; return from function
asmSwap ENDP

END