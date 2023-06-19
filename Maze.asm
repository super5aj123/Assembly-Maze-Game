include "emu8086.inc"
org 100h  

CURSOROFF
print "Use WASD to move the face to the heart. Good Luck!";Print the instructions
putc 010
putc 010
putc 010
putc 013



call MazeCreation



        
        
CHECKLOCATION:
    cmp Complete, 1 ;IDK why, but when I say to ret in the END jump, it just goes back to CHECKLOCATION, and lets you move around the void, so this is to stop that (If you want to see that for whatever reason, just comment out the jz CLOSE)
    jz CLOSE
    mov BH, CursorX
    mov BL, CursorY
    GOTOXY BH,BL 
    mov DL, CurrentPos
    mov PotPos, DL
    mov AH, 07h
    INT 21H ;Get the keypress from the user
    cmp AL, 77h ;W
    jz MOVUP
    cmp AL, 64h ;A 
    jz MOVRIGHT
    cmp AL, 73h ;S
    jz MOVDOWN
    cmp AL, 61h ;D
    jz MOVLEFT
    putc 007 ;Makes a sound if an incorrect key is pressed
    jmp CHECKLOCATION

    
    
        MOVUP: ;W  
        
            mov BH, CursorX ;Move the cursor to the potential moving location
            mov BL, CursorY
            dec BL
            GOTOXY BH,BL
            
            mov AH, 08h
            mov BH, 0 ;Get the value of the character above the current location in AL
            int 10h
            
            
            cmp AL, 32 
            jnz FAILED ;Check if that location is a 32 (Space)
            
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL ;Put a space where the character was
            putc 032
            
            dec CursorY ;If it is = to 32, it won't jump, and so the program should move the character
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL
            putc 002
            jmp CHECKLOCATION 
        
        
         
       
        
        
        
        
        jmp CHECKLOCATION    
            
        MOVRIGHT: ;A
            
             
            mov BH, CursorX ;Move the cursor to the potential moving location
            inc BH
            mov BL, CursorY
            GOTOXY BH,BL
            
            mov AH, 08h
            mov BH, 0 ;Get the value of the character to the right of the current location in AL
            int 10h
            
            
            cmp AL, 32 
            jnz FAILED ;Check if that location is a 32 (Space)
            
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL ;Put a space where the character was
            putc 032
            
            inc CursorX ;If it is = to 32, it won't jump, and so the program should move the character
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL
            putc 002
            jmp CHECKLOCATION
            
            
            
            
            
            
            
            
            
            
            
            
               
              
              
        MOVDOWN: ;S
            
            
            mov BH, CursorX ;Move the cursor to the potential moving location
            mov BL, CursorY
            inc BL
            GOTOXY BH,BL
            
            mov AH, 08h
            mov BH, 0 ;Get the value of the character below the current location in AL
            int 10h
            
            
            cmp AL, 32 
            jnz FAILED ;Check if that location is a 32 (Space)
            
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL ;Put a space where the character was
            putc 032
            
            inc CursorY ;If it is = to 32, it won't jump, and so the program should move the character
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL
            putc 002
            jmp CHECKLOCATION  
            
            
        MOVLEFT: ;D
            
            
            mov BH, CursorX ;Move the cursor to the potential moving location
            dec BH
            mov BL, CursorY
            GOTOXY BH,BL
            
            mov AH, 08h
            mov BH, 0 ;Get the value of the character to the left of the current location in AL
            int 10h
            
            cmp AL, 3
            jz END
            cmp AL, 32 
            jnz FAILED ;Check if that location is a 32 (Space)
            
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL ;Put a space where the character was
            putc 032
            
            dec CursorX ;If it is = to 32, it won't jump, and so the program should move the character
            mov BH, CursorX
            mov BL, CursorY
            GOTOXY BH,BL
            putc 002
            jmp CHECKLOCATION        
    
        
        FAILED:
            putc 007 ;beep
            jmp CHECKLOCATION
    
    
    
    
                



   
END:   
    call GoalReached
    mov Complete, 1    


    ret
    
CLOSE:
    ret    


MazeCreation PROC
    NEWLINE: 
    
    putc 10
    putc 13
    mov CurrentSpot, 0
    PRINTLINE:
        mov BX, CurrentSpace
        putc Maze+BX
        inc CurrentSpot
        inc CurrentSpace
        cmp CurrentSpace, 110
        jz CHECKLOCATION
        cmp CurrentSpot, 10
        jz NEWLINE
        jmp PRINTLINE
        ret 
        
MazeCreation ENDP

GoalReached PROC
    
    call CLEAR_SCREEN
    print "Congratulations! You have won!"
    mov Complete, 1
    ret
    
GoalReached ENDP    
    
    


  
  
  
Maze db 178,178,178,178,178,178,178,178,178,178   ;32 is a space (walkable), 178 is a dashed block (wall)
     db 178,32,32,32,178,32,178,178,32,178        ;2 is the start, 3 is the goal.
     db 178,178,178,32,32,32,32,32,32,178
     db 178,32,178,32,178,178,178,178,32,178
     db 178,32,32,32,32,32,32,178,32,178
     db 178,32,178,178,32,178,32,178,32,178
     db 178,32,32,32,32,178,32,178,32,178
     db 3,32,178,178,32,32,32,178,32,178
     db 178,32,32,178,178,178,178,32,32,178
     db 178,178,178,178,178,178,178,2,178,178
     db 178,178,178,178,178,178,178,178,178,178  

PotPos db 98
CurrentPos db 98  
CurrentSpace dw 0 ;Used for printing the maze
Complete db 0
       
;
CursorX db 7 ;Used to keep the location the cursor needs to be on the x (horizontal) axis
Cursory db 13 ;Used to keep the location the cursor needs to be on the y (vertical) axis

NewLineDivide dw 10 ;Used to track printing the maze
CurrentSpot dw 0



DEFINE_CLEAR_SCREEN         