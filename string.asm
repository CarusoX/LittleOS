hex_string:
    db '0x0000', 0

print:
    ; Prints what's in bx until NULL character
    pusha
    ; Select tele-type operation for BIOS
    mov ah, 0x0e
    print_for:
        ; Load character
        mov al, [bx]

        ; Compare with NULL character
        cmp al, 0
        je print_end

        ; Interrupt to print
        int 0x10

        ; Next position
        add bx, 1
        jmp print_for
    print_end:
        popa
        ret

print_newline:
    ; Prints a CR and then a LF
    pusha
    mov ah, 0x0e
    ; CR character
    mov al, 0x0d
    int 0x10
    ; LF character
    mov al, 0x0a
    int 0x10
    popa
    ret

print_hex:
    ; Prints a 16bit word stored at dx as a hex-string
    ; We use hex_string which is a global template for 0x????
    pusha
    mov bx, hex_string
    ; Go to final '?'
    add bx, 5

    ; Loop 4 times
    mov cx, 4

    print_hex_loop:
        ; Isolate dx current byte
        mov ax, dx
        and ax, 0x000f

        ; Check if al is lower than 10
        cmp al, 10
        jl print_hex_number

        print_hex_letter:
            ; + 87 gives us [a-z] ascii codes
            add al, 0x57
            jmp print_hex_continue

        print_hex_number:
            ; + 48 gives as [0-9] ascii codes
            add al, 0x30

        print_hex_continue:
            ; Save al to string
            mov [bx], al
            ; Move to previous '?'
            sub bx, 1
            sub cx, 1
            ; Go to next high order byte
            shr dx, 4
            ; Check if we finished
            cmp cx, 0
            jne print_hex_loop

    ; Pass bx to print to print the hexcode
    mov bx, hex_string
    call print

    popa
    ret
