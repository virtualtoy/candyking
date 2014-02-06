package candyking.game.ammo {
	
	import candyking.game.ammo.Ammo;
	import candyking.game.collisions.ColliderType;
	import candyking.utils.SoundUtil;
	import net.flashpunk.FP;
	
	public class PeppermintBomb extends Ammo {
		
		public function PeppermintBomb() {
			super(ColliderType.ENEMY_AMMO, int.MAX_VALUE, "entities/enemy_peppermint_bomb.xml");
		}
		
		override public function update():void {
			x += dx;
			y += dy;
			
			dy += 0.08;
			if (dy > 5) {
				dy = 5;
			}
			
			if (x < -width || x > FP.width || y >= FP.height - height) {
				remove();
			}else {
				syncSpace();
			}
			
		}
		
		public override function remove():void {
			for (var i:int = 0; i < 3; i++) {
				_gameWorld.addExplosionWithinBounds(this);
			}
			SoundUtil.playExplosion();
			super.remove();
		}
		
	}

}
