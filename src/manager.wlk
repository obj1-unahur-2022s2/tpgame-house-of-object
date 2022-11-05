import wollok.game.*
import alien.*
import ball.*
import pad.*

object gameManager {	
	// Inicalizo lista de aliens de tipo A.
	const property alienListA = []
	// Inicalizo lista de aliens de tipo B.
	const property alienListB= []
	// Inicalizo lista de aliens de tipo C.
	const property alienListC= []
	// Inicalizo lista de aliens de tipo D.
	const property alienListD= []
	// Distancia de separacion entre aliens.
	var property alienOfset = 3
	// Offset para chocar con los bordes del Arcade.
	var property offset = 5
	
	// Chequeo de colision de los aliens con la ball.
	method collisionAliensWith(aBall, lista) {
		if(!lista.isEmpty()) {
			lista.forEach({ alien => if(alien.CanCollideWith(aBall)) {
												aBall.invertDirectionY()
												alien.erase()
												lista.remove(alien)
						  						}			
						 })
		} 	
	}	
	
	// Lleno lista de aliens.
	method fillAlienList(list, count, yPos, letter){
		(0..count - 1).forEach({
			index => list.add(new Alien(position=new Position(x= offset + index*alienOfset, y=yPos), alienLetter=letter))
		})
	}
	
	// Dibujo lista de aliens.
	method drawAlienList(list) {
		list.forEach({alien => alien.draw()})
	}
	
	// Cambio frame de cada Alien de la lista.
	method changeFrameAlien(list, fameLetter) {
		list.forEach({alien => alien.changeFrame(fameLetter)})
	}
	
	// Mover los aliens hacia abajo.
	method moveDown(list) {
		list.forEach({alien => alien.moveDown()})
	}
	
	// Mover los aliens de forma horizontal segun su dirección.
	method moveHorizontal(list) {
		list.forEach({alien => alien.moveHorizontal()})
	}
	
	// Cambiar la direccion de los aliens.
	method changeDirection(list) {
		list.forEach({alien => alien.changeDirection()})
	}
	
	// Colisiona lista de aliens con bordes.
	method CollisionWidth(list) = !list.isEmpty() && (list.first().position().x() < 1 + offset
						   							 || list.last().position().x() > game.width() - alienOfset - offset)
	
	// Comportamiento de aliens.
	method aliensBehavior(list, fameLetter){
		self.changeFrameAlien(list, fameLetter)  	// Cambio de frame de los aliens.
					self.moveHorizontal(list)		// Muevo los Alien de forma horizontal.
					if(self.CollisionWidth(list)){	// Chequeo colision con bordes.
						self.moveDown(list)			// Muevo los aliens hacia abajo cuando choca.
						self.changeDirection(list)	// Cambio de direccion de los aliens.
					}
	}	
}
