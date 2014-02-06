package candyking.ui {
	
	import candyking.assets.Assets;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.extensions.vozochris.Scale9Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	public class Button extends Entity {
		
		private static const BACKGROUND_RECT:Rectangle = new Rectangle(5, 5, 50, 10);
		private static const HORIZONTAL_PADDING:Number = 10;
		private static const VERTICAL_PADDING:Number = 2;
		private static const ICON_GAP:Number = 2;
		
		private var _label:Text;
		private var _icon:Stamp;
		private var _iconAssetId:String;
		private var _horizontalPadding:Number;
		private var _verticalPadding:Number;
		private var _iconGap:Number;
		private var _normalBackground:Scale9Image;
		private var _activatedBackground:Scale9Image;
		private var _activated:Boolean = false;
		private var _actionCallback:Function;
		
		public function Button(text:String, actionCallback:Function = null, options:Object = null) {
			_actionCallback = actionCallback;
			
			_iconAssetId = null;
			_horizontalPadding = HORIZONTAL_PADDING;
			_verticalPadding = VERTICAL_PADDING;
			_iconGap = ICON_GAP;
			
			if (options) {
				if (options.hasOwnProperty("iconAssetId")) { _iconAssetId = options.iconAssetId; }
				if (options.hasOwnProperty("horizontalPadding")) { _horizontalPadding = options.horizontalPadding; }
				if (options.hasOwnProperty("verticalPadding")) { _verticalPadding = options.verticalPadding; }
				if (options.hasOwnProperty("iconGap")) { _iconGap = options.iconGap; }
			}
			_label = new Text(text, 0, 0, { wordWrap: false, size: 16, resizable: true } );
			_icon = new Stamp(iconAssetId ? Assets.getAsset(iconAssetId) : null);
			_normalBackground = new Scale9Image(Assets.getAsset("images/ui_panel_blue.png"), BACKGROUND_RECT);
			_activatedBackground = new Scale9Image(Assets.getAsset("images/ui_panel_orange.png"), BACKGROUND_RECT);
			addGraphic(_normalBackground);
			addGraphic(_activatedBackground);
			addGraphic(_label);
			addGraphic(_icon);
			redraw();
		}
		
		override public function update():void {
			if (visible) {
				if (collidePoint(x, y, Input.mouseX, Input.mouseY)) {
					if (Input.mousePressed) {
						activated = true;
					}else if (Input.mouseReleased && activated) {
						activated = false;
						if (_actionCallback != null) {
							_actionCallback();
						}
					}
				}else {
					activated = false;
				}
			}
		}
		
		private function redraw():void {
			var labelWidth:Number = _label.text != "" ? _label.width : 0;
			var labelHeight:Number = _label.text != "" ? _label.height : 0;
			
			var width:Number = labelWidth + (_icon.source ? _icon.width + _iconGap : 0) + _horizontalPadding * 2;
			var height:Number = Math.max(labelHeight, (_icon.source ? _icon.height : 0)) + _verticalPadding * 2;
			
			if (_iconAssetId) {
				width = labelWidth + _icon.width + (labelWidth == 0 ? 0 : _iconGap) + _horizontalPadding * 2;
				height = Math.max(labelHeight, _icon.height) + _verticalPadding * 2;
				_label.x = _horizontalPadding;
				_label.y = (height - labelHeight) / 2;
				_icon.x = width - _icon.width - _horizontalPadding;
				_icon.y = (height - _icon.height) / 2;
			}else {
				width = labelWidth + _horizontalPadding * 2;
				height = labelHeight + _verticalPadding * 2;
				_label.x = _horizontalPadding;
				_label.y = _verticalPadding;
			}
			
			_normalBackground.redraw(width, height, false);
			_activatedBackground.redraw(width, height, false);
			
			_normalBackground.visible = !_activated;
			_activatedBackground.visible = _activated;
			setHitbox(width, height);
		}
		
		public function get text():String {
			return _label.text;
		}
		
		public function set text(value:String):void {
			if (_label.text != value) {
				_label.text = value;
				redraw();
			}
		}
		
		public function get iconAssetId():String {
			return _iconAssetId;
		}
		
		public function set iconAssetId(value:String):void {
			if (_iconAssetId != value) {
				_iconAssetId = value;
				_icon.source = Assets.getAsset(_iconAssetId);
				redraw();
			}
		}
		
		public function get activated():Boolean {
			return _activated;
		}
		
		public function set activated(value:Boolean):void {
			if (_activated != value) {
				_activated = value;
				redraw();
			}
		}
		
	}

}
