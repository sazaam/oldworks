package flashgrafix 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import gs.TweenLite;
	import mvc.structure.data.items.Item;
	import saz.geeks.graphix.deco.Typographeur ;
	import flash.display.Sprite ;
	import saz.geeks.Mac.addons.ScrollStageView;
	import saz.helpers.formats.FileFormat;
	import saz.helpers.loadlists.loaders.E.LoadEvent;
	import saz.helpers.loadlists.loaders.E.LoadProgressEvent;
	import saz.helpers.loadlists.loaders.XLoader;
	import saz.helpers.loadlists.loaders.MultiLoaderRequest;
	import saz.helpers.loadlists.loaders.MultiLoader;
	
	/**
	 * ...
	 * @author saz
	 */

	 
	public class TypograferTest extends Sprite
	{
		private var xLoader:XLoader;
		private var t:Typographeur;
		private var contents:Sprite;
		private var viewY:int;
		private var scene:Sprite;
		
		public function TypograferTest() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			//var req:MultiLoaderRequest = new MultiLoaderRequest("./xml/videos.xml","xml",FileFormat.XML) ;
		}
		private function onStageClicked(e:MouseEvent):void 
		{
			viewY = contents.mouseY ;
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, onStageUp) ;
			e.currentTarget.addEventListener(Event.ENTER_FRAME, onStageMove) ;
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, arguments.callee) ;
		}
		
		private function onStageUp(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, arguments.callee) ;
			e.currentTarget.removeEventListener(Event.ENTER_FRAME, onStageMove) ;
			e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, onStageClicked) ;
		}
		
		private function onStageMove(e:Event):void 
		{
			//trace(contents.height)
			//trace(scrollRect.bottom)
			var middle:int = (stage.stageHeight >> 1) ;
			//var viewY:int = viewY - stage.mouseY;
			var dif:int = viewY - contents.mouseY  ;
			//var dif:int = middle - localY ;
			var rect:Rectangle = scene.scrollRect ;
			rect.y = scene.scrollRect.y - dif ;
			if (rect.y < 0 ) {
				rect.y = 0 ;
			}
			if (rect.y > contents.height-stage.stageHeight+300 ) {
				rect.y = contents.height-stage.stageHeight+300 ;
			}
			scene.scrollRect = rect ;
			viewY = contents.mouseY ;
		}
		
		private function onSpecialProgress(e:LoadProgressEvent):void 
		{
			trace('loading >>   ' + e.req.id +'  loaded : ' + e.bytesLoaded +'  total : ' + e.bytesTotal ) ;
			//trace('GLOBAL[ loaded : ' + xLoader.loadedBytes +"   total : "+ xLoader.totalBytes)
		}
		
		private function onLoadingsComplete(e:LoadEvent):void 
		{
			trace('complete >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ' + e.req.id) ;
			//trace(e.content)
			var i:int = Item(xLoader.list.remove(e.req.id)).index ;
			trace(e.content)
			//depuis un élément de la bibliothèque	
			var bmpd:BitmapData = e.content.bitmapData ;
			
			t = new Typographeur("L’association 1KSABLE") ;
			//t.type = "pixel" ;
			//t.type = "box" ;
			t.type = "text" ;
			//var thresh:int = 256 ;
			var thresh:int = 300 ;
			t.threshold = thresh ;
			t.flipValues() ;
			//t.prepare(bmpd)
			//passe le bmpd au typographeur
			//t.fromBitmap( bmpd, 1, 10, 5, 1) ;
			t.fromBitmap( bmpd, 1, 10, 2, 17) ;
			//t.fromBitmap( bmpd, 1,3, 2, 5,true) ;
			
			//comme le bitmap est déja chargé, on peut lancer le traitement n'importe quand
			t.process() ;
			
			var bmpdt:BitmapData = new BitmapData(t.width, t.height, true, 0x0) ;
			bmpdt.draw(t) ;
			var output:Bitmap = new Bitmap(bmpdt, "auto", true ) ;
			output.x = ((stage.stageWidth-output.width) >> 1 ) ;
			output.y = ((output.height + 150) * (i))+150 ;
			output.cacheAsBitmap = true ;
			
			contents.addChild(output) ;
		}
		
		
		
		private function onStage(e:Event):void 
		{
			stage.scaleMode = "noScale" ;
			stage.align = "TL" ;
			
			scene = addChildAt(new Sprite(),0) as Sprite ;
			contents = scene.addChild(new Sprite()) as Sprite ;
			var scrollView:ScrollStageView = new ScrollStageView(scene,stage) ;
			xLoader = new XLoader() ;
			xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg0",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg1",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg2",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg3",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg4",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg5",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg6",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg7",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg8",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg9",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg10",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg11",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg12",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg13",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg14",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg15",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg16",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg17",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg18",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg19",FileFormat.JPG)) ;
			//xLoader.add(new MultiLoaderRequest("./img/100_croissance.jpg","jpg20",FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/hotelcortex.jpg","jpg1",FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/num93.jpg", "jpg2", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/argonaut.jpg", "jpg3", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/levis.jpg", "jpg4", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/cocacola.jpg", "jpg5", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/cwv.jpg", "jpg6")) ;
			xLoader.add(new MultiLoaderRequest("./img/elementn.jpg", "jpg7", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/fantasmos.jpg", "jpg8", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/foudreglobulaire.jpg", "jpg9", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/garageband.jpg", "jpg10", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/magnethix.jpg", "jpg11", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/murcoff.jpg", "jpg12", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/owl.jpg", "jpg13", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/postcripteur.jpg", "jpg14", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/pyllyq2.jpg", "jpg15", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/qtv.jpg", "jpg16", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/showreel.jpg", "jpg17", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/tripod.jpg", "jpg18", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/virus.jpg", "jpg19", FileFormat.JPG)) ;
			xLoader.add(new MultiLoaderRequest("./img/pyllyq.jpg", "jpg20", FileFormat.JPG)) ;
			xLoader.addEventListener(LoadProgressEvent.PROGRESS, onSpecialProgress) ;
			xLoader.addEventListener(LoadEvent.COMPLETE, onLoadingsComplete) ;
			xLoader.loadAll() ;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClicked) ;
		}
	}
}