package sketchbook.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import sketchbook.graphics.GraphicsHelper
	import flash.events.KeyboardEvent;
	import sketchbook.SketchBook;
	
	/**
	 * Sprite、MovieClipを効率よく操作する為の、ショートカット、Helper,Utilを集約したクラスです。
	 * 
	 * <p>このクラスを用いることでインタラクティブ作品を作るときに要求される、雑務的処理を軽減することができまう。</p>
	 * 
	 * <p>このクラスを使う前に、<code>SketchBook.init</code>で、sketchbookの初期化を行う必要があります。</p>
	 * 
	 * @example <listing version="3.0">
	 *   var mySprite:Sprite = new Sprite();
	 *   var helper:SpriteHelper = new SpriteHelepr();
	 * 
	 *   helper.red = 100;
	 *   helper.onEnterFrame = function():void{ trace("onEnterFrame"); }</listing>
	 * 
	 * @see sketchbook.SketchBook
	 */
	public class SpriteHelper
	{
		/** Event.ADDEDに対応するコールバック。 */
		
		public var onAdded:Function
		/** Event.REMOVEDに対応するコールバック。 */
		public var onRemoved:Function
		
		/** MouseEvent.CLICKに対応するコールバック。 */
		public var onClick:Function
		
		/** MouseEvent.MOUSE_UPに対応するコールバック。 */
		public var onMouseUp:Function
		
		
		protected var _target:Sprite
		protected var _graphicsHelper:GraphicsHelper
		
		/**
		 * @param sprite このクラスで制御するSpriteインスタンスの参照
		 */
		public function SpriteHelper(sprite:Sprite):void
		{
			target = sprite
		}
		
		/*
		----------------------------------------------------------------------------
		target property shortcut
		returns number prop accessor for tweener
		----------------------------------------------------------------------------
		*/
		
		public function get alpha():Number
		{
			return _target.alpha
		}
		
		public function set alpha(value:Number):void
		{
			_target.alpha = value
		}
		
		public function get x():Number
		{
			return _target.x
		}
		
		public function set x(value:Number):void
		{
			_target.x = value
		}
		
		public function get y():Number
		{
			return _target.y
		}
		
		public function set y(value:Number):void
		{
			_target.y = value
		}
		
		public function get width():Number
		{
			return _target.width
		}
		
		public function set width(value:Number):void
		{
			_target.width = value
		}
		
		public function get height():Number
		{
			return _target.height
		}
		
		public function set height(value:Number):void
		{
			_target.height = value
		}
		
		public function get scaleX():Number
		{
			return _target.scaleX 
			
		}
		
		public function set scaleX(value:Number):void
		{
			_target.scaleX = value
		}
		
		public function get scaleY():Number
		{
			return _target.scaleY 
			
		}
		
		public function set scaleY(value:Number):void
		{
			_target.scaleY = value
		}
		
		public function get rotation():Number
		{
			return _target.rotation
		}
		
		public function set rotation(value:Number):void
		{
			_target.rotation = value
		}
		
		/*
		----------------------------------------------------------------------------
		matrix shortcut
		----------------------------------------------------------------------------
		*/
		
		/** matrixへのショートカット */
		public function get matrix():Matrix
		{
			return _target.transform.matrix
		}
		
		public function set matrix(mat:Matrix):void
		{
			_target.transform.matrix = mat
		}
		
		/** matrix.translate へのショートカット */
		public function translate(dx:Number, dy:Number):void
		{
			var mat:Matrix = _target.transform.matrix
			mat.translate(dx,dy)
			_target.transform.matrix = mat
		}
		
		/** matrix.rotate へのショートカット */
		public function rotete(angle:Number):void
		{
			var mat:Matrix = _target.transform.matrix
			mat.rotate(angle)
			_target.transform.matrix = mat
		}
		
		/** matrix.scale へのショートカット */
		public function scale(sx:Number, sy:Number):void
		{
			var mat:Matrix = _target.transform.matrix
			mat.scale(sx, sy)
			_target.transform.matrix = mat
		}
		
		/** matrixへのショートカット */
		public function get concatenatedMatrix():Matrix
		{
			return _target.transform.concatenatedMatrix
		}
		
		
		/*
		----------------------------------------------------------------------------
		positioning shortcut
		----------------------------------------------------------------------------
		*/
		
		/**
		 * あるローカル座標系の位置を別のローカル座標系に変換します。
		 * 
		 * <p>この関数は異なるスケールや階層関係のDisplayObject同士で、位置を調整・判定する場合に有効です。</p>
		 * 
		 * @param pt 変換したい座標
		 * @fromCordinate 変換元となる座標系のDiesplayObject
		 * @toCordinate 変換先となる座標系のDisplayObject
		 * 
		 * @return 変換された座標
		 */
		public static function localToLocal(pt:Point, fromCordinate:DisplayObject, toCordinate:DisplayObject):Point
		{
			pt = fromCordinate.localToGlobal(pt);
			pt = toCordinate.globalToLocal(pt)
			return pt
		}
		
		/** 
		 * Spriteのグローバル座標系での現在位置 
		 */
		public function get globalPoint():Point
		{
			var pt:Point = new Point(_target.x, _target.y)
			pt = _target.parent.localToGlobal(pt)
			return pt
		}
		
		public function set globalPoint(pt:Point):void
		{
			pt = _target.parent.globalToLocal(pt)
			_target.x = pt.x
			_target.y = pt.y
		}
		
		/** Spriteのグローバル座標系でのX */
		public function get globalX():Number
		{
			return globalPoint.x
		}
		
		public function set globalX(x:Number):void
		{
			var pt:Point = new Point(x, globalY)
			globalPoint = pt
		}
		
		/** Spriteのグローバル座標系でのY */
		public function get globalY():Number
		{
			return globalPoint.y
		}
		
		public function set globalY(y:Number):void
		{
			var pt:Point = new Point(globalX, y)
			globalPoint = pt
		}
		
		/*
		----------------------------------------------------------------------------
		graphics shortcut
		----------------------------------------------------------------------------
		*/
		
		/** 
		 * 対象のSpriteのgraphicsプロパティへのショートカット 
		 * 
		 * <p>SpriteHelperを通じて、Graphicsの全ての関数プロパティにアクセスすることができます</p>
		 * 
		 * @see flash.display.Graphics
		 */
		public function get graphics():Graphics
		{
			return _target.graphics
		}
		
		/** graphics.beginFillへのショートカット */
		public function beginFill(color:uint, alpha:Number=1.0):void
		{
			_target.graphics.beginFill(color,alpha)
		}
		
		/** graphics.clearへのショートカット */
		public function clear():void
		{
			_target.graphics.clear()
		}
		
		/** graphics.curveToへのショートカット */
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_target.graphics.curveTo(controlX, controlY, anchorX, anchorY)
		}
		
		/** graphics.drawRectへのショートカット */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void{
			_target.graphics.drawRect(x,y,width,height)
		}
		
		/** graphics.drawCircleへのショートカット */
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			_target.graphics.drawCircle(x,y,radius)
		}
		
		/** graphics.drawEllipseへのショートカット */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
			_target.graphics.drawEllipse(x,y,width,height)
		}
		
		/** graphics.drawRoundRectへのショートカット */
		public function drawRoundRect(x:Number,y:Number,width:Number,height:Number,ellipseWidth:Number,ellipseHeight:Number):void
		{
			_target.graphics.drawRoundRect(x,y,width,height,ellipseWidth,ellipseHeight)
		}
		
		/** graphics.drawRoundRectComplexへのショートカット */
		public function drawRoundRectComplex(x:Number,y:Number,width:Number,height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			_target.graphics.drawRoundRectComplex(x,y,width,height,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius)
		}
		
		/** graphics.endFillへのショートカット */
		public function endFill():void
		{
			_target.graphics.endFill()
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			_target.graphics.moveTo(x,y)
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			_target.graphics.lineTo(x,y)
		}
		
		public function lineStyle(thickness:Number=0,
			color:uint=0,alpha:Number=1,
			pixelHinting:Boolean=false,
			scaleMode:String = "normal",
			caps:String=null,
			joints:String=null,
			miterLimit:Number=3):void
		{
			_target.graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit)
		}
		
		public function beginBitmapFill(bitmap:BitmapData,matrix:Matrix=null,repeat:Boolean=true,smooth:Boolean=false):void
		{
			_target.graphics.beginBitmapFill(bitmap,matrix,repeat,smooth)
		}
		
		public function beginGradientFill(type:String, color:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRation:Number=0.0):void
		{
			_target.graphics.beginGradientFill(type, color, alphas, ratios, matrix, spreadMethod, interpolationMethod,focalPointRation)
		}
		
		public function lineGradientStyle( type:String,colors:Array,alphas:Array,ratios:Array,matrix:Matrix=null,spreadMethod:String="pad",interpolationMethod:String="rgb",focalPointRatio:Number  = 0.0):void
		{
			_target.graphics.lineGradientStyle(type,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio)
		}
		
		/*
		----------------------------------------------------------------------
		graphicsHelper
		----------------------------------------------------------------------
		*/
		
		/** 
		 * <code>Sprite</code>と関連付けられた<code>GraphicsHelper</code>へのショートカット 
		 * 
		 * @see sketchbook.graphics.GraphicsHelper
		 */
		public function get graphicsHelper():GraphicsHelper
		{
			return _graphicsHelper
		}
		
		/**
		 * Pointの配列を繋げて線を描画します。
		 * 
		 * <p>この関数は<code>GraphicsHelper.drawLines</code>のショートカットです。</p>
		 * 
		 * @param points Point配列
		 * @param closePath パスを閉じるかどうかのフラグ
		 * 
		 * @see sketchbook.graphics.GraphicsHelper#drawLines
		 **/
		public function drawLines( points:Array, closePath:Boolean=false):void
		{
			_graphicsHelper.drawLines( points, closePath )
		}
		
		/** 
		 * 4点から矩形を描画します。
		 * 
		 * <p>この関数は<code>GraphicsHelper.drawQuad</code>のショートカットです。</p>
		 * 
		 * @see sketchbook.graphics.GraphicsHelper#drawQuad
		 */
		public function drawQuad(x0:Number,y0:Number, x1:Number,y1:Number, x2:Number,y2:Number, x3:Number,y3:Number):void
		{
			_graphicsHelper.drawQuad(x0,y0,x1,y1,x2,y2,x3,y3)
		}
		
		/** 
		 * 3点から三角形を描画します。
		 * 
		 * <p>この関数は<code>GraphicsHelper.drawPolygon</code>のショートカットです。</p>
		 * 
		 * @see sketchbook.graphics.GraphicsHelper#drawPolygon
		 */
		public function drawPolygon(x0:Number,y0:Number,x1:Number,y1:Number,x2:Number,y2:Number):void
		{
			_graphicsHelper.drawPolygon(x0,y0,x1,y1,x2,y2)
		}
		
		/**
		 * 星や爆発などの凹凸のある多角形を描画します。 
		 * 
		 * @param x 中心のX座標
		 * @param y 中心のY座標
		 * @param outerRadius 外周半径
		 * @param innerRadius 内周半径
		 * @param num 分割数
		 * 
		 * @see sketchbook.graphics.graphicsHelper
		 */
		public function drawStar(x:Number, y:Number, outerRadius:Number, innerRadius:Number, num:Number, fromDegree:Number=0):void
		{	
			_graphicsHelper.drawStar(x,y,outerRadius,innerRadius,num, fromDegree)
		}
		
		/**
		 * 円弧を描画します
		 * 
		 * @param x 中心のX座標
		 * @param y 中心のY座標
		 * @param radius 半径
		 * @param degree 円弧の角度
		 * @param fromDegree 開始角度
		 * @param split 円の分割数
		 * 
		 * @see sketchbook.graphics.graphicsHelper
		 */
		public function drawArc(x:Number, y:Number, radius:Number, degree:Number, fromDegree:Number=0, split:Number=36):void
		{
			_graphicsHelper.drawArc(x, y, radius, degree, fromDegree, split)
		}
		
		/**
		 * 中心と円弧を結んだ扇形を描画します。
		 * @param x 中心のX座標
		 * @param y 中心のY座標
		 * @param radius 半径
		 * @param degree 円弧の角度
		 * @param fromDegree 開始角度
		 * @param split 円の分割数
		 * 
		 * @see sketchbook.graphics.graphicsHelper
		*/
		public function drawPie(x:Number, y:Number, radius:Number, degree:Number, fromDegree:Number=0, split:Number=36):void
		{
			_graphicsHelper.drawPie(x, y, radius, degree, fromDegree, split)
		}
		
		/**
		 * 太さのある円弧を描画します。
		 * 
		 * @param x 中心のX座標
		 * @param y 中心のY座標
		 * @param outerRadius 外周の半径
		 * @param innerRadius 内周の半径
		 * @param degree 円弧の角度
		 * @param fromDegree 開始角度
		 * @param split 円の分割数
		 */
		public function drawRing(x:Number, y:Number, outerRadius:Number, innerRadius:Number, degree:Number=360, fromDegree:Number=0, split:Number=36):void
		{
			_graphicsHelper.drawRing(x, y, outerRadius, innerRadius, degree, fromDegree, split);
		}
		
		/*
		----------------------------------------------------------------------
		colorTransform
		----------------------------------------------------------------------
		*/
		
		
		/** colorTransformへのショートカット */
		public function get colorTransform():ColorTransform
		{
			return _target.transform.colorTransform
		}
		
		public function set colorTransform(colt:ColorTransform):void
		{
			_target.transform.colorTransform = colt	
		}
		
		public function get redOffset():Number{
			return _target.transform.colorTransform.redOffset
		}
		
		public function get greenOffset():Number{
			return _target.transform.colorTransform.greenOffset
		}
		
		public function get blueOffset():Number{
			return _target.transform.colorTransform.blueOffset
		}
		
		public function get redMultiplier():Number{
			return _target.transform.colorTransform.redMultiplier
		}
		
		public function get greenMultiplier():Number{
			return _target.transform.colorTransform.greenMultiplier
		}
		
		public function get blueMultiplier():Number{
			return _target.transform.colorTransform.blueMultiplier
		}
		
		public function set rgbOffset(value:Number):void{
			var colt:ColorTransform = colorTransform
			colt.redOffset = value
			colt.greenOffset = value
			colt.blueOffset = value
			_target.transform.colorTransform = colt
		}
		
		public function get rgbOffset():Number{
			var colt:ColorTransform = colorTransform
			return (colt.redOffset + colt.greenOffset + colt.blueOffset)/3;
		}
		
		
		/** 
		 * Childrenに対してsortを行います。 
		 * 
		 * <p>この関数は未実装です</p>
		 */
		public function sortChildren(...args):void
		{
			throw new Error("Not yet implementd")
		}
		
		/**
		 * targetのChildrenを特定のプロパティの値でArray.sortを行います。
		 * 
		 * @see Array.sort
		 */
		public function sort(fieldName:Object, options:Object=null):void
		{
			var i:int
			var ar:Array = new Array();
			var imax:Number = _target.numChildren
			for(i=0; i<imax; i++)
				ar.push(_target.getChildAt(i));
			ar.sortOn(fieldName, options);
			
			for(i=0; i<imax; i++)
				_target.setChildIndex(ar[i],i);
		}
		
		//対象のDisplayObjectの上にオブジェクトをaddする
		public function addChildOver(child:DisplayObject, brother:DisplayObject):void
		{
			var index:uint = _target.getChildIndex(brother);
			_target.addChildAt(child, index+1);
		}
		
		//対象のDisplayObjectの下にオブジェクトをaddする
		public function addChildUnder(child:DisplayObject, brother:DisplayObject):void
		{
			var index:uint = _target.getChildIndex(brother);
			_target.addChildAt(child, index);
		}
		
		/*
		----------------------------------------------------------------------
		
		----------------------------------------------------------------------
		*/
		
		
		
		/** target display object that DisplayObjectHelper access */
		public function get target():Sprite
		{
			return _target
		}
		
		public function set target(sprite:Sprite):void
		{
			if(sprite == _target) return
			
			if(_target != null){
				//remove all listeners
				_target.removeEventListener(Event.ADDED, _added)
				_target.removeEventListener(Event.REMOVED, _removed)
				
				//MouseEvent
				_target.removeEventListener(MouseEvent.CLICK, _click)
				_target.removeEventListener(MouseEvent.DOUBLE_CLICK, _doubleClick)
				_target.removeEventListener(MouseEvent.ROLL_OVER, _rollOver)
				_target.removeEventListener(MouseEvent.ROLL_OUT,_rollOut)
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDown)
				_target.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp)
				_target.removeEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel)
				_target.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMove)
				
				_target.removeEventListener(Event.ENTER_FRAME, _enterFrame)
				
				SketchBook.stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp)
				SketchBook.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _keyDown)
				SketchBook.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _keyUp)
				SketchBook.stage.removeEventListener(Event.RESIZE, _resize);
			}
			
			_target = sprite
			
			if(_target != null){
				_graphicsHelper = new GraphicsHelper(target.graphics)
				
				//ここはイベントハンドラ関数を定義した瞬間に、リスナ登録する方向に変更する予定
				
				//GeneralEvent
				_target.addEventListener(Event.ADDED, _added, false, 0, true)
				_target.addEventListener(Event.REMOVED, _removed, false, 0, true)
				
				//MouseEvent
				_target.addEventListener(MouseEvent.CLICK, _click, false, 0, true)
			}
		}
		
		/*
		----------------------------------------------------------------------
		event handler functions
		----------------------------------------------------------------------
		*/
		
		//store public handler functions
		private var _onKeyDownFunc:Function		
		private var _onKeyUpFunc:Function			
		private var _onEnterFrameFunc:Function		
		private var _onDoubleClickFunc:Function	
		private var _onMouseMoveFunc:Function
		private var _onRollOverFunc:Function
		private var _onRollOutFunc:Function
		private var _onMouseDownFunc:Function
		private var _onMouseWheelFunc:Function
		private var _onResizeFunc:Function
		
		/**
		 * キーがプレスされたときに呼ばれるイベントハンドラを定義できます。
		 * <p>イベント発行時にハンドラにはkeyCode:Numberが渡されます。</p>
		 */
		 
		public function set onKeyDown(func:Function):void
		{
			initEventHandler( func, "_onKeyDownFunc", SketchBook.stage, KeyboardEvent.KEY_DOWN, _keyDown);
		}
		
		public function get onKeyDown():Function
		{
			return _onKeyDownFunc
		}
		
		private function _keyDown(e:KeyboardEvent):void
		{
			if(_onKeyDownFunc!=null)
				_onKeyDownFunc(e.keyCode);
		}
		
		
		/**
		 * キーがリリースされたときに呼ばれるイベントハンドラを定義できます。
		 * <p>イベント発行時にハンドラにはkeyCode:Numberが渡されます。</p>
		 */
		
		public function set onKeyUp(func:Function):void
		{
			initEventHandler( func, "_onKeyUpFunc", SketchBook.stage, KeyboardEvent.KEY_UP, _keyUp);
		}
		
		public function get onKeyUp():Function
		{
			return _onKeyUpFunc
		}
		
		private function _keyUp(e:KeyboardEvent):void
		{
			if(_onKeyUpFunc!=null)
				_onKeyUpFunc(e.keyCode);
		}
		
		
		/**
		 * 毎フレーム呼ばれるイベントハンドラを定義できます。
		 */
		public function set onEnterFrame(func:Function):void
		{
			initEventHandler( func, "_onEnterFrameFunc", _target, Event.ENTER_FRAME, _enterFrame);
		}
		
		/** Event.ENTER_FRAMEに対応するコールバック */
		public function get onEnterFrame():Function
		{
			return _onEnterFrameFunc
		}
		
		private function _enterFrame(e:Event):void
		{
			if(onEnterFrame!=null)
				onEnterFrame()
		}
		
		
		/**
		 * ダブルクリックにに呼ばれるイベントハンドラを定義できます。
		 */
		public function set onDoubleClick(func:Function):void
		{
			_target.doubleClickEnabled = (func==null)? false : true	
			initEventHandler( func, "_onDoubleClickFunc", _target, MouseEvent.DOUBLE_CLICK, _doubleClick);
		}
		
		public function get onDoubleClick():Function
		{
			return _onDoubleClickFunc
		}
		
		private function _doubleClick(e:MouseEvent):void
		{
			if(onDoubleClick!=null)
				onDoubleClick()
		}
		
		/**
		 * MouseEvent.MOUSE_MOVEに対応するコールバック。
		 */
		public function set onMouseDown(func:Function):void
		{
			initEventHandler( func, "_onMouseDownFunc", _target, MouseEvent.MOUSE_DOWN, _mouseDown);
		}
		
		/** Event.ENTER_FRAMEに対応するコールバック */
		public function get onMouseDown():Function
		{
			return _onMouseDownFunc
		}
		
		
		/**
		 * MouseEvent.MOUSE_MOVEに対応するコールバック。
		 */
		public function set onMouseMove(func:Function):void
		{
			initEventHandler( func, "_onMouseMoveFunc", _target, MouseEvent.MOUSE_MOVE, _mouseMove);
		}
		
		/** Event.ENTER_FRAMEに対応するコールバック */
		public function get onMouseMove():Function
		{
			return _onMouseMoveFunc
		}
		
		private function _mouseMove(e:MouseEvent):void
		{
			if(onMouseMove!=null)
				onMouseMove()
		}
		
		
		/**
		 * MouseEvent.MOUSE_MOVEに対応するコールバック。
		 */
		public function set onRollOver(func:Function):void
		{
			initEventHandler( func, "_onRollOverFunc", _target, MouseEvent.ROLL_OVER, _rollOver);
		}
		
		/** Event.ENTER_FRAMEに対応するコールバック */
		public function get onRollOver():Function
		{
			return _onRollOverFunc
		}
		
		private function _rollOver(e:MouseEvent):void
		{
			if(onRollOver!=null)
				onRollOver()
		}
		
		
		/** MouseEvent.ROLL_OUTに対応するコールバック */
		public function set onRollOut(func:Function):void
		{
			initEventHandler( func, "_onRollOutFunc", _target, MouseEvent.ROLL_OUT, _rollOut);
		}
		
		public function get onRollOut():Function
		{
			return _onRollOutFunc
		}
		
		private function _rollOut(e:MouseEvent):void
		{
			if(onRollOut!=null)
				onRollOut()
		}
		
		
		/** 
		 * MouseEvent.MOUSE_WHEELに対応するコールバック。
		 * <p>関数には回転量<code>delta:Number</code>が渡される。</p>
		 **/
		public function set onMouseWheel(func:Function):void
		{
			initEventHandler( func, "_onMouseWheelFunc", _target, MouseEvent.MOUSE_WHEEL, _mouseWheel);
		}
		
		public function get onMouseWheel():Function
		{
			return _onMouseWheelFunc
		}
		
		private function _mouseWheel(e:MouseEvent):void
		{
			if(onMouseWheel!=null)
				onMouseWheel(e.delta)
		}
		
		/** ステージがリサイズされたら呼ばれるコールバック */
		public function set onResize(func:Function):void
		{
			initEventHandler( func, "_onResizeFunc", SketchBook.stage, Event.RESIZE, _resize);
		}
		
		public function get onResize():Function
		{
			return _onResizeFunc
		}
		
		private function _resize(e:Event):void
		{
			if(onResize!=null)
				onResize()
		}
		
		
		//イベントハンドラ関数の設定を行うまとめ部分
		private function initEventHandler(eventHandler:Function, propName:String, eventTarget:Object, type:String, internalHandler:Function):void
		{
			if(eventHandler == this[propName])
				return
				
			eventTarget.removeEventListener(type, internalHandler);
				
			this[propName] = eventHandler
				
			if(eventHandler!=null)
				eventTarget.addEventListener(type, internalHandler, false, 0, true);
		}
		
		/*
		----------------------------------------------------------------------
		internal event handler
		----------------------------------------------------------------------
		*/
		
		private function _added(e:Event):void
		{
			if(onAdded!=null)
				onAdded()
		}
		
		
		
		private function _removed(e:Event):void
		{
			if(onRemoved!=null)
				onRemoved()
		}
		
		private function _click(e:MouseEvent):void
		{
			if(onClick!=null)
				onClick()
		}
		
		
		private function _mouseDown(e:MouseEvent):void
		{
			SketchBook.stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUp, false, 0, true)
			if(onMouseDown!=null)
				onMouseDown()
		}
		
		private function _mouseUp(e:MouseEvent):void
		{
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp)
			if(onMouseUp!=null)
				onMouseUp()
		}
	}
}