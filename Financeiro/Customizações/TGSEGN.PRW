#include "RWMake.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³tgcodbar  ³ Autor ³ HCCONSYS              ³ Data ³ 03/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna codigo de barras para geracao de cnab a pagar      ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MP8                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DATA     ³ Analista Descricao da alteracao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TGSEGN()

Local _campo:=space(178)

Local _cnpj:=space(14) 

//if SM0->M0_CODFIL == "41" 
//	_cnpj:= "07974950000166" 
//else 
	_cnpj:=SUBST(SM0->M0_CGC,1,14)	
//endif 


DO CASE 

CASE SEA->EA_MODELO ==  "16" // DARF NORMAL  

		_campo	:= "02" // DARF NORMAL   
		
		_campo	+= SE2->E2_CODRET // CODIGO DE RETENCAO DA RECETA    	
        
        _campo	+= IF(LEN(ALLTRIM(SM0->M0_CGC)) == 14,"2","1") // 1=PESSOA FISICA,2=PESSOA JURIDICA 

//		_campo 	+= STRZERO(val(SA2->A2_CGC),14)   // cnpj do contribuinte 

		_campo 	+= _cnpj         // cnpj do contribuinte 
		
		_campo 	+= GRAVADATA(SE2->E2_EMISSAO,.F.,5)  // PERIODO DE APURACAO 
		
		_campo	+= Repli("0",17) // numero de referencia 
		
		_campo 	+= STRZERO(SE2->E2_SALDO*100,14) // valor  
		
        _campo 	+= REPL("0",14)  // MULTA   
      
        _campo	+= STRZERO(SE2->E2_ACRESC*100,14) // atualizacao monetaria 
        
        _campo	+= STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) // valor arrecadado 
        
        _campo	+= GRAVADATA(SE2->E2_VENCTO,.F.,5) // data de arrecadacao
                                                                                      
 		_campo	+= IF(EMPTY(SE2->E2_XPAGTO),GRAVADATA(SE2->E2_VENCTO,.F.,5),GRAVADATA(SE2->E2_XPAGTO,.F.,5)) // space(08) // DATA DE PAGTO                                                
 		
 		_campo	+= space(30) // BRANCOS   
 		
 		_campo 	+= SUBS(SM0->M0_NOME,1,30)


CASE SEA->EA_MODELO ==  "17" // GPS  

	_campo	:= "01" // GPS  
	
	IF ALLTRIM(SE2->E2_NATUREZ) == "23307" // INSS RETIDO 
		_campo	+= "2631" // Contribuição retida sobre a NF / Fatura da empresa prestadora de serviço - CNPJ 
	ELSE 
		_campo	+= "2100" // Empresas em Geral - CNPJ
	ENDIF 
	
		_campo 	+= subs(dtos(SE2->E2_EMISSAO),5,2) + subs(dtos(SE2->E2_EMISSAO),1,4) // Mes e ano de compotencia 
		
		_campo 	+= _cnpj  // cnpj do contribuinte 
		
        _campo 	+= STRZERO(SE2->E2_SALDO*100,14) // valor do GPS 
        
        _campo 	+= REPL("0",14)  // valor de outras entidades 
        
        _campo	+= STRZERO(SE2->E2_ACRESC*100,14) // atualizacao monetaria 
        
        _campo	+= STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) // valor arrecadado 
        
        _campo	+= GRAVADATA(SE2->E2_VENCTO,.F.,5) // data de arrecadacao                                                                       
        
 		_campo	+= space(08) //brancos 
 		
 		_campo	+= SA2->A2_CGC + space(36) // cnpj do fornecedor informativo para ser impresso na guia  
 		
 		_campo 	+= SUBS(SM0->M0_NOME,1,30)


CASE SEA->EA_MODELO ==  "16" // DARF NORMAL  

		_campo	:= "02" // DARF NORMAL   
		
		_campo	+= SE2->E2_CODRET // CODIGO DE RETENCAO DA RECETA    	
        
        _campo	+= IF(LEN(ALLTRIM(SM0->M0_CGC)) == 14,"2","1") // 1=PESSOA FISICA,2=PESSOA JURIDICA 

		_campo 	+= _cnpj         // cnpj do contribuinte 

		_campo 	+= GRAVADATA(SE2->E2_EMISSAO,.F.,5)  // PERIODO DE APURACAO 
		
		_campo	+= Repli("0",17) // numero de referencia 
		
		_campo 	+= STRZERO(SE2->E2_SALDO*100,14) // valor  
		
        _campo 	+= REPL("0",14)  // MULTA   
      
        _campo	+= STRZERO(SE2->E2_ACRESC*100,14) // atualizacao monetaria 
        
        _campo	+= STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14) // valor arrecadado 
        
        _campo	+= GRAVADATA(SE2->E2_VENCTO,.F.,5) // data de arrecadacao
                                                                                      
 		_campo	+= IF(EMPTY(SE2->E2_XPAGTO),GRAVADATA(SE2->E2_VENCTO,.F.,5),GRAVADATA(SE2->E2_XPAGTO,.F.,5)) // space(08) // DATA DE PAGTO                                                
 		
 		_campo	+= space(30) // BRANCOS   
 		
 		_campo 	+= SUBS(SM0->M0_NOME,1,30)

   
ENDCASE    
    

Return(_campo)