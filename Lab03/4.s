.text
.globl main
main: # initialize string
    li x10, 0x100      

    li x1, 0x48         # 'H'
    sb x1, 0(x10)
    
    li x1, 0x45         # 'E'
    sb x1, 1(x10)
    
    li x1, 0x4C         # 'L'
    sb x1, 2(x10)
    
    li x1, 0x4C         # 'L'
    sb x1, 3(x10)
    
    li x1, 0x4F         # 'O'
    sb x1, 4(x10)
    
    li x1, 0x00         # '\0' Null Terminator
    sb x1, 5(x10)

    li x11, 0x200       # Destination Address x11
strcpy:
    addi sp, sp, -4     # Adjust stack for 1 word
    sw x19, 0(sp)       # Save x19

    add x19, x0, x0     # i = 0

loop:
    add x5, x10, x19    # x5 = memort location of y[i]
    lb x6, 0(x5)       # x6 = y[i]

    add x7, x11, x19    # x7 = memory location of x[i]
    sb x6, 0(x7)        # x[i] = x6

    beq x6, x0, out    # if x6 == 0, exit // detection for null terminator, value is 0
    addi x19, x19, 1    # i++
    jal x0, loop        # repeat

out:
    lw x19, 0(sp)       # Restore x19
    addi sp, sp, 4      # Restore stack
    jalr x0, 0(x1)      # Return

