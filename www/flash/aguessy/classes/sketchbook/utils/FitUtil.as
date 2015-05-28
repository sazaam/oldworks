package sketchbook.utils
{
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	/**
	 * 長辺fit、短辺fitでrectをリサイズする為のサイズを計算するクラス。
	 * 
	 * var r : Rect = FitUtil.fitRectLongEdge( new Rectangle(0,0,320,240), new Rectangle(0,0,Stage.stageWidth, Stage.stageHeight));
	 * 
	 */
	 
	public class FitUtil
	{
		/**
		 * 矩形Aの短辺が、矩形Bの辺とフィットするようなリサイズ用Rectを返す
		 * 画面全体に写真を表示する時等に用いる
		*/
		public static function fitRectShortEdge( rectA : Rectangle, rectB : Rectangle ) : Rectangle
		{
			var rect : Rectangle = new Rectangle(0,0,0,0);
			var hRatio : Number = rectB.height / rectA.height;
			var wRatio : Number = rectB.width / rectA.width;
			if( hRatio < wRatio )
			{
				//W 基準でリサイズ
				rect.width = rectB.width;
				rect.height = rectA.height * wRatio;
			}else{
				//H 基準でリサイズ
				rect.width = rectA.width * hRatio;
				rect.height = rectB.height;	
			}
			
			rect.x = rectB.x + ( rectB.width - rect.width ) * 0.5;
			rect.y = rectB.y + ( rectB.height - rect.height ) * 0.5;
			
			return rect;
		}
		
		
		
		/**
		 * 矩形Aの長辺が、矩形Bの長辺とフィットするようなリサイズ用Rectを返す
		 * 矩形の中に写真を配置する時などに用いる
		*/
		public static function fitRectLongEdge( rectA : Rectangle, rectB : Rectangle ) : Rectangle
		{
			var rect : Rectangle = new Rectangle(0,0,0,0);
			var hRatio : Number = rectB.height / rectA.height;
			var wRatio : Number = rectB.width / rectA.width;
			
			if( hRatio < wRatio )
			{
				// H 基準でリサイズ
				rect.width = rectA.width * hRatio;
				rect.height = rectB.height;
			}else{
				// W 基準でリサイズ
				rect.width = rectB.width;
				rect.height = rectA.height * wRatio;
			}
			
			rect.x = rectB.x + ( rectB.width - rect.width ) * 0.5;
			rect.y = rectB.y + ( rectB.height - rect.height ) * 0.5;
			
			return rect;
		}
	}
}