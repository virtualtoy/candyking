package candyking.game.player {
	
	import candyking.game.collisions.ColliderType;
	import candyking.game.EntityLayer;
	import candyking.game.GameEntity;
	import candyking.game.input.IController;
	import candyking.game.powerups.Powerup;
	import candyking.game.Ship;
	import candyking.game.weapons.Gun;
	import candyking.game.weapons.Nuke;
	import candyking.game.weapons.Weapon;
	import flash.utils.Dictionary;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	
	public class PlayerShip extends Ship {
		
		public static const INIT_HEALTH:int = 1;
		public static const SPEED:Number = 2;
		public static const INVINCIBILITY_DURATION:int = 120;
		
		private var _weaponTypeToWeaponDict:Dictionary = new Dictionary();
		
		private var _controllerEnabled:Boolean = true;
		private var _invincibilityCount:int = 0;
		private var _primaryWeapon:Weapon;
		private var _secondaryWeapon:Weapon;
		private var _primaryWeaponType:Class;
		private var _spawnTween:LinearMotion;
		private var _vx:Number = 0;
		private var _vy:Number = 0;
		
		public function PlayerShip() {
			super(ColliderType.PLAYER, INIT_HEALTH, "entities/player_ship.xml");
			layer = EntityLayer.PLAYER;
			_spawnTween = new LinearMotion(onSpawnTweenCompleted);
			_spawnTween.object = this;
			addTween(_spawnTween);
			y = 100;
		}
		
		private function onSpawnTweenCompleted():void {
			_controllerEnabled = true;
		}
		
		override public function added():void {
			super.added();
			primaryWeaponType = Gun;
			_secondaryWeapon = new Nuke();
			_secondaryWeapon.equip(_gameWorld, this);
			spawn();
		}
		
		public function get primaryWeaponType():Class {
			return _primaryWeaponType;
		}
		
		public function set primaryWeaponType(value:Class):void {
			if (!_primaryWeaponType || _primaryWeaponType != value) {
				_primaryWeaponType = value;
				var weapon:Weapon = _weaponTypeToWeaponDict[value];
				if (!weapon) {
					weapon =
					_weaponTypeToWeaponDict[value] = new value();
				}
				_primaryWeapon = weapon;
				_primaryWeapon.equip(_gameWorld, this);
			}
		}
		
		override public function update():void {
			if (dead) {
				return;
			}
			
			if (_controllerEnabled) {
				var controller:IController = _gameWorld.controller;
				
				var dx:Number = controller.steeringLeft ? -SPEED : controller.steeringRight ? SPEED : 0;
				var dy:Number = controller.steeringUp ? -SPEED : controller.steeringDown ? SPEED : 0;
				x += dx;
				y += dy;
				
				_vx = dx > 0 ? 1 : dx < 0 ? -1 : _vx * 0.9;
				_vy = dy > 0 ? 1 : dy < 0 ? -1 : _vy * 0.9;
				
				if (dx == 0) {
					x += _vx;
				}
				if (dy == 0) {
					y += _vy;
				}
				
				if (x < 0) {
					x = 0;
				}else if (x > FP.width - width) {
					x = FP.width - width;
				}
				
				if (y < 0) {
					y = 0;
				}else if (y > FP.height - height) {
					y = FP.height - height;
				}
				
				_primaryWeapon.update();
				_secondaryWeapon.update();
			}
			
			if (_invincibilityCount > 0) {
				_invincibilityCount--;
				if (_invincibilityCount == 0) {
					visible = true;
				}else {
					visible = (_invincibilityCount % 10) < 5;
				}
			}
			
			var colliding:Vector.<GameEntity> = _space.getColliding(this, ColliderType.ENEMY_AMMO | ColliderType.POWERUP);
			for each (var entity:GameEntity in colliding) {
				if (_invincibilityCount <= 0 && entity.colliderType & ColliderType.ENEMY_AMMO) {
					damage(int.MAX_VALUE);
					entity.remove();
					break;
				}else if (entity.colliderType & ColliderType.POWERUP) {
					(entity as Powerup).pickUp();
				}
			}
			
			syncSpace();
		}
		
		public function spawn():void {
			resetHealth();
			_invincibilityCount = INVINCIBILITY_DURATION;
			_controllerEnabled = false;
			_spawnTween.setMotion( -40, y, 30, y, 0.5, Ease.quadOut);
		}
		
		override public function damage(value:int):void {
			if (_invincibilityCount <= 0) {
				super.damage(value);
			}
		}
		
		override protected function die():void {
			_gameWorld.addExplosionAtCenter(this);
			primaryWeaponType = Gun;
			
			_gameWorld.lives--;
			if (_gameWorld.lives > 0) {
				spawn();
			}else {
				visible = false;
				_gameWorld.gameOver();
			}
		}
		
		public function get controllerEnabled():Boolean {
			return _controllerEnabled;
		}
		
		public function set controllerEnabled(value:Boolean):void {
			_controllerEnabled = value;
		}
		
	}

}
