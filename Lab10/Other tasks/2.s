# Simplified Countdown Program
# Uses only: addi, add, beq, lw, sw

# Memory layout (byte addresses):
# 0x00 = reset_flag
# 0x04 = switch_port (input value)  
# 0x08 = led_port

# Register usage:
# x1  = reset_flag value
# x2  = switch value / countdown
# x3  = led output
# x10 = state (0=input, 1=countdown)

# Initialize
addi x10, x0, 0      # state = INPUT_WAITING
addi x2,  x0, 5      # simulate switch input = 5

main_loop:
    # Check reset
    lw   x1, 0(x0)       # load reset_flag
    addi x3, x0, 1
    beq  x1, x3, reset   # if reset_flag == 1, reset

    # Check state
    beq  x10, x0, input  # if state == 0, go to input

countdown:
    beq  x2, x0, done    # if countdown == 0, done
    sw   x2, 8(x0)       # write to LED
    addi x2, x2, -1      # decrement
    beq  x0, x0, countdown # loop

input:
    lw   x2, 4(x0)       # read switch
    beq  x2, x0, main_loop # if 0, wait
    sw   x2, 8(x0)       # display on LED
    addi x10, x0, 1      # state = COUNTDOWN
    beq  x0, x0, main_loop # loop

reset:
    addi x10, x0, 0      # state = INPUT_WAITING
    addi x2,  x0, 0      # clear countdown
    sw   x0,  8(x0)      # clear LEDs
    sw   x0,  0(x0)      # clear reset_flag
    beq  x0, x0, main_loop # loop

done:
    sw   x0, 8(x0)       # clear LEDs
    beq  x0, x0, main_loop # loop back