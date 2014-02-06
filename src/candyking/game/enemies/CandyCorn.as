package candyking.game.enemies {
	
	import candyking.game.ammo.EnemyBulletLarge;
	import net.flashpunk.graphics.Stamp;
	
	public class CandyCorn extends WayFollowingEnemy {
		
		public static const INIT_HEALTH:int = 30;
		public static const VALUE:int = 50;
		public static const AMMO_OFFSET_X:Number = 0;
		public static const AMMO_OFFSET_Y:Number = 24;
		
		public function CandyCorn() {
			super(INIT_HEALTH, VALUE, "entities/enemy_candy_corn.xml", "highlight");
			var hitArea:Stamp = getGraphic("highlight") as Stamp;
			enablePixelCollisions(hitArea.source, hitArea.x, hitArea.y);
		}
		
		protected override function performShoot():void {
			shootAtPlayer(EnemyBulletLarge, AMMO_OFFSET_X, AMMO_OFFSET_Y, 2);
		}
		
	}

}
