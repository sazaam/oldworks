package cv 
{
	import asSist.$;
	import cv.deposit.Deposit;
	import cv.exec.Executer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import saz.helpers.loadlists.loaders.MultiLoaderRequest;
	import saz.helpers.loadlists.loaders.XMLLoader;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Test extends Sprite
	{
		
		public function Test() 
		{
			$(stage).attr( { scaleMode: "noScale", align: "TL" } ) ;
			addEventListener(Event.ADDED_TO_STAGE,onAdded) ;
			
		}
		
		private function hackClips():void
		{
			var d:Deposit = new Deposit()
			Deposit.embedContents = true ;
			d.init() ;
		}
		
		private function onAdded(e:Event):void 
		{
			//var testt:Sprite = new Sprite() ;
			//testt.graphics.beginFill(0xFF3300) ;
			//testt.graphics.drawRect(0, 0, stage.stageWidth,stage.stageHeight) ;
			//testt.graphics.endFill() ;
			//addChild(testt)
			//$(testt).attr({id:"DEBUGSPRITE"}) ;
			//
			var tf:TextField = new TextField() ;
			tf.text = "CACA" ;
			addChild(tf) ;
			
			$(tf).attr({id:"DEBUGTXT"}) ;
			
			var xLoader:XMLLoader = new XMLLoader() ;
			//xLoader.loader.addEventListener(ProgressEvent.PROGRESS, onXMLProgress) ;
			xLoader.loader.addEventListener(Event.COMPLETE, onXMLComplete) ;
			xLoader.add(new MultiLoaderRequest("xml/datas/data_sections.xml", "data_sections")) ;
			xLoader.loadAll() ;
		}
		//////////////////////////////////////////////////////////HERE WE GO
		private function onXMLComplete(e:Event):void 
		{
			hackClips() ;
			Executer.init(this) ;
			Executer.launch(XMLLoader.XMLS["data_sections"]) ;
			
			//trace(XMLLoader.XMLS["data_sections"])
		}
	}
}