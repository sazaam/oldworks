package aguessy.custom.launch 
{
	import aguessy.custom.launch.graph3D.Nav3D;
	import aguessy.custom.launch.visuals.FLVManager;
	import aguessy.custom.launch.visuals.VisualManager;
	import aguessy.custom.load.geeks.Spinners;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLRequest;
	import naja.model.control.context.Context;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import naja.model.data.FileFormat;
	import naja.model.data.loaders.AllLoader;
	import naja.model.data.loaders.E.LoadEvent;
	import naja.model.data.loaders.E.LoadProgressEvent;
	import naja.model.data.loaders.IMGLoader;
	import naja.model.data.loaders.MultiLoaderRequest;
	import naja.model.data.loaders.XLoader;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LoadingSteps extends VirtualSteps
	{
		private var user:XUser ;
		private static var __loaded:Array = [] ;
		private var __type:String;
		private var xLoader:IMGLoader;
		private var req:MultiLoaderRequest;
		private var bmp:Bitmap;
		
		
		public function LoadingSteps(_id:Object) 
		{
			super(_id, new CommandQueue(new Command(this, openLoad)), new CommandQueue(new Command(this, closeLoad))) ;
			user = Root.user ;
		}
		
		private function openLoad():void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			launchLoadings() ;
		}
		
		private function launchLoadings(cond:Boolean = true):void
		{
			if (cond) {
				var url:String = xml.@url.toXMLString() ;
				var ext:String = FileFormat.test(url) ;
				__type = ext ;
				if (__type == FileFormat.VID) {
					url = user.sitePathes["flv"] + url ;
					playFLV(url) ;
				}else if (__type == FileFormat.IMG) {
					if (FLVManager.instance.opened) {
						FLVManager.instance.close() ;
					}
					url = user.sitePathes["img"] + url ;
					if (!Bitmap(__loaded[url])) {
						startLoading(url) ;
					}else {
						resume(url) ;
					}
				}
			}else {
				if (__type == FileFormat.VID) {
					closeFLV() ;
				}else if(__type == FileFormat.IMG){
					killLoading() ;
				}
			}
		}
		
		private function playFLV(url:String):void
		{
			var f:FLVManager = FLVManager.instance ;
			f.open(url) ;
		}
		private function closeFLV():void
		{
			var f:FLVManager = FLVManager.instance ;
			f.close() ;
		}
		
		///////////////////////////////////////////////////////////////////////////////// IMG
		private function startLoading(url:String):void
		{
			xLoader = new IMGLoader() ;
			req = new MultiLoaderRequest(url, "REQUEST") ;
			xLoader.add(req) ;
			xLoader.addEventListener(LoadEvent.COMPLETE, onComplete) ;
			var fakeCheck:* = Context.$get("Spinners") ;
			if (Boolean(fakeCheck[0])) {
				fakeCheck.remove() ;
			}
			var spinners:Spinners = Context.$get(Spinners).attr( { id:"SPINNERS", name:"SPINNERS" } )[0] ;
			spinners.blendMode = 'invert' ;
			Root.root.addChild(spinners) ;
			spinners.spin() ;
			xLoader.loadAll() ;
		}
		
		private function onComplete(e:LoadEvent):void 
		{
			var ref:String = req.url ;
			bmp = e.currentTarget.loader.getResponseById("REQUEST") ;
			__loaded[ref] = bmp ;
			var spinners:Spinners = Context.$get("#SPINNERS")[0] ;
			spinners.stopSpin() ;
			Root.root.removeChild(spinners) ;
			resume(ref) ;
		}
		
		private function resume(url:String):void
		{
			var v:VisualManager = VisualManager.instance ;
			var b:Bitmap = __loaded[url] ;
			if( v.fill!= b ) v.fill = b ;
		}
		
		private function killLoading():void
		{
			xLoader.removeEventListener(LoadEvent.COMPLETE,onComplete) ;
		}
		
		private function closeLoad():void
		{
			try 
			{
				launchLoadings(false) ;
			}
			catch (e:Error)
			{
				
			}
		}
		
	}
	
}