#Include "topconn.CH"
#Include "Colors.ch"
#Include "Protheus.CH"
/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   �RTNATTEL  � Autor � Deny B. Mendonca          �Data�25.12.2006���
����������������������������������������������������������������������������͹��
���Descricao  �                                                      		 ��� 
����������������������������������������������������������������������������͹��
���Sintaxe    �U_RTNATTEL                                                    ���
����������������������������������������������������������������������������͹��
���Parametros �                                                              ��� 
����������������������������������������������������������������������������͹��
���Uso        �                                                              ���
����������������������������������������������������������������������������͹��
���Solicitante�                                              �Data�          ���
����������������������������������������������������������������������������͹��
���               ALTERACOES EFETUADAS APOS CONSTRUCAO INICIAL               ���
����������������������������������������������������������������������������͹��
���Analista   �                                              �Data�          ���
����������������������������������������������������������������������������͹��
���Descricao  �                                                              ���
����������������������������������������������������������������������������͹��
���Autor      �                                              �Data�          ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
Adiciona campo do Acols do Rateio de Mult Natureza
/*/

User Function RTNATTEL()

Local nUsado 	:= Len(aHeader)
Local nUsadoNew := Len(aHeader)
Local acolsbkp := acols
Local nQtdAcols := Len(acols)
Local nA :=0 , nB := 0
//������������������������������������������������������Ŀ
//�Adiciona Campos no aHeader                            �
//��������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek("EV_OBSERV")
	nUsadoNew++
	Aadd(aHeader,{ 	TRIM(X3Titulo()),;
							TRIM(SX3->X3_CAMPO),;
							SX3->X3_PICTURE,;
	  	                	SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_ARQUIVO,;
							SX3->X3_CONTEXT } )
EndIf

aCols := {}
Aadd(aCols,Array(nUsadoNew+1))
For nA := 1 to nQtdAcols
	For nB := 1 To nUsado
		aCols[nA][nB] := aColsbkp[nA][nB]
	Next nB
	aCols[nA][nB] := CriaVar(aHeader[nB][2])
	aCols[nA][Len(aHeader)+1] := .F.
Next nA
   
Return