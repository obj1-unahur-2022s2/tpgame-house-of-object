import manager.*   
import wollok.game.*

object enemyCounter {
	var property index = 0
	var property position = new Position(x = 10, y = 33)
	var property image = "enemy_count.png"
}

object lineUnit {
	var property index = 0
	var property position = new Position(x = 18, y = 33)
	var property image = "num_" + index + ".png"
	
	method changeImage(){
		index =  gameManager.aliensCounter() % 10 	// Controlo que sea de 0 a 9
		image = "num_" + index + ".png"		// Seteo nueva imagen
	}
	
	method checkChangeLine(){game.onTick(40,"check de linea",{self.changeImage()})}
}

object lineDozens {
	var property index = 0
	var property position = new Position(x = 17, y = 33)
	var property image = "num_" + index + ".png"
	
	method changeImage(){// Solo entran imagen 1 o 0 por la cantidad de 15 aliens
		if( gameManager.aliensCounter() > 9){
			index =  1
			image = "num_" + index + ".png" 							// Seteo nueva imagen
		}
		else{
			index =  0
			image = "num_" + index + ".png" 							// Seteo nueva imagen
		}		
	}
	
	method checkChangeLine(){game.onTick(40,"check de linea",{self.changeImage()})}
}