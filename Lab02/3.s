.text
.globl main

main:
    # First loop: a[i] = i
    li x22, 0          # x22 = i = 0 
    li x25, 0x200      # x25 has base address as 0x200
    li x28, 10         # Loop limit comparision
    
Loop1:
    slli x9, x22, 2    # i * 4(basically we are starting to traverse in an array)
    add x9, x9, x25    # go at a[i]
    sw x22, 0(x9)      # set a[i] = i, x9 which is our a[i]
    addi x22, x22, 1   # i++
    bge x22, x28, reset # if i >= 10, exit
    beq x0, x0, Loop1  # continue loop

reset:
    # Reset for second loop
    li x22, 0          # Reset i = 0
    li x23, 0          # sum = 0
    li x29, 10         # Loop limit

Loop2:
    slli x10, x22, 2   # i * 4(starting to traverse in an array)
    add x10, x10, x25  # address of a[i]
    lw x11, 0(x10)     # load a[i]
    add x23, x23, x11  # sum = sum + a[i]
    addi x22, x22, 1   # i++
    bge x22, x29, exit # if i >= 10, exit
    beq x0, x0, Loop2  # continue loop

exit:
    j exit

    