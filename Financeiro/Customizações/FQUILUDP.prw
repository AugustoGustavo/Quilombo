#include "protheus.ch"
#include "topconn.ch"  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FQUILUDP  �Autor  �Felipi Marques      � Data �  30/12/15  ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao para atualizar PC j� liberado.                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Quilombo                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function FQUILUDP()

If SimNao("Confirma atualiza��o das informo��es da aprova��o de todos os Pedidos de Compra.?") == "S"
	Processa({ |lEnd| fFilDados(@lEnd),OemToAnsi("Filtrando pedidos, aguarde...")}, OemToAnsi("Aguarde..."))
EndIf 

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FQUILUDP  �Autor  �Felipi Marques      � Data �  30/12/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fFilDados(lEnd)

Local cDocto   := ""
Local cTipoDoc := "PC"
Local nCont    := 0
Local dDataLib := CTOD("  /  /  ")
Local cQuery
Local nContaRegs := 0



cQuery := CRLF+" SELECT R_E_C_N_O_ AS C7RECNO                                  "
cQuery += CRLF+" FROM   "+RetSqlName("SC7")+"                                  "
cQuery += CRLF+" WHERE  C7_CONAPRO = 'L'                                       "
cQuery += CRLF+"        AND C7_XNOMEAP = '"+Space(Len(SC7->C7_XNOMEAP))+"'     "
cQuery += CRLF+"        AND D_E_L_E_T_ <> '*'                                  "

//Fecha Alias se estiver em uso
If Select("SQL") > 0
	SQL->(dbCloseArea("SQL"))
Endif

//Cria Alias
TCQuery cQuery ALIAS "SQL" NEW

//Barra processamento
DbSelectArea("SQL")
SQL->(DbGoTop())
Count To nContaRegs
ProcRegua(nContaRegs)
SQL->(DbGoTop())


//Itens
SQL->(DbGoTop())
//Adicona toda tabela no arquivo
While SQL->(!Eof())
	IncProc("Aguarde: Rotina atualiar� informo��es da prova��o de todos os Pedidos de Compra.")
	//�������������������������������������������������������������������������������������Ŀ
	//� Zera variaveis                                                                      �
	//���������������������������������������������������������������������������������������
	dDataLib := ""
    cNomeUsr := ""
    cCRUSER  := ""

	dbSelectArea( "SC7" )
	dbSetOrder(1)
	dbGoTo( SQL->C7RECNO )
    
 	//�������������������������������������������������������������������������������������Ŀ
	//� Busca o pedido de compra                                                            �
	//���������������������������������������������������������������������������������������
	dbSelectArea("SCR")
	dbSetOrder(1)
	If dbSeek(SC7->C7_FILIAL+"PC"+SC7->C7_NUM)
	   Do While SCR->(!EOF()) .And. Alltrim(SC7->C7_NUM) == Alltrim(SCR->CR_NUM)
	      If SCR->CR_VALLIB > 0.00
	         cCRUSER  := AllTrim(SCR->CR_USERLIB)
	         dDataLib := SCR->CR_DATALIB
	         Exit
	       Endif
	       SCR->(dbSkip())
	    Enddo
	Endif

	If Len(AllTrim(cCRUSER)) > 0
		//�������������������������������������������������������������������������������������Ŀ
		//� Busca o nome do aprovador                                                           �
   		//���������������������������������������������������������������������������������������	
		dbSelectArea("SAK")
		dbSetOrder(2)
		If SAK->( dbSeek(SC7->C7_FILIAL+cCRUSER ))
           cNomeUsr := AllTrim(SAK->AK_NOME)
  		Endif
     Endif
       
	//�������������������������������������������������������������������������������������Ŀ
	//� Atualiza Pedido de Compra                                                           �
	//���������������������������������������������������������������������������������������
	dbSelectArea( "SC7" )
	dbSetOrder(1)
	dbGoTo( SQL->C7RECNO )
	
	RecLock( "SC7", .F. )
	IF Len(AllTrim(cNomeUsr)) <> 0
		SC7->C7_XNOMEAP := cNomeUsr
		SC7->C7_XDTAPRO := dDataLib
	Endif
	MSUnlock()
	
	//Proximo registro
    SQL->(DbSkip())
End  	

//Fecha Alias
SQL->(dbCloseArea("SQL"))

Return