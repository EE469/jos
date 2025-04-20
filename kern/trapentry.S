/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


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

// HINT 1 : TRAPHANDLER_NOEC(t_divide, T_DIVIDE);
//          Do something like this if there is no error code for the trap
// HINT 2 : TRAPHANDLER(t_dblflt, T_DBLFLT);
//          Do something like this if the trap includes an error code..
// HINT 3 : READ Intel's manual to check if the trap includes an error code
//          or not...

TRAPHANDLER_NOEC(th_divide, T_DIVIDE)
TRAPHANDLER_NOEC(th_debug, T_DEBUG)
TRAPHANDLER_NOEC(th_nmi, T_NMI)
TRAPHANDLER_NOEC(th_brkpt, T_BRKPT)
TRAPHANDLER_NOEC(th_oflow, T_OFLOW)
TRAPHANDLER_NOEC(th_bound, T_BOUND)
TRAPHANDLER_NOEC(th_illop, T_ILLOP)
TRAPHANDLER_NOEC(th_device, T_DEVICE)
TRAPHANDLER(th_dblflt, T_DBLFLT)
TRAPHANDLER(th_tss, T_TSS)
TRAPHANDLER(th_segnp, T_SEGNP)
TRAPHANDLER(th_stack, T_STACK)
TRAPHANDLER(th_gpflt, T_GPFLT)
TRAPHANDLER(th_pgflt, T_PGFLT)
TRAPHANDLER_NOEC(th_fperr, T_FPERR)
TRAPHANDLER(th_align, T_ALIGN)
TRAPHANDLER_NOEC(th_mchk, T_MCHK)
TRAPHANDLER_NOEC(th_simderr, T_SIMDERR)
TRAPHANDLER_NOEC(th_syscall, T_SYSCALL)

TRAPHANDLER_NOEC(th_irq_timer0, IRQ_OFFSET + 0)
TRAPHANDLER_NOEC(th_irq_timer1, IRQ_OFFSET + 1)
TRAPHANDLER_NOEC(th_irq_timer2, IRQ_OFFSET + 2)
TRAPHANDLER_NOEC(th_irq_timer3, IRQ_OFFSET + 3)
TRAPHANDLER_NOEC(th_irq_timer4, IRQ_OFFSET + 4)
TRAPHANDLER_NOEC(th_irq_timer5, IRQ_OFFSET + 5)
TRAPHANDLER_NOEC(th_irq_timer6, IRQ_OFFSET + 6)
TRAPHANDLER_NOEC(th_irq_timer7, IRQ_OFFSET + 7)
TRAPHANDLER_NOEC(th_irq_timer8, IRQ_OFFSET + 8)
TRAPHANDLER_NOEC(th_irq_timer9, IRQ_OFFSET + 9)
TRAPHANDLER_NOEC(th_irq_timer10, IRQ_OFFSET + 10)
TRAPHANDLER_NOEC(th_irq_timer11, IRQ_OFFSET + 11)
TRAPHANDLER_NOEC(th_irq_timer12, IRQ_OFFSET + 12)
TRAPHANDLER_NOEC(th_irq_timer13, IRQ_OFFSET + 13)
TRAPHANDLER_NOEC(th_irq_timer14, IRQ_OFFSET + 14)
TRAPHANDLER_NOEC(th_irq_timer15, IRQ_OFFSET + 15)

/*
 * Lab 3: Your code here for _alltraps
 */
 _alltraps:
	pushl %ds
	pushl %es
	pushal
	movw $GD_KD, %ax
	movw %ax, %ds
	movw %ax, %es
	pushl %esp
	call trap