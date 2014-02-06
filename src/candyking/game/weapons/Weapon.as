package candyking.game.weapons {
	
	import candyking.game.GameWorld;
	import candyking.game.input.IController;
	import candyking.game.player.PlayerShip;
	
	public class Weapon {
		
		protected var _gameWorld:GameWorld;
		protected var _controller:IController;
		protected var _player:PlayerShip;
		protected var _coolDownCount:int = 0;
		
		public function Weapon() {
			
		}
		
		public function equip(gameWorld:GameWorld, player:PlayerShip):void {
			_gameWorld = gameWorld;
			_controller = _gameWorld.controller;
			_player = player;
			_coolDownCount = 0;
		}
		
		public function update():void {
			
		}
		
	}

}
