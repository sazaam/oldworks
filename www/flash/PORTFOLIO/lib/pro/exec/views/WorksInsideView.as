package pro.exec.views 
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import gs.TweenLite;
	import of.app.required.context.XContext;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.modules.WorksInsideModule;
	import pro.exec.steps.CustomStep;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	import tools.geom.matrix.GridMatrix;
	import tools.grafix.Draw;
	
	/**
	 * ...
	 * @author saz
	 */
	public class WorksInsideView extends View 
	{
		private var __grid:GridMatrix;
		private var contentHeight:int;
		private var __index:int;
		private var wraps:Array;
		private var __currentIndex:Number;
		private var __max:int;
		private var numRows:int;
		
		public function WorksInsideView(module:WorksInsideModule) 
		{
			super(module) ;
		}
		public function treatWorks(cond:Boolean = true):void 
		{
			var parentContent:Sprite = XContext.$get('#contentWorks')[0] ;
			//var colorMatrixFilter:ColorMatrixFilter =  new ColorMatrixFilter(BlackAndWhiteColorMatrix);
			if (cond) {
				if(CustomStep(module.step.parent).module.workingStep.currentStep.id != module.step.id) CustomStep(module.step.parent).module.workingStep.launch(module.step.id) ;
				//parentContent.tabEnabled = false ;
				//parentContent.tabChildren = false ;
				//parentContent.alpha = .15 ;
				//parentContent.filters = [colorMatrixFilter] ;
				//parentContent.
				CustomStep(module.step.parent).checkBackground(false) ;
				parentContent.visible = false ;
			}else {
				parentContent.visible = true ;
				//parentContent.alpha = 1 ;
				//parentContent.filters = [] ;
				//parentContent.tabChildren = true ;
				//parentContent.tabEnabled = false ;
				CustomStep(module.step.parent).checkBackground() ;
				setFocus('enterWorks_' + module.step.id) ;
			}
		}
		private function setContent(cond:Boolean = true):Sprite 
		{
			if (cond) {
				return XContext.$get(Sprite).attr({id:'contentInsideWorks', name:'contentInsideWorks'}).appendTo(minFrame)[0] ;
			}else {
				return null ;
			}
		}
		private function getContent():Sprite 
		{
			return XContext.$get('#contentInsideWorks')[0] ;
		}
		public function worksInside(cond:Boolean = true):void 
		{
			if (cond) {
				trace('Opening Inside Works') ;
				content = setContent() ;
				var indY:int = depthNav.y  + depthNav.height * 2;
				contentHeight = execModel.minFrame.height + Math.abs(indY) * 3 ;
				content.y = indY ;
				content.graphics.beginFill(0xCCCCCC, 0) ;
				content.graphics.drawRect(0, 0, execModel.minFrame.width, contentHeight) ;
				content.graphics.endFill() ;
				applyDropShadow(content) ;
				TweenLite.killTweensOf(content) ;
				TweenLite.to(content, .25, { alpha:1 } ) ;
			}else {
				trace('Closing Inside Works') ;
				content = getContent() ;
				TweenLite.killTweensOf(content) ;
				TweenLite.to(content, .25, { alpha:0, onComplete:function():void {
					content.parent.removeChild(content) ;
					applyDropShadow(content, false) ;
					content = setContent(false) ;
				}})
			}
		}
		public function showGrid(cond:Boolean = true):void 
		{
			var step:CustomStep = module.step ;
			if (cond) {
				var len:int = module.step.numChildren ;
				var rows:int = execModel.grid.rows ;
				var cols:int = execModel.grid.cols ;
				var totalrows:int = Math.ceil(len/cols) ;
				__grid = new GridMatrix(cols, totalrows , len) ;
				var focusGrid:GridMatrix = __grid.getSubMatrix(cols, rows) ;
				len = focusGrid.concatenatedLength ;
				wraps = module.workingStep.userData.wraps =  [] ;
				content.visible = false ;
				for (var i:int = 0 ; i < len ; i ++ ) {
					var smart:Smart = createWrapSmart(i) ;
					wraps[wraps.length] = content.addChild(smart) ;
				}
			}else {
				removeWrapSmarts() ;
			}
		}
		
		private function removeWrapSmarts():void 
		{
			var step:CustomStep = module.step ;
			var len:int = content.numChildren ;
			for (var i:int = 0 ; i < len ; i ++ ) {
				var smart:Smart = getAtIndex(i) ;
				content.removeChild(smart) ;
				wraps[i] = Smart(smart).destroy() ;
			}
		}
		
		private function createWrapSmart(ind:int):Smart 
		{
			var names:Array = ['prev', 'current', 'next'] ;
			var s:Smart ;
			if (ind > module.step.length - Array.length) {
				s = new Smart() ;
				s.mouseEnabled = false ;
			}else {
				s = new BehaviorSmart() ;
				s.tabIndex = focusIndex ++ ;
			}
			s.name = 'wrap_' + ind ;
			s.mouseChildren = false ;
			s.focusRect = false ;
			s.buttonMode = true ;
			var pos:Point = getPos(ind) ;
			var rows:int = execModel.grid.rows ;
			var cols:int = execModel.grid.cols ;
			var totalDisplay:int = rows * cols ;
			var margin:int = execModel.grid.margin ;
			var marginBlock:int = 20 ;
			var unitWidth:int = (execModel.minFrame.width - (marginBlock*2) - (margin*(cols - 1))) / cols ;
			var unitHeight:int = 200 ;
			var col:uint = execModel.colors.main ;
			var colOver:uint = execModel.colors.mainOver ;
			var extraCol:uint = execModel.colors.extra ;
			var extraColOver:uint = execModel.colors.extraOver ;
			Draw.draw('rect', { g:s.graphics, color:col, alpha:0 }, 0, 0, unitWidth, unitHeight) ;
			var title:TextField = s.properties.title = XContext.$get(execModel.numberItem_TFXML)[0] ;
			title.x = 0 ;
			title.y = 25 ;
			var titleFmt:TextFormat = s.properties.titleFmt = title.defaultTextFormat ;
			titleFmt.leftMargin = titleFmt.rightMargin = 15 ;
			titleFmt.align = 'center' ;
			title.width = unitWidth ;
			title.wordWrap = true ;
			titleFmt.size = 60 ;
			titleFmt.color = col ;
			var desc:TextField = s.properties.desc = XContext.$get(execModel.simpleLinkTFXML)[0] ;
			desc.x = 0 ;
			desc.y = 150 ;
			desc.width = unitWidth ;
			desc.wordWrap = true ;
			var descFmt:TextFormat = s.properties.descFmt = desc.defaultTextFormat ;
			descFmt.size = 16 ;
			descFmt.align = 'center' ;
			descFmt.color = col ;
			
			s.addChild(title) ;
			s.addChild(desc) ;
			
			
			var string:String = String(ind+1) ;
			var ref:String = s.properties.ref = string ;
			
			s.properties.s = s ;

			s.properties.setText = function(str:String):void {
				this.title.text = str ;
				this.title.setTextFormat(this.titleFmt) ;
			}
			s.properties.enable = function(cond:Boolean = true):void {
				s.visible = cond ;
				if (cond) Draw.redraw('rect', { g:this.childline.graphics, color:col, alpha:.35 }, 0, 0 , unitWidth, 1) ;
				this.titleFmt.color = col ;
			}
			s.properties.fill = function(cond:Boolean = true):void {
				if (cond) {
					this.titleFmt.color = this.descFmt.color = colOver ;
				}else {
					this.titleFmt.color = this.descFmt.color = col ;
				}
				this.title.setTextFormat(this.titleFmt) ;
				this.desc.setTextFormat(this.descFmt) ;
			}
			s.properties.setDescText = function(str:String):void {
				this.desc.text = str ;
				this.desc.setTextFormat(this.descFmt) ;
			}
			s.properties.fillXML = function(item:XML):void {
				s.properties.setDescText(item.@label.toXMLString()) ;
			}
			s.properties.enable(false) ;
			s.properties.fill(false) ;
			var childline:Shape = s.properties.childline = new Shape() ;
			childline.y = 110 ;
			s.addChild(childline) ;
			
			var focus:Shape = s.properties.focus = new Shape() ;
			s.addChild(focus) ;
			s.properties.highlightSelected = function(cond:Boolean = true):void {
				this.entered = cond ;
				highlightSelection(s.properties.focus.graphics, unitWidth, unitHeight, cond) ;
			}
			s.properties.highlightSelected(false) ;
			s.properties.show = function(cond:Boolean = true):void {
				if (cond) {
					this.s.alpha = 1 ;
					this.highlightSelected(cond) ;
				}else {
					this.s.alpha = .35 ;
					this.highlightSelected(cond) ;
				}
			}
			s.properties.over =  function(cond:Boolean = true):void {
				if (cond) {
					if (this.s.alpha != 1) this.s.alpha = 1 ;
					this.fill() ;
				}else {
					if (this.s.alpha != .35) this.s.alpha = .35 ;
					this.fill(false) ;
				}
			}
			
			s.properties.over(false) ;
			
			s.properties.leave =  function(cond:Boolean = true):void {
				execController.launchUp() ;
			}
			s.properties.passUp =  function():void {
				var sm:Smart ;
				var dif:int = -3 ;
				var underNumber:Boolean = __max < totalDisplay ;
				var max:int =  totalDisplay ;
				var newIndex:int = -1 ;
				if ((__currentIndex + dif) < 0) {
					shift(dif) ;
					sm = getCurrent() ;
					newIndex = __currentIndex ;
				}else {
					sm = getAtIndex(__currentIndex + dif) ;
					newIndex = __currentIndex + dif ;
				}
				module.workingStep.launch(grid.concatenatedMatrix[newIndex]) ;
			}
			s.properties.passDown =  function():void {
				var sm:Smart ;
				var dif:int = 3 ;
				var underNumber:Boolean = __max < totalDisplay ;
				var max:int =  underNumber ? __max + 1 : totalDisplay ;
				var newIndex:int = -1 ;
				if ((__currentIndex + dif) > max - 1) {
					shift(dif) ;
					sm = getCurrent() ;
					newIndex = __currentIndex ;
				}else {
					sm = getAtIndex(__currentIndex + dif) ;
					newIndex = __currentIndex + dif ;
				}
				module.workingStep.launch(grid.concatenatedMatrix[newIndex])
			}
			s.properties.enter =  function(cond:Boolean = true):void {
				if (this.entered) {
					execController.launchDown(module.workingStep.currentStep.id) ;
				}else {
					var focusMatrix:GridMatrix = __grid.getSubMatrix(cols, rows) ;
					var p:Point = getPos(int(this.ref) - 1) ;
					module.workingStep.launch(module.workingStep.gates.merged[__grid.GetValue(p.y, p.x)]) ;
				}
			}
			s.properties.next =  function(cond:Boolean = true):void {
				execController.launchNext() ;
			}
			s.properties.prev =  function(cond:Boolean = true):void {
				execController.launchPrev() ;
			}
			
			
			
			
			
			
			s.properties.select =  function(item:XML, index:int, cond:Boolean = true):void {
				if (cond) {
					var sm:Smart ;
					var focusMatrix:GridMatrix = __grid.getSubMatrix( cols, rows ) ;
					var onAllIndex:int = grid.concatenatedMatrix.indexOf(index) ;
					var onDisplayIndex:int = focusMatrix.concatenatedMatrix.indexOf(index) ;
					
					if (onDisplayIndex == -1) {
						var dif:int = onAllIndex - __currentIndex ;
						shift(dif) ;
						var newFocusMatrix:GridMatrix = __grid.getSubMatrix( cols, rows ) ;
						var newDisplayIndex:int = newFocusMatrix.concatenatedMatrix.indexOf(index) ;
						sm = getAtIndex(newDisplayIndex) ;
						sm.properties.highlightSelected() ;
						setFocus(sm) ;
						__currentIndex = newDisplayIndex ;
					}else {
						sm = getAtIndex(onDisplayIndex) ;
						sm.properties.highlightSelected() ;
						setFocus(sm) ;
						__currentIndex = onDisplayIndex ;
					}
				}else {
					getCurrent().properties.highlightSelected(false) ;
					setFocus() ;
				}
			}
			
			s.x = marginBlock + (unitWidth + margin) * pos.x ;
			s.y = (unitHeight + margin) * pos.y ;
			return s ;
		}
		public function initGrid(max:int):void 
		{
			var start:int = (max < 8) ? 1 : 4 ;
			numRows = Math.ceil(max / 3) ;
			if (numRows < 3) {
				var h:int = execModel.minFrame.height ;
				var uH:int = 200 ;
				content.y = (h - (uH*numRows)) >> 1  ;
			}
			
			__max = max ;
			__currentIndex = start ;
			shift( -__currentIndex) ;
			content.visible = true ;
		}
		public function getPos(n:int):Point
		{
			var cols:int = execModel.grid.cols ;
			var indY:int = n / cols ;
			var indX:int = n % cols ;
			return new Point(indX, indY) ;
		}
		public function getIndex(p:Point):int
		{
			var cols:int = execModel.grid.cols ;
			var indX:int = p.x ; 
			var indY:int = p.y ; 
			return (indY * cols) + (indX);
		}
		public function getAtIndex(n:int):Smart { return Smart(wraps[n]) }
		public function getCurrent():Smart { return getAtIndex(__currentIndex) }
		private function displayChanges():void 
		{
			var cols:int = execModel.grid.cols ;
			var rows:int = execModel.grid.rows ;
			var focusMatrix:GridMatrix = __grid.getSubMatrix(cols, rows) ;
			var l:int = wraps.length ;
			for (var i:int = 0 ; i < l ; i++ ) {
				if (i > __max) {
					continue ;
				}else {
					var smart:Smart = Smart(wraps[i]) ;
					var n:int = focusMatrix.concatenatedMatrix[i] + 1 ;
					smart.properties.setText(String(n)) ;
					smart.properties.fillXML(module.step.xml.child('section')[focusMatrix.concatenatedMatrix[i]]) ;
					smart.properties.over(false) ;
				}
			}
		}
		public function boostSmart(item:XML, smart:Smart):void 
		{
			
			
			
		}
		public function centerFromOutSide(index:int):Boolean
		{
			return center(__currentIndex) ;
		}
		
		private function center(ind:int):Boolean
		{
			var cols:int = execModel.grid.cols ;
			var rows:int = execModel.grid.rows ;
			var focusMatrix:GridMatrix = __grid.getSubMatrix(cols, rows) ;
			var p:Point = getPos(ind) ;
			var pC:Point = new Point(1, 1) ;
			var colstoShift:int = p.x - pC.x ;
			var rowstoShift:int = p.y - pC.y ;
			
			if (colstoShift != 0 || rowstoShift != 0) {
				shiftRow(rowstoShift) ;
				shift(colstoShift) ;
				getCurrent().properties.highlightSelected(false) ;
				return true ;
			}
			return false ;
		}
		public function shift(n:int):void { __grid.shiftCol(n) ; displayChanges() }
		public function shiftRow(n:int):void{__grid.shiftRow(n) ; displayChanges() }
		public function nextCol():void { __grid.shiftCol(1) ; displayChanges() }
		public function prevCol():void { __grid.shiftCol(-1) ; displayChanges() }
		public function nextRow():void { __grid.shiftRow(+1) ; displayChanges() }
		public function prevRow():void { __grid.shiftRow(-1) ; displayChanges() }
		public function get grid():GridMatrix { return __grid }
	}

}