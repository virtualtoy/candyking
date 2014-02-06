package candyking.game.weapons {
	
	import candyking.game.ammo.PlayerBullet;
	
	public class FiveWayGun extends Weapon {
		
		public function FiveWayGun() {
			
		}
		
		override public function update():void {
			if ((_controller.beganPrimary || _controller.holdingPrimary) && _coolDownCount <= 0) {
				for (var i:int = -2; i <= 2; i++) {
					var ammo:PlayerBullet = _gameWorld.create(PlayerBullet) as PlayerBullet;
					ammo.dx = 1.5;
					ammo.dy = i * 1;
					ammo.x = _player.x + 28 - Math.abs(i) * 2;
					ammo.y = _player.y + 16 + i;
				}
				_coolDownCount = 36;
			}
			_coolDownCount--;
		}
		
	}

}
