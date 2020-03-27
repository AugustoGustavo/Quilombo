#include "rwmake.ch"
#include "protheus.ch"
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������ͱ����������������
���������������������������������������������������������������������������ͻ��
���Programa  �MTA103OK  �Autor  �Felipi Marques      � Data �  09/10/15     ���
���������������������������������������������������������������������������͹��
//�LOCALIZA��O:                                                               �
//�Na rotina de documento de entrada na fun��o A103VldEXC.                    �
//�                                                                           �
//�EM QUE PONTO:                                                              �
//�� executado ap�s a confirma��o da exclus�o de um documento.                �
//�                                                                           �
//�UTILIZA��O:                                                                �
//�Este ponto de entrada permite ao usu�rio determinar se durante a exclus�o  �
//�deum documento de entrada, ser�o ou n�o realizadas valida��es adicionais   �
//�antes de prosseguir com o processo. Atualmente a �nica valida��o executada �
//�pela rotina� verificar se existem pedidos de venda vinculados aos itens da �
//�nota que est�sendo exclu�da.                                               �
//�                                                                           �
//�PAR�METROS DE ENVIO:                                                       �
//�Nenhum par�metro � enviado ao ponto de entrada:                            �
//�                                                                           �
//�PAR�METROS DE RETORNO:                                                     �
//�� esperado como retorno um valor l�gico (verdadeiro ou falso). Se o        �
//�retornofor verdadeiro, a rotina executar� as valida��es normalmente.       �
//�Se o retorno forfalso as valida��es n�o ser�o executadas.                  �
���������������������������������������������������������������������������͹��
���Uso       � Quilombo                                                     ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function A103VLEX()

Local lRet
Local cTpOper := 'E'

//�Tratamento de recuperacao de registros deletados do CD2                 �
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