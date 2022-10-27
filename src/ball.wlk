import wollok.game.*
// Set de objetos para obtener imagenes
object azul { method image() { return "tile_azul.png" } }
object ball { method image() { return "ball1.png" } }
// Partes del Pad
object pad_left { method image() { return "pad_left.png" } }
object pad_center_left { method image() { return "pad_center_left.png" } }
object pad_center_midle { method image() { return "pad_center_midle.png" } }
object pad_center_right { method image() { return "pad_center_right.png" } }
object pad_right { method image() { return "pad_right.png" } }

// Tile generico base para armar la pelota y el pad
class PieceTile {
	var property color
	var property position
	var property image = color.image()
}
// Vector para poder dar la direccion a la bola al momento de moverse
class Vector2 {
	var property x
	var property y
	//Magnitud del vector respecto de la posicion de mi tile 
	method magnitud(tile) =	return tile.position().distance(new Position(x=x, y=y))	
	//Normalizacion de un vector
	method normalized(tile) = new Vector2(x=x/self.magnitud(tile), y=x/self.magnitud(tile))
	
}

class Ball {
	
	var property tile = new PieceTile(color=ball, position= new Position(x=8, y=5))	// Tile inicial de la bola
	var property velocity = 1														// Velocidad de desplazamiento
	var property direction = new Vector2(x=2, y=1)   								// 45 grados x=1 y=1
	var property relativeX = 0						 								// Origen de la pieza en el mapa X
	var property relativeY = 0					  								    // Origen de la pieza en el mapa Y	
	var property offset = 5															// Offset para chocar con bordes de Arcade
	// Movimiento de la bola
	method movement() {
		tile.position(new Position(x = tile.position().x() + (direction.x() * velocity), 
								   y = tile.position().y() + (direction.y() * velocity)
		))
	}
	// Dibujar la bola
	method drawBall() {
		game.addVisual(tile)
	}
	// Colision con bordes arriba, abajo, derecha e izquierda
	method CollisionWidthAndHeight() {
		if(tile.position().x()  <= 0 + offset  || tile.position().x() + offset >= game.width() - 1 ) direction.x(direction.x() * -1) 
		if(tile.position().y() <= 0  || tile.position().y() >= game.height() - 1 - 1 - offset ) direction.y(direction.y() * -1) 
	}
	// Colision con bola. Hace que la bola cambie direccion en Y cuando choca con el pad o los enemigos
	method collideWith(other) {
		if(other.collideWith(self)) {
			self.invertDirectionY()
		}
	}
	// Invierte la direccion en el eje Y. Se usa al chocar
	method invertDirectionY(){
		direction.y(direction.y() * -1)
	}
	
}