.code

Pixel proc; qword pointer, dword x, dword y, dword stride, dword BPP

	; saving stack pointer
	push rbp
	mov rbp, rsp

	imul r8d, r9d
	add r8, rcx
	imul edx, eax
	mov r12, 8
	div r12
	mov rax, r8
	add rax, rdx; rax contains returning value

	; popping base pointer
	pop rbp
	ret
Pixel endp

Transform proc; qword input, qword output, dword picHei, dword picWid, dword inputStr, dword outputStr, dword inputBPP, dword outputBPP, qwort pattern, dword begLine, dword endLine
	; creating variables
	local input: QWORD
	local output: QWORD
	local picHei: DWORD
	local picWid: DWORD
	local inputStr: DWORD
	local outputStr: DWORD
	local inputBPP: DWORD
	local outputBPP: DWORD
	local pattern: QWORD
	local begLine: DWORD
	local endLine: DWORD

	; saving stack pointer
	push rbp
	mov rbp, rsp

	; saving parameters
	mov input, RCX
	mov output, RDX
	mov picHei, R8D
	mov picWid, R9D
	mov rax, [rbp+112]
	mov inputStr, eax
	mov rax, [rbp+120]
	mov outputStr, eax
	mov rax, [rbp+128]
	mov inputBPP, eax
	mov rax, [rbp+136]
	mov outputBPP, eax
	mov rax, [rbp+144]
	mov pattern, rax
	mov rax, [rbp+152]
	mov begLine, eax
	mov rax, [rbp+160]
	mov endLine, eax

	





	; popping base pointer
	pop rbp
	ret
Transform endp
end




