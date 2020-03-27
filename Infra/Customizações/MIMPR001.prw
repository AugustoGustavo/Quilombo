/*/{Protheus.doc} MIMPR001
Description                                                     

@param xParam Parameter Description
@return xRet Return Description
@author Felipi Marques
@since 14/11/2018
/*/
//--------------------------------------------------------------  

User Function MIMPR001()
Local cSay1
Local oButton1
Local oButton2
Local oComboBo1
Local nComboBo1 := 1
Local oSay1
Local oSay2
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 200, 300 COLORS 0, 16777215 PIXEL

    @ 016, 017 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"CLIENTES","PRODUTOS","ATIVO FIXO","CONTAS A PAGAR","CONTAS A RECEBER"} SIZE 109, 010 OF oDlg COLORS 0, 16777215 PIXEL
    //@ 005, 018 SAY cSay1 PROMPT "IMPORTAÇÃO DE CADASTROS" SIZE 107, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 080, 017 BUTTON oButton1 PROMPT "IMPORTAR" SIZE 037, 012 OF oDlg PIXEL
    @ 081, 086 BUTTON oButton2 PROMPT "CANCELAR" SIZE 037, 012 OF oDlg PIXEL
    @ 031, 017 SAY oSay1 PROMPT "DE" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 017 SAY oSay2 PROMPT "PARA" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return