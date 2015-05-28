package sketchbook.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * Graphicsクラスを操作する為のヘルパーオブジェクトです。
	 * <p>基本的な多角形や、ポリライン描画などをサポートします</p>
	 */
	public class GraphicsHelper
	{
		protected var _target:Graphics
		
		public function GraphicsHelper(_target:Graphics)
		{
			this._target = _target
		}
		
		
		/*
			Draws a series of lines to target graphics instance.
			
			points:Array array that contains Point instances
			close:Boolean if true, close line from the last point to tha first point.
		*/
		public function drawLines(points:Array, close:Boolean=false):void
		{
			var g:Graphics = this._target
			
			var imax:Number = points.length
			
			g.moveTo(points[0].x, points[0].y);
			for(var i:Number=1; i<imax; i++)
				g.lineTo(points[i].x, points[i].y);
			
			if(close)
				g.lineTo(points[0].x, points[0].y);
		}
		
		
		
		/*
			Draws four points quad
			
			x0:Number
			y0:Number
			x1:Number
			y1:Number
			x2:Number
			y2:Number
		*/
		public function drawQuad(x0:Number,y0:Number, x1:Number,y1:Number, x2:Number,y2:Number, x3:Number,y3:Number):void
		{
			var ar:Array = getQuadPoints(x0,y0,x1,y1,x2,y2,x3,y3);
			drawLines(ar, true);
		}
		
		
		//４点を配列化して返す
		public function getQuadPoints(x0:Number,y0:Number, x1:Number,y1:Number, x2:Number,y2:Number, x3:Number,y3:Number):Array
		{
			return [new Point(x0,y0), new Point(x1,y1), new Point(x2,y2), new Point(x3,y3)]
		}
		
		
		
		/*
			Draws three point triangle
		*/
		public function drawPolygon(x0:Number,y0:Number,x1:Number,y1:Number,x2:Number,y2:Number):void
		{
			drawLines([new Point(x0,y0), new Point(x1,y1), new Point(x2,y2)], true);
		}
		
		//弧を描く
		public function drawArc(x:Number, y:Number, radius:Number, degree:Number, fromDegree:Number=0, split:Number=36):void
		{
			var points:Array = getArcPoints(x, y, radius, degree, fromDegree, split);
			drawLines(points, false);
		}
		
		
		public function drawRing(x:Number, y:Number, outerRadius:Number, innerRadius:Number, degree:Number=360, fromDegree:Number=0, split:Number=36):void
		{
			var points:Array = getRingPoints(x, y, outerRadius, innerRadius, degree, fromDegree, split);
			drawLines(points, true);
		}
		
		public function getRingPoints(x:Number, y:Number, outerRadius:Number, innerRadius:Number, degree:Number=360, fromDegree:Number=0, split:Number=36):Array
		{
			var fromRad:Number = fromDegree * Math.PI / 180;
			var dr:Number = (degree* Math.PI / 180) / split
			var pt:Point
			
			var imax:int = split +1
			var rad:Number
			
			var points:Array = new Array();
			for(var i:int=0; i<imax; i++)
			{
				pt = new Point()
				rad = fromRad + dr * i
				pt.x = Math.cos(rad)*outerRadius+x
				pt.y = Math.sin(rad)*outerRadius+y
				points.push(pt)
			}
			
			var points2:Array = []
			for(i=0; i<imax; i++){
				pt = new Point()
				rad = fromRad + dr * i
				pt.x = Math.cos(rad)*innerRadius+x
				pt.y = Math.sin(rad)*innerRadius+y
				points2.push(pt)
			}
			points2.reverse()
			
			points = points.concat(points2);
			
			return points
		}
		
		
		public static function getArcPoints(x:Number, y:Number, radius:Number, degree:Number, fromDegree:Number=0, split:Number=36):Array
		{
			var points:Array = new Array();
			var fromRad:Number = fromDegree * Math.PI / 180;
			var dr:Number = (degree* Math.PI / 180) / split
			var imax:int = split+1
			
			for(var i:int=0; i<imax; i++)
			{
				var pt:Point = new Point()
				var rad:Number = fromRad + dr * i
				pt.x = Math.cos(rad)*radius+x
				pt.y = Math.sin(rad)*radius+y
				points.push(pt)
			}
			
			return points
		}
		
		//扇形、円弧と中心点を結んだ形状を描画する
		public function drawPie(x:Number, y:Number, radius:Number, degree:Number, fromDegree:Number=0, split:Number=36):void
		{
			var points:Array = getPiePoints(x, y, radius, degree, fromDegree, split)
			drawLines(points, true);
		}
		
		
		public static function getPiePoints(x:Number, y:Number, radius:Number, degree:Number, fromDegree:Number=0, split:Number=36):Array
		{
			var points:Array = getArcPoints(x, y, radius, degree, fromDegree, split)
			var pt:Point

			points.unshift( new Point(x, y) )
			
			return points
		}
		
		
		
		//歯車を描画する
		public function drawStar(x:Number, y:Number, outerRadius:Number, innerRadius:Number, num:Number, degreeOffset:Number=0):void
		{	
			var ar:Array = getStarPoints(x,y,outerRadius,innerRadius,num,degreeOffset);
			drawLines(ar,true);
		}
		
		//ギア状のポイント配列を取得する
		public static function getStarPoints(x:Number, y:Number, outerRadius:Number, innerRadius:Number, num:Number, degreeOffset:Number=0):Array
		{
			var points:Array = new Array();
			var drad:Number = Math.PI * 2 / num
			var xOffset:Number = x
			var yOffset:Number = y
			var radOffset:Number = degreeOffset * Math.PI / 180
			
			var imax:Number = num

			for(var i:Number=0; i<imax; i++)
			{
				var rad:Number = Math.PI * 2 * i/ num + radOffset
				var rad2:Number = Math.PI * 2 * (i+0.5)/ num  + radOffset
				
				var pt:Point 
				pt = new Point()
				pt.x = Math.cos(rad)*outerRadius + xOffset
				pt.y = Math.sin(rad)*outerRadius + yOffset
				points.push(pt);
			
				pt = new Point()
				pt.x = Math.cos(rad2)*innerRadius + xOffset
				pt.y = Math.sin(rad2)*innerRadius + yOffset
				points.push(pt);
			}
			return points
		}
		
		
		
		
		/*
		---------------------------------------------------------------------------------------------
		Begin Fill等へのアクセス関数
		本来のgraphicsにそのまま委譲します
		---------------------------------------------------------------------------------------------
		*/
		
		public function beginFill(color:uint, alpha:Number=1.0):void
		{
			_target.beginFill(color,alpha)
		}
		
		public function clear():void
		{
			_target.clear()
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_target.curveTo(controlX, controlY, anchorX, anchorY)
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void{
			_target.drawRect(x,y,width,height)
		}
		
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			_target.drawCircle(x,y,radius)
		}
		
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
			_target.drawEllipse(x,y,width,height)
		}
		
		public function drawRoundRect(x:Number,y:Number,width:Number,height:Number,ellipseWidth:Number,ellipseHeight:Number):void
		{
			_target.drawRoundRect(x,y,width,height,ellipseWidth,ellipseHeight)
		}
		
		public function drawRoundRectComplex(x:Number,y:Number,width:Number,height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			_target.drawRoundRectComplex(x,y,width,height,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius)
		}
		
		
		
		public function endFill():void
		{
			_target.endFill()
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			_target.moveTo(x,y)
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			_target.lineTo(x,y)
		}
		
		public function lineStyle(thickness:Number=0,
			color:uint=0,alpha:Number=1,
			pixelHinting:Boolean=false,
			scaleMode:String = "normal",
			caps:String=null,
			joints:String=null,
			miterLimit:Number=3):void
		{
			_target.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit)
		}
		
		public function beginBitmapFill(bitmap:BitmapData,matrix:Matrix=null,repeat:Boolean=true,smooth:Boolean=false):void
		{
			_target.beginBitmapFill(bitmap,matrix,repeat,smooth)
		}
		
		public function beginGradientFill(type:String, color:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRation:Number=0.0):void
		{
			_target.beginGradientFill(type, color, alphas, ratios, matrix, spreadMethod, interpolationMethod,focalPointRation)
		}
		
		public function lineGradientStyle( type:String,colors:Array,alphas:Array,ratios:Array,matrix:Matrix=null,spreadMethod:String="pad",interpolationMethod:String="rgb",focalPointRatio:Number  = 0.0):void
		{
			_target.lineGradientStyle(type,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio)
		}
	}
}