#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA280    ºAutor  ³Felipi Marques      º Data ³  07/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada para gravação das informaçoes dos        º±±
±±º          ³   titulos de origem                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Quilombo                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA280()

Local aArea  := GetArea()  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informaçoes da fatura                 . ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Local nRecSE1 	  := aArea[3]
Local cNumFat     := aCols[1][2]   

Local cAliasTMP	  := "SE1QRY"    
Local cObsTMP     := "NF-PARC: "
Local cObs1       := ""
Local cObs2       := ""
Local cObs3       := ""
Local cObs4       := ""  

cQuery  := "SELECT SE1.R_E_C_N_O_ QRYRECNO "
cQuery	+= "FROM "+RetSqlName("SE1")+ " SE1 "
cQuery	+= "WHERE " 
cQuery  += "E1_FILIAL='"	+ xFilial("SE1") + "'"
cQuery	+= " AND E1_FATURA='"+cNumFat +"' AND D_E_L_E_T_ = ' ' "

If Select(cAliasTMP) > 0 
	dbSelectArea(cAliasTMP)
	dbCloseArea()
	dbSelectArea("SE1")
Endif

cQuery := ChangeQuery(cQuery)
dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasTMP,.F.,.T.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o Titulo Fatura que esta sendo gerado. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1)
While (cAliasTMP)->(!Eof() ) 
	dbSelectArea("SE1")
	dbGoto( (cAliasTMP)->QRYRECNO )
    	cObsTMP += Alltrim(STR(VAL(SE1->E1_NUM)))+"-"+Alltrim(STR(VAL(SE1->E1_PARCELA)))+"|"
	(cAliasTMP)->(dbSkip())  
Enddo	

cObsTMP := substr(cObsTMP,1,len(cObsTMP)-1)


If !Empty(cObsTMP)
	_nlinha:=Mlcount(cObsTMP,60) 
	For _nr_corrente = 1 to _nlinha
		If _nr_corrente == 1
	   	 cObs1 := Memoline(cObsTMP,55,_nr_corrente)
	   	EndIf
	 Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca e altera o Titulo Original.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE1->(dbGoto(nRecSE1))
RecLock("SE1",.F.)
	If FieldPos("E1_OBS1") > 0
		SE1->E1_OBS1 	:= cObs1
	EndIf 
MsUnLock()


RestArea(aArea)
Return()