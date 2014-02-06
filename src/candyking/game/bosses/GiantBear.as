package candyking.game.bosses {
	
	import candyking.game.GameEntity;
	import candyking.utils.SoundUtil;
	import net.flashpunk.graphics.Stamp;
	
	public class GiantBear extends Boss {
		
		public static const INIT_HEALTH:int = 150;
		public static const VALUE:int = 2000;
		
		private var _body:Stamp;
		private var _behaviour:GiantBearBehaviour;
		
		public function GiantBear() {
			super(INIT_HEALTH, VALUE, "entities/boss_giant_bear.xml", "highlight");
		}
		
		public override function added():void {
			super.added();
			
			_body = getGraphic("body") as Stamp;
			_behaviour = new GiantBearBehaviour(_gameWorld, this);
		}
		
		override public function update():void {
			if (dead) {
				_gameWorld.addExplosionWithinBounds(this);
				updateHighlight();
			}else {
				_behaviour.update();
				super.update();
			}
		}
		
		override public function collides(entity:GameEntity):Boolean {
			return collidesPixels(entity, _body.source, _body.x, _body.y);
		}
		
		override protected function die():void {
			SoundUtil.playLargeExplosion();
			_gameWorld.removeEnemiesAndAmmos();
			_behaviour.die();
		}
		
	}

}
