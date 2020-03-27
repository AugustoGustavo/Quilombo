#INCLUDE "TOTVS.CH"


/*
Função....: SPDPIS09
Autor.....: HCCONSYS
Data......: 07.02.2013
Descrição.: SPED Contribuicoes ( Registros 0150 / 0500 / F100 )
*/
User Function SPDPIS09()
Local _cFilial  := PARAMIXB[1]
Local dDataDe 	:= PARAMIXB[2]   
Local dDataAte 	:= PARAMIXB[3]
Local aRetF100	:= {}
//Local dData			:= STOD("20120201")  
/*
Local _cFilialA1	:= xFilial("SA1")
Local cFilialSE1	:= xFilial('SE1')
Local cFilialSEV	:= xFilial("SEV")
*/
// Local cFilialSED	:= xFilial("SED")
Local cQuery := ""

If cFilAnt $ '60/70/80' // Não executar PE para essas Filiais
   Return( {} )
Endif

//dbSelectArea("SE1")
//SE1->( dbSetOrder(6) ) // E1_FILIAL+DTOS(E1_EMISSAO)+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA

dbSelectArea("SEV")

/*
dbSelectArea("SED")
SED->( dbSetOrder(1) )
*/

If Select("Work")>0
	Work->( dbCloseArea() )
EndIf

cQuery := " SELECT * "
cQuery += " FROM " + RetSqlName("SE1")
cQuery += " WHERE E1_FILIAL = '"+_cFilial+"' "
cQuery += " AND E1_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQuery += " AND E1_NATUREZ = '61010401'"
cQuery += " AND D_E_L_E_T_=' ' "

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"Work",.T.,.T.)

Do While Work->( !EOF() )
	
	SA1->( MsSeek( _cFilial+Work->E1_CLIENTE+Work->E1_LOJA ) )
	
	If Work->E1_MULTNAT == "1" 
		
		If SEV->( MsSeek( _cFilial + Work->E1_PREFIXO + Work->E1_NUM + Work->E1_PARCELA + Work->E1_TIPO + Work->E1_CLIENTE + Work->E1_LOJA + Work->E1_NATUREZ ) )
			If SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO) == Work->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)  
				
				Aadd( aRetF100, {	'F100'								   		,;	// F100 - 01 - REG
				"1"														   		,;	// F100 - 02 - IND_OPER  ( 0 - Entrada, >0 - Saida )
				"SA1"+Work->E1_FILIAL+Work->E1_CLIENTE+Work->E1_LOJA			,;	// F100 - 03 - COD_PART (Entrada= SA2->A2_COD, Saida=  SA1->A1_COD)
				" "   		     												,;  // F100 - 04 - COD_ITEM
				StoD(Work->E1_EMISSAO)									  		,;  // F100 - 05 - DT_OPER
				SEV->EV_VALOR					           				  		,;  // F100 - 06 - VL_OPER
				"01"		         								  	 		,;  // F100 - 07 - CST_PIS
				SEV->EV_VALOR 							          		  		,;  // F100 - 08 - VL_BC_PIS
				Val("0.6500")										  		 		,;  // F100 - 09 - ALIQ_PIS
				ROUND(SEV->EV_VALOR*0.65/100,2)									,;	// F100 - 10 - VL_PIS
				"01"	        	  								   	 		,;  // F100 - 11 - CST_COFINS
				SEV->EV_VALOR          								   			,;  // F100 - 12 - VL_BC_COFINS
				Val("3.0000")		          	  									,;  // F100 - 13 - ALIQ_COFINS
				ROUND(SEV->EV_VALOR*3.00/100,2)						   			,;  // F100 - 14 - VL_COFINS
				"05"				  											,;  // F100 - 15 - NAT_BC_CRED
				"0"				  												,;  // F100 - 16 - IND_ORIG_CRED
				"61010401"		  												,;  // F100 - 17 - COD_CTA
				''	 												   			,;  // F100 - 18 - COD_CCUS
				''													   			,;  // F100 - 19 - DESC_DOC_OPER
				SA1->A1_LOJA				   									,;	// F100 - 20 - LOJA (Entarada = SA2->A2_LOJA, Saida = SA1->A1_LOJA)				
				'0'		   					  									,;  // F100 - 21 - INDICE DE CUMULATIVIDADE( 0 - Cumulativo, 1 - Nao cumultivo )	
				"SA1"+Work->E1_FILIAL+Work->E1_CLIENTE+Work->E1_LOJA	  		,;  // 0150 - 02 - COD_PART
				SA1->A1_NOME 										  			,;	// 0150 - 03 - NOME
				SA1->A1_CODPAIS	  												,; 	// 0150 - 04 - COD_PAIS
		  		Iif( SA1->A1_PESSOA == 'J', AllTrim(SA1->A1_CGC), "" )					,;  // 0150 - 05 - CNPJ
				Iif( SA1->A1_PESSOA == 'F', AllTrim(SA1->A1_CGC), "" )			  		,;  // 0150 - 06 - CPF
				SA1->A1_INSCR		  											,;  // 0150 - 07 - IE
				UfCodIBGE(SA1->A1_EST)+SA1->A1_COD_MUN	  												,; 	// 0150 - 08 - COD_MUN
				' ' 	           										 		,; 	// 0150 - 09 - SUFRAMA
				SA1->A1_END		 												,; 	// 0150 - 10 - END
				' '																,; 	// 0150 - 11 - NUM
				' '														 		,;	// 0150 - 12 - COMPL
				SA1->A1_BAIRRO	   												,;  // 0150 - 13 - BAIRRO
				'01012007'												 		,;  // 0500 - 02 - DT_ALT
				'04'												   			,;  // 0500 - 03 - COD_NAT_CC
				'A'																,;	// 0500 - 04 - IND_CTA
				'6'		   														,;	// 0500 - 05 - NIVEL
				'61010401'														,;	// 0500 - 06 - COD_CTA
				'ALUGUEIS DE IMOVEIS'									 		,;	// 0500 - 07 - NOME_CTA
				'3.01.01.01.01.06.00'									 		,;	// 0500 - 08 - COD_CTA_REF
				''			,;		// 0500 - 09 - CNPJ_EST
				''			,;		//Codigo da tabela da Natureza da Receita.
				''			,;		//Codigo da Natureza da Receita
				''			,;		//Grupo da Natureza da Receita
				''			})		//Dt.Fim Natureza da Receita
								
			Endif
		Endif
	
	Else
		
		If SE1->( MsSeek( _cFilial + Work->E1_PREFIXO + Work->E1_NUM + Work->E1_PARCELA + Work->E1_TIPO ) )
			If SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) == Work->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)  
				
				Aadd( aRetF100, {	'F100'								   		,;	// F100 - 01 - REG
				"1"														   		,;	// F100 - 02 - IND_OPER  ( 0 - Entrada, >0 - Saida )
				"SA1"+Work->E1_FILIAL+Work->E1_CLIENTE+Work->E1_LOJA			,;	// F100 - 03 - COD_PART (Entrada= SA2->A2_COD, Saida=  SA1->A1_COD)
				" "   		     												,;  // F100 - 04 - COD_ITEM
				StoD(Work->E1_EMISSAO)									  		,;  // F100 - 05 - DT_OPER
				Work->E1_VALOR					           				  		,;  // F100 - 06 - VL_OPER
				"01"		         								  	 		,;  // F100 - 07 - CST_PIS
				Work->E1_VALOR 							          		  		,;  // F100 - 08 - VL_BC_PIS
				Val("0.6500")										  		 		,;  // F100 - 09 - ALIQ_PIS
				ROUND(Work->E1_VALOR*0.65/100,2)								,;	// F100 - 10 - VL_PIS
				"01"	        	  								   	 		,;  // F100 - 11 - CST_COFINS
				Work->E1_VALOR         								   			,;  // F100 - 12 - VL_BC_COFINS
				Val("3.0000")		          	  									,;  // F100 - 13 - ALIQ_COFINS
				ROUND(Work->E1_VALOR*3.00/100,2)					   			,;  // F100 - 14 - VL_COFINS
				"05"				  											,;  // F100 - 15 - NAT_BC_CRED
				"0"				  												,;  // F100 - 16 - IND_ORIG_CRED
				"61010401"		  												,;  // F100 - 17 - COD_CTA
				''	 												   			,;  // F100 - 18 - COD_CCUS
				''													   			,;  // F100 - 19 - DESC_DOC_OPER 
				SA1->A1_LOJA				   									,;	// F100 - 20 - LOJA (Entarada = SA2->A2_LOJA, Saida = SA1->A1_LOJA)				
				'0'		   					  									,;  // F100 - 21 - INDICE DE CUMULATIVIDADE( 0 - Cumulativo, 1 - Nao cumultivo )	
				"SA1"+Work->E1_FILIAL+Work->E1_CLIENTE+Work->E1_LOJA	  		,;  // 0150 - 02 - COD_PART
				SA1->A1_NOME		  											,;	// 0150 - 03 - NOME
		  		SA1->A1_CODPAIS			  											,; 	// 0150 - 04 - COD_PAIS
		  		Iif( SA1->A1_PESSOA == 'J', AllTrim(SA1->A1_CGC), "" )					,;  // 0150 - 05 - CNPJ
				Iif( SA1->A1_PESSOA == 'F', AllTrim(SA1->A1_CGC), "" )			  		,;  // 0150 - 06 - CPF
				SA1->A1_INSCR		  											,;  // 0150 - 07 - IE
				UfCodIBGE(SA1->A1_EST)+SA1->A1_COD_MUN	   												,; 	// 0150 - 08 - COD_MUN
				' ' 	           										 		,; 	// 0150 - 09 - SUFRAMA
				SA1->A1_END		 										   		  ,; 	// 0150 - 10 - END
				' '													   			,; 	// 0150 - 11 - NUM
				' '														 		,;	// 0150 - 12 - COMPL
				SA1->A1_BAIRRO	   										 		,;  // 0150 - 13 - BAIRRO
				'01012007'												 		,;  // 0500 - 02 - DT_ALT
				'04'												   			,;  // 0500 - 03 - COD_NAT_CC
				'A'																,;	// 0500 - 04 - IND_CTA
				'6'		   														,;	// 0500 - 05 - NIVEL
				'61010401'														,;	// 0500 - 06 - COD_CTA
				'ALUGUEIS DE IMOVEIS'									 		,;	// 0500 - 07 - NOME_CTA
				'3.01.01.01.01.06.00'									 		,;	// 0500 - 08 - COD_CTA_REF
				''			,;		// 0500 - 09 - CNPJ_EST
				''			,;		//Codigo da tabela da Natureza da Receita.
				''			,;		//Codigo da Natureza da Receita
				''			,;		//Grupo da Natureza da Receita
				''			})		//Dt.Fim Natureza da Receita
				
			Endif
		Endif
		
	Endif
	
	Work->( dbSkip() )
	
Enddo

Return( aRetF100 )
