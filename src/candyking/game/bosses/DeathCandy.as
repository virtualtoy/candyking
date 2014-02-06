package candyking.game.bosses {
	
	import candyking.game.GameEntity;
	import candyking.utils.SoundUtil;
	import net.flashpunk.graphics.Stamp;
	
	public class DeathCandy extends Boss {
		
		public static const INIT_HEALTH:int = 180;
		public static const VALUE:int = 3000;
		
		private var _body:Stamp;
		private var _behaviour:DeathCandyBehaviour;
		
		public function DeathCandy() {
			super(INIT_HEALTH, VALUE, "entities/boss_death_candy.xml", "highlight");
		}
		
		override public function added():void {
			super.added();
			_body = getGraphic("body") as Stamp;
			_behaviour = new DeathCandyBehaviour(_gameWorld, this);
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
