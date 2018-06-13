IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
drawCounterForX db 0
drawCounterForY db 0
xPlace db 90 ; initial x value
yPlace db 90 ; initial y value
sideSize equ 20
xEdge equ 180
yEdge equ 180

CODESEG

proc DrawSquare
	; push bp
	; mov bp,sp
	; push ax
	; push bx
	push dx
	push cx

    ;mov cx,150;x value 
    ;mov dx,100;y value 
	mov [drawCounterForX],0
	mov [drawCounterForY],0
	DrawSquareLoop:	; Nested loop
	mov bh,0h
	mov al,4
	mov ah,0ch
	int 10h
	inc [drawCounterForX]
	inc cx
	cmp [drawCounterForX],sideSize
	jne DrawSquareLoop
	inc [drawCounterForY]
	mov [drawCounterForX],0
	inc dx
	pop cx; mov cx,150
	push cx; ...
	cmp [drawCounterForY],sideSize
	jne DrawSquareLoop
	
	pop cx	
	pop dx
	ret
endp 

proc DeleteSquare
	; push bp
	; mov bp,sp
	; push ax
	; push bx
	push dx
	push cx

   ; mov cx,150;x value 
   ; mov dx,100;y value 
	mov [drawCounterForX],0
	mov [drawCounterForY],0
	DeleteSquareLoop:	; Nested loop
	mov bh,0h
	mov al,0fBh
	mov ah,0ch
	int 10h
	inc [drawCounterForX]
	inc cx
	cmp [drawCounterForX],sideSize
	jne DeleteSquareLoop
	inc [drawCounterForY]
	mov [drawCounterForX],0
	inc dx
	pop cx; mov cx,150
	push cx; ...
	cmp [drawCounterForY],sideSize
	jne DeleteSquareLoop
	
	pop cx
	pop dx
	ret
endp 

;DELAY 500000 (0A120h).
proc delay 

	push cx
	push dx  
	  mov cx, 0      ;HIGH WORD.
	mov dx, 0A120h ;LOW WORD.
	mov ah, 86h    ;WAIT.
	int 15h
	pop dx
	pop cx
	ret
endp   
start:
	mov ax, @data
	mov ds,ax	
; --------------------------
; Your code here
; --------------------------
	mov ax,13h
	int 10h
	
DrawBall:

mov ch, 0
mov cl,[xPlace] ;x value 
mov dh, 0
mov dl,[yPlace] ;y value 
call DrawSquare
; mov ah,00h
; int 16h
call delay
call DeleteSquare
mov ah,00h
int 16h
cmp ah, 1h
je exit

inc [xPlace]
inc [yPlace]
mov ah, [xPlace]
mov al, [yPlace]
add ah, sideSize
add al, sideSize
cmp  ah, xEdge
jne DrawBall
cmp  al, yEdge
jne DrawBall

exit:
mov ah, 0
mov al, 2
int 10h
	
	mov ax, 4c00h
	int 21h
END start



