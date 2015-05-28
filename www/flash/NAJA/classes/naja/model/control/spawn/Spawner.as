package naja.model.control.spawn 
{
	import begin.eval.Eval;
	import begin.eval.evaluate;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import naja.tools.steps.I.IVirtualSteps;
	/**
	 * ...
	 * @author saz
	 */
	public class Spawner extends EventDispatcher
	{
		//////////////////////////////////////////////////////// VARS
		static private var __instance:Spawner;
		static private var __licensed:Dictionary = new Dictionary() ;
		
		private var __stepClass:Class ;
		private var __scriptName:String;
		
		private var __pkg_ns:String;
		private var __className:String;
		private var __pkg_short_ns:String;
		
		private var __body:String;
		
		private var __class_ns:String;
		private var __extends_ns:String;
		private var __ext_pkg_ns:String;
		private var __ext_pkg_short_ns:String;
		private var __ext_className:String;
		private var __methods:Array;
		private var __vars:Array;
		private var __dependencies:Array;
		private var __implements:Array;
		
		
		private var __concated:String;
		private var __result:Class;
		
		private var __onComplete:Function;
		static private var __ind:int;
		static private var __lengthThreads:int;
		static private var __spawners:Array;
		//////////////////////////////////////////////////////// CTOR
		public function Spawner(scrName:String = null) 
		{
			__instance = this ;
			__licensed[this] = [] ;
			__scriptName = scrName ;
		}
		
		public function init(_class_ns:String, _extends_ns:String, _implements_str:String, _funcBody:String = '', _dependencies:Array = null, _methods:Array = null, _vars:Array = null):Spawner
		{
			if(knowsClass(this, _class_ns))
			{
				dispatchEvent(new Event(Event.COMPLETE)) ;
				return this;
			}
			// Class
			__class_ns = _class_ns ;
			var nsarr:Array = __class_ns.split('::') ;
			__className = nsarr[1] ;
			
			// Package
			__pkg_ns = nsarr[0] ;
			__pkg_short_ns = splitLast(__pkg_ns) ;
			
			
			// Extends
			__extends_ns = _extends_ns ;
			var extStr:String = '' ;
			var arrSplitExt:Array = __extends_ns.split('::') ;
			__ext_pkg_ns = arrSplitExt[0] ;
			__ext_pkg_short_ns = splitLast(__ext_pkg_ns) ;
			__ext_className = arrSplitExt[1] ;
			
			// Implements
			var impl:String = '' ;
			var impl_set:String = '' ;
			var arrImpl:Array = __implements = _implements_str.split(',') ;
			var l:int = arrImpl.length ;
			for (var i:int ; i < l ; i++ )
			{
				var implements_ns:String = arrImpl[i] ;
				var arrSplitImpl:Array = implements_ns.split('::') ;
				var impl_pkg_ns:String = arrSplitImpl[0] ;
				var impl_pkg_short_ns:String = splitLast(impl_pkg_ns) ;
				var impl_className:String = arrSplitImpl[1] ;
				impl += strNameSpace(impl_pkg_short_ns, impl_pkg_ns) ;
				impl_set += i==0? impl_className :', '+ impl_className ;
			}
			
			
			// Function Body
			__body = _funcBody ;
			
			
			// Dependencies
			__dependencies = _dependencies || [];
			var deps:String = '' ;
			var len:int = __dependencies.length ;
			for (var j:int = 0 ; j < len ; j ++ ) {
				var depArr:Array = __dependencies[j].split("::")
				var short:String = depArr[0] ;
				var shorten:String = splitLast(short) ;
				deps += strNameSpace(shorten, short);
			}
			
			
			// Vars
			__vars = _vars || [];
			var vs:String = __vars.join('\n') ;
			
			// Methods
			__methods = _methods || [];
			var meths:String = __methods.join('\n') ;
			
			//BUILD
			// Class new namespace
			var s:String = strNameSpace(__pkg_short_ns, __pkg_ns) ;
			// Extends
			if (__ext_className != null) {
				s += strNameSpace(__ext_pkg_short_ns, __ext_pkg_ns) ;
				extStr = " extends " + __ext_className ;
			}
			
			// Implements
			var implStr:String = '' ;
			if (Boolean(__implements[0])) {
				s += impl ;
				implStr = " implements " + impl_set ;
			}
			s += deps ;
			// Open Class, Extends & Implements
			s += '\n' + __pkg_short_ns + " class " + __className ;
			s += extStr ;
			s += implStr ;
			s += "{";
			// Methods
			s += meths +' \n';
			// Constructor
			s += '\n' + __pkg_short_ns +" function " + __className +"(...params) {" + __body +"}\n" ;
			// Vars
			s += vs +' \n';
			// Close Class
			s += "}" ;	
			
			
			
			__concated = s ;
			
			trace('++++++++++++++++++++++++++++++++++++')
			trace(__concated)
			trace('++++++++++++++++++++++++++++++++++++')
			
			return this ;
		}
		
		static private function splitLast(s:String):String 
		{
			var arr:Array = s.split('.') ;
			return arr[arr.length - Array.length] ;
		}
		
		static public function knowsClass(spawner:Spawner, namespaceClass:String):Boolean
		{
			return __licensed[spawner].indexOf(namespaceClass) != -1 ;
		}
		
		static private function strNameSpace(_short:String, _namespacePkg:String):String
		{
			return 'namespace ' + _short + ' = "' + _namespacePkg + '";\nuse namespace ' + _short + ';\n' ;
		}
		
		public static function parse(xml : XML, onScriptComplete : Function):Array
		{
			__ind = 0 ;
			__lengthThreads = 0 ;
			__spawners = [];
			var classes:XMLList = xml.child('class') ;
			var l:int = classes.length() ;
			__lengthThreads = l ;
			for each(var cl:XML in classes) {
				__spawners.push(createSpawn(cl, onScriptComplete));
			}
			next() ;
			return __spawners;
		}
		
		static private function next():void 
		{
			//trace('dependancies >>',Spawner(__spawners[__ind]).__dependencies)
			Spawner(__spawners[__ind]).evaluateScript() ;
			__ind++ ;
		}
		
		protected static function createSpawn(xml:XML, onScriptComplete:Function, auto : Boolean = false) : Spawner {
			var c:XML = xml;
			var mth:Array = [];
			var methXML:XMLList = c.child('method');
			var method:XML;
			for each(method in methXML)
				mth.push(method.toString());
			
			var varXML:XMLList = c.child('var');
			var vars:Array = [];
			var v:XML;
			for each(v in varXML)
				vars.push(v.toString());
			
			var depXML:XMLList = c.child('dependency');
			var deps:Array = [];
			var d:XML;
			for each(d in depXML)
				deps.push(d.attribute('ns'));
			
			var __sp : Spawner = new Spawner().init(c.attribute('ns'), c.attribute('extends'), c.attribute('implements'), c.child('constructor')[0].toString(), deps, mth, vars);
			__sp.addEventListener(Event.COMPLETE, onSPComplete);
			__sp.onComplete = onScriptComplete;
			
			return __sp;
		}
		
		static private function onSPComplete(e:Event):void 
		{
			if (__ind == __lengthThreads)
			{
				Spawner(e.target).onComplete(e) ;
			}else {
				next() ;
			}
		}
		
		public function evaluateScript():void
		{
			evaluate(concated, __scriptName , onScriptReady);
		}
		private function onScriptReady(e:Event):void 
		{
			__result = Eval(e.target).getEvalLoader().getDefinition(__class_ns) ;
			__licensed[this].push(__class_ns) ;
			dispatchEvent(new Event(Event.COMPLETE)) ;
		}
		static public function getDefinition(_lns:String):Class 
		{
			return $get('definition', _lns) as Class;
		}
		
		override public function toString():String
		{
			return '[Object Spawner >> handled class : '+ __class_ns +' extended class : '+ __extends_ns +']';
		}
		
		static private function $get(by:String, _lns:String):Object 
		{
			var list : Array ;
			var i : *;
			var len : int
			for (i in __licensed) {
				list = __licensed[i] ;
				if (list.indexOf(_lns)!=-1)
					return (by == 'definition')? i["result"] : i ;
			}
			return null ;
		}
		static public function getSpawner(_lns:String):Spawner 
		{
			return $get('spawner', _lns) as Spawner;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get instance():Spawner { return __instance || new Spawner() }
		static public function get hasInstance():Boolean { return  Boolean(__instance) }
		
		static public function get licensed():Dictionary { return __licensed; }
		static public function set licensed(value:Dictionary):void 
		{ __licensed = value; }		
		
		public function get className():String { return __className; }
		public function get class_ns():String { return __class_ns; }
		public function get pkg_ns():String { return __pkg_ns; }
		public function get pkg_short_ns():String { return __pkg_short_ns; }
		public function get extends_ns():String { return __extends_ns; }
		public function get ext_pkg_ns():String { return __ext_pkg_ns; }
		public function get ext_pkg_short_ns():String { return __ext_pkg_short_ns; }
		public function get ext_className():String { return __ext_className; }
		
		public function get vars():Array { return __vars; }
		public function get methods():Array { return __methods; }
		public function get dependencies():Array { return __dependencies; }
		public function get body():String { return __body; }
		
		public function get concated():String { return __concated; }
		public function get result():Class { return __result; }
		
		
		public function get onComplete():Function { return __onComplete; }
		public function set onComplete(value:Function):void 
		{ __onComplete = value; }
		
		public function get implementsList():Array { return __implements; }
	}
}