;Assignment 1 recursive factorial

	area	tcd,code,readonly
	export	__main
__main
	ldr r5,=num1
	ldr r2, [r5]
	mov r1,r2		
	mov r0,#0
	bl fact
	
	ldr r3,=res1
	str r1,[r3]
	add r3,#4
	str r0,[r3]
	
	ldr r5,=num2
	ldr r2, [r5]
	mov r1,r2
	mov r0,#0
	bl fact
	
	ldr r3,=res2
	str r1,[r3]
	add r3,#4
	str r0,[r3]
	
	ldr r5,=num3
	ldr r2, [r5]
	mov r1,r2
	mov r0,#0
	bl fact
	
	ldr r3,=res3
	str r1,[r3]
	add r3,#4
	str r0,[r3]
	
	ldr r5,=num4
	ldr r2, [r5]
	mov r1,r2
	mov r0,#0
	bl fact
	
	ldr r3,=res4
	str r1,[r3]
	add r3,#4
	str r0,[r3]
	
fin	b		fin 			

fact
	
	stmfd sp!,{r2,r3,r4,r6,lr}
	cmp r2,#1
	beq po		;branch pop
	sub r2,#1 
	bl fact
	
	umull r1,r4,r2,r1  	;r1 x r2 -> r1, overflow -> r4
	umull r0,r6,r2,r0	;r0 x r2 -> r0, overflow -> r6
	
	add r0,r4
	cmp r6,#0
	
	blgt overflow
	cmp r8,#1
	blne cbit
	
po
	ldmfd sp!,{r2,r3,r4,r6,lr}

	bx lr
	
overflow
	mov r0,#0
	mov r1,#0
	mov r8,#1	;cbit branch wont execute
	bx lr
	
cbit
	mrs r10,cpsr
    ldr r7, =0xDFFFFFF
    and r10,r7,r10
	msr cpsr_f,r10
	bx lr
	
	area	romstuff,data,readonly
num1	dcd		5
num2	dcd		14
num3	dcd		20
num4    dcd		30
	
	area	ramstuff,data,readwrite
res1	space	8	
res2	space	8
res3	space   8
res4	space	8
	end