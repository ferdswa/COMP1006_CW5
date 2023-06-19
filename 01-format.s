		B main
width	DEFW 12
newline DEFB "\n",0
ruler	DEFB "123456789ABC\n",0
		ALIGN
main	
		MOV R2,#0
		LDR R1,width
		B whatEntered
		SWI 2
printC
		SWI 0
		ADD R2,R2,#1
whatEntered
		SWI 1
		CMP R0,#35 ;Break if #
		BEQ finish;
		CMP R0,#10 ;Newline if ascii 10
		BEQ entryNL
		CMP R0,#8
		BEQ bs
		CMP R2,R1 ;Newline if count>width
		BEQ ovf
		B printC
bs
		SUB R2,R2,#1
		SWI 0
		B whatEntered
ovf
		MOV R2,#0
		MOV R4,R0
		ADR R0,newline
		SWI 3
		MOV R0,R4
		B printC
entryNL
		MOV R2,#0
		ADR R0,newline
		SWI 3
		B whatEntered
finish
		SWI 2
