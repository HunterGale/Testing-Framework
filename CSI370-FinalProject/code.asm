; A program that compares various sorting algorithms written in Assembly and C++
; CSI370 - Final Project
; Author: Cameron LaBounty & Hunter Gale
; Date: 12/12/2022

_randomInRange PROTO

.CODE
asmBubbleSort PROC
    push rbp                                            ; push base pointer
	mov rbp, rsp										; move stack pointer to the base pointer
    sub rsp, 30h                                        ; allocate 48 bytes of shadow space

    mov [rsp + 20h], rcx                                ; store array in shadow space
	mov [rsp + 18h], rdx                                ; store length in shadow space

    xor rax, rax                                        ; set rax to 0 for outerLoop counter (i)
    bubbleOuterLoop:                                    ; label for outerLoop
        xor rbx, rbx                                    ; set rbx to 0 for innerLoop counter (j)
        bubbleInnerLoop:                                ; label for innerLoop
            mov r8, [rsp + 20h]                         ; set r8 to array
            lea rcx, [r8 + rbx * SDWORD]                ; set rcx to the address of array[j]
            lea rdx, [r8 + rbx * SDWORD + SDWORD]       ; set rdx to the address of array[j + 1]
            mov r9d, SDWORD PTR [rcx]                   ; set r9d to the value of array[j]
            mov r10d, SDWORD PTR [rdx]                  ; set r10d to the value of array[j + 1]
            
            cmp r9d, r10d                               ; compare the value of array[j] and the value of array[j + 1]
            jbe skipSwap                                ; skip swap if array[j] <= array[j + 1]
            call asmSwap                                ; swap otherwise
            skipSwap:                                   ; label for skipping swap

            mov r8, [rsp + 18h]                         ; set r8 to length
            dec r8                                      ; set r8 to (length - 1)
            sub r8, rax                                 ; set r8 to (length - 1 - i)

            inc rbx                                     ; increment j
            cmp rbx, r8                                 ; compare the j and (length - 1 - i)
            jne bubbleInnerLoop                         ; continue looping if j < (length - 1 - i)

        mov r8, [rsp + 18h]                             ; set r8 to length
        dec r8                                          ; set r8 to (length - 1)

        inc rax                                         ; increment i
		cmp rax, r8                                     ; compare i and (length - 1)
		jne bubbleOuterLoop                             ; continue looping if i < (length - 1)

    mov rsp, rbp                                        ; restore stack pointer
    pop rbp                                             ; pop base pointer
    ret                                                 ; return from function
asmBubbleSort ENDP

asmSelectionSort PROC
	push rbp											; push base pointer
	mov rbp, rsp										; move stack pointer to the base pointer
	sub rsp, 30h										; allocate 48 bytes of shadow space

	mov [rsp + 20h], rcx								; store array in shadow space
	mov [rsp + 18h], rdx								; store length in shadow space

	xor r10, r10										; set r10 to 0 for outerLoop counter (i)
	mov r11, [rsp + 18h]								; move length to r11
	dec r11												; set r11 to (length - 1)

	selectionOuterLoop:									; label for outer loop
		mov r12, r10									; move i into minIndex (r12)
		mov r13, r10									; j = i
		inc r13											; j = (i + 1)
		selectionInnerLoop:								; label for outer loop
			mov r8, [rsp + 20h]							; move array into r8
			mov r14d, SDWORD PTR [r8 + r13 * SDWORD]	; set r14d to the value at array[j]
			mov r15d, SDWORD PTR [r8 + r12 * SDWORD]    ; set r15d to the value at array[minIndex]
			cmp r14d, r15d								; compare array[j] and array[minIndex]
			jge skipInnerStatement						; skip inner statement if array[j] >= array[minIndex]

			mov r12, r13								; set minIndex to j
			skipInnerStatement:							; label for skipping inner statement

			inc r13										; increment j
			cmp r13, [rsp + 18h]						; compare j and length
			jne selectionInnerLoop						; continue looping if j < length

		mov r8, [rsp + 20h]								; move array into r8
		lea rcx, [r8 + r10 * SDWORD]					; set rcx to the address of array[i]
		lea rdx, [r8 + r12 * SDWORD]					; set rdx to the address of array[minIndex]
		call asmSwap									; swap(array[i], array[minIndex])

		inc r10											; increment i
		cmp r10, r11									; compare i and (length - 1)
		jne selectionOuterLoop							; continue looping if i < (length - 1)

	mov rsp, rbp                                        ; restore stack pointer
    pop rbp                                             ; pop base pointer
    ret                                                 ; return from function
asmSelectionSort ENDP

asmShellSort PROC
	push rbp												; push base pointer
	mov rbp, rsp											; move stack pointer to the base pointer
	sub rsp, 30h											; allocate 48 bytes of shadow space

	mov [rsp + 20h], rcx									; store array in shadow space
	mov [rsp + 18h], rdx									; store length in shadow space

	; Calculate Starting Gap
	xor rdx, rdx											; set rdx to 0
	mov rax, [rsp + 18h]									; move length to rax
	mov rcx, 2												; set denominator to 2
	div rcx													; store gap in rax

	shellOuterLoop:											; label for outer loop
		cmp rax, 0											; compare gap and 0
		jbe shellDone										; loop breaks if gap <= 0

		mov r10, rax										; middle loop counter (i) starts as the value of gap
		shellMiddleLoop:									; label for middle loop
			mov r8, [rsp + 20h]								; move array into r8
			mov r12d, SDWORD PTR [r8 + r10 * SDWORD]		; set r12d to the value at array[i]

			mov r11, r10									; inner loop counter (j) starts at the value of i
			shellInnerLoop:									; label for inner loop
				mov rbx, r11								; move j into rbx
				sub rbx, rax								; subtract gap from rbx
				mov r8, [rsp + 20h]							; move array into r8
				mov r13d, SDWORD PTR [r8 + rbx * SDWORD]	; set r13d to the value at array[j - gap]
				mov [r8 + r11 * SDWORD], r13d				; move the value of array[j - gap] to address of array[j]

				cmp r11, rax								; compare j and gap
				jl shellInnerLoopDone						; loop breaks if j < gap

				cmp r13d, r12d								; compare array[j - gap] and temp
				jle shellInnerLoopDone						; loop breaks if array[j - gap] <= temp

				sub r11, rax								; decrement j by gap
				jmp shellInnerLoop							; go back to inner loop

			shellInnerLoopDone:								; label for breaking out of inner loop

			mov r8, [rsp + 20h]								; move array into r8
			mov [r8 + r11 * SDWORD], r12d					; move the value of temp to address of array[j]

			inc r10											; increment i
			cmp r10, [rsp + 18h]							; compare i and length
			jne shellMiddleLoop								; continue looping if i < length

		; Calculate New Gap
		xor rdx, rdx										; set rdx to 0
		mov rcx, 2											; set denominator to 2
		div rcx												; store new gap in rax
		jmp shellOuterLoop									; go back to outer loop

	shellDone:												; label for breaking out of outer loop

	mov rsp, rbp											; restore stack pointer
    pop rbp													; pop base pointer
    ret														; return from function
asmShellSort ENDP

asmQuickSort PROC
	push rbp										; push base pointer
	mov rbp, rsp									; move stack pointer to the base pointer
	sub rsp, 30h									; allocate 48 bytes of shadow space

	mov [rsp + 20h], rcx							; store array in shadow space
	mov [rsp + 18h], rdx							; store start in shadow space
	mov [rsp + 10h], r8								; store end in shadow space

	; Base Case
	cmp rdx, r8										; compare start and end
	jae quickDone									; base case reached if start >= end

	; Recursive Case
	mov rcx, rdx									; move start to rcx
	mov rdx, r8										; move end to rdx
	mov r15, r8										; temporarily save end in a regester, fixes issue of shadow space being shifted by _randomInRange
	call _randomInRange								; get random index in range
	mov [rsp + 10h], r15							; restore end in shadow space

	mov r8, [rsp + 20h]								; move array into r8
	mov rbx, [rsp + 18h]							; move start into rbx
	lea rcx, [r8 + rax * SDWORD]					; set rcx to the address of array[randomIndex]
	lea rdx, [r8 + rbx * SDWORD]					; set rdx to the address of array[start]
	call asmSwap									; swap pivot and start

	mov rbx, [rsp + 18h]							; move start into rbx to keep track of lastSmaller
	mov rax, rbx									; move start into rax for counter (i)
	inc rax											; i starts at start + 1
	quickLoop:										; label for loop
		mov r8, [rsp + 20h]							; move array into r8
		mov r11, [rsp + 18h]						; move start into r11
		mov r9d, SDWORD PTR [r8 + rax * SDWORD]		; set r9d to the value of array[i]
		mov r10d, SDWORD PTR [r8 + r11 * SDWORD]	; set r10d to the value of array[start]
		cmp r9d, r10d								; compare array[i] and  array[start]
		jae skipQuickLoopCondition					; skip condition if array[i] >= array[start]

		mov r8, [rsp + 20h]							; move array into r8
		lea rcx, [r8 + rax * SDWORD]				; set rcx to the address of array[i]
		lea rdx, [r8 + rbx * SDWORD + SDWORD]		; set rdx to the address of array[lastSmaller + 1]
		call asmSwap								; swap(array[i], array[lastSmaller + 1])

		inc rbx										; increment lastSmaller

		skipQuickLoopCondition:						; label for skipping condition in loop

		inc rax										; increment i
		cmp rax, [rsp + 10h]						; compare i and end
		jle quickLoop								; continue looping if i <= end
	
	mov [rsp + 8h], rbx								; store lastSmaller in shadow space

	mov r8, [rsp + 20h]								; move array into r8
	mov rbx, [rsp + 18h]							; set rbx to start
	mov r11, [rsp + 8h]								; set r11 to lastSmaller
	lea rcx, [r8 + rbx * SDWORD]					; set rcx to the address of array[start]
	lea rdx, [r8 + r11 * SDWORD]					; set rdx to the address of array[lastSmaller]
	call asmSwap									; swap(array[start], array[lastSmaller])

	mov rcx, [rsp + 20h]							; set rcx to array
	mov rdx, [rsp + 18h]							; set rdx to start
	mov r8, [rsp + 8h]								; set r8 to lastSmaller
	dec r8											; set r8 to (lastSmaller - 1)
	call asmQuickSort								; quickSort(array, start, lastSmaller - 1)

	mov rcx, [rsp + 20h]							; set rcx to array
	mov rdx, [rsp + 8h]								; set rdx to lastSmaller
	inc rdx											; set rdx to (lastSmaller + 1)
	mov r8, [rsp + 10h]								; set r8 to end
	call asmQuickSort								; quickSort(array, lastSmaller + 1, end)

	quickDone:										; label for base case

	mov rsp, rbp									; restore stack pointer
    pop rbp											; pop base pointer
    ret												; return from function
asmQuickSort ENDP

asmMergeSort PROC
	push rbp						; push base pointer
	mov rbp, rsp					; move stack pointer to the base pointer
	sub rsp, 30h					; allocate 48 bytes of shadow space

	mov [rsp + 28h], rcx			; store array in shadow space
	mov [rsp + 20h], rdx			; store temp in shadow space
	mov [rsp + 18h], r8				; store start in shadow space
	mov [rsp + 10h], r9				; store end in shadow space

	; Base Case
	cmp r8, r9						; compare start and end
	jae mergeDone					; base case reached if start >= end

	; Recursive Case
	xor rdx, rdx					; set rdx to 0
	mov rax, [rsp + 18h]			; move start to rax
	add rax, [rsp + 10h]			; set numerator to (start + end)
	mov rcx, 2						; set denominator to 2
	div rcx							; run (start + end) / 2
	mov [rsp + 8h], rax				; store middle in shadow space

	mov rcx, [rsp + 28h]			; set rcx to array
	mov rdx, [rsp + 20h]			; set rdx to temp
	mov r8, [rsp + 18h]				; set r8 to start
	mov r9, [rsp + 8h]				; set r9 to middle
	call asmMergeSort				; sort left half of the array

	mov rcx, [rsp + 28h]			; set rcx to array
	mov rdx, [rsp + 20h]			; set rdx to temp
	mov r8, [rsp + 8h]				; set r8 to middle
	inc r8							; set r8 to (middle + 1)
	mov r9, [rsp + 10h]				; set r9 to end
	call asmMergeSort				; sort right half of the array

	mov rcx, [rsp + 28h]			; set rcx to array
	mov rdx, [rsp + 20h]			; set rdx to temp
	mov r8, [rsp + 18h]				; set r8 to start
	mov r9, [rsp + 10h]				; set r9 to end
	mov r10, [rsp + 8h]				; set r10 to middle
	call asmInplaceMerge			; merge the two halves of the array

	mergeDone:						; label for base case

	mov rsp, rbp					; restore stack pointer
	pop rbp							; pop base pointer
	ret								; return from function
asmMergeSort ENDP

asmSwap PROC
    push rbp					; push base pointer
	mov rbp, rsp				; move stack pointer to the base pointer
	sub rsp, 30h				; allocate 48 bytes of shadow space

	mov r8d, SDWORD PTR [rcx]	; set r8d to the value at address rcx
	mov r9d, SDWORD PTR [rdx]	; set r9d to the value at address rdx
    mov [rcx], r9d				; move the value at rdx to the value of rcx
    mov [rdx], r8d				; move the value at rcx to the value of rdx

	mov rsp, rbp				; restore stack pointer
    pop rbp						; pop base pointer
    ret							; return from function
asmSwap ENDP

asmInplaceMerge PROC
	push rbp										; push base pointer
	mov rbp, rsp									; move stack pointer to the base pointer
	sub rsp, 30h									; allocate 48 bytes of shadow space

	mov r11, r10									; set r11 to middle (leftEnd)
	inc r11											; set r11 to (middle + 1) (aka rightStart)

	mov r13, r8										; move start to r13 (left pointer)
	mov r14, r11									; move rightStart to r14 (right pointer)
	mov r15, r8										; move start to r15 (current pointer)

	inplaceMergeLoop:								; label for loop
		mov eax, SDWORD PTR [rcx + r13 * SDWORD]	; move the value of array[left] to eax
		mov ebx, SDWORD PTR [rcx + r14 * SDWORD]	; move the value of array[right] to eax

		cmp eax, ebx								; compare array[left] and array[right]
		jbe inplaceMergeLeftLower					; go to inplaceMergeLeftLower if array[left] <= array[right]
		jmp inplaceMergeReftLower					; otherwise, go to inplaceMergeReftLower

		inplaceMergeLeftLower:						; label for left lower
			mov [rdx + r15 * SDWORD], eax			; move the value of array[left] to temp[current]
			inc r13									; increment left pointer
			jmp doneInplaceMergeCondition			; break from condition
		inplaceMergeReftLower:						; label for right lower
			mov [rdx + r15 * SDWORD], ebx			; move the value of array[right] to temp[current]
			inc r14									; increment right pointer
			jmp doneInplaceMergeCondition			; break from condition

		doneInplaceMergeCondition:					; label for breaking out of condition

		inc r15										; increment current pointer

		cmp r13, r10								; compare left and leftEnd
		ja copyRightRemainder						; break from loop if left > leftEnd
		cmp r14, r9									; compare right and rightEnd
		ja copyLeftRemainder						; break from loop if right > leftEnd
		jmp inplaceMergeLoop						; otherwise, continue looping

	copyRightRemainder:								; label for copying right remainder when left pointer goes out of range
		mov ebx, SDWORD PTR [rcx + r14 * SDWORD]	; move the value of array[right] to ebx
		mov [rdx + r15 * SDWORD], ebx				; move the value of array[right] to temp[current]

		inc r15										; increment current
		inc r14										; increment right
		cmp r14, r9									; compare right and rightEnd
		jbe copyRightRemainder						; continue looping if right <= rightEnd
		jmp mergeDone								; otherwise, break from loop

	copyLeftRemainder:								; label for copying left remainder when right pointer goes out of range
		mov eax, SDWORD PTR [rcx + r13 * SDWORD]	; move the value of array[left] to eax
		mov [rdx + r15 * SDWORD], eax				; move the value of array[left] to temp[current]

		inc r15										; increment current
		inc r13										; increment left
		cmp r13, r10								; continue looping if left <= leftEnd
		jbe copyLeftRemainder						; otherwise, break from loop

	mergeDone:										; label for when array has been merged into temp

	mov r15, r8										; set current to start

	copyLoop:										; label for copying temp into array
		mov eax, SDWORD PTR [rdx + r15 * SDWORD]	; move the value of temp[current] to eax
		mov [rcx + r15 * SDWORD], eax				; set array[current] to temp[current]

		inc r15										; increment current
		cmp r15, r9									; compare current and end
		jne copyLoop								; continue looping if current < end
	
	mov rsp, rbp									; restore stack pointer
    pop rbp											; pop base pointer
    ret												; return from function
asmInplaceMerge ENDP

END