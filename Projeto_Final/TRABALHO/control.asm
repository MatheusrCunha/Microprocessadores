


.macro moveIntention (%name,%isValid,%X,%Y,%isPaused)
#		 	 offset:  &  ,    0  , 4, 8,   12 
.data
%name:
.align 2
	.word %isValid
	.word %X
	.word %Y
	.word %isPaused
.end_macro

moveIntention (kbBuffer,0,0,0,0)

