#Include "topconn.CH"
#Include "Colors.ch"
#Include "Protheus.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³FIN150_2  º Autor ³ Deny B. Mendonca          ºData³27.12.2006º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ³                                                      		 º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe    ³U_FIN150_2                                                    º±±
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
Faz a gravacao no CNAB BOLETO
/*/

User Function FIN150_2()
Local cGrava:= ""
Local lRet := .f.
Local nSoma :=0
If Subs(Upper(mv_par03),1,3)=="BOL"
	cGrava := '2'
	cGrava += Padr(U_BUSCSEV(1,"EV_OBSERV"),26)
	cGrava += Padr(Iif(U_BUSCSEV(1,"EV_VALOR")==0,' ',Transform(U_BUSCSEV(1,"EV_VALOR"), "@E 999,999,999.99")),14)
	//
	nSoma += U_BUSCSEV(1,"EV_VALOR")
	//
	cGrava += Padr(U_BUSCSEV(2,"EV_OBSERV"),26)
	cGrava += Padr(Iif(U_BUSCSEV(2,"EV_VALOR")==0,'',Transform(U_BUSCSEV(2,"EV_VALOR"), "@E 999,999,999.99")),14)
	//
	nSoma += U_BUSCSEV(2,"EV_VALOR")
	//
	cGrava += Padr(U_BUSCSEV(3,"EV_OBSERV"),26)
	cGrava += Padr(Iif(U_BUSCSEV(3,"EV_VALOR")==0,'',Transform(U_BUSCSEV(3,"EV_VALOR"), "@E 999,999,999.99")),14) 
	//        
	nSoma += U_BUSCSEV(3,"EV_VALOR")
	//
	cGrava += Padr(U_BUSCSEV(4,"EV_OBSERV"),26)
	cGrava += Padr(Iif(U_BUSCSEV(4,"EV_VALOR")==0,'',Transform(U_BUSCSEV(4,"EV_VALOR"), "@E 999,999,999.99")),14) 
	//        
	nSoma += U_BUSCSEV(4,"EV_VALOR")                                                  
	//
	cGrava += Padr(U_BUSCSEV(5,"EV_OBSERV"),26)
	cGrava += Padr(Iif(U_BUSCSEV(5,"EV_VALOR")==0,'',Transform(U_BUSCSEV(5,"EV_VALOR"), "@E 999,999,999.99")),14) 
	//        
	nSoma += U_BUSCSEV(5,"EV_VALOR")                  
	//
	cGrava += Padr(U_BUSCSEV(6,"EV_OBSERV"),26)
	cGrava += Padr(Iif(U_BUSCSEV(6,"EV_VALOR")==0,'',Transform(U_BUSCSEV(6,"EV_VALOR"), "@E 999,999,999.99")),14) 
	//        
	nSoma += U_BUSCSEV(6,"EV_VALOR")                  
	//
	cGrava += Padr("TOTAL R$ ",26)
	cGrava += Padr(Transform(nSoma, "@E 999,999,999.99"),14)                  
	//
	//cGrava += Space(400-Len(cGrava)-6)
	cGrava += Space(400-Len(cGrava)-34)
	//
	cGrava += "0100199100588008000000000000"
	//
	cGrava += STRZERO(INCREMENTA(),6)
	cGrava += CHR(13)+CHR(10)
	fWrite(nHdlSaida,cGrava)
	lRet := .t.
EndIf
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA040FIN  ºAutor  ³Microsiga           º Data ³  12/27/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta Endereco de cobranca                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ENDCOB()
Return(Alltrim(IiF(Empty(SA1->A1_ENDCOB),SA1->A1_END,SA1->A1_ENDCOB)))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA040FIN  ºAutor  ³Microsiga           º Data ³  12/27/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BUSCSEV(nCampo,cCampo)
Local aArea := GetArea()
Local aAreaSev := SEV->(GetArea())
Local aAreaSx3 := SX3->(GetArea())
Local nCount := 0
Local xRet
Local cTipo := "C"
Default nCampo := 0

dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek(cCampo)
	cTipo:=AllTrim(SX3->X3_TIPO)
EndIf	
// Compatibiliza a variável com o campo a retornar
// Campo numérico
If cTipo == "N"
	xRet := 0
// Campo Data
ElseIf cTipo == "D"
	xRet := dDatabase
ElseIf cTipo == "C"
	xRet := ""
EndIf

If nCampo > 0
	dbSelectArea("SEV")
	SEV->(dbSetOrder(1))
	If DbSeek(xFilial("SEV")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
		While SEV->(!Eof())	.And. xFilial("SEV")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)==;
				SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)
			nCount++
			If nCount == nCampo
				xRet:=SEV->&(cCampo)
				Exit
			EndIf
			SEV->(dbSkip())
		EndDo 
	EndIf
EndIf	

RestArea(aArea)
SEV->(RestArea(aAreaSev))
SX3->(RestArea(aAreaSX3))

Return(xRet)