import wollok.game.*
import ball.*
import pad.*
import Alien.*

object gameManager {	
	// Inicalizo lista de aliens
	const property alienListA = []
	// Distancia de separacion entre aien
	var property alienOfset = 3
	//Chequeo de colision de los Aliens con la bola
	method collisionAliensWith(aBall){
		if(!alienListA.isEmpty()){
			alienListA.forEach({ alien => if(alien.CanCollideWith(aBall)){
												aBall.invertDirectionY()
												alien.erase()
												alienListA.remove(alien)}			
							  })
		} 
		
	}	
	// Lleno lista de Aliens
	method fillAlienListA(count){
		(0..count - 1).forEach({
			index => alienListA.add(new Alien(position=new Position(x=index*alienOfset, y=20)))
		})
	}
	// Dibujo lista de Aliens
	method drawAlienListA(){
		alienListA.forEach({
			alien => alien.draw()
		})
	}
	// Cambio Frame de cada Alien de la lista
	method changeFrameAlien(){
		alienListA.forEach({
			alien => alien.changeFrame()
		})
	}
	// Mover los Aliens a la izquierda
	method moveLeft(){
		alienListA.forEach({
			alien => alien.moveLeft()
		})
	}
	// Mover los Aliens a la derecha 
	method moveRight(){
		alienListA.forEach({
			alien => alien.moveRight()
		})
	}
	// Mover los aliens hacia abajo
	method moveDown(){
		alienListA.forEach({
			alien => alien.moveDown()
		})
	}
	// Mover los Alien de forma horizontal segun su direccion
	method moveHorizontal(){
		alienListA.forEach({
			alien => alien.moveHorizontal()
		})
	}
	// Cambiar la direccion de los Aliens
	method changeDirection() {
		alienListA.forEach({
			alien => alien.changeDirection()
		})
	}
	
	// Colisiona lista de aliens con bordes
	method CollisionWidth() = !alienListA.isEmpty() && (alienListA.first().position().x() < 1 
						   							 || alienListA.last().position().x() > game.width() - alienOfset)
	
	
	
	
	
}
