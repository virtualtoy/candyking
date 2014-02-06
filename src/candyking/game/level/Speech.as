package candyking.game.level {
	
	import candyking.assets.Assets;
	import candyking.game.GameWorld;
	import candyking.game.ui.SpeechPanel;
	import candyking.utils.XMLUtil;
	import net.flashpunk.FP;

	public class Speech extends Frame {
		
		private var _entriesXMLList:XMLList;
		private var _entryIndex:int = 0;
		private var _panel:SpeechPanel;
		
		public function Speech(world:GameWorld, xml:XML) {
			super(world, true, true);
			_delay = XMLUtil.parseNumber(xml, "@delay");
			_entriesXMLList = xml.Entry;
		}
		
		public override function update(hasActiveFrames:Boolean):void {
			_time += FP.elapsed;
			if (!_started) {
				if (_time >= _delay) {
					_started = true;
					_panel = _world.create(SpeechPanel) as SpeechPanel;
					showNextEntry();
				}
			}else if (!_completed) {
				if (_world.controller.beganEsc) {
					_completed = true;
					_world.recycle(_panel);
				}else if (_panel.completed && (_world.controller.beganPrimary || _world.controller.beganSecondary)) {
					if (++_entryIndex == _entriesXMLList.length()) {
						_completed = true;
						_world.recycle(_panel);
					}else {
						showNextEntry();
					}
				}
			}
		}
		
		private function showNextEntry():void {
			var entryXML:XML = _entriesXMLList[_entryIndex];
			_panel.display(Assets.getAsset(entryXML.@portrait), entryXML.@text);
		}
		
	}

}
