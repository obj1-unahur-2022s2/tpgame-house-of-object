import wollok.game.*
import alien.*
import alienCounter.*
import ball.*
import pad.*

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
	
	const ball1 = new Ball() 						// Creo la ball.
	var property inicio = false						// Atributo para inicio de juego.
	var property replay = false	
	var property lost = false
	var property win = false	
	var property changeText = true						
	var property alienMovementTime = 800			// Tiempo del OnTick de las listas de aliens.
	var property ballMovementTime = 150				// Tiempo de OnTick de la ball.
	var property soundFondo 						// Sonido de fondo del juego.
	var property sounFondoIsPlay = false
	var property soundVictoria 						// Sonido de victoria.
	var property soundVictoriaIsPLay = false
	var property soundDerrota						// Sonido de derrota.
	var property soundDerrotaIsPlay = false
	var property aliensCounter = 0 					// Contador de aliens.
	
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
	
	// Borro la lista de aliens
	method eraseAlienList(list) {
		list.forEach({
			alien => alien.erase()			
		})
		list.clear()
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
		soundFondo = new Sound(file = "sonidoFondo.mp3")	
    	soundFondo.shouldLoop(true)                      	// El tema se repite en loop.
    	soundFondo.play()									// Reproducción de sonido.
    	sounFondoIsPlay = true
	}
	
	// Detener audio general.
	method stopSoundFondo() {
		soundFondo.shouldLoop(false)                      	
    	soundFondo.stop()									
    	sounFondoIsPlay = false
	}
	
	// Sonido win.
	method playWinSound() {
		if(soundVictoriaIsPLay) {
			soundVictoria.stop()
			soundVictoriaIsPLay = false
		}
		soundVictoria = new Sound(file = "sonidoVictoria.mp3")
		soundVictoria.play()				// Reproduccion de sonido de victoria. 			
		soundVictoriaIsPLay = true			// Control de reproduccion de sonido de victoria en true.			
	}
	
	// Sonido lost.
	method playLostSound() {
		if(soundDerrotaIsPlay) {
			soundDerrota.stop()
			soundDerrotaIsPlay = false
		}
		soundDerrota  = new Sound(file = "sonidoDerrota.mp3")
		soundDerrota.play()					// Reproduccion de sonido de derrota. 			
		soundDerrotaIsPlay = true			// Control de reproduccion de sonido de derrota en true.			
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
			replay = true
			win = true
			lost = false
			// Remuevo visual de la ball.
			game.removeVisual(ball1.tile())
			// Agrego cartel de ganador.
			game.addVisual(youWin)			// Cartel de winner.	
			youWin.animation()				// Animación de cartel de winner.
			game.addVisual(playAgain)
			playAgain.animation()		  	
			self.stopSoundFondo()			// Freno de música de fondo.
			self.stopUpdate()
			self.playWinSound()             // Reproducción de sonido de victoria. 
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
			// Borro las lista de Aliens
			self.eraseAlienList( self.alienListA())
			self.eraseAlienList( self.alienListB())
			self.eraseAlienList( self.alienListC())
			// remuevo visual de la bola
			game.removeVisual(ball1.tile())
			
			inicio = false                   // Inicio pasa a falso.
			replay = true
			lost = true
			win  = false
			// Agrego cartel de perdedor.
			game.addVisual(youLost)			// Cartel de perdedor.
			game.addVisual(playAgain)
			playAgain.animation()
			self.stopSoundFondo()			// Freno de música de fondo.
			self.playLostSound()			
			self.stopUpdate()			
		}
	}
	
	// Suma de size de listas.
	method counterSize() = self.alienListA().size() + self.alienListB().size() + self.alienListC().size()
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	method checkVisualselementsToRemove() {
		if(game.hasVisual(controlText)){game.removeVisual(controlText)}
		if(game.hasVisual(insertCointText)){game.removeVisual(insertCointText)}
		if(game.hasVisual(youLost)){game.removeVisual(youLost)}
		if(game.hasVisual(youWin)){game.removeVisual(youWin)}
		if(game.hasVisual(enemyCounter)){game.removeVisual(enemyCounter)}
		if(game.hasVisual(lineUnit)){game.removeVisual(lineUnit)}
		if(game.hasVisual(lineDozens)){game.removeVisual(lineDozens)}
		if(game.hasVisual(playAgain)){game.removeVisual(playAgain)}	
		if(game.hasVisual(controlText2)){game.removeVisual(controlText2)}	
		if(replay && lost){
			game.removeTickEvent("animacion de cartel play again")
			lost = false
		}
		if(replay && win){
			game.removeTickEvent("animacion de cartel win")
			game.removeTickEvent("animacion de cartel play again")
			lost = false
		}  			
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////playAgain
	
	// Condiciones básicas e inicio de juego.
	method play() {
		// Pantalla de inicio y  seteo inicial de atributos del tablero del juego.
		game.title("Arkanoid Invaders") 					  // Nombre del juego.
		game.width(30) 										  // Ancho de la pantalla.
		game.height(40) 									  // Alto de la pantalla.
		game.cellSize(25) 									  // Tamaño de mi unidad de sprite.
		game.boardGround("space_invader_arcade2.png")		  // Fondo del juego.			
		game.addVisual(controlText) 						  // Texto de explicacion de controles.
		game.addVisual(insertCointText) 					  // Texto de insert coin.
		pad.fillTileMap() 									  // Llenar el pad.		
		insertCointText.animation() 						  // Animacion de insert coin.
		keyboard.e().onPressDo({game.stop()})				  // Salir.
		keyboard.num2().onPressDo({ballMovementTime = 70 alienMovementTime = 500 self.controlTextChange()})	      // Dificulta
		keyboard.num3().onPressDo({ballMovementTime = 150 alienMovementTime = 800 self.controlTextChange()})	  // Dificulta
		keyboard.num1().onPressDo({ // Al presionar 1 comienza el juego. 
			if (!inicio ) {
				inicio = true // Inicio de juego.
				self.checkVisualselementsToRemove()
				self.playSoundFondoEnLoop() 									// Sonido de fondo del juego.
				if(ball1.tile() != null) ball1.drawBall() 						// Dibujo la ball.
				ball1.restarPosition()			   		
				if(pad.tilesMap() != null)pad.drawPad() 						// Dibujo el pad.					
				game.addVisual(enemyCounter)
				game.addVisual(lineUnit) 										// Contador de unidad de aliens.
				lineUnit.checkChangeLine() 										// Chequeo de contador de unidad de aliens.							
				game.addVisual(lineDozens)									    // Contador de decena de aliens.
				lineDozens.checkChangeLine() 									// Chequeo de contador de decena de aliens.							 
				self.fillAndDrawAllAliensLists()
				// Movimiento de los aliens.
				game.onTick(alienMovementTime, "alien updateA", {if (inicio){self.aliensBehavior(self.alienListA(), "A")}}) // Movimiento en un cierto tiempo lista e indice de Alien A
				game.onTick(alienMovementTime, "alien updateB", {if (inicio){self.aliensBehavior(self.alienListB(), "B")}}) // Movimiento en un cierto tiempo lista e indice de Alien B
				game.onTick(alienMovementTime, "alien updateC", {if (inicio){self.aliensBehavior(self.alienListC(), "C")}}) // Movimiento en un cierto tiempo lista e indice de Alien C
				
				self.update()									  // Update	
			}
		})
		self.keyBoardArrowControl()                       // Manejo de teclas de pad juego.	
		game.start()									  // Inicio del programa.	
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	method controlTextChange() {
		if(changeText){
			game.removeVisual(controlText)
			game.addVisual(controlText2)
			changeText = false
		}
		
	}	
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	method update() {
		// Game Update. Muevo ball en un lapso de tiempo.
		game.onTick(ballMovementTime, "game update", { if (inicio) {
				ball1.movement()								    // Muevo ball.
				ball1.CollisionWidthAndHeight() 					// Chequeo colision con bordes. 
				ball1.collideWith(pad) 								// Chequeo colision con pad.
				self.collisionAliensWith(ball1, self.alienListA())  // Chequeo colision de aliens A con ball.
				self.collisionAliensWith(ball1, self.alienListB())  // Chequeo colision de aliens B con ball.
				self.collisionAliensWith(ball1, self.alienListC())  // Chequeo colision de aliens C con ball.
				self.checkWinTheGame() 								// Chequea si se ganó el juego.
				self.checkLostTheGame() 							// Chequea si se perdió el juego.
			}
		})
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	method stopUpdate() {
		game.removeTickEvent("game update")
		game.removeTickEvent("alien updateA")
		game.removeTickEvent("alien updateB")
		game.removeTickEvent("alien updateC")		
		
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	method keyBoardArrowControl() {
		keyboard.left().onPressDo({ if(pad.isVisible()) pad.MoveLeft()if (pad.CollisionWidth()) pad.MoveRight()	})
		keyboard.right().onPressDo({ if(pad.isVisible()) pad.MoveRight()if (pad.CollisionWidth()) pad.MoveLeft()})
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////
	
	method fillAndDrawAllAliensLists() {
		self.fillAlienList(self.alienListA(), 5, 31, "A") 		// Lleno la lista de aliens con cantidad y en una posicion en Y
		self.drawAlienList(self.alienListA()) 					// y la letra del Sprite, en este caso A.
		self.fillAlienList(self.alienListB(), 5, 27, "B") 		// Lleno la lista de aliens con cantidad y en una posicion en Y
		self.drawAlienList(self.alienListB()) 					// y la letra del Sprite, en este caso B.
		self.fillAlienList(self.alienListC(), 5, 23, "C") 		// Lleno la lista de aliens con cantidad y en una posicion en Y
		self.drawAlienList(self.alienListC()) 					// y la letra del Sprite, en este caso C.
		self.aliensCounter(self.counterSize()) 					// Seteo la cantidad de aliens.
	}
}
