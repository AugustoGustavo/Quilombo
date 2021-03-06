#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097APR  �Autor  �Felipi Marques     � Data �  12/12/17    ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada no final da aprovacao manual do pedido     ���
���          �de compras.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Quilombo                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT097APR()

Local a_area	 := GetArea()
Private cAprv	 := SCR->CR_USER
Private cNapr	 := Busca_NOME(SCR->CR_USER)
Private	cNum	 := AllTrim(SCR->CR_NUM)
Private	dDataLib := SCR->CR_DATALIB
Private aAreac7


If SCR->CR_STATUS == '03'
	//���������������������������������������������Ŀ
	//�Atualiza os itens do pedido de compras       �
	//�����������������������������������������������
	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7")+cNum)
	aAreac7:= SC7->(GetArea())

	While SC7->(!EOF()) .and. SC7->C7_NUM == cNum
			RecLock( "SC7", .F. )
			IF Len(AllTrim(cNapr)) <> 0
				SC7->C7_XNOMEAP := cNapr
				SC7->C7_XDTAPRO := dDataLib
			Endif
			MSUnlock()
		SC7->(DbSkip())
	EndDo
EndIf
RestArea(aAreac7)
RestArea(a_area)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Busca_Nome�Autor  �Felipi Marques      � Data �  12/12/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Busca o Nome do Usu�rio Logado.				              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Busca_NOME(c_User)

c_user := Iif(c_User=Nil, __CUSERID, c_user)

_aUser := {}
psworder(1)
pswseek(c_user)
_aUser := PSWRET()

If len(_aUser) > 0
	_cnome		:= Substr(_aUser[1,4],1,50)
EndIf

Return(_cnome)