// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// Frocessing drawing library
// Copyright (C) 2008-09  TAKANAWA Tomoaki (http://nutsu.com) and
//					   	  Spark project (www.libspark.org)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// contact : face(at)nutsu.com
//

package frocessing.bmp 
{
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import frocessing.utils.IObjectLoader;
	import frocessing.utils.FLoadUtil;
	
	/**
	* Simple Image Loader
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FImageLoader extends FImage implements IObjectLoader
	{
		private var __loader:Loader;
		private var __status:int;
		private var __callback:Function;
		
		public var bgcolor:uint = 0x00000000;
		public var smooth:Boolean = false;
		
		/**
		 * 
		 */
		public function FImageLoader( url:String, loader:Loader = null, callback:Function=null, bitmapData:BitmapData=null ) 
		{
			super( bitmapData );
			if ( _bitmapdata == null )
				_bitmapdata = new BitmapData( 4, 4, true, bgcolor );
			
			__status   = 0;
			__callback = callback;	
			
			if ( loader != null )
				__loader = loader;
			else
				__loader = new Loader();
			
			FLoadUtil.load( url, __loader, __onComplete, __onError, int.MAX_VALUE );
		}
		
		
		private function __onComplete():void
		{
			var content:DisplayObject = __loader.content;
			try{
				if ( content.width != _bitmapdata.width || content.height != _bitmapdata.height )
				{
					var t:Boolean = _bitmapdata.transparent;
					dispose();
					_bitmapdata = new BitmapData( content.width, content.height, t, bgcolor );
				}
				else
				{
					_bitmapdata.fillRect( _bitmapdata.rect, bgcolor );
				}
				_bitmapdata.draw( content, null, null, null, null, smooth );
			}
			catch ( e:Error )
			{
				;
			}
			__loader.unload();
			__status = 1;
			__load_terminated();
		}
		
		private function __onError():void
		{
			__status = -1;
			__load_terminated();
		}
		
		private function __load_terminated():void
		{
			__loader = null;
			if ( __callback != null )
			{
				__callback.call();
				__callback = null;
			}
		}
		
		/**
		 * 0:loading, 1:complete, -1:error
		 */
		public function get status():int { return __status; }
		public function get success():Boolean { return status == 1; }
		
	}
	
}