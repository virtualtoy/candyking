package candyking.game.powerups {
	
	import candyking.game.weapons.Grenade;
	
	public class NukePowerup extends Powerup {
		
		public function NukePowerup() {
			super("entities/powerup_nuke.xml");
		}
		
		protected override function onPickedUp():void {
			_gameWorld.specialWeaponAmount++;
		}
		
	}

}
