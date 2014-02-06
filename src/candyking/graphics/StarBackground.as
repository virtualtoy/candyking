package candyking.graphics {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	
	public class StarBackground extends Graphic {
		
		public var speedX:Number;
		public var speedY:Number;
		
		private var _stars:Vector.<Star> = new Vector.<Star>();
		
		public function StarBackground(starCount:int = 50, speedX:Number = -1, speedY:Number = 0) {
			super();
			this.speedX = speedX;
			this.speedY = speedY;
			createStars(starCount);
		}
		
		private function createStars(starCount:int):void {
			for (var i:int = 0; i < starCount; i++) {
				var star:Star = new Star();
				star.setup(	Math.random() * FP.width,
								Math.random() * FP.height,
								speedX,
								speedY);
				_stars.push(star);
			}
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void {
			for each (var star:Star in _stars) {
				target.setPixel(star.x, star.y, star.color);
				star.x += star.speedX;
				if (star.x < 0) {
					star.setup(FP.width, star.y, speedX, speedY);
				}else if (star.x > FP.width) {
					star.setup(0, star.y, speedX, speedY);
				}
				star.y += star.speedY;
				if (star.y < 0) {
					star.setup(star.x, FP.height, speedX, speedY);
				}else if (star.y > FP.height) {
					star.setup(star.x, 0, speedX, speedY);
				}
			}
		}
		
	}

}

internal class Star {
	
	public var x:Number;
	public var y:Number;
	public var speedX:Number;
	public var speedY:Number;
	public var color:uint;
	
	public function Star() {
		
	}
	
	public function setup(x:Number, y:Number, speedX:Number, speedY:Number):void {
		this.x = x;
		this.y = y;
		this.speedX = (Math.random() * 0.9 + 0.1) * speedX;
		this.speedY = (Math.random() * 0.9 + 0.1) * speedY;
		var colorComponent:uint = Math.random() * 200 + 56;
		color = colorComponent << 16 | colorComponent << 8 | colorComponent;
	}
	
}
