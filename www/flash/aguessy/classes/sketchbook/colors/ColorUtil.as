
package sketchbook.colors{
	/**
	 * 色操作を支援するクラスです。
	 * <p>ColorUtilを用いることで、RGB,HSB,HLS間の色の変換等を行うことができます。</p>
	 * <p>AS2との互換性保持の為、このクラスは色情報のやり取りに無名オブジェクト<code>{r:uint, g:uint, b:uint}</code>を用いています。</p>
	 * <p>AS3で色を操作する場合には、Colorクラスの使用を推奨します。</p>
	 * 
	 * @example <listing version="3.0">
	 * var rgb:Object = {r:40, g:200, b:200}
	 * var hsb:Object = ColorUtils.RGB2HSB(rgb)
	 * trace(hsb.h,hsb.s,hsb.b)</listing>
	 * @see sketchbook.colors.Color
	 */
	public class ColorUtil{
		
	public function ColorUtil(){
		throw new Error("ColorUtil is static class");
	}
	
	
	
	/**
	 * 24ビットの色を、h,s,bを格納したオブジェクトに変換します。
	 * @param 24bit color.
	 * @returns HSB object {h:Hue, s:Saturation, b:Brightness}
	*/
	public static function getHSB(color:uint):Object
	{
		var rgbObj:Object = getRGB(color);
		return RGB2HSB(rgbObj.r,rgbObj.g,rgbObj.b);
	}
	
	
	/**
	 * 24ビットの色を、h,l,sを格納したオブジェクトに変換します。
	 * @param 24bit color
	 * @returns HLS object {h:Hue, l:Luminous, s:Saturation}
	 */
	public static function getHLS(color:uint):Object{
		var rgbObj:Object = getRGB(color);
		return RGB2HLS(rgbObj.r, rgbObj.g, rgbObj.b)
	}
	
	
	/**
	 * 24ビットの色を、r,g,bを格納したオブジェクトに変換します。
	 * 
	 * @param 24bit color
	 * @return Object that contains {r:Red, g:Green, b:Blue}
	 */
	public static function getRGB(rgb:uint):Object{
		return { 
					r: rgb >> 16 & 0xff,
					g: rgb >> 8 & 0xff,
					b: rgb & 0xff
					}
	}
	
	
	
	/**
	 * r,g,bを格納したオブジェクトの色を、HSBで定義しなおします。
	 * 
	 * @param Object with property h, s, b
	 * @param hue 0-255
	 * @param saturation 0-255
	 * @param brightness 0-255
	 */
	public static function setHSB( col:Object, h:Number, s:Number, b:Number):void
	{
		var rgbObj:Object = HSB2RGB(h,s,b);
		//trace(">>>>>>>>>>>>> : "+rgbObj.r, rgbObj.g, rgbObj.b);
		setRGB(col, rgbObj.r, rgbObj.g, rgbObj.b);
	}
	
	
	
	/**
	 * r,g,bを格納したオブジェクトの色を、HLSで定義しなおします。
	 * 
	 * @param Object with property h, s, b
	 * @param hue 0-255
	 * @param luminus 0-255
	 * @param saturation 0-255
	 */
	public static function setHLS( col:Object, h:Number, l:Number, s:Number):void{
		var rgbObj:Object = HLS2RGB(h,l,s);
		setRGB(col, rgbObj.r, rgbObj.g, rgbObj.b);
	}
	
	
	/**
	 * Set Color.value with R,G,B.
	 * 
	 * @param Object with property r, g, b
	 * @param red 0-255
	 * @param green 0-255
	 * @param blue 0-255
	 */
	public static function setRGB(obj:Object, r:uint, g:uint, b:uint):void{
		r = (r < 0)? 0 : (r>255)? 255: Math.round(r);
		g = (g < 0)? 0 : (g>255)? 255: Math.round(g);
		b = (b < 0)? 0 : (b>255)? 255: Math.round(b);
		obj.r = r<<16
		obj.g = g<<8
		obj.b = b
	}
	
	

	/**
	 * Create {h,s,b} Object from H, L, S value.
	 * 
	 * @param hue
	 * @param luminous
	 * @param saturation
	 * @return {h:Hue, s:Saturation, b:Brightness}
	 */
	public static function HLS2HSB(h:Number, l:Number, s:Number):Object{
		var rgbObj:Object = HLS2RGB(h,l,s);
		return RGB2HSB(rgbObj.r, rgbObj.g, rgbObj.b);
	}
	
	
	
	/**
	 * H, L, Sの値から、{r,g,b}のオブジェクトを取得します。
	 * 
	 * @param hue
	 * @param luminous
	 * @param saturation
	 * @return {r:Red, g:Green, b:Blue}
	 */
	public static function HLS2RGB(h:Number, l:Number, s:Number):Object{
		var max:Number, min:Number;
		
		h = (h<0)? h % 360+360 : (h>=360)? h%360: h;
		l = (l<0)? 0 : (l>100)? 100: l;
		s = (s<0)? 0 : (s>100)? 100: s;
		
		l *= 0.01;
		s *= 0.01;
		
		if(s==0){
			var val:Number = l * 255;
			return {r:val, g:val, b:val};
		}
		
		if( l < 0.5){
			max = l * (1+s) * 255
		}else{
			max = (l * (1-s) + s)*255
		}
		min = (2 * l)*255 - max;
		
		return _hMinMax2RGB(h, min, max);	//HSBとHLSの共通部分
	}
	
	
	
	/**
	 * Converts H, S, B values to {h:Hue, l:Luminous, s:Saturation} Object
	 * 
	 * @param hue
	 * @param saturation
	 * @param brightness
	 * @return {h:Hue, l:Luminous, s:Saturation}
	 */
	public static function HSB2HLS(h:Number, s:Number, b:Number):Object{
		var rgbObj:Object = HSB2RGB(h,s,b);
		return RGB2HLS(rgbObj.r, rgbObj.g, rgbObj.b);
	}
	
	
	
	/**
	 * convert H, S, B values to {r:red, g:green, b:blue} Object
	 * 
	 * @param hue 0-360
	 * @param saturation 0-100
	 * @param brightness 0-100
	 * 
	 * @return contains r(0-255), g(0-255), n(0-255)
	*/
	public static function HSB2RGB(hue:Number, sat:Number, bri:Number):Object{
		
		hue = (hue<0)? hue % 360+360 : (hue>=360)? hue%360: hue;
		sat = (sat<0)? 0 : (sat>100)? 100: sat;
		bri = (bri<0)? 0 : (bri>100)? 100: bri;		
		
		sat *= 0.01;
		bri *= 0.01;
		
		var val:Number
		if(sat == 0){
			val = bri*255;
			return {r:val, g:val, b:val}
		}
		
		var max:Number = bri*255;
		var min:Number = max*(1-sat);
		
		return _hMinMax2RGB(hue, min, max);
	}
	
	
	
	/**
	 * convert R,G,B values to {h:huse,s:saturation,b:brightness} Object
	 * 
	 * @param r Red value 0-255
	 * @param g Green value 0-255
	 * @param b Blue value 0-255
	 * 
	 * @return contains h(0-360), s(0-100), b(0-100)
	*/
	public static function RGB2HSB(r:uint, g:uint, b:uint):Object{
		r = (r < 0)? 0 : (r>255)? 255: Math.round(r);
		g = (g < 0)? 0 : (g>255)? 255: Math.round(g);
		b = (b < 0)? 0 : (b>255)? 255: Math.round(b);
		
		var min:Number = Math.min(r, g, b);
		var max:Number = Math.max(r, g, b);
		
		//saturation
		if(max==0){
			//明度が０の時は黒
			return {h:0, s: 0, b: 0}
		}else{
			var s:Number = (max - min)/max * 100;
		}
		
		//明度
		//変数名b (BLUE) と混同しないように注意
		var bri:Number = max / 255 * 100;
		
		//色相
		var h:Number = _getHue(r, b, g, max, min);
		return {h:h, s:s, b:bri}
	}


	/**
	 * convert R,G,B values to {h:Hue,l:Luminous,s:Saturation} Object
	 * 
	 * @param r Red value 0-255
	 * @param g Green value 0-255
	 * @param b Blue value 0-255
	 * 
	 * @return contains {h:Hue,l:Luminous,s:Saturation}
	*/
	public static function RGB2HLS(r:uint, g:uint, b:uint):Object{
		r = (r < 0)? 0 : (r>255)? 255: Math.round(r);
		g = (g < 0)? 0 : (g>255)? 255: Math.round(g);
		b = (b < 0)? 0 : (b>255)? 255: Math.round(b);
		
		var min:Number = Math.min(r,g,b);
		var max:Number = Math.max(r,g,b);
		var l:Number = (max + min)*0.5 / 255 * 100;
		
		var dist:Number = (max - min);
		var h:Number
		var s:Number
		if(dist==0){
			h = 0;
			s = 0;
		}else{
			if( l < 127.5){
				s = dist/(max+min)*100
			}else{
				s = dist/(510-max-min)*100
			}
		
			h = 360 - _getHue(r,g,b,max, min);
		}
		
		return {h:h, l:l, s:s}
	}
	
	
	public static function getLuminous( color:uint ) : uint
	{
		var r:uint = color >> 16 & 0xff;
		var g:uint = color >> 8 & 0xff;
		var b:uint = color & 0xff;

		var min:Number = Math.min(r,g,b);
		var max:Number = Math.max(r,g,b);
		var l:Number = (max + min)*0.5 / 255 * 100;
		
		
		return l;
	}
	
	
	
	
	
	/**
	--------------------------------------------------------------------------------
		INTERNAL METHOD
	--------------------------------------------------------------------------------
	*/
	
	
	
	/*
	* function: _hMinMax2RGB
	* 
	* internal use only
	* 
	* calcurates RGB used in hls, hsb conversion
	*/
	private static function _hMinMax2RGB(h:Number, min:Number, max:Number):Object{
		var r:Number,g:Number,b:Number;
		var area:Number = Math.floor(h / 60);
							  
		switch( area){
			case 0:
				r = max
				//0 - 0, 60-255
				g = min+h * (max-min)/ 60;
				b = min
				break;
			case 1:
				r = max-(h-60) * (max-min)/60;
				g = max
				b = min
				break;
			case 2:
				r = min 
				g = max
				b = min+(h-120) * (max-min)/60;
				break;
			case 3:
				r = min
				g = max-(h-180) * (max-min)/60;
				b =max
				break;
			case 4:
				r = min+(h-240) * (max-min)/60;
				g = min
				b = max
				break;
			case 5:
				r = max
				g = min
				b = max-(h-300) * (max-min)/60;
				break;
			case 6:
				r = max
				//0 - 0, 60-255
				g = min+h  * (max-min)/ 60;
				b = min
				break;
		}
		
		r = Math.min(255, Math.max(0, Math.round(r)))
		g = Math.min(255, Math.max(0, Math.round(g)))
		b = Math.min(255, Math.max(0, Math.round(b)))
		
		return {r:r, g:g, b:b}
	}




	/*
	* funciton: _getHue
	* 
	* internal use only
	* 
	*　calucurates hsb
	*/
	
	private static function _getHue(r:Number, g:Number, b:Number, max:Number, min:Number):Number{
		var range:Number = max - min;
		if(range==0){
			return 0;
		}
		
		var rr:Number = (max - r)
		var gg:Number = (max - g)
		var bb:Number = (max - b)
		
		var h:Number
		switch(max){
			case r:
				h = bb - gg
				break;
			case g:
				h = 2 *range+ rr - bb
				break;
			case b:
				h = 4 *range+ gg - rr
				break;
		}
		
		h*=-60;
		h/=range;
		h = (h<0)? h+360: h;
		
		return h
	}
	
	
}
}