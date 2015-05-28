package aguessy.custom.launch 
{
	import aguessy.custom.launch.graph3D.Nav3D;
	import aguessy.custom.load.geeks.AguessyLink;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.control.dialog.JSModule;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class MediasSteps extends VirtualSteps
	{
		private var user:XUser;
		private var urlloader:URLLoader;
		private var __login:Sprite;
		private var __password:TextField;
		private var __passwordText:TextField;
		private var __link:TextField;
		private var __mediasSprite:Sprite;
		private var error:String;
		private var welcome:String;
		private var __desc:TextField;
		private var __warning:TextField;
		public function MediasSteps(_id:Object) 
		{
			super(_id,new CommandQueue(new Command(this,onMediasOpen,true)), new CommandQueue(new Command(this,onMediasOpen,false))) ;
			user = Root.user ;
		}
		
		private function onMediasOpen(cond:Boolean):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			if (cond) {
				nav3D.levelOne() ;
				nav3D.fill(this) ;
				nav3D.stop() ;
				nav3D.reset() ;
				nav3D.evaluate(this) ;
				nav3D.play() ;
				nav3D.fillMedias(this) ;
				if(!readCookie()) {
					reCheck() ;
				}
				initMessages() ;
				addFieldSet() ;
			}else {
				nav3D.stop() ;
				nav3D.fillMedias(this,false) ;
				nav3D.levelOne(false) ;
				nav3D.fill(this, false) ;
				nav3D.reset() ;
				nav3D.evaluate(parent) ;
				nav3D.play() ;
			}
		}
		
		private function initMessages():void
		{
			error = xml.*[0].@errorMsg.toXMLString() ;
			welcome = xml.*[0].@welcomeMsg.toXMLString() ;
		}
		
		private function addFieldSet():void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			var pageInside:Sprite = Context.$get("#PAGEINSIDE")[0] ;
			var page:Sprite = Sprite(pageInside.parent) ;
			pageInside.blendMode = page.blendMode = 'normal' ;
			
			__mediasSprite = Context.$get(xml.*[0].*[0])[0] ;
			pageInside.addChild(__mediasSprite ) ;
			
			__desc = Context.$get('#desc')[0] ;
			__desc.htmlText = nav3D.g3D.__displayer.replaceTextForSpecialChar(__desc.htmlText.replace(/&amp;/gi,"&")) ;
			__passwordText = Context.$get('#password_txt')[0] ;
			__password = Context.$get('#password')[0] ;
			__login = Context.$get('#submit').bind(MouseEvent.CLICK, onTry2Go)[0] ;
			__link = Context.$get('#medias_link').bind(MouseEvent.CLICK, onGo).bind(MouseEvent.MOUSE_OVER,onLinkOver).bind(MouseEvent.MOUSE_OUT,onLinkOver)[0] ;
			__warning = Context.$get('#warning')[0] ;
			
			if (readCookie()) {
				displayLink() ;
			}
		}
		
		private function reCheck():void
		{
			JSModule.callJS("retrieveCookie", ["pressAccess"]);
		}
		
		private function onGo(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('http://www.aguessy.com/v3/press.php'),"_blank") ;
		}
		
		private function onLinkOver(e:MouseEvent):void
		{
			var tf:TextField = TextField(e.currentTarget) ;
			if (e.type == MouseEvent.MOUSE_OVER) {
				var s:AguessyLink = Context.$get(AguessyLink).attr( { id:"HOVER", name:"HOVER" } )[0] ;
				s.fill = 0xC8C8C8 ;
				s.arrowFill = 0x121212 ;
				s.alph = .25 ;
				s.init(tf) ;
				var cont:Sprite = __mediasSprite ;
				cont.addChildAt(s,0) ;
			}else {
				Context.$get("#HOVER").remove() ;
			}
		}
		
		private function displayLink():void
		{
			var pageInside:Sprite = Context.$get("#PAGEINSIDE")[0] ;
			var page:Sprite = Sprite(pageInside.parent) ;
			var s:Sprite = __mediasSprite ;
			
			s.removeChild(__passwordText) ;
			s.removeChild(__password) ;
			s.removeChild(__login) ;
			displayMsg(true) ;
			__link.visible = true ;
		}
		
		private function displayMsg(cond:Boolean):void
		{
			var fm:TextFormat
			if (cond) {
				if (__warning.visible) __warning.visible = false ;
				fm = __desc.getTextFormat() ;
				fm.color = "0xFF6600" ;
				__desc.blendMode = 'normal' ;
				__desc.text = welcome ;
				__desc.setTextFormat(fm,-1,welcome.indexOf(',')) ;
			}else {
				if (__warning.visible) return ;
				fm = __warning.getTextFormat() ;
				fm.color = "0xD40000" ;
				__warning.blendMode = 'normal' ;
				__warning.text = error ;
				__warning.setTextFormat(fm) ;
				__warning.visible = true ;
			}
		}
		
		private function readCookie():Boolean
		{
			if (ExternalDialoger.instance.isLocal) {
				return true ;
			}else {
				return Boolean(user.userData.cookies && user.userData.cookies.pressAccess) ;
			}
		}
		
		private function onTry2Go(e:MouseEvent):void 
		{
			var password:String = __password.text ;
			var req:URLRequest = new URLRequest('http://www.aguessy.com/v3/req_press.php') ;
			var variables:URLVariables = new URLVariables() ;
			variables.password = password ;
			trace(variables)
			req.data = variables ;
			req.method = URLRequestMethod.POST ;
			urlloader = new URLLoader() ;
			urlloader.dataFormat = req.contentType ;
			urlloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus) ;
			urlloader.load(req) ;
		}
		
		private function onStatus(e:HTTPStatusEvent):void 
		{
			reCheck() ;
			if (readCookie()) {
				displayLink() ;
			}else {
				displayMsg(false) ;
			}
		}
	}
}