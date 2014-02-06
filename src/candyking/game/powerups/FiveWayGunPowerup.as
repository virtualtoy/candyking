package candyking.game.powerups {
	
	import candyking.game.weapons.FiveWayGun;
	
	public class FiveWayGunPowerup extends Powerup {
		
		public function FiveWayGunPowerup() {
			super("entities/powerup_five_way_gun.xml");
		}
		
		protected override function onPickedUp():void {
			_gameWorld.player.primaryWeaponType = FiveWayGun;
		}
		
	}

}
