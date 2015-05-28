package
{
	import flash.display.*;
	import flash.text.*;
	import gyuque.effects.*;
	public class PGDemo extends Sprite
	{
		private var mOffscreenData:BitmapData;
		private var mOffscreenBitmap:Bitmap;

		function PGDemo()
		{
			mOffscreenData = new BitmapData(800, 600, true, 0);
			mOffscreenBitmap = new Bitmap(mOffscreenData,"auto",true);

			var t:TextField = new TextField();
			var fmt:TextFormat = new TextFormat();
			//t.width = 220;
			fmt.size = 220;
			fmt.bold = true;
			fmt.font = new Font1().fontName;
			fmt.color = 0xffffff;
			t.embedFonts = true;
			t.defaultTextFormat = fmt;
			t.alpha = .3
			t.text = "sazaam";
			
			mOffscreenData.draw(t);
			addChild(mOffscreenBitmap);
			var pg:PantsGlow = new PantsGlow(mOffscreenData);
			addChild(pg);
			pg.x = mOffscreenBitmap.x;
			pg.y = mOffscreenBitmap.y;
			
			pg.setTargetRect(0, 0, 800, 600);
			pg.setEffectCenter(87, 15);
			pg.effectWidth = 120;
			pg.sampling = .06;	
			pg.loopEnd = 50;

			pg.prepare();
		}
	}
}