//Bibliotecas
#Include "Protheus.ch"
  
 /*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT120TEL   - Autor: Felipi Marques                                                                    |
 | Desc:  Ponto de Entrada para adicionar campos no cabeçalho do pedido de compra                               |
 | Link:  http://tdn.totvs.com/display/public/mp/MT120TEL                                                       |
 *--------------------------------------------------------------------------------------------------------------*/
 
User Function MT120TEL()

Local oNewDialog	:= PARAMIXB[1]
Local aPosGet 		:= PARAMIXB[2]
Local aObj			:= PARAMIXB[3]
Local nOpcx			:= PARAMIXB[4]
Local nReg 			:= PARAMIXB[5]
Local aArea			:= GetArea()   
Local lEdit         := IIF(nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx ==  9, .T., .F.) //Somente será editável, na Inclusão, Alteração e Cópia

Local oSay1Choice
Local bSay1Choice
Local bGet1Choice
Local bPos1Array 
Local oGet1Choice

Private cCorBlack	:= CLR_BLACK
Private cCorWhite	:= CLR_WHITE

Public nChoice 	:= 1
Public cChoice	:= ''
Public aChoice := 	{""		                    ,;	
					 "1 - Regularizações "		,;	
					 "2 - Centralizados "		,;	
 					 "3 - Descentralizados " 	 } 


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Define o conteúdo para os campos                           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SC7->(DbGoTo(nReg))
If nOpcx == 3
   cChoice := CriaVar("C7_TIPCOM",.F.)
   nChoice := 1
Else
	If SC7->C7_TIPCOM = "1"
       	nChoice := 2 
 	ElseIf SC7->C7_TIPCOM = "2"
      	nChoice := 3
    ElseIf SC7->C7_TIPCOM = "3"
     	nChoice := 4  
    Else 
    	nChoice := 1  
    EndIf	 
EndIf  

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Monta Tela de Interacao com Usuario                           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
bSay1Choice	:= {|| "Tipo Pedido "}  
bGet1Choice	:= {|x| cChoice:= aChoice[nChoice], If(PCount()>0, cChoice :=x, cChoice )} 
bPos1Array	:= {||  nChoice:= oGet1Choice:nAt} 

oSay1Choice	:= TSay():New( 062, aPosGet[1,08] - 012 , bSay1Choice, oNewDialog,,,.F.,.F.,.F.,.T.,cCorBlack,cCorWhite,045,008) 
oGet1Choice	:= TComboBox():New( 061,aPosGet[1,09] - 006 , bGet1Choice, aChoice, 090, 010, oNewDialog,, bPos1Array,,cCorBlack,cCorWhite,.T.) 

//Se não houver edição, desabilita os gets
If !lEdit
	oGet1Choice:lActive := .F.
EndIf
 
RestArea(aArea)  

  
Return
  
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MTA120G2                                                                                              |
 | Desc:  Ponto de Entrada para gravar informações no pedido de compra a cada item (usado junto com MT120TEL)   |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
 *--------------------------------------------------------------------------------------------------------------*/
  
User Function MTA120G2()
    Local aArea := GetArea()
 
    //Atualiza a descrição, com a variável pública criada no ponto de entrada MT120TEL
    If nChoice = 1
   	 	SC7->C7_TIPCOM  := ""
    Else
    	SC7->C7_TIPCOM  := StrZero(nChoice-1,1)
    EndIf
    
 
    RestArea(aArea)
Return