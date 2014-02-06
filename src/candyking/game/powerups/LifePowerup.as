package candyking.game.powerups {
	
	import candyking.game.weapons.Grenade;
	
	public class LifePowerup extends Powerup {
		
		public function LifePowerup() {
			super("entities/powerup_life.xml");
		}
		
		protected override function onPickedUp():void {
			_gameWorld.lives++;
		}
		
	}

}
