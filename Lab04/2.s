.text
.globl main

main:
    li x10, 11             #sum till 66 => answer
    jal x1, loop           #jump to loop link address to x1
    addi x11, x10, 0       # store result in x11

    li x10, 1
    ecall
    
    j exit 


loop:
    li x6, 1                # x6 = 1 used for base case comparison
    ble x10, x6, exit_loop  # if n <= 1 exit

    addi sp, sp, -8         # make space for ra and n
    sw x1, 4(sp)            # save return address
    sw x10, 0(sp)           # save current n

    addi x10, x10, -1       # n = n - 1
    jal x1, loop            # recursive call

    lw x7, 0(sp)            # restore original n into x7
    lw x1, 4(sp)            # restore return address
    addi sp, sp, 8          # free stack space

    add x10, x10, x7        # #the recursive call + n
    jalr x0, 0(x1)          # return


exit_loop:
    li x10, 1               #return 1
    jalr x0, 0(x1)


end:
    j end

exit:
    j end