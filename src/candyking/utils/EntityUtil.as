package candyking.utils {
	
	import candyking.graphics.GraphicFactory;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	
	public class EntityUtil {
		
		public static function setup(xml:XML, entity:Entity, nameToGraphicDict:Dictionary = null):void {
			entity.x = XMLUtil.parseNumber(xml, "@x", entity.x);
			entity.y = XMLUtil.parseNumber(xml, "@y", entity.y);
			entity.width = XMLUtil.parseNumber(xml, "@width", entity.width);
			entity.height = XMLUtil.parseNumber(xml, "@height", entity.height);
			entity.visible = XMLUtil.parseBoolean(xml, "@visible", entity.visible);
			
			if (xml.hasOwnProperty("Graphic")) {
				var graphicList:XMLList = xml.Graphic.*;
				if (graphicList.length() == 1) {
					entity.graphic = GraphicFactory.create(graphicList[0], nameToGraphicDict);
				}else {
					for each (var graphicXML:XML in graphicList) {
						entity.addGraphic(GraphicFactory.create(graphicXML, nameToGraphicDict));
					}
				}
			}
		}
		
	}

}
