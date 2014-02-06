package candyking.game.powerups {
	
	import candyking.game.weapons.Grenade;
	
	public class GrenadePowerup extends Powerup {
		
		public function GrenadePowerup() {
			super("entities/powerup_grenade.xml");
		}
		
		protected override function onPickedUp():void {
			_gameWorld.player.primaryWeaponType = Grenade;
		}
		
	}

}
