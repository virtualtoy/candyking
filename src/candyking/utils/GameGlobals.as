package candyking.utils {
	
	import flash.net.SharedObject;
	
	public class GameGlobals {
		
		public static const MAX_LIVES:int = 5;
		public static const MAX_LEVEL:int = 2;
		public static const MAX_SPECIAL_WEAPON_AMOUNT:int = 5;
		
		public static const EASY:String = "easy";
		public static const NORMAL:String = "normal";
		public static const HARD:String = "hard";
		
		public static var soundEnabled:Boolean = true;
		
		private static var _bestScore:int;
		
		public static var score:int;
		public static var level:int;
		public static var lives:int;
		public static var specialWeaponAmount:int;
		
		private static var _scoreMultiplier:Number;
		private static var _powerupSpawnProbability:Number;
		private static var _enemyHealthMultiplier:Number;
		
		private static var _saveData:Object;
		
		populateBestScore();
		startGame(EASY);
		
		private static function populateBestScore():void {
			try {
				var so:SharedObject = SharedObject.getLocal("candykingeatstheworld");
				_bestScore = so.data["bestscore"];
			}catch (error:Error) { }
		}
		
		public static function startGame(difficulty:String):void {
			score = 0;
			level = 0;
			specialWeaponAmount = 3;
			
			switch (difficulty) {
				case EASY:
					lives = 5;
					_scoreMultiplier = 1;
					_powerupSpawnProbability = 1;
					_enemyHealthMultiplier = 0.3;
					break;
				case NORMAL:
					lives = 4;
					_scoreMultiplier = 10;
					_powerupSpawnProbability = 0.5;
					_enemyHealthMultiplier = 1;
					break;
				case HARD:
					lives = 3;
					_scoreMultiplier = 25;
					_powerupSpawnProbability = 0.2;
					_enemyHealthMultiplier = 1.2;
					break;
				default:
					throw new ArgumentError("Wrong difficulty: " + difficulty);
			}
		}
		
		public static function finishGame():void {
			if (score > _bestScore) {
				_bestScore = score;
			}
			try {
				var so:SharedObject = SharedObject.getLocal("candykingeatstheworld");
				so.data["bestscore"] = _bestScore;
			}catch (error:Error) { }
		}
		
		public static function get scoreMultiplier():Number {
			return _scoreMultiplier;
		}
		
		public static function get powerupSpawnProbability():Number {
			return _powerupSpawnProbability;
		}
		
		public static function get enemyHealthMultiplier():Number {
			return _enemyHealthMultiplier;
		}
		
		public static function get bestScore():int {
			return _bestScore;
		}
		
	}

}
