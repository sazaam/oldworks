package of.app.required.loading 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.text.Font;
	//import flash.utils.ByteArray;
	//import flash.utils.IDataInput;
	import of.app.required.formats.FileFormat;
	import of.app.required.regexp.BasicRegExp;
	//import of.app.required.zip.ZipEntry;
	//import of.app.required.zip.ZipFile;
	/**
	 * ...
	 * @author saz
	 */
	public class ZipLoadingsController extends LoadingsController
	{
		
		public function ZipLoadingsController() 
		{
			//super() ;
		}
		///////////////////////////////////////////////////////////////////////////////// ZIP ANSWER
		//static private function zipAnswer(req:XLoaderRequest, r:ByteArray,evt:Event):*
		//{
			//var z:ZipFile = new ZipFile(IDataInput(r as IDataInput)) ;
			//req.response = z ;
			//var resp:Object = {};
			//var entries:Array = z.entries ;
			//var l:int = entries.length ;
			//resp.count = [] ;
			//for (var i:int = 0 ; i < l ; i++ ) {
				//var entry:ZipEntry = entries[i] ;
				//if (entry.isDirectory())  resp.count.push(i) ;
				//else 
				//{
					//var name:String = entry.name ;
					//var ext:String = testUrl(name,name.indexOf("fonts") != -1)
					//switch(ext) {
						//case FileFormat.FONTS :
						//case FileFormat.SWF :
						//case FileFormat.IMG :
							//zipAnswerTreat(req, name, ext, z, entry , resp, evt) ;
						//break ;
						//case FileFormat.XML :
							//resp[name] = new XML(z.getInput(entry)) ; 
							//LoadedData.insert(ext.toUpperCase(), name, resp[name]) ;
							//resp.count.push(i) ;
						//break ;
					//}
				//}
			//}
			//if (resp.count.length == l) {
				//req.completed = true ;
				//req.dispatchEvent(evt) ;
			//}
			//return z ;
		//}
///////////////////////////////////////////////////////////////////////////////// ZIP ANSWER TREAT
		//static private function zipAnswerTreat(req:XLoaderRequest, name:String, ext:String, z:ZipFile, entry:ZipEntry, resp:Object ,evt:Event):void
		//{
			//var s:String = name ;
			//var answer:* ;
			//var dataLoader:Loader = new Loader() ;
			//var l:int = z.entries.length ;
			//dataLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void { 
				//e.target.removeEventListener(e.type, arguments.callee) ;
				//switch(ext) {
					//case  FileFormat.FONTS :
						//var c:Array = name.match(BasicRegExp.url_ID_FROM_URL_RE) ;
						//var str:String = Boolean(c as Array)? c[0] : name ;
						//var font:Class = Loader(dataLoader).contentLoaderInfo.applicationDomain.getDefinition(str) as Class ;
						//Font.registerFont(font) ;
						//answer =  font ;
					//break ;
					//case  FileFormat.SWF :
						//answer = e.currentTarget.content as Sprite ;
					//break ;
					//case  FileFormat.IMG :
						//answer = e.currentTarget.content as Bitmap ;
					//break ;
				//}
				//resp[name] = answer ;
				//resp.count.push("NaN") ;
				//LoadedData.insert(ext.toUpperCase(), name, answer) ;
				//if (resp.count.length == l) {
					//req.completed = true ;
					//req.dispatchEvent(evt) ;
				//}
			//} )
			//dataLoader.loadBytes(z.getInput(entry)) ;
		//}
	}
}