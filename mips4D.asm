.text
              #[f; g] = (h * i) + (i * i) # resultado de 64 bits, Hi em f e Lo em g
              
              mul $t0, $s2, $s3
              mul $t1, $s3, $s3
              add $s0, $t0, $t1