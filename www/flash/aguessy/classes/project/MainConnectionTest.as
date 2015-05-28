package project 
{
	import asSist.$;
	import flash.display.Sprite;
	import flash.events.Event;
	import alducente.services.WebService;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MainConnectionTest extends Sprite
	{
		private var initTime:Number;
		private var ws:WebService;
		
		public function MainConnectionTest()
		{
			$(this).bind(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onStage(e:Event):void
		{
			ws = new WebService();
			ws.addEventListener(Event.CONNECT, connected);
			ws.connect("http://itgc.proximity.fr/WebPartCollection/Central.Proximity.WebPartLogin/Webservice/Login_v3_0.asmx?WSDL") ;
			ws.cacheResults = true ;
		}
		
		function connected(evt:Event):void{
			initTime = getTimer() ;
			ws.Login(done, "sazaam@hotmail.com", "butokukai") ;
		}

		function done(serviceResponse:XML):void {
			var time:Number = getTimer();
			trace("Call duration: "+(time - initTime)+" milliseconds");
			initTime = time;
			//trace(serviceResponse) ;
			var result:XML = serviceResponse.*[0].*[0].*[0] ;
			trace(result) ;
		}

		function done2(resp:XML):void{
			//var time:Number = getTimer();
			//trace("Call duration: "+(time - initTime)+" milliseconds");
			//initTime = time;
			//trace(resp);
			//ws.clearCache();
			//ws.ResolveIP(done, "192.168.0.125", 0);
		}
	}
}