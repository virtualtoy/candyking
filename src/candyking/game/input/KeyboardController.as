package candyking.game.input {
	
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class KeyboardController implements IController {
		
		public function KeyboardController() {
			
		}
		
		public function get steeringLeft():Boolean {
			return Input.check(Key.LEFT) || Input.check(Key.A);
		}
		
		public function get steeringRight():Boolean {
			return Input.check(Key.RIGHT) || Input.check(Key.D);
		}
		
		public function get steeringUp():Boolean {
			return Input.check(Key.UP) || Input.check(Key.W);
		}
		
		public function get steeringDown():Boolean {
			return Input.check(Key.DOWN) || Input.check(Key.S);
		}
		
		public function get holdingPrimary():Boolean {
			return Input.check(Key.Z) || Input.check(Key.SPACE);
		}
		
		public function get beganPrimary():Boolean {
			return Input.pressed(Key.Z) || Input.pressed(Key.SPACE);
		}
		
		public function get holdingSecondary():Boolean {
			return Input.check(Key.X) || Input.check(Key.ENTER);
		}
		
		public function get beganSecondary():Boolean {
			return Input.pressed(Key.X) || Input.pressed(Key.ENTER);
		}
		
		public function get beganEsc():Boolean {
			return Input.pressed(Key.ESCAPE);
		}
		
	}

}
