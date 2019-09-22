[org 0x7c00]

; Boot drive, sector = 1, cylinder = 0, head = 0

mov [boot_drive], dl

; Setting stack at 0x8000
; bp is the base pointer
; sp is the pointer to the `top` of the stack (stack grows downwards) 
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 2
mov dl, [boot_drive]
call disk_load

; Query second sector
mov dx, [0x9000]
call print_hex

; Query third sector
mov dx, [0x9000 + 512]
call print_hex

; LittleEndian magic => It's not face|face|face|cafe|cafe|cafe, its actually ecaf|ecaf|ecaf|efac|efac|efac
; So if we read the transition af|ef (not ce|ca), it returs fefa (Cause it reverses again, and not ceca as one would expect)
mov dx, [0x9000 + 511]
call print_hex

jmp $

%include "string.asm"
%include "read_disk.asm"

boot_drive: db 0

; Bootsector padding
times 510 - ($ - $$) db 0

dw 0xaa55

times 256 dw 0xface ; Boot drive, sector = 2, cylinder = 0, head = 0
times 256 dw 0xcafe ; Boot drive, sector = 3, cylinder = 0, head = 0