.code

; Procedure saves address of a Pixel in R8 register, consumes R8-R12 registers content.
; @returns R8: pointer + y * stride + x * bitsPerPixel / 8;
; @params              R8       R9      R10           R11        R12
Pixel proc; qword pointer, dword x, dword y, dword stride, dword BPP [can corrupt R8-R12]

	imul r10, r11   ; stride * y -> R10
	add r8, r10     ; (stride * y) + pointer -> R8
	imul r9, r12    ; x * BPP -> R9
	shr r9, 3       ; (x * BPP) / 8 -> R9
	add r8, r9      ; ((x * BPP) / 8) + ((stride * y) + pointer) -> R8 = RETURNING REGISTER

	ret
Pixel endp


CutoffColors proc ; [can corrupt R9-R10]
	mov R9W, 0
	mov R10W, 255
	cmp R13W, R9W
	jge RedTop
	mov R13, 0
RedTop:
	cmp R13W, R10W
	jle RedOk
	mov R13, 255
RedOk:
	cmp R14W, R9W
	jge GreenTop
	mov R14, 0
GreenTop:
	cmp R14W, R10W
	jle GreenOk
	mov R14, 255
GreenOk:
	cmp R15W, R9W
	jge BlueTop
	mov R15, 0
BlueTop:
	cmp R15W, R10W
	jle BlueOk
	mov R15, 255
BlueOk:
	ret
CutoffColors endp

; Procedude transforms single image by given pattern
; @returns nothing
; @params               RCX          RDX            R8             R9        [rbp+48]         [rbp+48]        [rbp+64]         [rbp+72]       [rbp+80]
Transform proc; QWORD input, QWORD output, DWORD picHei, DWORD picWid, DWORD inputStr, DWORD outputStr, DWORD inputBPP, DWORD outputBPP, QWORD pattern
; @paramsInside:    [rbp-8]      [rbp-16]      [rbp-24]      [rbp-32]        [rbp-40]         [rbp-48]        [rbp-56]         [rbp-64]       [rbp-72]
	
	push rbp      ; saving stack pointer
	mov rbp, rsp  ;
	mov R13D, 0   ; int newRedValue = 0;
	mov R14D, 0   ; int newGreenValue = 0;
	mov R15D, 0   ; int newBlueValue = 0;
	   
	;newColorValue += (unsigned char)pixel(input, j - 1, i - 1, inputStride, inputBitsPerPixel)[0] * pattern[0];

	push rcx ; input [rbp-8]      ; saving parameters
	push rdx ; output [rbp-16]    ;
	mov r10, r8
	dec r10
	push r10 ; picHei [rbp-24]     ;
	mov r10, r9
	dec r10
	push r10 ; picWid [rbp-32]    ;
	mov rax, [rbp+48]             ;
	push rax ; inputStr [rbp-40]  ;
	mov rax, [rbp+56]             ;
	push rax ; outputStr [rbp-48] ;
	mov rax, [rbp+64]             ;
	push rax ; inputBPP [rbp-56]  ;
	mov rax, [rbp+72]             ;
	push rax ; outputBPP [rbp-64] ;
	mov rax, [rbp+80]             ;
	push rax ; pattern [rbp-72]   ;
	push rbx

	; petla zewnetrzna

	mov rcx, 0
loopOut:
	inc rcx

	; petla wewnetrzna
	mov rdx, 0
loopInn:
	inc rdx
	
	mov R13D, 0   ; newRedValue = 0;
	mov R14D, 0   ; newGreenValue = 0;
	mov R15D, 0   ; newBlueValue = 0;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TOP LEFT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov r8, [rbp-8]    ; input     ; setting parameters
	mov r9d, edx       ; inner counter - j (width/x)
	mov r10d, ecx      ; outer counter - i (height/y)
	mov r11d, [rbp-40] ; inputStr
	mov r12d, [rbp-56] ; BPP

	dec r9d   ; j-1  ; left
	dec r10d  ; i-1  ; top

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov RAX, [RBP-72] ; Pattern -> RBX
	mov R11W, [RAX]   ; Pattern[0] -> R11
	mov R10D, [R8]    ; pixel -> R10
	xor R12, R12
	mov R12B, R10B ; moving last byte of pixel to R12
	
	imul R12W, R11W; colorRed * pattern[0] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j - 1, i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8
	xor R12, R12
	mov R12B, R10B
	imul R12W, R11W
	add R14W, R12W  ; newGreenValue += pixel(input, j - 1, i - 1, inputStr, inputBPP)[1] * pattern[0];

	shr R10, 8
	xor R12, R12
	mov R12B, R10B
	imul R12W, R11W
	add R15W, R12W  ; newBlueValue += pixel(input, j - 1, i - 1, inputStr, inputBPP)[2] * pattern[0];

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TOP CENTER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TOP RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CENTER LEFT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CENTER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CENTER RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BOT LEFT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BOT CENTER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BOT RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WRITING TO OUTPUT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	call CutoffColors  ; cmp r12 cutting values exceeding 0 and 255:

	; writing values to output image:

	mov r8, [rbp-16]    ; output     ; setting parameters
	mov r9d, edx       ; inner counter - j (width/x)
	mov r10d, ecx      ; outer counter - i (height/y)
	mov r11d, [rbp-48] ; outputStr
	mov r12d, [rbp-64] ; outputBPP

	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor R12, R12
	mov R12B, R10B ; moving second byte of pixel to R12
	shl R12, 8
	shr R10, 8
	mov R12B, R10B ; moving third byte of pixel to R12
	shl R12, 8
	shr R10, 8
	mov R12B, R10B ; moving fourth byte of pixel to R12
	mov R8D, R12D

	;;;;;;;;;;;;loops;;;;;;;;;;;;;;

	cmp rdx, [rbp-32]
	jl loopInn

	cmp rcx, [rbp-24]
	jl loopOut

	; TODO wyjebac to kurwa
	pop rbx
	pop rax
	pop rax
	pop rax
	pop rax
	pop rax
	pop rax
	pop rax
	pop rax
	pop rax
	; popping base pointer
	pop rbp
	ret
Transform endp
end




