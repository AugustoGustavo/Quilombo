User Function LP510QE()

Local nlValor := 0 
Local _aArea:=GetArea()

If SE2->E2_MULTNAT<>"2"

//	POSICIONE("SE2",1,XFILIAL("SEV")+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA,SEV->EV_VALOR )
  
	POSICIONE("SEV",1,XFILIAL("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,"EV_VALOR" )
	nlValor := SEV->EV_VALOR

Else
	
	nlValor := SE2->(E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_COFINS+E2_PIS+E2_CSLL)
	
Endif

restarea(_aArea)

Return nlValor                            
