package candyking.game.effects {
	
	import candyking.assets.Assets;
	import candyking.utils.EntityUtil;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	public class Explosion extends Entity {
		
		private var _spritemap:Spritemap;
		
		public function Explosion() {
			super();
			EntityUtil.setup(Assets.getAsset("entities/explosion.xml"), this);
			_spritemap = graphic as Spritemap;
			_spritemap.callback = onAnimationCompleted;
		}
		
		private function onAnimationCompleted():void {
			world.recycle(this);
		}
		
		public override function added():void {
			_spritemap.play("default", true, 0);
		}
		
	}

}
