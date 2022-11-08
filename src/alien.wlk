import wollok.game.*
import ball.*
// import manager.*    	// Para audios.


class Alien {
	var property position                          			        // Posición del alien. 
	var property alienLetter						        		// Letra de imagen del alien (A, B o C).
	var property frame = 1								            // Cuadro de animacion inicial del alien.
	var property image = "invader" + alienLetter + frame + ".png"	// Imagen inicial del alien en base a su cuadro inicial.
	var property direction = 1										// Direccion inicial del movimiento del alien.
	var property soundMuerteDeAlien = new Sound(file = "sonidoMuerteAlien.mp3")		// Sonido de muerte de alien.
	var playSound = false
	
	// Dibujar el alien.
	method draw() {
		game.addVisual(self)
	}
	
	// Borrar el alien.
	method erase() {
		game.removeVisual(self)
		if(playSound){
			soundMuerteDeAlien.stop()
			playSound = false
		}
		soundMuerteDeAlien.play()
		playSound = true
	}
	
	// Movimiento del alien según su dirección.
	method moveHorizontal() {
		position = new Position(x = position.x() + direction, y = position.y())
	}
	
	// Moverse hacia abajo.
	method moveDown() {
		if(position.y() > 0 )
		position = new Position(x = position.x(), y = position.y() - 1)
	}
	
	// Cambiar cuadro de animación.
	method changeFrame(fameLetter) {
		if(frame == 1) frame++ else frame--
		image = "invader" + fameLetter + frame + ".png"
	}
	
	// Cambiar de dirección.
	method changeDirection() {
		if(direction == 1) direction = -1 else direction = 1
	}	
	
	// Colisión con ball.
	method CanCollideWith(aBall) { return
		aBall.tile().position().x() == position.x() && aBall.tile().position().y() == position.y()
		|| aBall.tile().position().x() == position.x() && aBall.tile().position().y() == position.y() + 1
		|| aBall.tile().position().x() == position.x() + 1 && aBall.tile().position().y() == position.y()
		|| aBall.tile().position().x() == position.x() + 1 && aBall.tile().position().y() == position.y() + 1		
	}
}