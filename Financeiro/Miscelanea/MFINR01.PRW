#Include "Protheus.ch"
#Include "rwmake.ch"
#include "fileio.ch"
#include "topconn.ch"
#Include "AP5MAIL.ch"
#Include "tbicode.ch"        

#DEFINE ENTER chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFINR01  บAutor  ณFelipi Marques       บ Data ณ  05/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Quilombo                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MFINR01()

Local nLenNumBor := TamSx3("E2_NUMBOR")[1]
Private cQuery    := ""
Private cPerg     := "LIMCODB"
private _cNomeArq := CriaTrab(Nil,.F.)
Private aCampos	  := {}
Private oDlg
Private cMarca    := GetMark()
Private lInverte  := .F.
PRIVATE MARCADO   := " "


validperg()

if !Pergunte(cPerg,.T.)
	return // se nao confirmar os parametros, sai da rotina
endif


cQuery := " SELECT '  ' MARCADO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_VENCTO,E2_EMISSAO,E2_VALOR,E2_CODBAR,R_E_C_N_O_ AS RECSE2 "
cQuery += " FROM " + RetSQLName("SE2") + " " +ENTER
cQuery += " WHERE " + ENTER
cQuery += "     E2_FILIAL = '" + xFilial("SE2") + "' 
cQuery += " AND E2_VENCTO BETWEEN    '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'" + ENTER
cQuery += " AND E2_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" + ENTER
cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVTAXA,"|") 
cQuery += " AND E2_CODBAR <> ''" + ENTER   
cQuery += " AND E2_SALDO > 0 "+ ENTER
cQuery += " AND D_E_L_E_T_ = ' '"+ENTER
cQuery += " ORDER BY E2_VENCTO"+ENTER

TcQuery cQuery New Alias "QUERY"

TcSetField("QUERY", "E2_VALOR"  , "N", 17, 2)
TcSetField("QUERY", "RECSE2"     , "N", 17, 2)
TcSetField("QUERY", "E2_EMISSAO", "D", 08, 0)
TcSetField("QUERY", "E2_VENCTO" , "D", 08, 0)

// Grava o resultado da Query em um arquivo temporario
DbSelectArea("QUERY")
dbgotop()
copy to &(_cNomeArq)
QUERY->(dbclosearea())
dbUseArea(.T.,,_cNomeArq,"TRB",.T.)

if TRB->(RecCount())>0
        
	aAdd(aCampos,{"MARCADO"		,"",""				 ,""})
	aAdd(aCampos,{"E2_PREFIXO"	,"","Prefixo"		 ,""})
	aAdd(aCampos,{"E2_NUM"		,"","Documento"		 ,""})
	aAdd(aCampos,{"E2_PARCELA"	,"","Parcela"   	 ,""})
	aAdd(aCampos,{"E2_FORNECE"	,"","Fornecedor"	 ,""})
	aAdd(aCampos,{"E2_LOJA"		,"","Loja"			 ,""})
	aAdd(aCampos,{"E2_NOMFOR"	,"","Nome Fornecedor",""})
	aAdd(aCampos,{"E2_VENCTO"   ,"","Vencimento"     ,""})  
	aAdd(aCampos,{"E2_EMISSAO"  ,"","Emissใo" 	     ,""})
	aAdd(aCampos,{"E2_VALOR"    ,"","Valor"			 ,"@E 9,999,999.99"}) 
	aAdd(aCampos,{"E2_CODBAR"   ,"","Cod Barra"		 ,""}) 
	aAdd(aCampos,{"RECSE2"       ,"","Recno"		     ,""})

	
	TRB->(dbgotop())
	
	DEFINE MSDIALOG oDlg TITLE "Selecione os Tํtulos" From 0,0 To 340,1015 of oMainWnd PIXEL
	
	oMark := MsSelect():New("TRB","MARCADO",,aCampos,@lInverte,@cMarca,{30,1,150,500})
	
	oMark:bMark := {|| ChkEnvM()}
	oMark:oBrowse:lhasMark = .T.
	oMark:oBrowse:lCanAllmark := .F.
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||LimpCodB(),close(oDlg)},{|| close(oDlg)}) centered
	
else
	
	msgstop("Nใo existem Tํtulos")
	
endif

TRB->(dbclosearea())

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |LimpCodB   บAutor  ณFelipe                             05/12/17
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia email para os fornecedores                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function LimpCodB()

TRB->(dbgotop())

while TRB->(!eof())
	
	dbselectarea("TRB")
	
	If IsMark("MARCADO",cMarca,lInverte)
		DbSelectArea("SE2")
		SE2->( dbGoto( TRB->RECSE2 ) )
		RecLock("SE2",.F.)                                  
			SE2->E2_CODBAR := ""
        MsunLock()      
	   	TRB->(DBSKIP())
	else
		TRB->(DBSKIP())
	endif
enddo

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkEnvM   บAutor  ณFelip1              บ Data ณ   05/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se jแ foi enviado email para o fornecedor         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ChkEnvM()
if IsMark("MARCADO",cMarca,lInverte)
	//if !empty(TRB->E2_XENMAIL) .and. !msgyesno("Jแ foi enviado email para o fornecedor " + TRB->E2_NOMFOR + " referente a NF " + TRB->E2_NUM + ". Deseja continuar assim mesmo?")
	//	RecLock("TRB",.F.)
	//	TRB->MARCADO := "  "
	//	MsUnlock()
	//endif
endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณFelipe              บ Data ณ  05/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function VALIDPERG()
PutSX1(cPerg,"01","De Data Vencto ?"		,"De Data Vencto ?"		,"De Data Vencto ?"		,"mv_ch1","D",08,0,0,"G","","","","","","mv_par01","","","","01/01/07","","","","","","","","","","","","")
PutSX1(cPerg,"02","Ate Data Vencto ?"	    ,"Ate Data Vencto ?"		,"Ate Data Vencto ?"		,"mv_ch2","D",08,0,0,"G","","","","","","mv_par02","","","","31/12/07","","","","","","","","","","","","")
PutSX1(cPerg,"03","De Fornecedor ?"	        ,"De Fornecedor ? "	        ,"De Fornecedor ? "	        ,"mv_ch3","C",06,0,0,"G","","SA2","","S","mv_par03","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Ate Fornecedor ?"	    ,"Ate Fornecedor ? "	    ,"Ate Fornecedor ? "	    ,"mv_ch4","C",06,0,0,"G","","SA2","","S","mv_par04","","","","","","","","","","","","","","","","","")
return