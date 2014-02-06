package candyking.game.weapons {
	
	import candyking.game.ammo.PlayerGrenade;
	
	public class Grenade extends Weapon {
		
		public function Grenade() {
			
		}
		
		override public function update():void {
			if ((_controller.beganPrimary || _controller.holdingPrimary) && _coolDownCount <= 0) {
				var ammo:PlayerGrenade = _gameWorld.create(PlayerGrenade) as PlayerGrenade;
				ammo.x = _player.x + 24;
				ammo.y = _player.y + 14;
				_coolDownCount = 34;
			}
			_coolDownCount--;
		}
		
	}

}
