package candyking.game.ui {
	
	import candyking.assets.Assets;
	import candyking.game.EntityLayer;
	import candyking.Main;
	import candyking.ui.Button;
	import candyking.utils.EntityUtil;
	import candyking.utils.GameGlobals;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	
	public class HUD extends Entity {
		
		private var _nameToGraphicsDict:Dictionary = new Dictionary();
		
		public function HUD() {
			super();
			init();
		}
		
		private function init():void {
			layer = EntityLayer.HUD;
			EntityUtil.setup(Assets.getAsset("misc/game_hud.xml"), this, _nameToGraphicsDict);
		}
		
		private function getGraphic(name:String):Graphic {
			return _nameToGraphicsDict[name];
		}
		
		public function set score(value:int):void {
			var scoreText:Text = getGraphic("scoreText") as Text;
			scoreText.text = "SCORE: " + value;
			scoreText.x = FP.width - scoreText.width;
		}
		
		public function set lives(value:int):void {
			for (var i:int = 0; i < GameGlobals.MAX_LIVES; i++) {
				getGraphic("life_" + i).visible = value > i;
			}
		}
		
		public function set specialWeaponAmount(value:int):void {
			for (var i:int = 0; i < GameGlobals.MAX_SPECIAL_WEAPON_AMOUNT; i++) {
				getGraphic("nuke_" + i).visible = value > i;
			}
		}
		
		public function showGameOver():void {
			layer = EntityLayer.OVERLAY;
			
			var text:Text = new Text("Game Over\nScore: " + GameGlobals.score + "\nBest: " + GameGlobals.bestScore);
			text.align = TextFormatAlign.CENTER;
			text.x = (FP.width - text.width) / 2;
			text.y = 80;
			addGraphic(text);
			
			var mainMenuButton:Button = new Button("Main Menu", Main.openMainMenu);
			mainMenuButton.layer = EntityLayer.OVERLAY;
			mainMenuButton.x = (FP.width - mainMenuButton.width) / 2;
			mainMenuButton.y = 138;
			world.add(mainMenuButton);
		}
		
	}

}
