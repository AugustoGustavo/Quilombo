#include "RWMake.Ch"
#include "Protheus.Ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TgRETCC  � Autor � HCCONSYS               � Data � 03/04/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna cod agencia e conta para sispag itau               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MP8                                                        ���
�������������������������������������������������������������������������Ĵ��
��� DATA     � Analista Descricao da alteracao                            ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TGAGECC()

Local _cAGeCC:=space(20)

if Sa2->a2_BANCO == "341"  // BANCO Itau
	_cAgeCC := "0"
	_cAgeCC += STRZERO(VAL(SA2->A2_AGENCIA),4)
	_cAgeCC += SPACE(1)
	_cAgeCC += "0000000"
	_cAgeCC += STRZERO(VAL(SUBS(SA2->A2_NUMCON,1,5)),5)
	_cAgeCC += SPACE(1)
	_cAgeCC += Alltrim(SA2->A2_XDVCONT)  //A2_XDVCTA  @!  DV Conta    Digito Verific. Conta  
Else  // OUTROS BANCOS
	
	_cAgeCC := STRZERO(VAL(SA2->A2_AGENCIA),5)
	_cAgeCC += SPACE(1)
	_cAgeCC += STRZERO(VAL(ALLTRIM(SA2->A2_NUMCON)),12)
	
	IF LEN(alltrim(SA2->A2_XDVCONT)) == 2
		_cAgeCC +=Alltrim(SA2->A2_XDVCONT)
	ELSE
		_cAgeCC += SPACE(1)
		_CAgeCC += alltrim(SA2->A2_XDVCONT)
	ENDIF
	
	
Endif


Return(_cAgeCC)


