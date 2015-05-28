package of.app.required.dialog 
{
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import of.app.required.dialog.js.BasicJSFunctions;

	/**
	 * ...
	 * @author saz
	 */
	/*========== EXEMPLE OF EXTERNAL USE ==========*/
		/*
		
		
		
		/*
		
		SEEM WRONG EXEMPLE 
		
		
		var callbackFunction:XML = <script><![CDATA[function ()
			{
				ASPopup = function (url, popname, width, height) 
				{
					var top=(screen.height - height)/2;
					var left=(screen.width - width)/2;   
					window.open(url, popname, "top=" + top + ",left=" + left + ",width=" + width + ",height=" + height + " ,menubar=no,scrollbars=no,statusbar=no");
				}
			}
		]]></script>;
		callbackFunction.name = "ASPopup";
		
		//	later
		
		JSModule.addCallbackJS(callbackFunction);
		JSModule.callJS("ASPopup")
		JSModule.callJS(callbackFunction.name)
		*/
		
		
		
		
		/*
			GOOD EXEMPLE 
			
			
			var alert:XML = <script><![CDATA[
				function() {
					window.wprout = function(msg)
					{	
						window.alert(msg);
					}
				}
				]]></script>;
			var cmd:XML = alert ;
			var command:JSCommand = JSModule.command("wprout", cmd);
			
			JSModule.addCallbackJS(command.command);
			JSModule.callJS(command.name, [new XML(<![CDATA[window]]>)]);
		
		
		*/
	public class JSModule
	{
//////////////////////////////////////////////////////// VARS 
		public static const LOCAL:Boolean		= Security.sandboxType != Security.REMOTE ;
		public static var hasExternal:Boolean;
		private static var __instance:JSModule;
		private var __history:Boolean ;
//////////////////////////////////////////////////////// CTOR
		public function JSModule()
		{
			__instance = this ;
		}
		///////////////////////////////////////////////////////////////////////////////// INIT
		public function init():JSModule
		{
			hasExternal = ExternalInterface.available ;
			trace(this, 'inited...') ;
			return this ;
		}
		public function parseCommand(cmd:XML, commandName:String = null ):JSModule
		{	
			var command:JSCommand = JSModule.command( commandName || "required", cmd) ;
			JSModule.addCallbackJS(command.command) ;
			return this ;
		}
		///////////////////////////////////////////////////////////////////////////////// COMMAND
		public static function command(name:String = "DefaultComand", cmd:XML=null):JSCommand
		{
			var command:XML ;
			if (cmd != null) {
				command = cmd ;
			} else {
				command = BasicJSFunctions.alert ;
			}
			return new JSCommand(name, command) ;
		}
		///////////////////////////////////////////////////////////////////////////////// ADD CALLBACK JS
		public static function addCallbackJS(_callbackFunction:XML,params:Array = null):void 
		{
			ExternalInterface.call.apply(ExternalInterface,[_callbackFunction].concat(params || [])) ;
		}
		///////////////////////////////////////////////////////////////////////////////// CALL JS
		public static function callJS(_calledFunction:String, args:Array=null):void 
		{
			ExternalInterface.call.apply(ExternalInterface, [_calledFunction].concat(args || [])) ;
		}
		///////////////////////////////////////////////////////////////////////////////// ADD CALLBACK AS
		public static function addCallbackAS(fName:String,_closure:Function):void 
		{
			ExternalInterface.addCallback(fName,_closure) ;
		}
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get hasInstance():Boolean { return Boolean(__instance as JSModule) }
		static public function init(...rest:Array):JSModule { return instance.init.apply(instance, [].concat(rest)) }
		static public function get instance():JSModule { return hasInstance? __instance :  new JSModule() }
		
	}
}