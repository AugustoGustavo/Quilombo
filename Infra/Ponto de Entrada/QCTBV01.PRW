#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � QCTBV01  �Autor  � Antonio Cordeiro   � Data � Fev./08     ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida Digitacao do campo de centro de custo <> Filial      ���
�������������������������������������������������������������������������͹��
���Solicitante: Marcel                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Empresa QUILOMBO.                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function QCTBV01(_cVariavel)

Local _aArea     :=GETAREA()
Local _cMens     :=""
Local _cRet      :=""
Local _cFilCus   :=""


x:=1


_cFilCus   :=Tabela("Z5",SM0->M0_CODFIL,.f.)
_cMReadVar :='M->'+ALLTRIM(_cVariavel)
_cRet      :=&(_cMReadvar)

IF ! EMPTY(_cRet)
	IF ! SUBSTR(_cRet,1,2) $ _cFilCus
		_cMens+=' Centro de Custo: '+_cRet+' Invalido para esta Filial '+CHR(13)
		_cRet:=""
	ENDIF
ENDIF

IF ! EMPTY(_cMens)
	MSGBOX(_cMens,'Atencao','Info')
ENDIF


RETURN(_cRet)
