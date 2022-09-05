include console.inc

.data

	b1 db ?
	b2 db ?
	b3 db ?
	w1 dw ?
	w2 dw ?
	w3 dw ?
	d1 dd ?
	d2 dd ?
	d3 dd ?

.code
Addthree MACRO arg1, arg2, arg3 
  LOCAL argument_1, argument_2, argument_3
      argument_1 = opattr(arg1) ; 42 - ���������� ����������
	  argument_2 = opattr(arg2)
	  argument_3 = opattr(arg3)
		IF argument_1 EQ 42 and argument_2 EQ 42 and argument_3 EQ 42  ;
		  IF TYPE arg2 NE SIZEOF DWORD and TYPE arg3 NE SIZEOF DWORD and TYPE arg1 NE SIZEOF DWORD
		    PUSH AX
        	IF TYPE arg1 EQ SIZEOF BYTE ; ���� ������ �������� �������� ����
        		IF TYPE arg2 EQ SIZEOF WORD or TYPE arg3 EQ SIZEOF WORD
				  .ERR <wrong sizes>
				ELSE			
				   mov al, arg1 
				   add al, arg2
				   add al, arg3
				   mov arg1, al
				ENDIF
        	ELSEIF TYPE arg1 EQ SIZEOF WORD ; ���� ������ �������� ����� 
        			mov ax, arg1
        			
					PUSH BX
        			IF TYPE arg2 EQ SIZEOF BYTE ; ���� ������ ���������� ��������, �� ���������
        				movzx bx, arg2
        			ELSE
        				mov bx, arg2 ; ���� ������ ��������� 2��������
        			
					ENDIF
        			
        			add ax, bx
        			
        			IF TYPE arg3 EQ SIZEOF BYTE ; ����������
        				movzx bx, arg3
        			ELSE
        				mov bx, arg3
        			ENDIF
        			
        			add ax, bx
        			mov arg1, ax
        	ENDIF
			POP BX
			POP AX
		 ELSE 
	        .ERR <arg1 or arg2 or arg3 neither word, byte> ; ���� �����-�� �� ���������� �� ����, �� �����
		 ENDIF
        ELSE
        	.ERR <parameter is a not variable> ; ���� �������� �� ���������� 
        ENDIF
    ENDM
	
start:

	Addthree b1, b2, b3
	OUTU b1
	
end start
