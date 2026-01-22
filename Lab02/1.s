.text 
.globl main

main:
    li x22, 0 # i
    li x23, 0  # j
    li x21, 1 # h
    li x20, 1 # g
    la x25, save
    bne x19, x23, Else
    add x19, x20, x21
    beq x0, x0, Loop
Else:
    sub x19, x20, x21
