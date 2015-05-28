package sketchbook.colors
{
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	/**
	 * 色情報を表現したクラスです。
	 * <p>Colorクラスは、RGB,HSBによる色の操作を提供します。<br/>
	 * このクラスはアルファチャンネルをサポートしません。</p>
	 * <p>ColorクラスはvalueOfを実装している為インスタンスをuint型に変換することで、色への代入値として使用することができます。</p>
	 * <p>Colorクラスの内部処理はColorUtilクラスに委譲されています。<br/>
	 * Colorクラスを用いずに色の操作をう場合、ColorUtilクラスで同様の操作を行うこともできます。</p>
	 * 
	 * <p>TODO: 色の各要素は遅延評価なのでR,G,B,H,S,Bに対してデータのバインディングができない。速度優先にしてバインディング自体を諦めるか？</p>
	 * <p>ColorUtilを使うと、brightnessを０とかにすると、必然的にhueやsaturationも０になる。本来のh,sを保存すべきか？</p>
	 * 
	 * @example <listing version="3.0">
	 * var col:Color = new Color(0xff0000);
	 * col.hue = 120;
	 * 
	 * var bmd:BitmapData = new BitmapData(100,100,false,uint(col));	//Colorインスタンスを直接代入</listing>
	 * 
	 * @see sketchbook.colors.ColorUtil
	 */
	 
	public class ColorSB
	{
		//simple 0xRRGGBB value
		private var _value:uint
		
		private var _red:uint = 0 
		private var _green:uint = 0
		private var _blue:uint = 0
		
		private var _hue:Number = 0 
		private var _saturation:uint = 0
		private var _brightness:uint = 0
		
		//flag to check update
		private var _hsbUpdate:Boolean
		private var _rgbUpdate:Boolean
		
		//brightnes, saturationのいずれかが0のとき、hueが０になる現象を回避する為のフラグ
		private var _holdHue:Boolean = false
		//brightnessが0のとき、saturationが０に変更される現象を回避する為のフラグ
		private var _holdSaturation:Boolean = false
		
		/**
		 * @param color 24bit unit value for color. This class does not support alpha channel
		 */
		public function ColorSB(color:uint=0)
		{
			_value = color
			
			_hsbUpdate = true
			_rgbUpdate = true
		}
		
		/**
		 * R,G,Bの3つの値から色を定義します。
		 * 
		 * @param red 0-255
		 * @param green 0-255 
		 * @param blue 0-255
		 */
		public function setRGB(r:uint, g:uint, b:uint):void
		{
			r = Math.min(255, Math.max(0, r))
			g = Math.min(255, Math.max(0, g))
			b = Math.min(255, Math.max(0, b))	
			
			value = (r << 16) | (g << 8 ) | b
		}
		
		
		/**
		 * 色相(hue), 彩度(saturation), 明度(brightnessChanges)から色を定義します。
		 * 
		 * @param hue 0-360
		 * @param saturation 0-100 
		 * @param brightness 0-100
		 */
		public function setHSB(hue:Number, saturation:Number, brightness:Number):void
		{
			var rgbInfo:Object = ColorUtil.HSB2RGB(hue,saturation,brightness)
			setRGB(rgbInfo.r, rgbInfo.g, rgbInfo.b)
		}
		
		
		/**
		 * Color インスタンスの複製を返します。
		 * 
		 * @return The copy of the Color instance
		 */
		public function clone():ColorSB
		{
			return new ColorSB(this.value)
		}
		
		
		/** 色を24ビットで表現した数値です */
		public function get value():uint
		{
			return _value
		}
		
		public function set value(color:uint):void
		{
			if(_value == color) return
			_value = color
			_hsbUpdate = true
			_rgbUpdate = true
		}
		
		public function getValue32(alpha:Number):uint
		{
			alpha = uint(alpha*255);
			var val:Number = (alpha<<24) | value
			return val
		}
		
		
		
		/*
		---------------------------------------------
		RGB getter / setter
		---------------------------------------------
		*/
		
		/** 赤成分。 0-255 */
		public function get red():uint
		{ 
			updateRGB()
			return _red
		}
		
		/** 緑成分。 0-255 */
		public function get green():uint
		{
			updateRGB()
			return _green
		}
		
		/** 青成分。 0-255 */
		public function get blue():uint
		{
			updateRGB()
			return _blue
		}
		
		public function set red(val:uint):void
		{
			if(val==_red) return	
			setRGB(val,green,blue)
		}
		
		public function set green(val:uint):void
		{
			if(val==_green) return
			setRGB(red,val,blue)
		}
		
		public function set blue(val:uint):void
		{
			if(val==blue)return
			setRGB(red,green,val)
		}
		
		
		public function toString():String
		{
			var str:String = "0x"
			
			var hexTable:Array = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
			
			str += hexTable[Math.floor(red / 16)];
			str += hexTable[red%16];
			str += hexTable[Math.floor(green / 16)];
			str += hexTable[green%16];
			str += hexTable[Math.floor(blue / 16)];
			str += hexTable[blue%16];
			
			return str
		}
		
		
		
		/*
		------------------------------------------------
		HSB getter / setter
		------------------------------------------------
		*/
		
		/** 色相 0-360 */
		public function get hue():Number
		{
			updateHSB()
			return _hue
		}
		
		/** 彩度 0-100 */
		public function get saturation():Number
		{
			updateHSB()
			return _saturation
		}
		
		/** 明度 0-100 */
		public function get brightness():Number
		{
			updateHSB()
			return _brightness
		}
		
		public function set hue(val:Number):void
		{
			var rgbInfo:Object = ColorUtil.HSB2RGB(val,saturation,brightness)
			setRGB(rgbInfo.r, rgbInfo.g, rgbInfo.b)
			_hue = val
		}
		
		public function set saturation(val:Number):void
		{
			var rgbInfo:Object = ColorUtil.HSB2RGB(hue,val,brightness)
			setRGB(rgbInfo.r, rgbInfo.g, rgbInfo.b)
			_saturation = val
		}
		
		public function set brightness(val:Number):void
		{
			//明度が０の場合は、hue,saturationの値を保持する
			var rgbInfo:Object = ColorUtil.HSB2RGB(hue,saturation,val)
			setRGB(rgbInfo.r, rgbInfo.g, rgbInfo.b)
			_brightness = val
		}
		
		/*
		----------------------------------------------------------------
		gray scale controll
		----------------------------------------------------------------
		*/
		
		/**
		 * 0-255の値でグレーの色を定義します。
		 * 
		 * @param value 0-255 gray scale.
		 */
		public function setGray(value:Number):void
		{
			setRGB(value,value,value)
		}
		
		
		/**
		 * 現在の色をグレースケールに変換します。
		 */
		public function toGray():void
		{
			var rw:Number = 0.3086
			var gw:Number = 0.6094
			var bw:Number = 0.0820
			var mat:ColorMatrixFilter = new ColorMatrixFilter([rw,gw,bw,0,0, rw,gw,bw,0,0, rw,gw,bw,0,0, 0,0,0,1,0])
			applyColorMatrix(mat)
		}
		
		
		/**
		 * 現在の色にColorMatrixFilterを適用します。
		 * 
		 * @param mat ColorMatrixFilter
		 * @see flash.filters.ColorMatrixFilter
		 */
		public function applyColorMatrix(mat:ColorMatrixFilter):void
		{
			var r:Number = _red * mat[0] + _red * mat[1] + _red * mat[2] + _red * mat[3] + mat[4]
			var g:Number = _green * mat[5] + _green * mat[6] + _green * mat[7] + _green * mat[8] + mat[9]
			var b:Number = _blue * mat[10] + _blue * mat[11] + _blue * mat[12] + _blue * mat[13] + mat[14]
			
			setRGB(r,g,b)
		}
		
		
		/**
		 * 現在の色にColorTransformを適用します。
		 * 
		 * @param colt ColorTransform
		 * @see flash.geom.ColorTransform
		 */
		public function applyColorTransform(colt:ColorTransform):void
		{
			var r:uint = _red * colt.redMultiplier + colt.redOffset
			var g:uint = _green * colt.redMultiplier + colt.greenOffset
			var b:uint = _blue * colt.blueMultiplier + colt.blueOffset
			
			//r = Math.round( Math.max(0, Math.min(255,r)))
			//g = Math.round( Math.max(0, Math.min(255,g)))
			//b = Math.round( Math.max(0, Math.min(255,b)))
			
			setRGB(r,g,b)
		}
		
		public function valueOf():Number
		{
			return value
		}
		
		/**
		 * R,G,Bの3つの値からColorSBオブジェクトを作成します。
		 * 
		 * @param red 0-255の値
		 * @param green 0-255の値
		 * @param blue 0-255の値
		 * 
		 * @return ColorSBオブジェクト
		 * 
		 */
		public static function createRGB(red:uint, green:uint, blue:uint):ColorSB
		{
			var col:ColorSB = new ColorSB();
			col.setRGB(red, green, blue);
			return col	
		}
		
		/**
		 * H, S, Bの3つの値からColorSBオブジェクトを作成します。
		 * 
		 * @param hue 0-255の値
		 * @param saturation 0-100の値
		 * @param brightness 0-100の値
		 * 
		 * @return ColorSBオブジェクト
		 * 
		 */
		public static function createHSB(hue:Number, saturation:Number, brightness:Number):ColorSB
		{
			var col:ColorSB = new ColorSB();
			col.setHSB(hue, saturation, brightness);
			return col	
		}
		
		/*
		------------------------------------------------
		Internal Use Only
		------------------------------------------------
		*/
		
		private function updateRGB():void
		{
			if(!_rgbUpdate) return
			_red = _value >>16 & 0xff
			_green = _value >> 8 & 0xff
			_blue = _value & 0xff
			_rgbUpdate = false
		}
		
		private function updateHSB():void
		{
			if(!_hsbUpdate) return
			
			var hsb:Object = ColorUtil.RGB2HSB(red,green,blue)
			
			//彩度０、明度が０の場合は昔の情報を保持
			if(hsb.b != 0 && hsb.s != 0 )
			_hue = hsb.h
			
			//明度が０の場合は昔の値を保持
			if(hsb.b != 0)
			_saturation = hsb.s
			
			_brightness = hsb.b
			_hsbUpdate = false
		}
		
	}
}