.model large
.stack 1000h
.data
new_line db 10,13,'$'
a40 db 10,13, 'Hamza$'
a41 db 10,13, 'Qatadha$'
a42 db 10,13, 'Ali bilal$'

a1 db 10,13,'                   ***************************************$'
a2 db 10,13,'                   *                                      *$'
a3 db 10,13,'                   *         Contact Book                 *$'
a4 db 10,13,'                   *                                      *$'
a5 db 10,13,'                   *                                      *$'
a6 db 10,13,'                   ****************************************$'

a7 db 10,13,'                      Enter your choice: $'
a8 db 10,13,'                      Press any key to display menu: $'

a9  db 10,13,'                    /\/\/\/\/\/\/\/\/\/|MENU|\/\/\/\/\/\/\/\$'
a10 db 10,13,'                    |  1. Add contact                      |$'
a11 db 10,13,'                    |  2. View contacts                    |$'
a14 db 10,13,'                    |  3. Search contact                   |$'
a15 db 10,13,'                    |  4. Exit                             |$'  
a16 db 10,13,'                    \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/$'

menu_msg db 10,13,'Contact Book Menu:$'
opt1 db 10,13,'1. Add Contact$'
opt2 db 10,13,'2. View Contacts$'
opt3 db 10,13,'3. Search Contact$'
opt4 db 10,13,'4. Exit$'
prompt db 10,13,'Enter your choice: $'
invalid_msg db 10,13,'Invalid input! Please select a valid option.$'

name_prompt db 10,13,'Enter name: $'
phone_prompt db 10,13,'Enter phone: $'
search_prompt db 10,13,'Enter name to search: $'
not_found_msg db 10,13,'Contact not found!$'
display db 10,13,'No contact to display!$'
found_msg db 10,13,'Contact found:$'
full_msg db 10,13,'Contact book is full!$'
No_msg db 10,13,'No contact to display!$'
newline db 10,13,'$' 

delete_prompt_msg db 10,13,'Enter the name to delete: $'  
delete_confirm_msg db 10,13,'Contact deleted successfully.$'
not_found_delete_msg db 10,13,'No contact found with that name.$'

delete_input_buffer db name_size dup('$')  

max_contacts equ 10
name_size equ 20
phone_size equ 15

contacts_name db max_contacts * name_size dup('$')
contacts_phone db max_contacts * phone_size dup('$')
contact_count db 0
temp_buffer db 30 dup('$')

.code
.startup


     MOV BL,10                   
     MOV AH,9 
     MOV AL,0  
     INT 10H

; Display names
lea dx, a40
mov ah, 09h
int 21h

lea dx, new_line
mov ah, 09h
int 21h

lea dx, a41
mov ah, 09h
int 21h

lea dx, new_line
mov ah, 09h
int 21h

lea dx, a42
mov ah, 09h
int 21h

; Display the title box
lea dx, a1
mov ah, 09h
int 21h
lea dx, a2
mov ah, 09h
int 21h
lea dx, a3
mov ah, 09h
int 21h
lea dx, a4
mov ah, 09h
int 21h
lea dx, a5
mov ah, 09h
int 21h
lea dx, a6
mov ah, 09h
int 21h 

; Main input loop
valid:
lea dx, new_line
mov ah, 09h
int 21h

lea dx, a8
mov ah, 09h
int 21h  

mov ah, 1    
int 21h      
jmp display_menu  

; Display main menu
display_menu:
lea dx, new_line
mov ah, 09h
int 21h

lea dx, a9
mov ah, 09h
int 21h
lea dx, a10
mov ah, 09h
int 21h
lea dx, a11
mov ah, 09h
int 21h

lea dx, a14
mov ah, 09h
int 21h
lea dx, a15
mov ah, 09h
int 21h
lea dx, a16
mov ah, 09h
int 21h

lea dx, new_line
mov ah, 09h
int 21h



lea dx, prompt
mov ah, 09h
int 21h

mov ah, 1
int 21h

cmp al, '1'
je add_contact
cmp al, '2'
je view_contacts
cmp al, '3'
jne not_search
jmp search_contact

not_search:
cmp al, '4'
je exit_program

lea dx, invalid_msg
    mov ah, 9
    int 21h
    jmp display_menu

exit_program:
mov ah, 4ch
int 21h

; Add Contact procedure
add_contact proc
    mov al, contact_count
    cmp al, max_contacts
    jae full_book
    
    lea dx, name_prompt
    mov ah, 9
    int 21h
    
    xor ax, ax
    mov al, contact_count
    mov bx, name_size
    mul bx
    lea di, contacts_name
    add di, ax
    
    ; Read name
    mov cx, name_size-1
    mov ah, 1
    name_input:
        int 21h
        cmp al, 13  
        je end_name
        mov [di], al
        inc di
        loop name_input
    end_name:
    

    lea dx, phone_prompt
    mov ah, 9
    int 21h
    
    xor ax, ax
    mov al, contact_count
    mov bx, phone_size
    mul bx
    lea di, contacts_phone
    add di, ax
    
    mov cx, phone_size-1
    mov ah, 1
    phone_input:
        int 21h
        cmp al, 13  
        je end_phone
        mov [di], al
        inc di
        loop phone_input
    end_phone:
    
    inc contact_count
    jmp display_menu
    
    full_book:
        lea dx, full_msg
        mov ah, 9
        int 21h
        jmp display_menu
add_contact endp

; View Contacts procedure
view_contacts proc
    cmp contact_count, 0         
    je no_contacts_found         

    xor cx, cx                   
    mov cl, contact_count        
    xor bx, bx                   

display_loop:
    push cx                      

    ; Print a newline
    lea dx, newline
    mov ah, 9
    int 21h

    ; Print contact name
    mov ax, bx                   ; BX contains the current index
    mov dx, name_size            ; Multiply index by name size
    mul dx
    lea si, contacts_name        ; Base address of names
    add si, ax                   ; Point to the correct name
    mov dx, si
    mov ah, 9
    int 21h

    ; Print a newline
    lea dx, newline
    mov ah, 9
    int 21h

    ; Print contact phone
    mov ax, bx                   ; BX contains the current index
    mov dx, phone_size           ; Multiply index by phone size
    mul dx
    lea si, contacts_phone       ; Base address of phone numbers
    add si, ax                   ; Point to the correct phone number
    mov dx, si
    mov ah, 9
    int 21h

    inc bx                       ; Increment the index
    pop cx                       ; Restore CX from the stack
    loop display_loop            ; Repeat for all contacts

    jmp return_to_menu           ; Go back to menu

no_contacts_found:
    lea dx, No_msg      ; Load address of "No contacts" message
    mov ah, 9
    int 21h                      ; Display the message

return_to_menu:
    jmp display_menu             ; Return to the main menu
view_contacts endp


; Search Contact procedure
search_contact proc
   
    lea dx, search_prompt
    mov ah, 9
    int 21h
    

    lea di, temp_buffer
    mov cx, name_size-1
    mov ah, 1
    search_input:
        int 21h
        cmp al, 13 
        je end_search_input
        mov [di], al
        inc di
        loop search_input
    end_search_input:
    mov byte ptr [di], '$'  
    
   
    xor cx, cx
    mov cl, contact_count
    xor bx, bx  
    
    search_loop:
        push cx
        push bx
        
        
        mov ax, bx
        mov dx, name_size
        mul dx
        lea si, contacts_name
        add si, ax
        
        
        lea di, temp_buffer
        compare_chars:
            mov al, [si]
            mov bl, [di]
            cmp al, '$'    
            je check_end
            cmp bl, '$'
            je next_contact
            cmp al, bl      
            jne next_contact
            inc si
            inc di
            jmp compare_chars
            
        check_end:
            cmp bl, '$'    
            je found_match
            
        next_contact:
            pop bx
            inc bx
            pop cx
            loop search_loop
        
   
    lea dx, not_found_msg
    mov ah, 9
    int 21h
    jmp display_menu
    
    found_match:
        pop bx    
        pop cx
        
        lea dx, found_msg
        mov ah, 9
        int 21h
        
     
        mov ax, bx
        mov dx, name_size
        mul dx
        lea si, contacts_name
        add si, ax
        mov dx, si
        mov ah, 9
        int 21h
        
        lea dx, newline
        int 21h
        

        mov ax, bx
        mov dx, phone_size
        mul dx
        lea si, contacts_phone
        add si, ax
        mov dx, si
        mov ah, 9
        int 21h
        
        jmp display_menu
search_contact endp
end
