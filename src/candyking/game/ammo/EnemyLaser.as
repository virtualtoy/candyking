package candyking.game.ammo {
	
	import candyking.game.collisions.ColliderType;
	
	public class EnemyLaser extends Ammo {
		
		public function EnemyLaser() {
			super(ColliderType.ENEMY_AMMO, int.MAX_VALUE, "entities/enemy_laser.xml");
		}
		
		override public function update():void {
			x += dx;
			super.update();
		}
		
	}
}
