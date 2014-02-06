package candyking.game.enemies {
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.tweens.motion.LinearMotion;

	public class LoveCandy extends Enemy {
		
		public static const INIT_HEALTH:int = 3;
		public static const VALUE:int = 7;
		public static const SPEED:int = 70;
		
		public var angle:Number;
		
		private var _spawnX:Number;
		private var _spawnY:Number;
		private var _tween:LinearMotion = new LinearMotion();
		
		public function LoveCandy() {
			super(INIT_HEALTH, VALUE, "entities/enemy_love_candy.xml", "highlight");
			var hitArea:Stamp = getGraphic("highlight") as Stamp;
			enablePixelCollisions(hitArea.source, hitArea.x, hitArea.y);
			_tween.object = this;
			addTween(_tween);
		}
		
		override public function added():void {
			super.added();
			
			(getGraphic("body") as Spritemap).randFrame();
			
			var player:Entity = _gameWorld.player;
			
			var cx:Number = player.x + player.width / 2 - width / 2;
			var cy:Number = player.y + player.height / 2 - height / 2;
			
			var maxDist:Number = Math.max(cx + width, FP.width - cx);
			
			_spawnX = cx + Math.cos(angle * FP.RAD) * maxDist;
			_spawnY = cy + Math.sin(angle * FP.RAD) * maxDist;
			
			var minDist:Number = 34;
			
			var toX:Number = cx + Math.cos(angle * FP.RAD) * minDist;
			var toY:Number = cy + Math.sin(angle * FP.RAD) * minDist;
			
			_tween.delay = 0;
			_tween.complete = onTweenCompleted_1;
			_tween.setMotionSpeed(_spawnX, _spawnY, toX, toY, SPEED);
		}
		
		private function onTweenCompleted_1():void {
			_tween.delay = 2;
			_tween.complete = remove;
			_tween.setMotionSpeed(x, y, _spawnX, _spawnY, SPEED);
		}
		
		public override function remove():void {
			_tween.active = false;
			super.remove();
		}
		
	}

}
