import wollok.game.*
// Set de objetos para obtener imagenes
object verde { method image() { return "tile_verde.png" } }
object rojo { method image() { return "tile_rojo.png" } }
object violeta { method image() { return "tile_violeta.png" } }
object naranja { method image() { return "tile_naranja.png" } }
object azul { method image() { return "tile_azul.png" } }
object amarillo { method image() { return "tile_amarillo.png" } }
object celeste { method image() { return "tile_celeste.png" } }
object blanco { method image() { return "tile_gris_base.png" } }
object ball { method image() { return "ball1.png" } }

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
	
	var property tile = new PieceTile(color=ball, position= new Position(x=8, y=4))	// Tile inicial de la bola
	var property velocity = 1														// Velocidad de desplazamiento
	var property direction = new Vector2(x=2, y=1)   								// 45 grados x=1 y=1
	var property relativeX = 0						 								// Origen de la pieza en el mapa X
	var property relativeY = 0					  								    // Origen de la pieza en el mapa Y	
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
		if(tile.position().x() <= 0 || tile.position().x() >= game.width() - 1) direction.x(direction.x() * -1) 
		if(tile.position().y() <= 0 || tile.position().y() >= game.height() - 1) direction.y(direction.y() * -1) 
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