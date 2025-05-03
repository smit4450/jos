#ifndef JOS_INC_MSR
#define JOS_INC_MSR 1

#include <inc/types.h>
#include <inc/memlayout.h>

#define MSR_IA32_SYSENTER_CS 0x174
#define MSR_IA32_SYSENTER_ESP 0x175
#define MSR_IA32_SYSENTER_EIP 0x176

#define wrmsr(msr, dx, ax) asm volatile("wrmsr"::"c"(msr), "d" (dx), "a" (ax))

static void 
msr_init(void)
{
    extern void _sysenter_handler(void);

    uint32_t cs;
    asm volatile("movl %%cs, %0": "=r"(cs));

    wrmsr(MSR_IA32_SYSENTER_CS, 0, cs);
    wrmsr(MSR_IA32_SYSENTER_EIP, 0, (uint32_t)  _sysenter_handler);
    wrmsr(MSR_IA32_SYSENTER_ESP, 0, KSTACKTOP);
}
#endif