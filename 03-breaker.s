		B main
width	DEFW 12

; Use this buffer to store your words, there's space for words up to 32 bytes long
;
; When you store characters here, it will overwrite the values that already exist.
buffer	DEFB "01234567890123456789012345678901",0 
ruler	DEFB "123456789ABC\n",0
		ALIGN
main	
		MOV R2,#0		;character count in line
		MOV R3,#0		;character in word count
		MOV R11,#0		;space flag
		MOV R12,#0		;newline flag
		ADR R6,buffer	;move address pointer to r6
		LDR R1,width
		B whatEntered
		SWI 2
storeC
		STRB R0,[R6]
		ADD R6,R6,#1
		ADD R3,R3,#1
		B whatEntered
lp
		LDRB R0,[R6]
		SWI 0
		ADD R6,R6,#1
		ADD R7,R7,#1
printW
		CMP R7,R3
		BLT lp
		ADD R2,R2,R3
		MOV R3,#0
		ADR R6,buffer
		CMP R11,#1
		BEQ huh
		CMP R12,#1
		BEQ newlinepost
		B whatEntered
whatEntered
		SWI 1
		MOV R11,#0
		MOV R12,#0
		CMP R0,#35 ;Break if #
		BEQ finish;
		CMP R0,#32 ;new word
		BEQ newWord
		CMP R0,#10 ;new line
		BEQ entryNLA
		B storeC
newWord
		ADD R10,R2,R3
		CMP R10,R1
		BGT entryNLA    ;new line then word
		BEQ	newlinepre	;word then new line
		BLT preprint
preprint
		MOV R7,#0		;second thing to allow printing
		ADR R6,buffer 	;reset pointer
		MOV R11,#1
		B printW
entryNLA
		MOV R2,#0
		MOV R0,#10
		SWI 0
		B preprint
huh
		MOV R0,#32
		ADD R2,R2,#1
		SWI 0
		B whatEntered
newlinepre
		MOV R12,#1
		B preprint
newlinepost
		MOV R2,#0
		MOV R0,#10
		SWI 0
		B whatEntered
finish
		SWI 2