.data
reset_flag:  .word 0        # 0 = no reset, 1 = reset
switch_port: .word 5        # Simulate switch input (change to test)
led_port:    .word 0        # LED output

.equ INPUT_WAITING, 0
.equ COUNTDOWN,     1

.text
.globl main

main:
    li   a0, INPUT_WAITING      # a0 = state
    li   s0, 0                  # s0 = countdown value

main_loop:
    la   t0, reset_flag
    lw   t1, 0(t0)
    li   t2, 1
    beq  t1, t2, reset_handler

    li   t2, INPUT_WAITING
    beq  a0, t2, state_input
    li   t2, COUNTDOWN
    beq  a0, t2, state_countdown
    j    main_loop


state_input:
    la   t0, switch_port
    lw   t1, 0(t0)              # Read switches
    beqz t1, main_loop          # Stay if no input

    la   t0, led_port
    sw   t1, 0(t0)              # Display on LEDs

    mv   s0, t1                 # Save value for countdown
    li   a0, COUNTDOWN          # Change state
    j    main_loop

state_countdown:
    mv   a0, s0                 # Pass countdown value
    call countdown_sub
    li   a0, INPUT_WAITING      # Return to input state
    j    main_loop


reset_handler:
    li   a0, INPUT_WAITING
    li   s0, 0
    la   t0, led_port
    sw   zero, 0(t0)            # Clear LEDs
    # Clear reset flag
    la   t0, reset_flag
    sw   zero, 0(t0)
    j    main_loop


# a0 = starting countdown value
# Counts down to 0, updating LED each step

countdown_sub:
    addi sp, sp, -16            # Allocate stack frame
    sw   ra, 12(sp)             # Save return address
    sw   s1, 8(sp)              # Save s1

    mv   s1, a0                 # s1 = countdown value

countdown_loop:
    blez s1, countdown_done     # If <= 0, done

    # Write current count to LED
    la   t0, led_port
    sw   s1, 0(t0)

    # Delay
    call delay_sub

    addi s1, s1, -1             # Decrement
    j    countdown_loop

countdown_done:
    # Clear LEDs when done
    la   t0, led_port
    sw   zero, 0(t0)

    lw   ra, 12(sp)             # Restore return address
    lw   s1, 8(sp)              # Restore s1
    addi sp, sp, 16             # Free stack frame
    ret

# Simple loop for simulation
delay_sub:
    addi sp, sp, -8
    sw   ra, 4(sp)
    sw   s2, 0(sp)

    li   s2, 1000               # Delay count (adjust for simulation speed)

delay_loop:
    beqz s2, delay_done
    addi s2, s2, -1
    j    delay_loop

delay_done:
    lw   ra, 4(sp)
    lw   s2, 0(sp)
    addi sp, sp, 8
    ret