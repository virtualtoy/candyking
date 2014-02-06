package candyking.game {
	
	import candyking.game.GameEntity;
	import candyking.utils.SoundUtil;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	
	public class Ship extends GameEntity {
		
		protected var _health:int;
		protected var _initHealth:int;
		
		private var _highlightTime:Number = 0;
		private var _highlight:Graphic;
		
		public function Ship(colliderType:int, initHealth:int, xmlAssetId:String = null, highlightName:String = null) {
			super(colliderType, xmlAssetId);
			_initHealth = initHealth;
			if (highlightName) {
				_highlight = getGraphic(highlightName);
				_highlight.visible = false;
			}
		}
		
		public override function added():void {
			super.added();
			resetHealth();
			if (_highlight) {
				_highlight.visible = false;
				_highlightTime = 0;
			}
		}
		
		protected function resetHealth():void {
			_health = _initHealth;
		}
		
		protected function die():void {
			throw new Error("Override required");
		}
		
		public function damage(value:int):void {
			if (_health > 0) {
				_health -= value;
				if (_health <= 0) {
					SoundUtil.playExplosion();
					die();
				}else {
					SoundUtil.playHit();
					showHighlight();
				}
			}
		}
		
		public function get dead():Boolean {
			return _health <= 0;
		}
		
		protected function updateHighlight():void {
			if (_highlightTime > 0) {
				_highlightTime -= FP.elapsed;
				if (_highlightTime < 0) {
					_highlightTime = 0;
				}else if (_highlightTime < 0.05) {
					_highlight.visible = false;
				}
			}
		}
		
		public function showHighlight():void {
			if (_highlight && _highlightTime == 0) {
				_highlightTime = 0.1;
				_highlight.visible = true;
			}
		}
		
	}

}
