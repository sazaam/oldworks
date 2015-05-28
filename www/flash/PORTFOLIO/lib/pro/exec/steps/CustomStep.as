package pro.exec.steps
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import of.app.required.commands.Command;
	import of.app.required.commands.DifferedCommand;
	import of.app.required.context.XContext;
	import of.app.required.dialog.AddressHierarchy;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.loading.XLoader;
	import of.app.required.steps.Hierarchy;
	import of.app.required.steps.HierarchyEvent;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import of.app.XConsole;
	import pro.exec.ExecuteController;
	import pro.exec.modules.Module;
	import pro.navigation.navmain.NavHierarchy;
	import pro.navigation.navmain.OverallNavigation;
	import tools.grafix.BloopEffect;
	import tools.grafix.Draw;
	import tools.layer.Layer;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class CustomStep extends VirtualSteps
	{
		private var __module:Module;
		private var bmpUID:uint;
		
		public function CustomStep(__id:String, __xmlSections:XML) 
		{
			super(__id, new DifferedCommand(this, onStep, true), new Command(this, onStep, false)) ;
			xml = __xmlSections ;
		}
		
		private function onStep(cond:Boolean):void
		{
			if (cond) {
				settings() ;
				if (loaded) {
					resume() ;
				}else {
					if (xml.attribute('sections').length() != 0) {
						load() ;
					}else {
						if (xml.child('section').length() != 0) {
							addSteps() ;
						}else {
							isFinal = true ;
						}
						resume() ;
					}
				}
			}else {
				resume(false) ;
				settings(false) ;
				reset() ;
			}
		}
		
		private function settings(cond:Boolean = true):void 
		{
			var changeable:Boolean ;
			if (cond) {	
				if (xml.attribute('color')[0]) {
					ExecuteController.instance.execModel.colors.main = xml.attribute('color')[0].toXMLString() ;
					changeable = true ;
				}
				if (xml.attribute('colorExtraOver')[0]) {
					ExecuteController.instance.execModel.colors.extraOver = xml.attribute('colorExtraOver')[0].toXMLString() ;
					changeable = true ;
				}
				if(changeable) ExecuteController.instance.execView.resetColor() ;
				
				checkBackground() ;
			}else {
				if (xml.attribute('color')[0]) {
					ExecuteController.instance.execModel.colors.main = (parent.xml.attribute('color')[0]) ? parent.xml.attribute('color')[0].toXMLString() : ExecuteController.instance.execModel.colors.defaultMain ;
					changeable = true ;
				}
				if (xml.attribute('colorExtraOver')[0]) {
					ExecuteController.instance.execModel.colors.extraOver = (parent.xml.attribute('colorExtraOver')[0]) ? parent.xml.attribute('colorExtraOver')[0].toXMLString() :ExecuteController.instance.execModel.colors.defaultExtraColorOver ;
					changeable = true ;
				}
				if(changeable) ExecuteController.instance.execView.resetColor() ;
				checkBackground(false) ;
			}
		}
		
		public function checkBackground(cond:Boolean = true):void 
		{
			if (xml.attribute('back')[0]) {
				if (cond) {
					bmpUID = setTimeout(ExecuteController.instance.loadSectionBmp, 800, xml.attribute('back')[0].toXMLString())
				}else {
					if (bmpUID != 0) 
					clearTimeout(bmpUID) ;
					ExecuteController.instance.loadSectionBmp(null, false) ;
				}
			}
		}
		
		private function reset():void 
		{
			 bmpUID = 0 ;
			 oldColor = 0 ;
		}
		
		public function load():void 
		{
			var loader:XLoader = new XLoader() ;
			var url:String = '../xml/' + xml.attribute('sections')[0].toXMLString() ;
			loader.addRequestByUrl(url) ;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				loader.removeEventListener(e.type, arguments.callee) ;
				var response:XML = loader.getAllResponses()[0] ;
				xml.appendChild(response.child('section')) ;
				xml['@sections'] = null ;
				delete xml['@sections'] ;
				addSteps() ;
				loaded = true ;
				resume() ;
			}) ;
			loader.load() ;
		}
		
		private function addSteps():void
		{
			if(xml.child('section').length() != 0){
				for each(var s:XML in xml.child('section')) {
					var cl:Class ;
					if (Boolean(s.attribute('class')[0])) {
						cl = Root.root.loaderInfo.applicationDomain.getDefinition(s.attribute('class')[0].toXMLString()) ;
					}else {
						cl = CustomStep ;
					}
					add(new cl(s.attribute('id').toXMLString(), s)) ;
				}
			}
		}
		
		public function resume(cond:Boolean = true):void 
		{
			
			var layer:Layer ;
			if (cond) {
				layer = XContext.$get(Layer).attr( { id:"LAYER_"+id, name:"LAYER_"+id, backgroundColor:ExecuteController.instance.execModel.colors.main, backgroundAlpha:0} )[0] ;
				XContext.$get('#content')[0].addChild(layer).addEventListener(MouseEvent.CLICK, onLayerClicked) ;				
				DifferedCommand(commandOpen).dispatchComplete() ;
			}else {
				XContext.$get("#LAYER_" + id).remove()[0].removeEventListener(MouseEvent.CLICK, onLayerClicked) ;
			}
		}
		
		
		private function onLayerClicked(e:MouseEvent):void 
		{
			if(gates.merged.length !=0) XExternalDialoger.instance.swfAddress.value = gates.merged[0].path.replace(ancestor.id+'/','') ;
		}
		
		
		public function get module():Module { return __module }
		public function set module(value:Module):void { __module = value }
	}
}