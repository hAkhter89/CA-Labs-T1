.text
.globl main
main:
    addi x10, x0, 12 # x10 = 12
    addi x11, x0, 12 # x11 =  12
    jal x1, sum # jumps to sum label
    addi x11, x10, 0 # x11 = 24
    li x10, 1 # x10 = 1
    ecall #print_int the value of x11(a1)
    j exit
sum:
    add x10, x11, x10 # x10 + x11 = 24
    jalr x0, 0(x1) # goes back to x1
exit:
    j exit