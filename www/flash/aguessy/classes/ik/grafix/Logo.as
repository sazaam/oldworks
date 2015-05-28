package ik.grafix 
{
	import asSist.*;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Logo extends Sprite
	{
		private var logoTitle:XML = <flash.text.TextField selectable="false" id="sazaam" autoSize="none" width="320" x="0" y="160" multiline="true">
															<filters>
																<flash.filters.BlurFilter blurX="10" blurY="10" quality="3" />
															</filters>
															<htmlText><![CDATA[SABLE]]></htmlText>
															<defaultTextFormat>
																<flash.text.TextFormat font="Impact" letterSpacing="20" align="center" size="40" color="0xFFFFFF" />
															</defaultTextFormat>
														</flash.text.TextField> ;
														
		
		
		public function Logo() 
		{
			with (graphics) {
			//graphics.beginGradientFill("radial",[0x000000, 0x222222],[100,100],[0, 0xFF],new Matrix(),"reflect","linearRGB",0.7);
			beginFill(0xFFFFFFF, 100);
			moveTo(53, 70);
			lineTo(120, 70);
			lineTo(67, 148);
			lineTo(0, 148);
			moveTo(145, 70);
			lineTo(212, 70);
			lineTo(159, 148);
			lineTo(92, 148);
			moveTo(275, 70);
			lineTo(342, 70);
			lineTo(260, 109);
			lineTo(293, 148);
			lineTo(226, 148);
			lineTo(195, 109);
			endFill();
			}
			$(logoTitle).appendTo(this) ;
		}
	}
}