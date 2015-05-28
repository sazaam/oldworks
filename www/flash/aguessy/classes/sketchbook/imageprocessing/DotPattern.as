package sketchbook.imageprocessing
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DotPattern implements IImageProcessing
	{
		/** dot pattern with 2dimentional array [[1,0],[0,1]] */
		public var patterns:Array
		/** color array that responds to patterns value [0x000000, 0xffffff] */
		public var colors:Array
		/** use transparent or not */
		public var transparent:Boolean
		
		public var clipRect:Rectangle
		
		public function DotPattern(transparent:Boolean = false, patterns:Array=null, colors:Array=null, clipRect:Rectangle=null)
		{
			if(patterns==null){
				this.patterns = [[0,1],[1,0]]
			}else{
				this.patterns = patterns.concat()
			}
				
			if(colors==null){
				if(transparent){
					this.colors = [0x00000000, 0xffffffff]
				}else{
					this.colors = [0x000000, 0xffffff]	
				}
			}else{
				this.colors = colors.concat()	
			}
			
			this.transparent = transparent
			
			if(clipRect!=null){
				this.clipRect = clipRect.clone()
			}
			
		}
		
		
		public function apply(targetBmd:BitmapData):BitmapData
		{		
			var bmd:BitmapData = new BitmapData(patterns[0].length, patterns.length, transparent, 0)
			
			var x:uint
			var y:uint
			var xmax:uint = patterns[0].length
			var ymax:uint = patterns.length
			var col:uint
			
			for(y=0; y<ymax; y++)
			{
				for(x=0; x<xmax; x++)
				{
					col = uint(colors[ patterns[y][x] ])
					if(transparent)
					{
						bmd.setPixel32(x,y,col)
					}else{
						bmd.setPixel(x,y,col)
					}
				}
			}
			
			var s:Shape = new Shape()
			s.graphics.beginBitmapFill(bmd);
			s.graphics.drawRect(0,0,targetBmd.width, targetBmd.height);
			s.graphics.endFill()
			
			
			targetBmd.draw(s,null,null,null,clipRect);
			
			//dispose after draw
			bmd.dispose()
			
			return targetBmd
		}
	}
}