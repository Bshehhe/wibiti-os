bits 16
org 0x7C00

start:
    mov [boot_drive], dl

    mov si, loading_msg
    call print

    mov ah, 0x02
    mov al, 9
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 0x8000
    int 0x13

    jc disk_error

    jmp 0x0000:0x8000

disk_error:
    mov si, error_msg
    call print

hang:
    cli
    hlt
    jmp hang

print:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

boot_drive db 0

loading_msg db "Loading WIBITI OS...", 13, 10, 0
error_msg db "Disk read error!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
