package candyking.game.collisions {
	
	public class ColliderType {
		
		public static const NONE:int 			= 0;
		public static const PLAYER:int 			= 1 << 0;
		public static const ENEMY:int 			= 1 << 1;
		public static const BOSS:int 			= 1 << 2;
		public static const PLAYER_AMMO:int 	= 1 << 3;
		public static const ENEMY_AMMO:int 		= 1 << 4;
		public static const POWERUP:int 		= 1 << 5;
		
	}

}
