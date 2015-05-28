package pro.steps
{
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		public function CustomStep(__id:String, __xmlSections:XML) 
		{
			super(__id, new DifferedCommand(this, onStep, true), new Command(this, onStep, false)) ;
			xml = __xmlSections ;
		}
		
		private function onStep(cond:Boolean):void
		{
			trace(cond)
			if (cond) {
				trace('opening step id : ' + id + '   >>> path : ' + path)
				if (loaded) {
					resume() ;
				}else {
					if (xml.attribute('sections').length() != 0) {
						//trace('loading step id : ' + id + '   >>> path : ' + path)
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
				trace('closing step id : ' + id + '   >>> path : ' + path)
				resume(false) ;
			}
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
						cl = loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(s.attribute('class')[0].toXMLString())) ;
					}else {
						cl = CustomStep ;
					}
					add(new cl(s.attribute('id').toXMLString(), s)) ;
					
					//var nParentStep:CustomNavStep = CustomNavStep(NavHierarchy.instance.getDeep(NavHierarchy.instance.functions.id + '/' + path.replace(ancestor.id + '/', ''))) ;
					//nParentStep.add(new CustomNavStep(c, s)) ;
				}
			}
		}
		
		public function resume(cond:Boolean = true):void 
		{
			var layer:Layer ;
			if (cond) {
				layer = XContext.$get(Layer).attr( { id:"LAYER_"+id, name:"LAYER_"+id } )[0] ;
				Draw.draw("rect", { g:layer.graphics, color:0xFF0000, alpha:.23 }, 0, 0, 600, 400) ;
				XContext.$get('#content')[0].addChild(layer).addEventListener(MouseEvent.CLICK, onLayerClicked) ;				
				Root.user.console.log('opening step id : ' + id + '   >>> path : ' + path) ;
				
				DifferedCommand(commandOpen).dispatchComplete() ;
			}else {
				trace('closing step id : ' + id + '   >>> path : ' + path)
				Root.user.console.log('closing step id : ' + id + '   >>> path : ' + path) ;
				XContext.$get("#LAYER_" + id).remove()[0].removeEventListener(MouseEvent.CLICK, onLayerClicked) ;
			}
		}
		
		
		private function onLayerClicked(e:MouseEvent):void 
		{
			trace(this)
			if(gates.merged.length !=0) XExternalDialoger.instance.swfAddress.value = gates.merged[0].path.replace(ancestor.id+'/','') ;
		}
	}
}