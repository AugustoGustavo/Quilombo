#Include "topconn.CH"
#Include "Colors.ch"
#Include "Protheus.CH"
/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   �FA040FIN  � Autor � Deny B. Mendonca          �Data�25.12.2006���
����������������������������������������������������������������������������͹��
���Descricao  �                                                      		 ��� 
����������������������������������������������������������������������������͹��
���Sintaxe    �U_FA040FIN                                                    ���
����������������������������������������������������������������������������͹��
���Parametros �                                                              ��� 
����������������������������������������������������������������������������͹��
���Uso        �                                                              ���
����������������������������������������������������������������������������͹��
���Solicitante�                                              �Data�          ���
����������������������������������������������������������������������������͹��
���               ALTERACOES EFETUADAS APOS CONSTRUCAO INICIAL               ���
����������������������������������������������������������������������������͹��
���Analista   �                                              �Data�          ���
����������������������������������������������������������������������������͹��
���Descricao  �                                                              ���
����������������������������������������������������������������������������͹��
���Autor      �                                              �Data�          ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
Faz a gravacao e destroie as variaveis
/*/

User Function FA040FIN()
Local aArea := GetArea()
Local aAreaSev := SEV->(GetArea())
Local nA := 0       
Local cAlias := "SE1"
Local cCampo := Subs(cAlias,2,2)
Local aHeader_X := {}     // Incluido P11 - HC 15.02.13 
Local aCols_x := {}       // Incluido P11 - HC 15.02.13
//Local nPosNat := aScan(aHeader_X,{|x| AllTrim(x[2])=="EV_NATUREZ"})
//Local nPosObs := aScan(aHeader_X,{|x| AllTrim(x[2])=="EV_OBSERV"})

If SE1->E1_MULTNAT == "1"  .And. (Inclui .Or. Altera)

	nPosNat := aScan(aHeader_X,{|x| AllTrim(x[2])=="EV_NATUREZ"})
	nPosObs := aScan(aHeader_X,{|x| AllTrim(x[2])=="EV_OBSERV"})
	For nA := 1 To Len(aCols_X)
	    dbSelectArea("SEV")
		SEV->(dbSetOrder(1))
		If DbSeek(xFilial("SEV")+;
				(cAlias)->&(cCampo + "_PREFIXO")+;
				(cAlias)->&(cCampo + "_NUM")+;
			  	(cAlias)->&(cCampo + "_PARCELA")+;
				(cAlias)->&(cCampo + "_TIPO")+;
				(cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))+;
				(cAlias)->&(cCampo + "_LOJA")+;
				aCols_x[nA][nPosNat])
			RecLock("SEV",.f.)
				SEV->EV_OBSERV := aCols_x[nA][nPosObs]
			MsUnlock()	
		Else
			Aviso("Natureza Nao Encontrada", "Verifique o Titulo pois n�o foi encontrado Rateio para a Natureza:"+aCols_x[nA][nPosNat], {"&Verifique"},,"" )
		EndIf
	Next nA
EndIf	
aCols_X := {}
aHeader_X:= {}
RestArea(aArea)
SEV->(RestArea(aAreaSev))
Return