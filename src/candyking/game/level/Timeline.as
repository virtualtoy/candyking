package candyking.game.level {
	
	import candyking.game.GameWorld;
	import candyking.utils.XMLUtil;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class Timeline extends Entity {
		
		private var _levelXML:XML;
		private var _gameWorld:GameWorld;
		private var _availableFrames:Vector.<Frame> = new Vector.<Frame>();
		private var _activeFrames:Vector.<Frame> = new Vector.<Frame>();
		private var _completed:Boolean = false;
		
		public function Timeline(levelXML:XML) {
			super();
			_levelXML = levelXML;
		}
		
		override public function added():void {
			_gameWorld = world as GameWorld;
			
			var refs:XML = _levelXML.Refs[0];
			var framesList:XMLList = _levelXML.Timeline.*;
			
			for each (var frameXML:XML in framesList) {
				
				var frameType:String = frameXML.localName();
				var refId:String = XMLUtil.parseString(frameXML, "@ref");
				var refXML:XML = refId ? refs[frameType].(@id == refId)[0] : null;
				var frame:Frame;
				
				switch (frameType) {
					case "EnemyWave":
						frame = new EnemyWave(_gameWorld, frameXML, refXML);
						break;
						
					case "Speech":
						frame = new Speech(_gameWorld, frameXML);
						break;
						
					default:
						throw new ArgumentError("Frame type is not supported: " + frameType);
				}
				
				_availableFrames.push(frame);
			}
		}
		
		override public function update():void {
			var waitForCompletion:Boolean = false;
			for (var i:int = _activeFrames.length - 1; i >= 0; i--) {
				var frame:Frame = _activeFrames[i];
				frame.update(true);
				if (frame.completed) {
					_activeFrames.splice(i, 1);
					if (_activeFrames.length == 0 && _availableFrames.length == 0) {
						_completed = true;
					}
				}else if (frame.waitForCompletion) {
					waitForCompletion = true;
				}
			}
			
			if (!waitForCompletion && _availableFrames.length) {
				var firstAvailabeFrame:Frame = _availableFrames[0];
				if (firstAvailabeFrame.startIfNoFrames && _activeFrames.length) {
					return;
				}
				firstAvailabeFrame.update(_activeFrames.length > 0);
				if (firstAvailabeFrame.started) {
					_availableFrames.shift();
					_activeFrames.push(firstAvailabeFrame);
				}
			}
		}
		
		public function get hasActiveFrames():Boolean {
			return _activeFrames.length > 0;
		}
		
		public function get completed():Boolean {
			return _completed;
		}
		
	}

}
