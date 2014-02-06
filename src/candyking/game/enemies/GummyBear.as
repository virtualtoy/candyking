package candyking.game.enemies {
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	public class GummyBear extends ShootingEnemy {
		
		public static const INIT_HEALTH:int = 2;
		public static const VALUE:int = 5;
		
		private var _dx:Number;
		private var _dy:Number;
		
		public function GummyBear() {
			super(INIT_HEALTH, VALUE, "entities/enemy_gummy_bear.xml", "highlight");
		}
		
		override public function added():void {
			super.added();
			
			(getGraphic("body") as Spritemap).randFrame();
			_dx = -(2 + Math.random() * 1);
			_dy = 1;
			x = FP.width;
			y = Math.random() * (FP.height - height);
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
				_dy = -(2 + Math.random() * 3);
				y = maxY;
			}
			
			if (x < -width) {
				remove();
			}else {
				super.update();
			}
			
		}
		
	}

}
