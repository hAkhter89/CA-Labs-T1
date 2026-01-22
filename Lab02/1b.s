.text
.globl main

main:
    li x22, 0
    li x24, 2
    la x25, save
Loop:
    slli x10, x22, 2
    add x10, x10, x25
    lw x9, 0(x10)
    bne x9, x24, Exit
    addi x22, x22, i
    beq x0, x0, Loop
Exit:
    j end