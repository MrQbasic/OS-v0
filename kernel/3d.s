;-------------------------------------------------------------------------
;render_main	    /
;render_get_tri	   ax=tri bx=point cx=coord         -->  ret=cs:dx pointer
;render_proj_init   /
;-------------------------------------------------------------------------
[bits 16]
render_main:
	;get old vid mode and save it
	mov ax, 0x0000
	mov ds, ax
	mov dl, [ds:0x0449]
	mov ax, cs
	mov ds, ax
	mov [ds: render_old_mode], dl
	;set video mode to 13
	mov ax, 0x0013
	;int 0x10
	;setup for rendering
	FINIT
	call render_proj_init
	

	
	;wait
	mov ax, 50
	call sys_delay
	;exit - restore old vid mode
	xor ax, ax
	mov al, [ds: render_old_mode]
	int 0x10
	ret


render_get_tri:
	push ax
	push bx

	mov dx, render_tris
	add dx, cx
	mov cx, 9
	mul cx
	add dx, ax
	mov ax, bx
	mov cx, 3
	mul cx
	add dx, ax
	pop cx
	pop bx
	pop ax
	ret 

render_proj_init:
	mov ax, cs
	mov ds, ax
	;calc tan(fov)
	FLD  dword [render_fov]
	FSIN
	FLD  dword [render_fov]
	FCOS
	FDIV
	FSTP dword [render_buffer]
	;calc 1 / tan(fov) = f
	FLD1
	FDIV dword [render_buffer]
	;store
	FST dword [render_projection + 5]
	;calc ar
	FLD dword [render_screen_width]
	FDIV dword [render_screen_height]
	;calc ar * f
	FMUL
	;store
	FST dword [render_projection]
	;calc zf / (zf - zn)
	FLD dword [render_z_far]
	FLD dword [render_z_far]
	FSUB dword [render_z_near]
	FDIV
	;store
	FST dword [render_projection + ((4 * 2) + 2)]
	;calc (-zf * zn) * (zf - zn)
	FLD dword [render_z_far]
	FSUB dword [render_z_near]
	FLD1
	FSUB dword [render_z_far]
	FMUL dword [render_z_near]
	FMUL
	;store
	FST dword [render_projection + ((4 * 2) + 3)]
	mov eax, [render_projection + ((4 * 2) + 3)]
	;2 fix vals
	FLD1
	FST dword [render_projection ((4 * 3) + 2)]
	FLDZ
	FST dword [render_projection ((4 * 3) + 3)]
	;exit
	ret

render_buffer: dd 0

render_old_mode: db 0x00

render_screen_width:  dd 320.0
render_screen_height: dd 200.0

render_z_far:		  dd 1000.0
render_z_near:  	  dd    0.1
render_fov:			  dd  100.0

render_projection:
	dd 0.0, 0.0, 0.0, 0.0
	dd 0.0, 0.0, 0.0, 0.0
	dd 0.0, 0.0, 0.0, 0.0
	dd 0.0, 0.0, 0.0, 0.0

render_tris:
    dd 0,0,0,0,1,0,1,1,0
    dd 0,0,0,1,1,0,1,0,0
    dd 1,0,0,1,1,0,1,1,1
    dd 1,0,0,1,1,1,1,0,1
    dd 1,0,1,1,1,1,0,1,1
    dd 1,0,1,0,1,1,0,0,1
    dd 0,0,1,0,1,1,0,1,0
    dd 0,0,1,0,1,0,0,0,0
    dd 0,1,0,0,1,1,1,1,1
    dd 0,1,0,1,1,1,1,1,0
    dd 1,0,1,0,0,1,0,0,0
    dd 1,0,1,0,0,0,1,0,0

	