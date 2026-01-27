.text
.globl main

main:
    # Initialize variables as specified
    li x5, 5           # a = 5
    li x6, 3           # b = 3 
    li x10, 0x200      # Base address of array D
    
    # Initialize i = x7 = 0 for outer loop
    li x7, 0           # i = 0
    
outer_loop:
    # for outer loop condition => i < a (x5)
    bge x7, x5, exit   # if i >= a, exit
    
    # Initialize j = x29 to 0 for inner loop
    li x29, 0          # j = 0
    
inner_loop:
    # for another loop condition: j < b (x6)
    bge x29, x6, end_inner   # if j >= b, exit inner loop
    
    # Calculate address of D[4*j]
    # Since each element is 4 bytes, offset = (4*j) * 4 = 16*j
    slli x30, x29, 4   # x30 = j * 16 
    add x31, x10, x30  # x31 = base address + offset (address of D[4*j])
    
    # Calculate i + j for value to store
    add x30, x7, x29   # x30 = i + j (value)
    
    # Store value in array
    sw x30, 0(x31)     # D[4*j] = i + j
    
    # Increment j
    addi x29, x29, 1   # j = j + 1
    
    # Continue inner loop
    beq x0, x0, inner_loop

end_inner:
    # Increment i
    addi x7, x7, 1     # i = i + 1
    
    # Continue outer loop
    beq x0, x0, outer_loop

exit:
    j exit