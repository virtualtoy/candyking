package candyking.game.enemies {
	
	import candyking.game.ammo.PeppermintBomb;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	
	public class Lollipop extends WayFollowingEnemy {
		
		public static const INIT_HEALTH:int = 20;
		public static const VALUE:int = 25;
		public static const AMMO_OFFSET_X:Number = 2;
		
		public var ammoOffsetY:Number = 0;
		
		public function Lollipop() {
			super(INIT_HEALTH, VALUE, "entities/enemy_lollipop.xml", "highlight");
			var hitArea:Stamp = getGraphic("highlight") as Stamp;
			enablePixelCollisions(hitArea.source, hitArea.x, hitArea.y);
		}
		
		override public function added():void {
			super.added();
			(getGraphic("body") as Spritemap).randFrame();
		}
		
		protected override function performShoot():void {
			if (y < 97) {
				shoot(PeppermintBomb, AMMO_OFFSET_X, 31, 0, ammoOffsetY);
			}else {
				shoot(PeppermintBomb, AMMO_OFFSET_X, -25, 0, ammoOffsetY);
			}
		}
		
		public override function removed():void {
			ammoOffsetY = 0;
			super.removed();
		}
		
	}

}
