package candyking.game.level {
	
	import candyking.game.enemies.Enemy;
	import candyking.game.GameWorld;
	import candyking.utils.XMLUtil;
	import net.flashpunk.FP;
	
	public class EnemyWave extends Frame {
		
		private var _enemyDefs:Vector.<EnemyDef> = new Vector.<EnemyDef>();
		
		private var _enemyCount:int = 0;
		private var _killedEnemyCount:int = 0;
		private var _spawnedEnemyCount:int = 0;
		
		public function EnemyWave(world:GameWorld, xml:XML, refXML:XML = null) {
			var waitForCompletion:Boolean = XMLUtil.parseBoolean(xml, "@waitForCompletion", false);
			var startIfNoFrames:Boolean = XMLUtil.parseBoolean(xml, "@startIfNoFrames", false);
			super(world, startIfNoFrames, waitForCompletion);
			init(xml, refXML);
		}
		
		private function init(xml:XML, refXML:XML):void {
			var actualXML:XML = refXML || xml;
			if (!actualXML.hasComplexContent()) {
				throw ArgumentError("Wrong xml: " + actualXML.toXMLString());
			}
			_delay = XMLUtil.parseNumber(xml, "@delay");
			
			var enemiesList:XMLList = actualXML.Enemy;
			for each (var enemyXML:XML in enemiesList) {
				_enemyDefs.push(new EnemyDef(enemyXML));
			}
		}
		
		public override function update(hasActiveFrames:Boolean):void {
			_time += FP.elapsed;
			if (!_started) {
				if (_time >= _delay || (!hasActiveFrames && !waitForCompletion)) {
					_time = _delay;
					_started = true;
				}
			}else if (!_completed) {
				for (var i:int = _enemyDefs.length - 1; i >= 0; i--) {
					var def:EnemyDef = _enemyDefs[i];
					if ((_time - _delay) >= def.delay) {
						spawn(def.classType, def.options);
						_enemyDefs.splice(i, 1);
					}
				}
				if (_enemyCount == 0 && _enemyDefs.length == 0) {
					_completed = true;
					if (_spawnedEnemyCount > 0 && _killedEnemyCount >= _spawnedEnemyCount) {
						_world.addPowerup();
					}
				}
			}
		}
		
		public function spawn(classType:Class, options:Object = null):Enemy {
			var enemy:Enemy = _world.create(classType, false) as Enemy;
			enemy.wave = this;
			if (options) {
				for (var prop:String in options) {
					enemy[prop] = options[prop];
				}
			}
			_world.add(enemy);
			_enemyCount++;
			_spawnedEnemyCount++;
			return enemy;
		}
		
		public function decreaseEnemyCount():void {
			_enemyCount--;
		}
		
		public function increaseKilledEnemyCount():void {
			_killedEnemyCount++;
		}
		
	}

}

import candyking.game.enemies.WayPoint;
import candyking.utils.XMLUtil;
import flash.utils.getDefinitionByName;

internal class EnemyDef {
	
	public var classType:Class;
	public var delay:Number;
	public var options:Object;
	
	public function EnemyDef(xml:XML) {
		classType = getDefinitionByName(xml.@type) as Class;
		delay = XMLUtil.parseNumber(xml, "@delay");
		var attrs:XMLList = xml.@*;
		for each (var attr:XML in attrs) {
			var attrName:String = attr.name();
			if (attrName != "type" && attrName != "delay") {
				if (!options) {
					options = { };
				}
				options[attrName] = (attrName == "wayPoints") ? parseWayPoints(attr) : parseFloat(attr);
			}
		}
	}
	
	private static function parseWayPoints(source:String):Vector.<WayPoint> {
		var result:Vector.<WayPoint> = new Vector.<WayPoint>();
		var pointsData:Array = source.split(";");
		for (var i:int = 0, l:int = pointsData.length; i < l; i++) {
			var pointData:Array = pointsData[i].split(",");
			var x:Number = parseFloat(pointData[0]);
			var y:Number = parseFloat(pointData[1]);
			var delay:Number = pointData.length >= 3 ? parseFloat(pointData[2]) : 0;
			var ease:String = pointData.length >= 4 ? pointData[3] : null;
			result[result.length] = new WayPoint(x, y, delay, ease);
		}
		if (result.length < 2) {
			throw new ArgumentError("Wrong way points source: " + source);
		}
		return result;
	}
	
}
