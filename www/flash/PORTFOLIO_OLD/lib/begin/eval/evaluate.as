package begin.eval {

	/**
	 * Evaluate an es4 script.
	 * 
	 * @param script String - the script to evaluate.
	 * @param scriptName String - the name of the specified script.
	 * @param scriptReady Function (default=null) - the complete listener if specified.
	 * @return Eval - the current Eval instance.
	 */
	public const evaluate : Function = function(script : String, scriptName : String = "", scriptReady : Function = null) : Eval {
		return Eval.script(script, scriptName, scriptReady);
	};	
}
