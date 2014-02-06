package candyking.mainmenu {
	
	import candyking.assets.Assets;
	import candyking.game.SideScrollerBackground;
	import candyking.Main;
	import candyking.ui.Button;
	import candyking.utils.GameGlobals;
	import candyking.utils.getURL;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	
	public class MainMenuWorld extends World {
		
		private var _background:SideScrollerBackground;
		private var _soundButton:Button;
		private var _playButton:Button;
		private var _helpButton:Button;
		private var _creditsButton:Button;
		private var _credits:Stamp;
		private var _creditsCloseButton:Button;
		private var _creditsBfxrButton:Button;
		private var _creditsMusicButton:Button;
		private var _creditsFlashPunkButton:Button;
		private var _creditsGitHubButton:Button;
		private var _help:Stamp;
		private var _helpCloseButton:Button;
		private var _easyButton:Button;
		private var _normalButton:Button;
		private var _hardButton:Button;
		
		public function MainMenuWorld() {
			super();
		}
		
		override public function begin():void {
			
			_background = new SideScrollerBackground(Assets.getAsset("misc/main_menu_background.xml"));
			add(_background);
			
			var logo:Stamp = new Stamp(Assets.getAsset("images/logo.png"), 81, 2);
			addGraphic(logo);
			
			var soundIcon:String = GameGlobals.soundEnabled ? "images/ui_icon_sound_on.png" : "images/ui_icon_sound_off.png";
			_soundButton = new Button("", onSoundAction, { iconAssetId: soundIcon, horizontalPadding: 2, verticalPadding: 2 } );
			_soundButton.x = FP.width - _soundButton.width - 4;
			_soundButton.y = 4;
			add(_soundButton);
			
			_playButton = new Button("Play", onPlayAction, { iconAssetId: "images/ui_icon_play.png" });
			_playButton.x = (FP.width - _playButton.width) / 2;
			_playButton.y = 190;
			add(_playButton);
			
			_helpButton = new Button("Help", onHelpAction);
			_helpButton.x = 10;
			_helpButton.y = 190;
			add(_helpButton);
			
			_creditsButton = new Button("Credits", onCreditsAction);
			_creditsButton.x = FP.width - _creditsButton.width - 10;
			_creditsButton.y = 190;
			add(_creditsButton);
			
			_credits = new Stamp(Assets.getAsset("images/main_menu_credits.png"));
			_credits.visible = false;
			addGraphic(_credits);
			
			_creditsCloseButton = new Button("", onCreditsCloseAction, { iconAssetId: "images/ui_icon_cross.png", horizontalPadding: 2, verticalPadding: 2 } );
			_creditsCloseButton.x = 360;
			_creditsCloseButton.y = 18;
			_creditsCloseButton.visible = false;
			add(_creditsCloseButton);
			
			_creditsBfxrButton = new Button("bfxr.net", onBfxrAction);
			_creditsBfxrButton.x = 205;
			_creditsBfxrButton.y = 76;
			_creditsBfxrButton.visible = false;
			add(_creditsBfxrButton);
			
			_creditsMusicButton = new Button("GundayMatt", onMusicAction);
			_creditsMusicButton.x = 172;
			_creditsMusicButton.y = 102;
			_creditsMusicButton.visible = false;
			add(_creditsMusicButton);
			
			_creditsFlashPunkButton = new Button("FlashPunk", onFlashPunkAction);
			_creditsFlashPunkButton.x = 197;
			_creditsFlashPunkButton.y = 154;
			_creditsFlashPunkButton.visible = false;
			add(_creditsFlashPunkButton);
			
			_creditsGitHubButton = new Button("GitHub", onGitHubAction);
			_creditsGitHubButton.x = 262;
			_creditsGitHubButton.y = 180;
			_creditsGitHubButton.visible = false;
			add(_creditsGitHubButton);
			
			_help = new Stamp(Assets.getAsset("images/main_menu_help.png"));
			_help.visible = false;
			addGraphic(_help);
			
			_helpCloseButton = new Button("", onHelpCloseAction, { iconAssetId: "images/ui_icon_cross.png", horizontalPadding: 2, verticalPadding: 2 } );
			_helpCloseButton.x = 360;
			_helpCloseButton.y = 18;
			_helpCloseButton.visible = false;
			add(_helpCloseButton);
			
			_normalButton = new Button("Normal", onNormalAction);
			_normalButton.x = (FP.width - _normalButton.width) / 2;
			_normalButton.y = 190;
			_normalButton.visible = false;
			add(_normalButton);
			
			_easyButton = new Button("Easy", onEasyAction);
			_easyButton.x = FP.width / 2 - _normalButton.width / 2 - 10 - _easyButton.width;
			_easyButton.y = 190;
			_easyButton.visible = false;
			add(_easyButton);
			
			_hardButton = new Button("Hard", onHardAction);
			_hardButton.x = FP.width / 2 + _normalButton.width / 2 + 10;
			_hardButton.y = 190;
			_hardButton.visible = false;
			add(_hardButton);
			
		}
		
		private function onSoundAction():void {
			GameGlobals.soundEnabled = !GameGlobals.soundEnabled;
			_soundButton.iconAssetId = GameGlobals.soundEnabled ? "images/ui_icon_sound_on.png" : "images/ui_icon_sound_off.png";
			Sfx.setVolume(null, GameGlobals.soundEnabled ? 1 : 0);
		}
		
		private function onHardAction():void {
			difficultyButtonsVisible = false;
			GameGlobals.startGame(GameGlobals.HARD);
			Main.openGame();
		}
		
		private function onEasyAction():void {
			difficultyButtonsVisible = false;
			GameGlobals.startGame(GameGlobals.EASY);
			Main.openGame();
		}
		
		private function onNormalAction():void {
			difficultyButtonsVisible = false;
			GameGlobals.startGame(GameGlobals.NORMAL);
			Main.openGame();
		}
		
		private function onGitHubAction():void {
			getURL("https://github.com/virtualtoy/candyking");
		}
		
		private function onFlashPunkAction():void {
			getURL("http://useflashpunk.net");
		}
		
		private function onMusicAction():void {
			getURL("http://www.newgrounds.com/audio/listen/449265");
		}
		
		private function onBfxrAction():void {
			getURL("http://www.bfxr.net");
		}
		
		private function onHelpCloseAction():void {
			mainButtonsVisible = true;
			
			_help.visible = 
			_helpCloseButton.visible = false;
		}
		
		private function onCreditsCloseAction():void {
			mainButtonsVisible = true;
			
			_credits.visible = 
			_creditsCloseButton.visible = 
			_creditsBfxrButton.visible = 
			_creditsMusicButton.visible = 
			_creditsFlashPunkButton.visible = 
			_creditsGitHubButton.visible = false;
		}
		
		private function onCreditsAction():void {
			mainButtonsVisible = false;
			
			_credits.visible = 
			_creditsCloseButton.visible = 
			_creditsBfxrButton.visible = 
			_creditsMusicButton.visible = 
			_creditsFlashPunkButton.visible = 
			_creditsGitHubButton.visible = true;
		}
		
		private function onHelpAction():void {
			mainButtonsVisible = false;
			
			_help.visible = 
			_helpCloseButton.visible = true;
		}
		
		private function set mainButtonsVisible(value:Boolean):void {
			_soundButton.visible =
			_playButton.visible =
			_helpButton.visible =
			_creditsButton.visible = value;
		}
		
		private function set difficultyButtonsVisible(value:Boolean):void {
			_easyButton.visible =
			_normalButton.visible =
			_hardButton.visible = value;
		}
		
		private function onPlayAction():void {
			mainButtonsVisible = false;
			difficultyButtonsVisible = true;
		}
		
		override public function update():void {
			_background.offset -= 2;
			super.update();
		}
		
	}

}
