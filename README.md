# 6502-bringup

Simple bringup/verification software for an [Eater](https://eater.net/6502) 6502 computer.

## Install tools

Install vasm (assembler).  On Arch Linux:

    git clone https://aur.archlinux.org/vasm.git
    cd vasm
    makepkg -i

Install minipro (EEPROM programmer).  On Arch Linux:

    git clone https://aur.archlinux.org/srecord.git
    cd srecord
    makepkg -i
    cd ..
    git clone https://aur.archlinux.org/minipro-git.git
    cd minipro-git
    makepkg -i

Install arduino-cli.  On Arch Linux:

    pacman -S arduino-cli

## Build

Clone the fab build system and the 6502 project:

    git clone https://github.com/dpicken/fab
    git clone https://github.com/dpicken/6502-bringup

Build:

    cd 6502-bringup
    make

## Software

* build/bringup/nop.s.o - 32 KiB of no-ops
* src/monitor/monitor.sh - Arduino-based address and data bus monitor
* build/bringup/hello-world-no-ram.s.o - hello world (no RAM required)
