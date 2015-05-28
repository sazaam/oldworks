package{    
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import frocessing.display.F5MovieClip2DBmp;
    [SWF(width=465,height=465, frameRate=24, backgroundColor=0x2a2a2a)]
    public class FrocessingTest extends F5MovieClip2DBmp
    {
        private const URL:String = "http://assets.wonderfl.net/images/related_images/c/cb/cb14/cb14361a5b577ef5597b6be9c5e0144e10a6a8af";
        private var __unitHeight:int;
        private var __unitWidth:int;
        private var __loading:Boolean = true;
        
        public function FrocessingTest ()
        {
            super() ;
            stage.scaleMode = 'noScale' ;
            __unitWidth = 465 ;
            __unitHeight = 465 ;
        }
        
        private function resetSettings():void 
        {
            size(__unitWidth, __unitHeight) ;
            background(0, 0, 0, 0) ;
        }
        public function setup():void
        {
            resetSettings() ;
            var smart:Smart = Smart(addChild(initSmart())) ;
            stage.addEventListener(MouseEvent.CLICK, onClick, true) ;
            load(smart) ;
        }
        private function onClick(e:MouseEvent):void 
        {
            trace(e.target)
            var smart:Smart = e.target as Smart ;
            if (!Boolean(smart)) return  ;
            toggleLoad(smart) ;
        }
        private function load(smart:Smart):void 
        {
            toggleLoad(smart) ;
        }
        private function toggleLoad(smart:Smart):void 
        {
            smart.properties.xLoad(URL, __loading) ;
            __loading = !__loading ;
        }
        private function initSmart():Smart
        {
            var smart:Smart = new Smart({name:'saz', mouseChildren:false}) ;
            
            smart.properties.smart = smart ;
            
            var rectangleCont:Rectangle = new Rectangle(0, 0 , __unitWidth, __unitHeight) ;
            
            var g:Graphics = smart.graphics ;
            g.beginFill(0x0, 0) ;
            g.drawRect(0,0, __unitWidth, __unitHeight) ;
            g.endFill() ;
            
            smart.properties.open = function(e:Event):void {
                smart.properties.loadFro = new FroLoader(rectangleCont, 10, 8, 2) ;
                smart.addChild(smart.properties.loadFro) ;
            }
            smart.properties.progress = function(e:ProgressEvent):void {
                //trace('>>', 100*(e.bytesLoaded / e.bytesTotal), '%        >> ', smart) ;
            }
            
            smart.properties.cleanLoadings = function( completeClosure:Function, e:Event = null):void {
                smart.properties.loader.contentLoaderInfo.removeEventListener(Event.OPEN, smart.properties.open) ;
                smart.properties.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, smart.properties.progress) ;
                smart.properties.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeClosure) ;
                smart.properties.loader.unload() ;
                smart.properties.loader.unloadAndStop(true) ;
                smart.properties.loader = null ;
            }
            smart.properties.complete = function(e:Event):void {
                var response:DisplayObject = DisplayObject(smart.properties.loader.content) ;
                smart.properties.cleanLoadings(arguments.callee, e) ;
                
                var bmp:Bitmap = Bitmap(response) ;
                smart.properties.loadFX = new LoadFX(bmp.bitmapData, rectangleCont) ;
                smart.addChild(smart.properties.loadFX) ;
                smart.properties.loadFX.start() ;
                smart.removeChild(smart.properties.loadFro) ;
                smart.properties.loadFro = null ;
            }
            smart.properties.xLoad = function(url:String, cond:Boolean = true):void {
                smart.properties.loadUrl = url ;
                if (cond) {
                    this.loader = new Loader() ;
                    this.loader.contentLoaderInfo.addEventListener(Event.OPEN, this.open) ;
                    this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progress) ;
                    this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.complete) ;
                    this.loader.load(new URLRequest(url), new LoaderContext(true)) ;
                }else {
                    if (this.loader) {
                        this.cleanLoadings(this.complete) ;
                        if (this.loadFro) {
                            this.smart.removeChild(this.loadFro) ;
                            this.loadFro = null ;
                        }
                    }else {
                        if (this.loadFX) {
                            this.smart.properties.loadFX.kill(function(t:Object):void {
                                t.smart.removeChild(t.loadFX) ;
                                t.loadFX = null ;
                            }, this) ;
                        }
                    }
                }
            }
            
            return smart ;
        }
        
        public function draw():void
        {
            //
        }
    }
}


import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.JointStyle;
import flash.display.Shape;
import flash.geom.Point;
import flash.geom.Rectangle;
import frocessing.display.F5MovieClip2D;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.geom.Point;
import flash.geom.Rectangle;
import frocessing.display.F5MovieClip2D;
import gs.easing.Back;
import gs.easing.Expo;
import gs.TweenLite;

class LoadFX extends F5MovieClip2D 
{
    private static var __angle:int = -90 ;
    private static var __sizeRect:Rectangle = new Rectangle(0, 0, 100, 100) ;
    
    private var __oldPoint:Point;
    private var __percent:Number;
    private var __bmp:Bitmap;
    private var __opened:Boolean;
    private var __test:Shape;
    
    public function LoadFX(bmpData:BitmapData, dimensions:Rectangle = null) 
    {
        if (dimensions) {
            __sizeRect = dimensions ;
        }else {
            __sizeRect.width = bmpData.width ;
            __sizeRect.height = bmpData.height ;
        }
        __bmp = new Bitmap(bmpData, 'auto', true) ;
        __bmp.smoothing = true ;
    }
    
    public function setup():void 
    {
        initialSettings() ;
    }
    
    private function initialSettings():void 
    {
        size(__sizeRect.width, __sizeRect.height) ;
        scrollRect = __sizeRect ;
        smooth() ;
        noLoop() ;
        colorMode(RGB, 255, 255, 255);
        background(0,0,0,0) ;
        noStroke();
    }
    
    ///////////////// START
    public function start(closure:Function = null, ...args:Array):void 
    {
        startSettings() ;
        TweenLite.killTweensOf(this) ;
        TweenLite.to(this, .45, { ease:Expo.easeInOut, percent:100, onUpdate:function():void {
            Qdraw(__percent) ;
        },onComplete:function():void {
            if (closure is Function) closure.apply(null, args) ;
        }}) ;
    }
    private function startSettings():void 
    {
        __percent = 0 ;
        __oldPoint = null ;
    }
    ///////////////// KILL
    public function kill(closure:Function = null, ...args:Array):void 
    {
        TweenLite.killTweensOf(this) ;
        killSettings() ;
        TweenLite.to(this, .45, { ease:Expo.easeInOut,  percent:0, onUpdate:function():void {
            Pdraw(__percent) ;
        },onComplete:function():void {
            //__bmp = null ;
            //background(0, 0, 0, 0) ;
            if (closure is Function) closure.apply(null, args) ;
        }}) ;
    }
    private function killSettings():void 
    {
        //__percent = 0 ;
        __oldPoint = null ;
    }
    
    ////////////// DRAW AT START
    public function Qdraw(pct:Number):void {
        pct /= 100 ;
        var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
        var w:int = r.width ;
        var h:int = r.height ;
        var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
        var max:Number = Math.max(w, h) ;
        var min:Number = Math.min(w, h) ;
        var diameter:Number =  Math.sqrt((min*min) + (max*max)) ;
        fg.beginDraw() ;
        fg.clear() ;
        beginBitmapFill(__bmp.bitmapData) ;
        
        
        drawArc(center.x, center.y, diameter/2, diameter/2, radians(-90), radians(-90 + 360 * pct), true) ;
        
        endFill() ;
        fg.endDraw() ;
    }
    ////////////// DRAW AT KILL
    public function Pdraw(pct:Number):void {
        pct /= 100 ;
        var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
        var w:int = r.width ;
        var h:int = r.height ;
        var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
        var max:Number = Math.max(w, h) ;
        var min:Number = Math.min(w, h) ;
        var diameter:Number =  Math.sqrt((min*min) + (max*max)) ;
        fg.beginDraw() ;
        fg.clear() ;
        beginBitmapFill(__bmp.bitmapData) ;
        
        drawArc(center.x, center.y, diameter/2, diameter/2, radians( -90 + 360 * - pct), radians(-90) , true) ;
        
        endFill() ;
        fg.endDraw() ;
    }
    
    public function get percent():Number 
    {
        return __percent;
    }
    
    public function set percent(value:Number):void 
    {
        __percent = value;
    }
}

class FroLoader extends F5MovieClip2D
{
    private static var __sizeRect:Rectangle = new Rectangle(0, 0, 60,60) ;
    private var t:Number = 0;
    private var n:int = 12;
    private var to:int = 255;
    private var radius:Number;
    private    var eachWidth:Number;
    private    var eachHeight:Number;
    private var rotationPt:Point;
    private var rndCor:Number;
    private var alphas:Array = [] ;
    
    
    public function FroLoader(dimensions:Rectangle = null, diameter:Number = NaN, itemWidth:Number = NaN, itemHeight:Number = NaN, rotationPoint:Point = null, roundRectIndix:Number = NaN, colorIndex:uint = 0x0, colorMode:String = 'rgb')
    {
        if (dimensions) {
            __sizeRect = dimensions ;
        }
        initialSettings() ;
        x = __sizeRect.x ;
        y = __sizeRect.y ;
        eachWidth = itemWidth || 5 ;
        eachHeight = itemHeight || 5 ;
        rotationPt = rotationPoint || new Point() ;
        rndCor = roundRectIndix || 1 ;
        radius = diameter || (__sizeRect.width / 2) - Math.max(eachWidth, eachHeight) ;
    }
    
    private function initialSettings():void 
    {
        size(__sizeRect.width, __sizeRect.height) ;
        colorMode(RGB, 255, 255, 255) ;
    }
    public function setup():void 
    {
        loaderSetup() ;
    }
    private function loaderSetup():void 
    {
        makeAlphas();
    }
    private function makeAlphas():void
    {
        for (var i:int = 0; i <= n; i++)
        {
            alphas.push(i/n + 0.1);
        }
    }
    public function draw():void
    {
        translate( fg.width / 2, fg.height / 2 ) ;
        for (var i:int  = 0; i <= n; i++)
        {
            rotate( -Math.PI * 2 / n) ;
            lineStyle(eachHeight, 0xFF0000, alphas[(t + i) % n], false, 'none', CapsStyle.SQUARE, JointStyle.MITER, 10) ;
            fill(208, 26, 26, alphas[(t + i) % n]);
            translate(rotationPt.x, rotationPt.y) ;
            line(rotationPt.x+radius, rotationPt.y+0, rotationPt.x+radius+eachWidth, rotationPt.y+0) ;
        }
        if (++t == 24) t = 0;
    }
}



import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.utils.getQualifiedClassName;
    
/**
 * ...
 * @author saz
 * all rights reserved - sazaam / SAMUAE studios 2009 haha
 */

class Smart extends Sprite
{
    //////////////////////////////////////////////////////// VARS
    private var __properties:Object = { } ;
    //////////////////////////////////////////////////////// CTOR
    public function Smart(__props:Object = null) 
    {
        if (__props) {
            merge(__props) ;
            applyProperties() ;
        }
        super() ;
    }
    public function applyProperties(props:Object = null):void 
    {
        var p:Object = props || __properties ;
        for (var i:String in p) {
            if (Object(this).hasOwnProperty(i)) {
                this[i] = p[i] ;
            }
        }
    }
    private function merge(...restObjects:Array):void
    {
        __properties = Smart.merge.apply(this, [__properties].concat(restObjects)) ;
    }
    static public function merge(object:Object, ...restObjects:Array):Object
    {
        var l:int = restObjects.length ;
        for (var i:int = 0 ; i < l ; i++ ) {
            var o:Object = restObjects[i] ;
            for (var s:String in o) {
                object[s] = o[s] ;
            }
        }
        return object ;
    }
    public function destroy():void 
    {
        destroyChildren() ;
        properties = destroyProperties() ;
    }
    
    private function destroyProperties():Object 
    {
        for (var p:* in __properties) {
            delete properties[p] ;
        }
        return null ;
    }
    
    private function destroyChildren():void 
    {
        while (numChildren) {
            var child:DisplayObject = removeChildAt(0) ;
            if (child is Smart) {
                Smart(child).destroy() ;
            }
        }
    }
    override public function toString():String { return '[object '+getQualifiedClassName(this) + '] >> name:'+ name}
    public function dump():String
    {
        var str:String = 'start dump >> ' + this ;
        for (var i:String in __properties) {
            str += '\n        ' + i + '  >>>  ' + String(__properties[i]) ;
        }
        str += '\n end dump'
        return str ;
    }
    public function get properties():Object { return __properties }
    public function set properties(value:Object):void { __properties = value }
}