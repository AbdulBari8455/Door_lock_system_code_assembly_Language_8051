# You are required to write   a program to communicate 
two 89C52 microcontrollers serially at a 9600 baud rate 
Connect eight SPDT switches with port P1 and a 
push button with P3.2 of microcontroller-1 These 
eight SPDT switches represent a byte 
Whenever the push button is pressed and then released,
the corresponding byte is transmitted to the 2nd 
microcontroller The microcontroller-2 displays the 
received string on Hyper Terminal. Assume oscillator 
frequency to be 11.0592MHz

;Code
;transmitter
ORG 00H
MOV TMOD,#20H
MOV TH1,#-3
MOV SCON,#50H
MOV P1,#0FFH
SETB TR1
SETB P3.2

AGAIN:
CLR P3.2
JNB P3.2,AGAIN
MOV A,P1
ACALL SEND
ACALL DELAY
SJMP AGAIN

SEND:
MOV SBUF,A
HERE:JNB TI,HERE
CLR TI
RET
DELAY:
	MOV R1,#14
	LOOP:	MOV R2,#255
	LOOP1:MOV R3,#255
	LOOP2:DJNZ R3,LOOP2
	DJNZ R2,LOOP1
	DJNZ R1,LOOP
	RET
END

;receiver

ORG 00H
	MOV TMOD,#20H
	MOV TH1,#-3
	MOV SCON,#50H
	MOV P2,#00
	CLR A
	SETB TR1
	
	AGAIN:
	ACALL RECE
	MOV P2,A
	SJMP AGAIN
	
	RECE:
	MOV A,SBUF
	HERE: JNB RI,HERE
	CLR RI
	RET
	
	
	END
		
