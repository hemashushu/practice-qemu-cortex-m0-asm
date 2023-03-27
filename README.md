# QEMU Cortex-M0 ASM

QEMU _Micro:Bit v1_

- Nordic nRF51822, 16 MHz ARM Cortex-M0 core
- 256 KB Flash
- 16 KB RAM

Details:

- https://qemu.readthedocs.io/en/latest/system/arm/nrf.html
- https://github.com/qemu/qemu/blob/master/hw/arm/microbit.c
- https://github.com/qemu/qemu/blob/master/hw/arm/nrf51_soc.c

Some key definitions:

```c
#define NRF51822_FLASH_PAGES    256         // 256KiB
#define NRF51822_SRAM_PAGES     16          // 16KiB
#define HCLK_FRQ                16000000    // 16MHz
```

## Build

`$ ./build.sh`

## Debug on QEMU

Start QEMU GDB server first:

`$ ./start-gdb-server-qemu.sh`

Open another terminal and run the script `start-gdb-client.sh` or `start-gdb-client-with-svd-tools.sh` to start GDB program:

`$ ./start-gdb-client.sh`

The processor should now halt on the instruction `Reset_Handler: b _start`, enter the following GDB command to confirm:

```gdb
(gdb) x/6i $pc
=> 0xc0 <Reset_Handler>:        b.n     0xc4 <_start>
   0xc2 <Reset_Handler+1>:      b.n     0xc2 <Reset_Handler+1>
   0xc4 <_start>:       movs    r0, #0
   0xc6 <_start+1>:     movs    r1, #1
   0xc8 <_start+3>:     movs    r2, #2
   0xca <_start+5>:     bkpt    0x0000
```

Then try to run some GDB commands, e.g.

```gdb
(gdb) i r
r0             0x0                 0
r1             0x0                 0
r2             0x0                 0
...
(gdb) si 4
100         bkpt
(gdb) i r
r0             0x0                 0
r1             0x1                 1
r2             0x2                 2
...
```

## Flash on real nRF51822 or _Micro:Bit v1_

Make sure that the nRF51822 or _Micro:Bit v1_ is connected to DAPLINK debugger (hardware) via the SWD wires first.

```bash
# openocd default scripts location "/usr/share/openocd/scripts"

# flash ELF or HEX
openocd -f interface/cmsis-dap.cfg  -f target/nrf51.cfg -c "program main.elf verify reset exit"

# flash BIN
#openocd -f interface/cmsis-dap.cfg -f target/nrf51.cfg -c "program main.bin verify reset exit 0x00000000"
```

Note that the program binary is placed at 0x00000000, not at 0x08000000 as is usual for STM32 serial chips.

## Debug on real nRF51822 or _Micro:Bit v1_

Start OpenOCD GDB server first:

```bash
# start gdb server by OpenOCD
openocd -f interface/cmsis-dap.cfg  -f target/nrf51.cfg -s "/usr/share/openocd/scripts"
```

Open another terminal and run the following commands:

```bash
$ arm-none-eabi-gdb main.elf \
    -ex "target extended-remote localhost:3333" \
    -ex "load"
```

Then try to print memory content with GDB `x` command:

```gdb
gdb> x/8i $pc
```

You should see a result that looks like this:

```text
(gdb) x/8i $pc
=> 0xc0 <Reset_Handler>:        b.n     0xc4 <_start>
   0xc2 <Reset_Handler+1>:      b.n     0xc2 <Reset_Handler+1>
   0xc4 <_start>:       movs    r0, #0
   0xc6 <_start+1>:     movs    r1, #1
   0xc8 <_start+3>:     movs    r2, #2
   0xca <_start+5>:     bkpt    0x0000
   0xcc <NMI_Handler>:  b.n     0xcc <NMI_Handler>
   0xce <HardFault_Handler>:    b.n     0xce <HardFault_Handler>
```

Then try to run some GDB commands, e.g.

```gdb
(gdb) si
97          movs r0, #0
(gdb) si
98          movs r1, #1
(gdb) si
99          movs r2, #2
(gdb) i r r0
r0             0x0                 0
(gdb) i r r1
r1             0x1                 1
(gdb)
```

Enter command `q` to exit GDB.
