package candyking.game.bosses {
	
	import candyking.game.GameEntity;
	import candyking.utils.SoundUtil;
	import net.flashpunk.graphics.Stamp;
	
	public class CandyKing extends Boss {
		
		public static const INIT_HEALTH:int = 130;
		public static const VALUE:int = 1000;
		
		private var _body:Stamp;
		private var _crown:Stamp;
		private var _behaviour:CandyKingBehaviour;
		
		public function CandyKing() {
			super(INIT_HEALTH, VALUE, "entities/boss_candy_king.xml", "highlight");
		}
		
		override public function added():void {
			super.added();
			_body = getGraphic("body") as Stamp;
			_crown = getGraphic("crown") as Stamp;
			_behaviour = new CandyKingBehaviour(_gameWorld, this);
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
			return 	collidesPixels(entity, _body.source, _body.x, _body.y) ||
					collidesPixels(entity, _crown.source, _crown.x, _crown.y);
		}
		
		override protected function die():void {
			SoundUtil.playLargeExplosion();
			_gameWorld.removeEnemiesAndAmmos();
			_behaviour.die();
		}
		
	}

}
