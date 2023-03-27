    /**
     * ARM Directives
     * https://sourceware.org/binutils/docs/as/ARM-Directives.html
     *
     * About the Unified Assembler Language
     * https://developer.arm.com/documentation/dui0473/k/dom1359731145130
     * https://sourceware.org/binutils/docs/as/ARM_002dInstruction_002dSet.html
     */

    .syntax unified
    .cpu cortex-m0
    .arch armv6-m
    .thumb

    /**
     * Instructions that were executed after the chip reset or power on
     */

    .section .text

    .thumb_func
    .globl Reset_Handler
    .type Reset_Handler, %function
Reset_Handler:
    b   _start
    b   .
    .size   Reset_Handler, . - Reset_Handler

    /**
     * The program entry `_start`, it was called by `Reset_Handler`
     */

    .thumb_func
    .globl _start
    .type _start, %function
_start:
    movs r0, #0
    movs r1, #1
    movs r2, #2
    bkpt
    .size   _start, . - _start

    /* end of this assembly file */
    .end
