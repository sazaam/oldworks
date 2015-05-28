package naja.model.data.loaders 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import saz.defaults.loaders.DefaultLoaderGraphics;
	import naja.model.commands.Command;
	import naja.model.data.loaders.E.LoadEvent;
	import naja.model.data.loaders.E.LoadProgressEvent;
	import naja.model.data.loaders.I.ILoaderGraphics;
	import naja.model.data.loaders.I.IXLoader;
	import naja.model.steps.E.StepEvent;
	import naja.model.steps.Step;
	import naja.model.steps.VirtualSteps;
	/**
	 * ...
	 * @author saz
	 */

	/*
	 *  THE USE OF ALLOADER
	 * 
	 * 
	 * //////////////:FROM LOADER
	 * 
	public function SiteLoader()
	{
		$(stage).attr( { scaleMode: "noScale", align: "TL" } ) ;
		SitePathes.instance.init(loaderInfo) ;
		var allLoader:AllLoader = AllLoader.instance.init(this, new CustomLoaderGraphics(this), "from_loader" ) ;
		allLoader.add(SitePathes.toSWF+"main.swf", "main") ;
		addEventListener(Event.COMPLETE, onFinishLoadingFromLoader) ;
		allLoader.launch() ;
	}
	private function onFinishLoadingFromLoader(e:Event):void 
	{
		var allLoader:AllLoader = AllLoader.instance ;
		addChild(AllLoader.packages["MAIN"][0]) ;
	}
	 * 
	 * //////////////:FROM MAIN
	 * 
	public function Main()
	{
		$(this).bind(Event.ADDED_TO_STAGE, onStage)
	}
	private function onStage(e:Event):void
	{
		trace("MAIN INITED !!") ;
		$(this).unbind(e.type, arguments.callee) ;
		var tg:Sprite = Sprite(AllLoader.target) || this ;
		var allLoader:AllLoader = AllLoader.instance.init(tg, new CustomLoaderGraphics(tg) , "in_main") ;
		
		allLoader.add(SitePathes.toXML + "datas/data_sections.xml", "main_data_sections") ;
		allLoader.add(SitePathes.toIMG + "skash/motif.png", "back_motif") ;
		allLoader.add(SitePathes.toSWF + "library/arial.swf","Arial",true) ;
		allLoader.add(SitePathes.toSWF + "library/neo_tech_dacia_regular.swf","NeoTechDaciaRegular",true) ;
		allLoader.add(SitePathes.toSWF + "library/library_items.swf", "clips") ;
		tg.addEventListener(Event.COMPLETE, onFinishLoading) ;
		
		allLoader.launch() ;
	}
	private function onFinishLoading(e:Event):void
	{
		//trace("here are the loaded contents" + AllLoader.packages)
		//Tween Oblige
		new CommandQueue(Wait(500), new Command(this, init)).execute() ;
	}
	private function init():void
	{
		AllLoader.instance.clean() ;
		//trace(AllLoader.instance.list)
		var tg:Sprite = Sprite(AllLoader.target) || this ;
		tg.removeEventListener(Event.COMPLETE, onFinishLoading) ;
		trace("LOADINGS FINISHED") ;
		
		//for further use
		//tg.addEventListener(Event.COMPLETE, onFinishLoading2) ;
		
		// like dis
		
		//AllLoader.instance.clean() ;
		//AllLoader.instance.graphics = new DefaultLoaderGraphics(this) ;
		//AllLoader.id = "after_main" ;
		
		//	or like dis
		
		//AllLoader.instance.remove("fonts") ;
		//AllLoader.instance.remove("xml") ;
		//AllLoader.instance.remove("swf") ;
		//AllLoader.instance.remove("img") ;
		//AllLoader.instance.remove("in_main") ;
		//AllLoader.instance.graphics = new DefaultLoaderGraphics(this) ;
		//AllLoader.id = "after_main" ;
		
		// or even like dis
		//AllLoader.instance.init(this, new DefaultLoaderGraphics(this), "after_main")
		
		//AllLoader.instance.add(SitePathes.toXML + "videos.xml", "main_videos") ;
		//AllLoader.instance.add(SitePathes.toSWF + "tests/instinct.swf", "instinct") ;
		//
		//AllLoader.instance.launch() ;
	}
 */
	
	public class AllLoader 
	{
		////////////////////////////////////////////////////////////////////////////////////VARS
		static private var _instance:AllLoader ;
		protected var _scheme:XML ;
		protected var _target:DisplayObjectContainer ;
		protected var _loader:IXLoader ;
		protected var _graphics:ILoaderGraphics ;
		protected var _stepList:VirtualSteps ;
		static private var xmlLoader:XMLLoader;
		static private var fontsLoader:FontsLoader;
		static private var swfLoader:SWFLoader;
		static private var imgLoader:IMGLoader;
		static private var xLoader:XLoader;
		private static var _packages:Object = {} ;
		private var _idSequence:String;
		static private var _closure:Function;
		////////////////////////////////////////////////////////////////////////////////////CTOR
		public function AllLoader()
		{
			_instance = this ;
		}
		////////////////////////////////////////////////////////////////////////////////////INIT
		public function init(_tg:DisplayObjectContainer, __graphics:ILoaderGraphics = null, __idSequence:String = null):AllLoader
		{
			_idSequence = __idSequence ;
			if (!_target) {
				_scheme = XML(<scheme />) ;
				_target = _tg ;
				_graphics = _graphics? _graphics : __graphics ? __graphics : new LoaderGraphics(Sprite(_target)) ;
				_stepList = new VirtualSteps() ;
				generate() ;
			}else {
				clean() ;
			}
			
			return this ;
		}
		public function generate():void
		{
			_stepList = new VirtualSteps() ;
			
			xmlLoader = new XMLLoader() ;
			fontsLoader = new FontsLoader() ;
			swfLoader = new SWFLoader() ;
			imgLoader = new IMGLoader() ;
		}
		public function clean():void
		{
			if("fonts" in _scheme) remove("fonts") ;
			if("xml" in _scheme) remove("xml") ;
			if("swf" in _scheme) remove("swf") ;
			if ("img" in _scheme) remove("img") ;
			if (_stepList.length > 0) remove(String(VirtualSteps(_stepList.gates.merged[0]).id)) ;
			
			generate()
		}		
		private function clear(i:IXLoader):void
		{
			if (i.loader.hasEventListener(Event.COMPLETE)) {
				i.loader.removeEventListener(ProgressEvent.PROGRESS, onProgress) ;
				i.loader.removeEventListener(Event.COMPLETE, onComplete) ;
			}
		}
		////////////////////////////////////////////////////////////////////////////////////LOAD ALL
		public function launch():void {
			loadAll() ;
		}
		private function loadAll():void
		{
			sort() ;
			addSteps() ;
			lauchLoadings() ;
		}
		
		private function sort():void
		{
			var output:XML = XML(<scheme />) ;
			for each(var node:XML in _scheme.*) {
				for each(var same:XML in _scheme[node.localName()]) {
					var p:XML = same.copy() ;
					delete _scheme.*[same.childIndex()] ;
					output.appendChild(p) ;
				}
			}
			_scheme = output ;
		}
		
		private function lauchLoadings():void
		{
			_stepList.launch(0) ;
		}
		
		internal function addSteps():void
		{
			var o:Object = {} ;
			for each(var node:XML in _scheme.*)
			{
				var iLoader:IXLoader = IXLoader(getLoader(node)) ;
				if (node.localName() == "fonts" && !o["fonts"]) addStep(new VirtualSteps("fonts", new Command(null, load, iLoader))) ;
				if (node.localName() == "xml" && !o["xml"]) addStep(new VirtualSteps("xml", new Command(null, load, iLoader))) ;
				if (node.localName() == "swf" && !o["swf"]) addStep(new VirtualSteps("swf", new Command(null, load, iLoader))) ;
				if (node.localName() == "img" && !o["img"]) addStep(new VirtualSteps("img", new Command(null, load, iLoader))) ;
				
				iLoader.add(new MultiLoaderRequest(node.@url,node.@id)) ;
				o[node.localName()] = node.localName() ;
			}
			addStep(new VirtualSteps("closing" + (_idSequence ? ("_" + _idSequence) : ""), new Command(null, closeRequests))) ;
		}
		
		private function load(iLoader:IXLoader):void
		{
			
			if (iLoader is FontsLoader) {
				_graphics.loadFonts() ;
			}
			else if (iLoader is SWFLoader) {
				_graphics.loadSWF() ;
			}
			else if (iLoader is XMLLoader) {
				_graphics.loadXML() ;
			}
			else if (iLoader is IMGLoader) {
				_graphics.loadIMG() ;
			}
			
			iLoader.loader.addEventListener(ProgressEvent.PROGRESS, onProgress) ;
			iLoader.loader.addEventListener(Event.COMPLETE, onComplete) ;
			iLoader.loadAll() ;
			_loader = iLoader ;
		}
		
		private function onComplete(e:Event):void 
		{
			if (e.currentTarget == fontsLoader.loader) {
				_graphics.onFontsComplete(e) ;
			}
			else if (e.currentTarget == xmlLoader.loader) {
				_graphics.onXMLComplete(e) ;
			}
			else if (e.currentTarget == swfLoader.loader) {
				_graphics.onSWFComplete(e) ;
			}
			else if (e.currentTarget == imgLoader.loader) {
				_graphics.onIMGComplete(e) ;
			}
			
			if (_stepList.hasNext()) {
				_stepList.next() ;
			}
		}
		private function onStepClose(e:StepEvent):void 
		{
			if (e.currentTarget.id == "fonts") {
				clear(_loader) ;
			}
			else if (e.currentTarget.id == "xml") {
				clear(_loader) ;
			}
			else if (e.currentTarget.id == "swf") {
				clear(_loader) ;
			}
			else if (e.currentTarget.id == "img") {
				clear(_loader) ;
			}
			
			_loader = null ;
		}
		private function closeRequests():void
		{
			if(target.hasEventListener(Event.COMPLETE)) target.dispatchEvent(new Event(Event.COMPLETE)) ;
		}
		private function onProgress(e:ProgressEvent):void 
		{
			if (e.currentTarget == fontsLoader.loader) _graphics.onFontsProgress(e) ;
			if (e.currentTarget == xmlLoader.loader) _graphics.onXMLProgress(e) ;
			if (e.currentTarget == swfLoader.loader) _graphics.onSWFProgress(e) ;
			if (e.currentTarget == imgLoader.loader) _graphics.onIMGProgress(e) ;
		}
		
		private function getLoader(node:XML):IXLoader
		{
			var iLoader:IXLoader, n:String = node.localName() ;
			if (n == "xml")
			iLoader = xmlLoader ;
			else if (n == "fonts")
			iLoader = fontsLoader ;
			else if (n == "swf")
			iLoader = swfLoader ;
			else if (n == "img")
			iLoader = imgLoader ;
			
			return iLoader ;
		}
		////////////////////////////////////////////////////////////////////////////////////ADDSTEP
		static public function add(url:String, id:String = null, font:Boolean = false):void {
			_instance.add(url,id,font) ;
		}
		public function add(url:String,id:String,font:Boolean = false):void
		{
			var quickReg:RegExp = /.((jp(e)?g)|png|bmp|gif|xml|swf)$/i ;
			var ext:String = url.match(quickReg)[0] ;
			ext = ext.substr(1, ext.length - 1) ;
			if (!ext) throw(new ArgumentError(url + " is not a correct url")) ;
			if (ext.search(/((jp(e)?g)|png|bmp|gif)/) != -1) ext = "img" ;
			if (font && ext=="swf") ext = "fonts" ;
			var node:XML = XML("<" + ext + " id='" + id + "' url='" + url + "' />") ;
			if (font) node.@font = "true" ;
			_scheme.appendChild(node) ;
		}
		static public function remove(id:String = null):void {
			_instance.remove(id) ;
		}
		public function remove(id:String = null):void
		{
			if (id == null) {
				//removeStep("0") ; 
			}
			if (id in _stepList.gates) {
				removeStep(_stepList.gates[id]) ;
			}else if(Boolean(_stepList.gates["closing_"+id])){
				removeStep(_stepList.gates["closing_"+id]) ;
			}else {
				trace("Trying to Remove an inexisting Step.... AllLoader")
			}
		}
		////////////////////////////////////////////////////////////////////////////////////ADDSTEP
		internal function addStep(_step:VirtualSteps) :VirtualSteps
		{
			_step.addEventListener(StepEvent.CLOSE, onStepClose) ;
			return VirtualSteps(_stepList.add(_step)) ;
		}
		internal function removeStep(_step:VirtualSteps) :VirtualSteps
		{
			if (_step.id in _scheme) {
				delete _scheme[_step.id] ;
			}
			_step.removeEventListener(StepEvent.CLOSE,onStepClose)
			return VirtualSteps(_stepList.remove(_step)) ;
		}
		////////////////////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		
		static public function initialize(__closure:Function,_tg:Sprite,__graphics:Class,_id:String = null ,...args):void 
		{
			if (!_instance) __closure.apply(_closure, [_tg].concat(args)) ;
			AllLoader.instance.init(_tg, new __graphics(_tg), _id) ;
		}
		
		static public function get target():DisplayObjectContainer { return _instance ? _instance._target : null }
		static public function set target(_tg:DisplayObjectContainer):void { _instance._target = _tg }
		static public function get loader():IXLoader { return _instance._loader }
		static public function get instance():AllLoader	{ return _instance || new AllLoader() }
		static public function get id():String { return _instance._idSequence } 
		static public function set id(value:String):void { _instance._idSequence = value }
		public function get graphics():ILoaderGraphics { return _graphics }
		public function set graphics(value:ILoaderGraphics):void { _graphics = value }
		public function get list():VirtualSteps { return _stepList }
		public function get id():String { return _idSequence }
		public function set id(value:String):void { _idSequence = value }
		
		public function get scheme():XML { return _scheme }
		public function set scheme(value:XML):void 
		{ _scheme = value }
	}
	
}