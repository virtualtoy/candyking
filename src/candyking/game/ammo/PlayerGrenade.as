package candyking.game.ammo {
	
	import candyking.game.collisions.ColliderType;
	
	public class PlayerGrenade extends Ammo {
		
		public static const DAMAGE:int = 2;
		
		public function PlayerGrenade() {
			super(ColliderType.PLAYER_AMMO, DAMAGE, "entities/player_grenade.xml");
		}
		
		public override function added():void {
			super.added();
			dx = 1.5 + Math.random() * 0.5;
			dy = -0.5 - Math.random() * 0.5;
		}
		
		override public function update():void {
			x += dx;
			y += dy;
			dy += 0.02;
			if (dy > 3) {
				dy = 3;
			}
			super.update();
		}
		
	}
}
