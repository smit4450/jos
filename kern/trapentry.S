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
	TRAPHANDLER_NOEC(t_divide, T_DIVIDE) // Divide Error 1
	TRAPHANDLER_NOEC(t_debug, T_DEBUG) // Debug Exception 2
	TRAPHANDLER_NOEC(t_nmi, T_NMI) // NMI Interrupt 3
	TRAPHANDLER_NOEC(t_brkpt, T_BRKPT) // Breakpoint 4
	TRAPHANDLER_NOEC(t_oflow, T_OFLOW) // Overflow 5
	TRAPHANDLER_NOEC(t_bound, T_BOUND) // Bound Range Exceeded 6
	TRAPHANDLER_NOEC(t_illop, T_ILLOP) // Invalid Opcode 7
	TRAPHANDLER_NOEC(t_device, T_DEVICE) //Device not Available 8
	TRAPHANDLER(t_dblflt, T_DBLFLT) // Double Fault 9
	TRAPHANDLER(t_tss, T_TSS) // Invalid TSS 10
	TRAPHANDLER(t_segnp, T_SEGNP) // Segment not present 11 
	TRAPHANDLER(t_stack, T_STACK) //Stack Segment Fault 12
	TRAPHANDLER(t_gpflt, T_GPFLT) // General Protection 13
	TRAPHANDLER(t_pgflt, T_PGFLT) // Page Fault 14
	TRAPHANDLER_NOEC(t_fperr, T_FPERR); // Floating Point Error 15
	TRAPHANDLER(t_align, T_ALIGN) // Alignment check
	TRAPHANDLER_NOEC(t_mchk, T_MCHK) // machine check
	TRAPHANDLER_NOEC(t_simderr, T_SIMDERR) //SIMD floating Point
	TRAPHANDLER_NOEC(t_syscall,T_SYSCALL)
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
// loading GD_KD into ds and es
	pushl %ds
	pushl %es
	pushal
	push $GD_KD
	pop %ds
	pushl $GD_KD
	popl %es
	pushl %esp
	call trap

