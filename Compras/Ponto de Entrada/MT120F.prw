#include "protheus.ch"
#include "topconn.ch"    
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120F    �Autor  �Felipi Marques      � Data �  12/08/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para tratar os aprovadores, de acordo com ���
���          �seus respectivos grupos de centros de custos.               ���
�������������������������������������������������������������������������͹��
���Uso       � Quilombo                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120F()

//�����������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                  								    �
//�������������������������������������������������������������������������������
Local aAreaSAK := SAK->( GetArea() )
Local aAreaSC7 := SC7->( GetArea() )
Local aAreaSCR := SCR->( GetArea() )
Local cCRUSER  := ""
Local cAlcCC   := ""
Private cAlisTrb	:= GetNextAlias()

SAK->( dbSetOrder(2) ) // AK_FILIAL + AK_USER
SC7->( dbSetOrder(1) ) // C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
SCR->( dbSetOrder(2) ) // CR_FILIAL + CR_TIPO + CR_NUM + CR_USER


	
	If SCR->( dbSeek( xFilial("SCR")+"PC"+ca120Num ) )
		Do While SCR->( !EOF() ) .and. SCR->CR_FILIAL == xFilial("SCR")
			cCRUSER := AllTrim(SCR->CR_USER)
			
			If SC7->( dbSeek( xFilial("SC7")+ca120Num ) )
				cAlcCC := Left( AllTrim(SC7->C7_CC),4 )
				
				//���������������������������������������������������������Ŀ
				//� Fecha todas as tabelas temporarias se estiverem abertas �
				//�����������������������������������������������������������
				If(Select(cAlisTrb) > 0, (cAlisTrb)->(dbCloseArea()),"")
				
				//���������������������������������������������������������Ŀ
				//� Procura os aprovadores                                  �
				//�����������������������������������������������������������
				cQuery := " SELECT AK_LIMMIN,AK_LIMMAX              "
				cQuery += " FROM   "+RetSqlName("SAK")+"            "
				cQuery += " WHERE  AK_FILIAL = '"+xFilial("SAK")+"' "
				//IF !cEmpAnt $ "12"
				cQuery += "        AND (AK_CC = '' OR AK_CC LIKE '%"+cAlcCC+"%'  )  "
				//EndIf
				cQuery += "        AND AK_COD = '"+SCR->CR_APROV+"' "
				cQuery += "        AND D_E_L_E_T_ <> '*'            " 
				
				TcQuery cQuery New Alias (cAlisTrb)  
				
				(cAlisTrb)->(DbGoTop())	
				//���������������������������������������������������������Ŀ
				//� Aprovadores sem centro de custo cadastrado              �
				//�����������������������������������������������������������
				If (cAlisTrb)->(EOF())
						RecLock("SCR", .F.)
							SCR->( dbDelete() )
						SCR->( msUnLock() ) 
				Endif

				While (cAlisTrb)->(!EOF()) 
					//���������������������������������������������������������Ŀ
					//� Analisa os valores das al�adas                          �
					//�����������������������������������������������������������
					dbSelectArea('SAK')
					dbSetOrder(1)
					dbSeek(xFilial('SAK')+SCR->CR_APROV)
					
					If SCR->CR_TOTAL > SAK->AK_LIMMAX //.And. (cAlisTrb)->AK_LIMMIN < SCR->CR_TOTAL
				     		RecLock("SCR", .f.) 
								SCR->( dbDelete() )
							SCR->( msUnLock() ) 
					EndIf
					(cAlisTrb)->(DbSKip()) 
				EndDo 
			
			EndIf
			
			SCR->( dbSkip() )
		EndDo
	EndIf

//�������������������������������������Ŀ
//�Rotina analisa se o pedido � copiado �
//�Felipi Marques - Oficina1 - 20180105 �
//���������������������������������������
uCop(ca120Num)
	
RestArea( aAreaSAK )
RestArea( aAreaSC7 )
RestArea( aAreaSCR )

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120F    �Autor  �Microsiga           � Data �  01/05/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina analisa se o pedido � copiado apagando os campos     ���
���          � C7_XNOMEAP e C7_XDTAPRO                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function uCop(ca120Num)

If lCop
	cUpd := " UPDATE " + RetSqlName("SC7") + " SET C7_XNOMEAP = '', C7_XDTAPRO = ''"
	cUpd += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' "
	cUpd += " AND C7_NUM = '"+ca120Num+"' "
	cUpd += " AND D_E_L_E_T_=' ' "
	
	tcSQLExec(cUpd)
	tcSQLExec("COMMIT")
EndIf

Return Nil