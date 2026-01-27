.text
.globl main
main:
    # Manually creating the list in memory with the base address 0x10000000 in x25
    li x25, 0x10000000      # base address
    
    # Store the values: save[] = {5, 5, 5, 3}
    #x10 is our temporary register used to store values in the list
    li x10, 5
    sw x10, 0(x25)          # save[0] = 5
    sw x10, 4(x25)          # save[1] = 5
    sw x10, 8(x25)          # save[2] = 5
    li x10, 3
    sw x10, 12(x25)         # save[3] = 3
    
    # Initialize registers
    li x22, 0               # i = 0
    li x24, 5               # k = 5
    
    # Use the exact instructions from the listing
Loop: 
    slli x10, x22, 2        # Temp reg x10 = i * 4
    add x10, x10, x25       # x10 = address of save[i]
    lw x9, 0(x10)           # Temp reg x9 = save[i]
    bne x9, x24, Exit       # go to Exit if save[i] != k
    addi x22, x22, 1        # i = i + 1
    beq x0, x0, Loop        # go to Loop

Exit:
    j Exit