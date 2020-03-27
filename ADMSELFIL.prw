#Include 'Protheus.ch'

 

User Function ADMSELFIL()

 

Local cTitle := ParamIxb[1]  // Utilizado para montagem de tela, se desejado
Local aOpcs  := ParamIxb[2] // Array contendo filial, nome da empresa e CGC
Local cOpcs  := ParamIxb[3] // aOpcs macro-executado armazenando apenas o codigo da filial
Local nTamFil:= ParamIxb[4] // Tamanho da filial
Local aRet   := {}                 // Retorno das filiais selecionadas
Local nI     := 0

 

Alert("Ponto de entrada ADMSELFIL executado.")

 

If MsgYesNo("Deseja selecionar todas as filiais?")
      For nI := 1 to Len(aOpcs)
            AADD(aRet, PadR(aOpcs[nI][1], nTamFil) )
      Next
Else
      For nI := 1 to Len(aOpcs)
            If MsgYesNo("Deseja selecionar a filial ( "+aOpcs[nI][2]+" ) ?")
                  AADD(aRet, aOpcs[nI][1])
                  MsgAlert("Filial "+aOpcs[nI][2]+" selecionada.")
            EndIf
      Next
      If Empty(aRet)
            aRet := cFilAnt
      EndIf
EndIf

Return()