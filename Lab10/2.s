.text
.globl main
main:
        MOV R0, #INPUT_WAITING     # State variable
        MOV R4, #0                 # Countdown value

MAIN_LOOP:
        LDR R5, =RESET_FLAG
        LDR R6, [R5]
        CMP R6, #1
        BEQ RESET_HANDLER

# FSM State Check
        CMP R0, #INPUT_WAITING
        BEQ STATE_INPUT

        CMP R0, #COUNTDOWN
        BEQ STATE_COUNTDOWN

        B MAIN_LOOP

# Input Waiting State
STATE_INPUT:
        LDR R1, =SWITCH_PORT
        LDR R2, [R1]              # Read switches

        CMP R2, #0
        BEQ MAIN_LOOP             # Stay if no input

        # Display switch value on LEDs
        LDR R3, =LED_PORT
        STR R2, [R3]

        # Save value for countdown
        MOV R4, R2

        # Change state
        MOV R0, #COUNTDOWN
        B MAIN_LOOP

# Countdown State
STATE_COUNTDOWN:
        MOV R1, R4                # Pass argument
        BL COUNTDOWN_SUB          # Call subroutine

        # After countdown ends → go back
        MOV R0, #INPUT_WAITING
        B MAIN_LOOP

# Reset Handler
RESET_HANDLER:
        MOV R0, #INPUT_WAITING
        MOV R4, #0

        # Clear LEDs
        LDR R3, =LED_PORT
        MOV R2, #0
        STR R2, [R3]

        B MAIN_LOOP