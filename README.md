# WIBITI OS

**WIBITI OS** is a hobby operating system written in C and Assembly.

The project is currently in an early experimental stage.

## Current features

- Custom BIOS bootloader
- x86 protected mode transition
- x86_64 long mode initialization
- VGA text output
- Basic PS/2 keyboard input
- Experimental login system

## Technologies

- C
- NASM Assembly
- GNU Binutils
- Git

## Project structure

| File | Description |
|---|---|
| `boot.asm` | BIOS bootloader |
| `kernel_entry.asm` | Kernel entry and CPU mode switching |
| `kernel.c` | Main kernel |
| `keyboard.c` | Keyboard input |
| `kernel.asm` | Earlier experimental kernel |
 
## Roadmap

- [ ] Fix bootloader disk reading
- [ ] Improve keyboard input
- [ ] Add screen clearing and scrolling
- [ ] Implement a basic command shell
- [ ] Add filesystem support
- [ ] Improve memory management

## Disclaimer

This is an educational hobby project. It is not intended for production use.
