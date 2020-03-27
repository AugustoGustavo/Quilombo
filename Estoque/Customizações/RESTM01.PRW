#include "totvs.ch"
#include "protheus.ch"

/*/{Protheus.doc} RESTM01
description
@type function
@version 
@author felipi marques
@since 18/03/2020
/*/

User Function RESTM01()

    // Declaração das variaveis
    Local aArea         := GetArea()
    Local cTitulo       := "Manutenção cadastro de produtos"
    Local nOpcao        := 0
    Local aButtons      := {}
    Local aSays         := {}
    Local aRegs         := {}
    Local cPerg         := PadR("PESTM01", Len(SX1->X1_GRUPO))
    Private cArquivo    := ""
    Private oProcess
    Private lRenomear   := .F.
    Private lMsErroAuto := .F.

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Define as perguntas da rotina                                                           ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aAdd(aRegs,{cPerg,"01","Arquivo"  ,"","" ,"mv_ch1","C",99,0,0,"G","",	"MV_PAR01","",	"","","",			"","",	"","","","","","","","","","","","","","","","","","","DIR",	"","","",""})
    aAdd(aRegs,{cPerg,"02","Renomear?",	"","","mv_ch2","N",01,0,2,"C","",	"mv_par02","Sim","","","",			"","Não","","","","","","","","","","","","","","","","","","","","","","","" } )

    CriaSx1(cPerg, aRegs)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-¿
    //³Abre a tela do pergunte para visualização e preenchimento das           |
    //|informações.                                                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Pergunte(cPerg, .F.)

    // Monta Tela para buscar
    AADD(aSays,OemToAnsi("Rotina para Importação de arquivo texto para atualizar os produtos"))
    AADD(aSays,"")
    AADD(aSays,OemToAnsi("Clique no botão PARAM para informar os parametros que deverão ser considerados."))
    AADD(aSays,"")
    AADD(aSays,OemToAnsi("Após isso, clique no botão OK."))
    AADD(aButtons, { 1,.T.,{|o| nOpcao:= 1,o:oWnd:End()} } )
    AADD(aButtons, { 2,.T.,{|o| nOpcao:= 2,o:oWnd:End()} } )
    AADD(aButtons, { 5,.T.,{| | pergunte(cPerg,.T.)  } } )

    FormBatch( cTitulo, aSays, aButtons,,200,530 )

    if nOpcao = 1
        cArquivo:= Alltrim(MV_PAR01)
        if Empty(cArquivo)
            MsgStop("Informe o nome do arquivo!!!","Erro")
            return
        Endif
        oProcess := MsNewProcess():New( { || Importa() } , "Importação de registros " , "Aguarde..." , .F. )
        oProcess:Activate()

    EndIf
    RestArea(aArea)

//Processamento do arquivo texto e validações
Static Function Importa()

    // Declaração de variaveis
    Local cArqProc   := cArquivo+".processado"
    Local cLinha     := ""
    Local lPrim      := .T.
    Local aCampos    := {}
    Local aDados     := {}
    Local aCliente   := {}
    Local nCont     := 1
    Local nPosCod    := 0
    Local nPosLoja   := 0
    Local nPosNome   := 0
    Local nPosEst    := 0
    Local nPosCodMun := 0
    Local nPessoa    := 0
    Local i          := 0
    Private aErro    := {}

    If !File(cArquivo)
        MsgStop("O arquivo " + cArquivo + " não foi encontrado. A importação será abortada!","[AEST904] - ATENCAO")
        Return
    EndIf
    FT_FUSE(cArquivo) //Abre o arquivo texto
    oProcess:SetRegua1(FT_FLASTREC()) //Preenche a regua com a quantidade de registros encontrados
    FT_FGOTOP() //coloca o arquivo no topo
    While !FT_FEOF()
        nCont++
        oProcess:IncRegua1('Validando Linha: ' + Alltrim(Str(nCont)))

        cLinha := FT_FREADLN()
        cLinha := ALLTRIM(cLinha)

        If lPrim //considerando que a primeira linha são os campos do cadastros, reservar numa variavel
            aCampos := Separa(cLinha,";",.T.)
            lPrim := .F.
        Else// gravar em outra variavel os registros
            AADD(aDados,Separa(cLinha,";",.T.))
        EndIf

        FT_FSKIP()
    EndDo
    FT_FUSE()

    //guardar novamente a quantidade de registros
    oProcess:SetRegua1(len(aDados)) 

    For i:=1 to Len(aDados)

        oProcess:IncRegua1("Atualizando os Produtos..."+aDados[i,2] )

        dbSelectArea("SB1")
        dbSetOrder(3)
        dbGoTop()

        //Neste ponto iremos alterar as contas registros
        If dbSeek(xFilial("SB1")+aDados[i,2])
            
        oProcess:SetRegua2(len(aCampos))
		
        // Grava as contas corretas	
        RecLock("SB1",.F.)
			SB1->B1_XCTAEUC  := aDados[i,6]  //Cta EUCA    
            SB1->B1_XCTASOJ  := aDados[i,7]  //Cta Soja    
            SB1->B1_XCTAPEC  := aDados[i,8]  //Cta Pecuaria
            SB1->B1_XCTADES  := aDados[i,9] //Cta Despesa 
		SB1->( MsUnLock() )
        
        //Caso o registro exista, gravar o log        
        Else 
            GravaErro(aDados[i,1],aDados[i,2],aDados[i,3],"O produto não esta cadastrado!")
        EndIf
    Next i

    IF(MV_PAR02==1)
        If File(cArqProc)
            fErase(cArqProc)
        Endif
        fRename(Upper(cArquivo), cArqProc)
    Endif

    If Len(aErro) > 0
        MostraLog()
    Else
        ApMsgInfo("Importação de clientes efetuada com sucesso!","SUCESSO")
    EndIf

Return

//Função para gravar erros encontrados
Static Function GravaErro(cCod,cLoja,cNome,cMsg)
    Local cFile := "\SYSTEM\"+FUNNAME()+".LOG"
    Local cLine := ""
    DEFAULT cMsg  := NIL
    If cMsg == NIL
        Begin Sequence
            IF !( lOk := File( cFile ) )
                Break
            EndIF

            FT_FUSE(cFile)
            FT_FGOTOP()

            While !FT_FEOF()

                cLine += FT_FREADLN() + CHR(13)+CHR(10)

                FT_FSKIP()
            End While

            FT_FUSE()
        End Sequence

        cMsg := cLine
    EndIf
    AADD(aErro,{cCod,cLoja,cNome,cMsg})
Return

//Função para mostrar o log em tela
Static Function MostraLog()
    Local oDlg
    Local oFont
    Local cMemo := ""
    DEFINE FONT oFont NAME "Courier New" SIZE 5,0
    DEFINE MSDIALOG oDlg TITLE "Manutenção contas dos produtos" From 3,0 to 400,417 PIXEL
    aCabec := {"Código","Loja","Nome"}
    cCabec := "{aErro[oBrw:nAT][1],aErro[oBrw:nAT][2],aErro[oBrw:nAT][3]}"
    bCabec := &( "{ || " + cCabec + " }" )
    oBrw := TWBrowse():New( 005,005,200,090,,aCabec,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
    oBrw:SetArray(aErro)
    oBrw:bChange    := { || cMemo := aErro[oBrw:nAT][4], oMemo:Refresh()}
    oBrw:bLDblClick := { || cMemo := aErro[oBrw:nAT][4], oMemo:Refresh()}
    oBrw:bLine := bCabec
    @ 100,005 GET oMemo VAR cMemo MEMO SIZE 200,080 OF oDlg PIXEL
    oMemo:bRClicked := {||AllwaysTrue()}
    oMemo:lReadOnly := .T.
    oMemo:oFont := oFont
    oImprimir :=tButton():New(185,120,'Imprimir' ,oDlg,{|| fImprimeLog() },40,12,,,,.T.)
    oSair     :=tButton():New(185,165,'Sair'     ,oDlg,{|| ::End() },40,12,,,,.T.)
    ACTIVATE MSDIALOG oDlg CENTERED
Return

//    Função para mostrar o log impresso
Static Function fImprimeLog()
    Local oReport
    
    If TRepInUse()  //verifica se relatorios personalizaveis esta disponivel
        oReport := ReportDef()
        oReport:PrintDialog()
    EndIf

Return

// Relatorio erro na importação
Static Function ReportDef()
    Local oReport
    Local oSection
    LOCAL nCurrentLine

    oReport := TReport():New(FUNNAME(),"Importação Cadastro de Fornecedores",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao de erros encontrados durante o processo de importação dos dados.")
    oReport:SetLandscape()
    oSection := TRSection():New(oReport,,{})
    TRCell():New(oSection,"CODIGO"  ,,"Código")
    TRCell():New(oSection,"DESCRI"  ,,"Loja")
    TRCell():New(oSection,"CONTA"   ,,"Nome")
    TRCell():New(oSection,"ERRO"    ,,"Descrição do Erro")
Return oReport

Static Function PrintReport(oReport)

    Local oSection      := oReport:Section(1)
    Local nCurrentLine  :=  0
    Local i             :=  0

    oReport:SetMeter(Len(aErro))
    oSection:Init()
    For i:=1 to Len(aErro)

        If oReport:Cancel()
            Exit
        EndIf

        oReport:IncMeter()

        oSection:Cell("CODIGO"):SetValue(aErro[i,1])
        oSection:Cell("CODIGO"):SetSize(20)
        oSection:Cell("DESCRI"):SetValue(aErro[i,2])
        oSection:Cell("DESCRI"):SetSize(20)
        oSection:Cell("CONTA"):SetValue(aErro[i,3])
        oSection:Cell("CONTA"):SetSize(50)
        oSection:Cell("ERRO"):SetValue(aErro[i,4])
        oSection:Cell("ERRO"):SetSize(200)

        nTamLin := 200
        nTab := 3
        lWrap := .T.

        lPrim := .T.

        cObsMemo := aErro[i,4]
        nLines   := MLCOUNT(cObsMemo, nTamLin, nTab, lWrap)

        For nCurrentLine := 1 to nLines
            If lPrim
                oSection:Cell("ERRO"):SetValue(MEMOLINE(cObsMemo, nTamLin, nCurrentLine, nTab, lWrap))
                oSection:Cell("ERRO"):SetSize(300)
                oSection:PrintLine()
                lPrim := .F.
            Else
                oSection:Cell("CODIGO"):SetValue("")
                oSection:Cell("DESCRI"):SetValue("")
                oSection:Cell("CONTA"):SetValue("")
                oSection:Cell("ERRO"):SetValue(MEMOLINE(cObsMemo, nTamLin, nCurrentLine, nTab, lWrap))
                oSection:Cell("ERRO"):SetSize(300)
                oSection:PrintLine()
            EndIf
        Next i

        oReport:SkipLine()
    Next i
    oSection:Finish()
Return

//Funcao para criacao dos parametros da rotina   
Static Function CriaSx1(cPerg, aRegs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nLoop1	:= 0
Local nLoop2	:= 0

dbSelectArea("SX1")
dbSetOrder(1)
For nLoop1 := 1 To Len( aRegs )
	If !MsSeek( Padr(aRegs[nLoop1,1],Len(SX1->X1_GRUPO)) + aRegs[nLoop1,2] )
		RecLock( "SX1", .T. )
		For nLoop2 := 1 To FCount()
			If nLoop2 <= Len( aRegs[nLoop1] )
				FieldPut(nLoop2, aRegs[nLoop1,nLoop2] )
			EndIf
		Next nLoop2
		MsUnlock()
	EndIf
Next nLoop1

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)