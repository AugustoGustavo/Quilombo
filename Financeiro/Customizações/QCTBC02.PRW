#Include "Rwmake.ch"
#INCLUDE "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ExecBlock ³ QCTBC02  |Por: Antonio Cordeiro          ³ Data ³ FEV/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Browse de centro de custos para marcacao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico QUILOMBO                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function QCTBC02(_cAlias)

Local   _aArea   :=GETAREA()
Local   _aAreaCTA:=GETAREA('CTA')
Local	cRet	:= ""
Local	lRet	:= .F.
Local	cSeek	:= '"' + xFilial("CTA") + '"'
Local	cWhile	:= "!EOF() .And. CTA_FILIAL==" + cSeek
Local   _nTam   := 4
Local	nPosTip	:= 0	,;
		nPosOper:= 0	,;
		cAtual	:= ""	,;
		cOpera	:= ""
      

Private	oDlg, oLbx, oChk
Private	oOk     := LoadBitMap(GetResources(), "LBTIK")        	// Bitmap utilizado no Lisbox  (Marcado)
Private oNo     := LoadBitMap(GetResources(), "LBNO")			// Bitmap utilizado no Lisbox  (Desmarcado)
Private oNever  := LoadBitMap(GetResources(), "BR_VERMELHO")	// Bitmap utilizado no Lisbox  (Desabilitado)
Private	lMark	:= .F.

IF _cAlias == 'CT1'
   cAtual	:= M->CT1_RGNV1
   cWhile	:= "!EOF() .And. (CTA_TIPO=='  '.OR. CTA_TIPO=='CC') .AND. CTA_FILIAL==" + cSeek
   cSeek	:= '"' + xFilial("CTA") + 'CC"'
   _nTam:=4
ELSEIF _cAlias == 'CTT' 
   cAtual	:= M->CTT_RGNV2
   cWhile	:= "!EOF() .And. (CTA_TIPO=='  '.OR. CTA_TIPO=='IT') .AND. CTA_FILIAL==" + cSeek
   cSeek	:= '"' + xFilial("CTA") + 'IT"'
   _nTam:=4
ELSEIF _cAlias == 'CTD' 
   cAtual	:= M->CTD_RGNV3
   cWhile	:= "!EOF() .And. (CTA_TIPO=='  '.OR. CTA_TIPO=='CV') .AND. CTA_FILIAL==" + cSeek
   cSeek	:= '"' + xFilial("CTA") + 'CV"'
   _nTam:=5
ENDIF   

X:=1

DEFINE MSDIALOG oDlg TITLE "Amarracao" FROM 5,30 TO 25,80

//aRet	:= LocxGrid("CTA",cWhile,,.T.,".F.",cSeek,1)  
aRet	:= LocxGrid("CTA",cWhile,,.T.,".F.",cSeek,2)
aCab	:= AClone(aRet[3])
aLin	:= AClone(aRet[5])
aTam	:= AClone(aRet[4])
aCpo	:= AClone(aRet[1])

aEval( aLin , { |x,y| aLin[y,1] := Iif( SUBSTR(aLin[y,2],1,_nTam) $ cAtual , 1 , -1 ) })

oLbx := TwBrowse():New(011,000,000,000,,aCab,aTam,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oLbx:nHeight	:= (__DlgHeight(oDlg)*2) - 8
oLbx:nWidth		:= __DlgWidth(oDlg)*2
oLbx:lColDrag	:= .T.
oLbx:nFreeze	:= 1
oLbx:SetArray(aLin)
oLbx:bLine		:= LocxBLin('oLbx',aCpo,.T.)
oLbx:bLDblClick	:={ || ChgMarkLb(oLbx,aLin,{|| .T. },.T.) }

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| lRet := .T.,oDlg:End()},{|| lRet := .F.,oDlg:End()},,)

If lRet
	aEval( aLin, { |x,y| cRet += Iif( aLin[y,1] == 1, Alltrim(aLin[y,2]), "" ) } )
Else
	cRet := cAtual
EndIf

IF _cAlias == 'CT1'
   M->CT1_RGNV1 := cRet
ELSEIF _cAlias =='CTT'
   M->CTT_RGNV2 := cRet
ELSEIF _cAlias =='CTD'
   M->CTD_RGNV3 := cRet
ENDIF   
RestArea(_aArea)
RestArea(_aAreaCTA)
Return cRet    