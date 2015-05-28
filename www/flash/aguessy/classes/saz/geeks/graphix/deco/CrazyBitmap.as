package saz.geeks.graphix.deco 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class CrazyBitmap extends Bitmap
	{
		private var pDrag:Boolean;
		private var pImageList:Array
		private var pWidth:int
		private var pHeight:int
		private var pOriginalImage:BitmapData
		private var pUpperLeft:Point
		private var CLICKPOINT:Point;

		
		
		
		public function CrazyBitmap(_bitmapData:BitmapData = null, _pixelSnapping:String = "auto", _smoothing:Boolean = false)
		{
			
			super(_bitmapData, _pixelSnapping, _smoothing)
			//if (_bitmapData || _pixelSnapping || _smoothing)
				//render()
		}
		public function render():Bitmap
		{
			//trace('OK, BITMAPPING... : ')
			//initParams()
			//parent.addEventListener(MouseEvent.MOUSE_DOWN,onClicked)
			
			//var cm:ColorMatrixPainter = new ColorMatrixPainter();
			// Define matrix via RGB number passed
			//cm.paint( 0xFF6600, .5);
			//cm.()
			// Apply the filter to the bitmapdata section to paint it
			//bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(0, 0), new ColorMatrixFilter( cm.matrix ) );
			
			
			
			return this
		}
		
		private function initParams():void
		{
			pDrag = false
			pWidth = parent.width
			pHeight = parent.height
			pOriginalImage = bitmapData
			pUpperLeft = new Point(0, 0)
		}
		
		private function onClicked(e:MouseEvent):void 
		{
			//trace(pWidth, pHeight)
			
			
			parent.removeEventListener(MouseEvent.MOUSE_DOWN, arguments.callee)
			parent.addEventListener(MouseEvent.MOUSE_UP,onReleased)
			addEventListener(Event.ENTER_FRAME, onFrame)
			
			
			pDrag = true
			
			CLICKPOINT = new Point(e.localX,e.localY)
			var X:int = CLICKPOINT.x
			var Y:int = CLICKPOINT.y
			
			//var bmp:BitmapData = new BitmapData()
			//bmp.copyPixels(origImage,)
			
			var origImage:BitmapData = pOriginalImage
			pImageList = []
			//	TL  : []
			pImageList.push(new BitmapData(X, Y, false, 0))
			pImageList[0].copyPixels(origImage,new Rectangle(0, 0, X, Y),new Point(0,0))
			//	TR  : []
			pImageList.push(new BitmapData(pWidth - X, Y, false, 0))
			pImageList[1].copyPixels(origImage,new Rectangle(X+1,0,pWidth,Y),new Point(X+1,0))
			//	BL  : []
			pImageList.push(new BitmapData(X,pHeight-Y, false, 0))
			pImageList[2].copyPixels(origImage,new Rectangle(0,Y+1,X,pHeight),new Point(0,Y+1))
			//	BR  : []
			pImageList.push(new BitmapData(pWidth-X,pHeight-Y, false, 0))
			pImageList[3].copyPixels(origImage,new Rectangle(X+1,Y+1,pWidth,pHeight),new Point(X+1,Y+1))
			//pImageList.push( new BitmapData(X,Y,32))
			//pImageList[1].copyPixels(origImage,rect(0,0,X,Y),rect(0,0,X,Y))
			//
			//add pImageList, new BitmapData(pWidth-X,Y,32)
			//pImageList[2].copyPixels(origImage,rect(0,0,pWidth-X,Y),rect(X+1,0,pWidth,Y))
			//
			//add pImageList, new BitmapData(X,pHeight-Y,32)
			//pImageList[3].copyPixels(origImage,rect(0,0,X,pHeight-Y),rect(0,Y+1,X,pHeight))
			//
			//add pImageList, new BitmapData(pWidth-X,pHeight-Y,32)
			//pImageList[4].copyPixels(origImage,rect(0,0,pWidth-X,pHeight-Y),rect(X+1,Y+1,pWidth,pHeight))
		}
		
		private function onFrame(e:Event):void 
		{
			
			if (pDrag) {
				var x1:int = CLICKPOINT.x
				var y1:int = CLICKPOINT.y
				
				var pCurrentPoint:Point = new Point(mouseX, mouseY)
				
				var x2:int = pCurrentPoint.x 
				var y2:int = pCurrentPoint.y 
				
				var origImage:BitmapData = pOriginalImage
				
				origImage.copyPixels(pImageList[0],new Rectangle(0,0,x2,y2),new Point(x1,y1))
				origImage.copyPixels(pImageList[1],new Rectangle(x2,0,x2,y2),new Point(pWidth-x1,y1)) /*,[new Point(x1,0),new Point(pWidth,0),new Point(pWidth,y1),new Point(x2,y2)]*/
				origImage.copyPixels(pImageList[2],new Rectangle(0,y2,x2,pHeight-y2),new Point(x1,pHeight-y1)) //[new Point(0,y1),new Point(x2,y2),new Point(x1,pHeight),new Point(0,pHeight)])
				origImage.copyPixels(pImageList[3],new Rectangle(x2,y2,pWidth-x2,pHeight-y2),new Point(pWidth-x1,pHeight-y1)) //[new Point(x2,y2),new Point(pWidth,y1),new Point(pWidth,pHeight),new Point(x1,pHeight)],new Point(pWidth-x1,pHeight-y1))
			}
			
			 //if pDrag then
    //
    //x1 = CLICKPOINT.locH
    //y1 = CLICKPOINT.locV
    //
    //pCurrentPoint = the mouseLoc - pUpperLeft
    //x2 = pCurrentPoint.locH
    //y2 = pCurrentPoint.locV
    //
    //origImage = sprite(me.spriteNum).member.image
    //
    //origImage.copyPixels(pImageList[1],\
     //[point(0,0),point(x1,0),point(x2,y2),point(0,y1)],\
     //rect(0,0,x1,y1))
    //
    //origImage.copyPixels(pImageList[2],\
     //[point(x1,0),point(pWidth,0),point(pWidth,y1),point(x2,y2)],\
     //rect(0,0,pWidth-x1,y1))
    //
    //origImage.copyPixels(pImageList[3],\
     //[point(0,y1),point(x2,y2),point(x1,pHeight),point(0,pHeight)],\
     //rect(0,0,x1,pHeight-y1))
    //
    //origImage.copyPixels(pImageList[4],\
     //[point(x2,y2),point(pWidth,y1),point(pWidth,pHeight),point(x1,pHeight)],\
     //rect(0,0,pWidth-x1,pHeight-y1))
    //
  //end if
  //
//end
			//trace("ON FRAME")
		}
		
		private function onReleased(e:MouseEvent):void 
		{
			//trace("yo stop")
			pDrag = false
			removeEventListener(Event.ENTER_FRAME,onFrame)
			parent.removeEventListener(MouseEvent.MOUSE_UP, arguments.callee)
			parent.addEventListener(MouseEvent.MOUSE_DOWN,onClicked)
		}
	}
	
}