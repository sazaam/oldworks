package sketchbook.graphics
{
	import flash.display.Graphics;
	
	/**
	 * Graphics.beginFillをクラス化したものです。
	 * 
	 * <p>Fillの設定をクラス化することで、複数のDisplayObjectで塗り情報を共有化することができます。</p>
	 * 
     * @example <listing version="3.0">
	 * var fill:Fill = new Fill(0x000000,1);
	 * fill.applySetting(mySprite.graphics);
	 * mySprite.drawCircle(0,0,100);
	 * mySprite.endFill();</listing>
	 */
	public class Fill
	{
		public var color:uint
		public var alpha:Number
		
		public function Fill(color:uint=0, alpha:Number=1.0)
		{
			this.color = color
			this.alpha = alpha
		}
		
		/**
		 * 対象のGraphicsインスタンスの、beginFillを実行します。
		 * 渡されるパラメーターはこのインスタンスのプロパティです。
		 */
		public function applySetting(g:Graphics):void
		{
			g.beginFill(color, alpha)	
		}
		
		public function clone():Fill
		{
			return new Fill(color,alpha)
		}
	}
}