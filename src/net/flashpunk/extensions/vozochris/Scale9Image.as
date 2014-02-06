package net.flashpunk.extensions.vozochris
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Flashpunk Scale9Image extension
	 * @author vozochris (Dotvoz)
	 */
	public class Scale9Image extends Image
	{
		/**
		 * Create a Scale9Image
		 * @param	source Image source, BitmapData or Class
		 * @param	scale9Grid Scale 9 grid
		 * @param	clipRect Source clip rectangle
		 * @param	W Image Width
		 * @param	H Image Height
		 * @param	disposeRegions If true, disposes the regions, only dispose if you don't redraw or do it rarely, otherwise it will generate the BitmapData over and over again resulting in lowered performance
		 */
		public function Scale9Image(source:*, scale9Grid:Rectangle, clipRect:Rectangle = null, W:int = -1, H:int = -1, disposeRegions:Boolean = true):void
		{
			this.Scale9Grid = scale9Grid;
			this.ClipRect = clipRect;
			
			super(source);
			
			if (W != -1 && H != -1)
				redraw(W, H, disposeRegions);
		}
		
		/**
		 * Redraw the Scale9Image
		 * @param	W Image Width
		 * @param	H Image Height
		 * @param	disposeRegions If true, disposes the regions, only dispose if you redraw once or rarely, otherwise it will generate the BitmapData over and over again resulting in lowered performance
		 */
		public function redraw(W:int, H:int, disposeRegions:Boolean = true):void
		{
			_source = generateImage(W, H, disposeRegions);
			_sourceRect = _source.rect;
			createBuffer();
			updateBuffer();
			
			if (disposeRegions)
				this.disposeRegions();
		}
		
		private function generateImage(W:int, H:int, disposeRegions:Boolean = true):BitmapData
		{
			if (!middleCenter)
				generateRegions();
			
			var result:BitmapData = new BitmapData(W, H);
			
			var extendW:int = W - middleLeft.width - middleRight.width;
			var extendH:int = H - topCenter.height - topCenter.height;
			
			P.setTo(0, 0);
			result.copyPixels(topLeft, topLeft.rect, P);
			
			var extendedTopCenter:BitmapData = extendPatternBitmapData(topCenter, extendW, topCenter.height);
			P.setTo(topLeft.width, 0);
			result.copyPixels(extendedTopCenter, extendedTopCenter.rect, P);
			
			P.setTo(topLeft.width + extendedTopCenter.width, 0);
			result.copyPixels(topRight, topRight.rect, P);
			
			var extendedMiddleLeft:BitmapData = extendPatternBitmapData(middleLeft, middleLeft.width, extendH);
			P.setTo(0, topCenter.height);
			result.copyPixels(extendedMiddleLeft, extendedMiddleLeft.rect, P);
			
			var extendedMiddleCenter:BitmapData = extendPatternBitmapData(middleCenter, extendW, extendH);
			P.setTo(middleLeft.width, topCenter.height);
			result.copyPixels(extendedMiddleCenter, extendedMiddleCenter.rect, P);
			
			var extendedMiddleRight:BitmapData = extendPatternBitmapData(middleRight, middleRight.width, extendH);
			P.setTo(middleLeft.width + extendedMiddleCenter.width, topCenter.height);
			result.copyPixels(extendedMiddleRight, extendedMiddleRight.rect, P);
			
			P.setTo(0, topCenter.height + extendedMiddleCenter.height);
			result.copyPixels(bottomLeft, bottomLeft.rect, P);
			
			var extendedBottomCenter:BitmapData = extendPatternBitmapData(bottomCenter, extendW, bottomCenter.height);
			P.setTo(bottomLeft.width, topCenter.height + extendedMiddleCenter.height);
			result.copyPixels(extendedBottomCenter, extendedBottomCenter.rect, P);
			
			P.setTo(bottomLeft.width + extendedBottomCenter.width, topCenter.height + extendedMiddleCenter.height);
			result.copyPixels(bottomRight, bottomRight.rect, P);
			
			extendedTopCenter.dispose();
			extendedMiddleLeft.dispose();
			extendedMiddleCenter.dispose();
			extendedMiddleRight.dispose();
			extendedBottomCenter.dispose();
			
			return result;
		}
		
		private function generateRegions():void
		{
			var bmp:BitmapData = cropBitmapData(source, clipRect);
			
			const leftWidth:Number = Scale9Grid.x;
			const centerWidth:Number = Scale9Grid.width;
			const rightWidth:Number = source.width - Scale9Grid.width - Scale9Grid.x;
			const topHeight:Number = Scale9Grid.y;
			const middleHeight:Number = Scale9Grid.height;
			const bottomHeight:Number = source.height - Scale9Grid.height - Scale9Grid.y;
			
			const regionLeftWidth:Number = leftWidth;
			const regionTopHeight:Number = topHeight;
			const regionRightWidth:Number = rightWidth;
			const regionBottomHeight:Number = bottomHeight;
			
			const topLeftRegion:Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
			topLeft = cropBitmapData(source, topLeftRegion);
			
			const topCenterRegion:Rectangle = new Rectangle(regionLeftWidth, 0, centerWidth, regionTopHeight);
			topCenter = cropBitmapData(source, topCenterRegion);
			
			const topRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, 0, regionRightWidth, regionTopHeight);
			topRight = cropBitmapData(source, topRightRegion);
			
			const middleLeftRegion:Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, middleHeight);
			middleLeft = cropBitmapData(source, middleLeftRegion);
			
			const middleCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, centerWidth, middleHeight);
			middleCenter = cropBitmapData(source, middleCenterRegion);
			
			const middleRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight, regionRightWidth, middleHeight);
			middleRight = cropBitmapData(source, middleRightRegion);
			
			const bottomLeftRegion:Rectangle = new Rectangle(0, regionTopHeight + middleHeight, regionLeftWidth, regionBottomHeight);
			bottomLeft = cropBitmapData(source, bottomLeftRegion);
			
			const bottomCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + middleHeight, centerWidth, regionBottomHeight);
			bottomCenter = cropBitmapData(source, bottomCenterRegion);
			
			const bottomRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight + middleHeight, regionRightWidth, regionBottomHeight);
			bottomRight = cropBitmapData(source, bottomRightRegion);
		}
		
		private function disposeRegions():void
		{
			topLeft.dispose();
			topLeft = null;
			topCenter.dispose();
			topCenter = null;
			topRight.dispose();
			topRight = null;
			middleLeft.dispose();
			middleLeft = null;
			middleCenter.dispose();
			middleCenter = null;
			middleRight.dispose();
			middleRight = null;
			bottomLeft.dispose();
			bottomLeft = null;
			bottomCenter.dispose();
			bottomCenter = null;
			bottomRight.dispose();
			bottomRight = null;
		}
		
		private function cropBitmapData(source:BitmapData, region:Rectangle):BitmapData
		{
			if (!region)
				return source.clone();
			
			var result:BitmapData = new BitmapData(region.width, region.height);
			result.copyPixels(source, region, Zero);
			
			return result;
		}
		
		private function extendPatternBitmapData(source:BitmapData, W:int, H:int):BitmapData
		{
			var sourceRect:Rectangle = source.rect;
			var sourceWidth:int = source.width;
			var sourceHeight:int = source.height;
			
			var iLe:int = Math.ceil(W / sourceWidth);
			var jLe:int = Math.ceil(H / sourceHeight);
			
			var result:BitmapData = new BitmapData(W, H);
			for (var i:int = 0; i < iLe; i++)
			{
				for (var j:int = 0; j < jLe; j++)
				{
					P.setTo(sourceWidth * i, sourceHeight * j);
					result.copyPixels(source, sourceRect, P);
				}
			}
			
			return result;
		}
		
		private var topLeft:BitmapData;
		private var topCenter:BitmapData;
		private var topRight:BitmapData;
		private var middleLeft:BitmapData;
		private var middleCenter:BitmapData;
		private var middleRight:BitmapData;
		private var bottomLeft:BitmapData;
		private var bottomCenter:BitmapData;
		private var bottomRight:BitmapData;
		
		private var Scale9Grid:Rectangle;
		private var ClipRect:Rectangle;
		private var Zero:Point = new Point();
		private var P:Point = new Point();
	
	}

}
