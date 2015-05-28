package begin.eval {
	import begin.eval.dump.ByteLoader;
	import begin.type.utility.ClassParser;

	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * @author aime
	 */
	public class EvalLoader extends EventDispatcher {

		/**
		 * @param tamarinLoaderInfo
		 */
		public function EvalLoader(tamarinLoaderInfo : LoaderInfo) {
			this.tamarinLoaderInfo = tamarinLoaderInfo;
			this.classParser = new ClassParser(tamarinLoaderInfo);
			this.tamarinClasses = classParser.getDefinitionNames(true, false, false);
			this.bootstrap_namespaces = classParser.getDefinition("ESC::bootstrap_namespaces");
		}  

		/**
		 * @return Array
		 */
		public function getDefinition(name : String) : * {
			return evalParser.getDefinition(name);	
		}
		
		/**
		 * @return Array
		 */
		public function getEcsClasses() : Array {
			return tamarinClasses;	
		}
		
		/**
		 * @return ClassParser
		 */
		public function getEscParser() : ClassParser {
			return classParser;	
		}
		
		/**
		 * @return Array
		 */
		public function getEvalClasses() : Array {
			return evalClasses;	
		}
		
		/**
		 * @return ClassParser
		 */
		public function getEvalParser() : ClassParser {
			return evalParser;	
		}
		
		/**
		 * @return String
		 */
		public function getScriptName() : String {
			return codeName;	
		}

		/**
		 * @return String
		 */
		public function getScript() : String {
			return evalCode;	
		}
		
		/**
		 * @return LoaderInfo
		 */
		public function getTamarinLoaderInfo() : LoaderInfo {
			return tamarinLoaderInfo;	
		}

		/**
		 * @param script
		 * @param scriptName
		 */
		public function eval(script : String, scriptName : String = "(EVAL SCRIPT)") : void {
			this.codeName = scriptName;
			this.evalCode = script;
			this.parser = classParser.getDefinitionInstance("Parse::Parser", this.evalCode, this.bootstrap_namespaces, this.codeName);
			this.program = (parser["program"] as Function).call(parser, true);
			this.cg = classParser.getDefinition("Gen::cg");
			this.abcFile = cg(program);
			var bytes : ByteArray = (abcFile["getBytes"] as Function).call(abcFile);
			var loader : ByteLoader = new ByteLoader();
			loader.addEventListener(Event.COMPLETE, complete);
			bytes.position = 0;
			loader.loadBytes(bytes, true);				
		}
		
		/**
		 * @param evt Event
		 */
		private function complete(evt : Event) : void {
			var loaderInfo : LoaderInfo = ByteLoader(evt.target).getLoaderInfo();
			evalParser = new ClassParser(loaderInfo);
			evalClasses = evalParser.getDefinitionNames(true, false);
			dispatchEvent(new Event(Event.COMPLETE));	
		}

		private var tamarinClasses : Array;				private var codeName : String;				private var abcFile : Object;				private var cg : Function;				private var evalCode : String;				private var classParser : ClassParser;		private var evalParser : ClassParser;		private var parser : Object;		private var program : Object;		private var tamarinLoaderInfo : LoaderInfo;		private var bootstrap_namespaces : Array;		private var evalClasses : Array;
	}
}
