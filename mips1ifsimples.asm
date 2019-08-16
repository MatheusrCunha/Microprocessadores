#  if ( x == y ) go to L2;
#	a= b + c;
#	L2 : a = b - c;
# x = $s0, y = $s1, a = $s2, b = $s3, c = $s4.

	beq $s0, $s1, L2 #desvia para L2 se x == y
	add $s2, $s3, $s4 
        L2: sub $s2, $s3, $s4