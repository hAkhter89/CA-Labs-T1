.text
.globl main

main:
    li x20, 1
    li x21, 2
    li x22, 3
    li x23, 4

    li x27, 1
    li x28, 2
    li x29, 3
    li x30, 4

    beq x20, x27, case1
    beq x20, x28, case2
    beq x20, x29, case3
    beq x20, x30, case4
    li x21, 0
case1:
    add x21, x22, x23
    beq x0, x0, exit 
case2:
    sub x21, x22, x23
    beq x0, x0, exit

case3:
    slli x21, x22, 1
    beq x0, x0, exit
case4:
    srli x21, x22, 1
    beq x0, x0, exit

exit:
    j exit
