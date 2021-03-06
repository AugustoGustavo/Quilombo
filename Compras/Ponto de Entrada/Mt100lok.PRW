#include "rwmake.ch"
#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT100LOK � Autor � Marcos Eduardo Rocha  � Data � 09/09/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida Nota Fiscal de Origem de Transferencia.             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Dimep                                           ���
�������������������������������������������������������������������������Ĵ��
���Alteracoes� Elias Reis - 03/12/09 - No produto SERVICO, valida a digi- ���
���          �                         tacao de informacao no CCUSTO      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT100LOK()

//������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                                �
//��������������������������������������������������������������������������
Local lReturn     := PARAMIXB[1]
Local nPosConta	  := 0
Local cConta	  := " "
Local nPosCC	  := 0
Local cCCusto	  := " "
Local cPosCL      := 0
Local cClVl	      := " "
Local cRateio     := "2"
Local nPosRateio  := 0
Local aSvArea     := GetArea()
Local cTipo1	  := " "

Local cTesServ    := SuperGetMv("DM_TESSERV",.F.,"490")

nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_COD") })
cCodProd	:= aCols[n][nPosProd]

nPosTES     := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_TES") })
cTES        := aCols[n][nPosTES]

nPosPedido  := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_PEDIDO") })
cPedido     := aCols[n][nPosPedido]

nPosConta   := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_CONTA") })
cConta	    := aCols[n][nPosConta]

nPosCC	    := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_CC") })
cCCusto	    := aCols[n][nPosCC]

nPosRateio  := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_RATEIO") })
cRateio     := aCols[n][nPosRateio]

//��������������������������������������������������������������������Ŀ
//� Checa se o numero da Nota Fiscal esta preenchida com 6 caracteres. �
//����������������������������������������������������������������������
If Len(AllTrim(cNfiscal)) < 9 .And. cFormul <> "S"
	//Aviso(OemToAnsi("Num.Inv�lido"),OemToAnsi("N�o � permitido a inclus�o de Nota Fiscal de Entrada com menos de 6 caracteres no documento - Preencher com zeros a esquerda / verificar se n�o esta sendo cadastrado em duplicidade !"), {"Ok"},1,OemToAnsi("Num.Inv�lido"))
	//lReturn	:= .F.     
	
	//�����������������������������������������������������Ŀ
	//�Inclusao de 9 zeros a esquerda - 25/05/17            �
	//�Solicita��o do Jorge - Por motivo de notas duplicadas�
	//�������������������������������������������������������
    (cNfiscal := STRZERO( Val(cNfiscal),9),.T. )
EndIf

//��������������������������������������������������������������������Ŀ
//� Checa se a Emissao da Nota Fiscal e inferior a 1 ano da digita��o. �
//����������������������������������������������������������������������
/*
If (dDataBase - dDEmissao) > 90
	Aviso(OemToAnsi("Data Invalida"),OemToAnsi("Data de Emissao Inv�lida !"), {"Ok"},1,OemToAnsi("Emissao"))
	lReturn	:= .F.
EndIf
*/

If lReturn .And. AllTrim(FunName()) $ "MATA103" .and. (cEmpAnt $ "01" .AND. cFilAnt $ "01")
	If cTIPO = 'N' .And. Empty(cPedido) .And. POSICIONE("SF4",1,xFILIAL("SF4")+cTES,"F4_XTRANFI") <> "1" .And. !(cTES $ SuperGetMv("PR_TPCODOP",.F.,""))
		Aviso(	"Pedido de Compra",;
		"O tipo de entrada (TES) exige que a inclus�o do item possua um n�mero de pedido de compra associado.",;
		{"&Continua"},,;
		"Produto: "+AllTrim(cCodProd)+" TES: "+cTES )
		lReturn	:= .F.
	EndIf
EndIf

If lReturn .And. AllTrim(FunName()) $ "MATA103"
	PRIVATE cNFOri   := aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_NFORI") })]
	PRIVATE cSeriOri := aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_SERIORI") })]
	PRIVATE cItemOri := aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_ITEMORI") })]
	PRIVATE cTES     := aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_TES") })]
	
	If cTIPO = "D" // DEVOLUCAO DE VENDA
		dbSelectArea("SD2")
		dbSetOrder(3)
		If !dbSeek(xFilial("SD2")+cNFOri+cSeriOri+cA100For+cLoja+cCodProd+cItemOri)
			Aviso(	"Nota Fiscal Original",;
			"Para esta opera��o o sistema exige a informa��o completa da Nota Fiscal Original com Documento, Serie e Item! Nota Original n�o encontrada",;
			{"&Continua"},,;
			"NF Origem:"+cNFOri )
			lReturn	:= .F.
		EndIf
	EndIf
	
Endif


//��������������������������������������������������������������������Ŀ
//� Checa se RATEIO==NAO  e se eh Tes de SERVICO e se digitou CCUSTO.  �
//����������������������������������������������������������������������


//Verificar Essa Situacao- Denison 03/12/07

/*

If lReturn .And. cRateio == '2'
	If cTES $ cTesServ
		If Empty(cCCusto)
			Aviso(OemToAnsi("Centro de Custo"),OemToAnsi("Para aquisicoes de servico, informe o Centro de Custo!"), {"Ok"},1,OemToAnsi("Centro de Custo"))
			lReturn	:= .F.
		EndIf
	EndIf
EndIf
*/



//��������������������������������������������������������������������Ŀ
//� Checa se a Conta Contabil exige Centro de Custo  
//  Oficina1 -  Joyce 14/01/11
//����������������������������������������������������������������������


		dbSelectArea("CT1")
		dbSetOrder(1)
		If dbSeek(xFilial("CT1")+cConta)
			If CT1->CT1_CCOBRG = "1" .and. Empty(cCCUSTO) // Conta Contabil que exige Centro de Custo
				Aviso(OemToAnsi("Centro de Custo"),OemToAnsi("Centro de Custo obrigat�rio para a Conta Cont�bil. Informe o Centro de Custo!"), {"Ok"},1,OemToAnsi("Centro de Custo"))
				lReturn	:= .F.
			EndIf	
		EndIf
	

RestArea(aSvArea)

Return(lReturn)