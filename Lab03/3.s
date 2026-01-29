.text
.globl main

main:
    # Initialiing Arr
    li x10, 0x100 # v[]
    li x11, 1 # k
    li x18, 3
    li x19, 5
    li x20, 10
    sw x18, 0(x10)
    sw x19, 4(x10)
    sw x20, 8(x10)

    

    jal x1, swap
    j exit

swap:
    slli x6, x11, 2
    add x6, x6, x10
    lw x7, 0(x6) # v[k] = temp
    lw x8, 4(x6)
    sw x8, 0(x6) # v[k] = v[k+1]
    sw x7, 4(x6) # v[k+1] = temp
    jalr x0, 0(x1)

exit:
    j exit



