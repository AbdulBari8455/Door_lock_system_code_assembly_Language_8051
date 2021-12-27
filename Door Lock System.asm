RS EQU P2.7
RW EQU P2.6
E  EQU P2.5
FLG EQU 40H
SEL EQU 41H

ORG 000H
CLR P2.0
MOV TMOD,#00100001B
MOV TH1,#253D
MOV SCON,#50H
SETB TR1
ACALL LCD_INIT
MOV DPTR,#TEXT1
ACALL LCD_OUT
ACALL LINE2
MOV DPTR,#TEXT2
ACALL LCD_OUT

MAIN:ACALL LCD_INIT
     MOV DPTR,#TEXT1
     ACALL LCD_OUT
     ACALL LINE2
     MOV DPTR,#TEXT2
     ACALL LCD_OUT
     ACALL READ_TAG
     CLR REN
     ACALL LINE2
     ACALL CHECK_PASSWORD
     ACALL DELAY1
     SETB REN
     SJMP MAIN
     
     
LCD_INIT: MOV DPTR,#INIT_COMMANDS
          SETB SEL
          ACALL LCD_OUT
          CLR SEL
          RET      

LCD_OUT:  CLR A
           MOVC A,@A+DPTR
           JZ EXIT
           INC DPTR
           JB SEL,CMD
           ACALL DATA_WRITE
           SJMP LCD_OUT
CMD:      ACALL CMD_WRITE 
           SJMP LCD_OUT
EXIT:	   RET          

LINE2:MOV A,#0C0H 
    ACALL CMD_WRITE
    RET   
    
 READ_TAG:  MOV R0,#12D
           MOV R1,#160D
	   WAIT:JNB RI,WAIT
           MOV A,SBUF
           MOV @R1,A
           INC R1
           CLR RI
           DJNZ R0,WAIT
           RET
   

CHECK_PASSWORD:	CLR FLG
      		MOV R2,#12D
      		MOV R1,#160D
      		MOV DPTR,#PASS1
	REPEAT: CLR A
      		MOVC A,@A+DPTR
      		XRL A,@R1
      		JNZ CHECKNEXT
      		INC R1
      		INC DPTR
      		DJNZ R2,REPEAT
      		ACALL LINE2
      		MOV DPTR,#TEXT3
      		ACALL LCD_OUT
      		SETB P2.0
      		RET
      
CHECKNEXT: JB FLG,FAIL
           MOV R2,#12D
           MOV R1,#160D
           MOV DPTR,#PASS2
           SETB FLG
           SJMP REPEAT


FAIL:ACALL LINE2
     MOV DPTR,#TEXT4
     ACALL LCD_OUT 
     CLR P2.0
     RET
    
 

DELAY1:MOV R3,#46D
BACK:  MOV TH0,#00000000B   
       MOV TL0,#00000000B   
       SETB TR0             
HERE1: JNB TF0,HERE1         
       CLR TR0             
       CLR TF0             
       DJNZ R3,BACK
       RET


CMD_WRITE: MOV P0,A
    CLR RS
    CLR RW
    SETB E
    CLR E
    ACALL DELAY
    RET

DATA_WRITE:MOV P0,A
    SETB RS
    CLR RW
    SETB E
    CLR E
    ACALL DELAY
    RET

DELAY: CLR E
    CLR RS
    SETB RW
    MOV P0,#0FFh
    SETB E
    MOV A,P0
    JB ACC.7,DELAY
    CLR E
    CLR RW
    RET
    
INIT_COMMANDS:  DB 0CH,01H,06H,83H,3CH,0    
TEXT1: DB "RFID ACCESS",0  
TEXT2: DB "Swipe TagS..",0
TEXT3: DB "Access allowed",0
TEXT4: DB "Access denied",0

PASS1: DB "18008DC02E7B"
PASS2: DB "7500511ECDF7"
   
    END