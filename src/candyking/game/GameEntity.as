package candyking.game {
	
	import candyking.assets.Assets;
	import candyking.game.collisions.ISpace;
	import candyking.utils.EntityUtil;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	
	public class GameEntity extends Entity {
		
		protected var _gameWorld:GameWorld;
		protected var _space:ISpace;
		
		private var _nameToGraphicDict:Dictionary = new Dictionary();
		private var _colliderType:int;
		private var _prevX:Number = 0;
		private var _prevY:Number = 0;
		
		public function GameEntity(colliderType:int, xmlAssetId:String = null) {
			_colliderType = colliderType;
			if (xmlAssetId) {
				EntityUtil.setup(Assets.getAsset(xmlAssetId), this, _nameToGraphicDict);
			}
		}
		
		public function getBounds(result:Rectangle):void {
			result.x = x;
			result.y = y;
			result.width = width;
			result.height = height;
		}
		
		public function collides(entity:GameEntity):Boolean {
			return 	x < entity.x + entity.width &&
					x + width > entity.x &&
					y < entity.y + entity.height &&
					y + height > entity.y;
		}
		
		public function collidesPixels(entity:GameEntity, pixels:BitmapData, offsetX:Number = 0, offsetY:Number = 0):Boolean {
			var rect:Rectangle = FP.rect;
			rect.x = entity.x;
			rect.y = entity.y;
			rect.width = entity.width;
			rect.height = entity.height;
			
			var point:Point = FP.point;
			point.x = x + offsetX;
			point.y = y + offsetY;
			
			return pixels.hitTest(FP.point, 1, FP.rect);
		}
		
		protected function syncSpace():void {
			_space.sync(this, x - _prevX, y - _prevY);
			_prevX = x;
			_prevY = y;
		}
		
		override public function added():void {
			active = true;
			_gameWorld = world as GameWorld;
			_space = _gameWorld.space;
			_space.add(this);
		}
		
		public function remove():void {
			active = false;
			_space.remove(this);
			_gameWorld.recycle(this);
		}
		
		public function get colliderType():int {
			return _colliderType;
		}
		
		public function getGraphic(name:String):Graphic {
			return _nameToGraphicDict[name];
		}
		
	}

}
