package aguessy.custom.launch.visuals 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import gs.easing.Expo;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import saz.helpers.video.StreamPlayer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class PlayerGraphics 
	{
		public var NAV_MC:Sprite;
		
		internal var __tg:FLVManager ;
		internal var __nav:Sprite;
		private var __startY:int;
		private var __video:Video;
		
		
		
		public function PlayerGraphics() 
		{
			
		}
		
		internal function init(tg:FLVManager):void
		{
			__tg = tg ;
			__video = __tg.__player.video ;
		}
		
		internal function drawNav(cond:Boolean = true):void
		{
			if (cond) {
				__nav = Context.$get(NAV_MC).attr( { id:"VIDEONAV", name:"VIDEONAV", x:0, y:__tg.height - 25 } ).appendTo(Context.$get("#VIDEOCONTAINER")[0])[0] ;
			}else {
				try 
				{
					Context.$get("#VIDEONAV").remove() ;
				}catch (e:Error)
				{
					
				}
				__nav = null ;
			}
		}
		
		internal function drawVideo(cond:Boolean = true):void
		{
			var vidCont:Sprite ;
			
			var back:Sprite = Context.$get("#VM")[0] ;
			var infos:Sprite = Context.$get("#INFOS")[0] ;
			var obj:Object = { } ;
			if (cond) {
				vidCont = Context.$get(Sprite).attr({id:"VIDEOCONTAINER"}).append(__video)[0] ;
				//__startY = infos.y ;
				//obj.y = infos.y + __video.height + 9 ;
				__tg.addChild(vidCont) ;
				back.alpha = .07 ;
			}else {
				vidCont = Context.$get("#VIDEOCONTAINER")[0] ;
				__tg.removeChild(vidCont) ;
				//obj.y = __startY ;
				__tg.__finished = false ;
				back.alpha = 1 ;
			}
			//obj.ease = Expo.easeOut ;
			//infos.alpha = 0 ;
			//infos.y = obj.y ;
			//TweenLite.to(infos,.8,{alpha:1}) ;
		}
		
	}
	
}