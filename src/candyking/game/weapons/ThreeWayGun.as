package candyking.game.weapons {
	
	import candyking.game.ammo.PlayerBullet;
	
	public class ThreeWayGun extends Weapon {
		
		public function ThreeWayGun() {
			
		}
		
		override public function update():void {
			if ((_controller.beganPrimary || _controller.holdingPrimary) && _coolDownCount <= 0) {
				for (var i:int = -1; i <= 1; i++) {
					var ammo:PlayerBullet = _gameWorld.create(PlayerBullet) as PlayerBullet;
					ammo.dx = 2.5;
					ammo.dy = i * 1;
					ammo.x = _player.x + 28 - (i == 0 ? 0 : 2) ;
					ammo.y = _player.y + 16 + i;
				}
				_coolDownCount = 26;
			}
			_coolDownCount--;
		}
		
	}

}
