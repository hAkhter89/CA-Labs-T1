.text
.globl main

main:
    li x20, 1 #x
    li x21, 2 #a
    li x22, 3 #b
    li x23, 4 #c

    li x27, 1 #for comparasion x == 1
    li x28, 2 #for comparasion x == 2
    li x29, 3 #for comparasion x == 3
    li x30, 4 #for comparasion x == 4

    beq x20, x27, case1 #if x == 1
    beq x20, x28, case2 #if x == 2
    beq x20, x29, case3 #if x == 3
    beq x20, x30, case4 #if x == 4
    li x21, 0 #default case
    beq x0, x0, exit   # Jump to exit after default
case1:
    add x21, x22, x23 #a = b+c
    beq x0, x0, exit 
case2:
    sub x21, x22, x23 #a = b-c
    beq x0, x0, exit

case3:
    slli x21, x22, 1 #a = b*2
    beq x0, x0, exit
case4:
    srli x21, x22, 1 #a = b/2
    beq x0, x0, exit

exit:
    j exit