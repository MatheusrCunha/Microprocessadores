# if(a < b + 3 )
# 	a = a + 1
# else
#       a = a + 2
#  b = b + a
# a: $t0, b: $t1
# op dest, src1, src2
# add a, b,c  addi a, b, 12  a <- b + 12

     addi $t2, $t1, 3  # tmp = b + 3
     blt $t0, $t2, then  #if( a < temp)
     addi $t0, $t0, 2  #else case
     j end
then: addi $t0, $t1, 1
end:  add $t1, $t1, $t0