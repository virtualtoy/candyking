package candyking.game.enemies {
	
	import candyking.game.ammo.EnemyBullet;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	public class Marshmallow extends ShootingEnemy {
		
		public static const INIT_HEALTH:int = 4;
		public static const VALUE:int = 10;
		public static const AMMO_OFFSET_X:Number = 13;
		public static const AMMO_OFFSET_Y:Number = 15;
		
		private var _dx:Number;
		private var _dy:Number;
		
		public function Marshmallow() {
			super(INIT_HEALTH, VALUE, "entities/enemy_marshmallow.xml", "highlight");
		}
		
		override public function added():void {
			super.added();
			
			(getGraphic("body") as Spritemap).randFrame();
			_dx = 1;
			_dy = 1;
			x = -width;
			y = FP.height - height;
		}
		
		override public function update():void {
			x += _dx;
			y += _dy;
			_dy += 0.08;
			if (_dy > 5) {
				_dy = 5;
			}
			
			var maxY:Number = FP.height - height;
			if (y >= maxY) {
				_dy = -2;
				y = maxY;
			}
			
			if (x > FP.width) {
				remove();
			}else {
				super.update();
			}
		}
		
		protected override function performShoot():void {
			shootAtPlayer(EnemyBullet, AMMO_OFFSET_X, AMMO_OFFSET_Y, 2);
		}
		
	}

}
