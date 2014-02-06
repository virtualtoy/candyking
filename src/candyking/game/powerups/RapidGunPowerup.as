package candyking.game.powerups {
	
	import candyking.game.weapons.RapidGun;
	
	public class RapidGunPowerup extends Powerup {
		
		public function RapidGunPowerup() {
			super("entities/powerup_rapid_gun.xml");
		}
		
		protected override function onPickedUp():void {
			_gameWorld.player.primaryWeaponType = RapidGun;
		}
		
	}

}
