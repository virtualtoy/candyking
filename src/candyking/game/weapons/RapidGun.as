package candyking.game.weapons {
	
	import candyking.game.ammo.PlayerBullet;
	
	public class RapidGun extends Weapon {
		
		public function RapidGun() {
			
		}
		
		override public function update():void {
			if ((_controller.beganPrimary || _controller.holdingPrimary) && _coolDownCount <= 0) {
				var ammo:PlayerBullet = _gameWorld.create(PlayerBullet) as PlayerBullet;
				ammo.dx = 3;
				ammo.dy = 0;
				ammo.x = _player.x + 28;
				ammo.y = _player.y + 16;
				_coolDownCount = 14;
			}
			_coolDownCount--;
		}
		
	}

}
