package candyking.outro {
	
	import candyking.assets.Assets;
	import candyking.Main;
	import candyking.ui.Button;
	import candyking.utils.GameGlobals;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	
	public class OutroWorld extends World {
		
		private var _mainMenuButton:Button;
		
		public function OutroWorld() {
			super();
		}
		
		public override function begin():void {
			var logo:Stamp = new Stamp(Assets.getAsset("images/game_won.png"));
			addGraphic(logo);
			
			var text:Text = new Text("Congratulations!", 0, 8, { size: 16 } );
			addGraphic(text);
			text.x = (FP.width - text.width) / 2;
			
			text = new Text("Score: " + GameGlobals.score + " Best: " + GameGlobals.bestScore, 0, 165, { size: 16 } );
			addGraphic(text);
			text.x = (FP.width - text.width) / 2;
			
			_mainMenuButton = new Button("Main Menu", Main.openMainMenu);
			_mainMenuButton.x = (FP.width - _mainMenuButton.width) / 2;
			_mainMenuButton.y = 190;
			add(_mainMenuButton);
		}
		
	}

}
