[bits 16]
keyb_main:
	cli
	mov ax, 0x0000
	mov ds, ax
	mov di, 0x0024
	
	mov word [ds:di], keyb_int
	mov ax, cs
	mov word [ds:di+2], ax	

	sti

	jmp $
	
	ret
;INT 9h
keyb_int:
	pusha				;save all reg
	xor ax, ax
	mov dx, 0x60			;get ps/2 key data
	in al, dx			
	
	cmp al, 0x00
	je keyb_int_exit
	
	mov bx, ds			;save ds
	push bx

	mov bx, cs
	mov ds, bx
	mov di, SCANCODE
	add di, ax
	mov al, byte [ds:di]
	
	cmp al, 0x00
	je keyb_int_exit2
	mov byte [cs:KEYB_V_LAST], al
	mov ah, 0x0E	
	int 0x10

keyb_int_exit2:
	pop bx				;get ds back
	mov ds, bx

keyb_int_exit:
	mov al, 0x20			;reset master pic
	mov dx, 0x0020
	out dx, al
	mov dx, 0x00A0			;reset slave pic
	out dx, al
	popa				;get al reg back
	iret				;return from interrupt



KEYB_V_LAST:
	db 0x00, 0xff			;last key pressed



SCANCODE:
	db 0x00, 0x00, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, 0xE1, 0xB4, 0x08, 0x00
	db 0x51, 0x57, 0x45, 0x52, 0x54, 0x5A, 0x55, 0x49, 0x4F, 0x50, 0x9A, 0x2b, 0x00, 0x00,
	db 0x41, 0x53, 0x44, 0x46, 0x47, 0x48, 0x4A, 0x4B, 0x4C, 0x94, 0x84, 0x23, 0x20, 0x20,
	db 0x59, 0x58, 0x43, 0x56, 0x42, 0x4E, 0x4D, 0x2C, 0x2E, 0x2D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

