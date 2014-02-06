package candyking.game.enemies {
	
	import candyking.game.ammo.Ammo;
	import candyking.game.collisions.ColliderType;
	import candyking.game.EntityLayer;
	import candyking.game.GameEntity;
	import candyking.game.level.EnemyWave;
	import candyking.game.Ship;
	import candyking.utils.GameGlobals;
	import candyking.utils.SoundUtil;
	import flash.display.BitmapData;
	
	public class Enemy extends Ship {
		
		private var _wave:EnemyWave;
		private var _value:int;
		private var _collisionPixels:BitmapData;
		private var _collisionOffsetX:Number;
		private var _collisionOffsetY:Number;
		
		public function Enemy(initHealth:int, value:int, xmlAssetId:String = null, highlightName:String = null) {
			super(ColliderType.ENEMY, initHealth, xmlAssetId, highlightName);
			_value = value;
			layer = EntityLayer.ENEMY;
		}
		
		protected override function resetHealth():void {
			_health = Math.max(1, _initHealth * GameGlobals.enemyHealthMultiplier);
		}
		
		override public function update():void {
			if (active) {
				var colliding:Vector.<GameEntity> = _space.getColliding(this, ColliderType.PLAYER | ColliderType.PLAYER_AMMO);
				for each (var entity:GameEntity in colliding) {
					if (entity.colliderType & ColliderType.PLAYER_AMMO) {
						damage((entity as Ammo).damage);
						entity.remove();
						if (dead) {
							_gameWorld.addScore(_value);
							_wave.increaseKilledEnemyCount();
							return;
						}
					}else {
						(entity as Ship).damage(int.MAX_VALUE);
					}
				}
				syncSpace();
			}
			updateHighlight();
		}
		
		public function shoot(classType:Class, offsetX:Number, offsetY:Number, dx:Number, dy:Number):Ammo {
			SoundUtil.playShoot();
			var ammo:Ammo = _gameWorld.create(classType) as Ammo;
			ammo.x = x + offsetX;
			ammo.y = y + offsetY;
			ammo.dx = dx;
			ammo.dy = dy;
			return ammo;
		}
		
		public function shootAtPlayer(classType:Class, offsetX:Number, offsetY:Number, speed:Number):void {
			var player:Ship = _gameWorld.player;
			var tx:Number = player.x + player.height / 2 - (x + offsetX);
			var ty:Number = player.y + player.height / 2 - (y + offsetY);
			var angle:Number = Math.atan2(ty, tx);
			var dx:Number = Math.cos(angle) * speed;
			var dy:Number = Math.sin(angle) * speed;
			shoot(classType, offsetX, offsetY, dx, dy);
		}
		
		protected function enablePixelCollisions(pixels:BitmapData, offsetX:Number, offsetY:Number):void {
			_collisionPixels = pixels;
			_collisionOffsetX = offsetX;
			_collisionOffsetY = offsetY;
		}
		
		public override function collides(entity:GameEntity):Boolean {
			var collidesRect:Boolean = super.collides(entity);
			if (collidesRect && _collisionPixels) {
				return collidesPixels(entity, _collisionPixels, _collisionOffsetX, _collisionOffsetY);
			}
			return collidesRect;
		}
		
		public function get wave():EnemyWave {
			return _wave;
		}
		
		public function set wave(value:EnemyWave):void {
			_wave = value;
		}
		
		override protected function die():void {
			_gameWorld.addExplosionAtCenter(this);
			remove();
		}
		
		override public function remove():void {
			_wave.decreaseEnemyCount();
			super.remove();
		}
		
	}

}
