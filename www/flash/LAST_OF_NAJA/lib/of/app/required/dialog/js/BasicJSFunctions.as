package of.app.required.dialog.js 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class BasicJSFunctions 
	{
		static public const popup:XML = <script><![CDATA[function ()
				{	
					window[name] = function (url, popname, width, height) 
					{
						var top=(screen.height - height)/2;
						var left=(screen.width - width)/2;   
						window.open(url, popname, "top=" + top + ",left=" + left + ",width=" + width + ",height=" + height + " ,menubar=no,scrollbars=no,statusbar=no");
					}
				}
				]]></script>;
		
		
		
		static public const alert:XML = <script><![CDATA[
				function(){
					window.walert = function(msg)
					{	
						window.alert(msg);
					}
				}
				]]></script>;
	}
	
}