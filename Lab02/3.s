.text
.globl main
main:
    li x20, 0
    li x25, 0x100
    li x28, 10
Loop:
    slli x9, x20, 2
    add x9, x9, x25 # a[i]
    sw x20, 0(x9)
    bge x20, x28, main2    # stop x20 >= 10
    addi x20, x20, 1
    beq x0, x0, Loop

main2:
    li x21, 0
    li x29, 10
    li x30, 0 # sum
Loop2:
    slli x10, x21, 2
    add x10, x10, x25 # a[i]
    lw x11, 0(x10)
    bge x21, x29, exit    # stop x21 >= 10
    add x30, x30, x11
    addi x21, x21, 1
    beq x0, x0, Loop2

exit:
    j exit

    