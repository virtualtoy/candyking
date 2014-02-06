package candyking.tweens {
	
	import net.flashpunk.tweens.motion.Motion;
	
	public class PendulumMotion extends Motion {
		
		public static const X_AXIS:int 		= 1;
		public static const Y_AXIS:int 		= 2;
		public static const X_Y_AXIS:int 	= 3;
		
		private var _goingForward:Boolean = true;
		private var _axis:int = X_Y_AXIS;
		private var _fromX:Number = 0;
		private var _fromY:Number = 0;
		private var _moveX:Number = 0;
		private var _moveY:Number = 0;
		private var _distance:Number = - 1;
		
		public function PendulumMotion(complete:Function = null, type:uint = 0) {
			super(0, complete, type);
		}
		
		/**
		 * Starts moving along a line.
		 * @param	fromX		X start.
		 * @param	fromY		Y start.
		 * @param	toX			X finish.
		 * @param	toY			Y finish.
		 * @param	duration	Duration of the movement.
		 * @param	ease		Optional easer function.
		 */
		public function setMotion(fromX:Number, fromY:Number, toX:Number, toY:Number, duration:Number, ease:Function = null, axis:int = X_Y_AXIS):void
		{
			_goingForward = true;
			_axis = axis;
			_distance = -1;
			if ((_axis & X_AXIS)) {
				x = _fromX = fromX;
			}
			if ((_axis & Y_AXIS)) {
				y = _fromY = fromY;
			}
			_moveX = toX - fromX;
			_moveY = toY - fromY;
			_target = duration;
			_ease = ease;
			start();
		}
		
		/**
		 * Starts moving along a line at the speed.
		 * @param	fromX		X start.
		 * @param	fromY		Y start.
		 * @param	toX			X finish.
		 * @param	toY			Y finish.
		 * @param	speed		Speed of the movement.
		 * @param	ease		Optional easer function.
		 */
		public function setMotionSpeed(fromX:Number, fromY:Number, toX:Number, toY:Number, speed:Number, ease:Function = null, axis:int = X_Y_AXIS):void
		{
			_goingForward = true;
			_axis = axis;
			_distance = -1;
			if (_axis & X_AXIS) {
				x = _fromX = fromX;
			}
			if (_axis & Y_AXIS) {
				y = _fromY = fromY;
			}
			_moveX = toX - fromX;
			_moveY = toY - fromY;
			_target = distance / speed;
			_ease = ease;
			start();
		}
		
		/** @private Updates the Tween. */
		override public function update():void 
		{
			super.update();
			if (delay > 0) return;
			
			if (_axis & X_AXIS) {
				x = _goingForward ? _fromX + _moveX * _t : _fromX + _moveX * (1 - _t);
			}
			if (_axis & Y_AXIS) {
				y = _goingForward ? _fromY + _moveY * _t : _fromY + _moveY * (1 - _t);
			}
			
			if (_t == 1) {
				_goingForward = !_goingForward;
			}
		}
		
		/**
		 * Length of the current line of movement.
		 */
		public function get distance():Number
		{
			if (_distance <= 0) {
				if (_axis & X_Y_AXIS) {
					_distance = Math.sqrt(_moveX * _moveX + _moveY * _moveY)
				}else if (_axis & X_AXIS) {
					_distance = Math.abs(_moveX);
				}else if (_axis & Y_AXIS) {
					_distance = Math.abs(_moveY);
				}else {
					_distance = 0;
				}
			}
			return _distance;
		}
		
	}

}
