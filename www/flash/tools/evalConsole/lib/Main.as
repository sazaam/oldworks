package {
	import begin.eval.Eval;
	import begin.eval.dump.Util;
	import begin.eval.evaluate;
	import begin.type.Type;
	
	import console.ConsoleHandle ;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author aime
	 */
	public class Main extends Sprite {
		public function Main() {
			if (stage == null)
				addEventListener(Event.ADDED_TO_STAGE, init);
			else
				init();
		}

		private function init(evt : Event = null) : void {
			
			var loader:URLLoader = new URLLoader() ;
			loader.dataFormat = URLLoaderDataFormat.TEXT ;
			loader.addEventListener(Event.COMPLETE, onXML) ;
			loader.load(new URLRequest('./xml/console.xml')) ;
		}
			
		
		private function onXML(e:Event) :void
		{
			
			
			var script : XML = new XML(URLLoader(e.target).data) ;
			trace('yo retrieved')
			//trace('xml : >>', script.toXMLString())
			
			evaluate(script.toString(), "RubyJS", function(evt : Event) : void {
				var JS : Object = Eval(evt.target).getEvalLoader().getDefinition("core::JS");
				//trace(Type.toXml(JS));
				for (var p : String in JS)
					trace("key : ", p, "value : ", JS[p]);
				var MyClass : Class = Eval(evt.target).getEvalLoader().getDefinition("core::MyClass") as Class;
				//trace(Type.toXml(MyClass));
				var instance : Sprite = Sprite(addChild(new MyClass()));
				var s : Shape = new Shape();
				var g : Graphics = s.graphics;
				g.beginFill(0);
				g.drawRect(0, 0, 100, 100);
				g.endFill();
				instance.addChild(s);
				
				
				launchConsole() ;
			});	
			
			
		}
		
		private function launchConsole():void 
		{
			var tg:Sprite = this ;
			var console : ConsoleHandle = new ConsoleHandle(tg) ;
			
			//console.
		}
	}
}
