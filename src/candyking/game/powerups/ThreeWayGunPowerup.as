package candyking.game.powerups {
	
	import candyking.game.weapons.ThreeWayGun;
	
	public class ThreeWayGunPowerup extends Powerup {
		
		public function ThreeWayGunPowerup() {
			super("entities/powerup_three_way_gun.xml");
		}
		
		protected override function onPickedUp():void {
			_gameWorld.player.primaryWeaponType = ThreeWayGun;
		}
		
	}

}
