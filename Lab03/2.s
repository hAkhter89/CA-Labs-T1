.text
.globl main
main:
    addi x2, x2, -12 # push stack back by 3
    sw x18, 8(x2) # bottom of stack
    sw x19, 4(x2) # middle
    sw x20, 0(x2) # top of stack
    #initializing g,h,i,j
    li x10, 5
    li x11, 6
    li x12, 7
    li x13, 8
    #function call
    jal x1, stack
    lw x20, 0(x2)
    lw x19, 4(x2)
    lw x18, 8(x2)
    addi x2, x2, 12
    j exit
stack:
    add x18, x10, x11 # g+h
    add x19, x12, x13 # i + j
    sub x20, x18, x19 # x20 = f
    addi x10, x20, 0 # return val
    jalr x0, 0(x1)
exit:
    j exit