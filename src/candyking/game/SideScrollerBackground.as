package candyking.game {
	
	import candyking.graphics.GraphicFactory;
	import candyking.utils.XMLUtil;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	
	public class SideScrollerBackground extends Entity {
		
		private var _offset:Number = 0;
		private var _layers:Vector.<Graphic> = new Vector.<Graphic>();
		private var _scrollFactors:Vector.<Number> = new Vector.<Number>();
		private var _xml:XML;
		
		public function SideScrollerBackground(xml:XML) {
			_xml = xml;
		}
		
		override public function added():void {
			var layersList:XMLList = _xml.*;
			for each (var layerXML:XML in layersList) {
				var scrollFactor:Number = XMLUtil.parseNumber(layerXML, "@scrollFactor", 1);
				var layer:Graphic = GraphicFactory.create(layerXML);
				addGraphic(layer);
				_layers.push(layer);
				_scrollFactors.push(scrollFactor);
			}
		}
		
		override public function update():void {
			
		}
		
		public function get offset():Number {
			return _offset;
		}
		
		public function set offset(value:Number):void {
			if (_offset != value) {
				_offset = value;
				for (var i:int = 0, l:int = _layers.length; i < l; i++) {
					var scrollFactor:Number = _scrollFactors[i];
					if (scrollFactor) {
						_layers[i].x = _offset * scrollFactor;
					}
				}
			}
		}
		
	}

}
