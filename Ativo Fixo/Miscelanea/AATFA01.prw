#include "dbtree.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#include "protheus.ch"
#DEFINE GD_INSERT	1
#DEFINE GD_DELETE	4
#DEFINE GD_UPDATE	2

STATIC __lCusto
STATIC __lItem
STATIC __lClVL
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AATFA01   ºAutor  ³Felipi Marques      º Data ³  09/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de importacao da CSV com dados do Ativo para Implan-º±±
±±º          ³ tação                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AATFA01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea	  		:= GetArea()
Local aRegs			:= {}
Local cPerg			:= PADR("MANA01",Len(SX1->X1_GRUPO))
Local aParams		:= {MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04}
Local cLoteAtf    	:= LoteCont("ATF")
Local nHdlPrv     	:= 0
Local lHeader     	:= .F.
Local nX		 	:= 0
Local aDados	  	:= {}
Local aColunas	  	:= {"",""}
Local nCol		  	:= 0
Local cType		  	:=	"Arquivos CSV|*.CSV|Todos os Arquivos|*.*"
Local cDelimited  	:= ";"
Local lDigita     	:= .T.
Local lAglut      	:= .F.
Local cDocCtb     	:= ""
Local cArquivo		:= ""

Private cArq		:= ""
Private nHdl		:= Nil
Private cCadastro	:= "Importação Ativo Fixo em CSV"

SN1->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona o arquivo                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo CSV com os dados dos Ativos"),0,"",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
If Empty(cArq)
	Aviso("Inconsistência","Selecione o arquivo com os dados dos Ativos a serem recalculados.",{"Ok"},,"Atenção:")
	Return()
Endif

If !FILE(cArq)
 	Aviso("Inconsistência","Não foi localizado o arquivo com os dados do Ativo.",{"Ok"},,"Atenção:")
	Return()
EndIf         


nLinInicio := 2 //Verificar necessidade de pergunte deste campo            

nLidos := 0
nIncluidos := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a filial corrente para restaurar ao final da rotina                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilBack := cFilAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o arquivo de origem para importacao do Ativo Fixo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
// Abre o arquivo
nHandle := FT_FUse(cArq)

// Se houver erro de abertura abandona processamento
If nHandle = -1  
   Return
EndIf                     

dbSelectArea("SN1")	
dbSelectArea("SN3")	
dbSelectArea("SN4")	

// Posiciona na primeira linha
FT_FGoTop()

// Retorna o número de linhas do arquivo
nLast := FT_FLastRec()
//MsgAlert( nLast )
While !FT_FEOF()   
  cLine  := FT_FReadLn() 
  // Retorna a linha corrente  
  nRecno := FT_FRecno()  
  // Retorna o recno da linha  
  
  If nRecno < 5 //Mostra as 5 primeiras linhas
 	 Aviso("Recno: " + StrZero(nRecno,3),cLine,{"Ok"},3,"Linha: ")
  EndIf
  
  If nRecno < nLinInicio
     // Pula para próxima linha  
     FT_FSKIP()
     Loop
  EndIf
  
  
  nLidos   += 1
  
  // Transform String em Array com os campos delimitados     
  xLinha := cLine
  While cDelimited+cDelimited $ xLinha  //Tratamento para evitar truncar campos varios para o Array
     xLinha := StrTran(xLinha,cDelimited+cDelimited,cDelimited+" "+cDelimited)
  EndDo
  aDados := StrtoArray( xLinha, cDelimited ) //STRTOKARR( cLine, cDelimited )
  If nRecno < 5 //Mostra as 5 primeiras linhas
 	 AVISO( "Conteudo", VARINFO("aDados", aDados,,.F.,.F.), {"OK"}, 3, "Conteudo dos Registros")
  EndIf
  
 
//  Begin Transaction 

	 If !EMPTY(aDados[02])
		dbSelectArea("SNG")	
		SNG->(dbSetOrder(1))
	    If !SNG->(dbSeek(xFilial("SNG")+aDados[02]))
			   RecLock("SNG",.T.)
			   SNG->NG_FILIAL  := xFilial("SNG")
			   SNG->NG_GRUPO   := cGrupo
			   SNG->NG_DESCRIC := PADR("NOVO GRUPO - COMPLETAR CADASTRO",LEN(SNG->NG_DESCRIC))
		   MsUnLock()
		EndIF
			
	 EndIf
	 
	 nIncluidos += 1
     
     RecLock("SN1",.T.)
	     SN1->N1_FILIAL   := aDados[01]
	     SN1->N1_GRUPO    := aDados[02]
	     SN1->N1_CBASE    := aDados[03]
	     SN1->N1_ITEM     := aDados[04]
	     SN1->N1_AQUISIC  := sTOD(SUBSTR(aDados[05],01,10))	 
	     SN1->N1_QUANTD   := ConvValor(aDados[06],"N1_QUANTD")  	 
	     SN1->N1_BAIXA    := sTOD(SUBSTR(aDados[07],01,10)) 	 
	     SN1->N1_DESCRIC  := Upper(NoAcento(AnsiToOem(AllTrim(aDados[08]))))
	     SN1->N1_CHAPA    := aDados[09]
	     SN1->N1_FORNEC   := aDados[10] 	 
	     SN1->N1_LOJA     := aDados[11] 	 
	     SN1->N1_LOCAL    := aDados[12]
	     SN1->N1_NSERIE   := aDados[13]
	     SN1->N1_NFISCAL  := aDados[14]     
	     SN1->N1_CHASSIS  := aDados[15]
	     SN1->N1_PLACA	  := aDados[16]
	     SN1->N1_STATUS	  := aDados[17]
	     SN1->N1_DTBLOQ   := sTOD(SUBSTR(aDados[18],01,10)) 
     MsUnlock("SN1") 

	RecLock("SN3",.T.)
	     SN3->N3_FILIAL  := SN1->N1_FILIAL
	     SN3->N3_CBASE   := SN1->N1_CBASE
	     SN3->N3_ITEM    := SN1->N1_ITEM
	     SN3->N3_QUANTD  := SN1->N1_QUANTD
	     SN3->N3_TIPO    := "01"
	     SN3->N3_BAIXA   := aDados[19]
	     SN3->N3_TPSALDO := aDados[20]
	     SN3->N3_CCONTAB := IIF(EMPTY(aDados[21]),SNG->NG_CCONTAB,aDados[21])
	     SN3->N3_CDEPREC := IIF(EMPTY(aDados[28]),SNG->NG_CDEPREC,aDados[28])  
	     SN3->N3_CCUSTO  := IIF(EMPTY(aDados[29]),SNG->NG_CCONTAB,aDados[29])
		 SN3->N3_CUSTBEM := aDados[29]
	     SN3->N3_CCDEPR  := IIF(EMPTY(aDados[31]),SNG->NG_CCDEPR ,aDados[31]) 
	     SN3->N3_CDESP   := IIF(EMPTY(aDados[32]),SNG->NG_CDESP  ,aDados[32]) 
	     SN3->N3_DINDEPR := sTOD(SUBSTR(aDados[22],01,10))
	     SN3->N3_FIMDEPR := sTOD(SUBSTR(aDados[23],14,10))
	     SN3->N3_TXDEPR1 := ConvValor(aDados[24],"N3_TXDEPR1")
	     SN3->N3_VORIG1  := ConvValor(aDados[25],"N3_VORIG1")
	     SN3->N3_VRDMES1 := ConvValor(aDados[26],"N3_VRDMES1")
	     SN3->N3_VRDACM1 := ConvValor(aDados[27],"N3_VRDACM1")
	MsUnlock("SN3")
/*  		
		If SN3->N3_VRDACM1 > 0        // existindo valor de DEPRECIACAO ACUMULADA
			If Reclock("SN4", .T.)     // deve-se gerar titulo no sn4 com ocorrencia 06
				SN4->N4_FILIAL  := SN3->N3_FILIAL
				SN4->N4_CBASE   := SN3->N3_CBASE
				SN4->N4_ITEM    := SN3->N3_ITEM
				SN4->N4_TIPO    := SN3->N3_TIPO
				SN4->N4_OCORR   := "06"
				SN4->N4_TIPOCNT := "4"
				SN4->N4_CONTA   := SN3->N3_CCDEPR
				//SN4->N4_DATA    := SN3->N3_DINDEPR
				SN4->N4_QUANTD  := 0
				SN4->N4_VLROC1  := SN3->N3_VRDACM1
				SN4->N4_VLROC2  := SN3->N3_VRDACM2
				SN4->N4_VLROC3  := SN3->N3_VRDACM3
				SN4->N4_VLROC4  := SN3->N3_VRDACM4
				SN4->N4_VLROC5  := SN3->N3_VRDACM5
				SN4->N4_TXMEDIA := ROUND((SN3->N3_VRDACM1 / SN3->N3_VRDACM3),2)
				SN4->N4_SEQ  := '001'
				MsUnlock("SN4")
			Endif
		Endif
		
		If SN3->N3_VRCACM1 > 0        // existindo valor de CORRECAO ACUMULADA deve-se
			If Reclock("SN4",.T.)      // gerar registro no sn4 com ocorrencia 07
				SN4->N4_FILIAL  := SN3->N3_FILIAL
				SN4->N4_CBASE   := SN3->N3_CBASE
				SN4->N4_ITEM    := SN3->N3_ITEM
				SN4->N4_TIPO    := SN3->N3_TIPO
				SN4->N4_OCORR   := "07"
				SN4->N4_TIPOCNT := "2"
				SN4->N4_CONTA   := SN3->N3_CCORREC
				SN4->N4_DATA    := SN3->N3_DINDEPR
				SN4->N4_QUANTD  := 0
				SN4->N4_VLROC1  := SN3->N3_VRCACM1
				SN4->N4_VLROC2  := 0
				SN4->N4_VLROC3  := 0
				SN4->N4_VLROC4  := 0
				SN4->N4_VLROC5  := 0
				SN4->N4_TXMEDIA := 0
				SN4->N4_TXDEPR  := 0
				SN4->N4_SEQ  := '001'
				MsUnlock("SN4")
			Endif
			
			If Reclock("SN4",.T.)      // gerar registro no sn4 com ocorrencia 07 para tipo de cta 1
				SN4->N4_FILIAL  := SN3->N3_FILIAL
				SN4->N4_CBASE   := SN3->N3_CBASE
				SN4->N4_ITEM    := SN3->N3_ITEM
				SN4->N4_TIPO    := SN3->N3_TIPO
				SN4->N4_OCORR   := "07"
				SN4->N4_TIPOCNT := "1"
				SN4->N4_CONTA   := SN3->N3_CCONTAB
				SN4->N4_DATA    := SN3->N3_DINDEPR
				SN4->N4_QUANTD  := 0
				SN4->N4_VLROC1  := SN3->N3_VRCACM1
				SN4->N4_VLROC2  := 0
				SN4->N4_VLROC3  := 0
				SN4->N4_VLROC4  := 0
				SN4->N4_VLROC5  := 0
				SN4->N4_TXMEDIA := 0
				SN4->N4_TXDEPR  := 0
				SN4->N4_SEQ  := '001'
				MsUnlock("SN4")
			Endif
		Endif
		If SN3->N3_VRCDA1 > 0        // existindo valor da CORRECAO DA DEPRECIACAO ACUMULADA deve-se
			if reclock("SN4",.t.)     // gerar registro no sn4 com ocorrencia 08 e Tipo de conta 5
				SN4->N4_FILIAL  := SN3->N3_FILIAL
				SN4->N4_CBASE   := SN3->N3_CBASE
				SN4->N4_ITEM    := SN3->N3_ITEM
				SN4->N4_TIPO    := SN3->N3_TIPO
				SN4->N4_OCORR   := "08"
				SN4->N4_TIPOCNT := "5"
				SN4->N4_CONTA   := SN3->N3_CCORREC
				SN4->N4_DATA    := SN3->N3_DINDEPR
				SN4->N4_QUANTD  := 0
				SN4->N4_VLROC1  := SN3->N3_VRCDA1
				SN4->N4_VLROC2  := 0
				SN4->N4_VLROC3  := 0
				SN4->N4_VLROC4  := 0
				SN4->N4_VLROC5  := 0
				SN4->N4_TXMEDIA := 0
				SN4->N4_TXDEPR  := 0
				SN4->N4_SEQ  := '001'
				MsUnlock("SN4")
			Endif
			If Reclock("SN4",.t.)      // gerar registro no sn4 com ocorrencia 08 e tipo de conta 4
				SN4->N4_FILIAL  := SN3->N3_FILIAL
				SN4->N4_CBASE   := SN3->N3_CBASE
				SN4->N4_ITEM    := SN3->N3_ITEM
				SN4->N4_TIPO    := SN3->N3_TIPO
				SN4->N4_OCORR   := "08"
				SN4->N4_TIPOCNT := "4"
				SN4->N4_CONTA   := SN3->N3_CCDEPR
				SN4->N4_DATA    := SN3->N3_DINDEPR
				SN4->N4_QUANTD  := 0
				SN4->N4_VLROC1  := SN3->N3_VRCDA1
				SN4->N4_VLROC2  := 0
				SN4->N4_VLROC3  := 0
				SN4->N4_VLROC4  := 0
				SN4->N4_VLROC5  := 0
				SN4->N4_TXMEDIA := 0
				SN4->N4_TXDEPR  := 0
				SN4->N4_SEQ  := '001'
				MsUnlock("SN4")
			Endif
		Endif
	
		// Grava saldos do SN5
		If Val(SN3->N3_BAIXA) = 0                   
		
    	cTipoImob := "1"
        cTipoBaixa:= "5"
		cTipoCorr := "6"

		 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		 //³ Atualiza a Imobiliza‡„o. Conta do Bem                             ³
		 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 AtfSaldo(	SN3->N3_CCONTAB,MV_PAR04,cTipoImob,;
		 			SN3->(N3_VORIG1+N3_AMPLIA1),SN3->(N3_VORIG2+N3_AMPLIA2),SN3->(N3_VORIG3+N3_AMPLIA3),;
		 			SN3->(N3_VORIG4+N3_AMPLIA4),SN3->(N3_VORIG5+N3_AMPLIA5),"+",SN3->N3_TXDEPR1,;
		 			SN3->N3_SUBCCON,,SN3->N3_CLVLCON,SN3->N3_CUSTBEM,"1")

		 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		 //³ No raz„o soma-se a corre‡„o do bem a conta do bem, no RAZAO.      ³
		 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 If SN3->N3_VRCACM1 != 0
			  AtfSaldo(	SN3->N3_CCONTAB,MV_PAR04,cTipoCorr,;
			  			SN3->N3_VRCACM1 ,0 ,0 ,0 ,0 ,"+", SN3->N3_TXDEPR1 ,;
			  			SN3->N3_SUBCCON,, SN3->N3_CLVLCON,SN3->N3_CUSTBEM,"1")
		 Endif

		 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		 //³ Atualiza a conta de Despesa de Deprecia‡„o.  o total de deprecia-³
		 //³ ‡Æo acumulada no exerc¡cio.                                       ³
		 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 If SN1->N1_PATRIM $ "N " .and. SN3->N3_VRDBAL1 != 0
			  AtfSaldo(	SN3->N3_CDEPREC,MV_PAR04,"4",;
			  			SN3->N3_VRDBAL1 ,SN3->N3_VRDBAL2,SN3->N3_VRDBAL3,;
			  			SN3->N3_VRDBAL4 ,SN3->N3_VRDBAL5 ,"+", SN3->N3_TXDEPR1,;
			  			SN3->N3_SUBCCON,, SN3->N3_CLVLCON,SN3->N3_CUSTBEM,"3")
		 Endif

		 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		 //³ Atualiza a Deprecia‡„o Acumulada                                    ³
		 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 If SN1->N1_PATRIM $ "N " .and. SN3->N3_VRDACM1 != 0
			  AtfSaldo(	SN3->N3_CCDEPR,MV_PAR04,"4",;
			  			SN3->N3_VRDACM1,SN3->N3_VRDACM2,SN3->N3_VRDACM3,;
			  			SN3->N3_VRDACM4 ,SN3->N3_VRDACM5 ,"+", SN3->N3_TXDEPR1,;
			  			SN3->N3_SUBCCON,,SN3->N3_CLVLCON,SN3->N3_CUSTBEM,"4")
		 Endif
		EndIf 
*/
//  End Transaction
  
  // Pula para próxima linha  
  FT_FSKIP()
EndDo
// Fecha o arquivo
FT_FUSE()
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a filial corrente antes do inicio da execucao da rotina             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cFilBack

//	RMANA01LOG()
MsgStop("Registros Lidos:"+STRZERO(nLidos,6)+" Registros Incluidos:"+STRZERO(nIncluidos,6))

RestArea(aArea)

Return Nil

Static Function ConvValor(xValor,cCampo)

Local cTipoSX3 := TIPOSX3(cCampo)
Local aTamSX3  := TAMSX3(cCampo)              
Local xRetorno := xValor //Nil

If cCampo == "N1_STATUS" //0=Pendente de classificacao;1=Em Uso;2=Bloqueado por usuario;3=Bloqueado por local;4=Transferencia interna entre filiais        
   xRetorno := "1" //Valor Default
   If ALLTRIM(xValor) == "EM USO"
      xRetorno := "1"
   EndIf
Else
   If cTipoSX3 == "N"             
      xRetorno := xValor
      xRetorno := STRTRAN(xValor,".","")
      xRetorno := STRTRAN(xRetorno,",",".")
      xRetorno := STRTRAN(xRetorno,"R$","")
      xRetorno := STRTRAN(xRetorno,"%","")
      xRetorno := ALLTRIM(xRetorno)
      xRetorno := VAL(xRetorno)
   ElseIf cTipoSX3 == "D"
      xRetorno := CTOD(ALLTRIM(xValor))
   EndIf      
EndIf         

Return xRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TipoSX3    | Autor ³ Felipi Marques      ³ Data ³09/02/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o tipo de dado do SX3 de um determinado campo      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TipoSX3(cCampo)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCampo  - nome do campo                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGALOJA                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TipoSX3( cCampo )
Local cAlias  := Alias()
Local nOrd    := IndexOrd()
Local nordSx3 := SX3->(Indexord())
Local nRegSx3 := SX3->(Recno())
Local cTipo   :=' '

DbSelectArea("SX3")
DbSetOrder(2)
DbSeek(cCampo)
If Found()
	cTipo := X3_TIPO
EndIf

DbSelectArea("SX3")
DbSetOrder(nOrdSx3)
DbGoTo(nRegSx3)
If !Empty(cAlias)
	DbSelectArea(cAlias)
	DbSetOrder(nOrd)
EndIf
Return cTipo

User Function RMANA01A()
                                              
dbSelectArea("SN3")
dbSetOrder(1)

dbSelectArea("SN1")
dbGoTop()
While !EOF()
   
   SN3->(dbSeek(xFilial("SN3")+SN1->N1_CBASE+SN1->N1_ITEM))
   
   Reclock("SN1",.F.) 
   If EMPTY(SN1->N1_AQUISIC)
      SN1->N1_AQUISIC := SN3->N3_DINDEPR
   EndIf
   If EMPTY(SN1->N1_PATRIM)
      SN1->N1_PATRIM  := "0"
   EndIf
   MsUnLock()
   
   dbSkip()
EndDo

MsgStop("Ajuste efetuado!")
Return Nil