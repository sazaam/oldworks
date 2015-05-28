package pro.steps 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import naja.model.control.context.Context;
	import naja.model.control.spawn.Spawner;
	import naja.model.Root;
	import naja.tools.api.geom.Draw;
	import naja.tools.commands.Command;
	import naja.tools.lists.Gates;
	import naja.tools.steps.VirtualSteps;
	import pro.layer.Layer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class BeginUnique extends VirtualSteps 
	{
		private var __sp:Spawner;
		//private var __nav:Navigation;
		
		public function BeginUnique() 
		{
			super("ALL", new Command(this, onSite)) ;
			add(new VirtualSteps("HOME", new Command(this, onHome, true), new Command(this, onHome, false)) as VirtualSteps) ;
		}
		
		private function onHome(cond:Boolean):void
		{
			//var nav:Navigation = userData.nav ;
			
			var layer:Layer ;
			if (cond) {
				trace("opening home") ;
				//layer = Context.$get(Layer).attr( { id:"LAYER", name:"LAYER" } )[0] ;
				//Draw.draw("rect", { g:layer.graphics, color:0x0, alpha:.92 }, 0, 0, 600, 400) ;
				//Root.root.addChild(layer) ;
				//Root.root.addChildAt(layer, 0) ;
				//layer.addEventListener(MouseEvent.CLICK, onLayerClicked) ;
			}else {
				trace("closing home") ;
				//layer = Context.$get("#LAYER").remove()[0] ;
			}
		}
		private function onAime(cond:Boolean):void
		{
			//var nav:Navigation = userData.nav ;
			
			var layer:Layer ;
			if (cond) {
				trace("opening aime") ;
				layer = Context.$get(Layer).attr( { id:"LAYER", name:"LAYER" } )[0] ;
				Draw.draw("rect", { g:layer.graphics, color:0x0, alpha:.92 }, 0, 0, 600, 400) ;
				//Root.root.addChild(layer) ;
				Root.root.addChildAt(layer, 0) ;
				//layer.addEventListener(MouseEvent.CLICK, onLayerClicked) ;
			}else {
				trace("closing aime") ;
				layer = Context.$get("#LAYER").remove()[0] ;
			}
		}
		private function onLayerClicked(e:MouseEvent):void 
		{
			trace('layer clicked')
			//ExternalDialoger.instance.swfAddress.value = "PORTFOLIO/1/EXAMPLE" ;
		}
		
		private function onSite():void
		{
			initXML() ;
			initSpawn() ;
			initNav() ;
		}
		
		private function initSpawn():void 
		{
			trace(' >>> ', Spawner.parse(xml, onScriptComplete));
		}
		
		private function onScriptComplete(e:Event):void 
		{
			var c:Class = Spawner.getDefinition('naja.prospect::ASStep') ;
			var st:VirtualSteps = VirtualSteps(add(new c("AIME", new Command(this, onAime, true), new Command(this, onAime, false)))) ;
			
			trace(c)
			trace(st)
			trace(Spawner.getSpawner('naja.prospect::ASStep'))
			
			
			var c2:Class = Spawner.getDefinition('naja.prospect::ASSprite') ;
			var s:Sprite = new c2() ;
			s.graphics.beginFill(0xFF6600) ;
			s.graphics.drawRect(0,0,100,100) ;
			s.graphics.endFill() ;
			Root.root.addChild(s) ;
			
			trace(c2)
			trace(s)
			trace(Spawner.getSpawner('naja.prospect::ASSprite'))
			
			
			var c3:Class = Spawner.getDefinition('naja.prospect::ASLoader') ;
			var loader:* = new c3() ;
			
			trace(c3)
			trace(loader)
			trace(Spawner.getSpawner('naja.prospect::ASLoader'))
			
			
			var c4:Class = Spawner.getDefinition('naja.prospect::ASGates') ;
			var gates:Gates = new c4() ;
			//com.execute() ;
			
			trace(c4)
			trace(gates)
			trace(Spawner.getSpawner('naja.prospect::ASGates'))
		}
		
		private function initXML():void
		{
			//xml = Root.user.model.data.loaded["XML"]["sections"] ;
			xml = Root.user.model.data.loaded["XML"]["as"] ;
		}
		
		private function initNav():void
		{
			trace('initing Nav')
			//ExternalDialoger.instance.swfAddress.hierarchy.autoExec = false ;
			
			//
			//__nav = new Navigation().init(Root.root) ;
			//__nav.readOnce(this) ;
		}
	}

}