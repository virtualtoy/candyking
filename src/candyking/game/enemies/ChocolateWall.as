package candyking.game.enemies {
	
	import candyking.assets.Assets;
	import candyking.game.ammo.Ammo;
	import candyking.game.collisions.ColliderType;
	import candyking.game.GameEntity;
	import candyking.game.Ship;
	import candyking.utils.GameGlobals;
	import candyking.utils.SoundUtil;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.tweens.motion.LinearMotion;
	
	public class ChocolateWall extends Enemy {
		
		public static const INIT_BLOCK_HEALTH:int = 5;
		public static const BLOCK_VALUE:int = 10;
		
		public static const BLOCKS_WIDTH:int = 2;
		public static const BLOCKS_HEIGHT:int = 7;
		public static const SPEED:Number = 40;
		
		private var _blocks:Vector.<Stamp> = new Vector.<Stamp>();
		private var _blocksHealth:Vector.<int> = new Vector.<int>();
		private var _tween:LinearMotion = new LinearMotion();
		private var _blocksLeft:int;
		
		public function ChocolateWall() {
			super(0, 0);
			init();
		}
		
		private function init():void {
			_tween.object = this;
			addTween(_tween);
			
			var texture:BitmapData = Assets.getAsset("images/enemy_chocolate.png");
			var blockWidth:int = texture.width;
			var blockHeight:int = texture.height;
			for (var i:int = 0; i < BLOCKS_WIDTH; i++) {
				for (var j:int = 0; j < BLOCKS_HEIGHT; j++) {
					var block:Stamp = new Stamp(texture, i * blockWidth, j * blockHeight);
					addGraphic(block);
					_blocks.push(block);
					_blocksHealth.push(INIT_BLOCK_HEALTH);
				}
			}
			width = blockWidth * BLOCKS_WIDTH;
			height = blockHeight * BLOCKS_HEIGHT;
		}
		
		public override function added():void {
			super.added();
			var blockHealth:int = Math.max(1, INIT_BLOCK_HEALTH * GameGlobals.enemyHealthMultiplier);
			for (var i:int = 0, l:int = _blocks.length; i < l; i++) {
				_blocks[i].visible = true;
				_blocksHealth[i] = blockHealth;
			}
			_blocksLeft = _blocks.length;
			
			_tween.complete = remove;
			_tween.setMotionSpeed(FP.width, 4, -width, 4, SPEED);
		}
		
		public override function update():void {
			var colliding:Vector.<GameEntity> = _space.getColliding(this, ColliderType.PLAYER | ColliderType.PLAYER_AMMO);
			for each (var entity:GameEntity in colliding) {
				for (var i:int = 0, l:int = _blocks.length; i < l; i++) {
					if (_blocksHealth[i] > 0) {
						var block:Stamp = _blocks[i];
						var blockCollides:Boolean =
							(x + block.x) < entity.x + entity.width &&
							(x + block.x + block.width) > entity.x &&
							(y + block.y) < entity.y + entity.height &&
							(y + block.y + block.height) > entity.y;
						if (blockCollides) {
							if (entity.colliderType & ColliderType.PLAYER_AMMO) {
								_blocksHealth[i] -= (entity as Ammo).damage;
								if (_blocksHealth[i] <= 0) {
									block.visible = false;
									_gameWorld.addScore(BLOCK_VALUE);
									_gameWorld.addExplosion(x + block.x + block.width / 2, y + block.y + block.width / 2);
									SoundUtil.playExplosion();
									if (--_blocksLeft == 0) {
										wave.increaseKilledEnemyCount();
										remove();
										return;
									}
								}else {
									SoundUtil.playHit();
								}
								entity.remove();
								break;
							}else {
								(entity as Ship).damage(int.MAX_VALUE);
								break;
							}
						}
					}
				}
			}
			syncSpace();
		}
		
		public override function remove():void {
			_tween.active = false;
			super.remove();
		}
		
	}

}
