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
; @params          [rbp-72]      [rbp-80]      [rbp-88]      [rbp-96]        [rbp+48]         [rbp+56]        [rbp+64]         [rbp+72]       [rbp+80]
Transform proc; QWORD input, QWORD output, DWORD picHei, DWORD picWid, DWORD inputStr, DWORD outputStr, DWORD inputBPP, DWORD outputBPP, QWORD pattern
	
	;RBX, RBP, RDI, RSI, RSP, R12, R13, R14, R15

	push RBP      ; saving stack pointer
	mov RBP, RSP  ;
	push RBX
	push RDI
	push RSI
	push RSP
	push R12
	push R13
	push R14
	push R15
	
	push RCX
	push RDX
	push R8
	push R9

;	mov rax, [rbp-72]
;	mov rax, [rbp-80]
;	mov rax, [rbp-88]
;	mov rax, [rbp-96]
;	mov rax, [rbp+48]
;	mov rax, [rbp+56]
;	mov rax, [rbp+64]
;	mov rax, [rbp+72]
;	mov rax, [rbp+80]

	mov rcx, 0
loopOut:
	inc rcx

	mov rdx, 0
loopInn:
	inc rdx
	
	mov R13D, 0   ; newRedValue = 0;
	mov R14D, 0   ; newGreenValue = 0;
	mov R15D, 0   ; newBlueValue = 0;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TOP LEFT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	dec r9d   ; j-1  ; left ;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	dec r10d  ; i-1  ; top  ;;;;;;;;;;;;;;;;;;;;;;;;;;;ASDASDSDsd

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX]   ; Pattern[0] -> R11
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[0] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j - 1, i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j - 1, i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j - 1, i - 1, inputStr, inputBPP)[2] * pattern[0];

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TOP CENTER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
	mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	;dec r9d   ; j ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	dec r10d   ; i-1  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+4] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TOP RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	inc r9d   ; j+1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	dec r10d  ; i-1  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+8] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CENTER LEFT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	dec r9d   ; j-1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	;dec r10d  ; i  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+12] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CENTER CENTER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	;inc r9d   ; j-1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	;dec r10d  ; i-1  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+16] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CENTER RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	inc r9d   ; j+1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	;dec r10d  ; i  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+20] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BOT LEFT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	dec r9d   ; j-1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	inc r10d  ; i+1  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+24] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BOT CENTER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	;dec r9d   ; j ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	inc r10d  ; i+1  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+28] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BOT RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		mov r8, [rbp-72]   ; input
	mov r9d, edx       ; inner counter - j/width/x
	mov r10d, ecx      ; outer counter - i/height/y
	mov r11d, [rbp+48] ; inputStr
	mov r12d, [rbp+64] ; inputBPP

	inc r9d   ; j+1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;USUNAC NIEPOTRZEBNE
	inc r10d  ; i+1  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	;                      R8       R9      R10           R11        R12
	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	mov RAX, [RBP+80] ; Pattern -> RBX
	mov R11W, [RAX+32] ; Pattern[1] -> R11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RAX + _
	xor R12, R12      ;
	mov R12B, R10B    ; moving last byte (red color) of pixel to R12
	
	imul R12W, R11W ; colorRed * pattern[1] -> R11
	add R13W, R12W  ; newRedValue += pixel(input, j    , i - 1, inputStr, inputBPP)[0] * pattern[0];

	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R14W, R12W  ; newGreenValue += pixel(input, j    , i - 1, inputStr, inputBPP)[1] * pattern[0];
	
	shr R10, 8      ;
	xor R12, R12    ;
	mov R12B, R10B  ;
	imul R12W, R11W ;
	add R15W, R12W  ; newBlueValue += pixel(input, j    , i - 1, inputStr, inputBPP)[2] * pattern[0];

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WRITING TO OUTPUT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	call CutoffColors ; cmp r12 cutting values exceeding 0 and 255:

	; writing values to output image:

	mov r8, [rbp-80]   ; output     ; setting parameters
	mov r9d, edx       ; inner counter - j (width/x)
	mov r10d, ecx      ; outer counter - i (height/y)
	mov r11d, [rbp+56] ; outputStr
	mov r12d, [rbp+72] ; outputBPP

	call Pixel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor R12, R12
	mov R12B, R10B ; moving first byte of pixel to R12
	shl R12, 8
	shr R10, 8
	mov R12B, R10B ; moving second byte of pixel to R12
	shl R12, 8
	shr R10, 8
	mov R12B, R10B ; moving third byte of pixel to R12
	mov [R8], R12D ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Xddd swapping colors currently



	;;;;;;;;;;;;loops;;;;;;;;;;;;;;

	mov rax, [rbp-96] ; picWid
	dec rax
	dec rax
	cmp rdx, rax
	jl loopInn

	mov rax, [rbp-88] ; picHei
	dec rax
	dec rax
	cmp rcx, rax
	jl loopOut

	pop rax
	pop rax
	pop rax
	pop rax

	pop R15
	pop R14
	pop R13
	pop R12
	pop RSP
	pop RSI
	pop RDI
	pop RBX
	pop RBP

	ret
Transform endp
end




