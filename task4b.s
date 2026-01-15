lb   x5, 3(x10)        # x5 = a[3]
lh   x6, 6(x11)        # x6 = b[3]
add  x7, x5, x6
sw   x7, 12(x12)       # c[3]