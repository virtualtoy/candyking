package candyking.game.enemies {
	
	import candyking.game.ammo.EnemyBullet;
	import net.flashpunk.FP;
	
	public class ShootingEnemy extends Enemy {
		
		public var shootCooldown:Number;
		
		private var _shootCooldownTime:Number;
		
		public function ShootingEnemy(initHealth:int, value:int, xmlAssetId:String = null, highlightName:String = null) {
			super(initHealth, value, xmlAssetId, highlightName);
		}
		
		public override function added():void {
			super.added();
			_shootCooldownTime = -1;
		}
		
		public override function update():void {
			if (shootCooldown > 0) {
				if (_shootCooldownTime == -1) {
					_shootCooldownTime = shootCooldown;
				}else if (_shootCooldownTime >= 0) {
					_shootCooldownTime -= FP.elapsed;
					if (_shootCooldownTime <= 0) {
						_shootCooldownTime = shootCooldown;
						performShoot();
					}
				}
			}
			super.update();
		}
		
		protected function performShoot():void {
			shootAtPlayer(EnemyBullet, 0, 0, 2);
		}
		
		public override function remove():void {
			shootCooldown = 0;
			super.remove();
		}
		
	}

}
