import wollok.game.*
import ball.*
import pad.*
import alien.*

object gameManager {
		
	// Inicalizo lista de aliens de tipo A.
	const property alienListA = []
	// Inicalizo lista de aliens de tipo B.
	const property alienListB= []
	// Inicalizo lista de aliens de tipo C.
	const property alienListC= []
	
	// Distancia de separacion entre aliens.
	var property alienOfset = 3
	// Offset para chocar con los bordes del Arcade.
	var property offset = 5
	
	const ball1 = new Ball() 							  				// Creo la ball.
	var inicio = false								      				// Atributo para inicio de juego.
	const alienMovementTime = 800						  				// Tiempo del OnTick de las listas de aliens.
	const ballMovementTime = 150						  				// Tiempo de OnTick de la ball.
	var property soundFondo = new Sound(file = "sonidoFondo.mp3")		// Sonido de fondo del juego.
	var property soundVictoria = new Sound(file = "sonidoVictoria.mp3")	// Sonido de victoria.
	var property soundDerrota = new Sound(file = "sonidoDerrota.mp3")	// Sonido de derrota.
	
	// Chequeo de colision de los aliens con la ball.
	method collisionAliensWith(aBall, lista) {
		if(!lista.isEmpty()) {
			lista.forEach({ alien => if(alien.CanCollideWith(aBall)){
												aBall.invertDirectionY()
												alien.erase()
												lista.remove(alien)}			
						 })
		} 	
	}	
	// Lleno lista de aliens.
	method fillAlienList(list, count, yPos, letter) {
		(0..count - 1).forEach({
			index => list.add(new Alien(position=new Position(x= offset + index*alienOfset, y=yPos), alienLetter=letter))
		})
	}
	// Dibujo lista de aliens.
	method drawAlienList(list) {
		list.forEach({
			alien => alien.draw()
		})
	}
	// Cambio frame de cada alien de la lista.
	method changeFrameAlien(list, fameLetter) {
		list.forEach({
			alien => alien.changeFrame(fameLetter)
		})
	}
	// Mover los aliens hacia abajo.
	method moveDown(list) {
		list.forEach({
			alien => alien.moveDown()
		})
	}
	// Mover los aliens de forma horizontal segun su dirección.
	method moveHorizontal(list) {
		list.forEach({
			alien => alien.moveHorizontal()
		})
	}
	// Cambiar la direccion de los aliens.
	method changeDirection(list) {
		list.forEach({
			alien => alien.changeDirection()
		})
	}
	
	// Colisiona lista de aliens con bordes.
	method CollisionWidth(list) = !list.isEmpty() && (list.first().position().x() < 1 + offset
						   							 || list.last().position().x() > game.width() - alienOfset - offset)
	
	// Comportamiento de aliens.
	method aliensBehavior(list, fameLetter) {
		self.changeFrameAlien(list, fameLetter)  	// Cambio de frame de los aliens.
		self.moveHorizontal(list)					// Muevo los aliens de forma horizontal.
		if(self.CollisionWidth(list)) {				// Chequeo colision con bordes.
			self.moveDown(list)						// Muevo los aliens hacia abajo cuando choca.
			self.changeDirection(list)				// Cambio de dirección de los aliens.
		}
	}
	
	// Reproducir audio general en loop.
	method playSoundFondoEnLoop() {		
    	soundFondo.shouldLoop(true)                      	// El tema se repite en loop.
    	soundFondo.play()									// Reproducción de sonido.
	}

	// Condicion de victoria.
	method isWinner() = alienListA.isEmpty() && alienListB.isEmpty() && alienListC.isEmpty()
	
	// Chequeo si gano.
	method checkWinTheGame() {
		if(self.isWinner()) {
			// Elimina el pad del juego.
			pad.erasePad()
			// Inicio pasa a falso.
			inicio = false
			// Agrego cartel de ganador.
			game.addVisual(youWin)			// Cartel de winner.	
			youWin.animation()				// Animación de cartel de winner.	
			soundFondo.stop()				// Freno de música de fondo.
			soundVictoria.play()		  	// Reproducción de sonido de victoria.
		}
	}
	
	// Condicion de derrota.
	// Ball no tiene direction, tiene tile, y ese tile tiene direction.
	method isLoser() = self.hayAlgunAlienALaAlturaDelPad() || ball1.tile().position().y() < pad.origin().y()
	
	// Comprueba si al menos un alien está a la altura del pad.
	method hayAlgunAlienALaAlturaDelPad() =
		alienListA.any({ a => a.position().y() <= pad.origin().y() }) or
		alienListB.any({ a => a.position().y() <= pad.origin().y() }) or
		alienListC.any({ a => a.position().y() <= pad.origin().y() })
	
	// Chequeo si pierdo. 
	method checkLostTheGame() {
		if(self.isLoser()) {
			// Elimina el pad del juego.
			pad.erasePad()
			// Inicio pasa a falso.
			inicio = false
			// Agrego cartel de perdedor.
			game.addVisual(youLost)			// Cartel de perdedor. Cambiar por game.addVisual(youLost).
			soundFondo.stop()				// Freno de música de fondo.
			soundDerrota.play()				// Reproducción de sonido de derrota.
		}
	}
	
	// Condiciones básicas e inicio de juego.
	method play() {
			// Pantalla de inicio y  seteo inicial de atributos del tablero del juego.
			game.title("Arkanoid Invaders")							// Nombre del juego.
			game.width(30)          							  	// Ancho de la pantalla.
			game.height(40)										  	// Alto de la pantalla.
			game.cellSize(25)									  	// Tamaño de mi unidad de sprite.
			game.boardGround("space_invader_arcade2.png")		  	// Fondo del juego.
			game.addVisual(controlText)							  	// Texto de explicacion de controles.
			game.addVisual(insertCointText)						  	// Texto de insert coin.		
			insertCointText.animation()							  	// Animacion de insert coin.
			keyboard.num1().onPressDo({							  	// Al presionar 1 comienza el juego.
				
				if(!inicio) {
					inicio = true								        			 // Inicio de juego.
					self.playSoundFondoEnLoop()										 // Sonido de fondo del juego.
					ball1.drawBall()                        	       			     // Dibujo la ball.
			   		pad.fillTileMap()							        			 // Llenar el pad.
					pad.drawPad()								         			 // Dibujo el pad.	
					game.removeVisual(controlText)									 // Remover texto.
					game.removeVisual(insertCointText)								 // Remover texto.							 
					self.fillAlienList(self.alienListA(),5, 31, "A")                 // Lleno la lista de aliens con cantidad y en una posicion en Y
					self.drawAlienList(self.alienListA())				             // y la letra del Sprite, en este caso A.
					self.fillAlienList(self.alienListB(),5, 27, "B")                 // Lleno la lista de aliens con cantidad y en una posicion en Y
					self.drawAlienList(self.alienListB())			                 // y la letra del Sprite, en este caso B.
					self.fillAlienList(self.alienListC(),5, 23, "C")                 // Lleno la lista de aliens con cantidad y en una posicion en Y
					self.drawAlienList(self.alienListC())	 			             // y la letra del Sprite, en este caso C.
				} 	
			})
			
			// Movimiento de los aliens
			game.onTick(alienMovementTime, "alien update", {
				if(inicio){	self.aliensBehavior(self.alienListA(),"A") }}) // Movimiento en un cierto tiempo lista e indice de Alien A
				
			game.onTick(alienMovementTime, "alien update", {
				if(inicio){	self.aliensBehavior(self.alienListB(),"B") }}) // Movimiento en un cierto tiempo lista e indice de Alien B
				
			game.onTick(alienMovementTime, "alien update", {
				if(inicio){	self.aliensBehavior(self.alienListC(),"C") }}) // Movimiento en un cierto tiempo lista e indice de Alien C
			
			
			// Manejo de teclas de juego.
			keyboard.left().onPressDo({pad.MoveLeft() if(pad.CollisionWidth()) pad.MoveRight()})	
			keyboard.right().onPressDo({pad.MoveRight() if(pad.CollisionWidth()) pad.MoveLeft()})			
			
			// Game Update	Muevo bola en un lapso de tiempo.
			game.onTick(ballMovementTime, "game update", {
				if(inicio) {
					ball1.movement() 											// Muevo ball.
					ball1.CollisionWidthAndHeight() 							// Chequeo colision con bordes. 
					ball1.collideWith(pad)										// Chequeo colision con pad.
					self.collisionAliensWith(ball1, self.alienListA())          // Chequeo colision de aliens A con ball.
					self.collisionAliensWith(ball1, self.alienListB())	        // Chequeo colision de aliens B con ball.
					self.collisionAliensWith(ball1, self.alienListC())	        // Chequeo colision de aliens C con ball.
					self.checkWinTheGame()										// Chequea si se ganó el juego.
					self.checkLostTheGame()										// Chequea si se perdió el juego.
					}					
	})		
	
	// Inicio del programa.
	game.start()
	}
}
