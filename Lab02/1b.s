.text
.globl main

main:
    li x22, 0
    li x24, 2


    li x26, 2
    li x27, 1
    li x28, 0

    sw x28, 0(x25)
    sw x26, 4(x25)
    sw x27, 8(x25)
    sw x28, 12(x25)
    sw x28, 16(x25)

Loop:
    slli x10, x22, 2
    add x10, x10, x25
    lw x9, 0(x10)
    bne x9, x24, Exit
    addi x22, x22, 1
    beq x0, x0, Loop
Exit:
    j Exit