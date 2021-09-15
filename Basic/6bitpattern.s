	LDR	R1, =0b01110001000111101100111000111111	

	LDR R0, =0x0
	MOV	R2, R1, LSL #1
    	LDR R3, =0x1
    	
    	ifstart:
    	    CMP R1, #2147483648
    	    BLE endjump
    	    ADD R0, R0, #1
    	endjump:
    	    	
    	Loop:
    	    CMP R8, #31	
    	    BGE endLoop
    	    MOV R2, R2, LSR #1
    	    AND R4, R3, R2
    	    		
    	    
    	    ADD R8, R8, #1
    	   		
    	    CMP R4, R3
    	    BNE	else2
    	    MOV R5, #0
    	    B endif	
    	   		
    	else2:
    	    CMP R5, #0
    	    BNE endif2
    	    ADD R0, R0, #1
    	    MOV R5, #1
    	   	
    	endif2:
    	endif:
   	    B Loop
    	endLoop: