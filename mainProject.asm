; -------------------------------------------------------------
; Self Ping-Pong
; Author: ...
; -------------------------------------------------------------
IDEAL
MODEL small
STACK 100h
DATASEG
x dw 120
y dw 100
counter dw 0
color db 4
negativeColor db 0fbh
pixelsInPress equ 20
lineSizePixels equ 40


up db 'Move up',13,10,'$'
down db 'Move down',13,10,'$'
left db 'Move Left',13,10,'$'
right db 'Move right',13,10,'$'

CODESEG
proc line
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx

	mov cx,20
	prinline:
	mov bh,0h
	mov cx,[x]
	mov dx,[y]
	mov al,[color]
	mov ah,0ch
	int 10h
	inc [x] 
	inc [counter] 
	cmp [counter],lineSizePixels 
	jne prinline

	mov [x],120
	mov [y],100
	mov [counter],0
	pop ax
	pop bx
	pop cx
	pop dx
	pop bp
	ret 
endp line

proc moveLineRight
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx

	; draw black on 15 leftest pixels
	drawLeftBlack:
	mov bh,0h
	mov cx,[x]
	mov dx,[y]
	mov al,[negativeColor]
	mov ah,0ch
	int 10h
	inc [x] 
	inc [counter] 
	cmp [counter],pixelsInPress 
	jne drawLeftBlack
	mov [counter],0
	
	mov cx,[x]
	add cx,lineSizePixels
	drawRightColor:
	mov bh,0h
	mov dx,[y]
	mov al,[color]
	mov ah,0ch
	int 10h
	dec cx
	inc [counter] 
	cmp [counter],pixelsInPress 
	jne drawRightColor
	mov [counter],0	
	
	pop ax
	pop bx
	pop cx
	pop dx
	pop bp
	ret 
endp moveLineRight

proc moveLineLeft
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx

	; draw color on 15 leftest pixels
	;mov cx,[x]
	;sub cx,pixelsInPress
	drawLeftColor:
	mov bh,0h
	mov cx,[x]
	mov dx,[y]
	mov al,[color]
	mov ah,0ch
	int 10h
	dec [x] 
	inc [counter] 
	cmp [counter],pixelsInPress 
	jne drawLeftColor
	mov [counter],0	
	
	mov cx,[x]
	add cx,lineSizePixels
	inc cx
	drawRightBlack:
	mov bh,0h
	;mov cx,[x]
	mov dx,[y]
	mov al,[negativeColor]
	mov ah,0ch
	int 10h
	inc cx 
	inc [counter] 
	cmp [counter],pixelsInPress 
	jne drawRightBlack
	mov [counter],0	
	
	pop ax
	pop bx
	pop cx
	pop dx
	pop bp
	ret 
endp moveLineLeft

start:
mov ax, @data
mov ds, ax
; Graphic mode
mov ax, 13h
int 10h
; Print red line
call line
; Wait for key press
WaitForData:
	mov ah, 1
	int 16h
	jz WaitForData
	mov ah, 0
	int 16h
	cmp ah, 11h
	je W
	cmp ah, 1Eh
	je A
	cmp ah, 1Fh
	je S
	cmp ah, 20h
	je D
	cmp ah, 1h
	je exit
	jmp WaitForData
	
W:
; mov dx, offset up
; mov ah, 9
; int 21h
; call line
jmp WaitForData
A:
;mov dx, offset left
;mov ah, 9
;int 21h
call moveLineLeft
jmp WaitForData
S:
;mov dx, offset down
;mov ah, 9
;int 21h
jmp WaitForData
D:
;mov dx, offset right
;mov ah, 9
;int 21h
call moveLineRight
jmp WaitForData

exit:
; Return to text mode
mov ah, 0
mov al, 3h
int 10h ; exit int
mov ax, 4c00h
int 21h
END start

 
 
 