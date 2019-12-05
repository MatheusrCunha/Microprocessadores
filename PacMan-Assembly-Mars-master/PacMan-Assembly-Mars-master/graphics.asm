.eqv FB_PTR 0x10040000
.eqv FB_XRES 256
.eqv FB_YRES 256

.eqv X_OFFSET  0
.eqv Y_OFFSET  0
.eqv X_SCALE   7
.eqv Y_SCALE   7

.eqv GRID_ROWS 35       
.eqv GRID_COLS 35       
.eqv GRID_ID_OFFSET -64

.eqv NUMBER_OF_GHOSTS 6

.macro animatedSprite (%name, %id, %posX, %posY, %movX, %movY)
#		 	ofset:	&  ,  0 ,    4 ,    8 ,   12 ,   16
.data
%name:
.align 2
	.word %id
	.word %posX
	.word %posY
	.word %movX
	.word %movY
.end_macro

	#animatedSprite(pacman, 3, 119, 140, 0, 0)
	#animatedSprite(ghost0, 2, 105, 105, -1, 1)
	#animatedSprite(ghost1, 2, 105, 119, -1, -1)
	#animatedSprite(ghost2, 2, 133, 105, 1, 1)
	#animatedSprite(ghost3, 2, 133, 119, 1, -1)
	#animatedSprite(ghost4, 2, 112, 112, -1, 0)
	#animatedSprite(ghost5, 2, 126, 112, 1, 0)
	#animatedSprite(null,   0,   0,   0, 0, 0)
	animatedSprite(pacman, 3, 0, 0, 0, 0)
	animatedSprite(ghost0, 2, 0, 0, 0, 0)
	animatedSprite(ghost1, 2, 0, 0, 0, 0)
	animatedSprite(ghost2, 2, 0, 0, 0, 0)
	animatedSprite(ghost3, 2, 0, 0, 0, 0)
	animatedSprite(ghost4, 2, 0, 0, 0, 0)
	animatedSprite(ghost5, 2, 0, 0, 0, 0)
	animatedSprite(null	 , 0, 0, 0, 0, 0)
	
	
.data
# 35x35 Pacman Arena - Sprites 7x7
grid:
#.ascii "ENNNNNNGNNNGNNNGF@EGNNNGNNNGNNNNNNF"
.ascii "ENNNNNNGNNNGNNNGGNGGNNNGNNNGNNNNNNF"
.ascii "IA@@@@@I@@@I@@@LK@JM@@@I@@@I@@@@@AI"
.ascii "I@ONNP@I@Q@I@Q@I@@@I@Q@I@Q@I@ONNP@I"
.ascii "I@@@@@@I@I@I@I@R@Q@R@I@I@I@I@@@@@@I"
.ascii "LNNNNP@R@I@I@I@@@I@@@I@I@I@R@ONNNNM"
.ascii "I@@@@@@@@I@R@LNNNSNNNM@R@I@@@@@@@@I"
.ascii "I@ENNF@Q@I@D@I@D@I@D@I@D@I@Q@ENNF@I"
.ascii "I@JNNK@I@LNGNM@I@I@I@LNGNM@I@JNNK@I"
.ascii "I@@@@@@I@IDIDI@I@I@I@IDIDI@I@@@@@@I"
.ascii "I@ONNNNM@I@I@I@I@I@I@I@I@I@LNNNNP@I"
.ascii "I@@@@@@I@I@R@R@I@R@I@R@R@I@I@@@@@@I"
.ascii "I@ENNF@I@I@@@@@I@@@I@@@@@I@I@ENNF@I"
.ascii "I@JNNK@I@JP@Q@OHP@OHP@Q@OK@I@JNNK@I"
.ascii "I@@@@@@I@@@@I@@@@@@@@@I@@@@I@@@@@@I"
.ascii "LNNNNP@I@EF@R@ENP@ONF@R@EF@I@ONNNNM"
.ascii "IA@@@@@I@JK@@@R@@@@@R@@@JK@I@@@@@AI"
.ascii "LNNNNNNK@@@@Q@@A@@@A@@Q@@@@JNNNNNNM"
.ascii "I@@@@@@@@OP@I@Q@@@@@Q@I@OP@@@@@@@@I"
.ascii "LNNNNNNF@@@@R@JNNNNNK@R@@@@ENNNNNNM"
.ascii "IA@@@@@I@EF@@@@@@@@@@@@@EF@I@@@@@AI"
.ascii "LNNNNP@I@JK@ENNNPCONNNF@JK@I@ONNNNM"
.ascii "I@@@@@@I@@@@I@@@@@@@@@I@@@@I@@@@@@I"
.ascii "I@ENNF@I@EP@R@OGP@OGP@R@OF@I@ENNF@I"
.ascii "I@JNNK@I@I@@@@@I@@@I@@@@@I@I@JNNK@I"
.ascii "I@@@@@@I@I@Q@Q@I@Q@I@Q@Q@I@I@@@@@@I"
.ascii "I@ONNNNM@I@I@I@I@I@I@I@I@I@LNNNNP@I"
.ascii "I@@@@@@I@IDIDI@I@I@I@IDIDI@I@@@@@@I"
.ascii "I@ENNF@I@LNHNM@R@I@R@LNHNM@I@ENNF@I"
.ascii "I@JNNK@R@I@D@I@D@I@D@I@D@I@R@JNNK@I"
.ascii "I@@@@@@@@I@Q@LNNNSNNNM@Q@I@@@@@@@@I"
.ascii "LNNNNP@Q@I@I@I@@@I@@@I@I@I@Q@ONNNNM"
.ascii "I@@@@@@I@I@I@I@Q@R@Q@I@I@I@I@@@@@@I"
.ascii "I@ONNP@I@R@I@R@I@@@I@R@I@R@I@ONNP@I"
.ascii "IA@@@@@I@@@I@@@LF@EM@@@I@@@I@@@@@AI"
#.ascii "JNNNNNNHNNNHNNNHK@JHNNNHNNNHNNNNNNK"
.ascii "JNNNNNNHNNNHNNNHHNHHNNNHNNNHNNNNNNK"


.eqv BLACK  0x00000000
.eqv BLUE   0x001111ff
.eqv PURPLE 0x00b711ff
.eqv YELLOW 0x00fffc60
.eqv RED    0x00ff0000
.eqv GREEN  0x00007000
.eqv GRAY   0x00a0a0a0
.eqv WHITE  0x00ffffff

colors: .word BLACK, BLUE, PURPLE, YELLOW 
        .word RED, GREEN, GRAY, WHITE

.eqv SPRITE_SIZE 49
sprites:
#Comida
.byte 0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0
.byte 0,0,0,6,0,0,0
.byte 0,0,6,6,6,0,0
.byte 0,0,0,6,0,0,0
.byte 0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0
#Invenc.
.byte 0,0,0,0,0,0,0
.byte 0,0,0,1,0,0,0
.byte 0,0,1,1,1,0,0
.byte 0,1,1,1,1,1,0
.byte 0,0,1,1,1,0,0
.byte 0,0,0,1,0,0,0
.byte 0,0,0,0,0,0,0
#Inimigo
.byte 0,0,0,0,0,0,0
.byte 0,0,2,2,2,0,0
.byte 0,2,0,2,0,2,0
.byte 0,2,2,2,2,2,0
.byte 0,2,2,2,2,2,0
.byte 0,2,0,2,0,2,0
.byte 0,0,0,0,0,0,0
#PACMAN
.byte 0,0,0,0,0,0,0
.byte 0,0,3,3,3,0,0
.byte 0,3,3,3,3,3,0
.byte 0,3,3,3,3,3,0
.byte 0,3,3,3,3,3,0
.byte 0,0,3,3,3,0,0
.byte 0,0,0,0,0,0,0
#Cereja
.byte 0,0,0,0,0,0,0
.byte 0,0,0,0,5,5,0
.byte 0,0,0,5,5,0,0
.byte 0,4,4,4,0,0,0
.byte 0,4,4,4,0,0,0
.byte 0,4,4,4,0,0,0
.byte 0,0,0,0,0,0,0
#Canto Sup. Esq.
.byte 0,0,0,0,0,0,0
.byte 0,0,0,6,6,6,6
.byte 0,0,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,0
#Canto Sup. Dir.
.byte 0,0,0,0,0,0,0
.byte 6,6,6,6,0,0,0
.byte 6,6,6,6,6,0,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
#Tee Inferior
.byte 0,0,0,0,0,0,0
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 0,6,6,6,6,6,0
#Tee Superior
.byte 0,6,6,6,6,6,0
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 0,0,0,0,0,0,0
#Parede Vertical
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
#Canto Inf. Esq.
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,0,6,6,6,6,6
.byte 0,0,0,6,6,6,6
.byte 0,0,0,0,0,0,0
#Canto Inf. Dir.
.byte 0,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,0,0
.byte 6,6,6,6,0,0,0
.byte 0,0,0,0,0,0,0
#Tee Direita
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,0
#Tee Esquerda
.byte 0,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
#Parede Horizontal
.byte 0,0,0,0,0,0,0
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 0,0,0,0,0,0,0
#Ponta Esq.
.byte 0,0,0,0,0,0,0
.byte 0,0,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,6,6,6,6,6,6
.byte 0,0,6,6,6,6,6
.byte 0,0,0,0,0,0,0
#Ponta Dir.
.byte 0,0,0,0,0,0,0
.byte 6,6,6,6,6,0,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,6,0
.byte 6,6,6,6,6,0,0
.byte 0,0,0,0,0,0,0
#Ponta Sup.
.byte 0,0,0,0,0,0,0
.byte 0,0,6,6,6,0,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
#Ponta Inf.
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,6,6,6,6,6,0
.byte 0,0,6,6,6,0,0
.byte 0,0,0,0,0,0,0
#Cruz
.byte 0,6,6,6,6,6,0
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 6,6,6,6,6,6,6
.byte 0,6,6,6,6,6,0
