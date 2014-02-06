package candyking.game.enemies {
	
	import candyking.game.ammo.EnemyBullet;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	
	public class LifeSaver extends WayFollowingEnemy {
		
		public static const INIT_HEALTH:int = 2;
		public static const VALUE:int = 5;
		public static const AMMO_OFFSET_X:Number = 12;
		public static const AMMO_OFFSET_Y:Number = 12;
		
		public function LifeSaver() {
			super(INIT_HEALTH, VALUE, "entities/enemy_lifesaver.xml", "highlight");
			var hitArea:Stamp = getGraphic("highlight") as Stamp;
			enablePixelCollisions(hitArea.source, hitArea.x, hitArea.y);
		}
		
		override public function added():void {
			super.added();
			(getGraphic("body") as Spritemap).randFrame();
		}
		
		protected override function performShoot():void {
			shootAtPlayer(EnemyBullet, AMMO_OFFSET_X, AMMO_OFFSET_Y, 2);
		}
		
	}

}
