package candyking.game.enemies {
	
	import candyking.game.ammo.EnemyBullet;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.motion.LinearMotion;
	
	public class WayFollowingEnemy extends ShootingEnemy {
		
		public var wayPoints:Vector.<WayPoint>;
		public var speed:Number;
		
		private var _tween:LinearMotion = new LinearMotion();
		private var _wayPointIndex:int;
		
		public function WayFollowingEnemy(initHealth:int, value:int, xmlAssetId:String = null, highlightName:String = null) {
			super(initHealth, value, xmlAssetId, highlightName);
			_tween.object = this;
			_tween.complete = onTweenCompleted;
			addTween(_tween);
		}
		
		private function onTweenCompleted():void {
			_wayPointIndex++;
			if (_wayPointIndex < wayPoints.length - 1) {
				moveToNextWaypoint();
			}else {
				remove();
			}
		}
		
		public override function added():void {
			super.added();
			_wayPointIndex = 0;
			x = wayPoints[0].x;
			y = wayPoints[0].y;
			
			moveToNextWaypoint();
		}
		
		private function moveToNextWaypoint():void {
			var wayPoint:WayPoint = wayPoints[_wayPointIndex];
			var nextWayPoint:WayPoint = wayPoints[_wayPointIndex + 1];
			_tween.delay = wayPoint.delay;
			_tween.setMotionSpeed(x, y, nextWayPoint.x, nextWayPoint.y, speed, wayPoint.ease);
		}
		
		public override function remove():void {
			_tween.active = false;
			super.remove();
		}
		
	}

}
