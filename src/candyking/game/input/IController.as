package candyking.game.input {
	
	public interface IController {
		
		function get steeringLeft():Boolean;
		
		function get steeringRight():Boolean;
		
		function get steeringUp():Boolean;
		
		function get steeringDown():Boolean;
		
		function get holdingPrimary():Boolean;
		
		function get beganPrimary():Boolean;
		
		function get holdingSecondary():Boolean;
		
		function get beganSecondary():Boolean;
		
		function get beganEsc():Boolean;
		
	}
	
}
