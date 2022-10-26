import ball.*
import wollok.game.*

class Alien {
	
	var property position                               // Posocion del Alien
	var property frame = 1								// Cuadro de Animacion inicial del Alien
	var property image = "invaderA" + frame + ".png"	// Imagen Inicial del Alien en base a su cuadro inicial
	var property direction = 1							// Direccion inicial del movimiento del alien
	// Dibujar el Alien
	method draw() {
		game.addVisual(self)
	}
	// Borrar el Alien
	method erase() {
		game.removeVisual(self)
	}
	// Movimiento del Alien segun su direccion
	method moveHorizontal(){
		position = new Position(x = position.x() + direction, y = position.y())
	}
	// Moverse a la izquierda
	method moveLeft(){
		if(position.x() > 0)
		position = new Position(x = position.x() - 1, y = position.y())
	}
	// Moverse a la derecha
	method moveRight(){
		if(position.x() < game.width() - 1 )
		position = new Position(x = position.x() + 1, y = position.y())
	}
	// Moverse hacia abajo
	method moveDown(){
		if(position.y() > 0 )
		position = new Position(x = position.x(), y = position.y() - 1)
	}
	// Cambiae cuadro de animacion
	method changeFrame(){
		if(frame == 1) frame++ else frame--
		image = "invaderA" + frame + ".png"
	}
	// Cambiar de direccion
	method changeDirection(){
		if(direction == 1) direction = -1 else direction = 1
	}	
	// Colision con Bola
	method CanCollideWith(aBall) { return
		aBall.tile().position().x() == position.x() && aBall.tile().position().y() == position.y()
		|| aBall.tile().position().x() == position.x() && aBall.tile().position().y() == position.y() + 1
		|| aBall.tile().position().x() == position.x() + 1 && aBall.tile().position().y() == position.y()
		|| aBall.tile().position().x() == position.x() + 1 && aBall.tile().position().y() == position.y() + 1		
	}
}