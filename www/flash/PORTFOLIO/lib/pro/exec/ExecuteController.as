package pro.exec 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import gs.TweenLite;
	import of.app.required.commands.Command;
	import of.app.required.dialog.AddressHierarchy;
	import of.app.required.loading.XAllLoader;
	import of.app.required.loading.XLoader;
	import of.app.required.steps.HierarchyErrorEvent;
	import of.app.required.steps.VirtualSteps;
	import of.app.XConsole;
	import of.app.XCustom;
	import pro.exec.events.ClickBehaviorEvent;
	import pro.exec.events.KeyBehaviorEvent;
	import pro.exec.modules.Module;
	import pro.exec.required.ArrowSmart;
	import pro.exec.views.View;
	import pro.exec.steps.CustomStep;
	import pro.exec.steps.HomeStep;
	import tools.fl.sprites.BehaviorSmart;
	import tools.fl.sprites.Smart;
	import tools.layer.Layer;
	/**
	 * ...
	 * @author saz
	 */
	public class ExecuteController
	{
		private static var __instance:ExecuteController;
		
		private var __view:ExecuteView;
		private var __model:ExecuteModel;
		private var __currentStep:CustomStep;
		private var BMPloader:XLoader;
		
		public function ExecuteController() 
		{
			__instance = this ;
		}
		
		public function init():ExecuteController 
		{
			__model = new ExecuteModel() ;
			__view = new ExecuteView() ;
			__view.init(__model, this) ;
			
			enableCore() ;
			
			return this ;
		}
		
		private function enableCore():void 
		{
			__view.target.stage.addEventListener(FocusEvent.FOCUS_IN, onNewFocus, true) ;
			__view.target.stage.addEventListener(FocusEvent.FOCUS_OUT, onNewFocus, true) ;
			
			__view.target.stage.addEventListener(MouseEvent.CLICK, onNewClick) ;
			__view.target.stage.addEventListener(MouseEvent.MOUSE_UP, onNewClick) ;
			__view.target.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageWheel, true) ;
			__view.target.stage.addEventListener(MouseEvent.ROLL_OVER, onNewClick, true) ;
			__view.target.stage.addEventListener(MouseEvent.ROLL_OUT, onNewClick, true) ;
			
			__view.target.stage.addEventListener(KeyboardEvent.KEY_DOWN, onNewPress, true) ;
			__view.render() ;
			
			AddressHierarchy.instance.changer.addEventListener(HierarchyErrorEvent.PATH_ERROR, onHierarchyPathError )
			
		}
		
		private function onHierarchyPathError(e:HierarchyErrorEvent):void 
		{
			var rightPath:String = e.currentPath || AddressHierarchy.instance.changer.home ;
			var layer404:Layer = new Layer(null, NaN, 0, { errorPath: rightPath ,actualPath:e.errorPath,  name: 'layer404' } ) ;
			execView.layerError(layer404) ;
			launchSection(rightPath) ;
			
			execView.stage.addEventListener(MouseEvent.CLICK, onLayerClick, false, 0, true) ;
		}
		
		private function onLayerClick(e:MouseEvent):void 
		{
			if (e.target == execView.getFocus()) return ;
			e.currentTarget.removeEventListener(MouseEvent.CLICK, onLayerClick) ;
			var layer404:Layer = Layer(e.currentTarget.getChildByName('layer404')) ;
			execView.layerError(layer404, false) ;
			layer404.destroy() ;
		}
		
		private function onStageWheel(e:MouseEvent):void 
		{
			if (!__currentStep) return ;
			if (!__currentStep.module.workingStep) return ;
			if (e.delta < 0) {
				if (e.delta < -3) return ;
				__currentStep.module.workingStep.next() ;
			}else {
				if (e.delta > 3) return ;
				__currentStep.module.workingStep.prev() ;
			}
		}
		
		private function onNewClick(e:MouseEvent):void 
		{
			var tg:EventDispatcher = e.target ;
			var concerned:Boolean = Boolean(tg is BehaviorSmart) ;
			if (!concerned) {
				switch (e.type) 
				{
					case MouseEvent.CLICK :
					case MouseEvent.MOUSE_UP :
						__view.setFocus(View.lastFocused) ;
					break;
				}
				
				return ;
			}
			
			var sm:BehaviorSmart = BehaviorSmart(tg) ;
			var ee:ClickBehaviorEvent ;
			switch (e.type) 
			{
				case MouseEvent.CLICK :
					ee = new ClickBehaviorEvent(ClickBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(ClickBehaviorEvent.CLICK)) ;
				break;
				case MouseEvent.DOUBLE_CLICK :
					ee = new ClickBehaviorEvent(ClickBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(ClickBehaviorEvent.DOUBLE_CLICK)) ;
				break;
				case MouseEvent.ROLL_OVER :
					if (!sm.properties.tabSelected) sm.properties.over(true) ;
					 return ;
				break;
				case MouseEvent.ROLL_OUT :
					if (!sm.properties.tabSelected)  sm.properties.over(false) ;
					 return ;
				break;
				case MouseEvent.MOUSE_UP :
					if (__view.getFocus() != sm) {
						__view.setFocus(View.lastFocused) ;
					}
					return ;
				break;
				default :
					ee = new ClickBehaviorEvent(ClickBehaviorEvent.ALL, Behavior.DEFAULT) ;
				break;
			}
			sm.dispatchEvent(ee) ;
		}
		
		private function onNewPress(e:KeyboardEvent):void 
		{
			var tg:EventDispatcher = e.target ;
			var concerned:Boolean = Boolean(tg is BehaviorSmart) ;
			if (!concerned) return ;
			
			var sm:BehaviorSmart = BehaviorSmart(tg) ;
			var ee:KeyBehaviorEvent ;
			switch (e.keyCode) 
			{
				case Keyboard.UP :
					ee = new KeyBehaviorEvent(KeyBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(KeyBehaviorEvent.UP)) ;
				break;
				case Keyboard.DOWN :
					ee = new KeyBehaviorEvent(KeyBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(KeyBehaviorEvent.DOWN)) ;
				break;
				case Keyboard.LEFT :
					ee = new KeyBehaviorEvent(KeyBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(KeyBehaviorEvent.LEFT)) ;
				break;
				case Keyboard.RIGHT :
					ee = new KeyBehaviorEvent(KeyBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(KeyBehaviorEvent.RIGHT)) ;
				break;
				case Keyboard.ENTER :
				case Keyboard.NUMPAD_0 :
				case Keyboard.NUMPAD_ENTER :
					ee = new KeyBehaviorEvent(KeyBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(KeyBehaviorEvent.ENTER)) ;
				break;
				case Keyboard.ESCAPE :
				case Keyboard.NUMPAD_9 :
					ee = new KeyBehaviorEvent(KeyBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(KeyBehaviorEvent.ESCAPE)) ;
				break;
				case Keyboard.SHIFT :
				case Keyboard.CONTROL :
					return ;
				break;
				default :
					ee = new KeyBehaviorEvent(KeyBehaviorEvent.ALL, Behavior.DEFAULT) ;
				break;
			}
			sm.dispatchEvent(ee) ;
		}
		
		private function onNewFocus(e:FocusEvent):void 
		{
			var tg:EventDispatcher = e.target ;
			var cond:Boolean = e.type == FocusEvent.FOCUS_IN ;
			var concerned:Boolean = Boolean(tg is BehaviorSmart) ;
			if (!concerned) return ;
			// if 'IN'
			var sm:BehaviorSmart = BehaviorSmart(tg) ;
			sm.properties.over(cond) ;
			sm.properties.tabSelected = cond ;
			if (cond) {
				sm.addEventListener(ClickBehaviorEvent.ALL,  onMouseEvent ) ;
				sm.addEventListener(KeyBehaviorEvent.ALL,  onKeyEvent ) ;
				sm.dispatchEvent(new ClickBehaviorEvent(ClickBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(ClickBehaviorEvent.FOCUS_IN)))
			}else {
				sm.dispatchEvent(new ClickBehaviorEvent(ClickBehaviorEvent.ALL, Behavior.getBehaviorCodeFromType(ClickBehaviorEvent.FOCUS_OUT)))
				sm.removeEventListener(KeyBehaviorEvent.ALL, onKeyEvent) ;
				sm.removeEventListener(ClickBehaviorEvent.ALL,  onMouseEvent ) ;
			}
		}
		
		private function onMouseEvent(e:ClickBehaviorEvent):void 
		{
			switch (e.clickCode) 
			{
				case Behavior.ENTER :
					e.target.properties.enter() ;
				break ;
				default:
					//trace('>>', Behavior.getBehaviorTypeFromCode(e.clickCode),' on ',  e.target , '		with clickCode : ', e.clickCode)
				break;
			}
		}
		
		private function onKeyEvent(e:KeyBehaviorEvent):void 
		{
			var tg:BehaviorSmart = e.target ;
			var p:Object = tg.properties ;
			switch (e.keyCode) 
			{
				case Behavior.ENTER :
					if(p.enter is Function) p.enter() ;
				break ;
				case Behavior.ESCAPE :
					if(p.leave is Function) p.leave() ;
				break ;
				case Behavior.PASS_UP:
					if(p.passUp is Function) p.passUp() ;
				break ;
				case Behavior.PASS_DOWN :
					if (p.passDown is Function) p.passDown() ;
				break ;
				case Behavior.NEXT:
					if(p.next is Function) p.next() ;
				break ;
				case Behavior.PREV :
					if(p.prev is Function) p.prev() ;
				break ;
				default:
					//trace('>>', Behavior.getBehaviorTypeFromCode(e.keyCode),' on ',  e.target , '		with keyCode : ', e.keyCode)
				break;
			}
		}
		
		private function onFrameWheel(e:MouseEvent):void 
		{
			if (e.delta > 0 && e.delta < 4) {
				launchPrev() ;
			}else if(e.delta < 0 && e.delta > -4){
				launchNext() ;
			}
		}
		
		public function startModule(module:Module, cond:Boolean = true):void 
		{
			if (cond) {
				module.beforeModule(true) ;
				__currentStep = module.step ;
				module.launch(cond) ;
			}else {
				module.launch(cond) ;
				__currentStep = (__currentStep.parent is CustomStep) ? __currentStep.parent : null ;
				module.beforeModule(false) ;
			}
		}
		public function launchSection(url:String):void 
		{
			AddressHierarchy.instance.changer.value = url ;
		}
		public function launchDown(url:String):void 
		{
			launchSection(AddressHierarchy.instance.changer.value +'/'+ url) ;
		}
		public function launchUp():void 
		{
			var url:String = AddressHierarchy.instance.changer.value.replace(/\/*[^\/]+\/*$/, '') ;
			if (url == '' ) {
				url = 'HOME' ;
			}
			launchSection(url) ;
		}
		public function launchPrev():void 
		{
			__currentStep.module.arrowPrev() ;
		}
		public function launchNext():void 
		{
			__currentStep.module.arrowNext() ;
		}
		
		public function get execView():ExecuteView { return __view }
		public function get execModel():ExecuteModel { return __model }
		public function get currentStep():CustomStep { return __currentStep }
		public function set currentStep(value:CustomStep):void { __currentStep = value}
		
		
		
		static public function get hasInstance():Boolean { return Boolean(__instance as ExecuteController)}
		static public function get instance():ExecuteController { return __instance || new ExecuteController()}
		static public function init():ExecuteController { return instance.init() }
		
		public function loadSectionBmp(url:String = null, cond:Boolean = true):void 
		{
			if (cond) {
				BMPloader = new XLoader() ;
				BMPloader.addEventListener(Event.OPEN, onLoadOpen) ;
				BMPloader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress) ;
				BMPloader.addEventListener(Event.COMPLETE, onBackLoadComplete) ;
				BMPloader.addRequestByUrl('../img/' + url) ;
				XCustom.instance.graphics.start() ;
				BMPloader.load() ;
			}else {
				if (BMPloader) {
					destroyLoader() ;
				}
				execView.setSectionImage(null, false ) ;
			}
		}
		
		private function onLoadProgress(e:ProgressEvent):void 
		{
			XCustom.instance.graphics.onIMGProgress(e) ;
		}
		
		private function onLoadOpen(e:Event):void 
		{
			
			XCustom.instance.graphics.onIMGOpen(e) ;
		}
		
		private function onBackLoadComplete(e:Event):void 
		{
			XCustom.instance.graphics.onIMGComplete(e) ;
			var bmp:Bitmap = Bitmap(BMPloader.getAllResponses()[0]) ;
			destroyLoader() ;
			execView.setSectionImage(bmp) ;
		}
		
		private function destroyLoader():void 
		{
			XCustom.instance.graphics.kill() ;
			
			BMPloader.removeEventListener(Event.OPEN, onLoadOpen) ;
			BMPloader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress) ;
			BMPloader.removeEventListener(Event.COMPLETE, onBackLoadComplete) ;
			BMPloader = BMPloader.destroy() ;
		}
	}

}