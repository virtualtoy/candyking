package candyking {
	
	import candyking.game.GameWorld;
	import candyking.mainmenu.MainMenuWorld;
	import candyking.outro.OutroWorld;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import punk.transition.effects.CircleIn;
	import punk.transition.effects.CircleOut;
	import punk.transition.effects.FadeIn;
	import punk.transition.effects.FadeOut;
	import punk.transition.Transition;
	
	public class Main extends Engine {
		
		private static var EXPORT_CLASSES:ExportClasses;
		
		public function Main() {
			super(400, 225, 60, false);
			FP.screen.scale = 2;
			FP.screen.color = 0;
		}
		
		override public function init():void {
			openMainMenu();
		}
		
		public static function openMainMenu():void {
			Transition.to(MainMenuWorld, new FadeIn(), new FadeOut());
		}
		
		public static function openGame():void {
			Transition.to(GameWorld, new FadeIn(), new FadeOut());
		}
		
		public static function openOutro(centerX:Number, centerY:Number):void {
			var options:Object = { startX: centerX, startY: centerY };
			Transition.to(OutroWorld, new CircleIn(options), new CircleOut());
		}
		
	}

}
