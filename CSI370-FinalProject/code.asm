; A program that compares various sorting algorithms written in Assembly and C++
; CSI370 - Final Project
; Author: Cameron LaBounty & Hunter Gale
; Date: 12/6/2022

_inplaceMerge PROTO

.CODE
asmBubbleSort PROC
	push rbp

	xor r8, r8
	xor r9, r9
	outerLoop:
		xor r10, r10
		innerLoop:
			mov r11d, SDWORD PTR [rcx + r10 * SDWORD]
			mov r12d, SDWORD PTR [rcx + r10 * SDWORD + SDWORD]
			cmp r11d, r12d
			ja swap
			swapDone:

			mov r13, rdx
			sub r13, r9
			dec r13

			inc r10
			cmp r10, r13
			jne innerLoop

		cmp r8, 1
		jne done
		xor r8, r8

		mov r14, rdx
		dec r14

		inc r9
		cmp r9, r14
		jne outerLoop

	swap:
		mov r8, 1
		mov [rcx + r10 * SDWORD], r12d
		mov [rcx + r10 * SDWORD + SDWORD], r11d
		jmp swapDone

	done:

	pop rbp
	ret
asmBubbleSort ENDP

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
	push rbp

	;

	pop rbp
	ret
asmSwap ENDP

END