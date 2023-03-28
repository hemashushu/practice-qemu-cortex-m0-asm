#!/bin/bash
arm-none-eabi-gdb main.elf \
    -ex "target extended-remote localhost:3333" \
    -ex "source svd-tools/gdb-svd.py" \
    -ex "svd svd/nrf51.svd" \
    -ex "load"

# GDB commands can also be written to a configuration file,
# e.g. "debug.gdb":
#
# ```
# target extended-remote localhost:3333
# set backtrace limit 32
# source svd-tools/gdb-svd.py
# svd svd/nrf51.svd
# load
# ```
# and then GDB can be started with the following command:
#
# `$ arm-none-eabi-gdb main.elf -x debug.gdb`