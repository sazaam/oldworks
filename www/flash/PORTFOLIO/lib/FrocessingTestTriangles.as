// Fro IsoTriangle3D
package{
    
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import frocessing.core.F5Graphics3D;
    import frocessing.display.* ;
    import frocessing.f3d.models.* ;
    import flash.display.Loader ;
    import flash.display.BitmapData ;
    import flash.net.URLRequest ;
    import flash.events.Event ;
    import flash.system.* ;
    import gs.easing.*;
    import gs.TweenLite;
    
    [SWF(width=465,height=465, frameRate=24, backgroundColor=0x2a2a2a)]
    public class FrocessingTestTriangles extends F5MovieClip3DBmp
    {
        private const BMP:String = "http://assets.wonderfl.net/images/related_images/1/1c/1c3b/1c3b8d9bfc26fcab4bded661f003ba8621cfd4c6m";
        
        private var stage_width:Number  = 465;
        private var stage_height:Number = 465;
        private var triangles:Vector.<IsoTriangle3D> ;
        private var __angle:Number = 0 ;
		private var drop:DropShadowFilter = new DropShadowFilter(0, -90, 0x4ed5e9, 1, 10, 10, 4, 3) ;
        
        public function FrocessingTestTriangles()
        {
            super() ;
			stage.scaleMode = 'noScale' ;
        }
        
        private function onLoadComplete(e:Event):void{
            e.target.removeEventListener(e.type, arguments.callee) ;
            e.target.content.smoothing = true ;
            var tex:BitmapData = e.target.content.bitmapData ;
			
            setTexture(tex) ;
        }
        
        public function setup():void
        {
            
            initTriangles() ;
             
            size(stage_width, stage_height) ;
            colorMode(RGB, 255, 255, 255, 1) ;
            background(0,0,0,0) ;
			noStroke() ;
            noFill() ;
            var l:Loader = new Loader;
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete) ;
            
            l.load(new URLRequest(BMP), new LoaderContext(true)) ;
			
			stage.addEventListener(MouseEvent.ROLL_OVER, onRoll, true) ;
			stage.addEventListener(MouseEvent.ROLL_OUT, onRoll, true) ;
			stage.addEventListener(MouseEvent.CLICK, onClick, true) ;
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, true) ;
        }
        
        public function draw():void
        {
            //background(0, 0, 0, 0) ;
            renderTriangles() ;
            //imageSmoothing(true) ;
            //imageDetail(3) ;
            //smooth() ;
        }
        
        private function setTexture(tex:BitmapData):void {
			var front:BitmapData = tex.clone() ;
			var reflect:BitmapData = new Reflect(front, false) ;
			
			var invertedFront:BitmapData = new DirectionBitmapData(front, DirectionBitmapData.Y_AXIS_INVERTED) ;
			var invertedReflect:BitmapData = new Reflect(invertedFront, false) ;
            var l:int = triangles.length ;
            for (var i:int = 0 ; i < l ; i++ ) {
                var t:IsoTriangle3D = triangles[i] ;
				t.setTexture(front, front) ;
				t.userData.reflect.setTexture(reflect, reflect) ;
            } 
        }
        
        public function renderTriangles():void
        {
            var l:int = triangles.length ;
			
            for (var i:int = 0 ; i < l ; i++ ) {
				var t3:IsoTriangle3D = triangles[i] ;
				var f:F5Graphics3D = t3.userData.fg ;
				
				f.beginDraw() ;
                f.pushMatrix();
                f.translate(stage_width / 2, stage_height / 2) ;
                
                f.model(t3) ;
                f.model(t3.userData.reflect) ;
                f.popMatrix() ;
				f.endDraw() ;
            }
        }
        
        private function tweenTriangles(n:int):void{
            var l:int = triangles.length ;
            for (var i:int = 0 ; i < l ; i++ ) {
				var t:IsoTriangle3D = triangles[i] ;
				TweenLite.killTweensOf(t) ;
				var d:Number = __angle + Math.PI * n;
				TweenLite.to(t, .5, { ease:Quad.easeOut, rotationY: d }) ;
				TweenLite.to(t.userData.reflect, .5, { ease:Quad.easeOut, rotationY: -d }) ;
            }
			__angle = d ;
        }
        
        public function initTriangles():void
        {
			var rad:Number = 200 ;
			const TOTAL:Number = 3 ;
            triangles = new Vector.<IsoTriangle3D>() ;
			
			for (var i:int = 0 ;  i < TOTAL ; i++ ) {
				var angle:Number = 360 / TOTAL * i ;
				var t3:IsoTriangle3D = new IsoTriangle3D(150, 1) ;
				var refl3:IsoTriangle3D = t3.userData.reflect= new IsoTriangle3D(150, 1) ;
				var sh:Sprite = t3.userData.sprite = new Sprite() ;
				addChild(sh) ;
				var f:F5Graphics3D = t3.userData.fg = new F5Graphics3D(sh.graphics, stage_width, stage_height) ;
				f.noStroke() ;
				f.noFill() ;
				refl3.rotateX(PI) ;
				refl3.y = 150*2/3 ;
				refl3.z = t3.z =  i == 1? 0: -250 ;
				t3.x = refl3.x = - 200 + 200 * i  ;
				triangles.push(t3) ;
			}
        }
        public function onWheel(e:MouseEvent):void
        {
			trace(e.target)
            tweenTriangles(e.delta / 3) ;
        }
        public function onClick(e:MouseEvent):void
        {
			trace(e.target)
            tweenTriangles(1) ;
        }
		private function onRoll(e:MouseEvent):void 
		{
			var s:Sprite = Sprite(e.target) ;
			if (s is F5MovieClip3DBmp) return ;
			var p:Array = s.filters ;
			if (e.type == MouseEvent.ROLL_OVER) {
				s.filters = p.concat([drop]) ;
			}else {
				p.splice(drop) ;
				s.filters = p ;
			}
		}
    }
}

import frocessing.f3d.F3DModel;

/**
 * ...
 * @author saz
 */

class IsoTriangle3D extends F3DModel
{
	public function IsoTriangle3D(size:Number = 50, segment:int = 2)
	{
		super();
		backFaceCulling = false;
		initModel( size , segment);
	}
	
	/** @private */
	private function initModel( size:Number, seg:int):void
	{
		beginVertex(TRIANGLES) ;
		
		var total:int = seg + 1 ;
		var hh:Number = 0 ;
		var midSize:Number = size * .5 ;
		hh = int(Math.sqrt((size*size) - (midSize*midSize))) ;
		var diff:Number = size - hh ;
		var midW:Number = size * .5 ;
		var midH:Number = hh * .5 ;
		var divX:Number = size / (total) ;
		var divY:Number = hh / (total) ;
		
		var startX:Number = - midW ;
		var startY:Number = - (hh - diff) / 2 ;
		var startIndY:Number = (size - hh)/2 / size;
		var unitX:Number = 1/ (total*2) ;
		
		 for ( var i:int = 0 ; i <= seg; i++ ) {
			var curX:Number =  midW + ( - i * divX * .5) ;
			var curX2:Number =  midW + ( - i * divX) ;
			var curY:Number =  divY * i ;
			
			for ( var j:int = 0; j <= i ; j ++ ) {
				var xx:Number = curX + divX * j ;
				var yy:Number = curY ;
				var indX:Number = xx / size - unitX ;
				var indY:Number = yy / hh ;
				
				var result0:Number = indX + (divX  / size / 2) ;
				var result1:Number = indX + (divX  / size) ;
				var result2:Number = indX ;
				
				if (j != 0) {
					addVertex(startX + xx - divX, startY + (yy - divY / 2), 0,
							result1 - unitX*3, indY - startIndY) ;
					addVertex(startX + xx, startY + (yy - divY / 2), 0,
							result1 - unitX, indY - startIndY) ;
					addVertex(startX + (xx - divX / 2), startY + (yy + divY / 2), 0,
							result1 - unitX*2, indY + (divY / hh) - startIndY) ;
				}
				addVertex(startX + xx, startY + (yy - divY / 2), 0, 
						 result0, indY - startIndY) ;
				addVertex(startX + (xx + divX / 2), startY + (yy + divY / 2), 0, 
						result1, indY + (divY / hh) - startIndY) ;
				addVertex(startX + (xx - divX / 2), startY + (yy + divY / 2), 0, 
						result2, indY + (divY / hh) - startIndY) ;
			}
		}
		endVertex() ;
	}
	
	public function toString():String 
	{
		return '[object IsoTriangle3D] >> ( x:'+x+', y:'+y+', z:'+z+')' ;
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * ...
 * @author saz
 */
class DirectionBitmapData extends BitmapData 
{
    private var __dims:Rectangle;
    private var __source:IBitmapDrawable;
    static public const NORMAL:int = -1
    static public const X_AXIS_INVERTED:int = 1 ;
    static public const Y_AXIS_INVERTED:int = 2 ;
    
    
    public function DirectionBitmapData(src:IBitmapDrawable, mode:int = -1) 
    {
        __source = src ;
        __dims = new Rectangle(0,0,BitmapData(src).width, BitmapData(src).height) ;
        super(__dims.width, __dims.height, true, 0xFF6600) ;
        drawSource(mode) ;
    }
    public function drawSource(mode:int = -1):void 
    {
        var m:Matrix ; 
        switch(mode) {
            case X_AXIS_INVERTED:
                m = new Matrix(-1, 0, 0, 1, __dims.width, 0) ;
            break;
            case Y_AXIS_INVERTED:
                m = new Matrix(1, 0, 0, -1, 0, __dims.height) ;
            break;
            default :
                return draw(source, null, null, null, null, true) ;
            break ;
        }
        var temp:BitmapData = this.clone() ;
        temp.draw(__source, null, null, null, null, true) ;
        draw(temp, m) ;
    }
    public function toBitmap(pixelSnapping:String, smoothing:Boolean):Bitmap
    {
        return new Bitmap(this, pixelSnapping, smoothing) ; 
    }
    
    public function get source():IBitmapDrawable { return __source }
    public function set source(value:IBitmapDrawable):void { __source = value }
    
    public function get dimensions():Rectangle { return __dims }
    public function set dimensions(value:Rectangle):void { __dims = value }
    
}

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.IBitmapDrawable;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * ...
 * @author saz
 */
class Reflect extends DirectionBitmapData 
{
    public function Reflect(src:IBitmapDrawable, invert:Boolean = true, mode:Number = -1)
    {
        if (mode == -1 && Boolean(invert)) mode = Y_AXIS_INVERTED ;
        super(src, mode) ;
        init(mode) ;
    }
    
    private function init(mode:int):void 
    {
        drawReflectGradient(mode) ;
    }
    
    private function drawReflectGradient(mode:int):void 
    {
        var matrix:Matrix = new Matrix() ;
        var colors:Array = [0xFFFFFF, 0x0] ;
        var alphas:Array = [.25, 0] ;
        var ratios:Array = [0, 255] ;
        
        var rotation:Number ;
        switch(mode) {
            case X_AXIS_INVERTED :
                trace('yo') ;
                colors = [0xFFFFFF, 0x0] ;
                alphas = [.25, 0] ;
                ratios = [0, 255] ;
                rotation = 0 ;
            break;
            case Y_AXIS_INVERTED:
                colors = [0xFFFFFF, 0x0] ;
                alphas = [.25, 0] ;
                ratios = [0, 255] ;
                rotation = Math.PI * .5 ;
            break;
            default:
                rotation = -Math.PI * .5 ;
            break;
        }
        
        var sh:Shape = new Shape() ;
        
        matrix.createGradientBox(dimensions.width, dimensions.height, rotation, 0, 0) ;
        sh.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix) ;
        sh.graphics.drawRect(0, 0, dimensions.width, dimensions.height) ;
        sh.graphics.endFill() ;
        
        draw(sh, null, null, 'alpha' ,null,true) ;
    }
}
