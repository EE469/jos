/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
/* 

TABLE FROM WIKIPEDIA : https://en.wikipedia.org/wiki/Interrupt_descriptor_table

// INT_NUM 	Short Description PM[clarification needed]
// 0x00 	Division by zero
// 0x01 	Single-step interrupt (see trap flag)
// 0x02 	NMI
// 0x03 	Breakpoint (which benefits from the shorter 0xCC encoding of INT 3)
// 0x04 	Overflow
// 0x05 	Bound Range Exceeded
// 0x06 	Invalid Opcode
// 0x07 	Coprocessor not available
// 0x08 	Double Fault
// 0x09 	Coprocessor Segment Overrun (386 or earlier only)
// 0x0A 	Invalid Task State Segment
// 0x0B 	Segment not present
// 0x0C 	Stack Segment Fault
// 0x0D 	General Protection Fault
// 0x0E 	Page Fault
// 0x0F 	reserved
// 0x10 	x87 Floating Point Exception
// 0x11 	Alignment Check
// 0x12 	Machine Check
// 0x13 	SIMD Floating-Point Exception
// 0x14 	Virtualization Exception
// 0x15 	Control Protection Exception (only available with CET) 
*/

###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

//We will use TRAPHANDLER or TRAPHANDLER_NOEC based on whether the system returns a 
//error code or not given the specific interrupt. This can be found via the table provided
//in the lab manual. 

TRAPHANDLER_NOEC(interrupt_0, 0)
TRAPHANDLER_NOEC(interrupt_1, 1)
TRAPHANDLER_NOEC(interrupt_2, 2)
TRAPHANDLER_NOEC(interrupt_3, 3)
TRAPHANDLER_NOEC(interrupt_4, 4)
TRAPHANDLER_NOEC(interrupt_5, 5)
TRAPHANDLER_NOEC(interrupt_6, 6)
TRAPHANDLER_NOEC(interrupt_7, 7)
TRAPHANDLER(interrupt_8, 8)
TRAPHANDLER_NOEC(interrupt_9, 9)
TRAPHANDLER(interrupt_10, 10)
TRAPHANDLER(interrupt_11, 11)
TRAPHANDLER(interrupt_12, 12)
TRAPHANDLER(interrupt_13, 13)
TRAPHANDLER(interrupt_14, 14)
// TRAPHANDLER_NOEC(interrupt_15, 15) //Intel reserved. Do not use.
TRAPHANDLER_NOEC(interrupt_16, 16)
TRAPHANDLER(interrupt_17, 17)
TRAPHANDLER_NOEC(interrupt_18, 18)
TRAPHANDLER_NOEC(interrupt_19, 19)
TRAPHANDLER_NOEC(interrupt_20, 20)
//define T_SYSCALL   48		// system call
TRAPHANDLER_NOEC(interrupt_syscall, 48) 


// HINT 1 : TRAPHANDLER_NOEC(t_divide, T_DIVIDE);
//          Do something like this if there is no error code for the trap
// HINT 2 : TRAPHANDLER(t_dblflt, T_DBLFLT);
//          Do something like this if the trap includes an error code..
// HINT 3 : READ Intel's manual to check if the trap includes an error code
//          or not...

/*
 * Lab 3: Your code here for _alltraps
 */

 _alltraps:
	pushl %ds
	pushl %es 
	pushal
	movl $GD_KD, %eax
	movw %ax, %ds
	movw %ax, %es 
	pushl %esp 
	call trap





