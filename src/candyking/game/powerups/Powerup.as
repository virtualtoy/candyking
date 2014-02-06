package candyking.game.powerups {
	
	import candyking.game.collisions.ColliderType;
	import candyking.game.EntityLayer;
	import candyking.game.GameEntity;
	import candyking.tweens.PendulumMotion;
	import candyking.utils.SoundUtil;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	
	public class Powerup extends GameEntity {
		
		public static const SPEED:Number = -1;
		
		private var _tween:PendulumMotion = new PendulumMotion(null, Tween.LOOPING);
		
		public function Powerup(xmlAssetId:String = null) {
			super(ColliderType.POWERUP, xmlAssetId);
			layer = EntityLayer.POWERUP;
			_tween.object = this;
			addTween(_tween);
		}
		
		public override function added():void {
			super.added();
			y = 10 + Math.random() * (FP.height - height - 30);
			_tween.setMotion(0, y, 0, y + 20, 0.85, Ease.sineInOut, PendulumMotion.Y_AXIS);
			x = FP.width;
		}
		
		public override function update():void {
			x += SPEED;
			if (x < -width) {
				remove();
			}else {
				syncSpace();
			}
		}
		
		public function pickUp():void {
			if (active) {
				SoundUtil.playPowerup();
				onPickedUp();
				remove();
			}
		}
		
		protected function onPickedUp():void {
			
		}
		
	}

}
