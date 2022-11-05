import wollok.game.*

// Set de objetos para obtener imagenes.
object azul { method image() { return "tile_azul.png" } }
object ball { method image() { return "ball1.png" } }

// Partes del pad (5).
object pad_left { method image() { return "pad_left.png" } }
object pad_center_left { method image() { return "pad_center_left.png" } }
object pad_center_midle { method image() { return "pad_center_midle.png" } }
object pad_center_right { method image() { return "pad_center_right.png" } }
object pad_right { method image() { return "pad_right.png" } }

// Texto de controles.
object controlText { 
	var property position = new Position(x = 9, y = 30)
	var property image = "controls_text.png"
}

object insertCointText {
	var property position = new Position(x = 9, y = 20 )
	var property image = "text_insert_coin.png"
	
	method changeFrame() {
		if(image == "text_insert_coin.png"){ image = "text_insert_coin_black.png" }
		else { image = "text_insert_coin.png" }
	}
	
	method animation() {
		game.onTick(800, "animacion de cartel", { self.changeFrame()})
	}
}

// Tile genérico base para armar la ball y el pad.
class PieceTile {
	var property color
	var property position
	var property image = color.image()
}

// Vector para poder dar la direccion a la ball al momento de moverse.
class Vector2 {
	var property x
	var property y
	
	// Magnitud del vector respecto de la posicion de mi tile. 
	method magnitud(tile) =	return tile.position().distance(new Position(x=x, y=y))	
	
	// Normalizacion de un vector.
	method normalized(tile) = new Vector2(x=x/self.magnitud(tile), y=x/self.magnitud(tile))
}

// Class Ball. 
class Ball {
	var property tile = new PieceTile(color = ball, position = new Position(x = 8, y = 5))	// Tile inicial de la ball.
	var property velocity = 1																// Velocidad de desplazamiento.
	var property direction = new Vector2(x=2, y=1)   										// 45 grados x = 1 y = 1
	var property relativeX = 0						 							// Origen de la pieza en el mapa X.
	var property relativeY = 0					  								// Origen de la pieza en el mapa Y.	
	var property offset = 5														// Offset para chocar con bordes de Arcade.
	
	// Movimiento de la ball.
	method movement() {
		tile.position(new Position(x = tile.position().x() + (direction.x() * velocity), 
								   y = tile.position().y() + (direction.y() * velocity)
		))
	}
	
	// Dibujar la ball.
	method drawBall() {game.addVisual(tile)}
	
	// Colision con bordes arriba, abajo, derecha e izquierda.
	method CollisionWidthAndHeight() {
		if(tile.position().x()  <= 0 + offset  || tile.position().x() + offset >= game.width() - 1 ) direction.x(direction.x() * -1) 
		if(tile.position().y() <= 0  || tile.position().y() >= game.height() - 1 - 1 - offset ) direction.y(direction.y() * -1) 
	}
	
	// Colision con ball. Hace que la ball cambie direccion en Y cuando choca con el pad o los enemigos.
	method collideWith(other) {
		if(other.collideWith(self)) {self.invertDirectionY()}
	}
	
	// Invierte la direccion en el eje Y. Se usa al chocar.
	method invertDirectionY(){direction.y(direction.y() * -1)}
}