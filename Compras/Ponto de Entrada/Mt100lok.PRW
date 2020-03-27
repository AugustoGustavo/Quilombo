#include "rwmake.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT100LOK ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 09/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Nota Fiscal de Origem de Transferencia.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Dimep                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³ Elias Reis - 03/12/09 - No produto SERVICO, valida a digi- ³±±
±±³          ³                         tacao de informacao no CCUSTO      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT100LOK()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Checa se o numero da Nota Fiscal esta preenchida com 6 caracteres. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(AllTrim(cNfiscal)) < 9 .And. cFormul <> "S"
	//Aviso(OemToAnsi("Num.Inválido"),OemToAnsi("Não é permitido a inclusão de Nota Fiscal de Entrada com menos de 6 caracteres no documento - Preencher com zeros a esquerda / verificar se não esta sendo cadastrado em duplicidade !"), {"Ok"},1,OemToAnsi("Num.Inválido"))
	//lReturn	:= .F.     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inclusao de 9 zeros a esquerda - 25/05/17            ³
	//³Solicitação do Jorge - Por motivo de notas duplicadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    (cNfiscal := STRZERO( Val(cNfiscal),9),.T. )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Checa se a Emissao da Nota Fiscal e inferior a 1 ano da digitação. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If (dDataBase - dDEmissao) > 90
	Aviso(OemToAnsi("Data Invalida"),OemToAnsi("Data de Emissao Inválida !"), {"Ok"},1,OemToAnsi("Emissao"))
	lReturn	:= .F.
EndIf
*/

If lReturn .And. AllTrim(FunName()) $ "MATA103" .and. (cEmpAnt $ "01" .AND. cFilAnt $ "01")
	If cTIPO = 'N' .And. Empty(cPedido) .And. POSICIONE("SF4",1,xFILIAL("SF4")+cTES,"F4_XTRANFI") <> "1" .And. !(cTES $ SuperGetMv("PR_TPCODOP",.F.,""))
		Aviso(	"Pedido de Compra",;
		"O tipo de entrada (TES) exige que a inclusão do item possua um número de pedido de compra associado.",;
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
			"Para esta operação o sistema exige a informação completa da Nota Fiscal Original com Documento, Serie e Item! Nota Original não encontrada",;
			{"&Continua"},,;
			"NF Origem:"+cNFOri )
			lReturn	:= .F.
		EndIf
	EndIf
	
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Checa se RATEIO==NAO  e se eh Tes de SERVICO e se digitou CCUSTO.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


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



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Checa se a Conta Contabil exige Centro de Custo  
//  Oficina1 -  Joyce 14/01/11
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


		dbSelectArea("CT1")
		dbSetOrder(1)
		If dbSeek(xFilial("CT1")+cConta)
			If CT1->CT1_CCOBRG = "1" .and. Empty(cCCUSTO) // Conta Contabil que exige Centro de Custo
				Aviso(OemToAnsi("Centro de Custo"),OemToAnsi("Centro de Custo obrigatório para a Conta Contábil. Informe o Centro de Custo!"), {"Ok"},1,OemToAnsi("Centro de Custo"))
				lReturn	:= .F.
			EndIf	
		EndIf
	

RestArea(aSvArea)

Return(lReturn)