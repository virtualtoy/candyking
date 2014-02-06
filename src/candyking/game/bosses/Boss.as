package candyking.game.bosses {
	
	import candyking.game.collisions.ColliderType;
	import candyking.game.enemies.Enemy;
	import candyking.game.EntityLayer;
	
	public class Boss extends Enemy {
		
		public function Boss(initHealth:int, value:int, xmlAssetId:String = null, highlightName:String = null) {
			super(initHealth, value, xmlAssetId, highlightName);
			layer = EntityLayer.BOSS;
		}
		
		override public function get colliderType():int {
			return ColliderType.BOSS;
		}
		
	}

}
