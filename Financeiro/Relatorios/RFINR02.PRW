#include "rwmake.ch"
#Include "Protheus.CH"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR02   ºAutor  ³Felipi Marques      º Data ³  17/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Orçado x Real Regime de Caixa e Competencia      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quilombo                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINR02()

Local aButtons		:= { } 
Local cCadastro     := "Relatorio Orçado x Real Regime de Caixa e Competencia"    
Local nOpca         := 0 
Private aLog        := {}
Private aTitle      := {}
Private cPerg       := PADR("REGCX3",Len(SX1->X1_GRUPO))
Private aRegs       := {}
Private cTmpTb     	:= "RgiCaxCop-"+Dtos(MSDate())+StrTran(Time(),":","")

AjusPerg()  // Criar e VerIficar Perguntas

//Chama tela de perguntas, caso cancele, não executar relatorio
If Pergunte(cPerg,.T.)
	Processa({ |lEnd| RegCxCp(),OemToAnsi("Criando cabeçalho, aguarde...")}, OemToAnsi("Aguarde..."))
EndIf
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI020  ºAutor  ³Microsiga           º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RegCxCp()

Local lDir          := .T.
Local cPath         := ""
Local lProsiga      := .T.
Local cDirDocs      := MsDocPath()
Local cQuery        := ""
Local cAlias        := GetNextAlias()
Local cSqlAlias	    := GetNextAlias() 
Local cSqlAlias1	:= GetNextAlias()
Local cSqlAlias2	:= GetNextAlias()
Local cSqlAlias3	:= GetNextAlias()
Local cRecOri    
Local cTabOri    
Local nRecCount := 0 

Local cNomArq1 := ""
Local cIndArq1 := ""
Local aCampos1 := {}

//Tela de apontamento de origem e destino
aRetTela := fOriDes()

//Fragmentando resultado da variavel
cPath       := aRetTela[1]
lProsiga    := aRetTela[2]

If lProsiga = .F.
	MsgInfo("Cancelado pelo usuário")
    Return()
Endif


aAdd(aCampos1, {"FILIAL"  , "C", 02, 0})
aAdd(aCampos1, {"DATAFIN" , "D", 08, 0})
aAdd(aCampos1, {"LOTE"    , "C", 06, 0})
aAdd(aCampos1, {"SBLOTE"  , "C", 03, 0})
aAdd(aCampos1, {"DOC"     , "C", 06, 0})
aAdd(aCampos1, {"LINHA"   , "C", 03, 0})
aAdd(aCampos1, {"MOEDA"   , "C", 02, 0})
aAdd(aCampos1, {"TIPO"    , "C", 20, 0})
aAdd(aCampos1, {"DEBITO"  , "C", 20, 0})
aAdd(aCampos1, {"CREDITO" , "C", 20, 0})
aAdd(aCampos1, {"VALOR"   , "N", 17, 2})
aAdd(aCampos1, {"HISTORI" , "C", 80, 0})
aAdd(aCampos1, {"CCUSTOD" , "C", 09, 0})
aAdd(aCampos1, {"CCUSTOC" , "C", 09, 0})
aAdd(aCampos1, {"ITEMD"   , "C", 09, 0})
aAdd(aCampos1, {"ITEMC"   , "C", 09, 0})
aAdd(aCampos1, {"ORIGEM"  , "C", 10, 0})
aAdd(aCampos1, {"PREFIXO" , "C", 03, 0})
aAdd(aCampos1, {"TIPOPGTO", "C", 03, 0})
aAdd(aCampos1, {"NUMERO " , "C", 14, 0})
aAdd(aCampos1, {"PARCELA" , "C", 03, 0})
aAdd(aCampos1, {"CLIFOR"  , "C", 06, 0})
aAdd(aCampos1, {"LOJA"    , "C", 02, 0})
aAdd(aCampos1, {"EMISSAO" , "D", 08, 0})
aAdd(aCampos1, {"VENCTO"  , "D", 08, 0})
aAdd(aCampos1, {"TABELA"  , "C", 03, 0})
aAdd(aCampos1, {"REGISTRO", "C", 19, 0})
aAdd(aCampos1, {"CTADESP1", "C", 20, 0})
aAdd(aCampos1, {"CTADESP2", "C", 20, 0})
aAdd(aCampos1, {"CTADESP3", "C", 20, 0})
aAdd(aCampos1, {"CTADESP4", "C", 20, 0})
aAdd(aCampos1, {"CTADESP5", "C", 20, 0})
aAdd(aCampos1, {"CTADESP6", "C", 20, 0})
aAdd(aCampos1, {"CTADESP7", "C", 20, 0})
aAdd(aCampos1, {"CTADESP8", "C", 20, 0})
aAdd(aCampos1, {"CTADESP9", "C", 20, 0})

If Empty(cTmpTb)
	cTmpTb := "REGCX-"+Dtos(MSDate())+StrTran(Time(),":","")
EndIf

//Define uma nova tabela ou um novo arquivo do tipo tabela e sua estrutura (campos)
dbCreate(cDirDocs+"\"+cTmpTb,aCampos1) 

//Define um arquivo de dados como uma área de trabalho disponível na aplicação.
dbUseArea(.T.,,cDirDocs+"\"+cTmpTb,cSqlAlias3,.F.,.F.)


cQuery	:= 	" SELECT CT2_FILIAL, CT2_DATA, CT2_DEBITO, CT2_CREDIT, CT2_SEQUEN, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA, CT2_MOEDLC,  " 
cQuery	+= 	" CT2_DC, CT2_VALOR, CT2_HIST, CT2_CCD, CT2_CCC, CT2_ITEMD, CT2_ITEMC, CT2_LP, CT2_SEQLAN                                 "
cQuery   +=	" FROM  "+ CT2->(RetSQLName("CT2")) +" CT2                                                                                  "       
cQuery	+= 	" WHERE                                                                                                                   " 
cQuery	+= 	" CT2.D_E_L_E_T_ <> '*'                                                                                                  "                                                                            
cQuery	+= 	" AND CT2_FILIAL >= "+ MV_PAR03 + " AND CT2_FILIAL <= "+ MV_PAR04 + "                                                                              "
cQuery	+= 	" AND CT2_DATA BETWEEN '"+ Dtos ( mv_par01 ) +"' AND '"+ Dtos ( mv_par02 ) +"'                                               "

//Cria Tabela temporaria
TcQuery cQuery New Alias &cSQLAlias

//Quandidade de Registros
Count To nRecCount

//Valor máximo da régua de progressão
ProcRegua(nRecCount)

//Posiciona a tabela corrente no primeiro registro lógico
(cSQLAlias)->( dbGoTop () ) 

//Inicia Impressao do relatorio
While (cSQLAlias)->(!EOF())
	
	IncProc("Registro-> " + (cSQLAlias)->CT2_HIST)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Zera Valores das Bases que serao recalculadas				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dData := dEmissa := dVenci := CTOD("  /  /  ")
    cPrefixo := cNumero := cParcela := cClifor := cLoja := cTipo := cNumCheq := cBanco := ""
    cAgencia := cConta := cCtaDesp1 := cCtaDesp2 := cCtaDesp3 := cCtaDesp4 := cCtaDesp5:= ""
    cCtaDesp6 := cCtaDesp7 := cCtaDesp8 := cCtaDesp9 := cTPagto := ""
	nValor    := 0
	cFil      := (cSQLAlias)->CT2_FILIAL 
  	// Rastreamento de Lancamento                                           
	cQuery	:= 	" SELECT DISTINCT CV3_FILIAL, CV3_DTSEQ ,CV3_SEQUEN, CV3_TABORI, CV3_RECORI "
	cQuery  +=	" FROM  "+ CV3->(RetSQLName("CV3")) +" CV3 "
	cQuery	+= 	" WHERE " 
	cQuery	+= 	" CV3.D_E_L_E_T_ <> '*' " 
	cQuery	+= 	" And CV3_FILIAL ='"+ (cSQLAlias)->CT2_FILIAL +"' And CV3_DTSEQ = '"+ (cSQLAlias)->CT2_DATA +"' " 
	cQuery	+= 	" And CV3_SEQUEN = '"+ (cSQLAlias)->CT2_SEQUEN +"' And CV3_RECORI <> ' ' " 
	cQuery	+= 	" And CV3_DC = '"+ (cSQLAlias)->CT2_DC +"' And CV3_HIST LIKE '%"+ Alltrim((cSQLAlias)->CT2_HIST)  +"%' " 
	
	If(Select(cSQLAlias1) > 0, (cSQLAlias1)->(dbCloseArea()),"")
	//Cria Tabela temporaria
	TcQuery cQuery New Alias &cSQLAlias1

	//Posiciona a tabela corrente no primeiro registro lógico
	(cSQLAlias1)->( dbGoTop () ) 
	
	cRecOri := (cSQLAlias1)->CV3_RECORI 
	cTabOri := (cSQLAlias1)->CV3_TABORI
	//(cSQLAlias1)->( dbCloseArea () )   
    
	//Analise se o lanamento contabil é referente ao financeiro
	If cTabOri $ "SE5/SEF/SE1/SE2"
		DbSelectArea(cTabOri)
		DbGoto(VAL(cRecOri)) 
	Else
		DbSelectArea(cSQLAlias1)
		(cSQLAlias)->(!dbSkip())
		Loop
	Endif
	//Se as contas contabeis são referente a regime de caixa
	If SUBS((cSQLAlias)->CT2_DEBITO,1,4) == "1101" .OR. SUBS((cSQLAlias)->CT2_CREDIT,1,4) == "1101"
			
			//Carrega as variaveis cabeçalho do relatorio
			If cTabOri == "SE5"
				dData     := SE5->E5_DTDISPO
				cPrefixo  := SE5->E5_PREFIXO
				cNumero   := SE5->E5_NUMERO
				cParcela  := SE5->E5_PARCELA
				cClifor   := SE5->E5_CLIfOR
				cLoja     := SE5->E5_LOJA
				cTipo	 := SE5->E5_TIPO
				nValor    := SE5->E5_VALOR
			ElseIf cTabOri == "SEF"
				dData	:= SEF->EF_DATA
				cPrefixo := SEF->EF_PREFIXO
				cNumero  := SEF->EF_TITULO
				cParcela := SEF->EF_PARCELA
				cClifor  := SEF->EF_FORNECE
				cLoja    := SEF->EF_LOJA
				cTipo	:= SEF->EF_TIPO
				nValor   := SEF->EF_VALOR
			ElseIf (cTabOri == "SE1" )  .AND. ('FINA')$SE2->E2_ORIGEM
				dData    := SE1->E1_EMISSAO
				cPrefixo := SE1->E1_PREFIXO
				cNumero  := SE1->E1_NUM
				cParcela := SE1->E1_PARCELA
				cClifor  := SE1->E1_CLIENTE
				cLoja    := SE1->E1_LOJA
				cTipo	:= SE1->E1_TIPO
				dVenci   := SE1->E1_VENCTO
				dEmissa  := SE1->E1_EMISSAO
				nValor   := SE1->E1_VALOR
				cCtaDesp1 := SE1->E1_CREDIT 
				cTPagto   := "R"
			ElseIf (cTabOri == "SE2")  .AND. ('FINA')$SE2->E2_ORIGEM
				dData     := SE2->E2_EMISSAO
				cPrefixo  := SE2->E2_PREFIXO
				cNumero   := SE2->E2_NUM
				cParcela  := SE2->E2_PARCELA
				cClifor   := SE2->E2_FORNECE
				cLoja     := SE2->E2_LOJA
				cTipo	 := SE2->E2_TIPO
				dVenci    := SE2->E2_VENCTO
				dEmissa   := SE2->E2_EMISSAO
				nValor    := SE2->E2_VALOR
				cCtaDesp1 := SE2->E2_DEBITO  
				cTPagto   := "P"
			Else
				dData	 := (cSQLAlias)->T2_DATA
				cPrefixo  := ""
				cNumero   := ""
				cParcela  := ""
				cClifor   := ""
				cLoja     := ""
				cTipo	 := ""
				dVenci    := CTOD("  /  /  ")
				dEmissa   := CTOD("  /  /  ")
				nValor    := (cSQLAlias)->CT2_VALOR
				cCtaDesp1 := ""
			Endif
			
			//Variaveis itens do relatorio
			If cTabOri == "SE5" .And. SE5->E5_RECPAG == "P"
				SE2->(DbSetOrder(1))
				If SE2->(DbSeek(XFILIAL("SE2") + cPrefixo + cNumero + cParcela + cTipo + cClifor + cLoja ))
					dVenci := SE2->E2_VENCTO
					dEmissa := SE2->E2_EMISSAO 
					cTPagto   := "P"  
					
					lImposto := .F.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Variáveis com os tipos de títulos³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//TAXA
					IF (SE2->E2_TIPO $ MVISS+"/"+MVTAXA+"/"+MVTXA+"/"+MVINSS+"/"+"SES"+"/"+"AB-")
						lImposto := .T.				
					ENDIF
					If lImposto
						cQuery  :=	" SELECT E2_FORNECE,E2_LOJA "
						cQuery  +=	" FROM   "+RetSqlName("SE2")+" "
						cQuery  +=	" WHERE  E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO "
						cQuery  +=	"        + E2_FORNECE + E2_LOJA = '"+SE2->E2_TITPAI+"' AND E2_FILIAL = "+(cSQLAlias)->CT2_FILIAL+""
						If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")
						//TCQuery Abre uma workarea com o resultado da query
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
						
						cClFrOri := (cAlias)->E2_FORNECE
						cLjOri   := (cAlias)->E2_LOJA
					EndIf	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					//³Analise se existe mais de 1 item com contas diferentes³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					cQuery  :=	" SELECT   D1_CONTA,                          "
					cQuery  +=	"          D1_DOC,                            "
					cQuery  +=	"          D1_SERIE,                          "
					cQuery  +=	"          D1_FORNECE,                        "
					cQuery  +=	"          D1_LOJA                            "
					cQuery  +=	" FROM     "+RetSqlName("SD1")+"              "
					cQuery  +=	" WHERE    D1_FILIAL = '"+(cSQLAlias)->CT2_FILIAL+"'   "
					cQuery  +=	" AND      D1_DOC = '"+cNumero+"'             "
					cQuery  +=	" AND      D1_SERIE = '"+cPrefixo+"'          "
					cQuery  +=	" AND      D1_FORNECE = '"+If(lImposto, cClFrOri, cClifor)+"'         "
					cQuery  +=	" AND      D1_LOJA = '"+If(lImposto, cLjOri, cLoja)+"'              "
					cQuery  +=	" AND      D_E_L_E_T_ = ' '                   "
					cQuery  +=	" GROUP BY D1_CONTA,                          "
					cQuery  +=	"          D1_DOC,                            "
					cQuery  +=	"          D1_SERIE,                          "
					cQuery  +=	"          D1_FORNECE,                        "
					cQuery  +=	"          D1_LOJA                            "
					         
					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")
					//TCQuery Abre uma workarea com o resultado da query
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define a quantidade de registros a processar                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					COUNT TO nTotReg
					nCont := 1
					(cAlias)->(DbGotop())
					While (cAlias)->(!Eof())
						   //&("cCtaDesp"+Alltrim(Str(nCont))):= (cAlias)->D1_CONTA 
						   cCtaDesp1 := (cAlias)->D1_CONTA 
						   nCont++
						  (cAlias)->(dbSkip())
					EndDo 

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
					//³Tratamento referente a conta de resultado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
					If nTotReg == 0 
						cCtaDesp1 := Alltrim(SE2->E2_DEBITO)
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Fecha tabela temporaria aberta ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")  
				Endif
			Endif
			If cTabOri == "SEF" .And. !Empty(SEF->EF_FORNECE)
				SE2->(DbSetOrder(1))
				If SE2->(DbSeek(XFILIAL("SE2") + cPrefixo + cNumero + cParcela + cTipo + cClifor + cLoja ))
					dVenci  := SE2->E2_VENCTO
					dEmissa := SE2->E2_EMISSAO 
					
					cTPagto := "P"
					lImposto := .F.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Variáveis com os tipos de títulos³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//TAXA
					IF (SE2->E2_TIPO $ MVISS+"/"+MVTAXA+"/"+MVTXA+"/"+MVINSS+"/"+"SES"+"/"+"AB-")
						lImposto := .T.				
					ENDIF
					If lImposto
						cQuery  :=	" SELECT E2_FORNECE,E2_LOJA "
						cQuery  +=	" FROM   "+RetSqlName("SE2")+" "
						cQuery  +=	" WHERE  E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO "
						cQuery  +=	"        + E2_FORNECE + E2_LOJA = '"+SE2->E2_TITPAI+"' AND E2_FILIAL = "+(cSQLAlias)->CT2_FILIAL+" "
						If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")
						//TCQuery Abre uma workarea com o resultado da query
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
						
						cClFrOri := (cAlias)->E2_FORNECE
						cLjOri   := (cAlias)->E2_LOJA
					EndIf	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					//³Analise se existe mais de 1 item com contas diferentes³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					cQuery  :=	" SELECT   D1_CONTA,                          "
					cQuery  +=	"          D1_DOC,                            "
					cQuery  +=	"          D1_SERIE,                          "
					cQuery  +=	"          D1_FORNECE,                        "
					cQuery  +=	"          D1_LOJA                            "
					cQuery  +=	" FROM     "+RetSqlName("SD1")+"              "
					cQuery  +=	" WHERE    D1_FILIAL = '"+(cSQLAlias)->CT2_FILIAL+"'   "
					cQuery  +=	" AND      D1_DOC = '"+cNumero+"'             "
					cQuery  +=	" AND      D1_SERIE = '"+cPrefixo+"'          "
					cQuery  +=	" AND      D1_FORNECE = '"+If(lImposto, cClFrOri, cClifor)+"'         "
					cQuery  +=	" AND      D1_LOJA = '"+If(lImposto, cLjOri, cLoja)+"'              "
					cQuery  +=	" AND      D_E_L_E_T_ = ' '                   "
					cQuery  +=	" GROUP BY D1_CONTA,                          "
					cQuery  +=	"          D1_DOC,                            "
					cQuery  +=	"          D1_SERIE,                          "
					cQuery  +=	"          D1_FORNECE,                        "
					cQuery  +=	"          D1_LOJA                            "
					         
					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")
					//TCQuery Abre uma workarea com o resultado da query
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define a quantidade de registros a processar                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					COUNT TO nTotReg
					nCont := 1
					(cAlias)->(DbGotop())
					While (cAlias)->(!Eof())
						   //&("cCtaDesp"+Alltrim(Str(nCont))):= (cAlias)->D1_CONTA 
						   cCtaDesp1 := (cAlias)->D1_CONTA 
						   nCont++
						  (cAlias)->(dbSkip())
					EndDo 
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Tratamento referente a conta de resultado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nTotReg == 0 
						cCtaDesp1 := Alltrim(SE2->E2_DEBITO)
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Fecha tabela temporaria aberta ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")  
				Endif
			Endif
			
			If cTabOri == "SE5" .And. SE5->E5_RECPAG == "R"
				cTPagto   := "R"
				SE1->(DbSetOrder(2))
				If SE1->(DbSeek(XFILIAL("SE1") + cClifor + cLoja + cPrefixo + cNumero + cParcela + cTipo ))
					dVenci := SE1->E1_VENCTO
					dEmissa := SE1->E1_EMISSAO
					cTPagto   := "R"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					//³Analise se existe mais de 1 item com contas diferentes³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					cQuery  :=	" SELECT   D2_CONTA,                          "
					cQuery  +=	"          D2_DOC,                            "
					cQuery  +=	"          D2_SERIE,                          "
					cQuery  +=	"          D2_CLIENTE,                        "
					cQuery  +=	"          D2_LOJA                            "
					cQuery  +=	" FROM     "+RetSqlName("SD2")+"              "
					cQuery  +=	" WHERE    D2_FILIAL = '"+(cSQLAlias)->CT2_FILIAL+"'   "
					cQuery  +=	" AND      D2_DOC = '"+cNumero+"'             "
					cQuery  +=	" AND      D2_SERIE = '"+cPrefixo+"'          "
					cQuery  +=	" AND      D2_CLIENTE = '"+cClifor+"'         "
					cQuery  +=	" AND      D2_LOJA = '"+cLoja+"'              "
					cQuery  +=	" AND      D_E_L_E_T_ = ' '                   "
					cQuery  +=	" GROUP BY D2_CONTA,                          "
					cQuery  +=	"          D2_DOC,                            "
					cQuery  +=	"          D2_SERIE,                          "
					cQuery  +=	"          D2_CLIENTE,                        "
					cQuery  +=	"          D2_LOJA                            "
					
					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")					
					//TCQuery Abre uma workarea com o resultado da query
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define a quantidade de registros a processar                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					COUNT TO nTotReg
					nCont := 1
					(cAlias)->(DbGotop())
					While (cAlias)->(!Eof())
							//&("cCtaDesp"+Alltrim(Str(nCont))):= (cAlias)->D2_CONTA 
							cCtaDesp1 := (cAlias)->D2_CONTA 
						   nCont++
						  (cAlias)->(dbSkip())
					EndDo 
										
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Tratamento referente a conta de resultado³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nTotReg == 0 
						cCtaDesp1 := SE1->E1_CREDIT
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Fecha tabela temporaria aberta ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"") 
				Endif
			Endif
			If cTabOri == "SEF" .And. !Empty(SEF->EF_CLIENTE)
				cTPagto   := "R"
				SE1->(DbSetOrder(2))
				If SE1->(DbSeek(XFILIAL("SE1") + cClifor + cLoja + cPrefixo + cNumero + cParcela + cTipo ))
					dVenci  := SE1->E1_VENCTO
					dEmissa := SE1->E1_EMISSAO
					cTPagto := "R"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					//³Analise se existe mais de 1 item com contas diferentes³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
					cQuery  :=	" SELECT   D2_CONTA,                          "
					cQuery  +=	"          D2_DOC,                            "
					cQuery  +=	"          D2_SERIE,                          "
					cQuery  +=	"          D2_CLIENTE,                        "
					cQuery  +=	"          D2_LOJA                            "
					cQuery  +=	" FROM     "+RetSqlName("SD2")+"              "
					cQuery  +=	" WHERE    D2_FILIAL = '"+(cSQLAlias)->CT2_FILIAL+"'   "
					cQuery  +=	" AND      D2_DOC = '"+cNumero+"'             "
					cQuery  +=	" AND      D2_SERIE = '"+cPrefixo+"'          "
					cQuery  +=	" AND      D2_CLIENTE = '"+cClifor+"'         "
					cQuery  +=	" AND      D2_LOJA = '"+cLoja+"'              "
					cQuery  +=	" AND      D_E_L_E_T_ = ' '                   "
					cQuery  +=	" GROUP BY D2_CONTA,                          "
					cQuery  +=	"          D2_DOC,                            "
					cQuery  +=	"          D2_SERIE,                          "
					cQuery  +=	"          D2_CLIENTE,                        "
					cQuery  +=	"          D2_LOJA                            "

					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"")
					//TCQuery Abre uma workarea com o resultado da query
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define a quantidade de registros a processar                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					COUNT TO nTotReg
					nCont := 1
					(cAlias)->(DbGotop())
					While (cAlias)->(!Eof())
							//&("cCtaDesp"+Alltrim(Str(nCont))):= (cAlias)->D2_CONTA 
							cCtaDesp1 := (cAlias)->D2_CONTA 
						   nCont++
						  (cAlias)->(dbSkip())
					EndDo 
					
					If nTotReg == 0 
						cCtaDesp1 := SE1->E1_CREDIT
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Fecha tabela temporaria aberta ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If(Select(cAlias) > 0, (cAlias)->(dbCloseArea()),"") 
				Endif                                                                      
				
			Endif
        
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento referente a conta de resultado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SUBS((cSQLAlias)->CT2_DEBITO,1,1) >= "5" 
			cCtaDesp1 := (cSQLAlias)->CT2_DEBITO
		ElseIf SUBS((cSQLAlias)->CT2_CREDIT,1,1) >= "5"		
			cCtaDesp1 := (cSQLAlias)->CT2_CREDIT
        EndIf
        
        If cEmpAnt == "12"
             cCtaReg := "2110"
        Else
        	 cCtaReg := "2109"
   		EndIf
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Entrada  Financeiro / Caixa contra um grupo específico de contas, trazer a conta do grupo específico ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       IF (SubStr((cSQLAlias)->CT2_DEBITO,1,4)     $ "2102/2103/2106/2107/1102/"+cCtaReg) .And. (SubStr((cSQLAlias)->CT2_CREDIT,1,4) $ "110102/110103/110105")
       		 cCtaDesp1 := (cSQLAlias)->CT2_DEBITO
       ElseIf (SubStr((cSQLAlias)->CT2_CREDIT,1,4) $ "2102/2103/2106/2107/1102/"+cCtaReg) .And. (SubStr((cSQLAlias)->CT2_DEBITO,1,6) $ "110102/110103/110105")
      		 cCtaDesp1 := (cSQLAlias)->CT2_CREDIT
       EndIf  
       
                 
		// Grava registro a ser impresso
		DbSelectArea(cSqlAlias3)
		RecLock(cSqlAlias3,.T.)
			(cSqlAlias3)->FILIAL   :=  (cSQLAlias)->CT2_FILIAL
			(cSqlAlias3)->DATAFIN  :=  dData
			(cSqlAlias3)->LOTE     := (cSQLAlias)->CT2_LOTE
			(cSqlAlias3)->SBLOTE   := (cSQLAlias)->CT2_SBLOTE
			(cSqlAlias3)->DOC      := (cSQLAlias)->CT2_DOC
			(cSqlAlias3)->LINHA    := (cSQLAlias)->CT2_LINHA
			(cSqlAlias3)->MOEDA    := (cSQLAlias)->CT2_MOEDLC
			(cSqlAlias3)->TIPO     := IIf((cSQLAlias)->CT2_DC=="1","Debito",IIf((cSQLAlias)->CT2_DC=="2","Credito","Partida Dobrada"))
			(cSqlAlias3)->DEBITO   := (cSQLAlias)->CT2_DEBITO
			(cSqlAlias3)->CREDITO  := (cSQLAlias)->CT2_CREDIT
			(cSqlAlias3)->VALOR    := IIf(nValor == 0 , (cSQLAlias)->CT2_VALOR ,nValor)
			(cSqlAlias3)->HISTORI  := (cSQLAlias)->CT2_HIST
			(cSqlAlias3)->CCUSTOD  := (cSQLAlias)->CT2_CCD
			(cSqlAlias3)->CCUSTOC  := (cSQLAlias)->CT2_CCC
			(cSqlAlias3)->ITEMD    := (cSQLAlias)->CT2_ITEMD
			(cSqlAlias3)->ITEMC    := (cSQLAlias)->CT2_ITEMC
			(cSqlAlias3)->ORIGEM   := (cSQLAlias)->CT2_LP + (cSQLAlias)->CT2_SEQLAN
			(cSqlAlias3)->TIPOPGTO :=  cTPagto
			(cSqlAlias3)->TABELA   :=  cTabOri
			(cSqlAlias3)->REGISTRO :=  cRecOri
			(cSqlAlias3)->PREFIXO  :=  cPrefixo
			(cSqlAlias3)->NUMERO   :=  cNumero
			(cSqlAlias3)->PARCELA  :=  cParcela
			(cSqlAlias3)->CLIFOR   :=  cClifor
			(cSqlAlias3)->LOJA     :=  cLoja
			(cSqlAlias3)->EMISSAO  :=  dEmissa
			(cSqlAlias3)->VENCTO   :=  dVenci
			(cSqlAlias3)->CTADESP1  := cCtaDesp1
			(cSqlAlias3)->CTADESP2  := cCtaDesp2		
			(cSqlAlias3)->CTADESP3  := cCtaDesp3		
			(cSqlAlias3)->CTADESP4  := cCtaDesp4
			(cSqlAlias3)->CTADESP5  := cCtaDesp5
			(cSqlAlias3)->CTADESP6  := cCtaDesp6
			(cSqlAlias3)->CTADESP7  := cCtaDesp7
			(cSqlAlias3)->CTADESP8  := cCtaDesp8
			(cSqlAlias3)->CTADESP9  := cCtaDesp9
		MsUnlock()
	Endif
	
	/*
	
		If cTabOri == "SEF" .And. Empty(cNumero)
			
			_NUMCHEQ	:= SEF->EF_NUM
			_BANCO		:= SEF->EF_BANCO
			_AGENCIA    := SEF->EF_AGENCIA
			_CONTA		:= SEF->EF_CONTA
			
			DbSelectArea("SEF")
			DbSetOrder(4)
			If SEF->(DbSeek(XFILIAL("SEF") + _NUMCHEQ + _BANCO + _AGENCIA + _CONTA ))
				Do While .NOT. EOF() .And. _NUMCHEQ + _BANCO + _AGENCIA + _CONTA == SEF->EF_NUM + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA
					
					If Empty(SEF->EF_TITULO)
						DbSkip()
						Loop
					Endif
					
					// PEGA INFORMACOES DE EMISSAO E VENCTO DO TITULO
					If !Empty(SEF->EF_FORNECE)
						SE2->(DbSetOrder(1))
						If SE2->(DbSeek(XFILIAL("SE2") + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO + SEF->EF_FORNECE + SEF->EF_LOJA))
							_DVENCI := SE2->E2_VENCTO
							_DEMISS := SE2->E2_EMISSAO
							cClifor := SEF->EF_FORNECE
							_LOJA	:= SEF->EF_LOJA
						Endif
					Endif
					
					If !Empty(SEF->EF_CLIENTE)
						
						SE1->(DbSetOrder(2))
						If SE1->(DbSeek(XFILIAL("SE1") + SEF->EF_CLIENTE + SEF->EF_LOJACLI + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO ))
							_DVENCI := SE1->E1_VENCTO
							_DEMISS := SE1->E1_EMISSAO
							cClifor := SEF->EF_CLIENTE
							_LOJA	:= SEF->EF_LOJACLI
						Endif
					Endif
					
					DbSelectArea("TRB2")
					RecLock("TRB2",.T.)
					TRB2->FILIAL   := _cFil
					TRB2->DATAFIN  := _ddata
					TRB2->LOTE     := _cLote
					TRB2->SBLOTE   := _cSBLOT
					TRB2->DOC      := _cDoc
					TRB2->LINHA    := _cLin
					TRB2->MOEDA    := ""
					TRB2->TIPO     := ""
					TRB2->DEBITO   := ""
					TRB2->CREDITO  := ""
					TRB2->VALOR    := SEF->EF_VALOR
					TRB2->HISTORI  := SEF->EF_NUM
					TRB2->CCUSTOD  := ""
					TRB2->CCUSTOC  := ""
					TRB2->ITEMD    := ""
					TRB2->ITEMC    := ""
					TRB2->ORIGEM   := ""
					TRB2->TABELA   := cTabOri
					TRB2->REGISTRO := cRecOri
					TRB2->PREFIXO  := SEF->EF_PREFIXO
					TRB2->NUMERO   := SEF->EF_TITULO
					TRB2->PARCELA  := SEF->EF_PARCELA
					TRB2->CLIfOR   := cClifor
					TRB2->LOJA     := LOJA
					TRB2->EMISSAO  := DEMISS
					TRB2->VENCTO   := DVENCI
					MsUnlock()
					
					DbSelectArea("SEF")
					DbSetOrder(4)
					DbSkip()
					
				Enddo
				
			Endif
		EndIf
		*/
	(cSQLAlias)->(!dbSkip())
EndDo

//Aquivo de origem
cOrig     := cDirDocs + "\" + AllTrim(cTmpTb)+".DBF"
//Arquivo de destino
cDest     := cPath+"\"+AllTrim(cTmpTb)+".XLS" 

//Define a area ativa
dbSelectArea(cSqlAlias3)
//Quantidade de registros
cCount := Reccount()     
//Fecha a area
(cSqlAlias3)->(DbCloseArea())

//Quantidade de registro maior que 0
If cCount > 0
	If Aviso("Aviso - "+Procname(), "Deseja Abrir em Excel ?",  {"&Nao","&Sim"}, 1, "Atencao!") == 2
			If ! ApOleClient( 'MsExcel' )
				// MsExcel nao instalado
				MsgStop( 'MsExcel nao Instalado' ) 					
				Return               
			EndIf                    
			If File(cOrig) 
				//Copia do arquivo de origem para a pasta escolhida
			   nRetDir := MakeDir(cPath)   
			   lCopied := __CopyFile(cOrig, cDest)  
			   fErase(cOrig)   
				If ! ApOleClient( 'MsExcel' )         
					 //'MsExcel nao instalado'
					MsgStop( 'MsExcel nao instalado' )
					Return
				EndIf
				oExcelApp := MsExcel():New()      
				// Abre uma planilha
				oExcelApp:WorkBooks:Open( cDest ) 
				oExcelApp:SetVisible(.T.)
				Ferase(cOrig) 
			EndIf
	Else        
		//Copia do arquivo de origem para a pasta escolhida
		__CopyFIle(cOrig , cDest)
		//Apaga o arquivo de origem para liberar espaço
		Ferase(cOrig)
	EndIf
EndIf		

Return()


Return        



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fOriDes   ºAutor  ³Felipi Marques      º Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HelenoFonseca                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fOriDes()

Local oDlg
Local lRet		:= .T.
Local nOpca		:= 0
Local bOk    	:= {||nOpca:=1,oDlg:End()}
Local bCancel	:= {||nOpca:=2,oDlg:End()}
Private cOrig	:= Space(300)

Define MsDialog oDlg From 000,000 TO 140,400 Title OemToAnsi("Busca de diretorio...") Pixel

@ 007,005 Say OemToAnsi("Nome do arquivo:") Pixel
@ 020,005 Say OemToAnsi("Arquivo origem:") Pixel
@ 033,005 Say OemToAnsi("Nome do usuário:") Pixel
@ 008,050 Get cTmpTb Size 130,8 Picture "@!" Pixel When .T.
@ 019,050 Get cOrig	 Size 130,8 Picture "@!" Pixel When .F.
@ 032,050 Get cUserName	Size 130,8 Picture "@" Pixel When .F.
@ 019,185 Button oBtn1 Prompt OemToAnsi("...") Size 10,10 Pixel of oDlg Action fBscDir(.F.,@cOrig)

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered

If nOpca = 1
	// Se o arquivo nao for encontrado, sair da rotina.
	If !File(cOrig)
		MsgAlert("Arquivo de origem não informado ou não existe!")
		lRet := .F.
	Endif
Else
	lRet := .F.
EndIf

Return{cOrig,lRet}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fOriDes   ºAutor  ³Felipi Marques      º Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HelenoFonseca                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fBscDir(lDir,cOrig,cAquivo)

Local cTipo 	:=	"'Arquivo *|*.*|Arquivo XLS|*.XLS'"
Local cTitulo	:= "Dialogo de Selecao de Arquivos"
Local cDirIni	:= ""
Local cDrive	:= ""
Local cRet		:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExten	:= ""
Local cGetFile	:= ""

//A árvore de diretórios exibida no componente para escolha de diretórios/arquivos
cGetFile := cGetFile(cTipo,cTitulo,0,cDirIni,.T.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY,.F.) 

// Separa os componentes
SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten )

//Trata variavel de retorno
If !Empty(cFile) .And. !lDir
	cRet := cGetFile
EndIf

//Trata variavel de retorno
IF SUBSTR(cGetFile,LEN(cGetFile),1) == "\"
	cGetFile := SUBSTR(cGetFile,1,LEN(cGetFile)-1)
ENDIF

cOrig := cGetFile            			

Return()
  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG   ºAutor  ³Felipi Marques      º Data ³  08/19/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica perguntas, incluindo-as caso nao existam.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
////////////////////////////
Static Function AjusPerg()
////////////////////////////

Local i      		:= 0                 // Variaveis Auxiliares
Local j      		:= 0
Local sAlias 		:= Alias()
Local aRegs  		:= {}

DbSelectArea("SX1")               // Criar as Perguntas
SX1->(DbSetOrder(1))


aAdd(aRegs,{cPerg,"01","Data de    ?","","","mv_cha","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Ate   ?","","","mv_chb","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Filial de  ?","","","mv_chc","C",02,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Filial Ate ?","","","mv_chd","C",02,0,0,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 To Len(aRegs)          // Gravar as Perguntas
	
	DbSelectArea("SX1")
	If !SX1->(DbSeek(cPerg + aRegs[i, 2]))
		If Reclock("SX1",.T.)
			For j := 1 To FCount()
				FieldPut(j, aRegs[i, j])
			Next
			SX1->(MsUnlock())
		Endif
	Endif
Next
DbSelectArea(sAlias)

Return (.T.)
