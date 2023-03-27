/* the entry point */
ENTRY(Reset_Handler)

/*
 * Info : QEMU nRF51822 256kB Flash, 16kB RAM
 *
 * https://github.com/qemu/qemu/blob/master/hw/arm/nrf51_soc.c
 *
 * #define NRF51822_FLASH_PAGES    256
 * #define NRF51822_SRAM_PAGES     16
 */
MEMORY
{
  FLASH ( rx )      : ORIGIN = 0x00000000, LENGTH = 256K
  RAM ( rxw )       : ORIGIN = 0x20000000, LENGTH = 16K
}

/* the stack point is the end address of RAM, i.e. `0x20000000 + 0x5000` */
_estack = ORIGIN(RAM) + LENGTH(RAM);

EXTERN(__isr_vector);
EXTERN(Reset_Handler);

SECTIONS
{
  /* The vector table goes at the start of flash. */
  .vector_table :
  {
    LONG(_estack);

    KEEP(*(.vector_table.vectors));
  } >FLASH

  /* The 'text' section contains the main program code. */
  .text : /* ALIGN(4) */
  {
    /* KEEP(*(.vector_table.vectors)); */
    *(.text .text.*);
  } >FLASH

  /* The 'rodata' section contains read-only data,
   * constants, strings, information that won't change.
   */
  .rodata : ALIGN(4)
  {
    *(.rodata .rodata.*);
  } >FLASH

  /* The 'data' section is space set aside in RAM for
   * things like variables, which can change.
   *
   * set the Load Memory Address (LMA) of the `.data` section by
   * `AT(...)` at header line or `AT > FLASH` at footer line
   */
  .data : ALIGN(4) /* AT(ADDR(.rodata) + SIZEOF(.rodata)) */
  {
    _sdata = .;
    *(.data .data.*);
    _edata = .;
  } >RAM AT >FLASH

  /**
   * get the LMA of the section `.data`
   * - 3.1 Basic Linker Script Concepts
   *   https://sourceware.org/binutils/docs/ld/Basic-Script-Concepts.html
   * - 3.6.8.2 Output Section LMA
   *   https://sourceware.org/binutils/docs/ld/Output-Section-LMA.html
   * - LOADADDR(section)
   *   https://sourceware.org/binutils/docs/ld/Builtin-Functions.html#index-LOADADDR_0028section_0029
   */
  /* LMA of .data */
  _sidata = LOADADDR(.data);

  /* The 'bss' section is similar to the 'data' section,
   * but its space is initialized to all 0s at the
   * start of the program. */
  .bss : ALIGN(4)
  {
    _sbss = .;
    *(.bss .bss.*);
    _ebss = .;
  } >RAM

  . = ALIGN(4);
  _heap_start = .;

  /* Discarded sections */
  /DISCARD/ :
  {
    *(.ARM.exidx .ARM.exidx.* .ARM.extab.*);
  }
}
