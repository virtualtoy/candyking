package candyking.game.ammo {
	
	import candyking.game.collisions.ColliderType;
	
	public class EnemyBulletLarge extends Ammo {
		
		public function EnemyBulletLarge() {
			super(ColliderType.ENEMY_AMMO, int.MAX_VALUE, "entities/enemy_bullet_large.xml");
		}
		
		override public function update():void {
			x += dx;
			y += dy;
			super.update();
		}
		
	}
}
