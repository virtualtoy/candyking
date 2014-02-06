package candyking.game {
	
	import candyking.assets.Assets;
	import candyking.game.collisions.ColliderType;
	import candyking.game.collisions.ISpace;
	import candyking.game.collisions.SpatialHashSpace;
	import candyking.game.effects.Explosion;
	import candyking.game.input.IController;
	import candyking.game.input.KeyboardController;
	import candyking.game.level.Timeline;
	import candyking.game.player.PlayerShip;
	import candyking.game.powerups.FiveWayGunPowerup;
	import candyking.game.powerups.GrenadePowerup;
	import candyking.game.powerups.LifePowerup;
	import candyking.game.powerups.NukePowerup;
	import candyking.game.powerups.RapidGunPowerup;
	import candyking.game.powerups.ThreeWayGunPowerup;
	import candyking.game.SideScrollerBackground;
	import candyking.game.ui.HUD;
	import candyking.game.weapons.FiveWayGun;
	import candyking.game.weapons.Grenade;
	import candyking.game.weapons.RapidGun;
	import candyking.game.weapons.ThreeWayGun;
	import candyking.Main;
	import candyking.utils.GameGlobals;
	import candyking.utils.SoundUtil;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class GameWorld extends World {
		
		private static const POWERUP_TYPES:Vector.<Class> = Vector.<Class>([
			FiveWayGunPowerup,
			GrenadePowerup,
			LifePowerup,
			NukePowerup,
			RapidGunPowerup,
			ThreeWayGunPowerup,
		]);
		
		private var _tempList:Vector.<Entity> = new Vector.<Entity>();
		private var _powerupTypes:Vector.<Class> = new Vector.<Class>();
		private var _background:SideScrollerBackground;
		private var _controller:IController = new KeyboardController();
		private var _levelCompleted:Boolean = false;
		private var _player:PlayerShip;
		private var _timeline:Timeline;
		private var _space:ISpace;
		private var _hud:HUD;
		private var _gameOver:Boolean = false;
		
		public function GameWorld() {
			super();
		}
		
		override public function begin():void {
			
			SoundUtil.playMusic();
			
			var levelXML:XML;
			switch (GameGlobals.level) {
				case 0:
					levelXML = Assets.getAsset("levels/level_1.xml");
					break;
				case 1:
					levelXML = Assets.getAsset("levels/level_2.xml");
					break;
				case 2:
					levelXML = Assets.getAsset("levels/level_3.xml");
					break;
			}
			
			_space = new SpatialHashSpace(40);
			
			_hud = new HUD();
			_hud.score = GameGlobals.score;
			_hud.lives = GameGlobals.lives;
			_hud.specialWeaponAmount = GameGlobals.specialWeaponAmount;
			add(_hud);
			
			_timeline = new Timeline(levelXML);
			add(_timeline);
			
			_background = new SideScrollerBackground(levelXML.Background[0]);
			_background.layer = EntityLayer.BACKGROUND;
			add(_background);
			
			_player = new PlayerShip();
			add(_player);
			
		}
		
		public function addPowerup():void {
			
			if (Math.random() < GameGlobals.powerupSpawnProbability) {
				var powerupType:Class;
				while (true) {
					if (!_powerupTypes.length) {
						_powerupTypes = POWERUP_TYPES.slice();
						FP.shuffle(_powerupTypes);
					}
					
					powerupType = _powerupTypes.pop();
					
					if (powerupType == LifePowerup && GameGlobals.lives < GameGlobals.MAX_LIVES) {
						break;
					}else if (powerupType == NukePowerup && GameGlobals.specialWeaponAmount < GameGlobals.MAX_SPECIAL_WEAPON_AMOUNT) {
						break;
					}else if (powerupType == FiveWayGunPowerup && _player.primaryWeaponType != FiveWayGun) {
						break;
					}else if (powerupType == GrenadePowerup && _player.primaryWeaponType != Grenade) {
						break;
					}else if (powerupType == RapidGunPowerup && _player.primaryWeaponType != RapidGun) {
						break;
					}else if (powerupType == ThreeWayGunPowerup && _player.primaryWeaponType != ThreeWayGun) {
						break;
					}
				}
			}
			
			create(powerupType);
		}
		
		public function addExplosion(x:Number, y:Number):void {
			var explosion:Entity = create(Explosion);
			explosion.x = x;
			explosion.y = y;
		}
		
		public function addExplosionAtCenter(entity:Entity):void {
			var explosion:Entity = create(Explosion);
			explosion.x = entity.x + entity.width / 2;
			explosion.y = entity.y + entity.height / 2;
		}
		
		public function addExplosionWithinBounds(entity:Entity):void {
			var explosion:Entity = create(Explosion);
			explosion.x = entity.x + Math.random() * entity.width;
			explosion.y = entity.y + Math.random() * entity.height;
		}
		
		public function get lives():int {
			return GameGlobals.lives;
		}
		
		public function set lives(value:int):void {
			if (value > GameGlobals.MAX_LIVES) {
				value = GameGlobals.MAX_LIVES;
			}
			GameGlobals.lives = 
			_hud.lives = value;
		}
		
		public function addScore(value:int):void {
			GameGlobals.score += value * GameGlobals.scoreMultiplier;
			_hud.score = GameGlobals.score;
		}
		
		public function get specialWeaponAmount():int {
			return GameGlobals.specialWeaponAmount;
		}
		
		public function set specialWeaponAmount(value:int):void {
			if (value > GameGlobals.MAX_SPECIAL_WEAPON_AMOUNT) {
				value = GameGlobals.MAX_SPECIAL_WEAPON_AMOUNT;
			}
			GameGlobals.specialWeaponAmount = 
			_hud.specialWeaponAmount = value;
		}
		
		public function useSpecialWeapon():void {
			specialWeaponAmount--;
			_tempList.length = 0;
			getAll(_tempList);
			SoundUtil.playLargeExplosion();
			for each (var entity:Entity in _tempList) {
				var gameEntity:GameEntity = entity as GameEntity;
				if (gameEntity && (gameEntity.colliderType & ColliderType.ENEMY)) {
					addExplosionAtCenter(gameEntity);
					gameEntity.remove();
				}
			}
		}
		
		public function removeEnemiesAndAmmos():void {
			_tempList.length = 0;
			getAll(_tempList);
			for each (var entity:Entity in _tempList) {
				var gameEntity:GameEntity = entity as GameEntity;
				if (gameEntity) {
					var colliderType:int = gameEntity.colliderType;
					if (colliderType & ColliderType.ENEMY) {
						addExplosionAtCenter(gameEntity);
						gameEntity.remove();
					}else if (colliderType & ColliderType.ENEMY_AMMO) {
						gameEntity.remove();
					}
				}
			}
		}
		
		public function gameOver():void {
			GameGlobals.finishGame();
			SoundUtil.stopMusic();
			_timeline.active = false;
			_gameOver = true;
			_hud.showGameOver();
		}
		
		override public function update():void {
			super.update();
			_background.offset -= 2;
			if (!_gameOver && !_levelCompleted && _timeline.completed) {
				_levelCompleted = true;
				_player.controllerEnabled = false;
				if (GameGlobals.level == GameGlobals.MAX_LEVEL) {
					GameGlobals.finishGame();
					SoundUtil.stopMusic();
					Main.openOutro(_player.centerX, _player.centerY);
				}else {
					GameGlobals.level++;
					Main.openGame();
				}
			}
		}
		
		public function get controller():IController {
			return _controller;
		}
		
		public function get space():ISpace {
			return _space;
		}
		
		public function get player():PlayerShip {
			return _player;
		}
		
	}

}
