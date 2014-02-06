package candyking.game.collisions {
	
	import candyking.game.GameEntity;
	
	public interface ISpace {
		
		function add(entity:GameEntity):void;
		
		function remove(entity:GameEntity):void;
		
		function sync(entity:GameEntity, dx:Number, dy:Number):void;
		
		function getColliding(entity:GameEntity, colliderType:int):Vector.<GameEntity>;
		
	}
	
}
