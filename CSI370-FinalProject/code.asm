; A program that compares various sorting algorithms written in Assembly and C++
; CSI370 - Final Project
; Author: Cameron LaBounty & Hunter Gale
; Date: 12/4/2022

.CODE
asmBubbleSort PROC
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
	ret
asmBubbleSort ENDP

asmSelectionSort PROC
	; rcx (array)
	; rdx (N)
	; mov r9d, SDWORD PTR [rcx + r10 * SDWORD] (r9d = array[r10])
	ret
asmSelectionSort ENDP

asmBucketSort PROC
	; rcx (array)
	; rdx (N)
	; mov r9d, SDWORD PTR [rcx + r10 * SDWORD] (r9d = array[r10])
	ret
asmBucketSort ENDP

asmQuickSort PROC
	; rcx (array)
	; rdx (start)
	; r8 (end)
	; mov r9d, SDWORD PTR [rcx + r10 * SDWORD] (r9d = array[r10])
	ret
asmQuickSort ENDP

asmMergeSort PROC
	; rcx (array)
	; rdx (start)
	; r8 (end)
	; mov r9d, SDWORD PTR [rcx + r10 * SDWORD] (r9d = array[r10])
	ret
asmMergeSort ENDP
END