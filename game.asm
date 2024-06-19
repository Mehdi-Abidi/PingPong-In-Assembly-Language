include Irvine32.inc

.data
str1 BYTE "PING PONG",0
str2 BYTE "1. Play the Game",0
str3 BYTE "Instructions: Player 1 can use w to move up and s to move down.",0
str4 BYTE "Player 2 can use i to move up and k to move down.",0
str5 BYTE "Both can use f to speed up and l to slow down.",0
str6 BYTE "Enter 1 to play or any key to exit: ",0
str7 BYTE "Made by, Rida (22k-4409), Mashal (22k-4552), Mehdi (22k-4480)",0

str8 BYTE "SCORE: 0",0
str9 BYTE "SPEED: ",0
str10 BYTE "Enter ESC to quit",0

str13 BYTE "Difficulty Level",0
str14 BYTE "1=>>> EASY",0
str15 BYTE "2=>>> MEDIUM",0
str16 BYTE "3=>>> HARD",0

str17 BYTE "you missed, player 1 won!!!",0
str18 BYTE "you missed, player 2 won!!!",0
str19 BYTE "game ended",0

str20 BYTE "player 1",0
str21 BYTE "player 2",0

ball BYTE "o",0
clear BYTE " ",0

missed BYTE "YOU MISSED. Enter r to play again.",0

str11 BYTE "Game has been stopped. Press ENTER to resume.",0
str12 BYTE "                                             ",0

vb BYTE "-",0
hb BYTE "|",0
bar BYTE "*",0
V BYTE 25
H BYTE 79

score DWORD 0
score1 DWORD 0
pau DWORD 0
start DWORD 1
cont DWORD 1
opt DWORD 1
speed DWORD ?
gspeed DWORD 50
count DWORD 0
p1 BYTE 5
p2 BYTE 5
px BYTE ?
py BYTE ?
down1 DWORD 0
up1 DWORD 0
down2 DWORD 0
up2 DWORD 0
startdir DWORD ?
x BYTE 40
y BYTE 6
control DWORD ?

lvl DWORD ?

.code

main PROC
mov eax, blue + (white*16)
call settextcolor
call menu
exit
main endp


menu PROC
call clrscr
mov dh,4
mov dl,34
call gotoxy
mov edx,OFFSET str1
call writestring
mov dh,10
mov dl,34
call gotoxy
mov edx,OFFSET str2
call writestring
mov dh,12
mov dl,34
call gotoxy
mov edx,OFFSET str3
call writestring
mov dh,13
mov dl,34
call gotoxy
mov edx,OFFSET str4
call writestring
mov dh,14
mov dl,34
call gotoxy
mov edx,OFFSET str5
call writestring
mov dh,16
mov dl,34
call gotoxy
mov edx,OFFSET str6
call writestring
mov dh,20
mov dl,34
call gotoxy
mov edx,OFFSET str7
call writestring
mov eax,0
call readchar
cmp al,49
jne _end
call level
_end:
ret
menu endp

level PROC
call clrscr
mov dh,4
mov dl,38
call gotoxy
mov edx,OFFSET str13
call writestring
mov dh,8
mov dl,38
call gotoxy
mov edx,OFFSET str14
call writestring
mov dh,10
mov dl,38
call gotoxy
mov edx,OFFSET str15
call writestring
mov dh,12
mov dl,38
call gotoxy
mov edx,OFFSET str16
call writestring
mov eax,0
call readchar
mov lvl,eax
mov eax,lvl
cmp eax,231h      ;1
je _start
cmp eax,332h      ;2
je _start
cmp eax,433h      ;3
je _start
jmp _incorrect
_start:
call play
_incorrect:
call menu
ret
level endp

gameborder PROC
call clrscr

mov ecx,0                          ;horizontal bondaries
mov cl,H                           ;H=79
sub ecx,2
mov eax,2
l1:
    mov dl,al
    mov dh,1
    call gotoxy
    mov edx,OFFSET vb              ;-
    call writestring
    mov dl,al
    mov dh,V                       ;v=25
    call gotoxy
    mov edx,OFFSET vb
    call writestring
    inc eax
loop l1

mov ecx,0                          ;vertical axis
mov cl,V
sub ecx,1
mov eax,1
l2:
   mov dl,2
   mov dh,al
   call gotoxy
   mov edx,OFFSET hb
   call writestring
   mov dl,H
   mov dh,al
   call gotoxy
   mov edx,OFFSET hb
   call writestring
   inc eax
loop l2

mov ecx,0               ;x-axis btw
mov cl,H
sub ecx,4
mov eax,3
l3:
   mov dl,al
   mov dh,4
   call gotoxy
   mov edx,OFFSET vb
   call writestring
   inc eax
loop l3

mov eax,lvl                ;deciding bar length
cmp eax,231h               ;1
je _easy
cmp eax,332h               ;2
je _medium
cmp eax,433h               ;3
je _hard
_easy:
mov ecx,5
jmp _over
_medium:
mov ecx,4
jmp _over
_hard:
mov ecx,3
_over:
mov eax,5

l4:                     ;printing bar on both sides
   mov dl,5
   mov dh,al
   call gotoxy
   mov edx,OFFSET bar
   call writestring
   mov dl,76
   mov dh,al
   call gotoxy
   mov edx,OFFSET bar
   call writestring
   inc eax
loop l4

mov dl,4
mov dh,2
call gotoxy
mov edx,OFFSET str20
call writestring
mov dl,70
mov dh,2
call gotoxy
mov edx,OFFSET str21
call writestring
mov dl,4
mov dh,3
call gotoxy
mov edx,OFFSET str8
call writestring
mov dl,V
mov dh,3
call gotoxy
mov edx,OFFSET str9
call writestring
mov dl,40
mov dh,3
call gotoxy
mov edx,OFFSET str10
call writestring
mov dl,70
mov dh,3
call gotoxy
mov edx,OFFSET str8
call writestring
ret
gameborder endp


play PROC
call gameborder

mov score,0                ;player1 score
mov score1,0               ;player2 score
mov pau,0                  ;pause
mov start,1  
mov cont,1                 ;continue
mov opt,1
mov speed,0                ;eax-delay
mov gspeed,200             ;print
mov count,0
mov p1,5
mov p2,5
mov px,0
mov py,0
mov down1,0
mov up1,0
mov down2,0
mov up2,0
mov startdir,0
mov x,40
mov y,6
mov control,0

call randomize
mov eax,4
call randomrange
mov startdir,eax               ;decides the direction of the ball
mov eax,15
call randomrange
add y,al                       ;random starting posi

mov eax,count                ;intializing speed=50
cmp eax,0
jne _skip
mov speed,50
mov dl,V
mov dh,3
call gotoxy
mov edx,OFFSET str9
call writestring
mov eax,gspeed
call writedec
_skip:

_while:
       mov eax,opt                    ;in the game - opt=1
       cmp eax,1
       jne _endwhile

       mov eax,cont               ;cont=1 when ball is moving
       cmp eax,1
       jne _skip1

       _while1:
               call readkey               ;key not pressed al=1
               cmp al,1
               jne _endwhile1
               mov eax,opt
               cmp opt,1
               jne _endwhile1

               mov eax,0
               mov al,x               ;px=x
               mov px,al
               mov al,y               ;py=y
               mov py,al
               mov dl,x
               mov dh,y
               call gotoxy
               mov edx,OFFSET ball
               call writestring
               mov eax,speed
               call delay
               mov dl,x
               mov dh,y
               call gotoxy
               mov edx,OFFSET clear
               call writestring

               mov eax,start              ;start=1 in the very beg
               cmp start,1
               jne _end1
               mov start,0
               mov eax,startdir        ;NW
               cmp eax,0
               jne _end11
               dec x
               inc y
               _end11:

               mov eax,startdir       ;SW
               cmp eax,1
               jne _end12
               dec x
               dec y
               _end12:

               mov eax,startdir       ;NE
               cmp eax,2
               jne _end13
               inc x
               inc y
               _end13:

              mov eax,startdir        ;SE
              cmp eax,3
              jne _end14
              inc x
              dec y
              _end14:
              _end1:

              mov eax,down1    ;cont NW, startdir=0
              cmp eax,1
              jne _end2
              dec x
              inc y
              _end2:

              mov eax,up1     ;cont SW, startdir=1
              cmp eax,1
              jne _end3
              dec x
              dec y
              _end3:

              mov eax,up2      ;cont  SE, startdir=3
              cmp eax,1
              jne _end4
              inc x
              dec y
              _end4:

              mov eax,down2     ;cont NE, startdir=2
              cmp eax,1
              jne _end5
              inc x
              inc y
              _end5:

              mov al,x           ;x<px && y>py
              cmp al,px
              jae _end6
              mov al,y
              cmp al,py
              jbe _end6
              mov down1,1
              _end6:

              mov al,x           ;x<px && y<py
              cmp al,px
              jae _end7
              mov al,y
              cmp al,py
              jae _end7
              mov up1,1
              _end7:

              mov al,x         ;x>px && y>py
              cmp al,px
              jbe _end8
              mov al,y
              cmp al,py
              jbe _end8
              mov down2,1
              _end8:

              mov al,x          ;x>px && y<py
              cmp al,px
              jbe _end9
              mov al,y
              cmp al,py
              jae _end9
              mov up2,1
              _end9:

              mov al,y
              cmp al,5
              jne _end10
              mov eax,up1
              cmp eax,1
              jne _end10
              mov down1,1
              mov up1,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end10:

              mov al,y
              cmp al,24
              jne _end21
              mov eax,down1
              cmp eax,1
              jne _end21
              mov up1,1
              mov down1,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end21:

              mov al,x
              cmp al,6
              jne _end22
              mov eax,up1
              cmp eax,1
              jne _end22
              mov up2,1
              mov up1,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end22:

              mov al,x
              cmp al,6
              jne _end23
              mov eax,down1
              cmp eax,1
              jne _end23
              mov down2,1
              mov down1,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end23:

              mov al,y
              cmp al,5
              jne _end24
              mov eax,up2
              cmp eax,1
              jne _end24
              mov down2,1
              mov up2,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end24:

              mov al,y
              cmp al,24
              jne _end25
              mov eax,down2
              cmp eax,1
              jne _end25
              mov up2,1
              mov down2,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end25:

              mov al,x
              cmp al,75
              jne _end26
              mov eax,down2
              cmp eax,1
              jne _end26
              mov down1,1
              mov down2,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end26:

              mov al,x
              cmp al,75
              jne _end27
              mov eax,up2
              cmp eax,1
              jne _end27
              mov up1,1
              mov up2,0
              sub speed,2
              add gspeed,2
              mov dl,V
              mov dh,3
              call gotoxy
              mov edx,OFFSET str9
              call writestring
              mov eax,gspeed
              call writedec
              _end27:

              mov al,x
              cmp al,75
              je _true1
              mov al,x
              cmp al,6
              jne _end28
              _true1:
              mov eax,speed
              call delay
              _end28:

              mov al,y
              cmp al,5
              je _true2
              mov al,y
              cmp al,24
              jne _end29
              _true2:
              mov eax,speed
              call delay
              _end29:




              mov al,x
              cmp al,6
              jne _end30
              mov al,y
              cmp al,p1
              jb _true3
              mov al,y
              mov bl,p1
              mov ecx,lvl
              cmp ecx,231h
              je _easy1
              cmp ecx,332h
              je _medium1
              cmp ecx,433h
              je _hard1
              _easy1:
              add bl,4
              jmp _over1
              _medium1:
              add bl,3
              jmp _over1
              _hard1:
              add bl,2
              _over1:
              cmp al,bl
              jbe _end30
              _true3:
              mov dl,x
              mov dh,y
              call gotoxy
              mov edx,OFFSET missed
              call writestring
              mov edx,OFFSET str18
              mov ebx,OFFSET str19
              call msgbox
              mov opt,0
              mov eax,0
              call readchar
              jmp _endwhile1
              _end30:

              mov al,x
              cmp al,75
              jne _end31
              mov al,y
              cmp al,p2
              jb _true4
              mov al,y
              mov bl,p2
              mov ecx,lvl
              cmp ecx,231h
              je _easy2
              cmp ecx,332h
              je _medium2
              cmp ecx,433h
              je _hard2
              _easy2:
              add bl,4
              jmp _over2
              _medium2:
              add bl,3
              jmp _over2
              _hard2:
              add bl,2
              _over2:
              cmp al,bl
              jbe _end31
              _true4:
              mov dl,x
              mov dh,y
              call gotoxy
              mov edx,OFFSET missed
              call writestring
              mov edx,OFFSET str17
              mov ebx,OFFSET str19
              call msgbox
              mov opt,0
              mov eax,0
              call readchar
              jmp _endwhile1
              _end31:

              mov al,x
              cmp al,6
              jne _end32
              mov eax,opt
              cmp eax,1
              jne _end32
              mov dl,4
              mov dh,3
              call gotoxy
              mov edx,OFFSET str8
              call writestring
              inc score
              mov eax,score
              call writedec
              _end32:

              mov al,x
              cmp al,75
              jne _end33
              mov eax,opt
              cmp eax,1
              jne _end33
              mov dl,70
              mov dh,3
              call gotoxy
              mov edx,OFFSET str8
              call writestring
              inc score1
              mov eax,score1
              call writedec
              _end33:

              jmp _while1
       _endwhile1:
       _skip1:

       mov control,eax

mov eax,control
cmp eax,3920h          ;space - pause
jne _endif1
mov eax,opt
cmp opt,1
jne _endif1
mov pau,1
mov cont,0
mov dl,22
mov dh,12
call gotoxy
mov edx, OFFSET str11
call writestring
mov eax,0
call readchar
mov control,eax
_endif1:


mov eax,control 
cmp al,13                    ;enter - continue
jne _endif2
mov eax,opt
cmp opt,1
jne _endif2
mov eax,pau
cmp eax,1
jne _endif2
mov pau,0
mov cont,1
mov dl,22
mov dh,12
call gotoxy
mov edx,OFFSET str12
call writestring
_endif2:

mov eax,control                   ;r - replay
cmp eax,1372h
je _andcond
mov eax,control
cmp eax,1352h
jne _endif3
_andcond:
mov eax,opt
cmp eax,0
jne _endif3
mov opt,1
mov count,0
call play
jmp _endwhile
_endif3:

mov eax,control          ;f - inc speed
cmp eax,2166h
je _andcond1
mov eax,control
cmp eax,2146h
jne _endif4
_andcond1:
mov eax,speed
cmp eax,20
jb _endif4
sub speed,5
add gspeed,5
mov dl,V
mov dh,3
call gotoxy
mov edx,OFFSET str9
call writestring
mov eax,gspeed
call writedec
inc count
_endif4:

mov eax,control            ;esc - menu
cmp eax,011Bh
jne _endif5
call menu
mov eax,0
_endif5:

mov eax,control        ;L - dec speed
cmp eax,266Ch
je _cond
mov eax,control
cmp eax,264Ch
jne _endif6
_cond:
add speed,5
sub gspeed,5
mov dl,V
mov dh,3
call gotoxy
mov edx,OFFSET str9
call writestring
mov eax,gspeed
call writedec
inc count
_endif6:

mov eax,control       ;w
cmp eax,1177h
je _andcond2
mov eax,control
cmp eax,1157h
jne _endif7
_andcond2:
mov al,p1
cmp al,5
jbe _endif7
mov dl,5
mov dh,p1
dec dh
call gotoxy
mov edx,OFFSET bar
call writestring
mov dl,5
mov dh,p1
mov ecx,lvl
cmp ecx,231h
je _easy3
cmp ecx,332h
je _medium3
cmp ecx,433h
je _hard3
_easy3:
add dh,4
jmp _over3
_medium3:
add dh,3
jmp _over3
_hard3:
add dh,2
_over3:
call gotoxy
mov edx,OFFSET clear
call writestring
dec p1
_endif7:

mov eax,control       ;s
cmp eax,1F73h
je _andcond3
mov eax,control
cmp eax,1F53h
jne _endif8
_andcond3:
mov al,p1
cmp al,19
ja _endif8
mov dl,5
mov dh,p1
mov ecx,lvl
cmp ecx,231h
je _easy4
cmp ecx,332h
je _medium4
cmp ecx,433h
je _hard4
_easy4:
add dh,5
jmp _over4
_medium4:
add dh,4
jmp _over4
_hard4:
add dh,3
_over4:
call gotoxy
mov edx,OFFSET bar
call writestring
mov dl,5
mov dh,p1
call gotoxy
mov edx,OFFSET clear
call writestring
inc p1
_endif8:

mov eax,control        ;k
cmp eax,256Bh
je _andcond4
mov eax,control
cmp eax,254Bh
jne _endif9
_andcond4:
mov al,p2
cmp al,19
ja _endif9
mov dl,76
mov dh,p2
mov ecx,lvl
cmp ecx,231h
je _easy5
cmp ecx,332h
je _medium5
cmp ecx,433h
je _hard5
_easy5:
add dh,5
jmp _over5
_medium5:
add dh,4
jmp _over5
_hard5:
add dh,3
_over5:
call gotoxy
mov edx,OFFSET bar
call writestring
mov dl,76
mov dh,p2
call gotoxy
mov edx,OFFSET clear
call writestring
inc p2
_endif9:

mov eax,control         ;i
cmp eax,1769h
je _andcond5
mov eax,control
cmp eax,1749h
jne _endif10
_andcond5:
mov al,p2
cmp al,5
jbe _endif10
mov dl,76
mov dh,p2
dec dh
call gotoxy
mov edx,OFFSET bar
call writestring
mov dl,76
mov dh,p2
mov ecx,lvl
cmp ecx,231h
je _easy6
cmp ecx,332h
je _medium6
cmp ecx,433h
je _hard6
_easy6:
add dh,4
jmp _over6
_medium6:
add dh,3
jmp _over6
_hard6:
add dh,2
_over6:
call gotoxy
mov edx,OFFSET clear
call writestring
dec p2
_endif10:

jmp _while
_endwhile:
ret
play endp

end main
