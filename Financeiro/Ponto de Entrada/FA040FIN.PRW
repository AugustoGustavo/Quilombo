#Include "topconn.CH"
#Include "Colors.ch"
#Include "Protheus.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³FA040FIN  º Autor ³ Deny B. Mendonca          ºData³25.12.2006º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³                                                      		 º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe    ³U_FA040FIN                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros ³                                                              º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso        ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSolicitante³                                              ºData³          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ALTERACOES EFETUADAS APOS CONSTRUCAO INICIAL               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista   ³                                              ºData³          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAutor      ³                                              ºData³          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			Aviso("Natureza Nao Encontrada", "Verifique o Titulo pois não foi encontrado Rateio para a Natureza:"+aCols_x[nA][nPosNat], {"&Verifique"},,"" )
		EndIf
	Next nA
EndIf	
aCols_X := {}
aHeader_X:= {}
RestArea(aArea)
SEV->(RestArea(aAreaSev))
Return