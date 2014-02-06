package candyking.game.bosses {
	
	import candyking.game.ammo.EnemyBullet;
	import candyking.game.ammo.EnemyBulletLarge;
	import candyking.game.enemies.GummyBear;
	import candyking.game.GameWorld;
	import candyking.tweens.PendulumMotion;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.motion.CircularMotion;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	
	public class CandyKingBehaviour {
		
		public static const ATTACK_NONE:String = "none";
		public static const ATTACK_HOVERING:String = "hovering";
		public static const ATTACK_CHASING:String = "chasing";
		public static const ATTACK_RAGING:String = "raging";
		public static const ATTACK_CIRCLING:String = "circling";
		
		private static const RANDOM_ATTACKS:Vector.<String> = Vector.<String>([
			ATTACK_HOVERING,
			ATTACK_CHASING,
			ATTACK_CIRCLING
		]);
		
		public static const AMMO_OFFSET_X:Number = 17;
		public static const AMMO_OFFSET_Y:Number = 67;
		public static const SPEED_SLOW:int = 30;
		public static const SPEED_MEDIUM:int = 60;
		public static const SPEED_FAST:int = 70;
		public static const ENEMY_SPAWN_COOLDOWN_TIME:Number = 4;
		public static const HOVERING_SHOOT_COOLDOWN_TIME:Number = 0.35;
		public static const CHASING_SHOOT_COOLDOWN_TIME:Number = 1.4;
		public static const RAGING_SHOOT_COOLDOWN_TIME:Number = 0.02;
		public static const CIRCLING_SHOOT_COOLDOWN_TIME:Number = 0.4;
		
		private var _gameWorld:GameWorld;
		private var _entity:Boss;
		private var _attack:String = ATTACK_NONE;
		private var _attackTime:Number = 0;
		private var _attackShootCooldownTime:Number = 0;
		private var _enemySpawnCooldownTime:Number = ENEMY_SPAWN_COOLDOWN_TIME;
		private var _linearTween:LinearMotion = new LinearMotion();
		private var _pendulumTween:PendulumMotion = new PendulumMotion(null, Tween.LOOPING);
		private var _circularTween:CircularMotion = new CircularMotion(null, Tween.LOOPING);
		private var _mouthOpenTime:Number = 0;
		
		public function CandyKingBehaviour(gameWorld:GameWorld, entity:Boss) {
			_gameWorld = gameWorld;
			_entity = entity;
			_entity.collidable = false;
			init();
		}
		
		private function init():void {
			_entity.getGraphic("eyes_2").visible = false;
			_entity.getGraphic("eyes_3").visible = false;
			_entity.getGraphic("mouth_1").visible = false;
			_entity.getGraphic("mouth_2").visible = false;
			
			_linearTween.object = _entity;
			_entity.addTween(_linearTween);
			
			_pendulumTween.object = _entity;
			_entity.addTween(_pendulumTween);
			
			_circularTween.object = _entity;
			_entity.addTween(_circularTween);
			
			var spawnTween:LinearMotion = new LinearMotion(onSpawnTweenCompleted, Tween.ONESHOT);
			spawnTween.object = _entity;
			spawnTween.setMotion(450, 60, 300, 60, 3, Ease.sineOut);
			_entity.addTween(spawnTween);
		}
		
		private function onSpawnTweenCompleted():void {
			_entity.collidable = true;
			startAttack(ATTACK_HOVERING);
		}
		
		private function showMouthOpen():void {
			_entity.getGraphic("mouth_2").visible = true;
			_entity.getGraphic("mouth_3").visible = false;
			_mouthOpenTime = 0.5;
		}
		
		public function update():void {
			_attackTime += FP.elapsed;
			
			if (_mouthOpenTime > 0) {
				_mouthOpenTime -= FP.elapsed;
				if (_mouthOpenTime <= 0) {
					_entity.getGraphic("mouth_2").visible = false;
					_entity.getGraphic("mouth_3").visible = true;
				}
			}
			
			switch (_attack) {
				case ATTACK_HOVERING:
					updateAttackHovering();
					break;
				case ATTACK_CHASING:
					updateAttackChasing();
					break;
				case ATTACK_RAGING:
					updateAttackRaging();
					break;
				case ATTACK_CIRCLING:
					updateAttackCircling();
					break;
			}
			
			if (_attack != ATTACK_NONE) {
				_enemySpawnCooldownTime -= FP.elapsed;
				if (_enemySpawnCooldownTime <= 0) {
					_enemySpawnCooldownTime = ENEMY_SPAWN_COOLDOWN_TIME;
					_entity.wave.spawn(GummyBear);
				}
			}
			
		}
		
		private function updateAttackChasing():void {
			if (!_linearTween.active) {
				var player:Entity = _gameWorld.player;
				var toX:Number = player.x + player.width / 2 - _entity.width / 2;
				var toY:Number = player.y + player.height / 2 - _entity.height / 2;
				toX = Math.max(0, Math.min(toX, FP.width - _entity.width));
				toY = Math.max(0, Math.min(toY, FP.height - _entity.height));
				_linearTween.delay = 0.5;
				_linearTween.setMotionSpeed(_entity.x, _entity.y, toX, toY, SPEED_FAST, Ease.cubeInOut);
			}
			_attackShootCooldownTime -= FP.elapsed;
			if (_attackShootCooldownTime <= 0) {
				_attackShootCooldownTime = CHASING_SHOOT_COOLDOWN_TIME;
				const speed:Number = 2;
				for (var i:int = 0; i < 8; i++) {
					var angle:Number = 2 * Math.PI / 8 * i;
					var dx:Number = Math.cos(angle) * speed;
					var dy:Number = Math.sin(angle) * speed;
					_entity.shoot(EnemyBullet, AMMO_OFFSET_X, AMMO_OFFSET_Y, dx, dy);
				}
				showMouthOpen();
			}
			if (_attackTime >= 12) {
				_linearTween.delay = 0;
				_linearTween.active = false;
				startRandomAttack();
			}
		}
		
		private function updateAttackRaging():void {
			if (!_linearTween.active) {
				_entity.getGraphic("eyes_1").visible = false;
				_entity.getGraphic("eyes_2").visible = true;
				_entity.x = 300 + Math.random() * 4 - 2;
				_entity.y = 55 + Math.random() * 4 - 2;
				
				_attackShootCooldownTime -= FP.elapsed;
				if (_attackShootCooldownTime <= 0) {
					_attackShootCooldownTime = RAGING_SHOOT_COOLDOWN_TIME;
					const speed:Number = 1.5;
					var angle:Number = Math.random() * Math.PI * 2;
					var dx:Number = Math.cos(angle) * speed;
					var dy:Number = Math.sin(angle) * speed;
					_entity.shoot(EnemyBulletLarge, AMMO_OFFSET_X, AMMO_OFFSET_Y, dx, dy);
					showMouthOpen();
				}
			}
			if (_attackTime >= 10) {
				_entity.getGraphic("eyes_1").visible = true;
				_entity.getGraphic("eyes_2").visible = false;
				startRandomAttack();
			}
		}
		
		private function updateAttackHovering():void {
			if (!_linearTween.active && !_pendulumTween.active) {
				_pendulumTween.setMotionSpeed(300, 10, 300, 105, SPEED_MEDIUM, Ease.sineInOut);
			}
			if (_pendulumTween.active) {
				_attackShootCooldownTime -= FP.elapsed;
				if (_attackShootCooldownTime <= 0) {
					_attackShootCooldownTime = HOVERING_SHOOT_COOLDOWN_TIME;
					shootAtPlayer();
				}
			}
			if (_attackTime >= 12) {
				_pendulumTween.active = false;
				startRandomAttack();
			}
		}
		
		private function updateAttackCircling():void {
			if (!_linearTween.active && !_circularTween.active) {
				_circularTween.setMotion(200, 55, 60, 90, Math.random() < 0.5, 8);
			}
			if (_circularTween.active) {
				_attackShootCooldownTime -= FP.elapsed;
				if (_attackShootCooldownTime <= 0) {
					_attackShootCooldownTime = CIRCLING_SHOOT_COOLDOWN_TIME;
					shootAtPlayer();
				}
			}
			if (_attackTime >= 16) {
				_circularTween.active = false;
				startRandomAttack();
			}
		}
		
		private function shootAtPlayer():void {
			_entity.shootAtPlayer(EnemyBullet, AMMO_OFFSET_X, AMMO_OFFSET_Y, 2);
			showMouthOpen();
		}
		
		private function startRandomAttack():void {
			var rndAttack:String;
			while (true) {
				var rndIndex:int = Math.random() * randomAttacks.length;
				rndAttack = randomAttacks[rndIndex];
				if (_attack != rndAttack) {
					break;
				}
			}
			startAttack(rndAttack);
		}
		
		private function startAttack(attack:String):void {
			if (_attack == attack) {
				return;
			}
			
			switch (attack) {
				case ATTACK_HOVERING:
					_attackShootCooldownTime = HOVERING_SHOOT_COOLDOWN_TIME;
					_linearTween.setMotionSpeed(_entity.x, _entity.y, 300, 10, SPEED_FAST, Ease.sineInOut);
					break;
				case ATTACK_CHASING:
					_attackShootCooldownTime = CHASING_SHOOT_COOLDOWN_TIME;
					break;
				case ATTACK_RAGING:
					_attackShootCooldownTime = RAGING_SHOOT_COOLDOWN_TIME;
					_linearTween.setMotionSpeed(_entity.x, _entity.y, 300, 55, SPEED_FAST, Ease.sineInOut);
					break;
				case ATTACK_CIRCLING:
					_attackShootCooldownTime = CIRCLING_SHOOT_COOLDOWN_TIME;
					_linearTween.setMotionSpeed(_entity.x, _entity.y, 200, -5, SPEED_FAST, Ease.sineInOut);
					break;
				default:
					throw new ArgumentError("Wrong attack type: " + attack);
			}
			_attack = attack;
			_attackTime = 0;
		}
		
		protected function get randomAttacks():Vector.<String> {
			return RANDOM_ATTACKS;
		}
		
		public function die():void {
			_attack = ATTACK_NONE;
			_entity.getGraphic("eyes_1").visible = false;
			_entity.getGraphic("eyes_2").visible = false;
			_entity.getGraphic("eyes_3").visible = true;
			_linearTween.complete = _entity.remove;
			_linearTween.setMotionSpeed(_entity.x, _entity.y, 400, _entity.y, SPEED_SLOW, Ease.sineIn);
		}
		
	}

}
