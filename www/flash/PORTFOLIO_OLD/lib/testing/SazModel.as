package testing 
{
	import of.app.required.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SazModel 
	{
		
		public function SazModel() 
		{
			VirtualSteps;
		}
		
		public var conf_xml:XML = <scheme>
			<flash.display.Sprite id="universe" name="universe">
				<flash.display.Sprite id="console" name="console" />
				<flash.display.Sprite id="content" name="content" />
				<flash.display.Sprite id="nav" name="nav" />
				<flash.display.Sprite id="space" name="space" />
			</flash.display.Sprite>
		</scheme> ;
		public var plugin_xml:XML = <plugin>
			<class ns="of::HomeStep"  extends="of.app.required.steps::VirtualSteps" >
				<dependency ns="flash.utils::Dictionary" />
				<dependency ns="flash.display::Loader" />
				<dependency ns="tools.grafix::Draw" />
				<dependency ns="pro.layer::Layer" />
				<var>
					<![CDATA[
						private static var dict:Dictionary = new Dictionary() ;
					]]>
				</var>
				<var>
					<![CDATA[
						protected var o:Object = {} ;
					]]>
				</var>
				<var>
					<![CDATA[
						public static var arr:Array = [] ;
					]]>
				</var>
				<constructor>
					<![CDATA[
						onAime(true) ;
					]]>
				</constructor>
				<method>
					<![CDATA[
						private function onAime(cond:Boolean):void
						{					
							var layer:Layer ;
							if (cond) {
								trace("opening aime") ;
								layer = Context.$get(Layer).attr( { id:"LAYER", name:"LAYER" } )[0] ;
								Draw.draw("rect", { g:layer.graphics, color:0x0, alpha:.3 }, 0, 0, 600, 400) ;
							}else {
								trace("closing aime") ;
								layer = Context.$get("#LAYER")[0] ;
							}
						}
					]]>
				</method>
			</class>
		</plugin> ;
	}
	
}