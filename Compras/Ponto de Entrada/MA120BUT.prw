#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120BUT  ºAutor  ³Felipi Marques       º Data ³  15/06/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Adiciona  Botoão para consulta de aprovações do Pedido    º±±
±±º          ³  e histórico de reviões                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA120BUT() 

	Local aButtons := {}   
	Local cPc      := ""//M->C7_NUM
	
	aadd(aButtons,{'USER'  ,{|| U_FS120Hist(cPc)},'* Consulta Alçadas','* Consulta Alçadas'}) 

Return (aButtons)               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS120Hist  ºAutor  ³Felipi Marques       ºData ³  15/06/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Tela com histórico de revisões do pedido                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            

User Function FS120Hist(cPc)                                        

	Local cNum   := cA120Num//cPc 
	Local aArea  := getArea()
	Local cTipo  := nTipoPed//"PC"
	Local cTpDoc   :=""
	Local oGroup1
	Local oGroup2
	Local oLB1
	Local nLB1   := 1
	Local oLB2
	Local nLB2   := 1
	Local oOK
	Local aVetor := {}

	Static oDlg  
	
	If cTipo=1
		cTpDoc:="PC"
	ElseIf cTipo=2
		cTpDoc:="AE" 
	Else   
		cTpDoc:="XX"  // Tipo genérico para informar que não passa pelo Action View		
	Endif
	
	If cTpDoc="XX"
		msgAlert("Para este tipo de documento não existe Processo de Action View History")
		Return NIL
	Endif	
	
	//-----------------------------------------
	//Verifica se há na SCR registro de alçada
	//-----------------------------------------	
	dbSelectArea("SCR")
	dbSetOrder(1) 
	dbGoTop()   
	
	If dbSeek(xFilial("SCR")+cTpDoc+cNum)       
	
		DEFINE MSDIALOG oDlg TITLE "Histórico de Aprovações e Justificativas" FROM 000, 000  TO 300, 700  COLORS 0, 16777215 PIXEL
    		@ 0, 0 LISTBOX oLB2 FIELDS HEADER;
    			     	"","Pedido","Status","Data Lib.","Valor Pedido","Valor Liberado","Aprov.";
    					SIZE 350, 133 OF oDlg PIXEL  

   						//-------------------------------
   						// Função que monta a Lista BOX 
   						//-------------------------------   				
   						FSListSCR(@oLb2,cNum)            
	    	@  135, 310 BUTTON oOK PROMPT "Ok" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()
  		ACTIVATE MSDIALOG oDlg CENTERED
 	 Else
 	 	msgAlert("Este Pedido não possui controle de Aprovação")
	Endif                   
	
	RestArea(aArea)
Return  
                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FSListSCR ºAutor  ³Felipi Marques       ºData ³  15/06/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função que monta o vetor com os dados da SCR para         º±±
±±º          ³  alimentar o ListBox                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FSListSCR(oLb2,cNum)

	Local aArea  := getArea()
	Local aVetor   := {} 
	Local cPc      := cNum
	Local lMark
	Local cCodPc   := ""
	Local dData    := ""
	Local cHora    := ""
	Local cReq     := ""
	Local cCompra  := ""
	Local cNomLib  := ""
	Local cJustif  := ""
	Local oDlg
	Local oLbx     := oLb2
	Local cTitulo  := "Consulta de Aprovações "
	Local aCab     := {}
	Local cSaldo    
	Local cQuery   := ""
	Local cQry     := "" 
	Local cAprov   := ""
	Local cAlias   := getNextAlias()
	
	//-----------------------------------------------------------
	// Query Buscando todos as aprovações, inclusive os deletados
	//------------------------------------------------------------
	
	cQuery    := "SELECT SCR.* FROM "+RetSqlName("SCR")+" SCR "
	cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
	cQuery    += "SCR.CR_NUM = '"+ cPc +"' AND D_E_L_E_T_ = ' ' "
	cQuery    += "ORDER BY SCR.CR_STATUS"
	
	cQuery := ChangeQuery(cQuery)    
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias)

	//-------------------------------
	// Carrega o vetor da ListMark                                         
	//-------------------------------
	dbSelectArea(cAlias)
	(cAlias)->( dbGoTop() )
	While (cAlias)->( !Eof() )	 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ 
		//³aVetor[oLbx:nAt, 1] - lMark              ³ 
		//³aVetor[oLbx:nAt, 2] - Número do Pedido   ³ 
		//³aVetor[oLbx:nAt, 3] - Número da revisão  ³ 
		//³aVetor[oLbx:nAt, 4] - Data               ³ 
		//³aVetor[oLbx:nAt, 5] - Hora               ³ 
		//³aVetor[oLbx:nAt, 6] - Requisitante       ³ 
		//³aVetor[oLbx:nAt, 7] - Comprador          ³ 
		//³aVetor[oLbx:nAt, 8] - Justificativa      ³ 			
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		 
		cAprov := ""
		Do Case
             Case (cAlias)->CR_STATUS == "01"
                     cAprov := "Aguardando"
             Case (cAlias)->CR_STATUS == "02"
                     cAprov := "Em Aprovacao"
             Case (cAlias)->CR_STATUS == "03"
                     cAprov := "Aprovado"
             Case (cAlias)->CR_STATUS == "04"
                     cAprov := "Bloqueado"
             Case (cAlias)->CR_STATUS == "05"
                     cAprov := "Nivel Liberado"
        EndCase	
        
		cCodPc   := (cAlias)->CR_NUM
		dData    := (cAlias)->CR_DATALIB
		nTotal   := (cAlias)->CR_TOTAL
		nValLib  := (cAlias)->CR_VALLIB
		cLibApro := (cAlias)->CR_USERLIB
		cStatus   := cAprov
			    		
	   	//aAdd( aVetor,{lMark,AllTrim(cCodPc),cStatus,dData, nTotal, nValLib, UsrRetName(cLibApro) })	
	   	aAdd( aVetor,{lMark,AllTrim(cCodPc),cStatus,StoD(dData), Transform(nTotal,"@E 999,999,999.99"), Transform(nValLib,"@E 999,999,999.99"), AllTrim(UsrFullName((cAlias)->CR_USER)) })	       	
	   	
       	DbSelectArea(cAlias)
		(cAlias)->( dbSkip() )	
	EndDo	                                                
	//------------------------------------------------------
	// Se não houver justificativas a serem apresentadas...
	//------------------------------------------------------
	If Len( aVetor ) == 0
   		Aviso( cTitulo, "Não existem registro de aprovações/ Bloqueios para este pedido", {"Ok"} )
 		Return
	Endif 
	//-----------------------------------------------
	// Monta vetor para com os dados das liberações.
	//-----------------------------------------------

   		oLb2:SetArray( aVetor )
  		oLb2:bLine := {|| {aVetor[oLb2:nAt,1],;
        		           aVetor[oLb2:nAt,2],;
                	       aVetor[oLb2:nAt,3],;
                     	   aVetor[oLb2:nAt,4],;
                  		   aVetor[oLb2:nAt,5],;
                     	   aVetor[oLb2:nAt,6],;
                     	   aVetor[oLb2:nAt,7]}}
        oLb2:Refresh()
        (cAlias)->(dbCloseArea())
        
        RestArea(aArea)                   

Return 