package begin.eval {
	
	import begin.eval.dump.ByteLoader;
	

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author aime
	 */
	public class Eval extends EventDispatcher {
		
		public function Eval() {
			
		}
		
		/**
		 * Evaluate an es4 script.
		 * 
		 * @param script String - the script to evaluate.
		 * @param scriptName String - the name of the specified script.
		 * @return Eval - the current Eval instance.
		 */
		public function eval(script : String, scriptName : String) : Eval {
			return loadEsc(script, scriptName);				
		}
		
		/**
		 * Return the ByteLoader that contains the tamarin byte code.
		 * @see begin.eval.util.ByteLoader
		 * @return ByteLoader - the loader that contains the tamarin byte code.
		 */
		public function getEscLoader() : ByteLoader {
			return byteLoader;
		}

		/**
		 * Return the ScriptLoader that contains the evaluated byte code.
		 * @see begin.eval.util.ScriptLoader
		 * @return ScriptLoader - the loader that contains the evaluated byte code.
		 */		
		public function getEvalLoader() : EvalLoader {
			return scriptLoader;
		}
		
		/**
		 * Evaluate an es4 script.
		 * 
		 * @param script String - the script to evaluate.
		 * @param scriptName String - the name of the specified script.
		 * @param scriptReady Function (default=null) - the complete listener if specified.
		 * @return Eval - the current Eval instance.
		 */
		public static function script(script : String, scriptName : String, scriptReady : Function = null) : Eval {
			var eval : Eval = new Eval();
			if (scriptReady != null)
				eval.addEventListener(Event.COMPLETE, scriptReady);
			return eval.eval(script, scriptName);	
		}
		
		/**
		 * Return the evaluated string representation.
		 * 
		 * @return String - the evaluated string representation.
		 */
		override public function toString() : String {
			return evalScript;
		}

		static public function get scopes() : Array {
			return _scopes;
		}
		
		static public function set scopes(scopes : Array) : void {
			_scopes = scopes;
		}
		
		static public function get cb() : Array {
			return _cb;
		}
		
		static public function set cb(cb : Array) : void {
			_cb = cb;
		}
		
		/**
		 * @private
		 */
		private function escComplete(event : Event = null) : void {
			var loader : ByteLoader
			if (event != null) {
				loader = ByteLoader(event.target);
				//loader.removeEventListener(event.type, escComplete);
			} else {
				loader = byteLoader;
			}
			
			if (loader != null) {
				trace('>>>>>>>>>>>>>>')
				trace(loader.getLoaderInfo())
				scriptLoader = new EvalLoader(loader.getLoaderInfo());
				scriptLoader.addEventListener(Event.COMPLETE, evalComplete);
				scriptLoader.eval(evalScript, evalScriptName);
			}
		}

		/**
		 * @private
		 */
		private function evalComplete(event : Event) : void {			
			var loader : EvalLoader = EvalLoader(event.target);
			loader.removeEventListener(event.type, evalComplete);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @private
		 */
		private function loadEsc(script : String, scriptName : String) : Eval {
			
			if (initialized) {
				evalScript = script;
				evalScriptName = scriptName;
				escComplete();
			} else {
				// ONLY ONCE PLEASE
				esc_bytes = EvalSupport.getBytes();
				evalScript = script;
				evalScriptName = scriptName;
				byteLoader.addEventListener(Event.COMPLETE, escComplete);
				byteLoader.loadBytes(esc_bytes, true);
			}
			initialized = true ;
			return this ;
		}

		/**
		 * @private
		 */
		private function loadScript(script : String, scriptName : String) : void {
			
		}

		private static var esc_bytes : Array;

		private static var initialized : Boolean;

		private static var byteLoader : ByteLoader = new ByteLoader();	
		private var scriptLoader : EvalLoader;	

		private var evalScript : String;		
		private var evalScriptName : String;	

		private static var _scopes:Array = [];
		private static var _cb:Array = [];
						
		// stoken from eval-support.es
		private var eval_counter : int = 0;
			
	}
}
