#INCLUDE 'RWMAKE.CH'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA103OK �Autor  �Felipi Marques      � Data � 26/03/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado na Valida��o A103LinOk NF/e     ���
���          �  			                                              ���
�������������������������������������������������������������������������͹��
���Uso       � DIMEP                                                      ���
�������������������������������������������������������������������������ͼ��
�� Altera��o: Fabio Costa - Inclus�o da obrigatoriedade quando for        ��
�� devolucao informar o motivo de cancelamento.                           ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                 

User Function MTA103OK()

Local _cAlias := Alias()
Local _lRet   := PARAMIXB[1]

Local _cRefDev  := ""
Local _dDtIni   := ""
Local _cCC      := ""
Local _cTipCan  := ""
Local _cMotc    := ""
                     
_nLinGetD := n

_nPosRefd := aScan(aHeader, { |x| Alltrim(x[2]) == "D1_REFDEV" })
//_cRefDev := aCols[_nLinGetD, _nPosRefd ]  
   
_nPosTpCa := aScan(aHeader, { |x| Alltrim(x[2]) == "D1_TIPREF" })  
                
_nPosDtIn := aScan(aHeader, { |x| Alltrim(x[2]) == "D1_DTIND" })
//_dDtIni := aCols[_nLinGetD, _nPosDtIn ]

_nPosCC   := aScan(aHeader, { |x| Alltrim(x[2]) == "D1_CC" })
//_cCC    := aCols[_nLinGetD, _nPosCC ]                    

_nPosMotc := aScan(aHeader, { |x| Alltrim(x[2]) == "D1_MOTC" })
//_cMotc  := aCols[_nLinGetD, _nPosMotc ]


If _nPosRefd <> 0
	_cRefDev  := aCols[_nLinGetD, _nPosRefd ]
Endif	

If _nPosTpCa <> 0 
	_cTipCan := aCols[_nLinGetD, _nPosTpCa ]
Endif  

If _nPosDtIn <> 0 
	_dDtIni   := aCols[_nLinGetD, _nPosDtIn ]
Endif	 

If _nPosCC <> 0
	_cCC      := aCols[_nLinGetD, _nPosCC ]
Endif	

If _nPosMotc <> 0
   _cMotc   := aCols[_nLinGetD, _nPosMotc ]
Endif 

//Somente em Casos de Devolu��o( Se for realizado pelo bot�o RETORNAR n�o pode ser validado a condi��o � a vari�vel 'cCliente' que encontra-se somente na fun��o 
// deste bot�o no fonte MATA103  

if cTipo == 'D' .and. cempant == '01' .and. ( type('cCliente') == 'U')
	if Empty(_cRefDev)    
		MsgStop ( "Esta Nf/e � de devolu��o, � obrigat�rio o preenchimento do campo  'Refat.Devol?' !" ,"Atencao!" )
		_lRet:=.f. 
	Endif  
	
	if  _cRefDev == '1' .and. empty(_cTipCan)
		MsgStop ( "Favor informar o tipo de cancelamento efetuado no campo: 'Tipo Cancel' !" ,"Atencao!" )
		_lRet:=.f. 
	Endif 
	
	if  _cRefDev <> '1' .and. !empty(_cTipCan)
		MsgStop ( "Foi informado que n�o se trata de refaturamento, para este tipo deixar sem preenchimento o campo: 'Tipo Cancel' !" ,"Atencao!" )
		_lRet:=.f. 
	Endif   
	
	if Empty(_dDtIni) 
		MsgStop ( "Esta Nf/e � de devolu��o, � obrigat�rio o preenchimento do campo 'Dt.Ini.Devol.'! " ,"Atencao!" )
		_lRet:=.f. 
	Endif 
	
	if Empty(_cCC)   
		MsgStop ( "Esta Nf/e � de devolu��o, � obrigat�rio o preenchimento do Centro de Custo ! " ,"Atencao!" )
		_lRet:=.f. 
	Endif  
	
    If Empty(_cMotc)   
		MsgStop ( "Esta Nf/e � de devolu��o, � obrigat�rio o preenchimento do Motivo de Cancelamento! " ,"Atencao!" )
		_lRet:=.f. 
	Endif  
Endif     

DbSelectArea(_cAlias)

Return(_lRet)