package testing 
{
	import charts.ChartsManager;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * ...
	 * @author saz
	 */
	public class TestCharts 
	{
		private var __target:Sprite;
		private var manager:ChartsManager;
		
		public function TestCharts(tg:Sprite) 
		{
			__target = tg ;
			__sizeRect = new Rectangle(0, 0, tg.width, tg.height) ;
			var tf:TextField = ChartUtils.$TextField('hello world') ;
			__target.addChild(tf) ;
			manager = new ChartsManager().init(__target, __sizeRect) ;
			manager.createUpon(chartsData) ;
			//manager.createUpon(chartsData, false) ;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////// CHARTUTILS
import flash.text.TextField;
import flash.text.TextFormat;

class ChartUtils {
	static public function $TextField(text:String = '', textField:TextField = null, x:Number = 0, y:Number = 0, fontName:String = 'Arial', size:int = 10, color:uint = 0x2A2A2A, alpha:Number = 1):TextField
	{
		var tf:TextField = textField || new TextField() ;
		tf.selectable = false ;
		var fmt:TextFormat = tf.defaultTextFormat ;
		fmt.font = fontName || 'Arial' ;
		fmt.color = color ;
		fmt.size = size ;
		
		tf.defaultTextFormat = fmt ;
		tf.text = text ;
		//tf.setTextFormat(tf.defaultTextFormat) ;
		return tf ;
	}
	static public function toFixed(n:Number, p:* = 0):Number 
	{
		return Number(n).toFixed() ;
	}
}




var chartsData:XML = XML(
<chart type='proutPie'>
	<data>
		<key label='satisfaction' indix='89' unit="/100" total='100' >
			<tooltip>
				<![CDATA['this is the desc supposed to come in the chart for satisfaction']]>
			</tooltip>
		</key>
		<key label='visitors' indix='1600' unit='/year' total='80000' >
			<tooltip>
				<![CDATA['this is the desc supposed to come in the chart for visitors']]>
			</tooltip>
		</key>
		<key label='pricing' indix='2700' unit='euro' total='20000' >
			<tooltip>
				<![CDATA['this is the desc supposed to come in the chart for pricing']]>
			</tooltip>
		</key>
	</data>
</chart>
)