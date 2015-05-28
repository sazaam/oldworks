package testing 
{
	import fl.motion.DynamicMatrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	import tools.geom.matrix.GridMatrix;
	import tools.grafix.Draw;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestMatrixArray extends Sprite 
	{
		
		private var matrix:GridMatrix;
		private var focusMatrix:GridMatrix;
		
		private var unitHeight:int;
		private var unitWidth:int;
		private var margin:int;
		private var cols:int;
		private var rows:int;
		private var length:int;
		private var rowsDisplayLimit:int;
		private var __index:int;
		private var container:Sprite;
		private var rowContainers:Array;
		private var smarts:Array;
		static private var focusIndex:int;
		
		
		public function TestMatrixArray() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage)
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init() ;
		}
		
		private function init():void 
		{
			initStage() ;
			initParams() ;
			initMatrix() ;
			initContainer() ;
			initSmarts() ;
			shift(-__index) ;
			highlight(__index) ;
		}
		
		private function initStage():void 
		{
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
		}
		private function initParams():void 
		{
			rowsDisplayLimit = 3 ;
			__index = 4 ;
			unitWidth = 200 ;
			unitHeight = 200 ;
			margin = 1 ;
		}
		private function initContainer():void 
		{
			container = new Sprite() ;
			smarts = [] ;
			rowContainers = [] ;
			addChild(container) ;
			stage.addEventListener(KeyboardEvent.KEY_UP, onStagePress, true) ;
			stage.addEventListener(MouseEvent.CLICK, onStageClick, true) ;
		}
		private function initSmarts():void 
		{
			var rowContainer:Sprite ;
			var rows:int = rowsDisplayLimit ;
			var cols:int = matrix.GetWidth() ;
			
			
			for (var i:int = 0 ; i <  rows; i ++ ) {
				rowContainer = new Sprite() ;
				for (var j:int = 0 ; j < cols ; j ++ ) {
					var ind:int = (cols * i) + (j) ;
					var smart:Smart = new Smart() ;
					smart.properties.smart = smart ;
					var tf:TextField = smart.properties.tf = new TextField() ;
					var fmt:TextFormat = smart.properties.fmt = tf.getTextFormat() ;
					fmt.color = 0X2A2A2A ;
					fmt.size = 100 ;
					fmt.font = 'Arial' ;
					tf.autoSize = 'left' ;
					tf.cacheAsBitmap = true ;
					tf.alpha = .05 ;
					smart.tabIndex = focusIndex ++ ;
					smart.mouseChildren = false ;
					smart.name = 'smart_' + ind ;
					Draw.draw('rect', { g:smart.graphics, color:0xFFFFFF, alpha:.3 }, 0, 0, unitWidth, unitHeight) ;
					smart.x = (unitWidth + margin) * j ;
					var focusEffect:Sprite = smart.properties.focusEffect = new Sprite() ;
					Draw.draw('rect', { g:focusEffect.graphics, color:0xFF0000, alpha:.3 }, 0, 0, unitWidth, unitHeight) ;
					
					smart.properties.fill = function(ref:String):void {
						this.tf.text = '#' + ref ;
						this.tf.setTextFormat(this.fmt) ;
						this.tf.x = (unitWidth - this.tf.width) >> 1 ;
						this.tf.y = (unitHeight - this.tf.height) >> 1 ;
					}
					smart.properties.focus = function(cond:Boolean = true):void {
						this.focusEffect.visible = cond ;
					}
					smart.properties.highlight = function(cond:Boolean = true):void {
						this.focus( cond? true : false ) ;
					}
					smart.properties.highlight(false) ;
					smart.properties.fill(String(ind)) ;
					smart.addChild(tf);
					smart.addChild(focusEffect) ;
					smarts.push(rowContainer.addChild(smart)) ;
				}
				rowContainer.y = (unitHeight + margin) * i ;
				rowContainers.push(container.addChild(rowContainer)) ;
			}
		}
		private function initMatrix():void 
		{
			length = 49 ;
			cols = 3 ;
			rows = Math.ceil(length / cols) ;
			matrix = new GridMatrix(cols, rows, length) ;
		}
		private function onStageClick(e:MouseEvent):void 
		{
			var n:int = e.target.name.replace('smart_', '') ;
			trace(n == __index) ;
			highlight(n) ;
		}
		private function onStagePress(e:KeyboardEvent):void 
		{
			if (!Boolean(e.target is Smart)) {
				return ;
			}
			switch (e.keyCode) 
			{
				case Keyboard.UP:
					highlight('up') ;
				break;
				case Keyboard.DOWN:
					highlight('down') ;
				break;
				case Keyboard.LEFT:
					highlight('left') ;
				break;
				case Keyboard.RIGHT:
					highlight('right') ;
				break;
			}
		}
		
		private function highlight(way:String = ''):void 
		{
			getCurrent().properties.highlight(false) ;
			var p:Point = getPos(__index) ;
			var n:int ;
			switch (way) 
			{
				case 'up':
					if (p.y > 0) {
						p.y -- ;
					}else {
						prevRow()  ;
					}
				break ;
				case 'down':
					if (p.y < rowsDisplayLimit - 1) {
						p.y ++ ;
					}else {
						nextRow()  ;
					}
				break ;
				case 'left':
					if (p.x > 0 ) {
						p.x -- ;
					}else {
						p.x = rowsDisplayLimit - 1 ;
						if (p.y > 0) {
							p.y -- ; 
						}else {
							prevRow()  ;
						}
					}
				break ;
				case 'right':
					if (p.x < cols - 1) {
						p.x ++ ;
					}else {
						p.x = 0 ;
						if (p.y < rowsDisplayLimit - 1) {
							p.y ++ ; 
						}else {
							nextRow()  ;
						}
					}
				break;
				default :
					n = int(way) ;
					Smart(smarts[n]).properties.highlight() ;
					__index = n ;
					return ;
				break;
			}
			n = getIndex(p) ;
			Smart(smarts[n]).properties.highlight(true) ;
			__index = n ;
		}
		
		private function getPos(n:int):Point
		{
			var indY:int = n / cols ;
			var indX:int = n % cols ;
			return new Point(indX, indY) ;
		}
		private function getIndex(p:Point):int
		{
			var indX:int = p.x ; 
			var indY:int = p.y ; 
			
			return (indY * cols) + (indX);
		}
		private function getCurrent():Smart
		{
			return Smart(smarts[__index]) ;
		}
		private function displayChanges():void 
		{
			focusMatrix = matrix.getSubMatrix(cols, rowsDisplayLimit) ;
			var l:int = focusMatrix.concatenatedLength ;
			for (var i:int = 0 ; i < l ; i++ ) {
				var smart:Smart = Smart(smarts[i]) ;
				smart.properties.fill(focusMatrix.concatenatedMatrix[i]) ;
			}
		}
		private function shift(n:int):void { matrix.shiftCol(n) ; displayChanges() }
		private function nextCol():void { matrix.shiftCol(1) ; displayChanges() }
		private function prevCol():void { matrix.shiftCol(-1) ; displayChanges() }
		private function nextRow():void { matrix.shiftRow(+1) ; displayChanges() }
		private function prevRow():void { matrix.shiftRow(-1) ; displayChanges() }
	}
}