package candyking.game.bosses {
	
	import candyking.game.GameWorld;
	
	public class FinalKingBehaviour extends CandyKingBehaviour {
		
		private static const RANDOM_ATTACKS:Vector.<String> = Vector.<String>([
			ATTACK_HOVERING,
			ATTACK_CHASING,
			ATTACK_RAGING,
			ATTACK_CIRCLING
		]);
		
		public function FinalKingBehaviour(gameWorld:GameWorld, entity:Boss) {
			super(gameWorld, entity);
		}
		
		override protected function get randomAttacks():Vector.<String> {
			return RANDOM_ATTACKS;
		}
		
	}

}
