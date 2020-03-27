#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±ÍÍ±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA103OK  ºAutor  ³Felipi Marques      º Data ³  09/10/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//³LOCALIZAÇÃO:                                                               ³
//³Na rotina de documento de entrada na função A103VldEXC.                    ³
//³                                                                           ³
//³EM QUE PONTO:                                                              ³
//³É executado após a confirmação da exclusão de um documento.                ³
//³                                                                           ³
//³UTILIZAÇÃO:                                                                ³
//³Este ponto de entrada permite ao usuário determinar se durante a exclusão  ³
//³deum documento de entrada, serão ou não realizadas validações adicionais   ³
//³antes de prosseguir com o processo. Atualmente a única validação executada ³
//³pela rotinaé verificar se existem pedidos de venda vinculados aos itens da ³
//³nota que estásendo excluída.                                               ³
//³                                                                           ³
//³PARÂMETROS DE ENVIO:                                                       ³
//³Nenhum parâmetro é enviado ao ponto de entrada:                            ³
//³                                                                           ³
//³PARÂMETROS DE RETORNO:                                                     ³
//³É esperado como retorno um valor lógico (verdadeiro ou falso). Se o        ³
//³retornofor verdadeiro, a rotina executará as validações normalmente.       ³
//³Se o retorno forfalso as validações não serão executadas.                  ³
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quilombo                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A103VLEX()

Local lRet
Local cTpOper := 'E'

//³Tratamento de recuperacao de registros deletados do CD2                 ³
dbSelectArea("CD2")
dbSetOrder(2)

cAliasCD2 := "DelCD2"

cQuery := "SELECT CD2_FILIAL,CD2_TPMOV,CD2_DOC,CD2_SERIE,CD2_CODCLI,CD2_LOJCLI,CD2_CODFOR,CD2_LOJFOR,R_E_C_N_O_ CD2RECNO "
cQuery += "FROM "+RetSqlName("CD2")+" CD2 "
cQuery += "WHERE CD2.CD2_FILIAL='"+xFilial("CD2")+"' AND "
cQuery += "CD2.CD2_SERIE='"+CSERIE+"' AND "
cQuery += "CD2.CD2_DOC='"+CNFISCAL+"' AND "
cQuery += "CD2.CD2_TPMOV='"+cTpOper+"' AND "
cQuery += "CD2.CD2_CODFOR='"+CA100FOR+"' AND "
cQuery += "CD2.CD2_LOJFOR='"+CLOJA+"' AND "
cQuery += "CD2.D_E_L_E_T_=' ' "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCD2)


While (!Eof() .And.	(cAliasCD2)->CD2_FILIAL == xFilial("CD2") .And.	(cAliasCD2)->CD2_TPMOV  == cTpOper	.And.;
	ALLTRIM((cAliasCD2)->CD2_DOC)== ALLTRIM(CNFISCAL)  .And. ALLTRIM((cAliasCD2)->CD2_SERIE)  == ALLTRIM(CSERIE)  .And.;
	ALLTRIM((cAliasCD2)->CD2_CODFOR) == ALLTRIM(CA100FOR) .And. ALLTRIM((cAliasCD2)->CD2_LOJFOR) == ALLTRIM(CLOJA) )
	
	
	CD2->(dbGoto((cAliasCD2)->CD2RECNO))

	RecLock("CD2")
	dbdelete()
	MsUnLock()
	
	dbSelectArea(cAliasCD2)
	dbSkip()
EndDo 

dbSelectArea(cAliasCD2)
dbCloseArea()
dbSelectArea("CD2")


Return(lRet)