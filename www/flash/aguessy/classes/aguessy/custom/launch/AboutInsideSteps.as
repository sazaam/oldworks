package aguessy.custom.launch 
{
	
	import aguessy.custom.launch.graph3D.Nav3D;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import saz.helpers.sprites.Smart;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class AboutInsideSteps extends VirtualSteps
	{
		private var user:XUser;
		private var currentNavIndex:int;
		private var __curImgStep:LoadingSteps;
		
		
		public function AboutInsideSteps(_id:Object) 
		{
			super(_id, new CommandQueue(new Command(this, openAboutInside, true)), new CommandQueue(new Command(this, openAboutInside, false))) ;
			user = Root.user ;
		}
		
		public function onCurrent(arr:XML):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			
			var ind:int = arr.childIndex() ;
			var mcInside:Sprite = Context.$get("#PAGEINSIDE")[0] ;
			var spr:Smart = Context.$get("#" + id + "_" + String(ind))[0] ;
			var r:Rectangle = mcInside.scrollRect ;
			var l:int = mcInside.numChildren ;
			TweenLite.to(mcInside,.2,{x:-int(spr.properties.x),onComplete:nav3D.g3D.__displayer.checkForContainedSprites})
		}
		
		private function openAboutInside(cond:Boolean = true):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			
			if (cond) {
				nav3D.appendText(this) ;
				nav3D.stop() ;
				nav3D.finalEvents(this) ;
				nav3D.reset() ;
				nav3D.evaluate(this) ;
				nav3D.play() ;
				nav3D.addSubSection(this) ;
			}else {
				nav3D.stop()
				nav3D.appendText(this, false) ;
				nav3D.addSubSection(this, false) ;
				nav3D.finalEvents(this,false) ;
				nav3D.reset() ;
				nav3D.evaluate(parent) ;
				nav3D.play()
			}
		}
		
		private function closeAboutInside():void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			
			
		}
	}
}