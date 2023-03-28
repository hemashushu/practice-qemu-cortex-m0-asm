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

Open another terminal window and run the script `start-gdb-client-qemu.sh` or `start-gdb-client-qemu-with-svd-tools.sh` to start GDB program:

`$ ./start-gdb-client-qemu.sh`

The processor should now halt on the instruction `Reset_Handler: b _start`, enter the following GDB command to confirm:

```gdb
(gdb) x/6i $pc
=> 0xcc <Reset_Handler>:        b.n     0xd0 <_start>
   0xce <Reset_Handler+1>:
    b.n 0xce <Reset_Handler+1>
   0xd0 <_start>:       movs    r0, #0
   0xd2 <_start+1>:     movs    r1, #1
   0xd4 <_start+3>:     movs    r2, #2
   0xd6 <_start+5>:     b.n     0xd6 <_start+5>
```

Then try to run some GDB commands, e.g.

```gdb
(gdb) i r
r0             0x0                 0
r1             0x0                 0
r2             0x0                 0
...
(gdb) si 4
40          b    .
(gdb) i r
r0             0x0                 0
r1             0x1                 1
r2             0x2                 2
...
```

## Flash on the real nRF51822 or _Micro:Bit v1_

Make sure that the nRF51822 is connected to DAPLINK debugger (hardware) via the SWD wires first. If you have _Micro:Bit v1_ board, just simply use a USB cable to connect it to your computer.

```bash
# openocd default scripts location "/usr/share/openocd/scripts"

# flash ELF or HEX
openocd -f interface/cmsis-dap.cfg  -f target/nrf51.cfg -c "program main.elf verify reset exit"

# flash BIN
#openocd -f interface/cmsis-dap.cfg -f target/nrf51.cfg -c "program main.bin verify reset exit 0x00000000"
```

Note that the program binary is placed at 0x00000000, not at 0x08000000 as is usual for STM32 serial chips.

When the flash is successful, some of the output is shown as below:

```text
Info : auto-selecting first available session transport "swd". To override use 'transport select <transport>'.
Info : CMSIS-DAP: SWD  Supported
Info : CMSIS-DAP: FW Version = 1.10
Info : CMSIS-DAP: Interface Initialised (SWD)
Info : SWCLK/TCK = 1 SWDIO/TMS = 1 TDI = 0 TDO = 0 nTRST = 0 nRESET = 1
Info : CMSIS-DAP: Interface ready
Info : clock speed 1000 kHz
Info : SWD DPIDR 0x0bb11477
Info : nrf51.cpu: hardware has 4 breakpoints, 2 watchpoints
Info : starting gdb server for nrf51.cpu on 3333
Info : Listening on port 3333 for gdb connections
target halted due to debug-request, current mode: Thread
xPSR: 0xc1000000 pc: 0x000002ec msp: 0x20004000
** Programming Started **
Info : nRF51822-QFAA(build code: H2) 256kB Flash, 16kB RAM
Warn : Adding extra erase range, 0x000000d8 .. 0x000003ff
** Programming Finished **
** Verify Started **
** Verified OK **
** Resetting Target **
shutdown command invoked
```

## Debug on the real nRF51822 or _Micro:Bit v1_

Start OpenOCD GDB server first:

```bash
# start gdb server by OpenOCD
openocd -f interface/cmsis-dap.cfg  -f target/nrf51.cfg -s "/usr/share/openocd/scripts"
```

Open another terminal window and run the following commands:

```bash
$ arm-none-eabi-gdb main.elf \
    -ex "target extended-remote localhost:3333" \
    -ex "load"
```

Then try to print memory content with GDB `x` command:

```text
(gdb) x/5i $pc
=> 0xcc <Reset_Handler>:        b.n     0xd0 <_start>
   0xce <Reset_Handler+1>:      b.n     0xce <Reset_Handler+1>
   0xd0 <_start>:       movs    r0, #0
   0xd2 <_start+1>:     movs    r1, #1
   0xd4 <_start+3>:     movs    r2, #2
```

Then try to run some GDB commands, e.g.

```gdb
(gdb) si
Reset_Handler () at main.S:37
37          movs r0, #0
(gdb) si
_start () at main.S:38
38          movs r1, #1
(gdb) si
39          movs r2, #2
(gdb) i r r0
r0             0x0                 0
(gdb) i r r1
r1             0x1                 1
```

Enter command `q` to exit GDB.
