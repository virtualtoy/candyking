package candyking.graphics {
	
	import candyking.assets.Assets;
	import candyking.utils.XMLUtil;
	import flash.utils.Dictionary;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	
	public class GraphicFactory {
		
		public static function create(xml:XML, nameToGraphicDict:Dictionary = null):Graphic {
			
			var graphic:Graphic;
			var type:String = xml.localName();
			
			switch (type) {
				case "Spritemap":
					graphic = createSpritemap(xml);
					break;
					
				case "Stamp":
					graphic = createStamp(xml);
					break;
					
				case "Image":
					graphic = createImage(xml);
					break;
					
				case "Backdrop":
					graphic = createBackdrop(xml);
					break;
					
				case "StarBackground":
					graphic = createStarBackground(xml);
					break;
					
				case "Text":
					graphic = createText(xml);
					break;
					
				default:
					throw new ArgumentError("Type is not supported: " + type);
			}
			
			setAttributes(xml, graphic, nameToGraphicDict);
			
			return graphic;
		}
		
		private static function createText(xml:XML):Text {
			var text:String = XMLUtil.parseString(xml, "@text", "");
			
			var options:Object = { };
			var font:String = XMLUtil.parseString(xml, "@font", null);
			var size:Number = XMLUtil.parseNumber(xml, "@size", NaN);
			var align:String = XMLUtil.parseString(xml, "@align", null);
			var width:Number = XMLUtil.parseNumber(xml, "@width", NaN);
			var height:Number = XMLUtil.parseNumber(xml, "@height", NaN);
			
			if (font) { options.font = font; }
			if (!isNaN(size)) { options.size = size; }
			if (align) { options.align = align; }
			if (!isNaN(width)) { options.width = width; }
			if (!isNaN(height)) { options.height = height; }
			
			if (xml.hasOwnProperty("@wordWrap")) { options.wordWrap = XMLUtil.parseBoolean(xml, "@wordWrap"); }
			if (xml.hasOwnProperty("@resizable")) { options.resizable = XMLUtil.parseBoolean(xml, "@resizable"); }
			
			return new Text(text, 0, 0, options);
		}
		
		private static function createStarBackground(xml:XML):StarBackground {
			var starCount:int = XMLUtil.parseNumber(xml, "@starCount", 50);
			var speedX:int = XMLUtil.parseNumber(xml, "@speedX", -1);
			var speedY:int = XMLUtil.parseNumber(xml, "@speedY", 0);
			return new StarBackground(starCount, speedX, speedY);
		}
		
		private static function createBackdrop(xml:XML):Backdrop {
			var repeatX:Boolean = xml.hasOwnProperty("@repeatX") ? String(xml.@repeatX) == "true" : true;
			var repeatY:Boolean = xml.hasOwnProperty("@repeatY") ? String(xml.@repeatY) == "true" : true;
			return new Backdrop(Assets.getAsset(xml.@source), repeatX, repeatY);
		}
		
		private static function createImage(xml:XML):Image {
			return new Image(Assets.getAsset(xml.@source));
		}
		
		private static function createStamp(xml:XML):Stamp {
			return new Stamp(Assets.getAsset(xml.@source));
		}
		
		private static function createSpritemap(xml:XML):Spritemap {
			var spritemap:Spritemap = new Spritemap(Assets.getAsset(xml.@source), xml.@frameWidth, xml.@frameHeight);
			var animList:XMLList = xml.Animation;
			for each(var animXML:XML in animList) {
				var frames:Array = XMLUtil.parseString(animXML, "@frames", "").split(",");
				var frameRate:Number = XMLUtil.parseNumber(animXML, "@frameRate", 0);
				var loop:Boolean = XMLUtil.parseBoolean(animXML, "@loop", true);
				spritemap.add(animXML.@name, frames, frameRate, loop);
			}
			if (xml.hasOwnProperty("@play")) {
				spritemap.play(xml.@play);
			}
			return spritemap;
		}
		
		private static function setAttributes(xml:XML, graphic:Graphic, nameToGraphicDict:Dictionary):void {
			var name:String;
			if (nameToGraphicDict && (name = XMLUtil.parseString(xml, "@name"))) {
				nameToGraphicDict[name] = graphic;
			}
			graphic.x = XMLUtil.parseNumber(xml, "@x", 0);
			graphic.y = XMLUtil.parseNumber(xml, "@y", 0);
			graphic.visible = XMLUtil.parseBoolean(xml, "@visible", true);
		}
		
	}

}
