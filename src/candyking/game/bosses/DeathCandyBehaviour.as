package candyking.game.bosses {
	
	import candyking.game.ammo.EnemyBulletLarge;
	import candyking.game.ammo.EnemyLaser;
	import candyking.game.GameWorld;
	import candyking.tweens.PendulumMotion;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.motion.CircularMotion;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	
	public class DeathCandyBehaviour {
		
		public static const ATTACK_NONE:String = "none";
		public static const ATTACK_WANDERING:String = "wandering";
		public static const ATTACK_CIRCLING:String = "circling";
		public static const ATTACK_RUSHING:String = "rushing";
		public static const ATTACK_LASER:String = "laser";
		
		public static const AMMO_OFFSET_X:Number = 29;
		public static const AMMO_OFFSET_Y:Number = 32;
		public static const SPEED_SLOW:int = 30;
		public static const SPEED_MEDIUM:int = 60;
		public static const SPEED_FAST:int = 70;
		public static const SPEED_XFAST:int = 180;
		public static const SPEED_RUSHING:int = 200;
		
		private static const RANDOM_ATTACKS:Vector.<String> = Vector.<String>([
			ATTACK_WANDERING,
			ATTACK_CIRCLING,
			ATTACK_RUSHING,
			ATTACK_LASER
		]);
		
		private var _gameWorld:GameWorld;
		private var _entity:DeathCandy;
		private var _attack:String = ATTACK_NONE;
		private var _attackTime:Number = 0;
		private var _attackUpdateCount:Number = 0;
		private var _rushingPreparing:Boolean;
		private var _rushingFromAbove:Boolean;
		
		private var _linearTween:LinearMotion = new LinearMotion();
		private var _pendulumTween_1:PendulumMotion = new PendulumMotion(null, Tween.LOOPING);
		private var _pendulumTween_2:PendulumMotion = new PendulumMotion(null, Tween.LOOPING);
		private var _circularTween:CircularMotion = new CircularMotion(null, Tween.LOOPING);
		
		public function DeathCandyBehaviour(gameWorld:GameWorld, entity:DeathCandy) {
			_entity = entity;
			_gameWorld = gameWorld;
			init();
		}
		
		private function init():void {
			_linearTween.object = _entity;
			_entity.addTween(_linearTween);
			
			_pendulumTween_1.object = _entity;
			_entity.addTween(_pendulumTween_1);
			
			_pendulumTween_2.object = _entity;
			_entity.addTween(_pendulumTween_2);
			
			_circularTween.object = _entity;
			_entity.addTween(_circularTween);
			
			var spawnTween:LinearMotion = new LinearMotion(onSpawnTweenCompleted, Tween.ONESHOT);
			spawnTween.object = _entity;
			spawnTween.setMotion(450, 56, 260, 56, 3, Ease.sineOut);
			_entity.addTween(spawnTween);
		}
		
		private function onSpawnTweenCompleted():void {
			startAttack(ATTACK_LASER);
		}
		
		public function update():void {
			_attackTime += FP.elapsed;
			_attackUpdateCount++;
			
			switch (_attack) {
				case ATTACK_CIRCLING:
					updateAttackCircling();
					break;
				case ATTACK_WANDERING:
					updateAttackWandering();
					break;
				case ATTACK_RUSHING:
					updateAttackRushing();
					break;
				case ATTACK_LASER:
					updateAttackLaser();
					break;
			}
			
			if (_attack != ATTACK_NONE) {
				if (_attackUpdateCount % 120 == 0) {
					
				}
			}
		}
		
		private function updateAttackCircling():void {
			if (!_linearTween.active && !_circularTween.active) {
				_circularTween.setMotion(200 - 56, 112 - 56, 56, 90, Math.random() < 0.5, 8);
			}
			if (_circularTween.active) {
				if (_attackUpdateCount % 20 == 0) {
					shootAtPlayer();
				}
			}
			if (_attackTime >= 16) {
				_circularTween.active = false;
				startRandomAttack();
			}
		}
		
		private function updateAttackWandering():void {
			if (!_linearTween.active && !_pendulumTween_1.active) {
				_pendulumTween_1.setMotionSpeed(280, 0,  8, 0, SPEED_MEDIUM, Ease.sineInOut, PendulumMotion.X_AXIS);
				_pendulumTween_2.setMotionSpeed(0,   10, 0, 103, SPEED_MEDIUM, Ease.sineInOut, PendulumMotion.Y_AXIS);
			}
			
			if (_pendulumTween_1.active) {
				if (_attackUpdateCount % 25 == 0) {
					shootAtPlayer();
				}
			}
			if (_attackTime >= 12) {
				_pendulumTween_1.active = false;
				_pendulumTween_2.active = false;
				startRandomAttack();
			}
		}
		
		private function updateAttackRushing():void {
			var toY:Number;
			if (!_linearTween.active) {
				if (_rushingPreparing) {
					_rushingPreparing = false;
					_rushingFromAbove = Math.random() < 0.5; 
					toY = _rushingFromAbove ? -_entity.height - 10 : FP.height + 10;
					_linearTween.setMotionSpeed(_entity.x, _entity.y, _entity.x, toY, SPEED_XFAST, Ease.quadIn);
				}else {
					var toX:Number = Math.random() * (FP.width - _entity.width);
					toY = _rushingFromAbove ? FP.height + 10 : -_entity.height - 10;
					_rushingFromAbove = !_rushingFromAbove;
					_linearTween.delay = 0.5;
					_linearTween.setMotionSpeed(toX, _entity.y, toX, toY, SPEED_RUSHING);
				}
			}
			if (!_rushingPreparing) {
				if (_attackUpdateCount % 15 == 0) {
					shootAtPlayer();
				}
			}
			if (_attackTime >= 12) {
				_linearTween.delay = 0;
				_linearTween.active = false;
				startRandomAttack();
			}
		}
		
		private function updateAttackLaser():void {
			if (!_linearTween.active && !_pendulumTween_1.active) {
				_pendulumTween_1.setMotionSpeed(280, 0, 280, 113, SPEED_MEDIUM, Ease.sineInOut);
			}
			if (_pendulumTween_1.active) {
				if (_attackUpdateCount % 10 == 0) {
					var offsetY:Number;
					if (_entity.y <= 5) {
						offsetY = 5;
					}else if (_entity.y >= 108) {
						offsetY = _entity.height - 5;
					}else {
						offsetY = Math.random() * _entity.height;
					}
					_entity.shoot(EnemyLaser, AMMO_OFFSET_X, offsetY, -4, 0);
				}
			}
			if (_attackTime >= 12) {
				_pendulumTween_1.active = false;
				startRandomAttack();
			}
		}
		
		private function shootAtPlayer():void {
			_entity.shootAtPlayer(EnemyBulletLarge, AMMO_OFFSET_X, AMMO_OFFSET_Y, 2);
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
				case ATTACK_CIRCLING:
					_linearTween.setMotionSpeed(_entity.x, _entity.y, 200 - 56, 0, SPEED_FAST, Ease.sineInOut);
					break;
				case ATTACK_WANDERING:
					_linearTween.setMotionSpeed(_entity.x, _entity.y, 280, 10, SPEED_FAST, Ease.sineInOut);
					break;
				case ATTACK_RUSHING:
					_rushingPreparing = true;
					break;
				case ATTACK_LASER:
					_linearTween.setMotionSpeed(_entity.x, _entity.y, 280, 0, SPEED_FAST, Ease.sineInOut);
					break;
				default:
					throw new ArgumentError("Wrong attack type: " + attack);
			}
			_attack = attack;
			_attackTime = 0;
			_attackUpdateCount = 0;
		}
		
		public function die():void {
			_attack = ATTACK_NONE;
			_linearTween.complete = _entity.remove;
			_linearTween.setMotionSpeed(_entity.x, _entity.y, 400, _entity.y, SPEED_SLOW, Ease.sineIn);
		}
		
	}

}
