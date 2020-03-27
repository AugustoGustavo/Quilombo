#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description
                                                                
@param xParam Parameter Description
@return xRet Return Description                                 
@author  -
@since 16/11/2018                                                   
/*/
//--------------------------------------------------------------
User Function MyQBG()

//?Declaracao de Variaveis                                             

Local nOpca     	:= 0 
Local oEmpDe
Local cEmpDe        := "  "   
// Informe no nome pra sua Janela
Local cTela:="De/Para Cadastros"
// Informe as opcoes que voce deseja no combo
Local oCbx 
Local cCbx := "Produto"
Local nCbx := 1
Local aCbx := {"Produto","Cliente","Fornecedor","Natureza","TES","Lan?meto Padr?","Al?das de Compras","Moedas","Banco e Parametros","Contas a Pagar","Contas Receber","Ativo Fixo" }
Local oDlgCombo,oConf,oCanc,nCombo,uCombo:=1
Local nA := 0

DEFINE MSDIALOG oDlgCombo TITLE cTela FROM 000, 000  TO 200, 400 OF oDlgCombo PIXEL   
@ 027, 004 SAY oSay1 PROMPT "Empresa De:" SIZE 044, 007 OF oDlgCombo COLORS 0, 16777215 PIXEL
@ 026, 053 MSGET oEmpDe VAR cEmpDe SIZE 060, 010 OF oDlgCombo COLORS 0, 16777215 PIXEL
@ 042, 004 SAY oSay2 PROMPT "Tipo de Cadastros" SIZE 046, 007 OF oDlgCombo COLORS 0, 16777215 PIXEL
     
@ 042, 053 MSCOMBOBOX oCbx VAR cCbx ITEMS aCbx SIZE 90,90 OF oDlgCombo PIXEL ON CHANGE nCbx := oCbx:nAt

DEFINE SBUTTON oConf FROM 75, 50 TYPE 1 ACTION ( nOpca := 1,oDlgCombo:End() ) ENABLE OF oDlgCombo
DEFINE SBUTTON oCanc FROM 75, 80 TYPE 2 ACTION ( nOpca := 0,oDlgCombo:End() ) ENABLE OF oDlgCombo
     
ACTIVATE MSDIALOG oDlgCombo CENTERED 

If nOpca=1
   Processa({ |lEnd| fDePara(nCbx,cEmpDe),OemToAnsi("De/Para Cadastros, aguarde...")}, OemToAnsi("Aguarde..."))
Endif

Return()                              

Static Function fDePara(nCombo,cEmpDe)  
        
Local nA:= 0


DO CASE

//Produto
CASE nCombo = 1
		
		DbUseArea(.T.,"TOPCONN","SB1"+cEmpDe+"0","SB1TMP",.F.,.F.)
        /*
		cQuery := " SELECT DISTINCT NATZ.* FROM (SELECT  DISTINCT B1_FILIAL,B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_LOCPAD, B1_GRUPO, B1_PICM,B1_IPI, B1_POSIPI, B1_CODISS, B1_TE, B1_TS, B1_TIPCONV,B1_QE,B1_CONTA, B1_CONRES, B1_CODBAR, B1_IRRF, B1_INSS, B1_PIS, B1_COFINS, B1_CSLL, B1_RETOPER "
		cQuery += "   FROM  SD1"+cEmpDe+"0  SD1 INNER JOIN  SB1"+cEmpDe+"0  SB1 " "
		cQuery += "    ON SB1.B1_COD = SD1.D1_COD  AND SD1.D_E_L_E_T_ <> '*'   "
		cQuery += "   WHERE SD1.D1_EMISSAO >= '20180101'   "
		cQuery += "   UNION ALL  "
		cQuery += "   SELECT  DISTINCT B1_FILIAL,B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_LOCPAD, B1_GRUPO, B1_PICM,B1_IPI, B1_POSIPI, B1_CODISS, B1_TE, B1_TS, B1_TIPCONV,B1_QE,B1_CONTA, B1_CONRES, B1_CODBAR, B1_IRRF, B1_INSS, B1_PIS, B1_COFINS, B1_CSLL, B1_RETOPER "
		cQuery += "   FROM  SD2"+cEmpDe+"0  SD2 INNER JOIN  SB1"+cEmpDe+"0  SB1 "
		cQuery += "    ON SB1.B1_COD = SD2.D2_COD  AND SD2.D_E_L_E_T_ <> '*'   "
		cQuery += "   WHERE SD2.D2_EMISSAO >= '20180101'  "
		cQuery += "   UNION ALL  "
		cQuery += "   SELECT  DISTINCT B1_FILIAL,B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_LOCPAD, B1_GRUPO, B1_PICM,B1_IPI, B1_POSIPI, B1_CODISS, B1_TE, B1_TS, B1_TIPCONV,B1_QE,B1_CONTA, B1_CONRES, B1_CODBAR, B1_IRRF, B1_INSS, B1_PIS, B1_COFINS, B1_CSLL, B1_RETOPER "
		cQuery += "   FROM  SD3"+cEmpDe+"0  SD3 INNER JOIN  SB1"+cEmpDe+"0  SB1 "
		cQuery += "    ON SB1.B1_COD = SD3.D3_COD  AND SD3.D_E_L_E_T_ <> '*'   "
		cQuery += "   WHERE SD3.D3_EMISSAO >= '20180101'   "
		cQuery += "   UNION ALL  "
		cQuery += "   SELECT  DISTINCT B1_FILIAL,B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_LOCPAD, B1_GRUPO, B1_PICM,B1_IPI, B1_POSIPI, B1_CODISS, B1_TE, B1_TS, B1_TIPCONV,B1_QE,B1_CONTA, B1_CONRES, B1_CODBAR, B1_IRRF, B1_INSS, B1_PIS, B1_COFINS, B1_CSLL, B1_RETOPER "
		cQuery += "   FROM  SB9"+cEmpDe+"0  SB9 INNER JOIN  SB1"+cEmpDe+"0  SB1 "
		cQuery += "    ON SB1.B1_COD = SB9.B9_COD  AND SB9.D_E_L_E_T_ <> '*'   "
		cQuery += "   WHERE SB9.B9_DATA >= '20180101'   "

		cQuery += "   ) NATZ "
		cQuery += "   ORDER BY B1_COD "
        */
        
        cQuery := " SELECT * FROM SB1"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"
		
		IF SELECT("SB1TMP") > 0
			DBSELECTAREA("SB1TMP")
			SB1TMP->( DBCLOSEAREA() )
		ENDIF
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SB1TMP", .F., .T.)},"Consultando Dados SB1010...")
		
		//Barra processamento
		nContaRegs := 0
		Count To nContaRegs
		ProcRegua(nContaRegs)
		
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		
		DBSELECTAREA("SB1TMP")
		SB1TMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SB1TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SB1"+cEmpDe+"0, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SB1")
			IF !MsSeek( SB1TMP->B1_FILIAL+SB1TMP->B1_COD )
					RecLock("SB1",.T.)
					For nA:= 1 to FCount() - 2
						IF SB1TMP->(FIELDPOS(SB1->(FIELDNAME(NA)))) > 0
							SB1->(FieldPut(nA,SB1TMP->(FieldGet(FieldPos( SB1->(FIELDNAME(nA)) )))))
						ENDIF
					Next
					SB1->( MsUnLock() )    
			ENDIF

			DBSELECTAREA("SB1TMP")
			SB1TMP->( DBSKIP() )
		END        

//Cliente
CASE nCombo = 2

		DbUseArea(.T.,"TOPCONN","SA1"+cEmpDe+"0","SA1TMP",.F.,.F.)
		
		cQuery := "SELECT * 
		cQuery += "FROM   SA1100 SA171 
		cQuery += "       INNER JOIN (SELECT DISTINCT A1_FILIAL, 
		cQuery += "                                   A1_COD, 
		cQuery += "                                   A1_LOJA 
		cQuery += "                   FROM   SA1100 SA1 
		cQuery += "                          INNER JOIN SE1"+cEmpDe+"0 SE1 
		cQuery += "                                  ON SA1.A1_COD = SE1.E1_CLIENTE 
		cQuery += "                                     AND SA1.A1_LOJA = SE1.E1_LOJA 
		cQuery += "                                     AND SE1.D_E_L_E_T_ <> '*' 
		cQuery += "                   WHERE  SA1.D_E_L_E_T_ <> '*' AND SE1.E1_EMISSAO >= '20180101') A1BK 
		cQuery += "               ON SA171.A1_FILIAL + SA171.A1_COD + SA171.A1_LOJA = 
		cQuery += "                  A1BK.A1_FILIAL + A1BK.A1_COD + A1BK.A1_LOJA 		
		
		IF SELECT("SA1TMP") > 0
			DBSELECTAREA("SA1TMP")
			SA1TMP->( DBCLOSEAREA() )
		ENDIF
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SA1TMP", .F., .T.)},"Consultando Dados SA1010...")


		DBSELECTAREA("SA1")
		DBSETORDER(1)
		
		DBSELECTAREA("SA1TMP")
		SA1TMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SA1TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SA1"+MV_PAR02+" p/ SA1010, Aguarde..."
			IncProc(_cMsg)
			DbSelectArea("SA1")
			DbSetOrder(3)
			If !MsSeek(xFilial("SA1")+SA1TMP->A1_CGC)
					RecLock("SA1",.T.)
					For nA:= 1 to FCount() - 2
						IF SA1TMP->(FIELDPOS(SA1->(FIELDNAME(NA)))) > 0
							If SA1->(FIELDNAME(NA)) == "A1_COD"
						  		SA1->(FieldPut(nA, Getsxenum('SA1','A1_COD') ))
							Else
								SA1->(FieldPut(nA,SA1TMP->(FieldGet(FieldPos( SA1->(FIELDNAME(nA)) )))))
							EndIf	
						ENDIF
			   		Next
					ConfirmSX8()
					SA1->( MsUnLock() )    
			ENDIF
		
			DBSELECTAREA("SA1TMP")
			SA1TMP->( DBSKIP() )
		END
//Fornecedor	
CASE nCombo = 3
		cQuery := " SELECT *  "
		cQuery += " FROM   SA2"+cEmpDe+"0 SA271  "
		cQuery += "       INNER JOIN (SELECT DISTINCT A2_FILIAL,  "
		cQuery += "                                   A2_COD,  "
		cQuery += "                                   A2_LOJA  "
		cQuery += "                   FROM   SA2"+cEmpDe+"0 SA2  "
		cQuery += "                          INNER JOIN SE2"+cEmpDe+"0 SE2  "
		cQuery += "                                  ON SA2.A2_COD = SE2.E2_FORNECE "
		cQuery += "                                     AND SA2.A2_LOJA = SE2.E2_LOJA  "
		cQuery += "                                     AND SE2.D_E_L_E_T_ <> '*'  "
		cQuery += "                   WHERE  SA2.D_E_L_E_T_ <> '*' AND SE2.E2_EMISSAO >= '20180101') A2BK  "
		cQuery += "               ON SA271.A2_FILIAL + SA271.A2_COD + SA271.A2_LOJA =  "
		cQuery += "                  A2BK.A2_FILIAL + A2BK.A2_COD + A2BK.A2_LOJA  "

		IF SELECT("SA2TMP") > 0
			DBSELECTAREA("SA2TMP")
			SA2TMP->( DBCLOSEAREA() )
		ENDIF
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SA2TMP", .F., .T.)},"Consultando Dados SA2010...")


		DBSELECTAREA("SA2")
		DBSETORDER(1)
		
		DBSELECTAREA("SA2TMP")
		SA2TMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SA2TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SA2"+cEmpDe+"0 p/ SA2010, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SA2")
			SA2->(dbSetorder(3))
			
			IF !MsSeek( xFILIAL("SA2")+SA2TMP->A2_CGC ) 
				
				RecLock("SA2",.T.)
				For nA:= 1 to FCount() - 2
					IF SA2TMP->(FIELDPOS(SA2->(FIELDNAME(NA)))) > 0
						If SA2->(FIELDNAME(NA)) == "A2_COD"
					  		SA2->(FieldPut(nA, Getsxenum('SA2','A2_COD') ))
						Else
							SA2->(FieldPut(nA,SA2TMP->(FieldGet(FieldPos( SA2->(FIELDNAME(nA)) )))))
						EndIf	
					ENDIF
				Next
				ConfirmSX8()
				SA2->( MsUnLock() )    
			ENDIF
		
			DBSELECTAREA("SA2TMP")
			SA2TMP->( DBSKIP() )
		END		

 
	
	
//Natureza	
CASE nCombo = 4
		DbUseArea(.T.,"TOPCONN","SED"+cEmpDe+"0","SEDTMP",.F.,.F.) 
		
		cQuery := " SELECT DISTINCT NATZ.* FROM (SELECT  DISTINCT  SED.* "
		cQuery += " FROM  SE1"+cEmpDe+"0  SE1 INNER JOIN SED"+cEmpDe+"0  SED "
		cQuery += "  ON SE1.E1_NATUREZ = SED.ED_CODIGO  AND SED.D_E_L_E_T_ <> '*'   "
		cQuery += " WHERE SE1.E1_EMISSAO >= '20180101'   "
		cQuery += " UNION ALL "
		cQuery += " SELECT  DISTINCT  SED.* "
		cQuery += " FROM  SE2"+cEmpDe+"0  SE2 INNER JOIN SED"+cEmpDe+"0  SED "
		cQuery += "  ON SE2.E2_NATUREZ  = SED.ED_CODIGO  AND SED.D_E_L_E_T_ <> '*'   "
		cQuery += " WHERE SE2.E2_EMISSAO >= '20180101'   "
		cQuery += " AND SE2.D_E_L_E_T_ <> '*'   "
		cQuery += " ) NATZ "

		IF SELECT("SEDTMP") > 0
			DBSELECTAREA("SEDTMP")
			SEDTMP->( DBCLOSEAREA() )
		ENDIF                                                                                                         
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SEDTMP", .F., .T.)},"Consultando Dados SED010...")  
				
		DBSELECTAREA("SEDTMP")
		SEDTMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SEDTMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SED"+cEmpDe+"0 p/ SED"+cEmpDe+"0, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SED") 
			dbSetOrder(1)

			IF !MsSeek( xFILIAL("SED")+SEDTMP->ED_CODIGO )
					RecLock("SED",.T.)
					For nA:= 1 to FCount() - 2
						IF SEDTMP->(FIELDPOS(SED->(FIELDNAME(NA)))) > 0
							SED->(FieldPut(nA,SEDTMP->(FieldGet(FieldPos( SED->(FIELDNAME(nA)) )))))
						ENDIF
					Next
					SED->( MsUnLock() )
			ENDIF
			DBSELECTAREA("SEDTMP")
			SEDTMP->( DBSKIP() )
		END		
//Tes
CASE nCombo = 5
		DbUseArea(.T.,"TOPCONN","SF4"+cEmpDe+"0","SF4TMP",.F.,.F.) 
		
		cQuery := " SELECT * FROM SF4"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"

		IF SELECT("SF4TMP") > 0
			DBSELECTAREA("SF4TMP")
			SF4TMP->( DBCLOSEAREA() )
		ENDIF                                                                                                         
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SF4TMP", .F., .T.)},"Consultando Dados SF4010...")  
				
		DBSELECTAREA("SF4TMP")
		SF4TMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SF4TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SF4"+cEmpDe+"0 p/ SF4"+cEmpDe+"0, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SF4") 
			dbSetOrder(1)

			IF !MsSeek( xFILIAL("SF4")+SF4TMP->F4_CODIGO )
					RecLock("SF4",.T.)
					For nA:= 1 to FCount() - 2
						IF SF4TMP->(FIELDPOS(SF4->(FIELDNAME(NA)))) > 0
							SF4->(FieldPut(nA,SF4TMP->(FieldGet(FieldPos( SF4->(FIELDNAME(nA)) )))))
						
						ENDIF
					Next
					SF4->( MsUnLock() )
			ENDIF
			DBSELECTAREA("SF4TMP")
			SF4TMP->( DBSKIP() )
		END	   
//Lan?mento Padr?		
CASE nCombo = 6
		
//Alcadas
CASE nCombo = 7
		//Solicitantes 
		IF SELECT("SAITMP") > 0
			DBSELECTAREA("SAITMP")
			SAITMP->( DBCLOSEAREA() )
		ENDIF  
		
		DbSelectArea("SAI")
		DbCloseArea()
		ChkFile("SAI")
		
		cQuery := " SELECT * FROM SAI"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"                                                                                                       
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SAITMP", .F., .T.)},"Consultando Dados SAI010...")  
	    DBSELECTAREA("SAITMP")
	 
		IF SELECT("SAITMP") > 0
				
			
			SAITMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SAITMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SAI"+cEmpDe+"0 p/ SAI"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SAI") 
				dbSetOrder(1)
	
				IF !MsSeek( SAITMP->AI_FILIAL+SAITMP->AI_GRUSER )
						RecLock("SAI",.T.)
						For nA:= 1 to FCount() - 2
							IF SAITMP->(FIELDPOS(SAI->(FIELDNAME(NA)))) > 0
								SAI->(FieldPut(nA,SAITMP->(FieldGet(FieldPos( SAI->(FIELDNAME(nA)) )))))
							ENDIF
						Next
						SAI->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SAITMP")
				SAITMP->( DBSKIP() )
			END
		 EndIf
		 
		// Compradores
		IF SELECT("SY1TMP") > 0
			DBSELECTAREA("SY1TMP")
			SY1TMP->( DBCLOSEAREA() )
		ENDIF  
 
		DbSelectArea("SY1")
		DbCloseArea()
		ChkFile("SY1")		

		cQuery := " SELECT * FROM SY1"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"                                                                                                       
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SY1TMP", .F., .T.)},"Consultando Dados SY1010...")  
				
		DBSELECTAREA("SY1TMP")
   		
   		IF SELECT("SY1TMP") > 0
			SY1TMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SY1TMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SY1"+cEmpDe+"0 p/ SY1"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SY1") 
				dbSetOrder(1)
	
				IF !MsSeek( SY1TMP->Y1_FILIAL+SY1TMP->Y1_COD)
						RecLock("SY1",.T.)
						For nA:= 1 to FCount() - 2
							IF SY1TMP->(FIELDPOS(SY1->(FIELDNAME(NA)))) > 0
								SY1->(FieldPut(nA,SY1TMP->(FieldGet(FieldPos( SY1->(FIELDNAME(nA)) )))))
							ENDIF
						Next
						SY1->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SY1TMP")
				SY1TMP->( DBSKIP() )
			END
		 EndIf
		 
		//Grupos de Compradores
		IF SELECT("SAJTMP") > 0
			DBSELECTAREA("SAJTMP")
			SAJTMP->( DBCLOSEAREA() )
		ENDIF  
		
		DbSelectArea("SAJ")
		DbCloseArea()
		ChkFile("SAJ")
				
		cQuery := " SELECT * FROM SAJ"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"                                                                                                       
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SAJTMP", .F., .T.)},"Consultando Dados SAJ010...")  
				
		DBSELECTAREA("SAJTMP")

		IF SELECT("SAJTMP") > 0

			SAJTMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SAJTMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SAJ"+cEmpDe+"0 p/ SAJ"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SAJ") 
				dbSetOrder(1)
	
				IF !MsSeek( SAJTMP->(AJ_FILIAL+AJ_GRCOM+AJ_ITEM))
						RecLock("SAJ",.T.)
						For nA:= 1 to FCount() - 2
							IF SAJTMP->(FIELDPOS(SAJ->(FIELDNAME(NA)))) > 0
								SAJ->(FieldPut(nA,SAJTMP->(FieldGet(FieldPos( SAJ->(FIELDNAME(nA)) )))))
							ENDIF
						Next
						SAJ->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SAJTMP")
				SAJTMP->( DBSKIP() )
			END
		EndIf
		
		 //Grupos de Aprovacao
		 IF SELECT("SALTMP") > 0
			DBSELECTAREA("SALTMP")
			SALTMP->( DBCLOSEAREA() )
		ENDIF  
			
		DbSelectArea("SAL")
		DbCloseArea()
		ChkFile("SAL")
		
		cQuery := " SELECT * FROM SAL"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"                                                                                                       

		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SALTMP", .F., .T.)},"Consultando Dados SAL010...")  
					
		DBSELECTAREA("SALTMP")
	    IF SELECT("SALTMP") > 0	 
			SALTMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SALTMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SAL"+cEmpDe+"0 p/ SAL"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SAL") 
				dbSetOrder(1)
	
				IF !MsSeek( SALTMP->(AL_FILIAL+AL_COD+AL_ITEM))
						RecLock("SAL",.T.)
						For nA:= 1 to FCount() - 2
							IF SALTMP->(FIELDPOS(SAL->(FIELDNAME(NA)))) > 0
								SAL->(FieldPut(nA,SALTMP->(FieldGet(FieldPos( SAL->(FIELDNAME(nA)) )))))
							ENDIF
						Next
						SAL->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SALTMP")
				SALTMP->( DBSKIP() )
			END
         EndIf
         
		// Aprovadores
		IF SELECT("SAKTMP") > 0
			DBSELECTAREA("SAKTMP")
			SAKTMP->( DBCLOSEAREA() )
		ENDIF  

		DbSelectArea("SAK")
		DbCloseArea()
		ChkFile("SAK")		

		cQuery := " SELECT * FROM SAK"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"                                                                                                       
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SAKTMP", .F., .T.)},"Consultando Dados SAK010...")  
				
		DBSELECTAREA("SAKTMP")
	    IF SELECT("SAKTMP") > 0
			SAKTMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SAKTMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SAK"+cEmpDe+"0 p/ SAK"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SAK") 
				dbSetOrder(1)
	
				IF !MsSeek( SAKTMP->AK_FILIAL+SAKTMP->AK_COD)
						RecLock("SAK",.T.)
						For nA:= 1 to FCount() - 2
							IF SAKTMP->(FIELDPOS(SAK->(FIELDNAME(NA)))) > 0
								SAK->(FieldPut(nA,SAKTMP->(FieldGet(FieldPos( SAK->(FIELDNAME(nA)) )))))
							ENDIF
						Next
						SAK->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SAKTMP")
				SAKTMP->( DBSKIP() )
			END
		EndIf
		//Perfil de Aprovadores
		IF SELECT("DHLTMP") > 0
			DBSELECTAREA("DHLTMP")
			DHLTMP->( DBCLOSEAREA() )
		ENDIF  
		
		DbSelectArea("DHL")
		DbCloseArea()
		ChkFile("DHL")
				
		cQuery := " SELECT * FROM DHL"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"                                                                                                       
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"DHLTMP", .F., .T.)},"Consultando Dados DHL010...")  
				
		DBSELECTAREA("DHLTMP")
		IF SELECT("DHLTMP") > 0
		
			DHLTMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE DHLTMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de DHL"+cEmpDe+"0 p/ DHL"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("DHL") 
				dbSetOrder(1)
	
				IF !MsSeek( DHLTMP->DHL_FILIAL+DHLTMP->DHL_COD)
						RecLock("DHL",.T.)
						For nA:= 1 to FCount() - 2
							IF DHLTMP->(FIELDPOS(DHL->(FIELDNAME(NA)))) > 0
								DHL->(FieldPut(nA,DHLTMP->(FieldGet(FieldPos( DHL->(FIELDNAME(nA)) )))))
							ENDIF
						Next
						DHL->( MsUnLock() )
				ENDIF
				DBSELECTAREA("DHLTMP")
				DHLTMP->( DBSKIP() )
			END	
		EndIf	
//Moedas		
CASE nCombo = 8
		IF SELECT("SM2TMP") > 0
			DBSELECTAREA("SM2TMP")
			SM2TMP->( DBCLOSEAREA() )
		ENDIF  
		
		cQuery := " SELECT * FROM SM2"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"                                                                                                       
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SM2TMP", .F., .T.)},"Consultando Dados SM2010...")  
				
		DBSELECTAREA("SM2TMP")
		SM2TMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SM2TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SM2"+cEmpDe+"0 p/ SM2"+cEmpDe+"0, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SM2") 
			dbSetOrder(1)

			IF !MsSeek( xFILIAL("SM2")+SM2TMP->M2_Data )
					RecLock("SM2",.T.)
					For nA:= 1 to FCount() - 2
						IF SM2TMP->(FIELDPOS(SM2->(FIELDNAME(NA)))) > 0
							SM2->(FieldPut(nA,SM2TMP->(FieldGet(FieldPos( SM2->(FIELDNAME(nA)) )))))
						ENDIF
					Next
					SM2->( MsUnLock() )
			ENDIF
			DBSELECTAREA("SM2TMP")
			SM2TMP->( DBSKIP() )
		END
		
//Bancos		
CASE nCombo = 9
        
		// Bancos
		DbUseArea(.T.,"TOPCONN","SA6"+cEmpDe+"0","SA6TMP",.F.,.F.) 
		
		cQuery := " SELECT * FROM SA6"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"

		IF SELECT("SA6TMP") > 0
			DBSELECTAREA("SA6TMP")
			SA6TMP->( DBCLOSEAREA() )
		ENDIF                                                                                                         
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SA6TMP", .F., .T.)},"Consultando Dados SA6010...")  
				
		DBSELECTAREA("SA6TMP")
		IF SELECT("SA6TMP") > 0
			SA6TMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SA6TMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SA6"+cEmpDe+"0 p/ SA6"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SA6") 
				dbSetOrder(1)
	
				IF !MsSeek( SA6TMP->(A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON) )
						RecLock("SA6",.T.)
						For nA:= 1 to FCount() - 2
							IF SA6TMP->(FIELDPOS(SA6->(FIELDNAME(NA)))) > 0
								SA6->(FieldPut(nA,SA6TMP->(FieldGet(FieldPos( SA6->(FIELDNAME(nA)) )))))
							
							ENDIF
						Next
						SA6->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SA6TMP")
				SA6TMP->( DBSKIP() )
			END			
        EndIf 
        
        //Parametros Banco
        DbUseArea(.T.,"TOPCONN","SEE"+cEmpDe+"0","SEETMP",.F.,.F.) 
		
		cQuery := " SELECT * FROM SEE"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"

		IF SELECT("SEETMP") > 0
			DBSELECTAREA("SEETMP")
			SEETMP->( DBCLOSEAREA() )
		ENDIF                                                                                                         
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SEETMP", .F., .T.)},"Consultando Dados SEE010...")  
				
		DBSELECTAREA("SEETMP")
		IF SELECT("SEETMP") > 0
			SEETMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SEETMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SEE"+cEmpDe+"0 p/ SEE"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SEE") 
				dbSetOrder(1)
	
				IF !MsSeek( SEETMP->(EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA) )
						RecLock("SEE",.T.)
						For nA:= 1 to FCount() - 2
							IF SEETMP->(FIELDPOS(SEE->(FIELDNAME(NA)))) > 0
								SEE->(FieldPut(nA,SEETMP->(FieldGet(FieldPos( SEE->(FIELDNAME(nA)) )))))
							
							ENDIF
						Next
						SEE->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SEETMP")
				SEETMP->( DBSKIP() )
			END			
        EndIf    
        
        // Ocorencias 
        DbUseArea(.T.,"TOPCONN","SEB"+cEmpDe+"0","SEBTMP",.F.,.F.) 
		
		cQuery := " SELECT * FROM SEB"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"

		IF SELECT("SEBTMP") > 0
			DBSELECTAREA("SEBTMP")
			SEBTMP->( DBCLOSEAREA() )
		ENDIF                                                                                                         
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SEBTMP", .F., .T.)},"Consultando Dados SEB010...")  
				
		DBSELECTAREA("SEBTMP")
		IF SELECT("SEBTMP") > 0
			SEBTMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SEBTMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SEB"+cEmpDe+"0 p/ SEB"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)
				dbSelectArea("SEB") 
				dbSetOrder(1)
	
				IF !MsSeek( SEBTMP->(EB_FILIAL+EB_BANCO+EB_REFBAN+EB_TIPO+EB_MOTBAN) )
						RecLock("SEB",.T.)
						For nA:= 1 to FCount() - 2
							IF SEBTMP->(FIELDPOS(SEB->(FIELDNAME(NA)))) > 0
								SEB->(FieldPut(nA,SEBTMP->(FieldGet(FieldPos( SEB->(FIELDNAME(nA)) )))))
							
							ENDIF
						Next
						SEB->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SEBTMP")
				SEBTMP->( DBSKIP() )
			END			
        EndIf

//Contas a pagar		
CASE nCombo = 10 
       If 	cEmpDe== '71'  
          cSa2:= 'SA2710'
       ElseIf cEmpDe== '73'  
          cSa2:= 'SA2710'
       ElseIf cEmpDe== '12'
       	cSa2:= 'SA2120'
       ElseIf cEmpDe== '10'                
       	cSa2:= 'SA2710'
       ElseIf cEmpDe== '30'       
       	cSa2:= 'SA2710'
       ElseIf cEmpDe== '40' 
       	cSa2:= 'SA2710'
       ElseIf cEmpDe== '20'
       	cSa2:= 'SA2710'
       ElseIf cEmpDe== '70'       	
       	cSa2:= 'SA2710'  
       ElseIf cEmpDe== '21'       	
       	cSa2:= 'SA2210'     
       EndIf	  

///query de consulta SE2 e SA2 DA EMPRESA ANTIGA, PARA MONTAGEM DOS DADOS
		
		cQuery := " SELECT A2.A2_CGC,A2.A2_NOME  , E2 .* "
		cQuery += " FROM   SE2"+cEmpDe+"0 E2 "
		cQuery += "        INNER JOIN "+cSa2+" A2 "
		cQuery += " 		               ON A2.A2_COD = E2.E2_FORNECE "
		cQuery += " 		                  AND A2.A2_LOJA = E2.E2_LOJA "
		cQuery += " 		                  AND A2.D_E_L_E_T_ = ' ' "
		cQuery += " 		WHERE  E2.D_E_L_E_T_ = '  '  and E2.E2_SALDO > 0 AND E2_EMISSAO > '20170101' "
		cQuery += " 		ORDER BY A2.A2_CGC "

		IF SELECT("SE2TMP") > 0
			DBSELECTAREA("SE2TMP")
			SE2TMP->( DBCLOSEAREA() )
		ENDIF                                                                                                         
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SE2TMP", .F., .T.)},"Consultando Dados SE2010...")  
		dbSelectArea("SA2") 
						
		DBSELECTAREA("SE2TMP")
		IF SELECT("SE2TMP") > 0
			SE2TMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SE2TMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SE2"+cEmpDe+"0 p/ SE2"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)

				dbSelectArea("SE2") 
				dbSetOrder(1)
	   			cCodFor := "XXXXXX"
				cLojFor := "XX"
				cE2Codf := SE2TMP->(E2_FORNECE)				
				If Empty(SE2TMP->A2_CGC)
				     SA2->(dbSetOrder(2))
				     If SA2->(dbSeek(xFilial("SA2")+SE2TMP->(A2_NOME+E2_LOJA) ))
				          cCodFor := SA2->A2_COD
				          cLojFor := SA2->A2_LOJA
				     Else
					      cCodFor := "XXXXXX"
				          cLojFor := "XX"
				     EndIf
				Else
		
		//CONSULTA SA2 ANTIGA///
	
					cQry := "SELECT *            				"
					cQry += "FROM   "+cSa2+" SA2   				"
					cQry += "WHERE A2_COD="+cE2Codf+" 		"
					cQry += "AND D_E_L_E_T_ = '  ' "				
		
		
					IF SELECT("SA2TMP") > 0
						DBSELECTAREA("SA2TMP")
						SA2TMP->( DBCLOSEAREA() )
					ENDIF			
						
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"SA2TMP", .F., .T.)
					
					DBSELECTAREA("SA2TMP")//VERIFICAR SA2 POSICIONADA PARA A GRAVAÇÃO DOS DADOS ANTIGOS
					IF SELECT("SA2TMP") > 0
						SA2TMP->( DBGOTOP() )
						      	SA2->(dbSetOrder(3))
						    If !SA2->(DBSeek(xFilial("SA2")+SA2TMP->A2_CGC ))
									//!MsSeek(xFilial("SA2")+SA2TMP->A1_CGC)
									RecLock("SA2",.T.)///GRAVAÇÃO DO FORNECEDOR NA EMPRESA NOVA 
									SA2TMP->( DBGOTOP() )
									For nA:= 1 to FCount() - 2
										IF SA2TMP->(FIELDPOS(SA2->(FIELDNAME(NA)))) > 0
											If SA2->(FIELDNAME(NA)) == "A2_COD"
										  		SA2->(FieldPut(nA, Getsxenum('SA2','A2_COD') ))
										  		
											Else
												SA2->(FieldPut(nA,SA2TMP->(FieldGet(FieldPos( SA2->(FIELDNAME(nA)) )))))
											EndIf	
										ENDIF
							   		Next
									ConfirmSX8()
									SA2->( MsUnLock() )    
							ENDIF
				  EndIf
					DBSELECTAREA("SA2TMP")
					SA2TMP->( DBGOTOP() )
			      	cCodFor := SA2TMP->A2_COD
					cLojFor := SA2TMP->A2_LOJA	
				EndIf
	//				!SE1->(DBSeek(SE1TMP->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+cCodFor+cLojFor) )) 
				IF !SE2->(DBSeek(SE2TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+cCodFor+cLojFor) )) //
						RecLock("SE2",.T.)//GRAVACÃO TITULOS EMPRESA NOVA.
						For nA:= 1 to FCount() - 2
						
							If SE2->(FIELDNAME(NA)) == "E2_FORNECE"
						  		SE2->(FieldPut(nA, cCodFor )) 
						    ElseIf SE2->(FIELDNAME(NA)) == "E2_LOJA" 
							    SE2->(FieldPut(nA, cLojFor )) 
							ElseIf !(FieldName(nA)$("A2_CGC*A2_NOME"))
								SE2->(FieldPut(nA,SE2TMP->(FieldGet(FieldPos( SE2->(FIELDNAME(nA)) )))))
							EndIf
						
						Next
						SE2->( MsUnLock() )
				ENDIF
				DBSELECTAREA("SE2TMP")
				SE2TMP->( DBSKIP() )
			END			
        EndIf   
        


 

       
        
	        
        
         
//Contas a receber		
CASE nCombo = 11 //CONSULTA SE1 ANTIGA
       If 	cEmpDe== '73'  
          cSa1:= 'SA1100'
       ElseIf cEmpDe== '12'       
       	cSa1:= 'SA1300'
       ElseIf cEmpDe== '30'       
       	cSa1:= 'SA1300'
       ElseIf cEmpDe== '40' 
       	cSa1:= 'SA1400'
       ElseIf cEmpDe== '20'
       	cSa1:= 'SA1200'
       ElseIf cEmpDe== '70'       	
       	cSa1:= 'SA1100'  
       ElseIf cEmpDe== '21'       	
       	cSa1:= 'SA1210'     
       EndIf	    	        

		//cQuery := " SELECT * FROM SE2"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' ' AND E2_SALDO>0"
		
		cQuery := " SELECT A1.A1_CGC,A1.A1_NOME  , E1 .* "
		cQuery += " FROM   SE1"+cEmpDe+"0 E1 "
		cQuery += "        INNER JOIN "+cSa1+" A1 "
		cQuery += " 		 ON A1.A1_COD = E1.E1_CLIENTE "
		cQuery += " 		  AND A1.A1_LOJA = E1.E1_LOJA "
		cQuery += " 		 AND A1.D_E_L_E_T_ = ' ' "
		cQuery += " 		WHERE  E1.D_E_L_E_T_ = '  '  and E1.E1_SALDO > 0 AND E1_EMISSAO > '20170101' "
		//cQuery += "      AND E1.E1_NUM='001017' "	
		//cQuery += 		"AND E1.E1_PARCELA='002'	"
		//cQuery +=	"		AND E1.E1_CLIENTE='002077'"	
		cQuery += " 		ORDER BY A1.A1_CGC "

		IF SELECT("SE1TMP") > 0
			DBSELECTAREA("SE1TMP")
			SE1TMP->( DBCLOSEAREA() )
		ENDIF                                                                                                         
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SE1TMP", .F., .T.)},"Consultando Dados SE1010...")  
		dbSelectArea("SA1") 
						
		DBSELECTAREA("SE1TMP")
		IF SELECT("SE1TMP") > 0
			SE1TMP->( DBGOTOP() )
			_nLin         := 0  
			WHILE SE1TMP->( !EOF() )
				_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SE1"+cEmpDe+"0 p/ SE1"+cEmpDe+"0, Aguarde..."
				IncProc(_cMsg)

				dbSelectArea("SE1") 
				dbSetOrder(1)
	   			cCodFor := "XXXXXX"
				cLojFor := "XX"
				cE1Codf := SE1TMP->(E1_CLIENTE)
				If Empty(SE1TMP->A1_CGC)
				     SA1->(dbSetOrder(2))
				     If SA1->(dbSeek(xFilial("SA1")+SE1TMP->(A1_NOME+E1_LOJA) ))
				          cCodFor := SA1->A1_COD
				          cLojFor := SA1->A1_LOJA
				     Else
					      cCodFor := "XXXXXX"
				          cLojFor := "XX"
				     EndIf
				Else
		//CONSULTA SA1 ANTIGA///
	
					cQry := "SELECT *            				"
					cQry += "FROM   "+cSa1+" SA1   				"
					cQry += "WHERE A1_COD="+cE1Codf+" 		"
					cQry += "AND D_E_L_E_T_ = '  ' "				
		
		
					IF SELECT("SA1TMP") > 0
						DBSELECTAREA("SA1TMP")
						SA1TMP->( DBCLOSEAREA() )
					ENDIF			
						
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry),"SA1TMP", .F., .T.)
					
					DBSELECTAREA("SA1TMP")
					IF SELECT("SA1TMP") > 0
						SA1TMP->( DBGOTOP() )
						      	SA1->(dbSetOrder(3))
						    If !SA1->(DBSeek(xFilial("SA1")+SA1TMP->A1_CGC ))
									//!MsSeek(xFilial("SA1")+SA1TMP->A1_CGC)
									RecLock("SA1",.T.)
									SA1TMP->( DBGOTOP() )
									For nA:= 1 to FCount() - 2
										IF SA1TMP->(FIELDPOS(SA1->(FIELDNAME(NA)))) > 0
											If SA1->(FIELDNAME(NA)) == "A1_COD"
										  		SA1->(FieldPut(nA, Getsxenum('SA1','A1_COD') ))
										  		
											Else
												SA1->(FieldPut(nA,SA1TMP->(FieldGet(FieldPos( SA1->(FIELDNAME(nA)) )))))
											EndIf	
										ENDIF
							   		Next
									ConfirmSX8()
									SA1->( MsUnLock() )    
							ENDIF
				  EndIf
				/*     SA1->(dbSetOrder(3))
				     If SA1->(DBSeek(xFilial("SA1")+ SE1TMP->(A1_CGC) ))
					     cCodFor := SA1->A1_COD
				         cLojFor := SA1->A1_LOJA
				     Else
					     cCodFor := "XXXXXX"
				         cLojFor := "XX"		     
				     EndIf		
				EndIf*/
			      	cCodFor := SA1TMP->A1_COD
					cLojFor := SA1TMP->A1_LOJA
					IF !SE1->(DBSeek(SE1TMP->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+cCodFor+cLojFor) )) 
							RecLock("SE1",.T.)
							For nA:= 1 to FCount() - 2
							
								If SE1->(FIELDNAME(NA)) == "E1_CLIENTE"
							  		SE1->(FieldPut(nA, cCodFor )) 
							    ElseIf SE1->(FIELDNAME(NA)) == "E1_LOJA" 
								    SE1->(FieldPut(nA, cLojFor )) 
								ElseIf !(FieldName(nA)$("A1_CGC*A1_NOME"))
									SE1->(FieldPut(nA,SE1TMP->(FieldGet(FieldPos( SE1->(FIELDNAME(nA)) )))))
								EndIf
							
							Next
							SE1->( MsUnLock() )
					ENDIF
				 EndIf
				DBSELECTAREA("SE1TMP")
				SE1TMP->( DBSKIP() )
			END			
        EndIf   
//Ativo		
CASE nCombo = 12
   cQuery := " SELECT * FROM SN1"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"
		
		IF SELECT("SN1TMP") > 0
			DBSELECTAREA("SN1TMP")
			SN1TMP->( DBCLOSEAREA() )
		ENDIF
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SN1TMP", .F., .T.)},"Consultando Dados SN1010...")
		
		//Barra processamento
		nContaRegs := 0
		Count To nContaRegs
		ProcRegua(nContaRegs)
		
		DBSELECTAREA("SN1")
		DBSETORDER(1)
		
		DBSELECTAREA("SN1TMP")
		SN1TMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SN1TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SN1"+cEmpDe+"0, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SN1")
			SN1->(dbSetOrder(1))
			IF !MsSeek( SN1TMP->(N1_FILIAL+N1_CBASE+N1_ITEM))
					RecLock("SN1",.T.)
					For nA:= 1 to FCount() - 2
						IF SN1TMP->(FIELDPOS(SN1->(FIELDNAME(NA)))) > 0
							SN1->(FieldPut(nA,SN1TMP->(FieldGet(FieldPos( SN1->(FIELDNAME(nA)) )))))
						ENDIF
					Next
					SN1->( MsUnLock() )    
			ENDIF

			DBSELECTAREA("SN1TMP")
			SN1TMP->( DBSKIP() )
		END        
		
		   cQuery := " SELECT * FROM SN3"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"
		
		IF SELECT("SN3TMP") > 0
			DBSELECTAREA("SN3TMP")
			SN3TMP->( DBCLOSEAREA() )
		ENDIF
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SN3TMP", .F., .T.)},"Consultando Dados SN3010...")
		
		//Barra processamento
		nContaRegs := 0
		Count To nContaRegs
		ProcRegua(nContaRegs)
		
		DBSELECTAREA("SN3")
		DBSETORDER(1)
		
		DBSELECTAREA("SN3TMP")
		SN3TMP->( DBGOTOP() )
		_nLin         := 0  
		WHILE SN3TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SN3"+cEmpDe+"0, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SN3")
			SN3->(dbSetOrder(1))
			IF !MsSeek( SN3TMP->(N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ) )
					RecLock("SN3",.T.)
					For nA:= 1 to FCount() - 2
						IF SN3TMP->(FIELDPOS(SN3->(FIELDNAME(NA)))) > 0
							SN3->(FieldPut(nA,SN3TMP->(FieldGet(FieldPos( SN3->(FIELDNAME(nA)) )))))
						ENDIF
					Next
					SN3->( MsUnLock() )    
			ENDIF

			DBSELECTAREA("SN3TMP")
			SN3TMP->( DBSKIP() )
		END        
		
		
		   cQuery := " SELECT * FROM SN4"+cEmpDe+"0 WHERE D_E_L_E_T_ = ' '"
		
		IF SELECT("SN4TMP") > 0
			DBSELECTAREA("SN4TMP")
			SN4TMP->( DBCLOSEAREA() )
		ENDIF
		
		MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SN4TMP", .F., .T.)},"Consultando Dados SN4010...")
		
		//Barra processamento
		nContaRegs := 0
		Count To nContaRegs
		ProcRegua(nContaRegs)
		
		DBSELECTAREA("SN4")
		DBSETORDER(1)
		
		DBSELECTAREA("SN4TMP")
		SN4TMP->( DBGOTOP() )
		_nLin         := 0  
		
		WHILE SN4TMP->( !EOF() )
			_cMsg := "Gerando reg. "+LTRIM(RTRIM(STR(_nLin++)))+", de SN4"+cEmpDe+"0, Aguarde..."
			IncProc(_cMsg)
			dbSelectArea("SN4")
			SN3->(dbSetOrder(1))
			IF !MsSeek( SN4TMP->(N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO+N4_DATA+N4_OCORR+N4_SEQ) )
					RecLock("SN4",.T.)
					For nA:= 1 to FCount() - 2
						IF SN4TMP->(FIELDPOS(SN4->(FIELDNAME(NA)))) > 0
							SN4->(FieldPut(nA,SN4TMP->(FieldGet(FieldPos( SN4->(FIELDNAME(nA)) )))))
						ENDIF
					Next
					SN4->( MsUnLock() )    
			ENDIF

			DBSELECTAREA("SN4TMP")
			SN4TMP->( DBSKIP() )
		END        
                		
OTHERWISE
	MsAlert("Valida")
ENDCASE
Return()