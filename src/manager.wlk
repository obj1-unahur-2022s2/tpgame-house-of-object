import wollok.game.*
import ball.*
import pad.*
import Alien.*

object gameManager {
		
	// Inicalizo lista de aliens de tipo A
	const property alienListA = []
	// Inicalizo lista de aliens de tipo B
	const property alienListB=[]
	// Inicalizo lista de aliens de tipo C
	const property alienListC=[]
	// Inicalizo lista de aliens de tipo D
	const property alienListD=[]
	
	// Distancia de separacion entre aliens
	var property alienOfset = 3
	// Offset para chocar con los bordes del Arcade
	var property offset = 5
	
	var ball1 = new Ball() 								  // Creo la bola
	var inicio = false								      // Atributo para inicion de juego
	var alienMovementTime = 800							  // Tiempo del OnTick de las lista de Aliens
	var ballMovementTime = 150							  // Tiempo de OnTick de la bola
	
	//Chequeo de colision de los Aliens con la bola
	method collisionAliensWith(aBall, lista){
		if(!lista.isEmpty()){
			lista.forEach({ alien => if(alien.CanCollideWith(aBall)){
												aBall.invertDirectionY()
												alien.erase()
												lista.remove(alien)}			
							  })
		} 
		
	}	
	// Lleno lista de Aliens 
	method fillAlienList(list, count, yPos, letter){
		(0..count - 1).forEach({
			index => list.add(new Alien(position=new Position(x= offset + index*alienOfset, y=yPos), alienLetter=letter))
		})
	}
	// Dibujo lista de Aliens
	method drawAlienList(list){
		list.forEach({
			alien => alien.draw()
		})
	}
	// Cambio Frame de cada Alien de la lista
	method changeFrameAlien(list, fameLetter){
		list.forEach({
			alien => alien.changeFrame(fameLetter)
		})
	}
	// Mover los aliens hacia abajo
	method moveDown(list){
		list.forEach({
			alien => alien.moveDown()
		})
	}
	// Mover los Alien de forma horizontal segun su direccion
	method moveHorizontal(list){
		list.forEach({
			alien => alien.moveHorizontal()
		})
	}
	// Cambiar la direccion de los Aliens
	method changeDirection(list) {
		list.forEach({
			alien => alien.changeDirection()
		})
	}
	
	// Colisiona lista de aliens con bordes
	method CollisionWidth(list) = !list.isEmpty() && (list.first().position().x() < 1 + offset
						   							 || list.last().position().x() > game.width() - alienOfset - offset)
	
	
	// Comportamiento de aliens
	method aliensBehavior(list, fameLetter){
		self.changeFrameAlien(list, fameLetter)  	// Cambio de frame de los Aliens
					self.moveHorizontal(list)		// Muevo los Alien de forma horizontal
					if(self.CollisionWidth(list)){	// Chequeo colision con bordes
						self.moveDown(list)			// Muevo los aliens hacia abajo cuando choca
						self.changeDirection(list)	// Cambio de direccion de los Aliens
					}
	}
	
	// Condicion de victoria
	method isWinner() = alienListA.isEmpty() && alienListB.isEmpty() && alienListC.isEmpty()
	// Chequeo si gano
	method checkWinTheGame() {
		if(self.isWinner()){
			//game.clear()
			pad.erasePad()
			// Setear inicio en false
			inicio = false
			// agrego para el final el cartel de you Win
			game.addVisual(youWin)						  // Texto de insert coin		
			youWin.animation()							  // Animacion de insert coin
		}
	}
	// Metodo donde ocurre la magia
	method play() {
			//Pantalla de Inicio y  Seteo inicial de atributos del tablero del juego
			game.title("BreackOut")
			game.width(30)          							  // Ancho de la pantalla
			game.height(40)										  // Alto de la pantalla
			game.cellSize(25)									  // Tamaño de mi unidad de sprite
			game.boardGround("space_invader_arcade2.png")		  // Fondo del juego
			game.addVisual(controlText)							  // Texto de explicacion de controles
			game.addVisual(insertCointText)						  // Texto de insert coin		
			insertCointText.animation()							  // Animacion de insert coin
			keyboard.num1().onPressDo({							  // Al presionar 1 comienza el juego
				
				if(!inicio){
					inicio = true								        			 // Inicio de juego
					ball1.drawBall()                        	       			     // Dibujo la bola
			   		pad.fillTileMap()							        			 // llenar y dibujar el pad ES UN OBJETO
					pad.drawPad()								         			 // Dibujo el pad	
					game.removeVisual(controlText)									 // Remover texto
					game.removeVisual(insertCointText)								 // Remover texto
					self.fillAlienList(self.alienListA(),5, 31, "A")                 // Lleno la lista de aliens con cantidad y en una posicion en Y
					self.drawAlienList(self.alienListA())				             // y la letra del Sprite, en este caso A
					self.fillAlienList(self.alienListB(),5, 27, "B")                 // Lleno la lista de aliens con cantidad y en una posicion en Y
					self.drawAlienList(self.alienListB())			                 // y la letra del Sprite, en este caso B
					self.fillAlienList(self.alienListC(),5, 23, "C")                 // Lleno la lista de aliens con cantidad y en una posicion en Y
					self.drawAlienList(self.alienListC())	 			             // y la letra del Sprite, en este caso C
								
				} 	
			
			})
			// Movimiento de los aliens
			game.onTick(alienMovementTime, "alien update", {
				if(inicio){	self.aliensBehavior(self.alienListA(),"A") }}) //movimiento en un cierto tiempo lista e indice de Alien A
				
			game.onTick(alienMovementTime, "alien update", {
				if(inicio){	self.aliensBehavior(self.alienListB(),"B") }}) //movimiento en un cierto tiempo lista e indice de Alien B
				
			game.onTick(alienMovementTime, "alien update", {
				if(inicio){	self.aliensBehavior(self.alienListC(),"C") }}) //movimiento en un cierto tiempo lista e indice de Alien C
			
			
			// Manejo de teclas de juego
			keyboard.left().onPressDo({pad.MoveLeft() if(pad.CollisionWidth()) pad.MoveRight()})	
			keyboard.right().onPressDo({pad.MoveRight() if(pad.CollisionWidth()) pad.MoveLeft()})			
			// Game Update	Muevo bola en un lapso de tiempo
			game.onTick(ballMovementTime, "game update", {
				if(inicio){
					ball1.movement() 													// Muevo bola
					ball1.CollisionWidthAndHeight() 									// Chequeo colision con bordes 
					ball1.collideWith(pad)												// Chequeo colision con pad
					self.collisionAliensWith(ball1, self.alienListA())                  // Chequeo colision de aliens A con Bola
					self.collisionAliensWith(ball1, self.alienListB())	                // Chequeo colision de aliens B con Bola
					self.collisionAliensWith(ball1, self.alienListC())	                // Chequeo colision de aliens C con Bola
					self.checkWinTheGame()
					}					
				
		})		
			// Inicio del programa	
			game.start()
	}
	
	
}
