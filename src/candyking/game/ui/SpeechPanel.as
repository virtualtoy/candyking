package candyking.game.ui {
	
	import candyking.assets.Assets;
	import candyking.game.EntityLayer;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.extensions.vozochris.Scale9Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	
	public class SpeechPanel extends Entity {
		
		private var _portrait:Stamp = new Stamp(null);
		private var _continueIcon:Spritemap;
		private var _label:Text; 
		private var _textToShow:String;
		private var _textToShowLength:int;
		private var _updateCount:int;
		private var _completed:Boolean = false;
		
		public function SpeechPanel() {
			super(50, 180);
			layer = EntityLayer.OVERLAY;
			_label = new Text("", 44, 0, { wordWrap: true, size: 8, resizable: true, width: 252 } );
			_continueIcon = new Spritemap(Assets.getAsset("images/ui_icon_continue_animated.png"), 4, 7);
			_continueIcon.x = 293;
			_continueIcon.y = 25;
			_continueIcon.add("default", [0, 1], 5);
			_continueIcon.play("default");
			var panel:Scale9Image = new Scale9Image(Assets.getAsset("images/ui_panel_blue.png"),
													new Rectangle(5, 5, 50, 10),
													null,
													260,
													35);
			panel.x = 40;
			addGraphic(panel);
			addGraphic(_portrait);
			addGraphic(_label);
			addGraphic(_continueIcon);
		}
		
		public function display(portraitTexture:BitmapData, text:String):void {
			_portrait.source = portraitTexture;
			_label.text = "";
			_textToShow = text;
			_textToShowLength = 0;
			_updateCount = 0;
			_completed = false;
			_continueIcon.visible = false;
		}
		
		override public function update():void {
			if (++_updateCount % 2 == 0) {
				if (_textToShowLength != _textToShow.length) {
					_textToShowLength++;
					_label.text = _textToShow.substr(0, _textToShowLength);
				}else {
					_completed = true;
					_continueIcon.visible = true;
				}
			}
		}
		
		public function get completed():Boolean {
			return _completed;
		}
		
	}

}
