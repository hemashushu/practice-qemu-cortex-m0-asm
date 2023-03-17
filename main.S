    .syntax unified
    .cpu cortex-m0
    .arch armv6-m

    /**
     * ARM Directives
     * https://sourceware.org/binutils/docs/as/ARM-Directives.html
     *
     * About the Unified Assembler Language
     * https://developer.arm.com/documentation/dui0473/k/dom1359731145130
     * https://sourceware.org/binutils/docs/as/ARM_002dInstruction_002dSet.html
     */

    .section .vector_table.vectors
    .align 2
    .globl __isr_vector
__isr_vector:
    .long   _estack                  /* Top of Stack */
    .long   Reset_Handler
    .long   NMI_Handler
    .long   HardFault_Handler
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   SVC_Handler
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   PendSV_Handler
    .long   SysTick_Handler

  /* External Interrupts */
    .long   POWER_CLOCK_IRQHandler
    .long   RADIO_IRQHandler
    .long   UART0_IRQHandler
    .long   SPI0_TWI0_IRQHandler
    .long   SPI1_TWI1_IRQHandler
    .long   0                           /*Reserved */
    .long   GPIOTE_IRQHandler
    .long   ADC_IRQHandler
    .long   TIMER0_IRQHandler
    .long   TIMER1_IRQHandler
    .long   TIMER2_IRQHandler
    .long   RTC0_IRQHandler
    .long   TEMP_IRQHandler
    .long   RNG_IRQHandler
    .long   ECB_IRQHandler
    .long   CCM_AAR_IRQHandler
    .long   WDT_IRQHandler
    .long   RTC1_IRQHandler
    .long   QDEC_IRQHandler
    .long   LPCOMP_IRQHandler
    .long   SWI0_IRQHandler
    .long   SWI1_IRQHandler
    .long   SWI2_IRQHandler
    .long   SWI3_IRQHandler
    .long   SWI4_IRQHandler
    .long   SWI5_IRQHandler
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */
    .long   0                           /*Reserved */

    .size __isr_vector, . - __isr_vector

/* program start */

    .section .text
    .thumb

    .thumb_func
    .align 1
    .globl Reset_Handler
    .type Reset_Handler, %function
Reset_Handler:
    b   _start
    b   .
    .size   Reset_Handler, . - Reset_Handler

    .thumb_func
    .globl _start
    .type _start, %function
_start:
    movs r0, #0
    movs r1, #1
    movs r2, #2
    bkpt
    .size   _start, . - _start

    .section .text

/* Dummy Exception Handlers (infinite loops which can be modified) */

    .weak   NMI_Handler
    .type   NMI_Handler, %function
NMI_Handler:
    b       .
    .size   NMI_Handler, . - NMI_Handler


    .weak   HardFault_Handler
    .type   HardFault_Handler, %function
HardFault_Handler:
    b       .
    .size   HardFault_Handler, . - HardFault_Handler


    .weak   SVC_Handler
    .type   SVC_Handler, %function
SVC_Handler:
    b       .
    .size   SVC_Handler, . - SVC_Handler


    .weak   PendSV_Handler
    .type   PendSV_Handler, %function
PendSV_Handler:
    b       .
    .size   PendSV_Handler, . - PendSV_Handler


    .weak   SysTick_Handler
    .type   SysTick_Handler, %function
SysTick_Handler:
    b       .
    .size   SysTick_Handler, . - SysTick_Handler


/* IRQ Handlers */

    .globl  Default_Handler
    .type   Default_Handler, %function
Default_Handler:
    b       .
    .size   Default_Handler, . - Default_Handler

/* macro */

    .macro  IRQ handler
    .weak   \handler
    .set    \handler, Default_Handler
    .endm

    IRQ  POWER_CLOCK_IRQHandler
    IRQ  RADIO_IRQHandler
    IRQ  UART0_IRQHandler
    IRQ  SPI0_TWI0_IRQHandler
    IRQ  SPI1_TWI1_IRQHandler
    IRQ  GPIOTE_IRQHandler
    IRQ  ADC_IRQHandler
    IRQ  TIMER0_IRQHandler
    IRQ  TIMER1_IRQHandler
    IRQ  TIMER2_IRQHandler
    IRQ  RTC0_IRQHandler
    IRQ  TEMP_IRQHandler
    IRQ  RNG_IRQHandler
    IRQ  ECB_IRQHandler
    IRQ  CCM_AAR_IRQHandler
    IRQ  WDT_IRQHandler
    IRQ  RTC1_IRQHandler
    IRQ  QDEC_IRQHandler
    IRQ  LPCOMP_IRQHandler
    IRQ  SWI0_IRQHandler
    IRQ  SWI1_IRQHandler
    IRQ  SWI2_IRQHandler
    IRQ  SWI3_IRQHandler
    IRQ  SWI4_IRQHandler
    IRQ  SWI5_IRQHandler

/* end of this assembly file */
  .end
