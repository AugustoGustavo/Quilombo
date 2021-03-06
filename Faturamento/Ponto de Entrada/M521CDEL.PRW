#include "rwmake.ch"
#include "protheus.ch"
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������ͱ����������������
���������������������������������������������������������������������������ͻ��
���Programa  �M521CDEL �Autor  �Felipi Marques      � Data �  09/10/15     ���
���������������������������������������������������������������������������͹��
//�O ponto de entrada MA521CDEL existente na fun��o MaCanDelF2 ser�           �
//�   disparado ap�s verificar a amarra��o de uma fatura � solicita��o.       �
���������������������������������������������������������������������������͹��
���Uso       � Quilombo                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function M521CDEL()

Local lRet    := .T.
Local cTpOper := 'S'

//�Tratamento de recuperacao de registros deletados do CD2                 �
dbSelectArea("CD2")
dbSetOrder(2)

cAliasCD2 := "DelCD2"

cQuery := "SELECT CD2_FILIAL,CD2_TPMOV,CD2_DOC,CD2_SERIE,CD2_CODCLI,CD2_LOJCLI,CD2_CODFOR,CD2_LOJFOR,R_E_C_N_O_ CD2RECNO "
cQuery += "FROM "+RetSqlName("CD2")+" CD2 "
cQuery += "WHERE CD2.CD2_FILIAL='"+xFilial("CD2")+"' AND "
cQuery += "CD2.CD2_SERIE='"+SF2->F2_SERIE+"' AND "
cQuery += "CD2.CD2_DOC='"+SF2->F2_DOC+"' AND "
cQuery += "CD2.CD2_TPMOV='"+cTpOper+"' AND "
cQuery += "CD2.CD2_CODFOR='"+SF2->F2_CLIENTE+"' AND "
cQuery += "CD2.CD2_LOJFOR='"+SF2->F2_LOJA+"' AND "
cQuery += "CD2.D_E_L_E_T_=' ' "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCD2)


While (!Eof() .And.	(cAliasCD2)->CD2_FILIAL == xFilial("CD2") .And.	(cAliasCD2)->CD2_TPMOV  == cTpOper	.And.;
	ALLTRIM((cAliasCD2)->CD2_DOC)== ALLTRIM(SF2->F2_DOC)  .And. ALLTRIM((cAliasCD2)->CD2_SERIE)  == ALLTRIM(SF2->F2_SERIE)  .And.;
	ALLTRIM((cAliasCD2)->CD2_CODFOR) == ALLTRIM(SF2->F2_CLIENTE) .And. ALLTRIM((cAliasCD2)->CD2_LOJFOR) == ALLTRIM(SF2->F2_LOJA) )
	
	
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