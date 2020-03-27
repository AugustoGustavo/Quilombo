#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

#DEFINE PAD_LEFT	0
#DEFINE PAD_RIGHT	1
#DEFINE PAD_CENTER	2

/*
Função.....: QLCTBR01
Autor......: Eurai Rapelli - HC Consys
Data.......: 26/04/2013
Descrição..: Relatório de caixa compentencia
*/
User Function QLCTBR01()
Local cDesc				:= " Relatório de caixa compentencia "//Descrição usada no tNewProcess
Local aInfoCustom		:= {}

Private cTitulo			:= " Relatório de caixa compentencia "
Private cPerg			:= "QLCTBR02"
Private cFig			:= "lgrl01.bmp"//Logotipo
Private oPrint			:= TMSPrinter():New(cTitulo)			//Funcao que inicia a classe para impressao em OOP
Private oFont07a		:= TFont():New('Arial',,07,,.F.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private oFont07b		:= TFont():New('Arial',,07,,.T.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private oFont08a		:= TFont():New('Arial',,08,,.F.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private oFont08b		:= TFont():New('Arial',,08,,.T.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private oFont09a		:= TFont():New('Arial',,09,,.F.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private oFont09b		:= TFont():New('Arial',,09,,.T.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private oFont10a		:= TFont():New('Arial',,10,,.F.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private oFont10b		:= TFont():New('Arial',,10,,.T.,,,,.F.,.F.)	//Negrito/Italico/Sublinhado
Private nLin			:= 10
Private nLinLimite 		:= 2250	//Limite da folha A4
Private nLinHalf		:= nLinLimite/2	//Limite da folha A4
Private nColInicio 		:= 100									//Coluna de Inicio
Private nColLimite 		:= 3300									//Tamanho limite de coluna. Tamanho da folha.
Private nColHalf		:= nColLimite/2								//Tamanho limite de coluna. Tamanho da folha.
Private nPag 	  	 	:= 1										//Numero de pagina
Private nRegs1			:= 0
Private nRegs2			:= 0

Private lInvert		:= .F.
Private lImpMult	:= .F.

Private cCRLF		:= CRLF
Private cData		:= Dtoc(date())+" - "+cValToChar(Time()) + ' '
Private cNomeFun	:= FUNNAME()

//Variaveis
Private cFilialSD1	:= xFilial("SD1")
Private cFilialSE1	:= xFilial("SE1")
Private cFilialSE2	:= xFilial("SE2")
Private cFilialSED	:= xFilial("SED")
Private cFilialSEF	:= xFilial("SEF")
Private cFilialSEV	:= xFilial("SEV")
Private cFilialCT2	:= xFilial("CT2")

/*
Private cAbc		:= '43' 
cFilialSD1	:= cAbc
cFilialSE1	:= cAbc
cFilialSE2	:= cAbc
cFilialSED	:= cAbc
cFilialSEF	:= cAbc
cFilialSEV	:= cAbc
cFilialCT2	:= cAbc
*/

Private cPic01		:= PesqPict('CT2', 'CT2_VALOR')

Private nTam01		:= TamSX3('CT2_ORIGEM')[1]

//Abrir Areas

dbSelectArea('SD1')
dbSelectArea('SE1')
SE1->( dbSetOrder( 2 ) )
dbSelectArea('SE2')
dbSelectArea('SE5')
dbSelectArea('SEF')
SEF->( dbSetOrder( 4 ) )


oPrint:SetLandscape()	// Retrato
oPrint:SetpaperSize(9)	// PAPEL A4

dbSelectArea("SM0")

Aadd(aInfoCustom,{"Setup",{|| oPrint:Setup() },"WATCH" })

ValidPerg()
tNewProcess():New(/*FUNNAME()*/cNomeFun,cTitulo,{|oSelf| CtrlPrint(oSelf) },cDesc,cPerg,aInfoCustom, .F.,5, "Gerando Relatório", .T. )

Return( Nil )

/*
Função.....: CtrlPrint()
Autor......: Eurai Rapelli - HC Consys
Parametro..: oSelf > Objeto tNewProcess.
Data.......: 26/04/2013
Descrição..: Controla funções de impressoes. Usado para auxiliar tNewProcess
*/
Static Function CtrlPrint( oSelf )
Local cNomArq1	:= ""
Local cIndArq1	:= ""
Local cArqSai	:= ""

MsgRun("Gerando Consulta, aguarde...","",{|| CursorWait(), GeraQry1(),CursorArrow()})
If(Qry1->(Eof()))
	MsGBox("Não há dados!!","Atenção")
	Return(Nil)
Endif

If( MV_PAR01 == 2 )//Se imprimi parâmetros pergunta estiver SIM. segunda opção 2 do combo
	ImpPerg()//Imprime parametros selecionados
Endif

TMPCria( @cNomArq1, @cIndArq1 )
TMPGera( oSelf )

ImpCabec()
ImpCorpo( oSelf )

oSelf:SaveLog("MENSAGEM: Relatório Impresso " )

Qry1->( dbCloseArea() )


cArqSai := Alltrim(MV_PAR05)      // Arquivo de Saida

If MV_PAR04 == 1 .AND. !Empty( cArqSai )

	If File(cArqSai)
		FErase(cArqSai)
	Endif

	cArqTmp := cNomArq1 + ".DBF"
	Copy File &cArqTmp To &cArqSai           // Copiar Arquivo de Dados
Endif

TRB1->( dbCloseArea() )
FErase( cIndArq1 + OrdBagExt() )
FErase( cNomArq1 + ".DBF" )

oPrint:Preview()

If MV_PAR04 == 1 .AND. !Empty( cArqSai )
	
		
	If !ApOleClient("MsExcel")
		
		MsgBox("Microsoft Excel Nao Instalado !!!", "Atencao !!!", "INFO")
		
	Else                           // Abrir o Arquivo Como Uma Planilha Excel
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cArqSai )
		oExcelApp:SetVisible(.T.)
		
	Endif
	
Endif

Return( Nil )

/*
Função.....: GeraQry1()
Autor......: Eurai Rapelli - HC Consys
Data.......: 26/04/2013
Descrição..: Gera Qry Principal de Impressao
*/
Static Function GeraQry1()
Local cQuery	:= ""

If Select("Qry1") > 0//Verifica se ja existe alias criado
	Qry1->( dbCloseArea() )
Endif

cQuery := " SELECT "															+ cCRLF
cQuery += " 	CT2_FILIAL,T2.CT2_DATA,CT2_DEBITO,CT2_CREDIT,CT2_ORIGEM, "		+ cCRLF
cQuery += " 	CT2_SEQUEN,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LP,CT2_SEQLAN, "		+ cCRLF
cQuery += " 	CT2_LINHA,CT2_MOEDLC,T2.CT2_DC,CT2_VALOR,CT2_HIST, "			+ cCRLF
cQuery += " 	CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_CLVLDB,CT2_CLVLCR,  "	+ cCRLF
cQuery += " 	CV3_TABORI, CV3_RECORI  "										+ cCRLF
//cQuery += " 	E5.E5_PREFIXO, E5.E5_NUMERO, E5.E5_PARCELA, E5.E5_TIPO, E5.E5_CLIFOR  "	+ cCRLF
cQuery += " FROM "											+ cCRLF
cQuery += RetSqlName("CT2") + " T2 "						+ cCRLF
cQuery += " INNER JOIN  "									+ cCRLF
cQuery += RetSqlName("CV3") + " V3 "						+ cCRLF
cQuery += " ON  "											+ cCRLF
cQuery += " 	T2.CT2_FILIAL=V3.CV3_FILIAL "				+ cCRLF
cQuery += " 	AND T2.CT2_DATA=V3.CV3_DTSEQ "				+ cCRLF
cQuery += " 	AND T2.CT2_SEQUEN=V3.CV3_SEQUEN   "			+ cCRLF
//cQuery += " 	AND T2.CT2_DC=V3.CV3_DC "					+ cCRLF
//cQuery += " 	AND T2.CT2_DEBITO=V3.CV3_DEBITO "			+ cCRLF
//cQuery += " 	AND T2.CT2_CREDIT=V3.CV3_CREDIT "			+ cCRLF
cQuery += " 	AND T2.CT2_VALOR=V3.CV3_VLR01 "				+ cCRLF
cQuery += " 	AND T2.R_E_C_N_O_=V3.CV3_RECDES "			+ cCRLF
//cQuery += " INNER JOIN  "									+ cCRLF
//cQuery += RetSqlName("SE5") + " E5  "						+ cCRLF
//cQuery += " ON  "											+ cCRLF
//cQuery += " 	V3.CV3_FILIAL=E5.E5_FILIAL "				+ cCRLF
//cQuery += " 	AND V3.CV3_RECORI=E5.R_E_C_N_O_ "			+ cCRLF
cQuery += " WHERE "											+ cCRLF
cQuery += " 	CT2_FILIAL = '"+ cFilialCT2 +"'  "						+ cCRLF
cQuery += " 	AND CT2_DATA BETWEEN '"+ Dtos(MV_PAR02) +"' AND '"+ Dtos(MV_PAR03) +"' "	+ cCRLF
cQuery += " 	AND ( SubString(T2.CT2_DEBITO,1,4) IN ('1101') OR SubString(T2.CT2_CREDIT,1,4) IN ('1101','1102','7101') )  "		+ cCRLF   // INCLUIDO 1102 P/ TRAZER PA
cQuery += " 	AND SUBSTRING(T2.CT2_ORIGEM,3,1) = '5'  "					+ cCRLF
//Eurai Rapelli HCCONSYS 2013.07.10
//cQuery += " 	AND ( SUBSTRING(T2.CT2_ORIGEM,3,1) = '5' OR SUBSTRING(T2.CT2_ORIGEM,3,2) = '65' )  "					+ cCRLF
// cQuery += " 	AND SUBSTRING(T2.CT2_HIST,1,4) NOT IN ('EXCL','CANC')  "	+ cCRLF
cQuery += " 	AND V3.CV3_TABORI IN ('SE1','SE2','SE5','SEF')  "		+ cCRLF
cQuery += " 	AND T2.D_E_L_E_T_ = ''  "								+ cCRLF
cQuery += " 	AND V3.D_E_L_E_T_ = ''  "								+ cCRLF
//cQuery += " 	AND E5.D_E_L_E_T_ = ''  "								+ cCRLF
//cQuery += " 	AND E5_SITUACA<> 'C' "			    					+ cCRLF //incluido HC 29.07 (NÃO DUPLICAR MOV. BANCARIO)

//INICIO - Tratamento para não sair duas baixas de inclusão. Eurai Rapelli HCCONSYS 2013.06.26
cQuery += " 	AND NOT EXISTS (  "										+ cCRLF
cQuery += " 		SELECT   "											+ cCRLF
cQuery += " 			*   "											+ cCRLF
cQuery += " 		FROM   "											+ cCRLF
cQuery += RetSqlName("CT2") + " CT2_2  "								+ cCRLF
cQuery += " 		INNER JOIN    "										+ cCRLF
cQuery += RetSqlName("CV3") + " CV3_2  "								+ cCRLF
cQuery += " 		ON    "												+ cCRLF
cQuery += " 			CT2_2.CT2_FILIAL=CV3_2.CV3_FILIAL   "			+ cCRLF
cQuery += " 			AND CT2_2.CT2_DATA=CV3_2.CV3_DTSEQ   "			+ cCRLF
cQuery += " 			AND CT2_2.CT2_SEQUEN=CV3_2.CV3_SEQUEN     "		+ cCRLF
cQuery += " 			AND CT2_2.CT2_DC=CV3_2.CV3_DC   "				+ cCRLF
cQuery += " 			AND CT2_2.CT2_DEBITO=CV3_2.CV3_DEBITO   "		+ cCRLF
cQuery += " 			AND CT2_2.CT2_CREDIT=CV3_2.CV3_CREDIT   "		+ cCRLF
cQuery += " 			AND CT2_2.CT2_VALOR=CV3_2.CV3_VLR01   "			+ cCRLF
cQuery += " 			AND CT2_2.R_E_C_N_O_=CV3_2.CV3_RECDES "			+ cCRLF
cQuery += " 		WHERE  "											+ cCRLF
cQuery += " 			V3.CV3_RECORI = CV3_2.CV3_RECORI  "				+ cCRLF
cQuery += " 			AND V3.CV3_TABORI = CV3_2.CV3_TABORI  "			+ cCRLF
cQuery += " 			AND T2.CT2_HIST = CT2_2.CT2_HIST  "				+ cCRLF
cQuery += " 			AND T2.CT2_VALOR = CT2_2.CT2_VALOR  "			+ cCRLF
cQuery += " 			AND T2.CT2_FILIAL = CT2_2.CT2_FILIAL  "			+ cCRLF
cQuery += " 			AND T2.CT2_DC = CT2_2.CT2_DC  "					+ cCRLF
cQuery += " 			AND T2.CT2_LP <> CT2_2.CT2_LP  "				+ cCRLF
cQuery += " 			AND T2.CT2_DOC <> CT2_2.CT2_DOC  "				+ cCRLF
cQuery += " 		)  "												+ cCRLF
//FIM - Tratamento para não sair duas baixas de inclusão. Eurai Rapelli HCCONSYS 2013.06.26

cQuery += " ORDER BY CT2_DATA "											+ cCRLF

MemoWrite( '\QLCTBR01-'+ProcName(0)+'.SQL', cQuery )

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry1",.T.,.T.)

Qry1->( dbEval({|| nRegs2 += 1 }) )
nRegs1 := nRegs2 
Qry1->( dbGotop() )

Return( Nil )

/*
Função.....: GetInf
Autor......: Eurai Rapelli - HC Consys
Data.......: 13/05/2013
Descrição..: Retorna array com as informações complementares
Retorno....: aInfComp > Informações complementares
*/
Static Function GetInf()
Local cQuery	:= ""

Local dData		:= CTOD("  /  /  ")
Local nValor	:= 0
Local cPref		:= ""
Local cNum		:= ""
Local cParc		:= ""
Local cCliFor	:= ""
Local cLoja		:= ""
Local dDtVenc	:= CTOD("  /  /  ")
Local dDtEmis	:= CTOD("  /  /  ")
Local cCtaDesp	:= ""

Local cCCD		 := Qry1->CT2_CCD
Local cCCC		 := Qry1->CT2_CCC
Local cITEMD	 := Qry1->CT2_ITEMD
Local cITEMC	 := Qry1->CT2_ITEMC
Local cCLVLDB	 := Qry1->CT2_CLVLDB
Local cCLVLCR	 := Qry1->CT2_CLVLCR



Local aInfComp	:= {}

/*aInfComp
aInfComp[01] := Data
aInfComp[02] := Valor
aInfComp[03] := Prefixo
aInfComp[04] := Numero
aInfComp[05] := Parcela
aInfComp[06] := CliFor
aInfComp[07] := Loja
aInfComp[08] := Data Vencimento
aInfComp[09] := Data Emissao
aInfComp[10] := Conta Despesa
aInfComp[11] := CT2_CCD
aInfComp[12] := CT2_CCC
aInfComp[13] := CT2_ITEMD
aInfComp[14] := CT2_ITEMC
aInfComp[15] := CT2_CLVLDB
aInfComp[16] := CT2_CLVLCR
*/
/*
Necessário pegar CCC CCD ITEMC ITEMD CLASSEC CLASSED da emissão CT2.
Há casos que o origem não está preenchido corretamente. LP não preenche buscar SD1.
Registros são contabilizados emissão e baixa.
Informações são registradas na emissão.
Com a QRY1 baixa. Necessário buscar inf dos campos da emissão.
Outros casos SE1 e SE2 na função TMPGera.
2013.09.10 - Outro caso JUROS MULTA CANC MULTA E JUROS CCC e CCD na baixa.
Nesse caso pegar valor do CT2 e caso for MULTNAT SEV não imprimir o SEV.
*/

lImpMult 	:= .T.
lInvert		:= .F.

DbSelectArea( Qry1->CV3_TABORI )
DbGoto( Val( Qry1->CV3_RECORI ) ) 

If Qry1->CV3_TABORI == "SE1"

	dData		:= SE1->E1_EMISSAO
	nValor		:= SE1->E1_VALOR
	cPref		:= SE1->E1_PREFIXO
	cNum		:= SE1->E1_NUM
	cParc		:= SE1->E1_PARCELA
	cCliFor		:= SE1->E1_CLIENTE
	cLoja		:= SE1->E1_LOJA
	dDtVenc		:= SE1->E1_VENCTO
	dDtEmis		:= SE1->E1_EMISSAO
	cCtaDesp	:= POSICIONE( "SED", 1, cFilialSED + SE1->E1_NATUREZ, "ED_CONTA" )
	
ElseIf Qry1->CV3_TABORI == "SE2"

	dData		:= SE2->E2_EMISSAO
	nValor		:= SE2->E2_VALOR
	cPref		:= SE2->E2_PREFIXO
	cNum		:= SE2->E2_NUM
	cParc		:= SE2->E2_PARCELA
	cCliFor		:= SE2->E2_FORNECE
	cLoja		:= SE2->E2_LOJA
	dDtVenc		:= SE2->E2_VENCTO
	dDtEmis		:= SE2->E2_EMISSAO
	cCtaDesp	:= POSICIONE( "SED", 1, cFilialSED + SE2->E2_NATUREZ, "ED_CONTA" )

ElseIf Qry1->CV3_TABORI == "SE5"

	dData		:= SE5->E5_DATA
	//nValor		:= SE5->E5_VALOR
	cPref		:= SE5->E5_PREFIXO
	cNum		:= SE5->E5_NUMERO
	cParc		:= SE5->E5_PARCELA
	cCliFor		:= SE5->E5_CLIFOR
	cLoja		:= SE5->E5_LOJA
	dDtVenc		:= SE5->E5_DATA
	dDtEmis		:= SE5->E5_DATA
	cCtaDesp	:= POSICIONE( "SED", 1, cFilialSED + SE5->E5_NATUREZ, "ED_CONTA" )

	If 'REC. MULTA' $ Qry1->CT2_HIST
	
		nValor		:= Qry1->CT2_VALOR						//VALOR SOMENTE DA MULTA
		lImpMult 	:= .F.
		
	ElseIf 'REC JUROS' $ Qry1->CT2_HIST
	
		nValor		:= Qry1->CT2_VALOR						//VALOR SOMENTE DA MULTA
		lImpMult 	:= .F.

	ElseIf 'CANC. JUROS' $ Qry1->CT2_HIST

		nValor		:= Qry1->CT2_VALOR						//VALOR SOMENTE DO JUROS
		lImpMult 	:= .F.
		lInvert		:= .T.									//Inverter coluna para bater. canc multa e canc baixa

	ElseIf 'CANC. MULTA' $ Qry1->CT2_HIST
	
		nValor		:= Qry1->CT2_VALOR						//VALOR SOMENTE DO JUROS
		lImpMult 	:= .F.
		lInvert		:= .T.									//Inverter coluna para bater. canc multa e canc baixa

	ElseIf 'CANC. BX.' $ Qry1->CT2_HIST
	
		nValor		:= Qry1->CT2_VALOR						//VALOR SOMENTE DO JUROS
		lInvert		:= .T.									//Inverter coluna para bater. canc multa e canc baixa

	ElseIf 'JUROS S/TIT.' $ Qry1->CT2_HIST
	
		nValor		:= Qry1->CT2_VALOR						//VALOR SOMENTE DO JUROS
		
	ElseIf 'DESCONTO OBTIDO TIT.' $ Qry1->CT2_HIST ;
	       .OR. 'DESCONTO CONC. TIT.  NR.' $ Qry1->CT2_HIST ; 
	       .OR. 'DESC CONC. TIT.  NR.' $ Qry1->CT2_HIST ; 
	       .OR. 'DESC. CONC.S/TIT. NR.' $ Qry1->CT2_HIST  // INCLUIDO DESCONTO HIST. (30.07.13 HC)  
	       
		nValor		:= Qry1->CT2_VALOR						//VALOR SOMENTE DO DESCONTO
		lImpMult 	:= .F.
		
	Else
		nValor		:= Qry1->CT2_VALOR - SE5->E5_VLJUROS //- SE5->E5_VLMULTA + SE5->E5_VLDESCO	//VALOR TOTAL DO TITULO - MULTA + JUROS + DESCONTO
	Endif

	cCCD	 := Qry1->CT2_CCD
	cCCC	 := Qry1->CT2_CCC
	cITEMD	 := IIf( lImpMult, Qry1->CT2_ITEMD, "" )
	cITEMC	 := IIf( lImpMult, Qry1->CT2_ITEMC, "" )
	cCLVLDB	 := IIf( lImpMult, Qry1->CT2_CLVLDB, "" )
	cCLVLCR	 := IIf( lImpMult, Qry1->CT2_CLVLCR, "" )

	cQuery := "	SELECT "													+ cCRLF
	cQuery += "		*FROM "													+ cCRLF
	cQuery += RetSqlName("CT2") + " CT2 "									+ cCRLF
	cQuery += "	WHERE "														+ cCRLF
	cQuery += " 	CT2_FILIAL = '"+ cFilialCT2 +"'  "						+ cCRLF
	cQuery += " 	AND SubString(CT2_ORIGEM,10,"+cValtoChar(nTam01)+") 	= '" + SubStr( Qry1->CT2_ORIGEM, 10, nTam01 ) + "' "								+ cCRLF

	If SE5->E5_RECPAG == 'P'

		cQuery += " 	AND SubString(CT2_ORIGEM,1,6) 	= 'LP510/' "		+ cCRLF
		cQuery += " 	AND CT2_CCD 	<> '' "								+ cCRLF
			
		If SE2->( MsSeek( cFilialSE2 + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA ) )
			dDtVenc		:= SE2->E2_VENCTO
			dDtEmis		:= SE2->E2_EMISSAO
			cCtaDesp	:= POSICIONE( "SED", 1, cFilialSED + SE2->E2_NATUREZ, "ED_CONTA" )
		Endif
	Else

		cQuery += " 	AND SubString(CT2_ORIGEM,1,6) 	= 'LP500/' "		+ cCRLF
		cQuery += " 	AND CT2_CCC 	<> '' "								+ cCRLF

		If SE1->( MsSeek( cFilialSE1 + SE5->E5_CLIFOR + SE5->E5_LOJA + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO ))
			dDtVenc		:= SE1->E1_VENCTO
			dDtEmis		:= SE1->E1_EMISSAO
			cCtaDesp 	:= POSICIONE( "SED", 1, cFilialSED + SE1->E1_NATUREZ, "ED_CONTA" )
		Endif
	Endif

	cQuery += " 	AND CT2.D_E_L_E_T_ <> '*'	 "												+ cCRLF

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry2",.T.,.T.)
	
	If Qry2->( !EOF() ) .AND. Len( AllTrim( Qry1->CT2_ORIGEM ) ) >= 10
	
		If lInvert

			If Empty( cCCD )
				cCCD	 := Qry2->CT2_CCC
			Endif
			
			If Empty( cCCC )
				cCCC	 := Qry2->CT2_CCD
			Endif
			
			If Empty( cITEMD )
				cITEMD	 := IIf( lImpMult, Qry2->CT2_ITEMC, "" ) //Para não imprimir classe e item qd multa canc multa e desconto
			Endif
			
			If Empty( cITEMC )
				cITEMC	 := IIf( lImpMult, Qry2->CT2_ITEMD, "" )
			Endif
			
			If Empty( cCLVLDB )
				cCLVLDB	 := IIf( lImpMult, Qry2->CT2_CLVLCR, "" )
			Endif
			
			If Empty( cCLVLCR )
				cCLVLCR	 := IIf( lImpMult, Qry2->CT2_CLVLDB, "" )
			Endif
	
		Else
	
			If Empty( cCCD )
				cCCD	 := Qry2->CT2_CCD
			Endif
			
			If Empty( cCCC )
				cCCC	 := Qry2->CT2_CCC
			Endif
			
			If Empty( cITEMD )
				cITEMD	 := IIf( lImpMult, Qry2->CT2_ITEMD, "" )
			Endif
			
			If Empty( cITEMC )
				cITEMC	 := IIf( lImpMult, Qry2->CT2_ITEMC, "" )
			Endif
			
			If Empty( cCLVLDB )
				cCLVLDB	 := IIf( lImpMult, Qry2->CT2_CLVLDB, "" )
			Endif
			
			If Empty( cCLVLCR )
				cCLVLCR	 := IIf( lImpMult, Qry2->CT2_CLVLCR, "" )
			Endif
			
		Endif
		
	Else

		If SD1->( MsSeek( cFilialSD1 + SE5->E5_NUMERO + SE5->E5_PREFIXO + SE5->E5_CLIFOR + SE5->E5_LOJA  ) )
		
			If lInvert
			
				cCCC	 := SD1->D1_CC
				cITEMC	 := SD1->D1_ITEMCTA
				cCLVLCR	 := SD1->D1_CLVL

			Else
			
				cCCD	 := SD1->D1_CC
				cITEMD	 := SD1->D1_ITEMCTA
				cCLVLDB	 := SD1->D1_CLVL

			Endif
						
		Endif
	
	Endif
	
	Qry2->( dbCloseArea() )

ElseIf Qry1->CV3_TABORI == "SEF"

	dData		:= SEF->EF_DATA
	nValor		:= SEF->EF_VALOR
	cPref		:= SEF->EF_PREFIXO
	cNum		:= SEF->EF_TITULO
	cParc		:= SEF->EF_PARCELA
	cCliFor		:= SEF->EF_FORNECE
	cLoja		:= SEF->EF_LOJA
	dDtVenc		:= CTOD("  /  /  ")
	dDtEmis		:= CTOD("  /  /  ")
	cCtaDesp	:= ""

	If !Empty( SEF->EF_FORNECE )
		If SE2->( MsSeek( cFilialSE2 + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO + SEF->EF_FORNECE + SEF->EF_LOJA ) )
			dDtVenc		:= SE2->E2_VENCTO
			dDtEmis		:= SE2->E2_EMISSAO
			cCtaDesp	:= POSICIONE( "SED", 1, cFilialSED + SE2->E2_NATUREZ, "ED_CONTA" )
		Endif
	Endif

	If !Empty( SEF->EF_CLIENTE )
		If SE1->( MsSeek( cFilialSE1 + SEF->EF_FORNECE + SEF->EF_LOJA + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO ) )
			dDtVenc		:= SE1->E1_VENCTO
			dDtEmis		:= SE1->E1_EMISSAO
			cCtaDesp	:= POSICIONE( "SED", 1, cFilialSED + SE1->E1_NATUREZ, "ED_CONTA" )
		Endif
	Endif

Endif

aAdd( aInfComp, dData	)
aAdd( aInfComp, nValor	)
aAdd( aInfComp, cPref	)
aAdd( aInfComp, cNum	)
aAdd( aInfComp, cParc	)
aAdd( aInfComp, cCliFor	)
aAdd( aInfComp, cLoja	)
aAdd( aInfComp, dDtVenc	)
aAdd( aInfComp, dDtEmis	)
aAdd( aInfComp, cCtaDesp)


aAdd( aInfComp, cCCD	)
aAdd( aInfComp, cCCC	)
aAdd( aInfComp, cITEMD	)
aAdd( aInfComp, cITEMC	)
aAdd( aInfComp, cCLVLDB	)
aAdd( aInfComp, cCLVLCR	)


Return( aInfComp )

/*
Função.....: ImpCabec.
Autor......: Eurai Rapelli - HC Consys
Parametro..: oSelf > Objeto tNewProcess.
Data.......: 26/04/2013
Descrição..: Impressao do cabecalho
*/
Static Function ImpCabec()
Local nTam		:= RetTamTex( 'Data e Hora da Impressão: '+Space(05)+cData, oFont08b, oPrint)
Local nLinCop := 0

oPrint:Say(nLin,nColHalf,cTitulo ,oFont10b,,,,PAD_CENTER)
oPrint:SayBitmap(nLin,nColInicio,cFig,400,180)     //Linha/Coluna/Figura/Comprimento/Largura
nLin += 200
nLinCop := nLin
oPrint:Say(nLin,nColInicio		,"Empresa: "+	SM0->M0_NOME + '/' + SM0->M0_NOMECOM			,oFont08b,,,,)
oPrint:Say(nLin,nColLimite-nTam	,'Data/Hora da Impressão: ' 		,oFont08b,,,,)
oPrint:Say(nLin,nColLimite-RetTamTex(Space(05)+cData, oFont08b, oPrint)	,cData 		,oFont07a,,,,)
nLin += 40

oPrint:Box(nLinCop,nColInicio-10		,nLin,nColLimite)
Return(Nil)

/*
Função.....: ImpHeader
Autor......: Eurai Rapelli - HC Consys
Data.......: 29/04/2013
Descrição..: Imprime titulos
*/
Static Function ImpHeader()
oPrint:Say(nLin,nColInicio+0000	,"FIL"	 			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+0100	,"DATA FIN"			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+0240 ,"LOTE"				,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+0400 ,"SBLOTE"			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+0550	,"DOC"				,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+0700	,"LIN"				,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+0800	,"MOE"				,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+0900	,"TIPO"				,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+1100	,"DEBITO"			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+1250	,"CREDITO"			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+1550	,"VALOR"			,oFont08b,,,,PAD_RIGHT)
oPrint:Say(nLin,nColInicio+1600	,"HISTORICO"		,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+2250	,"CC DEB"			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+2400	,"CC CRED"			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+2600	,"ITEM DEB"			,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+2800	,"ITEM CRED"		,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+3050	,"ORIGEM"			,oFont08b,,,,PAD_LEFT)
Return( Nil )

/*
Função.....: ImpCorpo.
Autor......: Eurai Rapelli - HC Consys
Data.......: 26/04/2013
Descrição..: Impressao do corpo
*/
Static Function ImpCorpo( oSelf )
Local nLinCop	:= 0

Local nValTot	:= 0

ImpHeader()

nLinCop := nLin


nLin += 40
oSelf:SetRegua1(nRegs1)
TRB1->( dbGoTop() )
Do While TRB1->( !EOF() )
	
	If oSelf:lEnd//Cancelamento do processo
		Exit
	EndIf
	
	oSelf:IncRegua1("Imprimindo:" )
		
	oPrint:Say(nLin,nColInicio+0000	,TRB1->FILIAL	 					,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+0100	,Dtoc( TRB1->DATAFIN )				,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+0240 ,TRB1->LOTE							,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+0400 ,TRB1->SBLOTE						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+0550	,TRB1->DOC							,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+0700	,TRB1->LINHA						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+0800	,TRB1->MOEDA						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+0900	,TRB1->TIPO							,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+1100	,TRB1->DEBITO						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+1250	,TRB1->CREDITO						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+1550	,Transform( TRB1->VALOR, cPic01 )	,oFont07a,,,,PAD_RIGHT)
	oPrint:Say(nLin,nColInicio+1600	,TRB1->HISTORI						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+2250	,TRB1->CCUSTOD						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+2400	,TRB1->CCUSTOC						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+2600	,TRB1->ITEMD						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+2800	,TRB1->ITEMC						,oFont07a,,,,PAD_LEFT)
	oPrint:Say(nLin,nColInicio+3050	,TRB1->ORIGEM						,oFont07a,,,,PAD_LEFT)
									
	nValTot += TRB1->VALOR
	
	If( nLin >= nLinLimite )
		oPrint:Box(nLinCop, nColInicio-10, nLin+40, nColLimite)
		
		oPrint:EndPage()
		nLin := 10
		oPrint:StartPage()
		ImpCabec()
		ImpHeader()
		nLinCop	:=	nLin
	Endif
	
	nLin += 40
	TRB1->( dbSkip() )
EndDo

nLin += 40
oPrint:Say(nLin,nColInicio+0000	,"TOTAL GERAL"	 						,oFont08b,,,,PAD_LEFT)
oPrint:Say(nLin,nColInicio+1550	,Transform( nValTot, cPic01 )			,oFont07a,,,,PAD_RIGHT)
oPrint:Box(nLinCop,nColInicio-10,nLin,nColLimite)

Return( Nil )

/*
Função.....: TMPCria
Autor......: Eurai Rapelli - HC Consys
Data.......: 13/05/2013
Descrição..: Cria arquivo temporario para exportar excel
*/
Static Function TMPCria( cNomArq1, cIndArq1 )
Local aCampos := {}

aAdd(aCampos, {"FILIAL"  , "C", 02, 0} )
aAdd(aCampos, {"DATAFIN" , "D", 08, 0} )
aAdd(aCampos, {"LOTE"    , "C", 06, 0} )
aAdd(aCampos, {"SBLOTE"  , "C", 03, 0} )
aAdd(aCampos, {"DOC"     , "C", 06, 0} )
aAdd(aCampos, {"LINHA"   , "C", 03, 0} )
aAdd(aCampos, {"MOEDA"   , "C", 02, 0} )
aAdd(aCampos, {"TIPO"    , "C", 20, 0} )
aAdd(aCampos, {"DEBITO"  , "C", 20, 0} )
aAdd(aCampos, {"CREDITO" , "C", 20, 0} )
aAdd(aCampos, {"VALOR"   , "N", 17, 2} )
aAdd(aCampos, {"HISTORI" , "C", 80, 0} )
aAdd(aCampos, {"CCUSTOD" , "C", 09, 0} )
aAdd(aCampos, {"CCUSTOC" , "C", 09, 0} )
aAdd(aCampos, {"ITEMD"   , "C", 09, 0} )
aAdd(aCampos, {"ITEMC"   , "C", 09, 0} )
aAdd(aCampos, {"CLVLDB"  , "C", 09, 0} )
aAdd(aCampos, {"CLVLCR"  , "C", 09, 0} )
aAdd(aCampos, {"ORIGEM"  , "C", 10, 0} )
aAdd(aCampos, {"PREFIXO" , "C", 03, 0} )
aAdd(aCampos, {"NUMERO " , "C", 06, 0} )
aAdd(aCampos, {"PARCELA" , "C", 03, 0} )
aAdd(aCampos, {"CLIFOR"  , "C", 06, 0} )
aAdd(aCampos, {"LOJA"    , "C", 02, 0} )
aAdd(aCampos, {"EMISSAO" , "D", 08, 0} )
aAdd(aCampos, {"VENCTO"  , "D", 08, 0} )
aAdd(aCampos, {"TABELA"  , "C", 03, 0} )
aAdd(aCampos, {"REGISTRO", "C", 19, 0} )
aAdd(aCampos, {"CTADESP" , "C", 20, 0} )

If Select("TRB1") > 0//Verifica se ja existe alias criado
	TRB1->( dbCloseArea() )
Endif

cNomArq1	:= CriaTrab(aCampos, .T.)
dbUseArea( .T.,, cNomArq1, "TRB1", IIf( .F. .Or. .F., !.F., Nil ), .F. )
cChavInd1	:= "FILIAL+DTOS(DATAFIN)+LOTE+SBLOTE+DOC+LINHA"
IndRegua("TRB1", cNomArq1, cChavInd1,,, "SelecionAndo Registros ...")

Return( Nil )

/*
Função.....: TMPGera
Autor......: Eurai Rapelli - HC Consys
Data.......: 14/05/2013
Descrição..: Preenche os dados na tabela temporaria
*/
Static Function TMPGera( oSelf )
Local cQuery	:= ""


Local cFilImp	:= ""
Local cData		:= ""
Local cLote		:= ""
Local cSbLote	:= ""
Local cDoc		:= ""
Local cLinha	:= ""
Local cMoeda	:= ""
Local cTipo		:= ""
Local cDebito	:= ""
Local cCredito	:= ""
Local cValor	:= ""
Local cHist		:= ""
Local cOrigem	:= ""

Local cNumCHQ	:= ""
Local cBanco	:= ""
Local cAgencia	:= ""
Local cConta	:= ""

Local aInfComp	:= {}

Local lMultNat	:= .F.

oSelf:SetRegua2(nRegs2)
Do While Qry1->( !EOF() )

	oSelf:IncRegua2("Gerando dados TMP")

	DbSelectArea( Qry1->CV3_TABORI )
	DbGoto( Val( Qry1->CV3_RECORI ) ) 
	
	If Qry1->CV3_TABORI == 'SE5' 
		If AllTrim(SE5->E5_SITUACA) $ 'CXE' 
			Qry1->( dbSkip() )
			Loop
		Endif
	Endif

	/*aInfComp
	aInfComp[01] := Data
	aInfComp[02] := Valor
	aInfComp[03] := Prefixo
	aInfComp[04] := Numero
	aInfComp[05] := Parcela
	aInfComp[06] := CliFor
	aInfComp[07] := Loja
	aInfComp[08] := Data Vencimento
	aInfComp[09] := Data Emissao
	aInfComp[10] := Conta Despesa
	aInfComp[11] := CT2_CCD
	aInfComp[12] := CT2_CCC
	aInfComp[13] := CT2_ITEMD
	aInfComp[14] := CT2_ITEMC
	aInfComp[15] := CT2_CLVLDB
	aInfComp[16] := CT2_CLVLCR
	*/
	aInfComp := GetInf()

	cFilImp	:= Qry1->CT2_FILIAL
	cLote	:= Qry1->CT2_LOTE
	cSbLote	:= Qry1->CT2_SBLOTE
	cDoc	:= Qry1->CT2_DOC
	cLinha	:= Qry1->CT2_LINHA
	cMoeda	:= Qry1->CT2_MOEDLC
	cTipo	:= IIf( Qry1->CT2_DC == "1", "Debito", IIf( Qry1->CT2_DC == "2", "Credito", "Partida Dobrada" ) )
	cDebito	:= Qry1->CT2_DEBITO
	cCredito:= Qry1->CT2_CREDIT
	cHist	:= Qry1->CT2_HIST
	cOrigem	:= Qry1->CT2_LP + Qry1->CT2_SEQLAN


	lMultNat := .F.

	If Qry1->CV3_TABORI == 'SE5' .AND. SE5->E5_RECPAG == 'R'
	
		If SE1->( MsSeek( cFilialSE1 + SE5->E5_CLIFOR + SE5->E5_LOJA + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO ) )

			//aInfComp é preenchido na função GetInf(). Caso ele estiver branco. procura no SE1
			
			If lInvert

				If Empty( aInfComp[11] )
					aInfComp[11]	:= SE1->E1_CCC
				Endif
		
				If Empty( aInfComp[13] )
					aInfComp[13]	:= IIf( lImpMult, SE1->E1_ITEMC, "" )
				Endif
	
				If Empty( aInfComp[15] )
					aInfComp[15]	:= IIf( lImpMult, SE1->E1_CLVLCR, "" )
				Endif
			
			Else
			
				If Empty( aInfComp[12] )
					aInfComp[12]	:= SE1->E1_CCC
				Endif
		
				If Empty( aInfComp[14] )
					aInfComp[14]	:= IIf( lImpMult, SE1->E1_ITEMC, "" )
				Endif
	
				If Empty( aInfComp[16] )
					aInfComp[16]	:= IIf( lImpMult, SE1->E1_CLVLCR, "" )
				Endif
				
			Endif

	
			If SE1->E1_MULTNAT == '1' .AND. lImpMult	

				If Select("Qry3") > 0//Verifica se ja existe alias criado
					Qry3->( dbCloseArea() )
				Endif
				
				cQuery := "	SELECT  "													+ cCRLF
				cQuery += "		* "														+ cCRLF
				cQuery += "	FROM "														+ cCRLF
				cQuery += RetSqlName("SEV") + " SEV "									+ cCRLF
				cQuery += "	WHERE "														+ cCRLF
				cQuery += "		EV_FILIAL = '" + cFilialSEV + "' "						+ cCRLF
				cQuery += "		AND EV_PREFIXO = '" + SE5->E5_PREFIXO + "' "  			+ cCRLF
				cQuery += "		AND EV_NUM = '" + SE5->E5_NUMERO + "' "  				+ cCRLF
				cQuery += "		AND EV_PARCELA = '" + SE5->E5_PARCELA + "' "  			+ cCRLF
				cQuery += "		AND EV_CLIFOR = '" + SE5->E5_CLIFOR + "' "   			+ cCRLF
				cQuery += "		AND EV_LOJA = '" + SE5->E5_LOJA + "' "					+ cCRLF
				cQuery += "		AND EV_TIPO = '" + SE5->E5_TIPO + "' "					+ cCRLF
				cQuery += "		AND EV_RECPAG = 'R' "									+ cCRLF
				cQuery += "		AND EV_IDENT = '1' "									+ cCRLF
				cQuery += " 	AND SEV.D_E_L_E_T_ <> '*'	 "							+ cCRLF
				
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry3",.T.,.T.)
				
				Do While Qry3->( !EOF() )
					
					lMultNat := .T.
					
					aInfComp[02]	:= Qry3->EV_VALOR
					aInfComp[10]	:= POSICIONE("SED", 1, cFilialSED + Qry3->EV_NATUREZ, "ED_CONTA" )

					TMPGrava( cFilImp, cLote, cSbLote, cDoc, cLinha, cMoeda, cTipo, ;
								cDebito, cCredito, cHist, cOrigem, aInfComp )
																	
					Qry3->( dbSkip() )
					
				EndDo

			Endif
	
		Endif

	ElseIf Qry1->CV3_TABORI == 'SE5' .AND. SE5->E5_RECPAG == 'P'
	
		If SE2->( MsSeek( cFilialSE2 + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA ) )

			//aInfComp é preenchido na função GetInf(). Caso ele estiver branco. procura no SE2
			If lInvert

				If Empty( aInfComp[12] )
					aInfComp[12]	:= SE2->E2_CCD
				Endif
				
				If Empty( aInfComp[14] )
					aInfComp[14]	:= IIf( lImpMult, SE2->E2_ITEMD, "" )
				Endif
				
				If Empty( aInfComp[16] )
					aInfComp[16]	:= IIf( lImpMult, SE2->E2_CLVLDB, "" )
				Endif
			
			Else
			
				If Empty( aInfComp[11] )
					aInfComp[11]	:= SE2->E2_CCD
				Endif
				
				If Empty( aInfComp[13] )
					aInfComp[13]	:= IIf( lImpMult, SE2->E2_ITEMD, "" )
				Endif
				
				If Empty( aInfComp[15] )
					aInfComp[15]	:= IIf( lImpMult, SE2->E2_CLVLDB, "" )
				Endif
	
			Endif
	
			If SE2->E2_MULTNAT == '1' .AND. lImpMult


				If Select("Qry3") > 0//Verifica se ja existe alias criado
					Qry3->( dbCloseArea() )
				Endif
				
				cQuery := "	SELECT  "													+ cCRLF
				cQuery += "		* "														+ cCRLF
				cQuery += "	FROM "														+ cCRLF
				cQuery += RetSqlName("SEV") + " SEV "									+ cCRLF
				cQuery += "	WHERE "														+ cCRLF
				cQuery += "		EV_FILIAL = '" + cFilialSEV + "' "						+ cCRLF
				cQuery += "		AND EV_PREFIXO = '" + SE5->E5_PREFIXO + "' "  			+ cCRLF
				cQuery += "		AND EV_NUM = '" + SE5->E5_NUMERO + "' "  				+ cCRLF
				cQuery += "		AND EV_PARCELA = '" + SE5->E5_PARCELA + "' "  			+ cCRLF
				cQuery += "		AND EV_CLIFOR = '" + SE5->E5_CLIFOR + "' "   			+ cCRLF
				cQuery += "		AND EV_LOJA = '" + SE5->E5_LOJA + "' "					+ cCRLF
				cQuery += "		AND EV_TIPO = '" + SE5->E5_TIPO + "' "					+ cCRLF
				cQuery += "		AND EV_RECPAG = 'P' "									+ cCRLF
				cQuery += "		AND EV_IDENT = '1' "									+ cCRLF
				cQuery += " 	AND SEV.D_E_L_E_T_ <> '*'	 "							+ cCRLF
				
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Qry3",.T.,.T.)
				
				Do While Qry3->( !EOF() )
					
					lMultNat := .T.
					
					aInfComp[02]	:= Qry3->EV_VALOR
					aInfComp[10]	:= POSICIONE("SED", 1, cFilialSED + Qry3->EV_NATUREZ, "ED_CONTA" )

					TMPGrava( cFilImp, cLote, cSbLote, cDoc, cLinha, cMoeda, cTipo, ;
								cDebito, cCredito, cHist, cOrigem, aInfComp )
																	
					Qry3->( dbSkip() )
					
				EndDo

			Endif
	
		Endif
			
	Endif
	
	If !lMultNat

		TMPGrava( cFilImp, cLote, cSbLote, cDoc, cLinha, cMoeda, cTipo, ;
					cDebito, cCredito, cHist, cOrigem, aInfComp )
	
	Endif
	
	If Qry1->CV3_TABORI == "SEF" .AND. Empty( aInfComp[04] )

		If SEF->( MsSeek( cFilialSEF + SEF->EF_NUM + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA ) )
		

			cNumCHQ		:= SEF->EF_NUM
			cBanco		:= SEF->EF_BANCO
			cAgencia	:= SEF->EF_AGENCIA
			cConta		:= SEF->EF_CONTA
	
			Do While SEF->( !EOF ) ;
						.AND. cNumCHQ + cBanco + cAgencia + cConta ;
						== SEF->EF_NUM + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA
	
				If Empty( SEF->EF_TITULO )
					SEF->( dbSkip() )
					Loop
				Endif

				aInfComp[06]	:= ""
				aInfComp[07]	:= ""
				aInfComp[08]	:= CTOD("  /  /  ")
				aInfComp[09]	:= CTOD("  /  /  ")

				If !Empty( SEF->EF_FORNECE )
					If SE2->( MsSeek( cFilialSE2 + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO + SEF->EF_FORNECE + SEF->EF_LOJA ) )
						aInfComp[06]	:= SEF->EF_FORNECE
						aInfComp[07]	:= SEF->EF_LOJA
						aInfComp[08]	:= SE2->E2_VENCTO
						aInfComp[09]	:= SE2->E2_EMISSAO
					Endif
				Endif
			
				If !Empty( SEF->EF_CLIENTE )
					If SE1->( MsSeek( cFilialSE1 + SEF->EF_FORNECE + SEF->EF_LOJA + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO ) )
						aInfComp[06]	:= SEF->EF_CLIENTE
						aInfComp[07]	:= SEF->EF_LOJACLI
						aInfComp[08]	:= SE1->E1_VENCTO
						aInfComp[09]	:= SE1->E1_EMISSAO
					Endif
				Endif
				
				aInfComp[02] := Transform( SEF->EF_VALOR, cPic01 )
				aInfComp[03] := SEF->EF_PREFIXO
				aInfComp[04] := SEF->EF_TITULO
				aInfComp[05] := SEF->EF_PARCELA

				TMPGrava( cFilImp, cLote, cSbLote, cDoc, cLinha, "", "", ;
						"", "", SEF->EF_NUM, "", "", "", "", ;
						"", aInfComp )
				
				nRegs1 += 1
				
				SEF->( dbSkip() )		
			EndDo
				
		Endif
				
	Endif	

	Qry1->( dbSkip() )
EndDo
Return( Nil )

/*
Função.....: TMPGrava
Autor......: Eurai Rapelli - HC Consys
Data.......: 13/05/2013
Descrição..: Grava no arquivo temporario. Usado qd exportado para excel e impresso em tela
Parametro..: cFilImp
Parametro..: cLote
Parametro..: cSbLote
Parametro..: cDoc
Parametro..: cLinha
Parametro..: cMoeda
Parametro..: cTipo
Parametro..: cDebito
Parametro..: cCredito
Parametro..: cHist
Parametro..: cOrigem
Parametro..: aInfComp >> Informações complementares
Onde Usado.: TMPGera
*/
Static Function TMPGrava( cFilImp, cLote, cSbLote, cDoc, cLinha, cMoeda, cTipo, ;
							cDebito, cCredito, cHist, cOrigem, aInfComp )
/*aInfComp
aInfComp[01] := Data
aInfComp[02] := Valor
aInfComp[03] := Prefixo
aInfComp[04] := Numero
aInfComp[05] := Parcela
aInfComp[06] := CliFor
aInfComp[07] := Loja
aInfComp[08] := Data Vencimento
aInfComp[09] := Data Emissao
aInfComp[10] := Conta Despesa
aInfComp[11] := CT2_CCD
aInfComp[12] := CT2_CCC
aInfComp[13] := CT2_ITEMD
aInfComp[14] := CT2_ITEMC
aInfComp[15] := CT2_CLVLDB
aInfComp[16] := CT2_CLVLCR
*/

If RecLock("TRB1",.T.)
	TRB1->FILIAL	:= cFilImp
	TRB1->DATAFIN	:= aInfComp[01]
	TRB1->LOTE		:= cLote
	TRB1->SBLOTE	:= cSbLote
	TRB1->DOC		:= cDoc
	TRB1->LINHA		:= cLinha
	TRB1->MOEDA		:= cMoeda
	TRB1->TIPO		:= cTipo
	TRB1->DEBITO	:= cDebito
	TRB1->CREDITO	:= cCredito
	TRB1->VALOR		:= aInfComp[02]
	TRB1->HISTORI	:= cHist
	TRB1->CCUSTOD	:= aInfComp[11]
	TRB1->CCUSTOC	:= aInfComp[12]
	TRB1->ITEMD		:= aInfComp[13]
	TRB1->ITEMC		:= aInfComp[14]
	TRB1->CLVLDB	:= aInfComp[15]
	TRB1->CLVLCR	:= aInfComp[16]
	TRB1->ORIGEM	:= cOrigem
	TRB1->TABELA	:= Qry1->CV3_TABORI
	TRB1->REGISTRO	:= Qry1->CV3_RECORI
	TRB1->PREFIXO	:= aInfComp[03]
	TRB1->NUMERO	:= aInfComp[04]
	TRB1->PARCELA	:= aInfComp[05]
	TRB1->CLIFOR	:= aInfComp[06]
	TRB1->LOJA		:= aInfComp[07]
	TRB1->VENCTO	:= aInfComp[08]
	TRB1->EMISSAO	:= aInfComp[09]
	TRB1->CTADESP	:= aInfComp[10]

	TRB1->( MsUnlock() )
Endif
Return( Nil )






/*
Função.....: ValidPerg
Descrição..: Verifica a existencia das perguntas criando-as caso seja necessario (caso nao existam).
Autor......: Eurai Rapellli
Empresa....: HCConsys
Data.......: 26/04/2013
*/
Static Function ValidPerg()
Local aRegs		:= {}
Local aHelp		:= {}

aHelp := {"Imprimi parâmetros da pergunta?"}
aAdd(aRegs,{"Imp. Parâmetros?"	  	, "Imp. Parâmetros?"		, "Imp. Parâmetros?"	,  "MV_CH1", "N",1	 		, 0, 1, "C", ""/*10*/, "MV_PAR01", "Não", "", "", "", "", "Sim", "", "", ""/*20*/, "", "", "", "", "", "", "", "", "", ""/*30*/, "", "", "", "", "", "", "", "", "", ""/*40*/, aHelp, aHelp, aHelp })

aHelp := {"Da Data"}
aAdd(aRegs,{"Da Data"	,"Da Data","Da Data"			,"MV_CH2","D",08,0,0,"G", ""/*10*/, "MV_PAR02", "", "", "", "", "", "", "", "", ""/*20*/, "", "", "", "", "", "", "", "", "", ""/*30*/, "", "", "", "", "", "", "", "", "", ""/*40*/, aHelp, aHelp, aHelp })
aHelp := {"Ate a Data"}
aAdd(aRegs,{"Ate a Data","Ate a Data","Ate a Data"		,"MV_CH3","D",08,0,0,"G", ""/*10*/, "MV_PAR03", "", "", "", "", "", "", "", "", ""/*20*/, "", "", "", "", "", "", "", "", "", ""/*30*/, "", "", "", "", "", "", "", "", "", ""/*40*/, aHelp, aHelp, aHelp })

aHelp := {"Gerar Planilha p/excel"}
aAdd(aRegs,{"Gerar Planilha p/excel"	,"Gerar Planilha p/excel"	,"Gerar Planilha p/excel",  "MV_CH4"		, "N",1, 0, 1, "C", ""/*10*/, "MV_PAR04", "SIM", "", "", "", "", "NAO", "", "", ""/*20*/, "", "", "", "", "", "", "", "", "", ""/*30*/, "", "", "", "", "", "", "", "", "", ""/*40*/, aHelp, aHelp, aHelp })

aHelp := {"Pasta e Arquivo p/Planilha?"}
aAdd(aRegs,{"Pasta e Arquivo p/Planilha", "Pasta e Arquivo p/Planilha", "Pasta e Arquivo p/Planilha"	,  "MV_CH5", "C",99	, 0, 0, "G", "U_SaveDirXLS()" /*10*/, "MV_PAR05", "", "", "", "", "", "", "", "", ""/*20*/, "", "", "", "", "", "", "", "", "", ""/*30*/, "", "", "", "", "", "", "", "", "", ""/*40*/, aHelp, aHelp, aHelp })


AJUSTASX1( cPerg, aRegs )
 
Return(Nil)

/*
Função.....: ImpPerg
Descrição..: Imprime os parametros na primeira folha
Autor......: Eurai Rapellli
Empresa....: HCConsys
Data.......: 26/04/2013
*/
Static Function ImpPerg()
Local nTamSX1	:= Len(SX1->X1_GRUPO)
Local cMacro	:= cMacroAux := "" 
Local cPergunta := ''

oPrint:SayBitmap(nLin,nColInicio,cFig,400,180)     //Linha/Coluna/Figura/Comprimento/Largura
oPrint:Say(nLin,nColHalf-0300,cTitulo ,oFont08b,,,,)
oPrint:Say(nLin,nColLimite-RetTamTex('Página: '+cValtoChar( nPag ), oFont07b, oPrint)	,'Página: ' 		,oFont07b,,,,)
oPrint:Say(nLin,nColLimite-RetTamTex(cValtoChar( nPag ), oFont07b, oPrint)	,cValtoChar( nPag ) 		,oFont07a,,,,)
nLin += 40
oPrint:Say(nLin,nColLimite-RetTamTex('Data/Hora: '+cData, oFont07b, oPrint)	,'Data/Hora: ' 		,oFont07b,,,,)
oPrint:Say(nLin,nColLimite-RetTamTex(cData, oFont07b, oPrint)	,cData 		,oFont07a,,,,)
nLin += 150

oPrint:Say(nLin,nColHalf,"Parâmetros Selecionados" ,oFont08b,,,,PAD_CENTER)
nLin += 100

dbSelectArea("SX1")
If( SX1->(MsSeek(PADR(cPerg,nTamSX1)+"01")))
	Do While(SX1->(SX1->X1_GRUPO == PADR(cPerg,nTamSX1) ))    
	    
		cMacro	:=	SX1->X1_VAR01
		cPergunta := AllTrim( SX1->X1_PERGUNT ) + ' '
			
		oPrint:Say(nLin,nColInicio		,cPergunta		,oFont07b,,,,)
		If(SX1->X1_TIPO == 'C' .AND. SX1->X1_GSC == 'C')//Combobox
			cMacroAux	:=	"SX1->X1_DEF0"
			cMacroAux	+= cValtoChar(&(cMacro))
			oPrint:Say(nLin,nColInicio+RetTamTex(cPergunta, oFont07b, oPrint)		,&(cMacroAux)		,oFont07a,,,,)
		ElseIf(SX1->X1_TIPO == 'N' .AND. SX1->X1_GSC == 'C')//Combobox
			cMacroAux	:=	"SX1->X1_DEF0"
			cMacroAux	+= cValtoChar(&(cMacro))
			oPrint:Say(nLin,nColInicio+RetTamTex(cPergunta, oFont07b, oPrint)		,&(cMacroAux)		,oFont07a,,,,)
		Else
			oPrint:Say(nLin,nColInicio+RetTamTex(cPergunta, oFont07b, oPrint)		,cValtoChar(&(cMacro))		,oFont07a,,,,)
		Endif
		nLin += 40
		SX1->( dbSkip() )
	EndDo
Endif

oPrint:EndPage()
oPrint:StartPage()
nLin	:= 10
nPag	+= 1
Return(Nil)

/*
Função.....: RetTamTex.
Autor......: Eurai Rapelli
Parametro..: cTexto   Texto a ser medido.
Parametro..: oFont    Objeto instanciado da fonte a ser utilizada.
Parametro..: oPrinter Objeto de impressão instanciado.
Retorno....: nTamanho Tamanho em pixels da string.
Data.......: 26/04/2013
Descrição..: Retorna o tamanho em pixels de uma string. (Workaround para o GetTextWidth)
*/
Static Function RetTamTex(cTexto, oFont, oPrinter)
Local nTamanho := 0

nTamanho := oPrinter:GetTextWidth(cTexto, oFont)

nTamanho := Round(nTamanho, 0)

Return( nTamanho )

/*                        
Função.....: SaveDirXLS
Autor......: Eurai Rapelli - HC Consys
Data.......: 26.04.2013
Descrição..: Abre tela para salvar XLS
*/
User Function SaveDirXLS()     
Local cExtens		:= "Arquivos XLS | *.XLS"
Local cTitulo		:= "Selecione o arquivo"

If Empty( &( Alltrim( ReadVar() ) ) )

	&( Alltrim( ReadVar() ) ) := AllTrim(cGetFile(cExtens,cTitulo, 0,'C:\', .T., GETF_LOCALHARD ))

Endif

Return( Nil )