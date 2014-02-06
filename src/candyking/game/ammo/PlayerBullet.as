package candyking.game.ammo {
	
	import candyking.game.collisions.ColliderType;
	
	public class PlayerBullet extends Ammo {
		
		public static const DAMAGE:int = 1;
		
		public function PlayerBullet() {
			super(ColliderType.PLAYER_AMMO, DAMAGE, "entities/player_bullet.xml");
		}
		
		override public function update():void {
			x += dx;
			y += dy;
			super.update();
		}
		
	}
}
