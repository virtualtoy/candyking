package candyking.utils {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class XMLUtil {
		
		public static function parseString(xml:XML, propertyName:String, defaultValue:String = null):String {
			if (xml.hasOwnProperty(propertyName)) {
				return xml[propertyName];
			}
			return defaultValue;
		}
		
		public static function parseBoolean(xml:XML, propertyName:String, defaultValue:Boolean = false):Boolean {
			if (xml.hasOwnProperty(propertyName)) {
				return String(xml[propertyName]) == "true";
			}
			return defaultValue;
		}
		
		public static function parseNumber(xml:XML, propertyName:String, defaultValue:Number = 0):Number {
			if (xml.hasOwnProperty(propertyName)) {
				return parseFloat(xml[propertyName]);
			}
			return defaultValue;
		}
		
		public static function parsePoint(xml:XML, propertyName:String, defaultValue:Point = null):Point {
			if (xml.hasOwnProperty(propertyName)) {
				var pointXML:XML = xml[propertyName][0];
				return new Point(pointXML.@x, pointXML.@y);
			}
			return defaultValue;
		}
		
		public static function parseRectangle(xml:XML, propertyName:String, defaultValue:Rectangle = null):Rectangle {
			if (xml.hasOwnProperty(propertyName)) {
				var rectXML:XML = xml[propertyName][0];
				return new Rectangle(rectXML.@x, rectXML.@y, rectXML.@width, rectXML.@height);
			}
			return defaultValue;
		}
		
	}

}
