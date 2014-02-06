package candyking.game.ammo {
	
	import candyking.game.EntityLayer;
	import candyking.game.GameEntity;
	import net.flashpunk.FP;
	
	public class Ammo extends GameEntity {
		
		private var _damage:int;
		
		public var dx:Number = 0;
		public var dy:Number = 0;
		
		public function Ammo(colliderType:int, damage:int, xmlAssetId:String = null) {
			super(colliderType, xmlAssetId);
			_damage = damage;
			layer = EntityLayer.AMMO;
		}
		
		override public function update():void {
			if (active) {
				if (x < -width || x > FP.width || y < -height || y > FP.height) {
					remove();
				}else {
					syncSpace();
				}
			}
		}
		
		public function get damage():int {
			return _damage;
		}
		
	}

}
