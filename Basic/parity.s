
	mov	r0, #22
	mov r1, r0
	
Loop:			@if statement
	cmp r0, #31	@compare r0 to decimal 31
	ble endLoop			@branch less than or equal to end the loop
		sub r0, r0, #32		@subtract 32 from r0 and store in r0
		add r2, r2, #1		@add 1 to r2 and store in r2
	b Loop			@branch loop, allows loop to keep going if needed
endLoop:		@does what it says

Loop1:
	cmp r0, #15
	ble endLoop1
		sub r0, r0, #16
		add r2, r2, #1
	b Loop1
endLoop1:

Loop2:
	cmp r0, #7
	ble endLoop2
		sub r0, r0, #8
		add r2, r2, #1
	b Loop2
endLoop2:

Loop3:
	cmp r0, #3
	ble endLoop3
		sub r0, r0, #4
		add r2, r2, #1
	b Loop3
endLoop3:

Loop4:
	cmp r0, #1
	ble endLoop4
		sub r0, r0, #2
		add r2, r2, #1
	b Loop4
endLoop4:

Loop5:
	cmp r0, #0
	ble endLoop5
		sub r0, r0, #1
		add r2, r2, #1
	b Loop5
endLoop5:

Loop6:			
	cmp r2, #1	@compare r2 and 1
	beq end		@if equal to go down to end ->

Loop7:
	cmp r2, #3
	beq end
		
Loop8:
	cmp r2, #5
	beq end

mov r0, r1	@if loop6,7,8 not activated then exacutes this step
b done

end:			@executes this step if loop6 or 7 or 8 are activated
add r0, r1, #128	@add 128 to r1 and store in r0
done:			@DONE
