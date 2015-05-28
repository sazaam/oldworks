package air.widgets 
{
	import flash.filesystem.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.desktop.*;

	/**
	* Cette classe sert à la mise à jour automatique de l'application.
	* Quand une maj est faite, déposer le nouveau fichier air sur un serveur, ainsi qu'un fichier xml formaté ainsi :
	* <?xml version="1.0" encoding="utf-8" ?>
	*       <data>
	*               <version>3.0</version>
	*       </data>
	* en renseignant le numéro de version correspondant à la nouvelle version.
	* Ensuite, il faut crér un nouvel objet XUpdater et invoquer la méthode checkForUpdate.
	* 
	* @author Erik Guittière
	*/

	public class XUpdater {

		private var xml:XML;
		private var xmlString:String;
		private var urlString:String;
		private var urlReq:URLRequest;
		private var urlStream:URLStream;
		private var fileData:ByteArray;
		private var fileStream:FileStream;
		private var file:File;
		private var updater:Updater;

		public function XUpdater() {
			urlStream = new URLStream();
			fileData = new ByteArray();
		}

		/**
		* Lancement de la vérification de version
		* @param       xmlPath String, url du xml qui contient le numéro de version de la dernière version
		* @param       airPath String, url de la dernière version du fichier air
		*/

		public function checkForUpdate(xmlPath:String = "", airPath:String = ""):void {
			if (xmlPath == "") {
				   return;
			}
			xmlString = xmlPath;
			urlString = airPath;
			var ulo:URLLoader = new URLLoader();
			ulo.addEventListener(Event.COMPLETE, parseXML);
			ulo.load(new URLRequest(xmlString));
		}

		private function parseXML(e:Event):void {
			xml = new XML(e.target.data);
			compareVersion();
		}

		private function compareVersion():void {
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appDescriptor.namespace();
			var appVersion:String = appDescriptor.ns::version;
			if (appVersion != xml.version.toString()) {
					urlStream.addEventListener(Event.COMPLETE, loaded);
					urlReq = new URLRequest(urlString);
					urlStream.load(urlReq);
			}
		}

		private function writeAirFile():void {
			var t:Array = urlString.split("/");
			var appName:String = t.pop() as String;
			file = File.applicationStorageDirectory.resolvePath(appName);
			fileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(fileData, 0, fileData.length);
			fileStream.close();
			xUpdate();
		}

		private function xUpdate():void{
			updater = new Updater();
			var version:String = xml.version.toString();
			updater.update(file, version);
		}

		private function loaded(event:Event):void {
			urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
			writeAirFile();
		}
	}
}