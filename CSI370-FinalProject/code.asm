; A program that compares various sorting algorithms written in Assembly and C++
; CSI370 - Final Project
; Author: Cameron LaBounty & Hunter Gale
; Date: 12/7/2022

_randomIndex PROTO

.CODE
asmBubbleSort PROC
    push rbp                                            ; push base pointer
    sub rsp, 30h                                        ; allocate 32 bytes of shadow space

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

    add rsp, 30h                                        ; restore stack pointer
    pop rbp                                             ; pop base pointer
    ret                                                 ; return from function
asmBubbleSort ENDP

asmSelectionSort PROC
	push rbp
	mov rbp, rsp
	sub rsp, 30h					; 20h for shadow, other 10h for params?

	mov [rsp + 20h], rcx			; store *array* in shadow space
	mov [rsp + 18h], rdx			; store *length* in shadow space

	mov r10, 0						; i starts at 0 for outer loop
	mov r11, [rsp + 18h]			; move length to r11
	dec r11							; r11 = (length - 1)

	selectionOuterLoop:
		cmp r10, r11					; if i >= (length - 1), loop terminates
		jge done

		mov r12, r10					; move i into minIndex (r12)
		mov r13, r10					; j = i
		inc r13							; j = (i + 1)
		selectionInnerLoop:
			cmp r13, [rsp + 18h]			; if j >= length, loop terminates
			jge selectionInnerLoopDone

			mov r8, [rsp + 20h]				; move array into r8
			lea rcx, [r8 + r13 * SDWORD]	; address of j index
			lea rdx, [r8 + r12 * SDWORD]	; address of minIndex
			mov r14d, SDWORD PTR [rcx]      ; set r14d to the value at array[j]
			mov r15d, SDWORD PTR [rdx]      ; set r15d to the value at array[minIndex]
			cmp r14d, r15d					; if array[j] >= array[minIndex], skip inner statement
			jge skipInnerStatement

				mov r12, r13					; minIndex = j

			skipInnerStatement:

			inc r13							; j++
			jmp selectionInnerLoop			; restart inner loop
		selectionInnerLoopDone:

		mov r8, [rsp + 20h]				; move array into r8
		lea rcx, [r8 + r10 * SDWORD]	; address of i index
		lea rdx, [r8 + r12 * SDWORD]	; address of minIndex
		call asmSwap					; swap(array[i], array[minIndex])

		inc r10							; i++ for next iteration
		jmp selectionOuterLoop			; restart the outer loop

	done:
	mov rsp, rbp
	pop rbp
	ret
asmSelectionSort ENDP

asmShellSort PROC
	push rbp
	mov rbp, rsp
	sub rsp, 30h					; 20h for shadow, other 10h for params?

	mov [rsp + 20h], rcx			; store *array* in shadow space
	mov [rsp + 18h], rdx			; store *length* in shadow space

									; calculate starting gap
	mov rdx, 0						; load rdx:rax with the dividend, length
	mov rax, [rsp + 18h]
	mov rcx, 2						; load rcx with the divisor, 2
	div rcx							; quotient in rax
	mov [rsp + 10h], rax			; store on the stack

	outerLoop:						; label for outer loop
		cmp rax, 0						; if gap == 0, loop terminates
		je shellDone
	

		mov r10, [rsp + 10h]			; i starts as the value of gap
		middleLoop:
			cmp r10, [rsp + 18h]			; if i >= length, loop terminates
			jae middleLoopDone


											; Saving array[i] as "temp"
			mov r8, [rsp + 20h]				; move array into r8
			lea rcx, [r8 + r10 * SDWORD]	; address of i index
			mov r12d, SDWORD PTR [rcx]      ; set r12d to the value at array[i] (aka temp)

			mov r11, r10					; j starts at value of i
			innerLoop:
				cmp r11, [rsp + 10h]			; if j < gap, loop terminates
				jl innerLoopDone
												; Additionally, if array[j - gap] <= temp, loop terminates
												; First, get array[j - gap]
				mov rbx, r11					; move j into rbx
				sub rbx, [rsp + 10h]			; subtract gap from rbx
				mov r8, [rsp + 20h]				; move array into r8
				lea rcx, [r8 + rbx * SDWORD]	; address of i index
				mov r13d, SDWORD PTR [rcx]      ; set r13d to the value at array[j - gap]
				cmp r13d, r12d					; if array[j - gap] <= temp, loop terminates
				jle innerLoopDone

				mov r8, [rsp + 20h]				; move array into r8 (ik it's redudant)
				lea rcx, [r8 + r11 * SDWORD]	; move address of array[j] into rcx
				mov [rcx], r13d					; move the value of array[j - gap] to address of array[j]

				sub r11, [rsp + 10h]			; j -= gap
				jmp innerLoop					; restart inner loop

			innerLoopDone:
											; put temp in its correct location
			mov r8, [rsp + 20h]				; move array into r8 (ik it's redudant)
			lea rcx, [r8 + r11 * SDWORD]	; move address of array[j] into rcx
			mov [rcx], r12d					; move the value of temp to address of array[j]

			inc r10							; i++
			jmp middleLoop					; then restart the loop

		middleLoopDone:


										; calculate the new gap
		mov rdx, 0						; load rdx:rax with the dividend, old gap
		mov rax, [rsp + 10h]
		mov rcx, 2						; load rcx with the divisor, 2
		div rcx							; quotient in rax
		mov [rsp + 10h], rax			; store on the stack
		jmp outerLoop					; go back to outer loop


	shellDone:
	mov rsp, rbp
	pop rbp
	ret
asmShellSort ENDP

asmQuickSort PROC
	push rbp
	call asmQuickSortRecursive
	pop rbp
	ret
asmQuickSort ENDP

asmQuickSortRecursive PROC
	push rbp
	sub rsp, 20h

	mov [rsp + 20h], rcx			; store *array* in shadow space
	mov [rsp + 18h], rdx			; store *start* in shadow space
	mov [rsp + 10h], r8				; store *end* in shadow space

	cmp rdx, r8						; check for base case (start >= end)
	jge quickDone					; jump to end of function

	mov rcx, rdx					; move start to rcx
	mov rdx, r8						; move end to rdx
	call _randomIndex				; get random index in range

									; prepare for moving the pivot to start
	mov r8, [rsp + 20h]				; move array into r8
	mov rbx, [rsp + 18h]			; move start into rbx
	lea rcx, [r8 + rax * SDWORD]	; address of random index
	lea rdx, [r8 + rbx * SDWORD]	; address of starting index
	call asmSwap					; move the pivot to the start

									; setup for loop to swap elements smaller than the pivot
									; with the first element that is larger than it
	mov rbx, [rsp + 18h]			; move start into rbx to keep track of "lastSmaller"
	mov rax, rbx					; move start into rax for counter
	inc rax							; i starts at start + 1

	quickLoop:						; start of the loop
		cmp rax, [rsp + 10h]			; loop will run if (i <= end)
		ja endLoop						; jump to end of the loop
	
										; start setup for "if" statement
										; checking if (array[i] < array[start])
		mov r8, [rsp + 20h]				; move array into r8
		mov r11, [rsp + 18h]			; move start into r11
		lea rcx, [r8 + rax * SDWORD]	; address of index i
		lea rdx, [r8 + r11 * SDWORD]	; address of start
		mov r8d, SDWORD PTR [rcx]       ; set r8d to the value of index i
		mov r9d, SDWORD PTR [rdx]       ; set r9d to the value of start
		cmp r8d, r9d					; if (array[i] < array[start])
		jae skip						; if not, jump to skip

													; prepare for swap(array[i], array[lastSmaller + 1])
			mov r8, [rsp + 20h]						; move array into r8
			lea rcx, [r8 + rax * SDWORD]			; address of index i
			lea rdx, [r8 + rbx * SDWORD + SDWORD]	; address of lastSmaller + 1
			push rbx								; temp push rbx to stack so we can get it after swap
			call asmSwap							; swap(array[i], array[lastSmaller + 1])
			pop rbx									; get rbx (lastSmaller) back

			inc rbx							; inc lastSmaller

		skip:							; label for end of "if" statement

		inc rax							; inc i for the loop
		jmp quickLoop					; start the loop again
	
	endLoop:						; label for end of loop			

	mov [rsp + 8h], rbx				; store lastSmaller in shadow Space

									;move parameters for quicksort function into registers
	mov r8, [rsp + 20h]
	mov rbx, [rsp + 18h]
	mov r11, [rsp + 8h]
	lea rcx, [r8 + rbx * SDWORD]	; address of start index
	lea rdx, [r8 + r11 * SDWORD]	; address of lastSmaller
	call asmSwap

									;move parameters for quicksort function into registers
	mov rcx, [rsp + 20h]
	mov rdx, [rsp + 18h]
	mov r8, [rsp + 8h]
	dec r8
	call asmQuickSortRecursive		;quickSort(array, start, lastSmaller - 1)

	mov rcx, [rsp + 20h]
	mov rdx, [rsp + 8h]
	mov r8, [rsp + 10h]
	inc rdx
	call asmQuickSortRecursive		;quickSort(array, lastSmaller + 1, end)

	quickDone:
	add rsp, 20h
	pop rbp
	ret
asmQuickSortRecursive ENDP

asmMergeSort PROC
	push rbp
	call asmMergeSortRecursive
	pop rbp
	ret
asmMergeSort ENDP

asmMergeSortRecursive PROC
	push rbp						; push base pointer
	sub rsp, 30h					; allocate 48 bytes of shadow space

	mov [rsp + 28h], rcx			; store *array* in shadow space
	mov [rsp + 20h], rdx			; store *temp* in shadow space
	mov [rsp + 18h], r8				; store *start* in shadow space
	mov [rsp + 10h], r9				; store *end* in shadow space

	; Base Case
	cmp r8, r9						; compare *start* and *end*
	jae mergeDone						; base case reached if (*start* >= *end*)

	; Recursive Case
	xor rdx, rdx					; set rdx to 0
	mov rax, [rsp + 18h]			; move *start* to rax
	add rax, [rsp + 10h]			; set numerator to (*start* + *end*)
	mov rcx, 2						; set denominator to 2
	div rcx							; run (*start* + *end*) / 2
	mov [rsp + 8h], rax				; store *middle* in shadow space

	mov rcx, [rsp + 28h]			; set rcx to *array*
	mov rdx, [rsp + 20h]			; set rdx to *temp*
	mov r8, [rsp + 18h]				; set r8 to *start*
	mov r9, [rsp + 8h]				; set r9 to *middle*
	call asmMergeSortRecursive		; sort left half of the array

	mov rcx, [rsp + 28h]			; set rcx to *array*
	mov rdx, [rsp + 20h]			; set rdx to *temp*
	mov r8, [rsp + 8h]				; set r8 to *middle*
	inc r8							; set r8 to (*middle* + 1)
	mov r9, [rsp + 10h]				; set r9 to *end*
	call asmMergeSortRecursive		; sort right half of the array

	mov rcx, [rsp + 28h]			; set rcx to *array*
	mov rdx, [rsp + 20h]			; set rdx to *temp*
	mov r8, [rsp + 18h]				; set r8 to *start*
	mov r9, [rsp + 10h]				; set r9 to *end*
	mov r10, [rsp + 8h]				; set r10 to *middle*
	call asmInplaceMerge			; merge the two halves of the array

	mergeDone:							; label for Base Case

	add rsp, 30h					; restore stack pointer
	pop rbp							; pop base pointer
	ret								; return from function
asmMergeSortRecursive ENDP

asmSwap PROC
    push rbp					; push base pointer
	mov r8d, SDWORD PTR [rcx]	; set r8d to the value at address rcx
	mov r9d, SDWORD PTR [rdx]	; set r9d to the value at address rdx
    mov [rcx], r9d				; move the value of *num2* to the address of *num1*
    mov [rdx], r8d				; move the value of *num1* to the address of *num2*
    pop rbp						; pop base pointer
    ret							; return from function
asmSwap ENDP

asmInplaceMerge PROC
	; rcx to *array*
	; rdx to *temp*
	; r8 to *leftStart*
	; r9 to *rightEnd*
	; r10 to *leftEnd*
	; r11 to *rightStart*
	; r12 to *size*
	; r13 to *left*
	; r14 to *right*
	; r15 to *index*

	push rbp					; push base pointer

	mov r11, r10
	inc r11

	mov r12, r9
	sub r12, r8
	inc r12

	mov r13, r8
	mov r14, r11
	mov r15, r8

	asmInplaceMergeLoop:
		mov eax, SDWORD PTR [rcx + r13 * SDWORD]	; array[left]
		mov ebx, SDWORD PTR [rcx + r14 * SDWORD]	; array[right]

		cmp eax, ebx
		jbe leftLower
		jmp rightLower

		leftLower:
			mov [rdx + r15 * SDWORD], eax
			inc r13
			jmp testing
		rightLower:
			mov [rdx + r15 * SDWORD], ebx
			inc r14
			jmp testing

		testing:

		inc r15

		cmp r13, r10
		ja copyRightRemainder
		cmp r14, r9
		ja copyLeftRemainder
		jmp asmInplaceMergeLoop

	copyRightRemainder:
		mov ebx, SDWORD PTR [rcx + r14 * SDWORD]	; array[right]
		mov [rdx + r15 * SDWORD], ebx

		inc r15
		inc r14
		cmp r14, r9
		jbe copyRightRemainder
	jmp mergeDone

	copyLeftRemainder:
		mov eax, SDWORD PTR [rcx + r13 * SDWORD]	; array[left]
		mov [rdx + r15 * SDWORD], eax

		inc r15
		inc r13
		cmp r13, r10
		jbe copyLeftRemainder

	mergeDone:

	mov r15, r8

	copyTempToArray:
		mov eax, SDWORD PTR [rdx + r15 * SDWORD]
		mov [rcx + r15 * SDWORD], eax

		inc r15
		cmp r15, r9
		jne copyTempToArray
		
	pop rbp						; pop base pointer
    ret							; return from function
asmInplaceMerge ENDP

END