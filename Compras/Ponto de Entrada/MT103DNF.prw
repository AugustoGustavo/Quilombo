#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103DNF  ºAutor  ³Felipi Marques      º Data ³  03/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VALIDAÇÃO DA CHAVE E SERIE DA NFE                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QUILOMBO                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103DNF()

Local lRet       := .T.
Local lValEmpr   := SuperGetMV("MV_XVALEMP", ,.F.) //Valida empresa para funcionar a rotina.


If TRIM(M->CFORMUL) == "N" .AND. TRIM(M->CESPECIE) == "SPED" .AND. lValEmpr
	If Empty(PARAMIXB[1][13])
		MSGSTOP("Favor informar o campo CHAVE NFE.")
		lRet = .F.
	ElseIf Empty(M->CSERIE)
		MSGSTOP("Favor informar o campo SERIE.")
		lRet = .F.
	Else
		If len(trim(PARAMIXB[1][13])) < 44
			MSGSTOP("Favor informar o campo CHAVE NFE com 44 dígitos.")
			lRet = .F.
		Endif
		
		_cQuery := "SELECT R_E_C_N_O_ REG, * FROM "+RetSqlName("SF1")+" SF1 WHERE F1_CHVNFE = '"+PARAMIXB[1][13]+"' AND D_E_L_E_T_ <> '*' "
		
		If Select("QRCHV") > 0
			dbSelectArea("QRCHV")
			QRCHV->(dbCloseArea())
		EndIf
		
		TcQuery _cQuery New Alias "QRCHV"
		
		QRCHV->(dbGoTop())
		If QRCHV->REG > 0
			Aviso("Aviso","NF já cadastrada no sistema."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			"Filial    : "+QRCHV->F1_FILIAL+Chr(13)+Chr(10)+;
			"Doc    : "+QRCHV->F1_DOC+Chr(13)+Chr(10)+;
			"Serie  : "+QRCHV->F1_SERIE+Chr(13)+Chr(10)+;
			IIF(QRCHV->F1_TIPO=="N","Fornece: ","Cliente: ")+;
			QRCHV->F1_FORNECE+Chr(13)+Chr(10)+;
			"Nome  : "+;
			IIF(QRCHV->F1_TIPO=="N",Posicione("SA2",1,xFilial("SA2")+QRCHV->F1_FORNECE+QRCHV->F1_LOJA,"A2_NOME"),;
			Posicione("SA1",1,xFilial("SA1")+QRCHV->F1_FORNECE+QRCHV->F1_LOJA,"A1_NOME")		);
			,{"Ok"},3)
			Return(.F.)
		EndIf
		
	end if
EndIf

Return (lRet) 
