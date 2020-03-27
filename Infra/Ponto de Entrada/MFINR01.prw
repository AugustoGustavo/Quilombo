#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO10    � Autor � AP6 IDE            � Data �  29/06/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MFINR01


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cString := "CD2"
dbSelectArea("CD2")
//dbSetOrder(1)

CREATE TRIGGER CD2010_TRIGGER1 ON CD2010 INSTEAD OF INSERT
AS
	DECLARE @QUANTIDADE AS INTEGER;
	
	SET NOCOUNT ON
	SELECT @QUANTIDADE = COUNT(*) 
	FROM CD2010 CD2, inserted i
	WHERE
		CD2.CD2_FILIAL = i.CD2_FILIAL AND
		CD2.CD2_TPMOV = i.CD2_TPMOV AND 
		CD2.CD2_SERIE = i.CD2_SERIE AND 
		CD2.CD2_DOC = i.CD2_DOC AND
		CD2.CD2_CODCLI = i.CD2_CODCLI AND
		CD2.CD2_LOJCLI = i.CD2_LOJCLI AND
		CD2.CD2_CODFOR = i.CD2_CODFOR AND
		CD2.CD2_LOJFOR = i.CD2_LOJFOR AND
		CD2.CD2_ITEM = i.CD2_ITEM AND
		CD2.CD2_CODPRO = i.CD2_CODPRO AND
		CD2.CD2_IMP = i.CD2_IMP AND
		CD2.R_E_C_D_E_L_ = i.R_E_C_D_E_L_;
	
	IF (@QUANTIDADE = 0) 
		INSERT INTO CD2010 SELECT * FROM inserted;


Return
