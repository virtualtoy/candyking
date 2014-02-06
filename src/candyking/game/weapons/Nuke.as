package candyking.game.weapons {
	
	import net.flashpunk.FP;
	
	public class Nuke extends Weapon {
		
		public function Nuke() {
			
		}
		
		override public function update():void {
			if (_coolDownCount <= 0) {
				if (_controller.beganSecondary &&
					_gameWorld.specialWeaponAmount > 0) {
					
					_gameWorld.useSpecialWeapon();
					_coolDownCount = 120;
				}
			}else if (_coolDownCount % 4 == 0) {
				var x:Number = Math.random() * FP.width;
				var y:Number = Math.random() * FP.height;
				_gameWorld.addExplosion(x, y);
			}
			_coolDownCount--;
		}
		
	}

}
