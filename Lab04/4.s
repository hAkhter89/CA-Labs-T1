.text
.globl main

main:
    li x10, 6          # n = 6
    jal x1, fib        # jump to fib linking it to x1

    addi x11, x10, 0   # store result in x11 (optional)

    li x17, 1          # print integer
    ecall

    li x17, 10         # exit syscall
    ecall


fib:
    #allocating stack
    addi sp, sp, -16      
    sw x1, 12(sp)      # storing main return in x1
    sw x10, 8(sp)      # storing n in x10

    li x5, 1           #comparision statement
    ble x10, x5, base      # if n <= 1 go to base case

    addi x10, x10, -1   #n = n-1 first recursive call
    jal x1, fib
    sw x10, 4(sp)      # store fib(n-1)

    lw x10, 8(sp)      # restore original n
    addi x10, x10, -2   #n = n-2 second recursive call
    jal x1, fib

    lw x6, 4(sp)       # load fib(n-1)
    add x10, x10, x6   # fib(n-1) + fib(n-2)

    lw x1, 12(sp)      # restore return address
    # deallocation stack
    addi sp, sp, 16        
    jalr x0, 0(x1)


base:
    lw x1, 12(sp)      # restore return address
    addi sp, sp, 16    # deallocate stack
    jalr x0, 0(x1)


exit:
    j exit