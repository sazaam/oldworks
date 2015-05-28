package aguessy.custom
{
	import aguessy.custom.launch.graph3D.Graph3D;
	import aguessy.custom.launch.graph3D.Nav3D;
	import aguessy.custom.launch.MediasSteps;
	import aguessy.custom.launch.PageSteps;
	import aguessy.custom.launch.visuals.FLVManager;
	import aguessy.custom.launch.visuals.VisualManager;
	import aguessy.custom.load.geeks.CustomLoaderGraphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.control.dialog.JSCommand;
	import naja.model.control.dialog.JSModule;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import naja.model.commands.Wait;
	import naja.model.data.loaders.I.ILoaderGraphics;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class UniqueSteps extends VirtualSteps
	{
		private var __loaderGraphics:ILoaderGraphics ;
		private var user:XUser;
//////////////////////////////////////////////////////// CTOR
		public function UniqueSteps() 
		{
			super("aguessy3D", new CommandQueue(new Command(this, openSite))) ;
			
			//PRIMORDIAL TO INFORM THIS VARIABLE
			__loaderGraphics = new CustomLoaderGraphics(Root.root) ;
			user = Root.user ;
			add(new VirtualSteps("HOME", new Command(this, onHome, true), new Command(this, onHome, false))) ;
		}
		///////////////////////////////////////////////////////////////////////////////// OPEN SITE
		private function openSite():void
		{
			initMotif() ;
			initNav3D() ;
			initJS() ;
			addNavigationSteps() ;
			
			var v:VisualManager = VisualManager.instance ;
			if (v.fill != v.defaultFill) v.fill = v.defaultFill ;
		}
		///////////////////////////////////////////////////////////////////////////////// NAVIGATION STEPS
		private function addNavigationSteps():void
		{
			xml = XML(user.model.data.loaded["XML"]["sections"]).copy() ;
			for each(var node:XML in xml.*) {
				var xxx:XML = XML(user.model.data.loaded["XML"][node.@id.toXMLString()]) ;
				if (xxx is XML) {
					for each(var xx:XML in xxx.*) {
						node.appendChild(xx) ;
					}
				}
			}
			for each(var sec:XML in xml.*) {
				var i:int = sec.childIndex() ;
				var navStep:VirtualSteps , str:String = sec.@id.toXMLString().toUpperCase();
				if (str != "MEDIAS") {
					navStep = new PageSteps(str) ;
				}else {
					navStep = new MediasSteps(str) ;
				}
				navStep.xml = XML(user.model.data.loaded["XML"][sec.@id.toXMLString()]) ;
				add(navStep) ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// HOME PSEUDO-SECTION
		private function onHome(cond:Boolean):void
		{
			var v:VisualManager = VisualManager.instance ;
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			if (cond) {
				var homeImg:Bitmap = user.model.data.loaded["IMG"]["home"] ;
				if(v.fill != homeImg) v.fill = homeImg ;
				nav3D.play() ;
				nav3D.reset() ;
				nav3D.evaluate(this) ;
			}else {
				v.fill = v.defaultFill ;
				nav3D.stop() ;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////// INITS
		//////////////////////////////////////////////////////// JS INIT 4 READING COOKIE
		private function initJS():void
		{
			var cookieFunction:XML = <script><![CDATA[function () 
			{
				sendCookie = function(ref,name) 
				{
					ref.sendCookie(name) ;
				}
				retrieveCookie = function(c_name) 
				{
					sendCookie(getSWFByID("FLASH"), getCookie(c_name)) ;
				}
			}
			]]></script>;
			var cmd:XML = cookieFunction ;
			var command:JSCommand = JSModule.command("retrieveCookie", cmd);
			JSModule.addCallbackJS(command.command);
			JSModule.addCallbackAS("sendCookie", onCookieRetrieved) ;
			JSModule.callJS("retrieveCookie", ["pressAccess"]);
		}
		private function onCookieRetrieved(s:*):void
		{
			user.userData.cookies = { pressAccess:Boolean(s) } ;
		}
		//////////////////////////////////////////////////////// INIT MOTIF
		private function initMotif():void
		{
			var motifBmp:Bitmap = Bitmap(user.model.data.loaded["IMG"]["motif"]) ;
			user.model.data.objects["motif"] = motifBmp.bitmapData ;
			
			var v:VisualManager = VisualManager.instance ;
			v.fill = 0x121212 ;
		}
		//////////////////////////////////////////////////////// INIT NAV3D
		private function initNav3D():void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] = new Nav3D() ;
			nav3D.init() ;
		}		
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get loaderGraphics():ILoaderGraphics { return __loaderGraphics }
	}
}