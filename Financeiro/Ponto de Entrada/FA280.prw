#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA280    �Autor  �Felipi Marques      � Data �  07/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para grava��o das informa�oes dos        ���
���          �   titulos de origem                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Quilombo                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA280()

Local aArea  := GetArea()  
//�����������������������������������������Ŀ
//� Informa�oes da fatura                 . �
//������������������������������������������� 
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

//�������������������������������������������������Ŀ
//� Atualiza o Titulo Fatura que esta sendo gerado. �
//���������������������������������������������������
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

//�����������������������������������������Ŀ
//� Busca e altera o Titulo Original.       �
//�������������������������������������������
SE1->(dbGoto(nRecSE1))
RecLock("SE1",.F.)
	If FieldPos("E1_OBS1") > 0
		SE1->E1_OBS1 	:= cObs1
	EndIf 
MsUnLock()


RestArea(aArea)
Return()