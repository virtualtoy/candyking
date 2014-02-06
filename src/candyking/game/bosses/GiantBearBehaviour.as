package candyking.game.bosses {
	
	import candyking.game.ammo.EnemyBulletLarge;
	import candyking.game.ammo.PeppermintBomb;
	import candyking.game.enemies.GummyBear;
	import candyking.game.GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	
	public class GiantBearBehaviour {
		
		public static const ATTACK_NONE:String = "none";
		public static const ATTACK_WANDERING:String = "wandering";
		public static const ATTACK_STOMPING:String = "stomping";
		public static const ATTACK_BOMBING:String = "bombing";
		public static const ATTACK_SPAWNING:String = "spawning";
		
		public static const AMMO_OFFSET_X:Number = 26;
		public static const AMMO_OFFSET_Y:Number = 20;
		public static const SPEED_SLOW:int = 30;
		public static const SPEED_MEDIUM:int = 130;
		public static const SPEED_FAST:int = 180;
		public static const MAX_Y:Number = 97;
		public static const WANDERING_SHOOT_COOLDOWN_TIME:Number = 0.5;
		public static const BOMBING_SHOOT_COOLDOWN_TIME:Number = 0.13;
		
		private static const RANDOM_ATTACKS:Vector.<String> = Vector.<String>([
			ATTACK_WANDERING,
			ATTACK_STOMPING,
			ATTACK_BOMBING,
			ATTACK_SPAWNING
		]);
		
		private var _gameWorld:GameWorld;
		private var _entity:GiantBear;
		private var _attack:String = ATTACK_NONE;
		private var _attackTime:Number = 0;
		private var _attackShootCooldownTime:Number = 0;
		private var _dx:Number;
		private var _dy:Number;
		private var _linearTween:LinearMotion = new LinearMotion();
		private var _stompingGoingUp:Boolean;
		
		public function GiantBearBehaviour(gameWorld:GameWorld, entity:GiantBear) {
			_gameWorld = gameWorld;
			_entity = entity;
			_entity.collidable = false;
			init();
		}
		
		private function init():void {
			_entity.getGraphic("eyes_2").visible = false;
			_entity.getGraphic("eyes_3").visible = false;
			
			_linearTween.object = _entity;
			_entity.addTween(_linearTween);
			
			var spawnTween:LinearMotion = new LinearMotion(onSpawnTweenCompleted, Tween.ONESHOT);
			spawnTween.object = _entity;
			spawnTween.setMotion(300, -_entity.height, 300, MAX_Y, 3, Ease.bounceOut);
			_entity.addTween(spawnTween);
		}
		
		private function onSpawnTweenCompleted():void {
			_entity.collidable = true;
			startAttack(ATTACK_SPAWNING);
		}
		
		public function update():void {
			_attackTime += FP.elapsed;
			
			switch (_attack) {
				case ATTACK_WANDERING:
					updateAttackWandering();
					break;
				case ATTACK_STOMPING:
					updateAttackStomping();
					break;
				case ATTACK_BOMBING:
					updateAttackBombing();
					break;
				case ATTACK_SPAWNING:
					updateAttackSpawning();
					break;
			}
		}
		
		private function updateWandering():void {
			_entity.x += _dx;
			_entity.y += _dy;
			_dy += 0.04;
			if (_entity.x < 0) {
				_entity.x = 0;
				_dx = -_dx;
			}else if (_entity.x > FP.width - _entity.width) {
				_entity.x = FP.width - _entity.width;
				_dx = -_dx;
			}
			if (_entity.y > MAX_Y) {
				_entity.y = MAX_Y;
				_dx = Math.random() * 4 - 2;
				_dy = -(Math.random() * 0.5 + 2.2);
			}
		}
		
		private function updateAttackWandering():void {
			updateWandering();
			_attackShootCooldownTime -= FP.elapsed;
			if (_attackShootCooldownTime <= 0) {
				_attackShootCooldownTime = WANDERING_SHOOT_COOLDOWN_TIME;
				_entity.shootAtPlayer(EnemyBulletLarge, AMMO_OFFSET_X, AMMO_OFFSET_Y, 2);
			}
			if (_attackTime >= 12 && _entity.y == MAX_Y) {
				startRandomAttack();
			}
		}
		
		private function updateAttackStomping():void {
			if (!_linearTween.active) {
				if (_stompingGoingUp) {
					if (_attackTime >= 12) {
						_linearTween.active = false;
						startRandomAttack();
					}else {
						_linearTween.delay = 0.5;
						_linearTween.setMotionSpeed(_entity.x, _entity.y, _entity.x, -_entity.height, SPEED_FAST, Ease.quadIn);
					}
				}else {
					var player:Entity = _gameWorld.player;
					var toX:Number = player.x - (_entity.width - player.width) / 2;
					if (toX < 0) {
						toX = 0;
					}else if (toX > FP.width - _entity.width) {
						toX = FP.width - _entity.width;
					}
					_linearTween.delay = 0.5;
					_linearTween.setMotionSpeed(toX, _entity.y, toX, MAX_Y, SPEED_MEDIUM, Ease.bounceOut);
				}
				_stompingGoingUp = !_stompingGoingUp;
			}
		}
		
		private function updateAttackBombing():void {
			if (!_linearTween.active) {
				_attackShootCooldownTime -= FP.elapsed;
				if (_attackShootCooldownTime <= 0) {
					_attackShootCooldownTime = BOMBING_SHOOT_COOLDOWN_TIME;
					var ammo:PeppermintBomb = _gameWorld.create(PeppermintBomb) as PeppermintBomb;
					ammo.x = Math.random() * (FP.width - ammo.width);
					ammo.y = -ammo.height;
					ammo.dx = 0;
					ammo.dy = 0;
				}
				if (_attackTime >= 10) {
					_linearTween.delay = 1;
					_linearTween.complete = onBombingTweenCompleted;
					_linearTween.setMotion(_entity.x, _entity.y, _entity.x, MAX_Y, 3, Ease.bounceOut);
				}
			}
		}
		
		private function onBombingTweenCompleted():void {
			_linearTween.delay = 0;
			_linearTween.complete = null;
			startRandomAttack();
		}
		
		private function updateAttackSpawning():void {
			updateWandering();
			if (_entity.y == MAX_Y) {
				if (_attackTime >= 12) {
					startRandomAttack();
				}else {
					for (var i:int = 0; i < 7; i++) {
						_entity.wave.spawn(GummyBear);
					}
				}
			}
		}
		
		private function startRandomAttack():void {
			var rndAttack:String;
			while (true) {
				var rndIndex:int = Math.random() * RANDOM_ATTACKS.length;
				rndAttack = RANDOM_ATTACKS[rndIndex];
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
				case ATTACK_WANDERING:
				case ATTACK_SPAWNING:
					_attackShootCooldownTime = WANDERING_SHOOT_COOLDOWN_TIME;
					_dx = Math.random() * 2 - 1;
					_dy = -(Math.random() * 0.5 + 2.2);
					break;
				case ATTACK_STOMPING:
					_stompingGoingUp = true;
					break;
				case ATTACK_BOMBING:
					_attackShootCooldownTime = BOMBING_SHOOT_COOLDOWN_TIME;
					_linearTween.delay = 0.5;
					_linearTween.setMotionSpeed(_entity.x, _entity.y, _entity.x, -_entity.height - 10, SPEED_FAST, Ease.quadIn);
					break;
				default:
					throw new ArgumentError("Wrong attack type: " + attack);
			}
			_attack = attack;
			_attackTime = 0;
		}
		
		public function die():void {
			_attack = ATTACK_NONE;
			_entity.getGraphic("eyes_1").visible = false;
			_entity.getGraphic("eyes_2").visible = false;
			_entity.getGraphic("eyes_3").visible = true;
			_linearTween.delay = 0;
			_linearTween.complete = _entity.remove;
			_linearTween.setMotionSpeed(_entity.x, _entity.y, 400, _entity.y, SPEED_SLOW, Ease.sineIn);
		}
		
	}

}
