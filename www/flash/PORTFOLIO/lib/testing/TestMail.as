package testing 
{
	
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import org.bytearray.smtp.mailer.SMTPMailer;
	import org.bytearray.smtp.encoding.JPEGEncoder;
	import org.bytearray.smtp.encoding.PNGEnc;
	import org.bytearray.smtp.events.SMTPEvent;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.*;
	import tools.grafix.Draw;

	/**
	 * ...
	 * @author saz
	 */
	public class TestMail 
	{
		private var __target:Sprite;
		private var __myBitmap:BitmapData;
		private var __myEncoder;
		private var __send_btn:Sprite;
		private var __smtp_txt:TextField;
		private var __from_txt:TextField;
		private var __to_txt:TextField;
		private var __message_txt:TextField;
		private var __status_txt:TextField;
		private var __myMailer:SMTPMailer;
		private var __subject_txt:TextField;
		private var __error_txt:TextField;
		
		public function TestMail(tg:Sprite) 
		{
			__target = tg ;
			Security.allowDomain('~~') ;
			__error_txt = new TextField() ;
			__error_txt.type = TextFieldType.DYNAMIC ;
			__error_txt.background = true ;
			__error_txt.x = 10 ;
			__error_txt.y = 10 ;
			__error_txt.width = 80 ;
			__error_txt.height = 80 ;
			__error_txt.text = 'no error yet' ;
			__target.addChild(__error_txt) ;
		}
		
		public function required():void 
		{
			__send_btn = new Sprite() ;
			__send_btn.x = 300 ;
			__send_btn.y = 300 ;
			Draw.draw('rect', { g:__send_btn.graphics, color:0xFF0000, alpha:1 }, 0, 0, 100, 20) ;
			
			
			__smtp_txt = new TextField() ;
			__smtp_txt.type = TextFieldType.INPUT ;
			__smtp_txt.background = true ;
			__smtp_txt.x = 100 ;
			__smtp_txt.y = 100 ;
			__smtp_txt.width = 180 ;
			__smtp_txt.height = 25 ;
			__smtp_txt.text = 'smtp.free.fr' ;
			
			__from_txt = new TextField() ;
			__from_txt.type = TextFieldType.INPUT ;
			__from_txt.background = true ;
			__from_txt.x = 100 ;
			__from_txt.y = 150 ;
			__from_txt.width = 180 ;
			__from_txt.height = 25 ;
			__from_txt.text = 'takuansoho@free.fr' ;
			
			__to_txt = new TextField() ;
			__to_txt.type = TextFieldType.INPUT ;
			__to_txt.background = true ;
			__to_txt.x = 100 ;
			__to_txt.y = 200 ;
			__to_txt.width = 180 ;
			__to_txt.height = 25 ;
			__to_txt.text = 'sazaam@gmail.com' ;
			
			__subject_txt = new TextField() ;
			__subject_txt.type = TextFieldType.INPUT ;
			__subject_txt.background = true ;
			__subject_txt.x = 100 ;
			__subject_txt.y = 250 ;
			__subject_txt.width = 180 ;
			__subject_txt.height = 25 ;
			__subject_txt.text = 'hello subject' ;
			
			__message_txt = new TextField() ;
			__message_txt.type = TextFieldType.INPUT ;
			__message_txt.background = true ;
			__message_txt.x = 100 ;
			__message_txt.y = 300 ;
			__message_txt.width = 180 ;
			__message_txt.height = 200 ;
			
			__status_txt = new TextField() ;
			__status_txt.type = TextFieldType.DYNAMIC ;
			__status_txt.background = true ;
			__status_txt.x = 300 ;
			__status_txt.y = 100 ;
			__status_txt.width = 250 ;
			__status_txt.height = 100 ;
			
			
			__target.addChild(__send_btn) ;
			__target.addChild(__smtp_txt) ;
			__target.addChild(__from_txt) ;
			__target.addChild(__to_txt) ;
			__target.addChild(__subject_txt) ;
			__target.addChild(__message_txt) ;
			__target.addChild(__status_txt) ;
			
			
		}
		
		public function init():void 
		{
			try 
			{
				required() ;
				
				//__myMailer.authenticate('request@samuae.com', 'butokukai') ;
				
				
				// create the socket connection to any SMTP socket
				// use your ISP SMTP
				
				__myMailer = new SMTPMailer (__smtp_txt.text, 25);
				//__myMailer.authenticate('takuansoho', 'butokuka') ;
				// register events
				// event dispatched when mail is successfully sent
				__myMailer.addEventListener(SMTPEvent.MAIL_SENT, onMailSent);
				// event dispatched when mail could not be sent
				__myMailer.addEventListener(SMTPEvent.MAIL_ERROR, onMailError);
				// event dispatched when SMTPMailer successfully connected to the SMTP server
				__myMailer.addEventListener(SMTPEvent.CONNECTED, onConnected);
				// event dispatched when SMTP server disconnected the client for different reasons
				__myMailer.addEventListener(SMTPEvent.DISCONNECTED, onDisconnected);
				// event dispatched when the client has authenticated successfully
				__myMailer.addEventListener(SMTPEvent.AUTHENTICATED, onAuthSuccess);
				// event dispatched when the client could not authenticate
				__myMailer.addEventListener(SMTPEvent.BAD_SEQUENCE, onAuthFailed);

				// take the snapshot
				__myBitmap = new BitmapData ( __target.stage.stageWidth, __target.stage.stageHeight );

				// encode as JPEG with quality 100
				__myEncoder= new JPEGEncoder( 100 );

				__send_btn.addEventListener (MouseEvent.CLICK, onClick);

				__message_txt.text = "<img src='http://www.google.com/images/logo_sm.gif'</img><br><b>Picture file attached ! :)</b>";
			}catch (err:Error)
			{
				__error_txt.appendText(err) ;
			}
		}
		
		private function onClick ( pEvt:MouseEvent )
		{
			
			// replace this by any DisplayObject
			__myBitmap.draw ( __target );

			var myCapStream:ByteArray = __myEncoder.encode ( __myBitmap );

			// sends HTML email
			//__myMailer.sendHTMLMail ( __from_txt.text, __to_txt.text, __subject_txt.text, "<img src='http://www.google.com/images/logo_sm.gif'</img><br><b>Picture from HTML :)</b>");
			
			
			// send HTML email with picture file attached
			__myMailer.sendAttachedMail ( __from_txt.text, __to_txt.text, __subject_txt.text, __message_txt.text, myCapStream, "image.jpg");

		}

		private function onAuthFailed ( pEvt:SMTPEvent ):void
		{
			__status_txt.htmlText = "Authentication Error";
		}
		private function onAuthSuccess ( pEvt:SMTPEvent ):void
		{
			__status_txt.htmlText = "Authentication OK !";
			//trace(__myMailer.close())
		}
		private function onConnected ( pEvt:SMTPEvent ):void 
		{
			__status_txt.htmlText = "Connected : \n\n" + pEvt.result.message;
			__status_txt.htmlText += "Code : \n\n" + pEvt.result.code;
		}private function onMailSent ( pEvt:SMTPEvent ) 
		{
			// when data available, read it
			__status_txt.htmlText = "Mail sent :\n\n" + pEvt.result.message;
			__status_txt.htmlText += "Code : \n\n" + pEvt.result.code;
		}
		private function onMailError ( pEvt:SMTPEvent ):void 
		{
			__status_txt.htmlText = "Error :\n\n" + pEvt.result.message;
			__status_txt.htmlText += "Code : \n\n" + pEvt.result.code;
		}
		private function onDisconnected ( pEvt:SMTPEvent ):void 
		{
			__status_txt.htmlText = "User disconnected :\n\n" + pEvt.result.message;
			__status_txt.htmlText += "Code : \n\n" + pEvt.result.code;
		}
		private function socketErrorHandler ( pEvt:IOErrorEvent ) 
		{
			// when data available, read it
			__status_txt.htmlText = "Connection error !";
		}
	}
}