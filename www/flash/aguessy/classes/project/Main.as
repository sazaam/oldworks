package project 
{
	import alducente.services.WebService;
	import asSist.*;
	import f6.utils.IDictionary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import gs.TweenLite;
	import mvc.behavior.commands.Command;
	import mvc.behavior.commands.CommandQueue;
	import mvc.behavior.commands.Wait;
	import mvc.behavior.commands.WaitCommand;
	import mvc.behavior.steps.E.StepEvent;
	import mvc.behavior.steps.Step;
	import mvc.behavior.steps.StepList;
	import mvc.behavior.steps.VirtualSteps;
	import saz.geeks.graphix.Appear;
	import saz.helpers.forms.FormsChecker;
	import fl.controls.RadioButton;
	import fl.controls.CheckBox;
	import saz.helpers.text.TextFill;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Main extends MovieClip
	{
		//////////////////////////////////////CONNECT
		private var CONNECTIONXML:String;
		private var CONNECTION_URL:String;
		private var SESSION_TICKET:String;
		private var USER_PROFILE:XML
		
		
		//////////////////////////////////////STEPS
		private var list:VirtualSteps;
		private var step1:Step;
		private var step2:Step;
		private var step3:Step;
		private var step4:Step;
		
		private var step5:Step;
		private var bathroomBlurred:Boolean;
		
		
		
		public function Main() 
		{
			if (!parent) {
				alpha = 0 ;
			}
			
			$(this).bind(Event.ADDED_TO_STAGE, onStage)  ;
			$(logo).attr( { id:"logo" } ) ;
			$(photos).attr( { id:"photos" } ) ;
			$(bathroom).attr( { id:"bathroom" } ) ;
			$(frame).attr( { id:"frame"  } ) ;
		}
		
		private function onStage(e:Event):void
		{
			trace("Instanciated && On Stage :: " + $(stage)) ;
			
			launchWSXML();
		}
		
		private function launchWSXML():void
		{
			$(URLLoader).each(function(i:int, el:URLLoader) {
				$(el).bind(Event.COMPLETE, function(e:Event) {
					loadWSRegistry(XML(e.target.data) as XML ) ;
				}).bind(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {
					trace("Error  :  " + e ) ;
				}) ;
			})[0].load(new URLRequest("./xml/WSRegistry.xml"))  ;
		}
		
		private function loadWSRegistry(_xml:XML):void
		{
			
			var CONNECTIONXML:String = _xml.path ;
			//trace(CONNECTIONXML)
			$(URLLoader).each(function(i:int, el:URLLoader) {
				$(el).bind(Event.COMPLETE, function(e:Event) {
					initWSRegistry(XML(e.target.data) as XML ) ;
				}).bind(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {
					//trace("Error  :  " + e ) ;
				}) ;
			})[0].load(new URLRequest("./xml/"+CONNECTIONXML))  ;
		}
		
		private function initWSRegistry(_xml:XML):void
		{
			CONNECTION_URL = _xml.connectionURL ;
			//trace(CONNECTION_URL)
			init() ;
		}
		
		private function init():void
		{
			$("#frame")[0].mouseEnabled = false ;
			step1 = new Step("home", new Command(null, initHome),new CommandQueue(new Command(null,killHome),Wait(400)));
			step2 = new Step("login",new Command(null,initLogin),new CommandQueue(new Command(null,killLogin),Wait(400)));
			step3 = new Step("lostPassword", new Command(null, initLostPassword), new CommandQueue(new Command(null,killLostPassword),Wait(400)));
			step4 = new Step("register", new Command(null, initRegister), new CommandQueue(new Command(null,killRegister),Wait(400)));
			step5 = new Step("startGame", new Command(null, initStartGame), new CommandQueue(new Command(null,killStartGame),Wait(400)));
			if (parent as RootLoader) {
				alpha = 1 ;
				new Appear(this,1,function(){launchSteps()});
			}else {
				launchSteps() ;
			}
		}
		
		
		

		
/////////////////////////////////////////////////////////////////////////////////////LAUNCH
		private function launchSteps():void
		{
			list = new VirtualSteps([step1]) ;
			
			list.add(step2) ;
			list.add(step3) ;
			list.add(step4) ;
			list.add(step5) ;
			
			//list.debug = true ;
			//list.remove() ;
			//list.remove("mansion") ;
			list.launch() ;
			//stage.addEventListener(MouseEvent.CLICK, onStageClicked) ;
			
			$("#logo").bind(MouseEvent.CLICK, function(e:MouseEvent) {
				if (list.playhead != 0) list.launch(0);
			})[0].buttonMode = true ;
		}
		
		
//////////////////////////////////////////////////////////////////////////////////////BATHROOM BLURING
		private function blurBathroom():void
		{
			if (bathroomBlurred) return ;
			var bath:Sprite = Sprite($("#bathroom")[0]) ;
			var bmpBlur:BitmapData = new BitmapData(bath.width, bath.height, false, 0x0) ;
			bmpBlur.draw(bath) ;
			bath.addChild(new Bitmap(bmpBlur, "auto", true)) ;
			$("#bathroom Bitmap").attr( { id:"bathBitmap" } ) ;
			//bath.removeChild($("#bathroom Shape")[0]) ;
			var ind:int = 0 ;
			bath.addEventListener(Event.ENTER_FRAME, function(e:Event) { 
				bmpBlur.applyFilter(bmpBlur,new Rectangle(bath.x,bath.y,bath.width,bath.height),new Point(),new BlurFilter(ind, ind, 1));
				if (ind == 10) {
					e.target.removeEventListener(Event.ENTER_FRAME, arguments.callee) ;
					bathroomBlurred = true ;
				}else{
					ind++;
				}
			} ) ;
		}
		private function unBlurBathroom():void
		{
			if (!bathroomBlurred) return ;
			var bath:Sprite = Sprite($("#bathroom")[0]) ;
			var bathBitmap:Bitmap = bath.getChildAt(1) as Bitmap;
			var ind:int = 9 ;
			var bmpBlur = bathBitmap.bitmapData ;
			bath.addEventListener(Event.ENTER_FRAME, function(e:Event) { 
				bathBitmap.alpha = ind / 10;
				if (ind == 0) {
					bath.removeChild(bathBitmap) ;
					e.target.removeEventListener(Event.ENTER_FRAME, arguments.callee) ;
					bathroomBlurred = false ;
				}else {
					ind--;
				}
			})
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////GAME

//////////////////////////////////////////////////////////////////////////////////////GAME LAUNCH
		private function initStartGame():void
		{
			if ($("#photos")[0].scaleX != .7) TweenLite.to($("#photos")[0], .4 ,{scaleX:.7,scaleY:.7,y:-30}) ;
			if ($('#frame')[0].alpha != 0) TweenLite.to($('#frame')[0], .4, { alpha:0 } ) ;
			unBlurBathroom() ;
			
			var s:Sprite = new GAMESTART() as Sprite ;
			$(s).attr( { id:"gameStart", name: "gameStart" } );
			addChildAt(s,1) ;
			
			stage.addEventListener(MouseEvent.CLICK,onStageClicked)
			trace('Game INITED') ;
		}
		
		private function onStageClicked(e:MouseEvent):void 
		{
			list.launch(0);
		}
		private function killStartGame():void
		{
			var s:Sprite = getChildAt(1) as Sprite ;
			s.blendMode = BlendMode.ADD ;
			TweenLite.to(s, .4, { alpha:0, onComplete:function() { s.parent.removeChild(s) }} ) ;
			
			
			stage.removeEventListener(MouseEvent.CLICK, onStageClicked) ;
			
			trace('Game KILLED') ;
		}
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////LAYERS

//////////////////////////////////////////////////////////////////////////////////////WAITING FOR CONNECTION
		private function displayConnectingLayer(cond:Boolean = true ):void
		{
			var s:Sprite ;
			if (cond) {
				s = new WAITLAYER() as Sprite ;
				$(s).attr( { id:"wait", name: "wait" } );
				addChild(s) ;
			}else {
				s = $("#wait")[0] ;
				s.blendMode = BlendMode.ADD ;
				TweenLite.to(s, .4, { alpha:0, onComplete:function() { s.parent.removeChild(s) }} ) ;
			}
		}
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////OTHER STEPS

//////////////////////////////////////////////////////////////////////////////////////HOME
		private function initHome():void
		{
			blurBathroom() ;
			if ($('#frame')[0].alpha != 1) TweenLite.to($('#frame')[0], .4, { alpha:1 } ) ;
			if ($("#photos")[0].scaleX != 1)TweenLite.to($("#photos")[0], .4 ,{scaleX:1,scaleY:1,y:-52}) ;
			var s:Sprite = new HOME() as Sprite ;
			$(s).attr( { id:"home", name: "home" } );
			addChildAt(s, 1) ;
			new Appear(s, 1) ;
			
			var playNow:Sprite = s.getChildByName('playNow') as Sprite ;
			playNow.buttonMode = true ;
			playNow.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				list.next() ;
			})
		}
		private function killHome():void
		{
			var s:Sprite = getChildAt(1) as Sprite ;
			s.blendMode = BlendMode.ADD ;
			TweenLite.to(s, .4, { alpha:0, onComplete:function() { s.parent.removeChild(s) }} ) ;
		}
		
//////////////////////////////////////////////////////////////////////////////////////LOGIN
		private function initLogin():void
		{
			var s:MovieClip = new LOGIN() as MovieClip ;
			$(s).attr( { id:"login", name: "login" } );
			addChildAt(s, 1) ;
			new Appear(s, 1) ;
			var register:Sprite = s.getChildByName('register') as Sprite ;
			register.buttonMode = true ;
			register.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				list.launch("register");
			});
			
			var val:Sprite = s.getChildByName('validateLogin') as Sprite ;
			val.buttonMode = true ;
			val.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				if (checkLoginInputs()) sendLoginRequest() ;
				else warnLoginIncorrect() ;
			});
			
			var forgotten:Sprite = s.getChildByName('forgottenpassword') as Sprite ;
			forgotten.buttonMode = true ;
			forgotten.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				list.next() ;
				//list.launch(0);
			});
			
			$("#login TextField").bind(FocusEvent.FOCUS_IN, onTextFieldFocusedIn).bind(FocusEvent.FOCUS_OUT, onTextFieldFocusedOut) ;
			
		}
		
		private function sendLoginRequest():void
		{
			
			//list.next() ;
			var ws:WebService = new WebService();
			displayConnectingLayer() ;
			ws.addEventListener(Event.CONNECT, function(e:Event) {
					//initTime = getTimer() ;
					ws.Login(function(resp:XML):void {
						displayConnectingLayer(false) ;
						var result:XML = resp.*[0].*[0].*[0] ;
						trace("==================================================================") ;
						
						var resultName:String = result.*[0] ;
						var resultDesc:String = result.*[1] ;
						var exception:String = result.*[2] ;
						//trace("RESULT : " + result)
						if (Boolean(resultName == "OK")) {
							USER_PROFILE = result.*[3] ;
							SESSION_TICKET = result.*[4] ;
							trace("USER_PROFILE : "+USER_PROFILE) ;
							trace("SESSION_TICKET : " + SESSION_TICKET) ;
							list.launch("startGame") ;
						}else {
							//echec
							list.launch(0) ;
						}
						//if(Boolean(resultName != "UNKNOWN_USER"))
						
						
					//}, $("#login #email")[0].text, $("#login #pass")[0].text) ;
					},"ostermann+user9@sixandco.com", "password") ;    // AND IT WORKS !!!
				});
			ws.connect(CONNECTION_URL) ;
			ws.cacheResults = true;
		}
		
		
		private function onTextFieldFocusedOut(e:FocusEvent):void
		{
			var tf:TextField = e.target as TextField ;
			if (tf.text.length == 0 || tf.text == "" ) {
				if (tf.name == "login") {
					tf.text = "login" ;	
				}else if(tf.name == "password"){
					tf.text = "mot de passe" ;	
				}else if (tf.name == "mail") {
					tf.text = "E-mail" ;	
				}
			}
		}
		
		private function onTextFieldFocusedIn(e:FocusEvent):void
		{
			var tf:TextField = e.target as TextField ;
			trace(tf.name)
			if (tf.text == "login" || tf.text == "mot de passe" || tf.text == "E-mail") tf.text = "" ;
		}
		
		private function warnLoginIncorrect():void
		{
			trace("LOGIN INCORRECT") ;
		}
		
		private function checkLoginInputs():Boolean
		{
			var cond:Boolean;
			$("#login TextField").each(function(i:int, el:TextField) {
				switch(el.name) {
					case 'login' :
						$(el).attr({id:"email"}) ;
						cond = FormsChecker.validate(el, FormsChecker.EMAIL) ;
						return cond ;
					break ;
					case 'password' :
						$(el).attr({id:"pass"}) ;
						cond = FormsChecker.validate(el, FormsChecker.ALPHANUM+" "+FormsChecker.MAX+"10"+" "+FormsChecker.MIN+"06") ;
						return cond;
					break ;
				}
			} ) ;
			return cond ;
		}
		
		private function killLogin():void
		{
			var s:Sprite = getChildAt(1) as Sprite ;
			s.blendMode = BlendMode.ADD ;
			TweenLite.to(s, .4, { alpha:0, onComplete:function() {s.parent.removeChild(s)}} ) ;
		}
/////////////////////////////////////////////////////////////////////////////////////LOST PASSWORD
		
		private function initLostPassword():void
		{
			var s:MovieClip = new LOSTPASSWORD() as MovieClip ;
			$(s).attr( { id:"lostPassword", name: "lostPassword" } );
			addChildAt(s, 1) ;
			new Appear(s, 1) ;
			
			var register:Sprite = s.getChildByName('register') as Sprite ;
			register.buttonMode = true ;
			register.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				list.launch("register") ;
			});
			
			var val:Sprite = s.getChildByName('validateMail') as Sprite ;
			val.buttonMode = true ;
			val.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				if (checkLostPasswordEmail()) sendLostPasswordRequest();
				else warnIncorrectLostPasswordEmail() ;
			});
			$("#lostPassword TextField").bind(FocusEvent.FOCUS_IN, onTextFieldFocusedIn).bind(FocusEvent.FOCUS_OUT, onTextFieldFocusedOut) ;
		}
		
		private function checkLostPasswordEmail():Boolean
		{
			var cond:Boolean;
			$("#lostPassword TextField").each(function(i:int, el:TextField) {
				switch(el.name) {
					case 'mail' :
						cond = FormsChecker.validate(el, FormsChecker.EMAIL) ;
						return cond ;
					break ;
				}
			} ) ;
			return cond ;
		}
		
		private function warnIncorrectLostPasswordEmail():void
		{
			trace("Email INCORRECT FOR PASSWORD REQUEST")
		}
		private function sendLostPasswordRequest():void
		{
			
			list.launch(0) ;
		}
		
		private function killLostPassword():void
		{
			var s:Sprite = getChildAt(1) as Sprite ;
			s.blendMode = BlendMode.ADD ;
			TweenLite.to(s, .4, { alpha:0, onComplete:function() {s.parent.removeChild(s) }} ) ;
		}
		
		
//////////////////////////////////////////////////////////////////////////////////////REGISTER
		private function initRegister():void
		{
			
			if($('#frame')[0].alpha != 0)TweenLite.to($('#frame')[0], .4, { alpha:0} ) ;
			var s:Sprite = new REGISTER() as Sprite ;
			addChildAt(s, 1) ;
			$(s).attr( { id:"register", name: "register" } );
			new Appear(s, 1) ;
			
			var val:Sprite = s.getChildByName('validate') as Sprite ;
			val.buttonMode = true ;
			val.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				if (checkRegisterInputs()) sendRegisterRequest() ;
				else warnIncorrectInformations() ;
				//
			});
			
		}
		
		private function sendRegisterRequest():void
		{
			//	copier principe de registry dans sendLoginRequest()
			
			list.next();
		}
		
		private function checkRegisterInputs():Boolean
		{
			var cond:Boolean;
			var password:String;
			$("#register TextField").each(function(i:int, el:TextField) {
				switch(el.name) {
					case 'prenom' :
					case 'city' :
					case 'nom' :
						cond = FormsChecker.validate(el, FormsChecker.ALPHA+" "+FormsChecker.MAX+"30") ;
						return cond ;
					break ;
					case 'address' :
						cond = FormsChecker.validate(el, FormsChecker.ALPHANUM+" "+FormsChecker.MAX+"30") ;
						return cond ;
					break;
					case 'mail' :
						cond = FormsChecker.validate(el, FormsChecker.EMAIL) ;
						return cond ;
					break ;
					case 'phone' :
						cond = FormsChecker.validate(el, FormsChecker.NUM+" "+FormsChecker.MAX+"10"+" "+FormsChecker.MIN+"10") ;
						return cond ;
					break ;
					case 'zip' :
						cond = FormsChecker.validate(el, FormsChecker.NUM+" "+FormsChecker.MAX+"5"+" "+FormsChecker.MIN+"5") ;
						return cond ;
					break ;
					case 'password' :
						password = el.text;
						cond = FormsChecker.validate(el, FormsChecker.ALPHANUM+" "+FormsChecker.MAX+"10"+" "+FormsChecker.MIN+"06") ;
						return cond;
					break ;
					case 'password_conf' :
						trace("EL TEXT : " + el.text+" PASSWORD : "+password) ;
						cond = el.text == password;
						return cond
					break ;
				}
			} ) ;
			var groupSucces:Boolean;
			var groupCond:int;
			$("#register RadioButton").each(function(i:int, el:RadioButton ) {
				if( el.selected ) groupCond ++;
			} )
			groupSucces = groupCond > 0 ;
			if(!groupSucces) return groupSucces ;
			//$("#register CheckBox").each(function(i:int, el:CheckBox ) {
				//trace(el + el.selected)
			//} )
			return cond ;
		}
		
		private function warnIncorrectInformations():void
		{
			trace("INCORRECT INFOES") ;
		}
		
		private function killRegister():void
		{
			var s:Sprite = getChildAt(1) as Sprite ;
			s.blendMode = BlendMode.ADD ;
			TweenLite.to(s, .4, { alpha:0, onComplete:function() { s.parent.removeChild(s) }} ) ;
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////EVENT HANDLERS
		
//////////////////////////////////////////////////////////////////////////////////////STEPEVENT HANDLERS
		private function onStepOneClose(e:StepEvent):void 
		{
			trace("CLOSING step : "+e.name) ;
		}
		private function onStepOneOpen(e:StepEvent):void 
		{
			step1.removeEventListener(StepEvent.OPEN, arguments.callee) ;
			trace(e.name) ;
		}
	}
}