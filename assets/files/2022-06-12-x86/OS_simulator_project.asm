title Operating System Simulator
include Irvine32.inc

;	Operating System Simulator
;	
;	          Authors
;	------------------------------
;	Karl ----  | ------
;	Luke ----  | ------



; ============================================================ Macros and structs

    ; describes a parameter type a command takes
    COMMAND_PARAM struct
        name_string dword ?     ; an address to a name string for the parameter
        desc_string dword ?     ; an address to a description string for the parameter
        function dword ?        ; an address to a validator function
        p_type byte -1          ; 0 = string, 1 = number, -1 if none
        min dword 0             ; a minimum number if type of param is number, or minimum length if type is string
        max dword 0             ; a maximum number if type of param is number, or maximum length if type is string
    COMMAND_PARAM ends

    ; associates a procedure with a command string and parameters
    COMMAND struct
        function dword ?        ; an address to an associated function
        string dword ?          ; an address to an associated string, the name of a command, which input will be matched to
        desc_string dword ?     ; an address to an associated description for printing help
        param1 dword ?          ; an address to a parameter type
        param2 dword ?          ; an address to a parameter type
        param3 dword ?          ; an address to a parameter type
    COMMAND ends
	
	; job modes determine which list a job is part of, or whether it is junk data
	MODE_INACTIVE equ 0
	MODE_HOLD equ 1
	MODE_RUN equ 2
	
    ; A job is also a node in a doubly linked list.
    ; There are two possible linked lists for which it can be a member - Run or Hold
    ; Mode indicates what list it is a member of
    ; If mode is inactive, the job does not exist and can be overwritten
    JOB struct                  ; information about a job
        job_name byte "DeMoJoBx", 0
		priority byte 0         ; the highest priority is 0
		time byte 1
		mode byte MODE_INACTIVE
        next dword 0            ; jobs are linked lists
        previous dword 0        ; jobs are linked lists
    JOB ends
	
; =========================================================== State Data

 .data
    ; global program settings, controls state & what is printed by print_visible_structures
    program_settings word 0000000000000000b
    ; macros for bit tests, each equal to a bit index counting from the low bit
    settings_helpshowing equ 0              ; whether help screen is showing
    settings_jobshowing equ 1               ; whether jobs table is showing
    settings_debugshowing equ 2             ; whether debug table is showing
	quit byte 0			; Flag to quit the program
	system_clock dword 0 ; The simulated system clock

; =========================================================== Print Procedures
  .data
  long_clear_string byte "                                                                                            ", 0
  .code 
 ; ===================================== Initialize Printing
    .data
        outHandle HANDLE ?                      ; windows console output handle for api functions
        original_console_out_settings DWORD ?   ; original console mode, for restoring when program is done
        _o_mode_eol_wrap equ 1                  ; amount of bit offset (for bit 2) of console output mode to control end of line wrap (1 == enable)
                                                ;  we disable end of line wrap for slightly better appearance on a mis-sized buffer
		
		console_title byte "Operating System Simulator", 0	; Name of console window
        inHandle HANDLE ?  ; only used for flushing input buffer on prompt flash
	.code 
    initialize_printing proc
        ; ---------------------------------------------------------------------------------------------------------------
        ; initialize_printing
        ;
        ; gets the HANDLE dword for the console so we can use the Windows API and stores it in the global mem location outHandle
        ;    @see Microsoft Docs and SmallWin.inc for info about Windows API
        ; ---------------------------------------------------------------------------------------------------------------
        push eax
        pushf
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov outHandle, eax
        invoke GetConsoleMode, outHandle, OFFSET original_console_out_settings  ; get the current console mode
        mov eax, original_console_out_settings  
        btc eax, _o_mode_eol_wrap       ; the point of this to improve viewing on a mis-sized window, but only made a minor difference
        invoke SetConsoleMode, outHandle, eax ;  ; but at least the right text wont overflow to the left
		invoke SetConsoleTitle, offset console_title

        invoke GetStdHandle, STD_INPUT_HANDLE
        mov inHandle, eax 

        popf
        pop eax
        ret
    initialize_printing endp

 ; ===================================== Mobile Coordinate
    .data
        print_coords COORD <?,?>
    .code
    print_coord_down proc
        ; ----------------------------------------------------------------
        ; print_coord_down
        ;
        ; changes the second word in print_coords by 1
        ; invokes SetConsoleCursor Position to move cursor down 1
        ; ---------------------------------------------------------------
        pushad                             ; save eax
        mov eax, print_coords               ; mov the pair of words to eax
        rol eax, 16                          ; move the second word into position
        inc ax                               ; increment that word
        rol eax, 16                          ; return to the original arrangement
        mov print_coords, eax                ; save in memory
        invoke SetConsoleCursorPosition, outHandle, print_coords
        popad                              ; restore eax
        ret
    print_coord_down endp

    print_coord_up proc
        ; ----------------------------------------------------------------
        ; print_coord_up
        ;
        ; changes the second word in print_coords by 1
        ; invokes SetConsoleCursor Position to move cursor up 1
        ; ---------------------------------------------------------------
        pushad
        mov eax, print_coords
        rol eax, 16
        dec ax
        rol eax, 16
        mov print_coords, eax
        invoke SetConsoleCursorPosition, outHandle, print_coords
        popad
        ret
    print_coord_up endp

    print_coord_right_by_eax proc
        ; -----------------------------------------------------------------
        ; print_coord_right_by_eax
        ;
        ; moves the print coordinate right by a number given in ax
        ;   RECEIVES ax: the number of columns to shift the cursor right by
        ; ------------------------------------------------------------------
        pushad
        mov ebx, print_coords
        add bx, ax
        mov print_coords, ebx
        invoke SetConsoleCursorPosition, outHandle, print_coords
        popad
        ret
    print_coord_right_by_eax endp

 ; ===================================== Print Box Layout
 
	.data
		box_coord COORD <0,0>   ; top left of box
		box_size COORD <8,3>    ; width, height of box
		box_shadow byte 1       ; whether to draw a shadow around the box
		
		SHADOW_COLOR dword 144    ; shadow color
		SHADOW_CHAR equ ' '     ; shadow character
		BOX_COLOR dword 112       ; box color
		
	.code
		print_box_line proc
            ; ----------------------------------------------------------------------------
            ; print_box_line
            ;
            ; prints a horizontal line of box graphics, adding shadow colors as necessary.
            ; called only by print_box as it draws the box graphics.
            ;   RECEIVES al - the character to write
            ; ----------------------------------------------------------------------------
			push eax
			push ecx
			
			movzx ecx, box_size.X		; Initialize horizontal iterator
			
			write_line:					; Write x=width spaces
				call WriteChar
				loop write_line
			
			pop ecx						; Restore current vertical iteration
			
			add_shadow:					; Add the right-aligned shadow if...
				cmp cx, box_size.Y		;	- The vertical iteration isn't at the top
				je  done
				cmp box_shadow, 0		;	- Box shadow flag is set
				je  done
				
				mov eax, SHADOW_COLOR	; Set the shadow color
				call SetTextColor
				mov al, SHADOW_CHAR		; Set the shadow character
				call WriteChar			; Write the shadow
			
			done:
				pop eax
				ret
		print_box_line endp
		
		print_box proc
            ; ----------------------------------------------------------------------------------
            ; print_box
            ;
            ; prints a box starting at box_coord of size box_size. Adds a shadow around the box.
            ; the shadow will be box_shadow characters larger than the size in box box_size.
            ; ----------------------------------------------------------------------------------
			pushad

            call GetTextColor       ; EAX::original_text_color = GetTextColor()
            push eax                ; save the original text color

			mov eax, box_coord			; Set the coordinates of the box corner
			mov print_coords, eax
			invoke SetConsoleCursorPosition, outHandle, print_coords
			
			movzx ecx, box_size.Y		; Auto-loop [box height] times
			
			print_each_line:
				mov eax, BOX_COLOR		; Set box color
				call SetTextColor
				mov al, ' '				; Blank character
				
				call print_box_line		; Draw the line
				call print_coord_down	; Move down 1
				
				loop print_each_line
			
			add_shadow:
				cmp box_shadow, 0		; Finish the bottom shadow if (box_shadow == 1)
				je  done
				
				mov eax, gray			; Start the shadow one space over
				call SetTextColor
				mov al, ' '
				call WriteChar
				
				mov eax, SHADOW_COLOR	; Update the shadow color and character
				call SetTextColor
				mov al, SHADOW_CHAR
				
				dec box_size.X			; Temporarily decrement the width to correctly align the shadow
				call print_box_line		; Print the shadow
				inc box_size.X			; Restore box width
				
			done:
				pop eax                 ; EAX::original_text_color = runtime_stack.pop()
			    call SetTextColor       ; restore original color
				popad
				ret
		print_box endp
		
        clear_box proc
            ; -------------------------------------------------------------------------------------------------------------
            ; clear_box
            ;
            ; clears the box described by the box size and box coordinate mem locations by writing whitespace over the area
            ; clears the *last* box. So only 1 box should be drawn at a time unless Clrscr is used.
            ; -------------------------------------------------------------------------------------------------------------
            pushad

            invoke SetConsoleCursorPosition, outHandle, box_coord   ; set cursor to top left of box
            mov eax, box_coord
            mov print_coords, eax                                   ; save top left coord in our mobile print coords
            mov al, ' '                                             ; will be writing space characters to clear

            movzx ecx, box_size.Y                     ; loop vertical size is equal to box_size.Y
            movzx edx, box_size.X                     ; loop horizontal size is equal to box_size.X
            cmp box_shadow, 1                       ; but if it has a shadow, box_size.Y + 1, box_size.X + 1
            je has_shadow
            jmp loop_through_y_coords
            has_shadow:
                add ecx, 1
                add edx, 1
            loop_through_y_coords:
                mov esi, 0
                loop_through_width:
                    call WriteChar
                    inc esi
                    cmp esi, edx
                    jl loop_through_width
                call print_coord_down
                loop loop_through_y_coords
			
			mov SHADOW_COLOR, 144    ; Quick and dirty color reset fix
			mov BOX_COLOR, 112
			
            popad
            ret
        clear_box endp
		print_box_header proc
			; ---------------------------------------------------------
			;	Center a string from EDX into the last created box
			; ---------------------------------------------------------
			pushad
			
			mov esi, edx
			call get_string_size	; ECX = Get string size
			dec ecx

            call GetTextColor       ; EAX::original_text_color = GetTextColor()
            push eax                ; save the original text color
			
			movzx eax, box_size.X	; Get width of box
			add eax, 5
			shr eax, 1				; Divide width by 2. (Right bitshift is the same as dividing by 2)
			shr ecx, 1				; Divide string size by 2
			sub eax, ecx			; Start X of string
			
			mov cx, box_coord.Y		; Set coordinate to box Y position
			mov print_coords.Y, cx	
			mov print_coords.X, ax	; Set coordinate X to AX
			invoke SetConsoleCursorPosition, outHandle, print_coords
			
			mov eax, BOX_COLOR		; Set box color
			call SetTextColor
			mov edx, esi			; Restore string from ESI
			call WriteString
			
            pop eax                 ; EAX::original_text_color = runtime_stack.pop()
			call SetTextColor       ; restore original color
			
			popad
			ret
		print_box_header endp
		
		

 ; ===================================== Print Errors
    .data
        coord_error_print COORD <21,2>
    .code
    print_error proc 
        ; ------------------------------------------------------------
        ; print_error
        ;
        ; prints a red error message at the coord_error_print location
        ;   RECEIVES: edx - address of a string to print.
        ; -------------------------------------------------------------
        push eax
        push ebx
        push edx
        invoke SetConsoleCursorPosition, outHandle, coord_error_print
        call GetTextColor
        mov ebx, eax            ; save old text color
        mov eax, red
        call SetTextColor
        pop edx
        call WriteString
        push edx
        mov eax, ebx
        call SetTextColor       ; restore old text color
        pop edx
        pop ebx
        pop eax
        ret
    print_error endp
    .data
        clear_error_line byte "                                           ", 0
    .code
    clear_error proc
        ;---------------------------------------------------------
        ; clear_error
        ;
        ; clears the error message area by printing a blank line
        ; --------------------------------------------------------
        push edx 
        push eax 
        invoke SetConsoleCursorPosition, outHandle, coord_error_print
        mov edx, offset clear_error_line
        call WriteString 
        pop eax 
        pop edx
        ret 
    clear_error endp
 ; ===================================== Print Prompt
    .data
        text_prompt byte           " Enter Command >> ", 0
        coord_prompt COORD <3,3>
        coord_input COORD <21,3>
    .code
    print_prompt proc
        ; ---------------------------------------------------------------------------
        ; print_prompt
        ;
        ; prints the command prompt string at the location specified by coord_prompt
        ; ---------------------------------------------------------------------------
        pushad 
        invoke SetConsoleCursorPosition, outHandle, coord_prompt
        call GetTextColor
        push eax
        mov eax, cyan ;+ (blue*16)
        call SetTextColor
        mov edx, offset text_prompt
        call WriteString
        pop eax
        call SetTextColor
        popad
        ret 
    print_prompt endp

    flash_prompt proc
        ; --------------------------------------------------------------------------------------------------------------------------
        ; flash_prompt
        ;
        ; Called when user enters empty input
        ; Flashes the command prompt by printing it in yellow, 1 letter at a time. Clears the input buffer after, to disregard any input entered during flash.
        ; --------------------------------------------------------------------------------------------------------------------------
        pushad 
        call print_prompt 
        invoke SetConsoleCursorPosition, outHandle, coord_prompt
        mov eax, coord_prompt
        mov print_coords, eax
        call GetTextColor
        push eax 
        mov eax, yellow
        call SetTextColor
        mov ecx, 18
        mov ebx, 0
        while_chars_left_to_print:
            mov al, text_prompt[ebx]
            call WriteChar
            mov eax, 1
            call Delay
            mov eax, 1
            call print_coord_right_by_eax
            inc ebx 
            cmp ebx, ecx
            jl while_chars_left_to_print

        pop eax
        call SetTextColor
        invoke FlushConsoleInputBuffer, inHandle
        popad
        ret
    flash_prompt endp
    .data
        clear_long_string byte 100 dup(" ")
        byte 0
    .code
    clear_input_area proc
        ; ---------------------------------------------------------------------
        ; clear_input_area
        ;
        ; prints whitespace over the input area to clear it.
        ; ---------------------------------------------------------------------
        push eax
        push edx 
        invoke SetConsoleCursorPosition, outHandle, coord_input
        mov edx, offset clear_long_string
        call WriteString
        pop edx
        pop eax
        ret 
    clear_input_area endp
 
 ; ===================================== Print Feedback
    .data
        coord_feedback_time COORD <3, 5>
        coord_feedback_text COORD <16, 5>
        feedback_tick_string byte "Tick ", 0
        feedback_was_shown byte 1       ; flag
    .code 

    set_for_printing_command_feedback proc
        ; ---------------------------------------------------------------------------------------
        ; show_feedback_next_draw
        ;
        ; Prints the time in white and leaves the cursor in position to print a feedback message. 
        ; ---------------------------------------------------------------------------------------
        push eax
        mov feedback_was_shown, 0
        invoke SetConsoleCursorPosition, outHandle, coord_feedback_time
        call GetTextColor
        push eax 
        mov eax, white
        call SetTextColor
        mov edx, offset feedback_tick_string
        call WriteString
        mov eax, system_clock
        call WriteDec
        invoke SetConsoleCursorPosition, outHandle, coord_feedback_text
        pop eax
        call SetTextColor
        pop eax
        ret
    set_for_printing_command_feedback endp 

    print_in_green proc
        ; -------------------------------------------------------------------
        ; print_in_green
        ;
        ; prints the contents of edx in green, wherever the cursor is at
        ;   RECEIVES - edx - address of a char array to print in green
        ; -------------------------------------------------------------------
        push eax
        call GetTextColor
        push eax
        mov eax, green
        call SetTextColor
        call WriteString
        pop eax
        call SetTextColor
        pop eax 
        ret
    print_in_green endp

    print_int_in_green proc
        ; -------------------------------------------------------------------
        ; print_int_in_green
        ;
        ; prints the contents of eax as a decimal in green
        ;   RECEIVES - eax - a number to print
        ; -------------------------------------------------------------------
        push eax 
        push ebx
        mov ebx, eax
        call GetTextColor
        push eax
        mov eax, green
        call SetTextColor
        mov eax, ebx
        call WriteDec
        pop eax
        call SetTextColor
        mov eax, ebx
        pop ebx
        pop eax
        ret
    print_int_in_green endp
    possibly_clear_command_feedback proc
        ; ----------------------------------------------------------------------------------------------
        ; possibly_clear_command_feedback
        ;
        ; checks flag to see if feedback has been seen by user yet. If it has, clears the feedback area.
        ; ----------------------------------------------------------------------------------------------
        push eax
        push edx
        cmp feedback_was_shown, 0
        jne clear_feedback_area
        jmp wait_to_clear_feedback_area
        clear_feedback_area:
            invoke SetConsoleCursorPosition, outHandle, coord_feedback_time
            mov edx, offset long_clear_string
            call WriteString
            jmp finish_up
        wait_to_clear_feedback_area:
            mov feedback_was_shown, 1
        finish_up:

        pop edx
        pop eax
        ret
    possibly_clear_command_feedback endp 
    

 ; ===================================== Print Param Prompt
    .data
        coord_param_prompt COORD <21, 4>
        param_prompt_intro byte "Input of ", 0
        param_prompt_continue byte " is invalid for parameter of type ", 0
        param_prompt_needed byte "Required: ", 0
        param_prompt_enter byte "Enter input >> ", 0

        coord_param_box_start COORD <21, 3>
        param_box_color dword (white + (magenta * 16))
        param_box_shadow dword (white + (brown * 16))
        param_box_size COORD <62, 5>
    .code

    print_parameter_prompt proc
        ; --------------------------------------------------------------------------------------
        ; print_parameter_prompt
        ;
        ; prints a description of the invalid parameter. Leaves cursor at a new input location.
        ;   RECEIVES ecx - an address to the parameter type to prompt for
        ; ---------------------------------------------------------------------------------------
        pushad 
        call GetTextColor
        push eax
        push ecx
        mov eax, param_box_color
        call SetTextColor 
        mov ebx, coord_param_box_start
        mov box_coord, ebx
        mov ebx, param_box_size
        mov box_size, ebx
        mov ebx, param_box_color 
        mov BOX_COLOR, ebx
        mov ebx, param_box_shadow 
        mov SHADOW_COLOR, ebx
        call print_box
        mov ebx, coord_param_prompt
        mov print_coords, ebx
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov edx, offset param_prompt_intro
        call WriteString
        mov edx, offset token_buffer
        call WriteString
        mov edx, offset param_prompt_continue
        call WriteString
        pop ecx 
        mov edx, (COMMAND_PARAM PTR[ecx]).name_string
        push ecx
        call WriteString
        call print_coord_down
        mov edx, offset param_prompt_needed
        call WriteString
        pop ecx 
        mov edx, (COMMAND_PARAM PTR [ecx]).desc_string
        call WriteString
        call print_coord_down
        mov edx, offset param_prompt_enter
        call WriteString
        ;mov edx, offset long_clear_string
        ;call WriteString
        ;invoke SetConsoleCursorPosition, outHandle, print_coords
        ;mov edx, offset param_prompt_enter
        ;call WriteString
        pop eax
        call SetTextColor
        popad 
        ret
    print_parameter_prompt endp

    clear_parameter_prompt proc
        ; ------------------------------------------------------
        ; clear_parameter_prompt
        ;
        ; clears the parameter prompt area by writing whitespace
        ; ------------------------------------------------------
        pushad
        mov ebx, coord_param_box_start
        mov box_coord, ebx
        mov ebx, param_box_size
        mov box_size, ebx
        call clear_box
        mov ebx, coord_param_prompt
        mov print_coords, ebx
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov edx, offset long_clear_string
        call WriteString
        ;call print_coord_down
        ;call WriteString
        ;call print_coord_down
        ;call WriteString
        popad
        ret
    clear_parameter_prompt endp
 ; ===================================== Print Misc

    .data
        prog_title_string byte " G8P3.asm ", 0 
        coord_prog_title COORD <1,1>
    .code
    print_title proc
        ; ----------------------------------------------------------------
        ; print_title
        ;
        ; prints the group and program name in the upper left
        ; ----------------------------------------------------------------
        pushad
        invoke SetConsoleCursorPosition, outHandle, coord_prog_title
        call GetTextColor               ; EAX::original_color = GetTextColor()
        push eax                        ; Stack.push(EAX::original_color)

        mov eax, white + (gray*16)      ; EAX::new_color = white with gray background
        call SetTextColor               ; SetTextColor(EAX::new_color)
        mov edx, OFFSET prog_title_string ; EDX::message_address = *header_msg
        call WriteString                ; WriteString(EDX::message_address)

        pop eax                         ; EAX::original_color = Stack.pop()
        call SetTextColor               ; SetTextColor(EAX::original_color)

        popad
        ret
    print_title endp
    
    .data
        credits_string byte "    G8P3.asm was created by Karl Miller and Luke Bates. ", 0
        goodbye_string byte "                      Goodbye. ", 0
    .code
    print_goodbye proc
        pushad

        call Clrscr 
        call print_title

        ;popad
        ;ret        ; turned off pretty print for testing


        call GetTextColor
        push eax 
        mov eax, lightGreen
        call SetTextColor

        mov eax, coord_prompt
        mov print_coords, eax


        mov esi, 0

        invoke SetConsoleCursorPosition, outHandle, print_coords
        while_not_done_animating:
            mov edx, offset credits_string
            call WriteString
            mov eax, 1
            call print_coord_right_by_eax
            
            mov eax, 5
            call Delay
            ; pushad
            ;     mov eax, ecx
            ;     call WriteInt
            ; popad
            add esi, 1
            cmp esi, 30
            jl while_not_done_animating
            
        call print_coord_down
        call print_coord_down

        mov edx, offset goodbye_string
        call WriteString
        call print_coord_down


        pop eax
        call SetTextColor

        mov eax, 1000
        call Delay

        popad
        ret
    print_goodbye endp

    print_visible_structures proc
        ; ----------------------------------------------------------------------------------------------
        ; print_visible_structures
        ;
        ; prints structures which are always visible and those which are currently toggled to be visible
        ; ----------------------------------------------------------------------------------------------
        pushad 
        call print_title
        call print_last_completed_job_once
        call possibly_clear_command_feedback
        call print_prompt
        call clear_input_area
        mov ax, program_settings
        bt ax, settings_helpshowing
        jnc possibly_print_jobs_table
            call print_command_help
        possibly_print_jobs_table:
            call possibly_print_lists
        possibly_print_debug_table:
            bt ax, settings_debugshowing
            jnc keep_printing
            call print_debug_table
        keep_printing:

        popad 
        ret
    print_visible_structures endp


 ; ===================================== Print Job Completion

 
    .data
        last_job_was_shown byte 1
        last_job_string_address dword 0
        job_complete_message byte " completed at time: ", 0
        job_clear_message byte "                                                      ", 0
        coord_job_complete_message COORD <13, 1>
    .code
    set_last_completed_job proc
        ; -------------------------------------------------------------------------------------------------------------------
        ; set_last_completed_job
        ;
        ; Called on the completion of a job. Stores the job address so its name can be printed once to indicate job completion.

        ; Does so by setting the address of the last job in memory and resetting the last_job_was_shown flag.
        ; The flag is looked at by the print_last_completed_job_once to determine whether to print the message. 
        ;   RECEIVES ESI - address of job name to print
        ; --------------------------------------------------------------------------------------------------------------------
        push ax 
        mov last_job_string_address, esi
        mov al, 0
        mov last_job_was_shown, al
        pop ax
        ret
    set_last_completed_job endp
    print_last_completed_job_once proc
        ; ------------------------------------------------------------------------------------
        ; print_last_completed_job
        ;
        ; Prints the last completed job information if the flag isn't shown. Resets the flag.
        ; ------------------------------------------------------------------------------------
        push eax
        push edx 
        invoke SetConsoleCursorPosition, outHandle, coord_job_complete_message
        cmp last_job_was_shown, 0
        je print_last_job 
        jmp print_clear_string
        print_last_job:
            mov al, 1
            mov last_job_was_shown, al
            mov edx, last_job_string_address
            call WriteString
            mov edx, offset job_complete_message
            call WriteString
            mov eax, system_clock
            call WriteDec
            jmp finish_up
        print_clear_string:
            mov edx, offset job_clear_message
            call WriteString
        finish_up:

        pop edx
        pop eax
        ret
    print_last_completed_job_once endp

 ; ===================================== Print Help Box

    .data
        command_help_box_title_cmd byte "             Command Information     ", 0
        command_help_box_title_param byte "           Parameter Information     ", 0
        command_help_box_name byte "        Name:  ", 0
        command_help_box_desc byte " Description:  ", 0

        coord_help_box COORD <10, 4>
        help_box_color dword 112
        help_box_shadow dword 144
        help_box_size COORD <69, 5>

    .code

    print_command_help_box proc
        ; --------------------------------------------------------------------------
        ; print_command_help
        ;
        ; prints a help box about command information until user presses enter
        ;   RECEIVES    ebx - the address of a command to print information about
        ; --------------------------------------------------------------------------
        pushad

        call clear_error
        call clear_command_help
        call clear_job_list
        call clear_debug_table

        call GetTextColor           ; save original text color
        push eax
        mov eax, BOX_COLOR          ; set print color to box color
        call SetTextColor 
        ; here we could clear the SHOW area as well
        mov eax, help_box_size
        mov box_size, eax
        mov eax, help_box_color
        mov BOX_COLOR, eax
        mov eax, help_box_shadow
        mov SHADOW_COLOR, eax
        mov eax, coord_help_box
        mov box_coord, eax
        call print_box
        mov eax, coord_help_box
        mov print_coords, eax
        ;invoke SetConsoleCursorPosition, outHandle, print_coords
        mov edx, offset command_help_box_title_cmd
        call print_box_header
        mov print_coords, eax
        invoke SetConsoleCursorPosition, outHandle, print_coords
        call print_coord_down
        call print_coord_down
        mov edx, offset command_help_box_name
        call WriteString
        mov edx, (COMMAND PTR [ebx]).string
        call WriteString
        call print_coord_down
        mov edx, offset command_help_box_desc
        call WriteString
        mov edx, (COMMAND PTR [ebx]).desc_string
        call WriteString
        call ReadChar
        pop eax             ; restore the text color
        call SetTextColor
        call clear_help_box ; clear the box
        popad
        ret
    print_command_help_box endp

    print_parameter_help_box proc
        ; --------------------------------------------------------------------------
        ; print_parameter_help_box
        ;
        ; prints a help box about parameter information until user presses enter
        ;   RECEIVES    ebx - the address of a parameter to print information about
        ; --------------------------------------------------------------------------
        pushad
        call clear_error
        call clear_command_help
        call clear_job_list
        call clear_debug_table

        call GetTextColor           ; save original text color
        push eax
        mov eax, BOX_COLOR          ; set print color to box color
        call SetTextColor 
        
        mov eax, coord_help_box
        mov box_coord, eax
        mov box_size.Y, 5
        mov box_size.X, 69
        call print_box
        mov print_coords, eax
        
        mov print_coords, eax
        ; invoke SetConsoleCursorPosition, outHandle, print_coords
        ; call print_coord_down
        mov edx, offset command_help_box_title_param
        call print_box_header
        mov print_coords, eax
        invoke SetConsoleCursorPosition, outHandle, print_coords
        ;call WriteString
        call print_coord_down
        call print_coord_down
        mov edx, offset command_help_box_name
        call WriteString
        mov edx, (COMMAND_PARAM PTR [ebx]).name_string
        call WriteString
        call print_coord_down
        mov edx, offset command_help_box_desc
        call WriteString
        mov edx, (COMMAND_PARAM PTR [ebx]).desc_string
        call WriteString
        call ReadChar
        pop eax             ; restore the text color
        call SetTextColor
        call clear_help_box ; clear the box
        popad
        ret
    print_parameter_help_box endp

    clear_help_box proc
        ; ---------------------------------------------------------------------------------
        ; clear_help_box
        ;
        ; clears the help box. Expects print_coord to be on the last line of the help box.
        ; ---------------------------------------------------------------------------------
        pushad
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov edx, offset long_clear_string
        call WriteString
        call print_coord_up
        call WriteString
        call print_coord_up
        call WriteString
        call print_coord_up
        call WriteString
        call clear_box
        popad
        ret
    clear_help_box endp 
 ; ===================================== Print Commands Table
    .data
        _no_parameter_text byte "None",0
        _priority_parameter_text byte "Priority, 0-7",0
        _job_parameter_text byte "Job Name <8 chars", 0
        _steps_parameter_text byte "Job Time >0",0
        _invalid_parameter_identifier byte "ERR PARAM", 0
    .code

    .data      
        command_help_clear byte  "                                           ",0
        command_help_header byte " command   param1      param2     param3   ",0
        command_help_spacer byte " - - - - - - - - - - - - - - - - - - - - - ",0
        coord_command_help COORD <45, 7>
    .code
    print_command_help proc
        ; -----------------------------------------------------------------------------------------
        ; print_command_help
        ;
        ; prints a table at coord_command_help listing each available command and its parameters
        ; -----------------------------------------------------------------------------------------
        pushad
        call GetTextColor
        push eax 
        mov eax, gray
        call SetTextColor

        mov eax, coord_command_help
        mov print_coords, eax
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov edx, offset command_help_header
        call WriteString
        call print_coord_down
        mov edx, offset command_help_spacer
        call WriteString

        mov esi, OFFSET commands

        do_while_commands_left_to_print:

            call print_coord_down
            mov edi, print_coords               ; save the beginning of the line

            mov ax, 2
            call print_coord_right_by_eax

            mov edx, (COMMAND ptr [esi]).string

            call WriteString 

            
            mov print_coords, edi
            mov ax, 10
            call print_coord_right_by_eax
            mov ebx, (COMMAND ptr [esi]).param1
            mov edx, (COMMAND_PARAM ptr [ebx]).name_string
            call WriteString 
            
            mov print_coords, edi
            mov ax, 23
            call print_coord_right_by_eax
            mov ebx, (COMMAND ptr [esi]).param2
            mov edx, (COMMAND_PARAM ptr [ebx]).name_string
            call WriteString 
            
            mov print_coords, edi
            mov ax, 35
            call print_coord_right_by_eax
            mov ebx, (COMMAND ptr [esi]).param3
            mov edx, (COMMAND_PARAM ptr [ebx]).name_string
            call WriteString 

            mov print_coords, edi

            add esi, sizeof COMMAND
            cmp esi, commands_end
            jl do_while_commands_left_to_print

        pop eax
        call SetTextColor              
        
        popad
        ret 
    print_command_help endp

    clear_command_help proc
        ; --------------------------------------------------------------------------
        ; clear_command_help
        ;
        ; clears the command information table by writing whitespace over each line.
        ; --------------------------------------------------------------------------
        pushad
        mov eax, coord_command_help
        mov print_coords, eax
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov ecx, commands_list_size
        mov edx, offset command_help_clear
        mov esi, 0
        do_while_help_lines_left_to_clear:
            call WriteString
            call print_coord_down
            cmp esi, ecx
            jg end_while
            inc esi
            jmp do_while_help_lines_left_to_clear

        end_while:

        popad
        ret
    clear_command_help endp 
	
 ; ===================================== Print Job List

    .data
        coord_list_start COORD <6,7>
        list_header_string byte "   ID     Prior   Time     ", 0
        list_line          byte "- - - - - - - - - - - - - -", 0
        running_string     byte "       * running *         ", 0
        ;                       "id111111    7      25"
        holding_string     byte "       * holding *         ", 0
        ;                       "id111111    7      25"
        clear_list_line_string  byte "                           ", 0
    .code
    possibly_print_lists proc
        ; --------------------------------------------
        ; possibly_print_lists
        ;
        ; prints the header and spacer if list is toggled to on, otherwise calls clear list
        ; prints *running* and *holding* dividers
        ; calls the procs to print the list data
        ; --------------------------------------------
        
        push edx
        push eax
        push ecx 
        call clear_job_list
        mov ax, program_settings
        bt ax, settings_jobshowing
        jc job_list_is_set_to_show
        job_list_is_set_to_hide:
            jmp finish_up
        job_list_is_set_to_show:
            mov eax, coord_list_start
            mov print_coords, eax 
            invoke SetConsoleCursorPosition, outHandle, print_coords
            call GetTextColor
            push eax
            mov eax, gray
            call SetTextColor
            mov edx, offset list_header_string
            call WriteString
            call print_coord_down
            mov eax, gray
            call SetTextColor
            mov edx, offset list_line
            call WriteString
            call print_coord_down
            mov eax, lightBlue
            call SetTextColor
            mov edx, offset running_string
            call WriteString
            call print_coord_down
            call print_run_list
            call print_coord_down
            mov eax, brown
            call SetTextColor
            mov edx, offset holding_string
            call WriteString
            call print_coord_down
            call print_hold_list
            pop eax
            call SetTextColor
        finish_up:

        pop ecx
        pop eax 
        pop edx
        ret
    possibly_print_lists endp

    print_hold_list proc
        ; ---------------------------------------------------------------------------
        ; print_hold_list
        ;
        ; prints the hold portion of the list. Expects print coords to already be set.
        ; ---------------------------------------------------------------------------
        push eax
        push esi
        call GetTextColor
        push eax 
        mov eax, lightBlue
        call SetTextColor
        mov esi, hold_list_head
        do_while_list_left_to_print:
            cmp (JOB ptr[esi]).mode, MODE_HOLD
            jne end_while
            call print_job_line
            mov esi, (JOB ptr[esi]).next
            cmp esi, 0
            je end_while
            call print_coord_down
            jmp do_while_list_left_to_print

        end_while:

        pop eax
        call SetTextColor
        pop eax
        pop esi
        ret
    print_hold_list endp

    print_run_list proc
        ; ---------------------------------------------------------------------------
        ; print_run_list
        ;
        ; prints the run portion of the list. Expects print coords to already be set.
        ; ---------------------------------------------------------------------------
        push eax
        push esi
        call GetTextColor
        push eax 
        mov eax, lightBlue
        call SetTextColor
        mov esi, run_list_head
        do_while_list_left_to_print:
            cmp (JOB ptr[esi]).mode, MODE_RUN
            jne end_while
            call print_job_line
            mov esi, (JOB ptr[esi]).next
            cmp esi, 0
            je end_while
            call print_coord_down
            jmp do_while_list_left_to_print

        end_while:

        pop eax
        call SetTextColor
        pop eax
        pop esi
        ret
    print_run_list endp
    print_job_line proc
        ; ------------------------------------------------------------
        ; print_job_line
        ;
        ; Prints 1 job line at the current print coordinate.
        ; Shouldn't be called directly.
        ;   RECEIVES esi - a pointer to a job
        ; ------------------------------------------------------------
        pushad
        mov edx, offset clear_list_line_string
        call WriteString
        invoke SetConsoleCursorPosition, outHandle, print_coords
        call GetTextColor               ; eax::orig_color = GetTextColor()
        push eax                        

        mov ecx, print_coords              ; ecx::original_print_coord = print_coord
        mov edx, esi                       ; edx::&name = &esi->job_name

        mov eax, 2
        call print_coord_right_by_eax
        call WriteString                  ; WriteString(edx::&job_name)

        mov eax, yellow
        call SetTextColor
        mov eax, 10
        call print_coord_right_by_eax
        movzx eax, (JOB ptr[esi]).priority
        call WriteDec
        mov eax, 7
        call print_coord_right_by_eax
        movzx eax, (JOB ptr[esi]).time
        call WriteDec

        pop eax
        call SetTextColor
        mov print_coords, ecx
        popad
        ret
    print_job_line endp 

    clear_job_list proc
        ; --------------------------------------------------
        ; clear_job_list
        ;
        ; clears the job list by writing whitespace over it.
        ; --------------------------------------------------
        push ecx
        push edx 
        push eax
        mov edx, coord_list_start
        mov print_coords, edx
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov ecx, JOB_LIST_SIZE + 5              ; num lines = total possible jobs + 5
        do_while_lines_left_to_clear:
            mov edx, offset clear_list_line_string
            call WriteString
            call print_coord_down
            sub ecx, 1
            cmp ecx, 0
            jg do_while_lines_left_to_clear

        pop eax
        pop edx
        pop ecx

        ret 
    clear_job_list endp
	
 ; ===================================== Debug Print Jobs Array

    dbt_print_job_address proc 
        ; -----------------------------------------------------------------
        ; dbt_print_job_address
        ;
        ; Prints a job address in lightblue if it's referencing a running job
        ; Prints a job address in brown if its referencing a holding job
        ; Prints a job address in lightGray if it's referencing an inactive job
        ; Prints job in red if its some other, invalid mode
        ;   RECEIVES    esi - address of job to print
        ; -----------------------------------------------------------------
        push eax
        push ebx
        call GetTextColor
        push eax 
        cmp esi, 0
        je set_to_zero_color
        mov bl, (JOB ptr [esi]).mode
        cmp bl, MODE_HOLD
        je set_to_hold_color
        cmp bl, MODE_RUN
        je set_to_run_color
        cmp bl, MODE_INACTIVE
        je set_to_inactive_color
        jmp set_to_error_color
        
        set_to_zero_color:
            mov eax, yellow
            jmp print_the_job_address

        set_to_error_color:
            mov eax, red
            jmp print_the_job_address

        set_to_hold_color:
            mov eax, brown
            jmp print_the_job_address

        set_to_run_Color:
            mov eax, lightBlue
            jmp print_the_job_address

        set_to_inactive_color:
            mov eax, lightGray
            jmp print_the_job_address

        print_the_job_address:
            call SetTextColor
            cmp esi, run_list_head
            je print_the_run_head_indicator
            jmp possibly_print_the_hold_head_indicator
            print_the_run_head_indicator:
                push eax 
                mov eax, white
                call SetTextColor
                mov al, '#'
                call WriteChar
                pop eax
                call SetTextColor
            possibly_print_the_hold_head_indicator:
                cmp esi, hold_list_head
                je print_the_hold_head_indicator
                jmp print_the_address 
                print_the_hold_head_indicator:
                    push eax
                    mov eax, lightMagenta
                    call SetTextColor
                    mov al, '#'
                    call WriteChar
                    pop eax
                    call SetTextColor
            print_the_address:
            mov eax, esi 
            call WriteDec

        pop eax 
        call SetTextColor

        pop ebx
        pop eax 
        ret 
    dbt_print_job_address endp
    .data 
        debug_table_clear_line byte "                                                                       ", 0
    .code 
    clear_debug_table proc 
        ; ------------------------------------------------------------------
        ; clear_debug_table
        ;
        ; draws whitespace over debug table to clear it
        ; ------------------------------------------------------------------
        pushad
        mov eax, debug_table_print_location
        mov print_coords, eax 
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov ecx, JOB_LIST_SIZE + 1
        while_lines_left_to_clear:
            mov edx, offset debug_table_clear_line
            call WriteString
            call print_coord_down
            dec ecx
            cmp ecx, -1
            jg while_lines_left_to_clear
        popad
        ret
    clear_debug_table endp 
    .data
        debug_table_print_location COORD <68, 7>
        debug_table_header_string byte "THIS       NAME       PREV       NEXT", 0
    .code 
    print_debug_table proc 
        ; ------------------------------------------------------------------
        ; print_debug_table
        ;
        ; prints debug info about the jobs towards the right of the screen
        ; prints the entire job array
        ; prints the address of each job, the name of the job, prev, and next
        ; -------------------------------------------------------------------
        pushad
        call clear_debug_table 
        mov eax, debug_table_print_location
        mov print_coords, eax 
        invoke SetConsoleCursorPosition, outHandle, print_coords
        mov edx, offset debug_table_header_string
        call WriteString
        call print_coord_down
        mov ecx, offset jobs_array
        while_still_left_in_array_to_print:
            call print_coord_down
            mov ebx, print_coords
            mov esi, ecx 
            call dbt_print_job_address
            mov eax, 11
            call print_coord_right_by_eax
            mov edx, ecx
            call WriteString
            mov eax, 11
            call print_coord_right_by_eax
            mov esi, (JOB ptr[ecx]).previous
            call dbt_print_job_address
            mov eax, 11
            call print_coord_right_by_eax
            mov esi, (JOB ptr[ecx]).next
            call dbt_print_job_address
            mov print_coords, ebx 
            add ecx, SIZEOF job
            cmp ecx, jobs_end
            jl while_still_left_in_array_to_print

        popad
        ret 
    print_debug_table endp 

; =========================================================== Job Data

    .data
	
    JOB_LIST_SIZE equ 10 

    jobs_array JOB JOB_LIST_SIZE dup(<>)

    jobs_end equ $

    run_list_head dword offset jobs_array[1]         ; points to the head of the running jobs linked list
    hold_list_head dword offset jobs_array[1]        ; points to the head of the holding jobs linked list


	.code
; =========================================================== Job Procedures

 ; ===================================== Linked List Debug
    .data
        coord_ll_db1 COORD <120, 6>
        db_ll_str_1 byte " - PRIMARY LIST LOGIC INDICATOR REACHED POSITION! - ", 0
        coord_ll_db2 COORD <120, 7>
        db_ll_str_2 byte " - SECONDARY LIST LOGIC INDICATOR REACHED POSITION! - ", 0
    .code
    lldb1 proc 
        ; ------------------------------------------------------------------------------------------------------------
        ; lldb2
        ;
        ; prints a secondary message at a rightward coord for use with debugging, to indicate reaching tested branches 
        ; ------------------------------------------------------------------------------------------------------------
        pushad 
        invoke SetConsoleCursorPosition, outHandle, coord_ll_db1
        mov edx, offset db_ll_str_1
        call WriteString 
        popad 
        ret 
    lldb1 endp
    lldb2 proc 
        ; ------------------------------------------------------------------------------------------------------------
        ; lldb2
        ;
        ; prints a secondary message at a rightward coord for use with debugging, to indicate reaching tested branches 
        ; ------------------------------------------------------------------------------------------------------------
        pushad 
        invoke SetConsoleCursorPosition, outHandle, coord_ll_db2
        mov edx, offset db_ll_str_2
        call WriteString 
        popad 
        ret 
    lldb2 endp
 ; ===================================== Linked List Procedures
    insert_job_into_run_list proc
        ; -----------------------------------------------------------------------------
        ; insert_job_into_run_list
        ;
        ; inserts a job into the run list linked list
        ;   RECEIVES - esi : address of a job to insert. Should already be mode running
        ; -----------------------------------------------------------------------------
        pushad 
        mov edi, run_list_head                      ; edi::head = &run_list_head
        mov cl, (JOB ptr [edi]).mode                ; cl::head_mode = edi::&head->mode
        cmp cl, MODE_RUN                            ; ? cl::head_mode != run ?
        jne no_valid_head_present                   ;     // esi becomes the new head, return
        cmp esi, edi                                ; if(esi::&new_job == edi::&head)
        je no_valid_head_present                    ;  // then we must have overwritten that head cause it was invalid!!!!!
        ; call lldb1
        mov bl, (JOB ptr[esi]).priority             ; bl::new_node_priority = esi::&job->priority
        mov bh, (JOB ptr[edi]).priority             ; bh::head_priority = edi::&head->priority
        cmp bl, bh
        jl insert_at_head
        jmp loop_through_list

        no_valid_head_present:
            ; call lldb2
            mov run_list_head, esi                  ; run_list_head = esi::&new_job_node
            mov (JOB ptr[esi]).next, 0              ; esi::&new_job_node->next = NULL
            mov (JOB ptr[esi]).previous, 0          ; esi::&new_job_node->previous = NULL
            jmp finish_up                           ; return

        insert_at_head:
            mov (JOB ptr[esi]).next, edi
            mov (JOB ptr[edi]).previous, esi
            mov (JOB ptr[esi]).previous, 0
            mov run_list_head, esi
            jmp finish_up

        loop_through_list:
            mov bh, (JOB ptr[edi]).priority         ; bh::next_node_priority = edi::job->priority
            cmp bh, bl                              ; ? bh::next_node_priority < bl::new_node_priority ?   // less = higher priority
            jg insert_after                         ;    // insert before next_node, return
            cmp (JOB ptr[edi]).next, 0              ; ? edi::&next_node->next == NULL ?
            je insert_at_tail                       ;   // insert at end, return
            mov edi, (JOB ptr[edi]).next            ; edi::&next_node = edi::&next_node->next
            jmp loop_through_list

        insert_after:
            mov ebx, (JOB ptr[edi]).previous        ; ebx::&prior_node = edi::next_node->&previous
            cmp (JOB ptr[edi]).previous, 0          ; ? edi::next_node->next == NULL ?
            jne attach_the_prior_node
            jmp attach_the_rest

            attach_the_prior_node:
                mov (JOB ptr[ebx]).next, esi        ; ebx::&prior_node->next = esi::&new_node 

            attach_the_rest:
                mov (JOB ptr[esi]).previous, ebx    ; esi::&new_node->previous = ebx::&prior_node
                mov (JOB ptr[esi]).next, edi        ; esi::&new_node->next = edi::&next_node
                mov (JOB ptr[edi]).previous, esi    ; edi::&next_node->previous = esi::&new_node
                jmp finish_up

        insert_at_tail:
            mov (JOB ptr[esi]).next, 0              ; esi::&new_node->next = NULL
            mov (JOB ptr[edi]).next, esi            ; edi::&next_node->next = esi::&new_node
            mov (JOB ptr[esi]).previous, edi        ; esi::&new_node->previous = edi::&next_node

        finish_up:

        popad

        ret 
    insert_job_into_run_list endp
	
	remove_job_from_run_list proc
        ; -----------------------------------------------------------------------------
        ; remove_job_from_run_list
        ;
        ; removes a job from the run linked list
        ;   RECEIVES - esi : address of a job to remove. Should already be mode running and in run list
        ; -----------------------------------------------------------------------------
		push edi
        push ebx
        push esi
        push eax 


        mov edi, (JOB ptr [esi]).next
        mov ebx, (JOB ptr [esi]).previous
        mov (JOB ptr [esi]).mode, MODE_INACTIVE
        mov (JOB ptr [esi]).previous, 0
        mov (JOB ptr [esi]).next, 0

        check_whether_previous_exists:
            cmp ebx, 0
            je if_previous_doesnt_exist_then_its_the_head 
            mov (JOB ptr[ebx]).next, edi
            jmp check_whether_next_exists

        if_previous_doesnt_exist_then_its_the_head:
            cmp edi, 0
            jne set_next_as_new_head 
            jmp finish_up

        set_next_as_new_head:
            mov run_list_head, edi
            mov (JOB ptr[edi]).previous, 0
            jmp finish_up

        check_whether_next_exists:
            cmp edi, 0
            je finish_up
            mov (JOB ptr[edi]).previous, ebx

        finish_up: 

        pop eax
        pop esi 
        pop ebx
        pop edi
		ret
	remove_job_from_run_list endp

	remove_job_from_hold_list proc
        ; ------------------------------------------------------------------------------------------
        ; remove_job_from_hold_list
        ;
        ; removes a job from the hold linked list
        ;   RECEIVES - esi : address of a job to remove. Should already be mode hold and in hold list
        ; -------------------------------------------------------------------------------------------
		push edi
        push ebx
        push esi
        push eax 

                                                                ;    // save next and previous to registers, zero in target job
        mov edi, (JOB ptr [esi]).next                           ; edi::&next = esi::&target_node->next
        mov ebx, (JOB ptr [esi]).previous                       ; ebx::&previous = esi::&target_node->previous
        mov (JOB ptr [esi]).mode, MODE_INACTIVE                 ; esi::&target_node->mode = MODE_INACTIVE
        mov (JOB ptr [esi]).previous, 0                         ; esi::&target_node->previous = 0
        mov (JOB ptr [esi]).next, 0                             ; esi::&target_node->next = 0

        check_whether_previous_exists:             
            cmp ebx, 0
            je if_previous_doesnt_exist_then_its_the_head 
            mov (JOB ptr[ebx]).next, edi
            jmp check_whether_next_exists

        if_previous_doesnt_exist_then_its_the_head:
            cmp edi, 0
            jne set_next_as_new_head                        
            jmp finish_up

        set_next_as_new_head:
            mov hold_list_head, edi
            mov (JOB ptr[edi]).previous, 0
            jmp finish_up

        check_whether_next_exists:
            cmp edi, 0
            je finish_up
            mov (JOB ptr[edi]).previous, ebx

        finish_up: 

        pop eax
        pop esi 
        pop ebx
        pop edi
		ret
	remove_job_from_hold_list endp

    insert_job_into_hold_list proc
        ; -----------------------------------------------------------------------------
        ; insert_job_into_hold_list
        ;
        ; inserts a job into the hold list linked list
        ;   RECEIVES - esi : address of a job to insert. Should already be mode holding
        ; -----------------------------------------------------------------------------
        pushad 
        mov edi, hold_list_head                     ; edi::head = &hold_list_head
        mov cl, (JOB ptr [edi]).mode                ; cl::head_mode = edi::&head->mode
        cmp cl, MODE_HOLD                           ; ? cl::head_mode != run ?
        jne no_valid_head_present                   ;     // esi becomes the new head, return
        cmp esi, edi                                ; if(esi::&new_job == edi::&head)
        je no_valid_head_present                    ;  // then we must have overwritten that head cause it was invalid!!!!!
        ; call lldb1
        mov bl, (JOB ptr[esi]).priority             ; bl::new_node_priority = esi::&job->priority
        mov bh, (JOB ptr[edi]).priority             ; bh::head_priority = edi::&head->priority
        cmp bl, bh
        jl insert_at_head
        jmp loop_through_list

        no_valid_head_present:
            ; call lldb2
            mov hold_list_head, esi                 ; hold_list_head = esi::&new_job_node
            mov (JOB ptr[esi]).next, 0              ; esi::&new_job_node->next = NULL
            mov (JOB ptr[esi]).previous, 0          ; esi::&new_job_node->previous = NULL
            jmp finish_up                           ; return

        insert_at_head:
            mov (JOB ptr[esi]).next, edi
            mov (JOB ptr[edi]).previous, esi
            mov (JOB ptr[esi]).previous, 0
            mov hold_list_head, esi
            jmp finish_up

        loop_through_list:
            mov bh, (JOB ptr[edi]).priority         ; bh::next_node_priority = edi::job->priority
            cmp bh, bl                              ; ? bh::next_node_priority < bl::new_node_priority ?   // less = higher priority
            jg insert_after                         ;    // insert before next_node, return
            cmp (JOB ptr[edi]).next, 0              ; ? edi::&next_node->next == NULL ?
            je insert_at_tail                       ;   // insert at end, return
            mov edi, (JOB ptr[edi]).next            ; edi::&next_node = edi::&next_node->next
            jmp loop_through_list

        insert_after:
            mov ebx, (JOB ptr[edi]).previous        ; ebx::&prior_node = edi::next_node->&previous
            cmp (JOB ptr[edi]).previous, 0          ; ? edi::next_node->next == NULL ?
            jne attach_the_prior_node
            jmp attach_the_rest

            attach_the_prior_node:
                mov (JOB ptr[ebx]).next, esi        ; ebx::&prior_node->next = esi::&new_node 

            attach_the_rest:
                mov (JOB ptr[esi]).previous, ebx    ; esi::&new_node->previous = ebx::&prior_node
                mov (JOB ptr[esi]).next, edi        ; esi::&new_node->next = edi::&next_node
                mov (JOB ptr[edi]).previous, esi    ; edi::&next_node->previous = esi::&new_node
                jmp finish_up

        insert_at_tail:
            mov (JOB ptr[esi]).next, 0              ; esi::&new_node->next = NULL
            mov (JOB ptr[edi]).next, esi            ; edi::&next_node->next = esi::&new_node
            mov (JOB ptr[esi]).previous, edi        ; esi::&new_node->previous = edi::&next_node

        finish_up:

        popad

        ret 
    insert_job_into_hold_list endp
	
	insert_job_into_appropriate_list proc
        ; ---------------------------------------------------------------------------------
        ; insert_job_into_appropriate_list
        ;
        ; calls procs to insert a job into the run_list or hold_list, depending on the mode.
        ;
        ;   RECEIVES - esi : address of a job to insert
        ; ----------------------------------------------------------------------------------
        push esi
        cmp (JOB ptr [esi]).mode, MODE_HOLD
        je is_mode_hold
        jmp check_if_mode_run
        is_mode_hold:
            call insert_job_into_hold_list
            jmp finish_up

        check_if_mode_run:
            cmp (JOB ptr [esi]).mode, MODE_RUN
            je is_mode_run
            jmp invalid_mode

        is_mode_run:
            call insert_job_into_run_list
            jmp finish_up
			
        invalid_mode:
            mov (JOB ptr[esi]).mode, MODE_INACTIVE
            mov (JOB ptr[esi]).next, 0
            mov (JOB ptr[esi]).previous, 0

        finish_up:
        pop esi
        ret
    insert_job_into_appropriate_list endp
 
    rotate_top_jobs proc
        ; --------------------------------------------------------------------
        ; rotate_top_jobs
        ;
        ; 'rolls' the jobs at the head of the run list that have equal priority
        ; --------------------------------------------------------------------
        push esi
        push edx
        mov esi, run_list_head                      ; esi::&list_head = run_list_head 
        mov dl, (JOB ptr [esi]).mode                ; dl::mode = esi::&list_head -> mode
        cmp dl, MODE_RUN                            ; if(dl == MODE_INACTIVE)
        jne rotate_nothing                           ;   return

        call remove_job_from_run_list
        mov (JOB ptr [esi]).mode, MODE_RUN
        call insert_job_into_run_list


        rotate_nothing:
        pop edx
        pop esi
        ret
    rotate_top_jobs endp
 ; ===================================== Job procedures 

    tick proc
        ; ----------------------------------------------------------------------------------------------------------------------------
        ; tick
        ;
        ; Ticks system clock. Decrements top job. Removes the top job if it's complete. 
        ; If complete, tick also calls proc which will set job address so it can be printed on the next draw.
        ; ----------------------------------------------------------------------------------------------------------------------------
        push eax
        push esi
        push ebx  
        mov esi, run_list_head
        mov al, (JOB ptr [esi]).mode
        cmp al, MODE_RUN
        jne finish_up_and_increment_clock

        mov al, (JOB ptr[esi]).time
        sub al, 1
        mov (JOB ptr[esi]).time, al 
        cmp al, 0
        jle job_done
        jmp finish_up_and_increment_clock
        job_done:
            call remove_job_from_run_list

        finish_up_and_increment_clock:
            mov eax, system_clock
            inc eax
            mov system_clock, eax

        pop ebx
        pop esi 
        pop eax 
        ret
    tick endp
	step_running_jobs proc
        ; ---------------------------------------------------------------------------------
        ; Step running jobs
		;
		; Steps the highest running job, and rotates jobs in that priority bracket
		;
		; RECEIVES EAX : Step size
        ; ----------------------------------------------------------------------------------
		pushad

        call tick
        call rotate_top_jobs
		
		; mov esi, run_list_head					; Get the running jobs head
		; mov bl, (JOB ptr [esi]).priority		; Get the highest priority
		
		; step_selected_jobs:
		; 	mov cl, (JOB ptr [esi]).priority	; Step each job equal to highest priority
		; 	cmp cl, bl
		; 	jne done
			
		; 	sub (JOB ptr [esi]).time, al
		; 	jmp step_selected_jobs
		
		; done:
		popad
		ret
	step_running_jobs endp

 ; ===================================== New Job Creation Procedures
    get_first_inactive_job proc
        ; -----------------------------------------------------------------------------
        ; get_first_inactive_job
        ;
        ; gets the first job in the jobs array where mode == 0, so it can be overwritten
        ;   RETURNS - edi - address to the first inactive job
        ;             cf  - 0 if succesful, 1 if jobs is full
        ; ------------------------------------------------------------------------------
        push eax
        mov edi, offset jobs_array   ;  edi::current_job = &jobs_array
        while_jobs_left_to_check:
            movzx eax, (JOB ptr [edi]).mode     ; eax::job_mode = [edi].mode
            cmp eax, MODE_INACTIVE              ; if(eax::job_mode == INACTIVE)
            je found_an_inactive_job            ;   return edi, true
            add edi, sizeof JOB                 ; edi::job_address += sizeof job
            cmp edi, jobs_end                   ; if(edi::job_address == jobs_end)
            jl while_jobs_left_to_check         ;   return edi, false
            stc                                 ;  cf::jobs_full = true
            jmp finish_up

        found_an_inactive_job:
            clc

        finish_up:
        pop eax
        ret
    get_first_inactive_job endp 

    copy_param_to_job_string proc
        ; ------------------------------------------------------------
        ; copy_param_buffer_to_job_string
        ;
        ; copies the contents of the parameter buffer to a job_name
        ;
        ;   RECEIVES esi - a pointer to a parameter buffer containing a new name
        ;   RECEIVES edi - a pointer to a job whose name to overwrite
        ; ------------------------------------------------------------
        pushad
        mov ecx, 0

        copy_while_not_terminator:
            mov al, (byte ptr [esi])
            mov [edi], al
            cmp al, 0
            je end_while 
            inc esi
            inc ecx
            inc edi
            jmp copy_while_not_terminator

        end_while:

        popad
        ret
    copy_param_to_job_string endp
	
	
; =========================================================== Command Procedures
    
    .data
        load_db_str byte " load called with value: ", 0
        load_err_jobs_full byte "There is no room for a new job!", 0
        load_success_message byte " was added!", 0
    .code
    load_job_command proc
        ; --------------------------------------------------------------------------
        ; load_job_command
        ;
        ;   called on input of LOAD
        ;   loads a new job into the job array. Defaults to RUN mode.
        ; 
        ;   RECEIVES    eax - offset to a parameter buffer with 1-8 valid chars
        ;               ebx - number representing a priority, 0-7
        ;               ecx - number representing a time
        ; --------------------------------------------------------------------------
        pushad
        push edi
        push esi

        call get_first_inactive_job             ; edi::&open_job, cf::is_full = get_first_inactive_job()
        jc jobs_are_full

        mov esi, eax                            ; esi::&param_buffer = eax::&param_buffer
        call copy_param_to_job_string           ; copy_param_to_job_string(edi::&open_job, esi::&param_buffer)
        
        
        mov (JOB ptr [edi]).priority, bl
        mov (JOB ptr [edi]).time, cl
        mov (JOB ptr [edi]).mode, MODE_HOLD

        mov esi, edi 
        call insert_job_into_appropriate_list
        jmp job_was_added
           
        jobs_are_full:
            mov edx, offset load_err_jobs_full
            call print_error
            jmp finish_up

        job_was_added:
            call set_for_printing_command_feedback
            push edx
            mov edx, edi
            call print_in_green
            mov edx, offset load_success_message
            call print_in_green
            pop edx 

        finish_up:

        pop esi
        pop edi
        popad
        ret
    load_job_command endp

    clear_command proc
        ; -----------------------------------------------------------------------------------------------------------
        ; clear_command
        ;
        ; called on input of CLEAR
        ; clears the screen buffer. When the buffer is redrawn at the next frame, hanging characters will be removed.
        ; -----------------------------------------------------------------------------------------------------------
        call Clrscr
        ret
    clear_command endp 

    toggle_command_help proc
        ; ----------------------------------------------------------------------------------------------
        ; toggle_command_help
        ;
        ; invoked on input of HELP, takes no parameters. Toggles whether the command help menu is displayed.
        ; ----------------------------------------------------------------------------------------------
        push eax
        pushf 
        mov ax, program_settings
        btc ax, settings_helpshowing
        jnc finish
        call clear_command_help
        finish:
            mov program_settings, ax
        popf
        pop eax
        ret
    toggle_command_help endp 

    show_help_box_command proc
        ; --------------------------------------------------------------------------------------------
        ; show_help_box_command
        ;
        ;   called on input of INFO
        ;
        ; shows a command help box or a parameter help box depending on the identifier in token_buffer
        ;   RECEIVES  eax: the address of a buffer containing an identifier
        ; ---------------------------------------------------------------------------------------------
        pushad
        mov edi, eax                        ; edi::target_buffer = eax::buffer_parameter
        call match_command                  ; ebx::command_address, cf::failed_match = match_command(edi::target_buffer)
        jc check_match_parameter            ; if(cf::failed_match) check if token matches a parameter
        call print_command_help_box
        jmp finish_up

        check_match_parameter:
            call match_parameter           ; ebx::parameter_address, cf::failed_match = match_parameter(edi::target_buffer)
            jc finish_up        
            call print_parameter_help_box

        finish_up:
        popad
        ret
    show_help_box_command endp

    quit_command proc
        ; ----------------------------------------------------------------------------------------------
        ; quit_command
        ;
        ; invoked when user types "QUIT". Restores original console mode and calls goodbye print message.
        ; ----------------------------------------------------------------------------------------------
        invoke SetConsoleMode, outHandle, original_console_out_settings
        call print_goodbye
		mov quit, 1
        ret
    quit_command endp 

    show_command proc
        ; ----------------------------------------------------------------------------------------------
        ; toggle_command_help
        ;
        ; invoked on input of HELP, takes no parameters. Toggles whether the command help menu is displayed.
        ; ----------------------------------------------------------------------------------------------
        push eax
        pushf 
        mov ax, program_settings
        btc ax, settings_jobshowing
        jnc finish
        call clear_job_list
        finish:
            mov program_settings, ax
        popf
        pop eax
        ret
    show_command endp

    .data
        run_feedback_str byte " was set to RUN mode.", 0
        run_error_str_already_run byte "That job is already in run mode!", 0
        run_error_str_doesnt_exist byte "That job doesn't exist!", 0
    .code
    run_command proc
        ; -------------------------------------------------------------------------------
        ; run_command
        ;
        ;   Called when user types "RUN". Sets an existing job in hold mode to run mode.
        ;   Prints errors or feedback depending on success or error result.
        ;
        ;   RECEIVES eax - address to a parameter buffer
        ; -------------------------------------------------------------------------------
        pushad

        mov edi, eax                        ; edi::&param_buffer = eax::&param_buffer
        call match_job                      ; cf::failed_match, ebx::job_address = match_job(edi::&param_buffer)
        jc no_such_job_exists               
        jmp check_if_job_in_hold_mode
        no_such_job_exists:                 ; if(cf::failed_match)
            mov edx, offset run_error_str_doesnt_exist
            call print_error
            jmp finish_up

        check_if_job_in_hold_mode:          ; else
            mov cl, (JOB ptr[ebx]).mode     ;   cl::job_mode = ebx::&target_job -> mode
            cmp cl, MODE_HOLD               
            je move_job_to_run_list
            jmp job_already_in_mode_run
            move_job_to_run_list:          ;    if(cl::job_mode == MODE_HOLD)
                mov esi, ebx
                call remove_job_from_hold_list
                mov (JOB ptr[esi]).mode, MODE_RUN
                call insert_job_into_run_list
                call set_for_printing_command_feedback
                mov edx, ebx
                call print_in_green
                mov edx, offset run_feedback_str
                call print_in_green
                jmp finish_up

            job_already_in_mode_run:       ;    else
                mov edx, offset run_error_str_already_run
                call print_error

        finish_up:
        popad 
        ret
    run_command endp

    .data
        hold_feedback_str byte " was set to HOLD mode.", 0
        hold_error_str_already_hold byte "That job is already in hold mode!", 0
        hold_error_str_doesnt_exist byte "That job doesn't exist!", 0
    .code
    hold_command proc
        ; -------------------------------------------------------------------------------
        ; hold_command
        ;
        ;   Called when user types "HOLD". Sets an existing job in run mode to hold mode.
        ;   Prints errors or feedback depending on success or error result.
        ;
        ;   RECEIVES eax - address to a parameter buffer
        ; -------------------------------------------------------------------------------
        pushad

        mov edi, eax                        ; edi::&param_buffer = eax::&param_buffer
        call match_job                      ; cf::failed_match, ebx::job_address = match_job(edi::&param_buffer)
        jc no_such_job_exists               
        jmp check_if_job_in_hold_mode
        no_such_job_exists:                 ; if(cf::failed_match)
            mov edx, offset hold_error_str_doesnt_exist
            call print_error
            jmp finish_up

        check_if_job_in_hold_mode:          ; else
            mov cl, (JOB ptr[ebx]).mode     ;   cl::job_mode = ebx::&target_job -> mode
            cmp cl, MODE_RUN                
            je move_job_to_hold_list
            jmp job_already_in_mode_hold
            move_job_to_hold_list:          ;    if(cl::job_mode == MODE_HOLD)
                mov esi, ebx
                call remove_job_from_run_list
                mov (JOB ptr[esi]).mode, MODE_HOLD
                call insert_job_into_hold_list
                call set_for_printing_command_feedback
                mov edx, ebx
                call print_in_green
                mov edx, offset hold_feedback_str
                call print_in_green
                jmp finish_up

            job_already_in_mode_hold:       ;    else
                mov edx, offset hold_error_str_already_hold
                call print_error

        finish_up:
        popad 
        ret
    hold_command endp

    .data
        bad_mode_msg byte "Hold job to kill!", 0
		success_kill_msg byte "Killed ", 0
		
    .code 
    kill_command proc
        ; -------------------------------------------------------------------------------
        ; kill_command
        ;
        ;   Called when user types "KILL". Kills a job in hold mode. Error if running.
        ;
        ;   RECEIVES eax - address to a parameter buffer
        ; -------------------------------------------------------------------------------
        pushad
		
		mov edi, eax			; Parameter for match_job
		call match_job			; EBX = Address of found job
		
		check_job_hold_mode:
			mov cl, (JOB ptr[ebx]).mode		; Get the job's mode
			cmp cl, MODE_HOLD
			jne bad_mode					; Error if mode != hold
			
		kill_the_job:
			call set_for_printing_command_feedback	; Setup feedback
			mov edx, offset success_kill_msg		; Print the beginning kill message
			call print_in_green
			mov edx, ebx							; Say what job was killed
			call print_in_green
			mov esi, ebx							; Remove that job from the hold list
			call remove_job_from_hold_list
			jmp done
		
		bad_mode:
			mov edx, offset bad_mode_msg			; Error message when killing job in run mode
			call print_error
		
		done:
		
		popad 
		ret
    kill_command endp

    .data
        step_success_message_front byte "Stepped forward ", 0
        step_success_message_back byte " ticks.", 0
        step_delay dword 0
    .code 
    step_command proc
        ; --------------------------------------------------------------------------
        ; step_command
        ;
        ;   Steps system clock and decrements top job time
        ; 
        ;   RECEIVES    eax - number of steps to move system clock, 0-50
        ; --------------------------------------------------------------------------
        pushad 

        mov ecx, eax 
        push eax 
        while_steps_left_to_tick:
            call step_running_jobs
            mov eax, step_delay
            call Delay
            call possibly_print_lists
            sub ecx, 1
            cmp ecx, 0
            jg while_steps_left_to_tick

        call set_for_printing_command_feedback
        mov edx, offset step_success_message_front
        call print_in_green
        pop eax
        call print_int_in_green
        mov edx, offset step_success_message_back
        call print_in_green 
        
        
        popad 
        ret
    step_command endp

    .data
        delay_command_feedback_str byte "Set step delay to ", 0
        delay_command_feedback_str_back byte " ms.", 0
    .code 
    delay_command proc
        ; ---------------------------------------------------------------------------------------------------------
        ; delay_command
        ;
        ;   Sets the step_delay to the value in eax (the parsed and validated first parameter argument of "DELAY")
        ;   Prints feedback indicating the new delay was set.
        ;
        ;   RECEIVES    - eax   The new delay in ms
        ; ---------------------------------------------------------------------------------------------------------
        mov step_delay, eax
        call set_for_printing_command_feedback
        mov edx, offset delay_command_feedback_str
        call print_in_green
        call print_int_in_green
        mov edx, offset delay_command_feedback_str_back
        call print_in_green
        ret
    delay_command endp

    change_priority_command proc
        ; -------------------------------------------------------------------------------
        ; change_priority_command
        ;
        ;   Called when user types "CHANGE". Changes the priority of a job.
        ;
        ;   RECEIVES eax - address to a parameter buffer
        ;            ecx - new priority to change it to
        ; -------------------------------------------------------------------------------
		pushad
		mov ecx, ebx			; Don't overwrite change amount!
		mov edi, eax			; Parameter for match_job
		call match_job			; EBX = Address of found job
		
        mov dl, (JOB ptr [ebx]).mode


        cmp dl, MODE_RUN
        je reprioritize_in_run_list
        cmp dl, MODE_HOLD
        je reprioritize_in_hold_list
        jmp finish_up
        reprioritize_in_run_list:
            mov esi, ebx
            call remove_job_from_run_list
		    mov (JOB ptr [ebx]).priority, cl
            mov (JOB ptr [ebx]).mode, MODE_RUN          ; removing resets mode to INACTIVE - it has to be set back to RUN
            call insert_job_into_run_list
            jmp finish_up

        reprioritize_in_hold_list:
            mov esi, ebx
            call remove_job_from_hold_list
		    mov (JOB ptr [ebx]).priority, cl
            mov (JOB ptr [ebx]).mode, MODE_HOLD
            call insert_job_into_hold_list

        finish_up:
		
		popad
        ret
    change_priority_command endp

    debug_command proc
        ; ----------------------------------------------------------------------------------------------------------
        ; debug_command
        ;
        ; Toggles whether the debug table is showing or not. The debug table shows the addresses of the jobs array
        ;  and shows what addresses they are linked to. The addresses display in different colors depending on which
        ;  mode the job is in.
        ; ----------------------------------------------------------------------------------------------------------
        push eax
        pushf 
        mov ax, program_settings
        btc ax, settings_debugshowing
        jnc finish
        call clear_debug_table
        finish:
            mov program_settings, ax
        popf
        pop eax
        ret
    debug_command endp
; =========================================================== Parameter Validators
    ; validators all have the same format so they can be processed correctly
    ; they return cf=0 if valid and cf=1 if invalid
    ; they return the result of parsing in ebx.
    ; ebx is saved in the parameter list by the dispatcher and popped to the appropriate register at time of dispatch

    .code 
    validate_identifier proc
        ; ------------------------------------------------------------------------------------------------
        ; validate_identifier
        ;
        ; validates whether token in token_buffer is a valid identifier. Copies to parameter buffer if so.
        ;   RETURNS cf: 0 = valid, 1 = invalid
        ;           ebx: address to the parameter string buffer
        ; ------------------------------------------------------------------------------------------------
        push edi 
        push eax 
        mov edi, offset token_buffer
        
        push edx 
        pop edx

        test_if_token_buffer_matches_a_command:
            call match_command                          ; cf::match_failed, ebx::command_address = match_command(edi::buffer)
            jnc copy_buffer_over

        test_if_token_buffer_matches_a_parameter_type:
            call match_parameter
            jnc copy_buffer_over
            jmp finish_up

        copy_buffer_over:
            call copy_token_buffer_to_parameter_buffer

        finish_up:
            mov ebx, offset parameter_buffer

        pop eax 
        pop edi
        ret
    validate_identifier endp

    validate_job proc 
        ; ------------------------------------------------------------------------------------------------
        ; validate_identifier
        ;
        ; validates whether token in token_buffer is a valid job name. Copies to parameter buffer if so.
        ;   RETURNS cf: 0 = valid, 1 = invalid
        ;           ebx: address to the parameter string buffer
        ; ------------------------------------------------------------------------------------------------
        push edi 
        push eax 
        mov edi, offset token_buffer
        

        test_if_token_buffer_matches_a_job:
            call match_job                          ; cf::match_failed, ebx::job_address = match_job(edi::buffer)
            jnc copy_buffer_over
            jmp finish_up

        copy_buffer_over:
            call copy_token_buffer_to_parameter_buffer
            clc

        finish_up:
            mov ebx, offset parameter_buffer

        pop eax 
        pop edi
        ret
    validate_job endp 

    validate_time proc 
        ; ------------------------------------------------------------------------------------------------
        ; validate_time
        ;
        ; validates token in buffer represents a valid number in the range of the time parameter
        ;   RETURNS cf: 0 = valid, 1 = invalid
        ;           ebx: a number that was parsed, junk data if parsing was bad
        ; ------------------------------------------------------------------------------------------------
        push esi
        push eax 
        mov esi, offset token_buffer                    ; esi::token_buffer = &token_buffer
        call parse_digit_from_token                     ; eax::num_parsed, cf::parse_no_success = parse_digit_from_token(esi::token_buffer)
        jc finish_up                                    ; if(cf::parse_no_succes) return cf::parse_no_success

        cmp eax, _command_param_time.max
        jg number_out_of_bounds
        cmp eax, _command_param_time.min
        jl number_out_of_bounds
        clc
        jmp finish_up

        number_out_of_bounds:
            stc

        finish_up:
            mov ebx, eax                            

        pop eax 
        pop esi
        ret 
    validate_time endp

    .data
        default_time_message byte "Defaulted to time = 1.", 0
    .code
    validate_optional_time proc
        ; ------------------------------------------------------------------------------------------------
        ; validate_time
        ;
        ; validates token in buffer represents a valid number in the range of the time parameter
        ; If not, sets ebx to 1 to represent default parameter
        ;   RETURNS cf: 0 = valid, 1 = invalid
        ;           ebx: a number that was parsed, junk data if parsing was bad
        ; ------------------------------------------------------------------------------------------------
        push edx 
        call validate_time
        jc parse_was_bad
        jmp finish_up

        parse_was_bad:
            mov edx, offset default_time_message
            call print_error
            mov ebx, 1      ; default value is 1

        finish_up:
        clc
        pop edx
        ret
    validate_optional_time endp
    validate_priority proc
        ; ------------------------------------------------------------------------------------------------
        ; validate_priority
        ;
        ; validates token in buffer represents a valid number in the range of the priority parameter
        ;   RETURNS cf: 0 = valid, 1 = invalid
        ;           ebx: a number that was parsed, junk data if parsing was bad
        ; ------------------------------------------------------------------------------------------------
        push esi
        push eax 
        mov esi, offset token_buffer                    ; esi::token_buffer = &token_buffer


        call parse_digit_from_token                     ; eax::num_parsed, cf::parse_no_success = parse_digit_from_token(esi::token_buffer)

        jc finish_up                                    ; if(cf::parse_no_succes) return cf::parse_no_success

        cmp eax, _command_param_priority.max
        jg number_out_of_bounds

        cmp eax, _command_param_priority.min
        jl number_out_of_bounds
        clc
        jmp finish_up

        number_out_of_bounds:
            stc

        finish_up:
            mov ebx, eax                            

        pop eax 
        pop esi
        ret 
    validate_priority endp

    .data
        er_st1 byte "                       debug output:::: ",0
        err_name_too_short byte "Job names must be at least 1 character.", 0
        err_name_too_long byte "Job names must be 8 chars or less.", 0
        err_name_already_exists byte "That job already exists.", 0
    .code 
    validate_name proc
        ; -----------------------------------------------------
        ; validate_name
        ;
        ; validates the name of a new job
        ;   RETURNS cf: 0 = valid, 1 = invalid
        ;           ebx: address to the parameter string buffer
        ; -----------------------------------------------------

        push edi 
        push esi
        push eax 
        push ecx
        push edx 

        call clear_error
        
        ; get the size of input to make sure not more than 8 chars, not less than 1

        mov edi, offset token_buffer    ; edi::&token_buffer = &token_buffer
        mov esi, edi                    ; esi::&token_buffer = edi
        call get_string_size            ; ecx::input_size = get_string_size(esi::&token_buffer)

        cmp ecx, 1
        jl name_too_short
        cmp ecx, 8
        jg name_too_long
        jmp check_if_job_already_exists

        name_too_short:
            mov edx, offset err_name_too_short
            call print_error
            stc
            jmp finish_up 

        name_too_long:
            mov edx, offset err_name_too_long
            call print_error
            stc
            jmp finish_up

        check_if_job_already_exists:
            call match_job                          ; cf:failed_match, ebx:job_address = match_job(edi::&token_buffer)
            jc copy_buffer_over
            job_does_already_exist:
                mov edx, offset err_name_already_exists
                call print_error
                stc
                jmp finish_up

        copy_buffer_over:                   
            call copy_token_buffer_to_parameter_buffer
            clc

        finish_up:
            mov ebx, offset parameter_buffer

        pop edx
        pop ecx
        pop eax 
        pop esi
        pop edi
        ret
    validate_name endp 

    validate_interval proc
        ; ------------------------------------------------------------------------------------------------
        ; validate_interval
        ;
        ; validates token in buffer represents a valid number in the range of the interval parameter
        ;   RETURNS cf: 0 = valid, 1 = invalid
        ;           ebx: a number that was parsed, junk data if parsing was bad
        ; ------------------------------------------------------------------------------------------------

        push esi
        push eax 
        mov esi, offset token_buffer                    ; esi::token_buffer = &token_buffer


        call parse_digit_from_token                     ; eax::num_parsed, cf::parse_no_success = parse_digit_from_token(esi::token_buffer)

        jc finish_up                                    ; if(cf::parse_no_succes) return cf::parse_no_success

        cmp eax, _command_param_interval.max
        jg number_out_of_bounds

        cmp eax, _command_param_interval.min
        jl number_out_of_bounds
        clc
        jmp finish_up

        number_out_of_bounds:
            stc

        finish_up:
            mov ebx, eax                            

        pop eax 
        pop esi
        ret 
    validate_interval endp
; =========================================================== Command Data
    .data

    ; string data for parameter names and information
    _command_param_none_string byte "NONE", 0
    _command_param_none_description byte "No parameter accepted.", 0
    _command_param_newjob_string byte "NAME", 0
    _command_param_newjob_description byte "The name of a new job. Must be 8 characters or less.", 0
    _command_param_job_string byte "JOB", 0
    _command_param_job_description byte "The name of an existing job.", 0
    _command_param_time_string byte "TIME", 0
    _command_param_time_description byte "A number of program steps. 1-50.", 0
    _command_param_time_optional_string byte "TIME?", 0
    _command_param_time_optional_description byte "A number of program steps. 1-50. Defaults to 1.", 0
    _command_param_priority_string byte "PRIORITY", 0
    _command_param_priority_description byte "Job priority. 0-7, inclusive.", 0
    _command_param_identifier_string byte "IDENTIFIER", 0
    _command_param_identifier_description byte "The name of a command or parameter.", 0
    _command_param_interval_string byte "INTERVAL", 0
    _command_param_interval_description byte "Ms to delay between steps, 0-300", 0

    ; list of available parameters
    _command_param_none COMMAND_PARAM <offset _command_param_none_string, offset _command_param_none_description>
    _command_param_job COMMAND_PARAM <offset _command_param_job_string, offset _command_param_job_description, validate_job, 0, 0, 8>
    _command_param_newjob COMMAND_PARAM <offset _command_param_newjob_string, offset _command_param_newjob_description, validate_name, 0, 0, 8>
    _command_param_time_optional COMMAND_PARAM <offset _command_param_time_optional_string, offset _command_param_time_optional_description, validate_optional_time, 1, 1, 50>
    _command_param_time COMMAND_PARAM <offset _command_param_time_string, offset _command_param_time_description, validate_time, 1, 1, 50>
    _command_param_priority COMMAND_PARAM <offset _command_param_priority_string, offset _command_param_priority_description, validate_priority, 1, 0, 7>
    _command_param_identifier COMMAND_PARAM <offset _command_param_identifier_string, offset _command_param_identifier_description, validate_identifier, 0, 0, 8>
    _command_param_interval COMMAND_PARAM <offset _command_param_interval_string, offset _command_param_interval_description, validate_interval, 1, 0, 300>
    params_end equ $
    params_list_size equ (params_end - _command_param_none) / sizeof COMMAND_PARAM

    ; string data for command names and descriptions
    _command_help_string byte "HELP",0
    _command_help_description byte "Toggles the command list display.", 0
    _command_info_string byte "INFO",0
    _command_info_description byte "Provides information about a command or parameter.", 0
    _command_show_string byte "SHOW", 0
    _command_show_description byte "Displays the job queue.", 0
    _command_run_string byte "RUN", 0
    _command_run_description byte "Sets a job to run mode.", 0
    _command_hold_string byte "HOLD", 0
    _command_hold_description byte "Sets a job to hold mode.", 0
    _command_kill_string byte "KILL",0
    _command_kill_description byte "Destroys an unfinished job.", 0
    _command_step_string byte "STEP", 0
    _command_step_description byte "Steps the clock forward some number of steps.", 0
    _command_change_string byte "CHANGE", 0
    _command_change_description byte "Changes the priority of a job.", 0
    _command_load_string byte "LOAD", 0
    _command_load_description byte "Loads a new job.", 0
    _command_clear_string byte "CLEAR", 0
    _command_clear_description byte "Clears the console buffer.", 0
    _command_debug_string byte "DEBUG", 0
    _command_debug_description byte "Toggles the jobs address debug display table.", 0
    _command_delay_string byte "DELAY", 0
    _command_delay_description byte "Sets the delay between steps.", 0
    _command_quit_string byte "QUIT", 0
    _command_quit_description byte "Quits the program.", 0

    ; available commands
    commands COMMAND {toggle_command_help, offset _command_help_string, offset _command_help_description, offset _command_param_none, offset _command_param_none, offset _command_param_none} 
             COMMAND {show_help_box_command, offset _command_info_string, offset _command_info_description, offset _command_param_identifier, offset _command_param_none, offset _command_param_none}
			 COMMAND {show_command, offset _command_show_string, offset _command_show_description, offset _command_param_none, offset _command_param_none, offset _command_param_none}     
			 COMMAND {run_command, offset _command_run_string, offset _command_run_description, offset _command_param_job, offset _command_param_none, offset _command_param_none} 
			 COMMAND {hold_command, offset _command_hold_string, offset _command_hold_description, offset _command_param_job, offset _command_param_none, offset _command_param_none}
			 COMMAND {kill_command, offset _command_kill_string, offset _command_kill_description, offset _command_param_job, offset _command_param_none, offset _command_param_none}
			 COMMAND {step_command, offset _command_step_string, offset _command_step_description, offset _command_param_time_optional, offset _command_param_none, offset _command_param_none}
			 COMMAND {change_priority_command, offset _command_change_string, offset _command_change_description, offset _command_param_job, offset _command_param_priority, offset _command_param_none}      
			 COMMAND {load_job_command, offset _command_load_string, offset _command_load_description, offset _command_param_newjob, offset _command_param_priority, offset _command_param_time}      
             COMMAND {clear_command, offset _command_clear_string, offset _command_clear_description, offset _command_param_none, offset _command_param_none, offset _command_param_none}   
             COMMAND {debug_command, offset _command_debug_string, offset _command_debug_description, offset _command_param_none, offset _command_param_none, offset _command_param_none}      
             COMMAND {delay_command, offset _command_delay_string, offset _command_delay_description, offset _command_param_interval, offset _command_param_none, offset _command_param_none}   

             

			 COMMAND {quit_command, offset _command_quit_string, offset _command_quit_description, offset _command_param_none, offset _command_param_none, offset _command_param_none}

    commands_end equ $
    commands_list_size equ (commands_end - commands) / sizeof COMMAND

; =========================================================== Matchers
    
    .data
        match_error_string_front byte "The command '", 0
        match_error_string_back byte "' is invalid!", 0
    .code 
    match_command proc
        ; -----------------------------------------------------------------------------------------------
        ; match_command
        ;
        ; matches a token in a token buffer with a command name string.
        ;   RECEIVES    edi :   the address of a token buffer to check
        ;   RETURNS     ebx :   address to the command
        ;               cf = 1 if failed to match, cf = 0 if match succesful
        ; -----------------------------------------------------------------------------------------------
        push esi
        push ecx
        push eax 
        push edi 

        mov eax, edi                            ; eax::pointer_to_buffer = edi::param_buffer_address
        
        mov ebx, offset commands                 ; esi::param_address = *command_param_none

        do_while_commands_to_check:
            mov esi, (COMMAND ptr [ebx]).string 
            mov edi, eax
            call get_string_size
            inc ecx
            cld
            repe cmpsb 

            cmp ecx, 0
            je found_match

            add ebx, sizeof COMMAND
            cmp ebx, commands_end
            jl do_while_commands_to_check 

        no_match:
            mov edx, offset match_error_string_front
            call print_error
            mov edx, offset token_buffer
            call WriteString
            call GetTextColor
            push eax
                mov eax, red
                call SetTextColor
                mov edx, offset match_error_string_back
                call WriteString
            pop eax
            call SetTextColor 
            stc
            jmp finish_up

        found_match:
            clc

        finish_up:

        pop edi
        pop eax 
        pop ecx
        pop esi
        ret
    match_command endp 

    match_parameter proc 
        ; -----------------------------------------------------------------------------------------------
        ; match_command
        ;
        ; matches a token in a token buffer with a parameter name string.
        ;   RECEIVES    edi :   the address of a token buffer to check
        ;   RETURNS     ebx :   address to the parameter struct
        ;               cf = 1 if failed to match, cf = 0 if match succesful
        ; -----------------------------------------------------------------------------------------------
        push esi
        push ecx
        push eax 
        push edi 

        mov eax, edi                            ; eax::pointer_to_buffer = edi::param_buffer_address
        
        mov ebx, offset _command_param_none    ; ebx::param_list_address = *_command_param_none

        do_while_params_to_check:
            ;call WriteInt
            mov esi, (COMMAND_PARAM ptr [ebx]).name_string 
            mov edi, eax
            call get_string_size
            inc ecx
            cld
            repe cmpsb 

            cmp ecx, 0
            je found_match

            add ebx, sizeof COMMAND_PARAM
            cmp ebx, params_end
            jl do_while_params_to_check 

        no_match:
            stc
            jmp finish_up

        found_match:
            clc

        finish_up:

        pop edi
        pop eax 
        pop ecx
        pop esi
        ret
    match_parameter endp

    match_job proc
        ; -----------------------------------------------------------------------------------------------
        ; match_job
        ;
        ; matches a token in a token buffer with a job name string.
        ;   RECEIVES    edi :   the address of a token buffer to check
        ;   RETURNS     ebx :   address to the job struct
        ;               cf = 1 if failed to match, cf = 0 if match succesful
        ; -----------------------------------------------------------------------------------------------
        push esi
        push ecx
        push eax 
        push edi 

        mov eax, edi                            ; eax::pointer_to_buffer = edi::param_buffer_address
        
        mov ebx, offset jobs_array              ; ebx::jobs_list_address = *jobs_array

        do_while_jobs_to_check:
            mov esi, ebx                       ; esi::&job_id = ebx::&job_address
            call get_string_size               ; ecx::string_size = get_string_size(ebx::&job)
            mov edi, eax                       ; edi::&buff = eax::pointer_to_buffer
            add ecx, 2
            cld
            repe cmpsb 

            cmp ecx, 0
            je found_match

            add ebx, sizeof JOB
            cmp ebx, jobs_end
            jl do_while_jobs_to_check 

        no_match:
            stc
            jmp finish_up

        found_match:
            mov cl, (JOB ptr [ebx]).mode
            cmp cl, MODE_INACTIVE
            je match_should_be_overwritten
            jmp match_is_an_existing_job
            match_should_be_overwritten:
                stc
                jmp finish_up
            match_is_an_existing_job:
                clc

        finish_up:

        pop edi
        pop eax 
        pop ecx
        pop esi
        ret
    match_job endp

; =========================================================== Command Parser
    .code 
    parse_digit_from_token proc
        ; ----------------------------------------------------------------------------------------
        ; parse_digit_from_token
        ;
        ;   RETURNS eax - a digit parsed from the token buffer
        ;           cf  - 1 = failed to parse, 0 = succesful parse
        ; ----------------------------------------------------------------------------------------
        push esi
        push ecx 
        push ebx
        push edx 

        mov esi, offset token_buffer                    ; esi::token_buffer = &token_buffer
        call get_string_size                            ; ecx::string_size = get_string_size(esi::token_buffer)

        ;sub ecx, 2

        cmp ecx, 0
        jle failed_to_parse                              ; if string size is zero, can't parse
        mov ebx, 1                                      ; ebx::multiplier = 1
        mov eax, 0                                      ; eax::total = 0

        do_while_digits_left_to_parse:
            sub ecx, 1                                     ; ecx::index -= 1
            movzx edx, token_buffer[ecx]                   ; dl::char_test = token_buffer[ecx::index]
            cmp dl, '0'
            jl failed_to_parse
            cmp dl, '9'
            jg failed_to_parse
            sub dl, '0'
            imul edx, ebx
            add eax, edx
            jo failed_to_parse
            imul ebx, 10
            cmp ecx, 0
            jg do_while_digits_left_to_parse
            clc
            jmp finish_up

        failed_to_parse:
            stc

        finish_up:

        pop edx
        pop ebx 
        pop ecx
        pop esi
        ret 
    parse_digit_from_token endp

    .data
        parameter_buffer byte 16 dup(0)
        parameter_list DWORD 0,0,0
    .code 
    get_command_param_input_and_dispatch proc
        ; ----------------------------------------------------------------------------------------
        ; get_command_param_input
        ;
        ; Parses command input from the buffer. Prompts for missing parameters. Dispatches command
        ;   RECEIVES    ebx: address of the command
        ;               esi: the address at which to start looking
        ;               eax: the size of the user input
        ; ----------------------------------------------------------------------------------------
        pushad 


        test_param_1:
            call clear_error
            mov ecx, (COMMAND PTR [ebx]).param1         ; ecx::param1 = ebx::command.param1
            cmp ecx, offset _command_param_none         ; if(param1 == param_none)
            je dispatch_command                         ;    dispatch, no params to validate
            call find_next_non_whitespace_in_buffer     ; esi::index = find_next_non_whitespace_in_buffer(esi::index, eax::input_size)
            call get_token                              ; esi::index, cf::token_parse_failed = get_token(esi::index, eax::input_size)

            push ebx                                    ; push(ebx::command_address)

            jc bad_param_1                              ; if(cf::token_parse_failed) prompt for correct command
            mov edx, (COMMAND_PARAM PTR[ecx]).function  ; edx::validator = ecx::command_param.function
            
            call edx                                    ; cf::validation_failed, ebx::parsed_input = edx::validator()
            jc bad_param_1                              ; if(cf::validation_failed) prompt for correct command
            mov parameter_list, ebx                     ; parameter_list[0] = ebx::parsed_input
            pop ebx                                     ; ebx::command_address = pop()
            jmp test_param_2                            ; otherwise, dispatch the command.... 

        bad_param_1:
            pop ebx
            call print_parameter_prompt                 ; print_parameter_prompt(ecx::command_param)
            mov esi, 0
            mov edx, offset input_buffer
            mov ecx, input_read_size
            call ReadString                             ; eax::input_size = ReadString(*edx::input_buffer, ecx::buffer_size)
            cmp eax, 0
            je clear_param_prompt                                ; if(input_size == 0) return without executing
            jmp test_param_1

        test_param_2:
            call clear_error
            mov ecx, (COMMAND PTR [ebx]).param2         ; ecx::param2 = ebx::command.param1
            cmp ecx, offset _command_param_none         ; if(param2 == param_none)
            je dispatch_command                         ;    dispatch, no more params to validate
            call find_next_non_whitespace_in_buffer     ; esi::index = find_next_non_whitespace_in_buffer(esi::index, eax::input_size)
            call get_token                              ; esi::index, cf::token_parse_failed = get_token(esi::index, eax::input_size)

            push ebx                                    ; push(ebx::command_address)

            jc bad_param_2                              ; if(cf::token_parse_failed) prompt for correct command
            mov edx, (COMMAND_PARAM PTR[ecx]).function  ; edx::validator = ecx::command_param.function
            
            call edx                                    ; cf::validation_failed, ebx::parsed_input = edx::validator()
            jc bad_param_2                              ; if(cf::validation_failed) prompt for correct command
            mov parameter_list[4], ebx                  ; parameter_list[4] = ebx::parsed_input
            pop ebx                                     ; ebx::command_address = pop()
            jmp test_param_3                        ; otherwise, dispatch the command.... 

        bad_param_2:
            pop ebx
            call print_parameter_prompt                 ; print_parameter_prompt(ecx::command_param)
            mov esi, 0
            mov edx, offset input_buffer
            mov ecx, input_read_size
            call ReadString                             ; eax::input_size = ReadString(*edx::input_buffer, ecx::buffer_size)
            cmp eax, 0
            je clear_param_prompt                                ; if(input_size == 0) return without executing
            jmp test_param_2

        test_param_3:
            call clear_error
            mov ecx, (COMMAND PTR [ebx]).param3         ; ecx::param3 = ebx::command.param1
            cmp ecx, offset _command_param_none         ; if(param3 == param_none)
            je dispatch_command                         ;    dispatch, no more params to validate
            call find_next_non_whitespace_in_buffer     ; esi::index = find_next_non_whitespace_in_buffer(esi::index, eax::input_size)
            call get_token                              ; esi::index, cf::token_parse_failed = get_token(esi::index, eax::input_size)

            push ebx                                    ; push(ebx::command_address)

            jc bad_param_3                              ; if(cf::token_parse_failed) prompt for correct command
            mov edx, (COMMAND_PARAM PTR[ecx]).function  ; edx::validator = ecx::command_param.function
            
            call edx                                    ; cf::validation_failed, ebx::parsed_input = edx::validator()
            jc bad_param_3                              ; if(cf::validation_failed) prompt for correct command
            mov parameter_list[8], ebx                  ; parameter_list[4] = ebx::parsed_input
            pop ebx                                     ; ebx::command_address = pop()
            jmp dispatch_command                        ; otherwise, dispatch the command.... 

        bad_param_3:
            pop ebx
            call print_parameter_prompt                 ; print_parameter_prompt(ecx::command_param)
            mov esi, 0
            mov edx, offset input_buffer
            mov ecx, input_read_size
            call ReadString                             ; eax::input_size = ReadString(*edx::input_buffer, ecx::buffer_size)
            cmp eax, 0
            je clear_param_prompt                                ; if(input_size == 0) return without executing
            jmp test_param_3

        dispatch_command:
            call clear_parameter_prompt
            mov edx, (COMMAND PTR[ebx]).function
            mov eax, parameter_list[0]
            mov ebx, parameter_list[4]
            mov ecx, parameter_list[8]
            call edx
            jmp finish_up
        
        clear_param_prompt:
            ;call clear_error
            call clear_parameter_prompt

        finish_up:
        popad 
        ret
    get_command_param_input_and_dispatch endp

    .data

        input_buffer byte 100 dup(0)
        input_read_size equ sizeof input_buffer - 3


    .code

    copy_token_buffer_to_parameter_buffer proc
        ; -----------------------------------------------------------------------------------------------------------------------------------------------------------
        ; copy_token_buffer_to_parameter_buffer
        ;
        ; copies the contents of the token_buffer to the parameter_buffer. Called by validators to save valid token parameters for passing to command functions later.
        ; -----------------------------------------------------------------------------------------------------------------------------------------------------------
        push esi
        push edi
        push eax 
        push ecx 

        mov ecx, sizeof token_buffer
        mov esi, 0
        mov edi, 0
        do_while_characters_left_to_copy:
            mov al, token_buffer[esi]
            mov parameter_buffer[edi], al
            inc esi
            inc edi 
            cmp esi, ecx
            jl do_while_characters_left_to_copy

        pop ecx 
        pop eax
        pop edi 
        pop esi 
        ret
    copy_token_buffer_to_parameter_buffer endp 

    is_whitespace proc
        ; ----------------------------------------------------------------
        ; is_whitespace
        ;
        ; parses a character and determines if it is whitespace
        ;   RECEIVES    al :    the character to process
        ;   RETURNS     cf :    1 if whitespace, 0 if not whitespace
        ; ----------------------------------------------------------------
        cmp al, 33              ; all ascii codes < 33 are whitespace
        jl whitespace_true
        jmp whitespace_false

        whitespace_true:
            stc
            jmp finish

        whitespace_false:
            clc

        finish:

        ret
    is_whitespace endp
    
    capitalize_if_letter proc
        ; ---------------------------------------------------------------------------
        ; capitalize_if_letter
        ;
        ; changes al to a capital letter, if it's a letter. Otherwise stays the same.
        ;   RECEIVES    al: a character to test
        ;   RETURNS     al: a character, capitalized if a letter
        ; ---------------------------------------------------------------------------
        cmp al, 'a'
        jl finish_up
        cmp al, 'z'
        jg finish_up
        and al, 11011111b
        finish_up:
        ret
    capitalize_if_letter endp

    get_string_size proc
        ; --------------------------------------------------------------------------
        ;   get_string_size
        ;
        ;   gets the size of a string pointed to by esi
        ;
        ;   RECEIVES    esi - a pointer to a string
        ;   RETURNS     ecx - the size of the string, characters before null byte (0)
        ; --------------------------------------------------------------------------
        mov ecx, 0
        push esi 
        do_while_not_null_character:
            cmp byte ptr [esi], 0
            je end_while
            inc esi
            inc ecx
            jmp do_while_not_null_character
        end_while:
        pop esi
        
        ret
    get_string_size endp

    .data
        token_buffer byte 16 dup(0)
        token_size byte 0
    .code 
    get_token proc 
        ; -------------------------------------------------------------------------------
        ; get_token
        ;
        ; loads a token into the token_buffer, prints an error if there was a problem
        ;   RECEIVES    esi - the index to start getting the token from
        ;
        ;   RETURNS     cf - 1 if failed(token too large for the buffer), 0 if succesful
        ;               esi - the index the next whitespace starts at
        ; -------------------------------------------------------------------------------
        push edi
        push ecx
        push eax 
        push edx 
        mov edi, 0
        mov ecx, lengthof token_buffer - 1                      ; ecx::buff_size = token_buffer.size()
        while_not_whitespace_and_token_buffer_room:             ; while(edi::index < ecx::buff_size)
            mov al, input_buffer[esi]                           ;  al::char_test = input_buffer[esi::index]
            call is_whitespace                                  ;  cf::is_whitespace = is_whitespace(al::char_test)
            jc whitespace_found                                 ;  if(is_whitespace) finish parsing
            call capitalize_if_letter                           ;  al::char = capitalize_if_letter(al::char)
            mov token_buffer[edi], al                           ;  token_buffer[edi::index] = al::char
            inc esi                                             ;  esi::index += 1
            inc edi                                             ;  edi::index += 1
            cmp edi, ecx                                        
            jl while_not_whitespace_and_token_buffer_room

        bad_token:
            stc 
            jmp end_while

        whitespace_found:
            mov token_buffer[edi], 0
            inc edi
            cmp edi, ecx
            jl whitespace_found
            clc

        end_while:
            mov token_buffer[edi], 0

        pop edx 
        pop eax
        pop ecx
        pop edi
        ret 
    get_token endp
    find_next_non_whitespace_in_buffer proc
        ; ---------------------------------------------------------------------------------------
        ; find_next_non_whitespace_in_buffer
        ;
        ; Finds the next non-whitespace in the buffer
        ;   RECEIVES    esi - the index to start looking at
        ;               eax - the maximum length to search, exclusive (max size of input)
        ;
        ;   RETURNS     esi - the index non-whitespace input starts again, -1 if max size reached
        ; ---------------------------------------------------------------------------------------
        push eax 
        push ecx 
        pushf 
        mov ecx, eax 
        do_while_not_whitespace_and_left_to_search:
            mov al, input_buffer[esi]
            call is_whitespace
            jnc end_while
            inc esi 
            cmp esi, ecx
            jl do_while_not_whitespace_and_left_to_search
            jmp end_while_hit_max_length 

        end_while_hit_max_length:
            mov esi, -1

        end_while:

        popf
        pop ecx
        pop eax
        ret 
    find_next_non_whitespace_in_buffer endp

    parse_input proc
		
        ; -----------------------------------------------------------
        ; parse_input
        ;
        ;   RECEIVES    eax: size of input
        ;
        ;   RETURNS:    cf = 1 if quit, otherwise cf = 0
        ; -----------------------------------------------------------
        mov esi, 0                                  ; ESI::parse_index = 0
        call find_next_non_whitespace_in_buffer     ; esi::index = find_next_non_whitespace_in_buffer(esi::index, eax::input_size)
        call get_token                              ; esi::index = get_token(esi::index)
        mov edi, offset token_buffer                ; edi::token_buffer = *token_buffer
        call match_command                          ; ebx::command, CF::command_success_flag = match_command(edi::token_buffer)
        jnc dispatch_command                        ; if(cf::command_success_flag)
        clc                                         ;   cf::quit_flag = false
        jmp finish_up                               ;   

        dispatch_command:                           ; else
            clc 
            call get_command_param_input_and_dispatch  ; get_command_param_input_and_dispatch(ebx::command_ptr, esi::index)
        finish_up:
        ret
    parse_input endp
; =========================================================== Main Loop
    get_input_and_draw_until_quit proc
        ; -----------------------------------------------------------------------------------------------
        ; get_input_and_draw_until_quit
        ;
        ; reads input until quit flag is set. Redraws visible structures and parse_inputs each iteration
        ; -----------------------------------------------------------------------------------------------
        while_not_quit:
            call print_visible_structures
            invoke SetConsoleCursorPosition, outHandle, coord_input
            mov edx, offset input_buffer
            mov ecx, input_read_size
            call ReadString             ; eax::input_size = ReadString(*edx::input_buffer, ecx::buffer_size)
            cmp eax, 0
            jne command_may_have_been_entered
            jmp enter_was_pressed_with_no_input
            command_may_have_been_entered:
                call clear_error            ; // clear errors here so the last error is visible
                call parse_input            ; cf::quit_flag = parse_input(eax::input_size)
                cmp quit, 1
                jne while_not_quit
                jmp end_while
            enter_was_pressed_with_no_input:
                call clear_error
                call flash_prompt
                clc
                jmp while_not_quit

        end_while:
        ret
    get_input_and_draw_until_quit endp
	
	.data
		test_header		byte	"Hello! This is a TEST.", 0
		test_header_2	byte	"Press any key to continue.", 0
		
	.code
    main proc
        call GetTextColor
        push eax
        mov eax, lightgray         ; user input is light gray 
        call SetTextColor 

		call Clrscr
        call initialize_printing		
        call get_input_and_draw_until_quit

        pop eax
        call SetTextColor
    exit
    main endp
    end main