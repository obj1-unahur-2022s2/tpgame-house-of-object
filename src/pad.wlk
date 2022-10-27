import ball.*
import wollok.game.*
object pad {
	// El pad esta formado por una lista de Tiles en linea	
	const property tilesMap = []			      // Mapa de tiles de la pieza
	var property padLength = 5				      // Tamaño de lado del pad
	var property origin = new Vector2(x=5, y=6)   // Posicion de origen del Pad
	var property offset = 5
	// Lista de Sprites
	const property sprites = [pad_left, pad_center_left, pad_center_midle, pad_center_right, pad_right]
	
	
	
	// Llenar el tileMap
	method fillTileMap() {
		(0..padLength - 1).forEach({
			index => tilesMap.add(new PieceTile(color = sprites.get(index), 
												position = new Position(x=origin.x()+index, y=origin.y())
			))
		})
	}
	//
	
	
	// Dibujar el Pad
	method drawPad() {
		tilesMap.forEach({
			tile => game.addVisual(tile)
		})
	}	
	// Mover izquierda el Pad
	method MoveLeft() {
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x() - 1, 
										 y = t.position().y() 
			))
		})
	}
	// Mover derecha el Pad
	method MoveRight() {
		tilesMap.forEach({		
			t => t.position(new Position(x = t.position().x() + 1, 
										 y = t.position().y() 
			))
		})
	}
	// Colisiona con la bola devuelve bool
	method collideWith(ball) = tilesMap.any({
		tile => tile.position().x() == ball.tile().position().x() 
			 && tile.position().y() + 1 == ball.tile().position().y()
	})
	// Colisiona con bordes devuelve bool
	method CollisionWidth() = tilesMap.first().position().x() < 0 + offset - 1
						   || tilesMap.last().position().x() > game.width() - 1 - offset
	
	
	
}
