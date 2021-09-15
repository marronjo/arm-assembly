	LDR r1, =0xAC

	AND r2, r1, #0x1 @stores just the lsb in position 0
	MOV r0, r2, lsl #2 @move d0 to correct place and store in r0

	AND r2, r1, #0xE @stores just d1,2,3 in r2
	ORR	r0, r0, r2, lsl #3 @adds d1,2,3 to r0  [d3, d2, d1, 0, d0, 0, 0]

	AND r2, r1, #0xF0 @stores d4,5,6,7 in r2
	ORR r0, r0, r2, lsl #4 @[d7, d6, d5, d4, 0, d3, d2, d1, 0, d0, 0, 0]

	EOR	R2, R0, R0, LSR #2	
	EOR	R2, R2, R2, LSR #4	
	EOR	R2, R2, R2, LSR #8

	AND	R2, R2, #0x1		
	ORR	R0, R0, R2

	EOR	R2, R0, R0, LSR #1	
	EOR	R2, R2, R2, LSR #4	
	EOR	R2, R2, R2, LSR #8

	AND	R2, R2, #0x2		
	ORR	R0, R0, R2

	EOR	R2, R0, R0, LSR #1	
	EOR	R2, R2, R2, LSR #2	
	EOR	R2, R2, R2, LSR #8

	AND	R2, R2, #0x8		
	ORR	R0, R0, R2

	EOR	R2, R0, R0, LSR #1	
	EOR	R2, R2, R2, LSR #2	
	EOR	R2, R2, R2, LSR #4

	AND	R2, R2, #0x80		
	ORR	R0, R0, R2