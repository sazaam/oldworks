package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import modules.coreData.geoms.Box;
	import modules.coreData.geoms.ColorData;
	import modules.coreData.geoms.Dimension;
	import modules.coreData.geoms.Location;
	import modules.coreData.geoms.MatrixData;
	import modules.coreData.views.CoreBitmap;
	import modules.coreData.views.CoreBitmapData;
	import modules.foundation.Type;
	import modules.foundation.events.ModuleEventDispatcher;
	import modules.foundation.langs.JSType;
	import modules.patterns.Singleton;
	import modules.patterns.Creation;
	import modules.patterns.proxies.DynamicProxy;
	import modules.patterns.proxies.Handler;
	
	public class Main extends Sprite 
	{
		
		public var dispatcher:ModuleEventDispatcher;
		public var proxy:DynamicProxy;
		
		public function Main()
		{
			trace('Instanciation :', this);
			proxy = DynamicProxy.getProxyInstance(new Handler(new ModuleEventDispatcher(this)));
			proxy.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			trace("Dimension __________________________________");
			
			var d0:Dimension = new Dimension(new XML("<instance><type class='modules.coreData.geoms.Dimension' width='800' height='800'/></instance>"));
			var d1:Dimension = new Dimension({width:200, height:400});
			var d2:Dimension = new Dimension(d0);
			var d3:Dimension = d0.clone() as Dimension;
			trace(d0);
			trace(d1);
			trace(d2);
			trace(d3);
			
			trace("ColorData __________________________________");
			
			var col0:ColorData = new ColorData(new XML("<instance><type class='modules.coreData.geoms.ColorData' red='255' blue='125' green='25'/></instance>"));
			var col1:ColorData = new ColorData({red:200, green:45, blue:125});
			var col2:ColorData = new ColorData(col0);
			var col3:ColorData = col0.clone() as ColorData;
			trace(col0);
			trace(col1);
			trace(col2);
			trace(col3);
			
			trace("Location __________________________________");
			
			var loc0:Location = new Location(new XML("<instance><type class='modules.coreData.geoms.Location' x='255' y='125'/></instance>"));
			var loc1:Location = new Location({x:200, y:45});
			var loc2:Location = new Location(loc0);
			var loc3:Location = loc2.clone() as Location;	
			//trace(loc0);
			//trace(loc1);
			//trace(loc2);
			trace(loc3);
			
			trace("Box __________________________________");
			
			var box0:Box = new Box(new XML("<instance><type class='modules.coreData.geoms.Box' x='255' y='125' width='100' height='100'/></instance>"));
			var box1:Box = new Box({x:200, y:45, width:345, height:500});
			var box2:Box = new Box(box1);
			var box3:Box = box0.clone() as Box;
			//trace(box0);
			//trace(box1);
			//trace(box2);
			trace(box3);
			
			trace("MatrixData __________________________________");
			
			var matrix0:MatrixData = new MatrixData(new XML("<instance><type class='modules.coreData.geoms.MatrixData' a='1' b='1' c='1' d='1' tx='1' ty='1'/></instance>"));
			var matrix1:MatrixData = new MatrixData({a:1, b:1, c:0, d:0});
			var matrix2:MatrixData = new MatrixData(matrix1);
			var matrix3:MatrixData = matrix0.clone() as MatrixData;
			//trace(matrix0);
			//trace(matrix1);
			//trace(matrix2);
			trace(matrix3);			
			
			trace("CoreBitmapData __________________________________");
			
			var bitmapData0:CoreBitmapData = new CoreBitmapData(new XML("<instance><type class='modules.coreData.views.CoreBitmapData' width='100' height='100' transparent='false' fillcolor='0'/></instance>"));
			var bitmapData1:CoreBitmapData = new CoreBitmapData({width:10, height:10, transparent:true, fillcolor:0xFFCCFFCC});
			var bitmapData2:CoreBitmapData = new CoreBitmapData(bitmapData1);
			var bitmapData3:CoreBitmapData = bitmapData0.clone() as CoreBitmapData;
			//trace(bitmapData0);
			//trace(bitmapData1);
			//trace(bitmapData2);
			//trace(bitmapData3);
			var o:* = Type.encode({width:10}, CoreBitmapData);
			//
			//trace(Type.getClass(o));
			//
			//for (var p:String in o)
				//trace(p);
			
			trace("CoreBitmap __________________________________");
			
			var bitmap0:CoreBitmap = new CoreBitmap(new XML("<instance><type class='modules.coreData.views.CoreBitmap' bitmapData='new flash.display.BitmapData(1, 1)' pixelSnapping='auto' smoothing='false'/></instance>"));
			//var bitmap1:CoreBitmapData = new CoreBitmapData({width:10, height:10, transparent:true, fillcolor:0xFFCCFFCC});
			//var bitmap2:CoreBitmapData = new CoreBitmapData(bitmapData1);
			//var bitmap3:CoreBitmapData = bitmapData0.clone() as CoreBitmapData;
			//trace(bitmap0);
			//trace(bitmap1);
			//trace(bitmap2);
			//trace(bitmap3);
			
			var Test:Function = function(s:String):void
			{
				this.print = function(s:String):void
				{
					trace(s);
				}
				this.print(s);
			}
			/*
			Test.prototype.print = function(s:String):void
			{
				trace(s);
			}
			*/
			var SubClass:Function = JSType.promote().extend(Test);
			var instance:Object = new SubClass("blaaaaa");
			
			//var created:Creation = Creation.getInstance();
			var created1:Creation = Singleton.getInstance(Creation) as Creation;
			var created2:Creation = Singleton.getInstance(Creation) as Creation;			
			trace("created1 : ", created1, created2);
			trace("equals : ", created1 === created2);
		}
		
	}
}
