IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
drawCounterForX db 0
drawCounterForY db 0
xPlace db 150 ; initial x value
yPlace db 100 ; initial y value
sideSize equ 20
xEdge equ 255
yEdge equ 180

CODESEG

proc DrawSquare
	; push bp
	; mov bp,sp
	; push ax
	; push bx
	push cx
	push dx

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
	mov cx,150
	cmp [drawCounterForY],sideSize
	jne DrawSquareLoop
	
	pop dx
	pop cx	
	ret
endp 

proc DeleteSquare
	; push bp
	; mov bp,sp
	; push ax
	; push bx
	push cx
	push dx

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
	mov cx,150
	cmp [drawCounterForY],sideSize
	jne DeleteSquareLoop
	
	pop dx
	pop cx
	ret
endp 

;DELAY 500000 (7A120h).
proc delay 

	push cx
	push dx  
	system_time:   
	;GET SYSTEM TIME.
	  mov  ah, 2ch
	  int  21h ;RETURN HUNDREDTHS IN DL.
	;CHECK IF 20 HUNDREDTHS HAVE PASSED. 
	  ;xor  dh, dh   ;MOVE HUNDREDTHS...
	  mov  ax, dx   ;...TO AX REGISTER.
	  mov  bl, 1
	  div  bl       ;HUNDREDTHS / 20.
	  cmp  ah, 0    ;REMAINDER.
	  jnz  system_time
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
call delay
mov ch, 0
mov cl,[xPlace] ;x value 
mov dh, 0
mov dl,[yPlace] ;y value 
call DrawSquare
; mov ah,00h
; int 16h

call DeleteSquare
; mov ah,00h
; int 16h
; cmp ah, 1h
; je exit

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



