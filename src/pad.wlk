import wollok.game.*
import ball.*

object pad {
	// El pad --> lista de tiles en linea.	
	const property tilesMap = []			      // Mapa de tiles de la pieza.
	var property padLength = 5				      // Tamaño de lado del pad.
	var property origin = new Vector2(x=5, y=6)   // Posición de origen del pad.
	var property offset = 5
	// Lista de sprites.
	const property sprites = [pad_left, pad_center_left, pad_center_midle, pad_center_right, pad_right]
	
	// Llenar el tileMap.
	method fillTileMap() {
		(0..padLength - 1).forEach({
			index => tilesMap.add(new PieceTile(color = sprites.get(index), 
												position = new Position(x=origin.x()+index, y=origin.y())
			))
		})
	}
	//
		
	// Dibujar el pad.
	method drawPad() {
		tilesMap.forEach({
			tile => game.addVisual(tile)
		})
	}	
	// Mover izquierda el pad.
	method moveLeft() {
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x() - 1, 
										 y = t.position().y() 
			))
		})
	}
	
	// Mover derecha el pad.
	method moveRight() {
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x() + 1, 
										 y = t.position().y() 
			))
		})
	}
	
	// Colisiona con la ball devuelve bool.
	method collideWith(ball) = tilesMap.any({
		tile => tile.position().x() == ball.tile().position().x() 
			 && tile.position().y() + 1 == ball.tile().position().y()
	})
	
	// Colisiona con bordes devuelve bool.
	method collisionWidth() = tilesMap.first().position().x() < 0 + offset - 1
						   || tilesMap.last().position().x() > game.width() - 1 - offset
	
	
	
}
