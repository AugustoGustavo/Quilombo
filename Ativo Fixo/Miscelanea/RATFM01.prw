#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} RATFM01
//Manutenção Ativo imobilizado
@author Felipi Marques
@since 04/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User function RATFM01()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpca     	:= 0
Local aSays     	:= {}
Local aButtons  	:= {}
Local cCadastro  	:= OemToAnsi("Rotina de Exclusão dos Ativos Fixos")
Local aArea			:= {}
Local cPerg			:= Padr("XATFM01",Len(SX1->X1_GRUPO))
Local aRegs			:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os parametros da rotina                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aRegs,{cPerg,"02","Do Cod. do Bem "				,"","","mv_ch2","C",10,0,1,"G","","MV_PAR01","","","","",	"","","","","","","","","","","","","","","","","","","","","SN1",	"","","",""})
Aadd(aRegs,{cPerg,"03","Ate o Cod. do Bem "	    		,"","","mv_ch3","C",10,0,0,"G","","MV_PAR01","","","","",	"","","","","","","","","","","","","","","","","","","","","SN1",	"","","",""})
U_CriaSx1(aRegs)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta tela principal                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSays,OemToAnsi("Esta rotina tem como objetivo a manutenção dos bens do Ativo Imobilizado" 	))
AADD(aSays,OemToAnsi("Podendo realizar a exclusão de todos itens sem data de baixa."       		    ))
AADD(aButtons, { 1,.T.						,{|o| (nOpca := 1,o:oWnd:End())	   							}})
AADD(aButtons, { 2,.T.						,{|o| (nOpca := 0,o:oWnd:End())								}})
AADD(aButtons, { 5,.T.						,{|o| (Pergunte(cPerg,.T.),o:oWnd:refresh())					}})
FormBatch( cCadastro, aSays, aButtons )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa o recalculo do Custo                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpca == 1
	Processa( { || fExclui()} ,"Excluindo Registros" )
Endif

Return

/*/{Protheus.doc} fExclui
//Exclusão dos ativos fixos
@author Felipi Marques
@since 04/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/     
Static Function fExclui()

//Variavel Local
Local cQuery := ""
Local cTblSN1 := CriaTrab(,.F.)

//Geracao da Instrucao SQL
cQuery := " SELECT R_E_C_N_O_ AS RECSN1"
cQuery += " FROM " + RetSQLName("SN1") + " " 
cQuery += " WHERE N1_FILIAL = '41' AND N1_BAIXA = ' ' AND D_E_L_E_T_ = ' ' "
cQuery += " AND N1_CBASE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "

//Cria uma Tabela Termporaria para Query
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cTblSN1, .F., .T.)},"Aguarde..")

//³ Define a regua de processamento                                                     ³
ProcRegua((cTblSN1)->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia o controle de transacao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Begin Transaction

//Le todos os registro da tabela temporia cTblSN1
While !(cTblSN1)->(Eof())

		SN1->(dbGoto((cTblSN1)->RECSN1))
	    cChave := xFilial("SN1")+SN1->(N1_CBASE+N1_ITEM)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua de processamento                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc( "Excluindo Registro, Cod. do Bem: "+SN1->N1_CBASE+" Item: "+SN1->N1_ITEM )
	
		//Exclui os movimentos do Bem
		SN4->(dbSetOrder(1))   //N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO+DTOS(N4_DATA)+N4_OCORR+N4_SEQ                                                                                                
		If SN4->(dbSeek(xFilial("SN4") + SN1->(N1_CBASE+N1_ITEM) ))
			While SN4->(!EOF()) .And. SN4->(N4_FILIAL+N4_CBASE+N4_ITEM) == xFilial("SN1")+SN1->(N1_CBASE+N1_ITEM)
				RecLock("SN4",.F.)
				SN4->(dbDelete())
				MsUnLock()
				SN4->(dbSkip())
			EndDo
		EndIf
		
		//Exclui os Saldos e Valores do Ativo 
		SN3->(dbSetOrder(1))   //N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ                                                                                             
		If SN3->(dbSeek(xFilial("SN3") + SN1->(N1_CBASE+N1_ITEM) ))
			While SN3->(!EOF()) .And. SN3->(N3_FILIAL+N3_CBASE+N3_ITEM) == xFilial("SN1")+SN1->(N1_CBASE+N1_ITEM)
				RecLock("SN3",.F.)
				SN3->(dbDelete())
				MsUnLock()
				SN3->(dbSkip())
			EndDo
		EndIf
		
		//Exclui o Ativo Fixo
		SN1->(DbSetOrder(1))
		If SN1->(DbSeek(cChave))
			If SN1->(RecLock("SN1",.F.))
				SN1->(dbDelete())
				SN1->(MsUnLock())
			EndIf
		EndIf
	
   	(cTblSN1)->(DBSkip())
EndDo                            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o controle de transacao                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
End Transaction      

Return    


User Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nLoop1	:= 0

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
