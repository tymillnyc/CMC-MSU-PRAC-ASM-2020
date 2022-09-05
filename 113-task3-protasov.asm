include console.inc

.data
N EQU 100
X DB N DUP (?)
Y DB N DUP (?)
.code

CONVERSION1 PROC
      PUSH EDX
srav: CMP BYTE PTR [EAX], 97 ;  '97' - ��� ������� 'a', '122' - ��� ������� 'z'
      JB otet ; ���� ������� ������ �� ����� � ��������� 'a'..'z', ������� �� otet
      CMP BYTE PTR [EAX], 122
      JA otet
      MOV DL, byte PTR [EAX]
      SUB DL, 32 ; ���� �����, �� �� ����� ������� �������� 32 - ������� ����� ������� � ��������� ��������� ����� � ASCII-�������
      MOV BYTE PTR [EAX], DL
otet: 
      POP EDX
      RET
CONVERSION1 ENDP

CONVERSION2 PROC
OUTSTR '����������� ������� 2: '
	  PUSH EBX
      PUSH ESI
	  PUSH ECX
      MOV ESI, 0
	  MOV EBX, 0
	  MOV CH, BYTE PTR [EAX]
	  MOV BYTE PTR [EDX], CH
dfnt: INC ESI
      MOV CL, BYTE PTR [EAX][ESI]
      CMP CL, '.'
      JE pass
      CMP CH, CL
	  JE same  
	  INC EBX
      MOV BYTE PTR [EDX][EBX], CL
same:
      JMP dfnt
pass: 
      MOV BYTE PTR [EDX][EBX+1], '.'
      POP ECX
      POP ESI
	  POP EBX
	  RET
CONVERSION2 ENDP

start:
ClrScr
      MOV CX, N 
      MOV ESI, 0
vvod: INCHAR AL  ; ������ ����������� ������
      MOV X[ESI], AL
      INC ESI 
      CMP AL, '.' ; ���� �� ����� ����� ��� CX <> N - ���� ������������
      LOOPNE vvod 
	  JNE NEXT 
	  MOV ECX, ESI
	  MOV ESI, 0
OutT: OUTCHAR X[ESI] ; ����� ���������� ������ �� ����� 
      INC ESI
	  LOOP OutT
	  NEWLINE
      MOV AL, X[ESI-2] ; ��������� ������ ����� ������
      CMP X[0], 48 ; 48 - ��� ������� '1', 57 - ��� ������� '9'
      JB vCon 
      CMP X[0], 57 ; ���� ������ ������ �� ����� � ��������� '1'..'9', ������� �� vCon 
	  JA vCon
      CMP AL, 48
      JB vCon
      CMP X[ESI-2], 57 ; ���������� � ������������� ��������
      JA vCon
      CMP X[0], AL; �� ����� - ������� �� ������� 1 - pCon
      JNE pCon ; 
	  
vCon: LEA EAX, X
      LEA EDX, Y
	  CALL CONVERSION2
	  JMP PRUG
	 
pCon: MOV ECX, ESI
      MOV ESI, 0
	  OUTSTR '����������� ������� 1: ' 
calc: LEA EAX, X[ESI] ; � ��������� ������� ������ ����� 1-��� �������
	  CALL CONVERSION1 ; ����� ��������� ���������� ������� ���, ������� �������� � ���� � ������� �
	  INC ESI
	  LOOP calc
      MOV ECX, ESI
      MOV ESI, 0	  
OuTX: OUTCHAR X[ESI] ; ����� �� ����� ���������������� �� ������� 1 ������
      INC ESI
      CMP X[ESI], '.'
      LOOPNE OuTX
	  NEWLINE
	  JMP NEXT
	    
PRUG: MOV ECX, ESI
      MOV ESI, 0
OuTY: OUTCHAR Y[ESI] ; ����� �� ����� ���������������� �� ������� 1 ������
	  CMP Y[ESI], '.'
	  INC ESI
      LOOPNE OuTY
	  NEWLINE
	  
NEXT:
exit

end start