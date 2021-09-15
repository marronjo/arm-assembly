; Assignment 3 Interrupt Clock

	area	tcd,code,readonly
	export	__main
__main

IO1DIR	EQU	0xE0028018
IO1PIN	EQU	0xE0028010
IO1SET	EQU	0xE0028014

T0	equ	0xE0004000		; Timer 0 Base Address
T1	equ	0xE0008000

IR	equ	0			; Add this to a timer's base address to get actual register address
TCR	equ	4
MCR	equ	0x14
MR0	equ	0x18

TimerCommandReset	equ	2
TimerCommandRun	equ	1
TimerModeResetAndInterrupt	equ	3
TimerResetTimer0Interrupt	equ	1
TimerResetAllInterrupts	equ	0xFF

VIC	equ	0xFFFFF000		; VIC Base Address
IntEnable	equ	0x10
VectAddr	equ	0x30
VectAddr0	equ	0x100
VectCtrl0	equ	0x200

Timer0ChannelNumber	equ	4	; UM, Table 63
Timer0Mask	equ	1<<Timer0ChannelNumber	; UM, Table 63
IRQslot_en	equ	5		; UM, Table 58

; initialisation code	
	ldr r0,=IO1DIR
	mov r1,#0xFFFFFFFF	; all output pins
	str r1,[r0]
	
	ldr	r4,=IO1PIN		
	ldr r1,=0x00F00F00	;set up output with 1111 between hours/mins/seconds
	str r1,[r4]

; Initialise the VIC
	ldr	r0,=VIC			; looking at you, VIC!

	ldr	r1,=irqhan
	str	r1,[r0,#VectAddr0] 	; associate our interrupt handler with Vectored Interrupt 0

	mov	r1,#Timer0ChannelNumber+(1<<IRQslot_en)
	str	r1,[r0,#VectCtrl0] 	; make Timer 0 interrupts the source of Vectored Interrupt 0

	mov	r1,#Timer0Mask
	str	r1,[r0,#IntEnable]	; enable Timer 0 interrupts to be recognised by the VIC

	mov	r1,#0
	str	r1,[r0,#VectAddr]   	; remove any pending interrupt (may not be needed)

; Initialise Timer 0
	ldr	r0,=T0			; looking at you, Timer 0!

	mov	r1,#TimerCommandReset
	str	r1,[r0,#TCR]

	mov	r1,#TimerResetAllInterrupts
	str	r1,[r0,#IR]

	;ldr	r1,=(14745600)-1
	ldr r1,=(18432000)-1 	;divided 14.... by 0.8, aligns timing with emulator timer. Easier to debug and test correctness 
	str	r1,[r0,#MR0]

	mov	r1,#TimerModeResetAndInterrupt
	str	r1,[r0,#MCR]

	mov	r1,#TimerCommandRun
	str	r1,[r0,#TCR]

;from here, initialisation is finished, so it should be the main body of the main program
	mov r3,#0
loop
	ldr r1,[r4]		;load display values into r1
	;bl waitinterupt
	
waitinterupt
	ldr r4,=time	
	ldr r2,[r4]
	cmp r3,r2			;will be different if interrupt has occurred
	beq waitinterupt
	
	add r3,#1			;used to compare to time memory, check if interupt
	;main code	
	ldr r4,=IO1PIN
	ldr r1,[r4]			;load in current time from display 
	
	mov r2,#0xF
	and r2,r1
	cmp r2,#0x9		;9 seconds 1001
	blt notfirstsec
	mov r2,#0xFFFFFFF0 ;clears first sec digit
	and r1,r2
	
	mov r2,#0xF0
	and r2,r1
	cmp r2,#0x50		;50 seconds
	blt notsecondsec
	mov r2,#0xFFFFFF0F ;clears second sec digit
	and r1,r2
	
	mov r2,#0xF000
	and r2,r1
	cmp r2,#0x9000		;9 minutes
	blt notfirstmin
	mov r2,#0xFFFF0FFF ;clears first min digit
	and r1,r2
	
	mov r2,#0xF0000
	and r2,r1
	cmp r2,#0x50000		;50 minutes
	blt notsecondmin
	mov r2,#0xFFF0FFFF ;clears second min digit
	and r1,r2
	
	mov r2,#0xF000000
	and r2,r1
	cmp r2,#0x9000000		;9 hours
	blt notfirsthour
	ldr r4,=0x00F00F00	
	and r1,r4			;clears time after 9 hours running
	
	b stores

notfirstsec
	add r1,#1
	b stores
	
notsecondsec
	add r1,#0x10
	b stores
	
notfirstmin
	add r1,#0x1000
	b stores

notsecondmin
	add r1,#0x10000
	b stores

notfirsthour
	add r1,#0x1000000
	b stores

notsecondhour
	add r1,#0x10000000
	b stores
	
stores
	ldr r4,=IO1PIN
	str r1,[r4]		;store time values on display
	
	b loop			;back to start of loop

fin b fin
	
	AREA	InterruptStuff, CODE, READONLY
irqhan	sub	lr,lr,#4
	stmfd	sp!,{r0-r1,lr}	; the lr will be restored to the pc

;this is the body of the interrupt handler

;here you'd put the unique part of your interrupt handler
;all the other stuff is "housekeeping" to save registers and acknowledge interrupts

;this code runs when interrupt occurs
	ldr r0,=time
	ldr r1,[r0]			;store value from memory in r1
	add r1,#1
	str r1,[r0]			;store value back in memory

;this is where we stop the timer from making the interrupt request to the VIC
;i.e. we 'acknowledge' the interrupt
	ldr	r0,=T0
	mov	r1,#TimerResetTimer0Interrupt
	str	r1,[r0,#IR]	   	; remove MR0 interrupt request from timer
	add r5,#1

;here we stop the VIC from making the interrupt request to the CPU:
	ldr	r0,=VIC
	mov	r1,#0
	str	r1,[r0,#VectAddr]	; reset VIC
	
	ldmfd	sp!,{r0-r1,pc}^	; return from interrupt, restoring pc from lr
				; and also restoring the CPSR

	area	InterruptData,data,readwrite
time	space 4					;memory space to store value from interrupt
                END
				
