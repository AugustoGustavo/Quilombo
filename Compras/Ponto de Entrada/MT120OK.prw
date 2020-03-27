#include 'protheus.ch'
#include 'parmtype.ch'

User Function  MT120OK()

Local lValido := .T.

If nChoice = 1
	MsgAlert("Por favor, informar o Tipo de Pedido no cabeçalho","Tipo Pedido")
	lValido := .F.
EndIf

Return(lValido) 
