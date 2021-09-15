@ Write an arm program to evaluate 4 * x * x + 3 * x
@ assume x is in r1 and store result in r0 
	
	.text
	
start:
	
      	MOV     r1, #0x8 
   
	@Everything to be stored in r0 as I go along
	@ x already stored in register 2, r1
	MOV	r2, #3 @store the decimal number 3 in register 3
  	MOV	r3, #4 @store the decimal number 4 in register 4
   
    	MUL	r0, r1, r1 @Multiply x by x and store in r0
    	MUL	r0, r0, r3 @Multiply x^2 by 4 and store in r0
    
   	MUL	r1, r1, r2 @Multiply x by 3 and store in r1
    	
    	ADD 	r0, r0, r1 @Add 4x^2 and 3x and store in r0
    
 
stop:   B	stop
    	.data
    	.end