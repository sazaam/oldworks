package air.widgets 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author saz
	 */
	public class BasicWidgetExample extends Sprite
	{
		
		public function BasicWidgetExample ()
		{
			var simpleWidget:BasicWidget = new BasicWidget()
			simpleWidget.hideWindowInTaskBar = true
			simpleWidget.init(this)
		}
		
	}
	
}