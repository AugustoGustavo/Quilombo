#include "rwmake.ch"
#Include "Protheus.CH"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ³±±
±±³Funcao        ³RFINR01    ³ Autor ³Felipi Marques        ³ Data ³25/09/15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ³±±
±±³Descricao     ³Relatorio contábil, considerando os movimentos financeiros  ³±±
±±³			     ³e rastreamento contábil    						          ³±±
±±³			     ³						                                      ³±±
±±³			     ³                                                            ³±±
±±³			     ³                               				              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±

/*/

User Function RFINR01()

Private Tamanho     := "G"
Private Titulo      := OemToAnsi("Contabilizacao do Movimento Financeiro")
Private cDesc1      := OemToAnsi("Ira emitir listagens dos dados contabeis ba")
Private cDesc2      := OemToAnsi("seados nos movimentos financeiros.")
Private cDesc3      := ""
Private Cabec1      := ""
Private Cabec2      := ""
Private cString     := "SE1"
Private lContinua   := .T.
Private aReturn     := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 0}
Private Nomeprog    := "RFINR01"
Private nLastKey    := 0
Private Li          := 66
Private m_Pag       := 1
Private Limite      := 220
Private lAbortPrint := .F.
Private wnRel       := "RFINR01"
Private CbTxt       := Space(10)
Private CbCont      := 0
Private cPerg       := PADR("REGCXA",Len(SX1->X1_GRUPO))
Private aCampos     := ""
Private cNomArq     := ""
Private cIndArq     := ""
Private aCampos1    := ""
Private cNomArq1    := ""
Private cIndArq1    := ""

AjusPerg()  // Criar e VerIficar Perguntas

Pergunte(cPerg, .F.)

wnRel := SetPrint(cString, wnRel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F.,, .T., Tamanho)

If nLastKey == 27
	Return (.T.)
Endif

SetDefault(aReturn, cString)

If nLastKey == 27
	Return (.T.)
Endif

Processa({|| Selecao()}, Titulo)

RptStatus({|lAbortPrint| Relatorio()}, Titulo)

DbSelectArea("TRB")
TRB->(DbCloseArea())
DbSelectArea("TRB2")
TRB2->(DbCloseArea())

Return (.T.)

///////////////////////////
Static Function Selecao()
///////////////////////////

cNomArq 		:= ""
cIndArq 		:= ""
aCampos			:= {}
_cRecOri		:= ""
_cTabOri		:= ""               

Private cQuery 	:= ""              // Variaveis Auxiliares
Private nRegs  	:= 0

aAdd(aCampos, {"FILIAL"  , "C", 02, 0})
aAdd(aCampos, {"PREFIXO" , "C", 03, 0})
aAdd(aCampos, {"NUMERO " , "C", 06, 0})
aAdd(aCampos, {"PARCELA" , "C", 03, 0})
aAdd(aCampos, {"CLIfOR"  , "C", 06, 0})
aAdd(aCampos, {"LOJA"    , "C", 02, 0})
aAdd(aCampos, {"DATAFIN" , "D", 08, 0})
aAdd(aCampos, {"TABELA"  , "C", 03, 0})
aAdd(aCampos, {"REGISTRO", "C", 19, 0})

If Select("TRB") > 0
	DbSelectArea("TRB")
	TRB->(DbCloseArea())
Endif

// cria arquivo temporário
cNomArq := CriaTrab(aCampos, .T.)
DbUseArea(.T.,, cNomArq, "TRB", .F., .F.)
cChavInd := "FILIAL+DTOS(DATAFIN)+TABELA+REGISTRO"
IndRegua("TRB", cNomArq, cChavInd,,, "SelecionAndo Registros ...")

cNomArq1 := ""
cIndArq1 := ""
aCampos1 := {}

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
aAdd(aCampos1, {"NUMERO " , "C", 06, 0})
aAdd(aCampos1, {"PARCELA" , "C", 03, 0})
aAdd(aCampos1, {"CLIfOR"  , "C", 06, 0})
aAdd(aCampos1, {"LOJA"    , "C", 02, 0})
aAdd(aCampos1, {"EMISSAO" , "D", 08, 0})
aAdd(aCampos1, {"VENCTO"  , "D", 08, 0})
aAdd(aCampos1, {"TABELA"  , "C", 03, 0})
aAdd(aCampos1, {"REGISTRO", "C", 19, 0})
aAdd(aCampos1, {"CTADESP", "C", 20, 0})

If Select("TRB2") > 0
	DbSelectArea("TRB2")
	TRB2->(DbCloseArea())
Endif

cNomArq1 := CriaTrab(aCampos1, .T.)
dbUseArea( .T.,, cNomArq1, "TRB2", IIf( .F. .Or. .F., !.F., Nil ), .F. )
cChavInd1 := "FILIAL+DTOS(DATAFIN)+LOTE+SBLOTE+DOC+LINHA"
IndRegua("TRB2", cNomArq1, cChavInd1,,, "SelecionAndo Registros ...")
     
If Select("TCT2") > 0
	DbSelectArea("TCT2")
	TCT2->(DbCloseArea())
Endif
	  
// lançamentos contábeis
cQuery	:= ""		         
cQuery	:= 	" SELECT CT2_FILIAL, CT2_DATA, CT2_DEBITO, CT2_CREDIT, CT2_SEQUEN, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA, CT2_MOEDLC,  " 
cQuery	+= 	" CT2_DC, CT2_VALOR, CT2_HIST, CT2_CCD, CT2_CCC, CT2_ITEMD, CT2_ITEMC, CT2_LP, CT2_SEQLAN"
cQuery  +=	" FROM  "+ CT2->(RetSQLName("CT2")) +" CT2 "       
cQuery	+= 	" WHERE " 
cQuery	+= 	"  CT2.D_E_L_E_T_ <> '*' "                                                                            
cQuery	+= 	" AND CT2_FILIAL = "+ xFilial("CT2") + "                     
cQuery	+= 	" AND CT2_DATA BETWEEN '"+ Dtos ( mv_par01 ) +"' AND '"+ Dtos ( mv_par02 ) +"' "                     
cQuery := ChangeQuery(cQuery)
TcQuery cQuery NEW Alias "TCT2" 

Count To nRecCount
 		
ProcRegua ( nRecCount )

TCT2->( dbGoTop () )                                                                                                       
While !TCT2->( Eof () )
	           
	IncProc("Buscando contabilizacoes-> " + TCT2->CT2_DOC)
	
	_cFil   	:= TCT2->CT2_FILIAL
	_DDATA		:= CTOD("  /  /  ")
	_DEMISS		:= CTOD("  /  /  ")
	_DVENCI		:= CTOD("  /  /  ")
	_PREFIXO  	:= ""
	_NUMERO   	:= ""
	_PARCELA  	:= ""
	_CLIfOR   	:= ""
	_LOJA     	:= ""
	_TIPO		:= ""
	_NUMCHEQ	:= ""
	_BANCO		:= ""
	_AGENCIA    := ""
	_CONTA		:= ""
	_CTADESP	:= ""           
		
   	// Rastreamento de Lancamento                                           
	cQuery 	:= ""		         
	cQuery	:= 	" SELECT DISTINCT CV3_FILIAL, CV3_DTSEQ ,CV3_SEQUEN, CV3_TABORI, CV3_RECORI "
	cQuery  +=	" FROM  "+ CV3->(RetSQLName("CV3")) +" CV3 "
	cQuery	+= 	" WHERE " 
	cQuery	+= 	" CV3.D_E_L_E_T_ <> '*' " 
	cQuery	+= 	" And CV3_FILIAL ='"+ TCT2->CT2_FILIAL +"' And CV3_DTSEQ = '"+ TCT2->CT2_DATA +"' " 
	
	//cQuery	+= 	" And CV3_SEQUEN = '"+ TCT2->CT2_SEQUEN +"' And CV3_RECORI <> ' ' "
	//Alterado por Paulo Apolinario - HCCONSYS. 22.02.2012 
	cQuery	+= 	" And CV3_SEQUEN = '"+ TCT2->CT2_SEQUEN +"' And CV3_RECORI <> ' ' " 
	cQuery	+= 	" And CV3_DC = '"+ TCT2->CT2_DC +"' And CV3_VLR01 = " + cValToChar(TCT2->CT2_VALOR)
	 
	TcQuery cQuery Alias TCV3 New

	TCV3->( dbGoTop () )                                                                                                       
	_cRecOri := TCV3->CV3_RECORI 
	_cTabOri := TCV3->CV3_TABORI
	TCV3->( dbCloseArea () )   
    	
	If _cTabOri $ "SE5/SEF/SE1/SE2"
		DbSelectArea(_cTabOri)
		DbGoto(VAL(_cRecOri)) 
	Else
		DbSelectArea("TCT2")
		DbSkip()
		Loop
	Endif

	DbSelectArea("TCT2")
		
	If SUBS(TCT2->CT2_DEBITO,1,4) == "1101" .OR. SUBS(TCT2->CT2_CREDIT,1,4) == "1101"
		
		DbSelectArea(_cTabOri)
		DbGoto(VAL(_cRecOri))

		If _cTabOri == "SE5"
			_dData    := SE5->E5_DTDISPO
			_PREFIXO  := SE5->E5_PREFIXO
			_NUMERO   := SE5->E5_NUMERO
			_PARCELA  := SE5->E5_PARCELA
			_CLIfOR   := SE5->E5_CLIfOR
			_LOJA     := SE5->E5_LOJA
			_TIPO	  := SE5->E5_TIPO
			_nValor   := SE5->E5_VALOR
			
		ElseIf _cTabOri == "SEF"
			_ddata		:= SEF->EF_DATA
			_PREFIXO  	:= SEF->EF_PREFIXO
			_NUMERO   	:= SEF->EF_TITULO
			_PARCELA  	:= SEF->EF_PARCELA
			_CLIfOR   	:= SEF->EF_FORNECE
			_LOJA     	:= SEF->EF_LOJA
			_TIPO		:= SEF->EF_TIPO
			_nValor     := SEF->EF_VALOR
			
		ElseIf _cTabOri == "SE1"
			_dData    := SE1->E1_EMISSAO
			_PREFIXO  := SE1->E1_PREFIXO
			_NUMERO   := SE1->E1_NUM
			_PARCELA  := SE1->E1_PARCELA
			_CLIfOR   := SE1->E1_CLIENTE
			_LOJA     := SE1->E1_LOJA
			_TIPO	  := SE1->E1_TIPO
			_DVENCI   := SE1->E1_VENCTO
			_DEMISS   := SE1->E1_EMISSAO
			_nValor   := SE1->E1_VALOR
			//_CTADESP  := If(SE1->E1_MULTNAT<>"2",POSICIONE("SED",1,XFILIAL("SED")+SEV->EV_NATUREZ,"ED_CONTA"),SE1->E1_CREDIT)
			_CTADESP  := POSICIONE("SED",1,XFILIAL("SED")+SE1->E1_NATUREZ,"ED_CONTA")
			
		ElseIf _cTabOri == "SE2"
			_dData    := SE2->E2_EMISSAO
			_PREFIXO  := SE2->E2_PREFIXO
			_NUMERO   := SE2->E2_NUM
			_PARCELA  := SE2->E2_PARCELA
			_CLIfOR   := SE2->E2_FORNECE
			_LOJA     := SE2->E2_LOJA
			_TIPO	  := SE2->E2_TIPO
			_DVENCI   := SE2->E2_VENCTO
			_DEMISS   := SE2->E2_EMISSAO
			_nValor   := SE2->E2_VALOR
			_CTADESP  := POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA")
			
		Else
			_Ddata	  := TCT2->T2_DATA
			
			//Adicionado por Paulo Apolinario - HCCONSYS. 22.02.2012
			_PREFIXO  := ""
			_NUMERO   := ""
			_PARCELA  := ""
			_CLIfOR   := ""
			_LOJA     := ""
			_TIPO	  := ""
			_DVENCI   := CTOD("  /  /  ")
			_DEMISS   := CTOD("  /  /  ")
			_nValor   := TCT2->CT2_VALOR
			
			_CTADESP  := ""
			
			//Fim Paulo
			
		Endif
		
		If _cTabOri == "SE5" .And. SE5->E5_RECPAG == "P"
			SE2->(DbSetOrder(1))
			If SE2->(DbSeek(XFILIAL("SE2") + _PREFIXO + _NUMERO + _PARCELA + _TIPO + _CLIfOR + _LOJA ))
				_DVENCI := SE2->E2_VENCTO
				_DEMISS := SE2->E2_EMISSAO
				_CTADESP  := POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA")
			Endif
		Endif
		
		If _cTabOri == "SE5" .And. SE5->E5_RECPAG == "R"
			SE1->(DbSetOrder(2))
			If SE1->(DbSeek(XFILIAL("SE1") + _CLIfOR + _LOJA + _PREFIXO + _NUMERO + _PARCELA + _TIPO ))
				_DVENCI := SE1->E1_VENCTO
				_DEMISS := SE1->E1_EMISSAO
				_CTADESP  := POSICIONE("SED",1,XFILIAL("SED")+SE1->E1_NATUREZ,"ED_CONTA")
			Endif
		Endif
	
		If _cTabOri == "SEF" .And. !Empty(SEF->EF_FORNECE)
			SE2->(DbSetOrder(1))
			If SE2->(DbSeek(XFILIAL("SE2") + _PREFIXO + _NUMERO + _PARCELA + _TIPO + _CLIfOR + _LOJA ))
				_DVENCI := SE2->E2_VENCTO
				_DEMISS := SE2->E2_EMISSAO
				_CTADESP  := POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA")
			Endif

		Endif
		
		If _cTabOri == "SEF" .And. !Empty(SEF->EF_CLIENTE)
			
			SE1->(DbSetOrder(2))
			If SE1->(DbSeek(XFILIAL("SE1") + _CLIfOR + _LOJA + _PREFIXO + _NUMERO + _PARCELA + _TIPO ))
				_DVENCI := SE1->E1_VENCTO
				_DEMISS := SE1->E1_EMISSAO  
				_CTADESP  := POSICIONE("SED",1,XFILIAL("SED")+SE1->E1_NATUREZ,"ED_CONTA")
			Endif                                                                      
			
		Endif
		
		_cLote 	 	:= TCT2->CT2_LOTE
		_cSbLot	:= TCT2->CT2_SBLOTE
		_cDoc  	 	:= TCT2->CT2_DOC
		_cLin  	 	:= TCT2->CT2_LINHA
		_cMoeda	:= TCT2->CT2_MOEDLC
		_cTipo 		:= TCT2->CT2_DC
		_cCtaDB 	:= TCT2->CT2_DEBITO
		_cCtaCR 	:= TCT2->CT2_CREDIT
		_nValor 	:= IIf(_nvalor == 0 , TCT2->CT2_VALOR,_nvalor)
		_nHist  	:= TCT2->CT2_HIST
		_cCCD   	:= TCT2->CT2_CCD
		_cCCC  		:= TCT2->CT2_CCC
		_cITEMD 	:= TCT2->CT2_ITEMD
		_cITEMC 	:= TCT2->CT2_ITEMC
		_cOrig  	:= TCT2->CT2_LP + TCT2->CT2_SEQLAN
		
		// GERA REGISTRO                                  
		DbSelectArea("TRB2")
		RecLock("TRB2",.T.)
		TRB2->FILIAL   := _cFil
		TRB2->DATAFIN  := _ddata
		TRB2->LOTE     := _cLote
		TRB2->SBLOTE   := _cSBLOT
		TRB2->DOC      := _cDoc
		TRB2->LINHA    := _cLin
		TRB2->MOEDA    := _cMoeda
		TRB2->TIPO     := IIf(_cTipo=="1","Debito",IIf(_cTipo=="2","Credito","Partida Dobrada"))
		TRB2->DEBITO   := _cCTADB
		TRB2->CREDITO  := _cCTACR
		TRB2->VALOR    := _nVALOR
		TRB2->HISTORI  := _nHIST
		TRB2->CCUSTOD  := _cCCD
		TRB2->CCUSTOC  := _cCCC
		TRB2->ITEMD    := _cITEMD
		TRB2->ITEMC    := _cITEMC
		TRB2->ORIGEM   := _cORIG
		TRB2->TABELA   := _cTabOri
		TRB2->REGISTRO := _cRecOri
		TRB2->PREFIXO  := _PREFIXO
		TRB2->NUMERO   := _NUMERO
		TRB2->PARCELA  := _PARCELA
		TRB2->CLIfOR   := _CLIfOR
		TRB2->LOJA     := _LOJA
		TRB2->EMISSAO  := _DEMISS
		TRB2->VENCTO   := _DVENCI
		TRB2->CTADESP  := _CTADESP
		MsUnlock()
		
		If _cTabOri == "SEF" .And. Empty(_NUMERO)
			
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
							_CLIfOR := SEF->EF_FORNECE
							_LOJA	:= SEF->EF_LOJA
						Endif
					Endif
					
					If !Empty(SEF->EF_CLIENTE)
						
						SE1->(DbSetOrder(2))
						If SE1->(DbSeek(XFILIAL("SE1") + SEF->EF_CLIENTE + SEF->EF_LOJACLI + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO ))
							_DVENCI := SE1->E1_VENCTO
							_DEMISS := SE1->E1_EMISSAO
							_CLIfOR := SEF->EF_CLIENTE
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
					TRB2->TABELA   := _cTabOri
					TRB2->REGISTRO := _cRecOri
					TRB2->PREFIXO  := SEF->EF_PREFIXO
					TRB2->NUMERO   := SEF->EF_TITULO
					TRB2->PARCELA  := SEF->EF_PARCELA
					TRB2->CLIfOR   := _CLIfOR
					TRB2->LOJA     := _LOJA
					TRB2->EMISSAO  := _DEMISS
					TRB2->VENCTO   := _DVENCI
					MsUnlock()
					
					DbSelectArea("SEF")
					DbSetOrder(4)
					DbSkip()
					
				Enddo
				
			Endif
			
		Endif
		
	Endif
	
	DbSelectArea("TCT2")
	DbSkip()
	
Enddo

Return (.T.)

///////////////////////////
Static Function Relatorio()
///////////////////////////
//

Li     := 66
nTipo  := IIf(aReturn[4] == 1, 15, 18)
Titulo := "Lancamentos contabeis pela data Financeira"
Cabec1 := "FIL DATA FIN   LOTE   SBLOTE DOC    LIN MOE TIPO                 DEBITO               CREDITO              VALOR             HISTORICO                                CC DEB    CC CRED   ITEM DEB  ITEM CRED ORIGEM"
Cabec2 := ""
//                   1         2         3         4         5         6         7         8         9         1         1         2         3         4         5         6         7         8         9         2         1         2
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                                                                                             0

SetPrc(0, 0)

DbSelectArea("TRB2")
SetRegua(TRB2->(LastRec()))
TRB2->(DbGotop())
_nTotVal := 0

While TRB2->(!Eof())
	IncRegua()
	If lAbortPrint
		Exit
	Endif
	If Li > 58
		Li := Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo) + 1
	Endif
	@ Li, 000 Psay TRB2->FILIAL
	@ Li, 004 Psay TRB2->DATAFIN
	@ Li, 015 Psay TRB2->LOTE
	@ Li, 022 Psay TRB2->SBLOTE
	@ Li, 029 Psay TRB2->DOC
	@ Li, 036 Psay TRB2->LINHA
	@ Li, 040 Psay TRB2->MOEDA
	@ Li, 044 Psay TRB2->TIPO
	@ Li, 065 Psay TRB2->DEBITO
	@ Li, 086 Psay TRB2->CREDITO
	@ Li, 107 Psay TRB2->VALOR PICTURE "@E 99,999,999,999.99"
	@ Li, 125 Psay TRB2->HISTORI
	@ Li, 166 Psay TRB2->CCUSTOD
	@ Li, 176 Psay TRB2->CCUSTOC
	@ Li, 186 Psay TRB2->ITEMD
	@ Li, 196 Psay TRB2->ITEMC
	@ Li, 206 Psay TRB2->ORIGEM
	Li += 1
	_nTotVal   += TRB2->VALOR
	DbSelectArea("TRB2")
	TRB2->(DbSkip())
Enddo
Li += 1
If Li > 58
	Li := Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo) + 1
Endif
@ Li,000 PSAY "TOTAL GERAL ----->"
@ Li,107 PSAY _nTotVal PICTURE "@E 99,999,999,999.99"

Set Device To Screen

If aReturn[5] == 1                // Se Saida p/ Disco, Ativa Spool
	
	Set Printer To
	DbCommitAll()
	OurSpool(wnRel)
	
Endif

Ms_Flush()

cArqSai := Alltrim(Mv_Par04)      // Arquivo de Saida

If File(cArqSai)
	FErase(cArqSai)
Endif

cArqTmp := cNomArq1 + ".DBF"

If !Empty(cArqSai) .And. Mv_Par03 == 1
	Copy File &cArqTmp To &cArqSai           // Copiar Arquivo de Dados
Endif

FErase(cNomArq1 + ".DBF")
FErase(cIndArq1 + OrdBagExt())

If Mv_Par03 == 1 .And. File(cArqSai)        // Mostrar Planilha
	
	If !ApOleClient("MsExcel")
		
		MsgBox("Microsoft Excel Nao Instalado !!!", "Atencao !!!", "INFO")
		
	Else                           // Abrir o Arquivo Como Uma Planilha Excel
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cArqSai)
		oExcelApp:SetVisible(.T.)
		
	Endif
	
Endif

Return (.T.)

////////////////////////////
Static Function AjusPerg()
////////////////////////////

Local i      		:= 0                 // Variaveis Auxiliares
Local j      		:= 0
Local sAlias 		:= Alias()
Local aRegs  		:= {}

DbSelectArea("SX1")               // Criar as Perguntas
SX1->(DbSetOrder(1))

aAdd(aRegs,{cPerg,"01","Data de  ?","","","mv_cha","D",08,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Ate ?","","","mv_chb","D",08,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Gerar Planilha p/ Excel      ?","","","mv_chc","N",01,0,0,"C","","Mv_Par03","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Pasta e Arquivo p/ Planilha  ?","","","mv_chd","C",40,0,0,"G","NaoVazio()","Mv_Par04","","","","C:\ARQ\GERCAIXA.DBF","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
