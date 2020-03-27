#INCLUDE 'RWMAKE.CH'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MTA103OK บAutor  ณFelipi Marques      บ Data ณ 26/03/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada executado na Valida็ใo A103LinOk NF/e     บฑฑ
ฑฑบ          ณ  			                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DIMEP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑ Altera็ใo: Fabio Costa - Inclusใo da obrigatoriedade quando for        ฑฑ
ฑฑ devolucao informar o motivo de cancelamento.                           ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//Somente em Casos de Devolu็ใo( Se for realizado pelo botใo RETORNAR nใo pode ser validado a condi็ใo ้ a variแvel 'cCliente' que encontra-se somente na fun็ใo 
// deste botใo no fonte MATA103  

if cTipo == 'D' .and. cempant == '01' .and. ( type('cCliente') == 'U')
	if Empty(_cRefDev)    
		MsgStop ( "Esta Nf/e ้ de devolu็ใo, ้ obrigat๓rio o preenchimento do campo  'Refat.Devol?' !" ,"Atencao!" )
		_lRet:=.f. 
	Endif  
	
	if  _cRefDev == '1' .and. empty(_cTipCan)
		MsgStop ( "Favor informar o tipo de cancelamento efetuado no campo: 'Tipo Cancel' !" ,"Atencao!" )
		_lRet:=.f. 
	Endif 
	
	if  _cRefDev <> '1' .and. !empty(_cTipCan)
		MsgStop ( "Foi informado que nใo se trata de refaturamento, para este tipo deixar sem preenchimento o campo: 'Tipo Cancel' !" ,"Atencao!" )
		_lRet:=.f. 
	Endif   
	
	if Empty(_dDtIni) 
		MsgStop ( "Esta Nf/e ้ de devolu็ใo, ้ obrigat๓rio o preenchimento do campo 'Dt.Ini.Devol.'! " ,"Atencao!" )
		_lRet:=.f. 
	Endif 
	
	if Empty(_cCC)   
		MsgStop ( "Esta Nf/e ้ de devolu็ใo, ้ obrigat๓rio o preenchimento do Centro de Custo ! " ,"Atencao!" )
		_lRet:=.f. 
	Endif  
	
    If Empty(_cMotc)   
		MsgStop ( "Esta Nf/e ้ de devolu็ใo, ้ obrigat๓rio o preenchimento do Motivo de Cancelamento! " ,"Atencao!" )
		_lRet:=.f. 
	Endif  
Endif     

DbSelectArea(_cAlias)

Return(_lRet)