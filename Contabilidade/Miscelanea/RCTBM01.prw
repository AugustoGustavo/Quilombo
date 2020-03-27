#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBM01   �Autor  �Felipi Marques      � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � IMPORTA��O DE ARQUIVOS .TXT - FOLHA PARA CTB               ���
�������������������������������������������������������������������������͹��
���Uso       � QUILOMBO                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/


User Function RCTBM01()

Local   lOk      := .F.
Private cFile 	 := Space(50)
Private cMemo	 := "ATEN��O: O ARQUIVO DEVE SEQUIR O LAYOUT PADRAO, " + CHR(13)+CHR(10)+; 
                    "-- USO ESPECIFICO PARA IMPORTACAO --."+ CHR(13)+CHR(10)
Private oFile
Private oMemo
Private oFont:=TFont():New("Arial",08,10,,.F.,,,,.F.,.F.)
Private _oDlg			
Private cmensagem := ''
Private nLimite := 0

DEFINE MSDIALOG _oDlg TITLE "IMPORTA��O DE ARQUIVOS .TXT - FOLHA PARA CTB" FROM C(178),C(181) TO C(413),C(763) PIXEL

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


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuscArq   �Autor  �Felipi Marques      � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para sele��o do arquivo de improta��o             ���
�������������������������������������������������������������������������͹��
���Uso       � Quilombo                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function BuscArq()

cFile := cGetFile( "*.TXT |*.TXT", OemToAnsi( 'Selecione o Arquivo Texto para Importa��o' ), 0 ,, .T. )
oFile:Refresh()

Return     

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuscArq   �Autor  �Felipi Marques      � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para improta��o do arquivo TXT                    ���
�������������������������������������������������������������������������͹��
���Uso       � Quilombo                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/   

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

//���������������������������Ŀ
//�DE-PARA DE EMRPESA E FILIAL�
//�����������������������������
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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuscArq   �Autor  �Felipi Marques      � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descricao  � Funcao responsavel por manter o Layout independente da    ���
���           � resolucao horizontal do Monitor do Usuario.               ���
�������������������������������������������������������������������������͹��
���Uso       � Quilombo                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/   

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