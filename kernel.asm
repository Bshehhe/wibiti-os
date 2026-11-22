bits 16
org 0x8000

start:
    cli

    lgdt [gdt_descriptor]

    ; Увімкнути protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE32_SEG:protected_mode


bits 32

protected_mode:
    mov ax, DATA32_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Очистити область під таблиці сторінок
    mov edi, 0x10000
    mov ecx, 0x3000
    xor eax, eax
    rep stosb

    ; PML4 -> PDPT
    mov dword [0x10000], 0x11003

    ; PDPT -> Page Directory
    mov dword [0x11000], 0x12003

    ; Page Directory -> 2 MiB identity mapping
    mov dword [0x12000], 0x00000083

    ; CR3 = адреса PML4
    mov eax, 0x10000
    mov cr3, eax

    ; Увімкнути PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Увімкнути Long Mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Увімкнути paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ; Перехід у 64-bit
    jmp CODE64_SEG:long_mode


bits 64

long_mode:
    mov ax, DATA64_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov rdi, 0xB8000
    mov rsi, message

print:
    lodsb
    test al, al
    jz hang

    mov [rdi], al
    inc rdi

    mov byte [rdi], 0x0F
    inc rdi

    jmp print

hang:
    cli
    hlt
    jmp hang


gdt_start:

gdt_null:
    dq 0

gdt_code32:
    dq 0x00CF9A000000FFFF

gdt_data32:
    dq 0x00CF92000000FFFF

gdt_code64:
    dq 0x00AF9A000000FFFF

gdt_data64:
    dq 0x00CF92000000FFFF

gdt_end:


gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start


CODE32_SEG equ gdt_code32 - gdt_start
DATA32_SEG equ gdt_data32 - gdt_start
CODE64_SEG equ gdt_code64 - gdt_start
DATA64_SEG equ gdt_data64 - gdt_start


message db "WIBITI OS: 64-bit long mode!", 0

times 4096-($-$$) db 0
