include console.inc

.data
N EQU 100
X DB N DUP (?)
Y DB N DUP (?)
.code

CONVERSION1 PROC
      PUSH EDX
srav: CMP BYTE PTR [EAX], 97 ;  '97' - код символа 'a', '122' - код символа 'z'
      JB otet ; если текущий символ не лежит в множестве 'a'..'z', переход на otet
      CMP BYTE PTR [EAX], 122
      JA otet
      MOV DL, byte PTR [EAX]
      SUB DL, 32 ; если лежит, то из этого символа отнимаем 32 - разница между большой и маленькой латинской буквы в ASCII-таблице
      MOV BYTE PTR [EAX], DL
otet: 
      POP EDX
      RET
CONVERSION1 ENDP

CONVERSION2 PROC
OUTSTR 'применилось правило 2: '
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
vvod: INCHAR AL  ; вводим посимвольно строку
      MOV X[ESI], AL
      INC ESI 
      CMP AL, '.' ; пока не равно точке или CX <> N - цикл продолжается
      LOOPNE vvod 
	  JNE NEXT 
	  MOV ECX, ESI
	  MOV ESI, 0
OutT: OUTCHAR X[ESI] ; вывод начального текста на экран 
      INC ESI
	  LOOP OutT
	  NEWLINE
      MOV AL, X[ESI-2] ; последний символ перед точкой
      CMP X[0], 48 ; 48 - код символа '1', 57 - код символа '9'
      JB vCon 
      CMP X[0], 57 ; если первый символ не лежит в множестве '1'..'9', переход на vCon 
	  JA vCon
      CMP AL, 48
      JB vCon
      CMP X[ESI-2], 57 ; аналогично с предпоследним символом
      JA vCon
      CMP X[0], AL; не равны - переход на правило 1 - pCon
      JNE pCon ; 
	  
vCon: LEA EAX, X
      LEA EDX, Y
	  CALL CONVERSION2
	  JMP PRUG
	 
pCon: MOV ECX, ESI
      MOV ESI, 0
	  OUTSTR 'применилось правило 1: ' 
calc: LEA EAX, X[ESI] ; в процедуру передаю только адрес 1-ого символа
	  CALL CONVERSION1 ; вызов процедуры происходит столько раз, сколько символов у меня в массиве Х
	  INC ESI
	  LOOP calc
      MOV ECX, ESI
      MOV ESI, 0	  
OuTX: OUTCHAR X[ESI] ; вывод на экран преобразованного по правилу 1 текста
      INC ESI
      CMP X[ESI], '.'
      LOOPNE OuTX
	  NEWLINE
	  JMP NEXT
	    
PRUG: MOV ECX, ESI
      MOV ESI, 0
OuTY: OUTCHAR Y[ESI] ; вывод на экран преобразованного по правилу 1 текста
	  CMP Y[ESI], '.'
	  INC ESI
      LOOPNE OuTY
	  NEWLINE
	  
NEXT:
exit

end start