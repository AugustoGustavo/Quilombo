#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBM01   บAutor  ณFelipi Marques      บ Data ณ  04/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ IMPORTAวรO DE ARQUIVOS .TXT - FOLHA PARA CTB               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ QUILOMBO                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/


User Function RCTBM01()

Local   lOk      := .F.
Private cFile 	 := Space(50)
Private cMemo	 := "ATENวรO: O ARQUIVO DEVE SEQUIR O LAYOUT PADRAO, " + CHR(13)+CHR(10)+; 
                    "-- USO ESPECIFICO PARA IMPORTACAO --."+ CHR(13)+CHR(10)
Private oFile
Private oMemo
Private oFont:=TFont():New("Arial",08,10,,.F.,,,,.F.,.F.)
Private _oDlg			
Private cmensagem := ''
Private nLimite := 0

DEFINE MSDIALOG _oDlg TITLE "IMPORTAวรO DE ARQUIVOS .TXT - FOLHA PARA CTB" FROM C(178),C(181) TO C(413),C(763) PIXEL

@ C(007),C(007) Say "Este programa tem como objetivo importar dados de arquivos .TXT para tabelas Microsiga. " COLOR CLR_BLUE PIXEL OF _oDlg FONT oFont
@ C(015),C(007) Say "Uso exclusivo - Quilombo." COLOR CLR_BLUE PIXEL OF _oDlg FONT oFont

@ C(040),C(007) Say "SELECIONE O ARQUIVO PARA IMPORTACAO:" COLOR CLR_BLUE PIXEL OF _oDlg
@ C(048),C(007) MsGet oFile Var cFile Size C(148),C(010) COLOR CLR_BLACK PIXEL OF _oDlg

@ C(048),C(158) Button "Arquivo" Size C(037),C(012) PIXEL OF _oDlg ACTION BuscArq()

@ C(067),C(007) GET oMemo Var cMemo MEMO Size C(226),C(049) PIXEL OF _oDlg COLOR CLR_BLACK
oMemo:lwordwrap := .T.

@ C(078),C(247) Button "IMPORTAR" Size C(037),C(012) PIXEL OF _oDlg ACTION Processa( {|| ImportaArq( cFile )}, 'Importando arquivo')  
@ C(096),C(247) Button "FECHAR" Size C(037),C(012) PIXEL OF _oDlg ACTION (_oDlg:End())

ACTIVATE MSDIALOG _oDlg CENTERED

Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscArq   บAutor  ณFelipi Marques      บ Data ณ  04/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para sele็ใo do arquivo de improta็ใo             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Quilombo                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function BuscArq()

cFile := cGetFile( "*.TXT |*.TXT", OemToAnsi( 'Selecione o Arquivo Texto para Importa็ใo' ), 0 ,, .T. )
oFile:Refresh()

Return     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscArq   บAutor  ณFelipi Marques      บ Data ณ  04/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para improta็ใo do arquivo TXT                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Quilombo                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/   

Static Function ImportaArq( cFile )

Local cBuffer
Local aCampos 	:= {} 
Local dDataLanc    := CTOD("")
Local cSubLote     := space(3)
Local aCab      := {}
Local aItens     := {}
Local cQryImp     := ""
Local cPath       := ""
Local cAliasImp   := ""
Local cData       
Local cDtlanc
Local cSbLote     := "001"
Local cDescEmp    := ""
Local cTmpTab  := ""
Local nLinha  := 0
Local nPasso   := 0
Local nTamLinha
Local cBuffer  := ""
Local nTamArq  := 0
Local nHandle1  := 0
Local cEmp   := ""  
Local cMeses := "   " 
Local cAno   := "   "
Local nAno := YEAR(dDataBase)
Local nMes := MONTH(dDataBase)
Local aOrdem := {}
Local cMeses := Alltrim(Substr(Str(nMes,4),3,2)+Substr(Str(nAno,4),3,2))
Local cLote       := "90"+cMeses
Local cLinha  :=  "001"    
Local aEmpDP  := {}
Private cDirImpFol := ""
Private aFiles     := {}
Private lMsErroAuto := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDE-PARA DE EMRPESA E FILIALณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aEmpDP,{"495" ,;  //DE
				  "71" ,; //PARA - EMPRESA
          	  "01" }) //PARA - FILIAL

dbSelectArea("CT2")

If Empty( cFile )
	Return
endif

ft_fuse(cFile)

ProcRegua(FT_FLASTREC())
FT_FGOTOP()

nCount := 1
                        
cBuffer  := FT_FREADLN()
 
cData   :=  Substr(cBuffer,436,10) 
While ! ft_feof()

	cBuffer  := FT_FREADLN()
	nTamLinha  := Len(cBuffer)
	 cAno       := Substr(cBuffer,073,2)
	cMeses      :=  Substr(cBuffer,071,2) 
	cLote       := "FL"+cMeses+cAno
	IF Empty(cBuffer)
		FT_FSKIP()
		Loop
	EndIF
   cMoeda   := '01'
	cTipo    := Substr(cBuffer,004,1)
	cDebito  := If(Substr(cBuffer,005,8)=="00000000","",Substr(cBuffer,005,8))
	cCredito := If(Substr(cBuffer,013,8)=="00000000","",Substr(cBuffer,013,8)) 
	If !Empty(cDebito)
		cCCD     := If(Substr(cBuffer,021,4)=="0000","",Substr(cBuffer,021,4)) 
 		cCCC     := ""
	Else
		cCCD     := ""
 		cCCC     := If(Substr(cBuffer,021,4)=="0000","",Substr(cBuffer,021,4)) 
	EndIf

	cHist    := Substr(cBuffer,025,30)
	cValor   := StrTran(Substr(cBuffer,055,12),",",".")
	cDtlanc  := Substr(cBuffer,067,8)
 		
	If cCCD == "0108"		 
			cItemD   := "0802"
	Else
			cItemD   := ""
	EndIf

	If cCCC == "0108"	
		cItemC   := "0802"
	Else
	  cItemC   := ""
	EndIf	
	
	cClasseD := ""
	cClasseC := ""
	
	If  nCount ==  1
		aCab := {  {"dDataLanc" ,stod(cDtlanc) ,NIL},;
						{"cLote"     ,Alltrim(cLote)    ,NIL},;
						{"cSubLote"  ,Alltrim(cSbLote)  ,NIL}}
		
		aItens := {}
	Endif
	

	
	aadd(aItens, { {"CT2_FILIAL" ,xFilial("CT2")         , NIL},;
						{"CT2_LINHA"  ,cLinha                 , NIL},;
						{"CT2_MOEDLC" ,Alltrim(cMoeda)        , NIL},;
						{"CT2_DC"     ,Alltrim(cTipo)         , NIL},;
						{"CT2_DEBITO" ,Alltrim(cDebito)       , NIL},;
						{"CT2_CREDIT" ,Alltrim(cCredito)      , NIL},;
						{"CT2_VALOR"  ,Val(Alltrim(cValor))   , NIL},;
						{"CT2_HIST"   ,LEFT(Alltrim(cHist),30), NIL},;
						{"CT2_CCD"    ,Alltrim(cCCD)       , NIL},;
						{"CT2_CCC"    ,Alltrim(cCCC)       , NIL},;
						{"CT2_ITEMD"  ,Alltrim(cItemD)      , NIL},;
						{"CT2_ITEMC"  ,Alltrim(cItemC)      , NIL},;
						{"CT2_CLVLDB" ,Alltrim(cClasseD)      , NIL},;
						{"CT2_CLVLCR" ,Alltrim(cClasseC)      , NIL},;
						{"CT2_ORIGEM" ,"CTBA102"       , NIL}})
		
	FT_FSKIP()
	cLinha := soma1(cLinha)
	nCount++
	
EndDo

ft_fuse()

If Len(aItens) > 0

	ChkFile("CT1") ; 	ChkFile("CT2") ;	ChkFile("CT3")  ;	ChkFile("CT7")
	ChkFile("CTU") ;	ChkFile("CTI") ;	ChkFile("CTG")  ;	ChkFile("CTD")
		
	DbSelectArea("CT2")
	DbSelectArea("CT7")
	
	MsgRun("Aguarde... Efetuando gravacao do(s) lancamento(s) ...",,{||  MSExecAuto( {|x,y,z| CTBA102(x,y,z)},aCab,aItens,3) } )
	
	If lMsErroAuto
		MostraErro()
	Endif
Endif

return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscArq   บAutor  ณFelipi Marques      บ Data ณ  04/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da    ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.               ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Quilombo                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/   

Static Function C(nTam) 

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

Return Int(nTam)