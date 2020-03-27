/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TRFCODBAR �Autor  �Andreza Favero      � Data �  03/06/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Transforma a linha digitavel em codigo de barras.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TRFCODBAR()

/*
Local cMonta1 := ""
Local cMonta2 := ""
Local cMonta3 := ""
Local cMonta4 := ""
Local cMonta5 := ""
Local cMonta6 := ""
Local cMonta7 := ""
Local cReturn := ""
Local cCodbar := ""
Local nTamCod := Len(cCodbar)
Local nTamVal := Len(cCodbar)-33


If FieldPos("E2_XLINDIG") > 0
	cCodbar 	:= Trim(M->E2_XLINDIG)
EndIf 
*/

SETPRVT("cStr")

cStr := LTRIM(RTRIM(M->E2_XLINDIG))

IF VALTYPE(M->E2_XLINDIG) == NIL .OR. EMPTY(M->E2_XLINDIG)
	// Se o Campo est� em Branco n�o Converte nada.
	cStr := ""
ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
	// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
    // Completa as 14 posicoes do valor do documento.
    //--- Marciane 25.05.06 - Completar com zeros a esquerda o valor do codigo de barras se n�o tiver preenchido
    //cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
    cStr := IF(LEN(cStr)<44,subs(cStr,1,33)+Strzero(val(Subs(cStr,34,14)),14),cStr)                            
    //--- fim Marciane 25.05.06
ENDIF

DO CASE
	CASE LEN(cStr) == 47
		cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
	CASE LEN(cStr) == 48
		cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
	OTHERWISE
		cStr := cStr+SPACE(48-LEN(cStr))
ENDCASE


Return(cStr)

