		B main
width	DEFW 12

; Use this buffer to store your words, there's space for words up to 32 bytes long
;
; When you store characters here, it will overwrite the values that already exist.
buffer	DEFB "01234567890123456789012345678901",0 
ruler	DEFB "123456789ABC\n",0
slzero	DEFB 0
;R0 = IO
;R1 is for the buffer address
;R2 is a character print counter
;R3 is for width
;R4 is line length at start of word
;R10 is for current word char count
;R11 is for current line char count
;R12 is space before word flag
;R13 is newline after word flag
		ALIGN
main	
        ADR R1,buffer
        LDR R3,width
        MOV R2,#0
        MOV R4,#0
        MOV R10,#0
        MOV R11,#0
        MOV R12,#0
        MOV R13,#0
        B enteredChar
enteredChar
        SWI 1
        CMP R0,#35
        BEQ finish
        CMP R0,#32
        BEQ newWord
        CMP R0,#10
        BEQ newLine
        B storeChar
storeChar
        STRB R0,[R1]
		SWI 0
        ADD R1,R1,#1
        ADD R10,R10,#1
        B enteredChar
newWord 
        ADD R11,R11,R10
		ADD R12,R11,#1
        ADR R1,buffer       ;Reset pointer for reading
        MOV R2,#0           ;Loop counter reset
        CMP R12,R3
        BGT newLine         ;Word follows newline
        BEQ newLineAft      ;Space then word then newline
        BLT lessThan        ;"normal" word
lessThan
        ;first word or not #letters>=line length
        CMP R4,#0
        BEQ regreset       ;branch if first word to non-space printer
        MOV R0,#32          ;Adding space
        SWI 0
		ADD R11,R11,#0
        B regreset
pwLoop
        LDRB R0,[R1]
		SWI 0
		ADD R1,R1,#1
		ADD R2,R2,#1
printWord
        CMP R10,R2
        BGT pwLoop
        ADR R1,buffer
        CMP R13,#1
        BEQ newLinePrint
        MOV R2,#0               ;Loop reset
        MOV R10,#0              ;Current word count reset
        MOV R13,#0              ;newline after word reset
        ADD R4,R4,#1      
        ADR R1,buffer
        B enteredChar
regreset
		CMP R13,#1
		BEQ newLinePrint
        MOV R2,#0               ;Loop reset
        MOV R10,#0              ;Current word count reset
        MOV R13,#0              ;newline after word reset
        ADD R4,R4,#1      
        ADR R1,buffer
        B enteredChar
newLinePrint
        MOV R0,#10
        SWI 0
        MOV R4,#0
        MOV R10,#0
        MOV R11,#0
        MOV R13,#0
        ADR R1,buffer
        B enteredChar
newLineAft
        MOV R13,#1              ;setting post-word newline flag to true
        CMP R4,#0
        BEQ regreset           ;first word in line & equal to line length means a different rule
        MOV R0,#32              ;Adding space
        SWI 0
        ADD R11,R11,#1          ;no space -> word -> newline
        B regreset
newLine
		MOV R0,R10
		BL rubOut
        MOV R0,#10	            ;print newline
        SWI 0
        MOV R4,#0               ;reset wordcount in line
        MOV R11,R10             ;add wordcount to new line count
        B printWord
rubOutLoop
		MOV R5,R0
		MOV R0,#8
		SWI 0
		MOV R0,R5
		SUB R0,R0,#1
rubOut
		CMP R0,#0
		BGT rubOutLoop
		MOV PC,R14
finish
        SWI 2