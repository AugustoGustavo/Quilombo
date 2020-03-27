#INCLUDE "RWMAKE.CH"

USER FUNCTION MT110END()

LOCAL cNumSC := PARAMIXB[1]
LOCAL nOpca  := PARAMIXB[2]
LOCAL aArea  := SC1->( GetArea() )

IF SC1->( DbSeek( xFilial("SC1") + cNumSc ) )

	DO WHILE SC1->C1_NUM == cNumSc .AND. ! SC1->( Eof() )
	
		IF nOpcA == 1 .AND. SC1->C1_APROV == "L"
		   RecLock( "SC1", .F. )
		   IF SC1->( FieldPos( "C1_XDTINCL" ) ) > 0            
		   	SC1->C1_XDTINCL := DATE()
		   ENDIF
		   IF SC1->( FieldPos( "C1_XHRINCL" ) ) > 0
		   	SC1->C1_XHRINCL := TIME()
		   ENDIF
			MSUnlock()
		ENDIF
		
		SC1->( DbSkip() )
		
	ENDDO
	
ENDIF

RestArea( aArea )			

RETURN	