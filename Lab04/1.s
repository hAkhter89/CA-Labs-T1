.text
.globl main

main:
    addi x10, x0, 5
    jal  x1, fact
    j exit    

fact:
    addi sp, sp, -16   # push stack
    sw   x1, 8(sp)     # return address on stack
    sw   x10, 0(sp)    

    # BASE CASE
    addi x5, x0, 1      # x5 = 1
    blt  x10, x5, base  # If n < 1, base case

    # recusrive else
    addi x10, x10, -1 # n = n - 1
    jal  x1, fact # fact(n-1)
    
    # returning to after the recursive call
    lw   x6, 0(sp)       # load n to x6
    mul  x10, x10, x6    # x10 = fact(n-1) * n
    j    return

base:
    addi x10, x0, 1   # return 1 for base case

return:
    # release stack
    lw   x1, 8(sp)       # Restore the next return address
    addi sp, sp, 16      # release current block of stack calls
    jalr x0, 0(x1)       # return to next address

exit:
    j exit