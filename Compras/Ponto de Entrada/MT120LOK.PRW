#include "rwmake.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT120LOK � Autor � Felipi Marques�         Data � 18/12/14 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Checa se a Conta Contabil exige Centro de Custo			   ��	 
�� Valida os 4 primeiros digitos do centro de custo (al�ada por CC) 	   ��	
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Quilombo                                        ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT120LOK()

Local cConta	  := " "
Local cCCusto	  := " "
Local cTipo1	  := " "
local cTipCom	  := " "
Local nPosConta	  := 0
Local nPosItem    := 0
Local nPosCC	  := 0
Local nPosTipCom  := 0
Local nI		  := 0
Local nTamArray	  := 0 //Apenas Desempenho
Local aSvArea     := GetArea()
Local lReturn     := .T.

nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
cItem		:= aCols[n][nPosItem]

nPosConta   := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C7_CONTA") })
cConta	    := aCols[n][nPosConta]

nPosCC	    := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C7_CC") })
cCCusto	    := aCols[n][nPosCC]

dbSelectArea("CT1")
dbSetOrder(1)    
If dbSeek(xFilial("CT1")+cConta)
	If CT1->CT1_CCOBRG = "1" .and. Empty(cCCUSTO) // Conta Contabil que exige Centro de Custo
		Aviso(OemToAnsi("Centro de Custo"),OemToAnsi("Centro de Custo obrigat�rio para a Conta Cont�bil. Informe o Centro de Custo!"), {"Ok"},1,OemToAnsi("Centro de Custo"))
		lReturn	:= .F.
	EndIf
EndIf

/*���������������������������������������������������������������������������������
//�Felipi Marques - Oficina1                                                       �
//�Solicita��o da Erica                                                            �
//�Excluir a valida��o de centro de custo, pois a karina ira controlar manualmente.�
//�Dt 23/09/2016                                                                   �
//��������������������������������������������������������������������������������*/
/* nTamArray := Len(aCols)//Desempenho
For nI := 1 to nTamArray
	If Left( AllTrim( aCols[n,nPosCC]),4 ) <> Left( AllTrim( aCols[nI,nPosCC]),4 ) .AND. nI <> n
		MsgStop( 'O centro de custo da linha >> ' + cValtoChar(n) + ' est� diferente da linha >> ' + cValToChar(nI) + CRLF + 'Compara��o >> 4 Primeiro digitos', 'Valida��o - Centro de Custo' )
		lReturn := .F.
	Endif
Next nI */

RestArea(aSvArea)

Return(lReturn)
