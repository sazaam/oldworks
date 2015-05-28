package air.widgets.utils
{	
	import flash.display.Loader;
	import flash.filesystem.*;
	
	public class WriteFile {
		
		/*
		UTILISATION :
		var Write:WriteFile = new WriteFile();
		
		Write.ecriture("nomDuFichier", "stringAEcrire");
		
		Renvoie une string si fichier existe
		Renvoie "empty" si fichier n'existe pas
		
		Write.supprime("nomDuFichier");
		*/
		
		function WriteFile() { }
		
		public function ecriture(fileName:String, toWrite:String, format:String=".txt"):void {
			var imageDir:File = File.userDirectory.resolvePath("LBP/");
			//File.u
			var newFile:File = new File(imageDir.nativePath + File.separator + fileName + format);
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(newFile, FileMode.WRITE);
			fileStream.writeUTFBytes(toWrite);
			fileStream.close();
		}
		
		public function lecture(fileName:String, format:String=".txt"):String {
			var imageDir:File = File.userDirectory.resolvePath("LBP/" + fileName + format);
			if (imageDir.exists) {
				var fileStream:FileStream = new FileStream();
				fileStream.open(imageDir, FileMode.READ);
				var contents:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
				return contents;
			} else {
				return "empty";
			}			
		}
		
		public function supprime(fileName:String):void {
			var imageDir:File = File.userDirectory.resolvePath("LBP/");
			var newFile:File = new File(imageDir.nativePath + File.separator + fileName + ".txt");
			newFile.deleteFile();
		}
		
	}	
}