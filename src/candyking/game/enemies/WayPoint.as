package candyking.game.enemies {
	
	import net.flashpunk.utils.Ease;
	
	public class WayPoint {
		
		private var _x:Number;
		private var _y:Number;
		private var _ease:String;
		private var _easeFunc:Function;
		private var _delay:Number;
		
		public function WayPoint(x:Number, y:Number, delay:Number = 0, ease:String = null) {
			_x = x;
			_y = y;
			_delay = delay;
			_ease = ease;
			_easeFunc = _ease ? Ease[_ease] : null;
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function get delay():Number {
			return _delay;
		}
		
		public function get ease():Function {
			return _easeFunc;
		}
		
		public function toString():String {
			return "[WayPoint x=" + x + " y=" + y + " delay=" + _delay + " ease=" + _ease + "]";
		}
		
	}

}
