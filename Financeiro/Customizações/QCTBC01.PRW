#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QCTBC01  ºAutor  ³ Antonio Cordeiro   º Data ³ Fev./08     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna filtro amarracao centro de custo conta contabil     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSolicitante: Marcel                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Empresa QUILOMBO.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function QCTBC01()

Local _aArea     :=GETAREA()
Local _aAreaCTT  :=GETAREA('CTT')
Local _cRgNV1 := ""
Local _cConta :=""
Local _cFilCus:=""

Private _cFiltro:=""
Private _cRet:=""


IF ALLTRIM(__Readvar) == 'M->D1_CC'
	_nPosConta := AScan(aHeader,{|x| AllTrim(x[2]) = "D1_CONTA"})
	_nPosCusto := AScan(aHeader,{|x| AllTrim(x[2]) = "D1_CC"})
	_cConta    := ACOLS[N,_nPosConta]
	_cRet      := ACOLS[N,_nPosCusto]
ELSEIF ALLTRIM(__Readvar) == 'M->CT2_CCC'
	_cConta    :=TMP->CT2_CREDITO
	_cRet      :=TMP->CT2_CCC
ELSEIF ALLTRIM(__Readvar) == 'M->CT2_CCD'
	_cConta    :=TMP->CT2_DEBITO
	_cRet      :=TMP->CT2_CCD
ELSEIF ALLTRIM(__Readvar) == 'M->D3_CC'
	_cConta    :=M->D3_CONTA
	_cRet      :=M->D3_CC
ELSEIF ALLTRIM(__Readvar) == 'M->EZ_CCUSTO'
	_cConta    :=""
	_cRet      :=M->EZ_CCUSTO
ELSEIF ALLTRIM(__Readvar) == 'M->CTJ_CCD'
	_cConta    :=""
	_cRet      :=M->CTJ_CCD   
ELSEIF ALLTRIM(__Readvar) == 'M->CTJ_CCC'
	_cConta    :=""
	_cRet      :=M->CTJ_CCD   
ELSEIF ALLTRIM(__Readvar) == 'M->E2_CCD'
	_cConta    :=""
	_cRet      :=M->E2_CCD
ENDIF

_cFilCus:=Tabela("Z5",SM0->M0_CODFIL,.f.)

CT1->(DBSETORDER(1))                            
IF CT1->(DBSEEK(XFILIAL()+_cConta))
	IF ! EMPTY(CT1->CT1_RGNV1)
		_cRgNv1:=CT1->CT1_RGNV1
		_cFiltro:= " SUBSTR(CTT->CTT_CUSTO,1,2) $ '"+_cFilCus+"'  .AND. LEN(ALLTRIM(CTT->CTT_CUSTO))=4 "
		_cFiltro+= " .AND. ALLTRIM(CTT->CTT_CRGNV1) $ '"+ALLTRIM(_cRgNv1)+"'" 
		//_cFiltro+= " ALLTRIM(CTT->CTT_CRGNV1) $ '"+ALLTRIM(_cRgNv1)+"'"
	ENDIF
ENDIF
IF EMPTY(_cFiltro)
	_cFiltro:= " SUBSTR(CTT->CTT_CUSTO,1,2) $ '"+_cFilCus+"'  .AND. LEN(ALLTRIM(CTT->CTT_CUSTO))=4 "
	//_cFiltro:= " SUBSTR(CTT->CTT_CUSTO,1,2) $ '"+_cFilCus+"'"
	_cFiltro+= " .AND. CTT->CTT_FILIAL == '"+XFILIAL('CTT')+"'"
	//_cFiltro+= " CTT->CTT_FILIAL == '"+XFILIAL('CTT')+"'"
ENDIF

DBSELECTAREA('CTT')
Set Filter to &(_cFiltro)

IF CONPAD1(,,,"CTT")
	_cRet:=CTT->CTT_CUSTO
ENDIF

Set Filter to
RestArea(_aAreaCTT)
RestArea(_aArea)

Return(_cRet)




User Function QCTBC01I()

Local _aArea     :=GETAREA()
Local _aAreaCTD  :=GETAREA('CTD')
Local _cRgNV2 := ""
Local _cCusto :=""

Private _cFiltro:=""
Private _cRet:=""

IF ALLTRIM(__Readvar) == 'M->CT2_ITEMC'
	_cCusto    :=TMP->CT2_CCC
	_cRet      :=TMP->CT2_ITEMC
ELSEIF ALLTRIM(__Readvar) == 'M->CT2_ITEMD'
	_cCusto    :=TMP->CT2_CCD
	_cRet      :=TMP->CT2_ITEMD
ELSEIF ALLTRIM(__Readvar) == 'M->D3_ITEMCTA'
	_cCusto    :=M->D3_CC
	_cRet      :=M->D3_ITEMCTA
ENDIF

CTT->(DBSETORDER(1))
IF CTT->(DBSEEK(XFILIAL()+_cCusto))
	IF ! EMPTY(CTT->CTT_RGNV2)
		_cRgNv2:=CTT->CTT_RGNV2
		_cFiltro:= " ALLTRIM(CTD->CTD_CRGNV2) $ '"+ALLTRIM(_cRgNv2)+"'"
	ENDIF
ENDIF
IF EMPTY(_cFiltro)
	_cFiltro:= " CTD->CTD_FILIAL == '"+XFILIAL('CTD')+"'"
ENDIF

DBSELECTAREA('CTD')
Set Filter to &(_cFiltro)
IF CONPAD1(,,,"CTD")
	_cRet:=CTD->CTD_ITEM
ENDIF
Set Filter to
RestArea(_aAreaCTD)
RestArea(_aArea)

RETURN(_cRet)






User Function QCTBC01C()

Local _aArea     :=GETAREA()
Local _aAreaCTH  :=GETAREA('CTH')
Local _cRgNV3 := ""
Local _cItem :=""

Private _cFiltro:=""
Private _cRet:=""

IF ALLTRIM(__Readvar) == 'M->CT2_CLVLDB'
	_cItem    :=TMP->CT2_ITEMD
	_cRet     :=TMP->CT2_CLVLDB
ELSEIF ALLTRIM(__Readvar) == 'M->CT2_CLVLCR'
	_cItem    :=TMP->CT2_ITEMC
	_cRet     :=TMP->CT2_CLVLCR
ELSEIF ALLTRIM(__Readvar) == 'M->D3_CLVL'
	_cItem    :=M->D3_ITEMCTA
	_cRet      :=M->D3_CLVL
ENDIF

CTD->(DBSETORDER(1))
IF CTD->(DBSEEK(XFILIAL()+_cItem))
	IF ! EMPTY(CTD->CTD_RGNV3)
		_cRgNv3:=CTD->CTD_RGNV3
		_cFiltro:= " ALLTRIM(CTH->CTH_CRGNV3) $ '"+ALLTRIM(_cRgNv3)+"'"
	ENDIF
ENDIF
IF EMPTY(_cFiltro)
	_cFiltro:= " CTH->CTH_FILIAL == '"+XFILIAL('CTH')+"'"
ENDIF

DBSELECTAREA('CTH')
Set Filter to &(_cFiltro)
IF CONPAD1(,,,"CTH")
	_cRet:=CTH->CTH_CLVL
ENDIF
Set Filter to
RestArea(_aAreaCTH)
RestArea(_aArea)


RETURN(_cRet)
