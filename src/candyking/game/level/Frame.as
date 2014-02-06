package candyking.game.level {
	
	import candyking.game.GameWorld;
	
	public class Frame {
		
		protected var _world:GameWorld;
		protected var _started:Boolean = false;
		protected var _completed:Boolean = false;
		protected var _time:Number = 0;
		protected var _delay:Number;
		private var _waitForCompletion:Boolean;
		private var _startIfNoFrames:Boolean;
		
		public function Frame(world:GameWorld, startIfNoFrames:Boolean, waitForCompletion:Boolean) {
			_world = world;
			_startIfNoFrames = startIfNoFrames;
			_waitForCompletion = waitForCompletion;
		}
		
		public function update(hasActiveFrames:Boolean):void {
			
		}
		
		public function get startIfNoFrames():Boolean {
			return _startIfNoFrames;
		}
		
		public function get waitForCompletion():Boolean {
			return _waitForCompletion;
		}
		
		public function get started():Boolean {
			return _started;
		}
		
		public function get completed():Boolean {
			return _completed;
		}
		
	}

}
