package pro 
{
	import flash.display.Sprite;
	import naja.tools.commands.BasicCommand;
	import naja.model.data.loadings.loaders.DefaultLoaderGraphics;
	import naja.model.Root;
	import pro.graphics.SazLoaderGraphics;
	import pro.graphics.SquareGraphics;
	import pro.steps.BeginUnique;
	import pro.steps.Unique;
	
	/**
	 * This NajaMain is an example of a project's AS3 Entry ('linked') Class
	 * 
	 * In order to have NAJA's packages correct initializing, we have to extends this class to
	 * a naja.model.Root class.
	 * 
	 * 
	 * 
	 * 
	 * Then, firstly we shall initialize site Pathes, since we may receive them from the loaderInfo.parameters object, 
	 * thus let's set them default here, for local (and with no browser) testing, by creating an Object of pathes
	 * 
	 * We'll stock'em into a naja.model.XUser, since it is the place for any 'User Experience accumulated data' 
	 * that we'll use thru one and only one user experience.
	 * 
	 * We have now our physical Entry Point(this main class), the pathes set as well,
	 * we finally need an other Entry Point to all custom classes, let's specify it now in 'Root.user.customizer'
	 * 
	 * But first, I want to let know who will be my first 'DefaultLoaderGraphics', 
	 * which will take care of representing visually the progress of our app's primary loadings.
	 * which I would do so, creating a new Class (CustomLoaderGraphics for example) which would extend 
	 * naja.model.data.loadings.loaders.DefaultLoaderGraphics,
	 * or just implement 
	 * naja.model.data.loadings.loaders.I.ILoaderGraphics
	 */
	public class SazMain extends Root
	{
		public function SazMain() 
		{
			trace('CTOR >> ' + this) ;
			
			var o:Object = { 
				root:"../" ,
				//config:"__config__.zip",
				config:"__config__/__config__.xml",
				zip:"zip/",
				fonts:"<swf>fonts/",
				html:"html/",
				xml:"xml/",
				swf:"swf/",
				img:"img/",
				flv:"flv/",
				pdf:"pdf/"
			} ;
			Root.user.sitePathes = o ;
			Root.user.loaderGraphics = new SazLoaderGraphics() ;
			
			//Root.user.initModule = new SazConfig() ;
			
			Root.user.customizer = new BeginUnique() ;
			
			
			
		}
	}
}