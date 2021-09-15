; Assignment 2 Simple IO

	area	tcd,code,readonly
	export	__main
__main
IO1DIR	EQU	0xE0028018
IO1SET	EQU	0xE0028014
IO1CLR	EQU	0xE002801C
IO1PIN	EQU	0xE0028010		
	
	ldr r0,=IO1DIR
	mov r1,#0x00FF0000	; outputs pins 23 - 16
	str r1,[r0]
	ldr	r0,=IO1PIN			
	
	mov	r2,#0			; store result
	mov r3,#0xF7000000	; pin 27
	mov r4,#0xFB000000  ; pin 26
	mov r5,#0xFD000000  ; pin 25
	mov r6,#0xFE000000  ; pin 24
	mov r7,#0xFF000000	; pins 24 - 27
	mov r8,#0x00FF0000	; pins 16-23

poll
	bl wait		; wait for input
	
	cmp	r1,r6			
	bleq	addone
	
	cmp r1,r5
	bleq subone
	
	cmp r1,r4
	bleq shiftl
	
	cmp r1,r3
	bleq shiftr
	
	bl store
	bl pressed	; wait for button release
	bl poll
	nop

fin	b	fin

wait
	ldr r1,[r0]
	and r1,r7		; only consider button inputs
	cmp r1,r7
	beq wait
	bx lr

pressed
	ldr r1,[r0]
	and r1,r7
	cmp r1,r7
	bne pressed
	bx lr

store
	lsl r2,#16
	and r2,r8		; account for overflow
	str r2,[r0]		; store in GPIO Pins
	lsr r2,#16
	bx lr
	
addone
	add r2,#1
	bx lr
	
subone
	sub r2,#1
	bx lr
	
shiftl
	lsl r2,#1
	bx lr
	
shiftr
	lsr r2,#1
	bx lr
	
	end