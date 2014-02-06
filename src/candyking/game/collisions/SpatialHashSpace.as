package candyking.game.collisions {
	
	import candyking.game.GameEntity;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	
	// http://www.playchilla.com/as3-spatial-hash
	public class SpatialHashSpace implements ISpace {
		
		private static const _tempRect:Rectangle = new Rectangle();
		private static const _tempColliding:Vector.<GameEntity> = new Vector.<GameEntity>();
		
		private var _hash:Dictionary = new Dictionary();
		private var _gridSize:Number;
		
		public function SpatialHashSpace(gridSize:Number) {
			_gridSize = gridSize;
		}
		
		public function add(entity:GameEntity):void {
			entity.getBounds(_tempRect);
			
			var xMin:int = _tempRect.x / _gridSize;
			var xMax:int = _tempRect.right / _gridSize;
			var yMin:int = _tempRect.y / _gridSize;
			var yMax:int = _tempRect.bottom / _gridSize;
			
			for (var x:int = xMin; x <= xMax; x++) {
				for (var y:int = yMin; y <= yMax; y++) {
					addToBucket(entity, x, y);
				}
			}
		}
		
		public function remove(entity:GameEntity):void {
			entity.getBounds(_tempRect);
			
			var xMin:int = _tempRect.x / _gridSize;
			var xMax:int = _tempRect.right / _gridSize;
			var yMin:int = _tempRect.y / _gridSize;
			var yMax:int = _tempRect.bottom / _gridSize;
			
			for (var x:int = xMin; x <= xMax; x++) {
				for (var y:int = yMin; y <= yMax; y++) {
					removeFromBucket(entity, x, y);
				}
			}
		}
		
		public function sync(entity:GameEntity, dx:Number, dy:Number):void {
			
			entity.getBounds(_tempRect);
			
			var xMin:int = _tempRect.x / _gridSize;
			var xMax:int = _tempRect.right / _gridSize;
			var yMin:int = _tempRect.y / _gridSize;
			var yMax:int = _tempRect.bottom / _gridSize;
			
			var xMinPrev:int = (_tempRect.x - dx) / _gridSize;
			var xMaxPrev:int = (_tempRect.right - dx) / _gridSize;
			var yMinPrev:int = (_tempRect.y - dy) / _gridSize;
			var yMaxPrev:int = (_tempRect.bottom - dy) / _gridSize;
			
			if (xMin != xMinPrev || xMax != xMaxPrev || yMin != yMinPrev || yMax != yMaxPrev) {
				for (var x:int = xMinPrev; x <= xMaxPrev; x++) {
					for (var y:int = yMinPrev; y <= yMaxPrev; y++) {
						removeFromBucket(entity, x, y);
					}
				}
				for (x = xMin; x <= xMax; x++) {
					for (y = yMin; y <= yMax; y++) {
						addToBucket(entity, x, y);
					}
				}
			}
			
		}
		
		private function addToBucket(entity:GameEntity, x:int, y:int):void {
			var key:uint = (x * 1640531513 ^ y * 2654435789) % 257; // inlining for better performance
			var bucket:Dictionary = _hash[key];
			if (!bucket) {
				bucket =
				_hash[key] = new Dictionary();
			}
			bucket[entity] = true;
		}
		
		private function removeFromBucket(entity:GameEntity, x:int, y:int):void {
			var key:uint = (x * 1640531513 ^ y * 2654435789) % 257; // inlining for better performance
			var bucket:Dictionary = _hash[key];
			if (bucket && entity in bucket) {
				delete bucket[entity];
			}
		}
		
		public function getColliding(entity:GameEntity, colliderType:int):Vector.<GameEntity> {
			
			_tempColliding.length = 0;
			if (!entity.collidable) {
				return _tempColliding;
			}
			
			entity.getBounds(_tempRect);
			
			var xMin:int = _tempRect.x / _gridSize;
			var xMax:int = _tempRect.right / _gridSize;
			var yMin:int = _tempRect.y / _gridSize;
			var yMax:int = _tempRect.bottom / _gridSize;
			
			for (var x:int = xMin; x <= xMax; x++) {
				for (var y:int = yMin; y <= yMax; y++) {
					var key:uint = (x * 1640531513 ^ y * 2654435789) % 257; // inlining for better performance
					var bucket:Dictionary = _hash[key];
					if (bucket)	{
						for (var o:* in bucket) {
							var e:GameEntity = o;
							if (e.active &&
								e.collidable &&
								e.colliderType & colliderType &&
								entity.collides(e)) {
								
								_tempColliding[_tempColliding.length] = e;
							}
						}
					}
				}
			}
			
			return _tempColliding;
		}
		
   		public static function getKey(x:int, y:int):uint {
  			return (x * 1640531513 ^ y * 2654435789) % 257;
   		}
		
	}

}
