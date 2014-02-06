package candyking.game.ammo {
	
	import candyking.game.collisions.ColliderType;
	
	public class EnemyBullet extends Ammo {
		
		public function EnemyBullet() {
			super(ColliderType.ENEMY_AMMO, int.MAX_VALUE, "entities/enemy_bullet.xml");
		}
		
		override public function update():void {
			x += dx;
			y += dy;
			super.update();
		}
		
	}
}
