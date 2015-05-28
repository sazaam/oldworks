/**
 * @author biendo@fullsix.com 
 */
package modules.coreData.geoms
{
	import flash.geom.ColorTransform;
	
	import modules.coreData.CoreData;
	import modules.foundation.Comparable;
	
	public class ColorData extends CoreData implements Comparable
	{
		/**
		 * 
		 * @param	source
		 */
		public function ColorData(source:Object=null)
		{
			//default constructor initialisation
			super(source);		
		}
		
		/**
		 * 
		 * @param	r
		 * @param	g
		 * @param	b
		 * @return
		 */
		public function center(r:int, g:int, b:int):int
		{
    		if ((red > green) && (red > blue)) 
                return red > green ? green : blue;
            else 
                if ((green > red) && (green > blue)) 
                    return red > blue ? red : blue;
                else 
                    if (red > green) 
                        return red;
                    else 
                        return green;
    	}

		public function cloneColorTransform():ColorTransform
		{
			var clone:ColorTransform = new ColorTransform();
			clone.alphaMultiplier = alphaMultiplier;
			clone.alphaOffset = alphaOffset;
			clone.blueMultiplier = blueMultiplier;
			clone.blueOffset = blueOffset;
			clone.greenMultiplier = greenMultiplier;
			clone.greenOffset = greenOffset;
			clone.redMultiplier = redMultiplier;
			clone.redOffset = redOffset;
			clone.color = color;
			return clone;
		}
		
		/**
		 * 
		 * @param	T
		 * @return
		 */
		public function compareTo(T:Object):int
		{
			if (!(T is ColorData))
				throw new TypeError();
			var module:ColorData = T as ColorData;
			if (module.color < color)
				return -1;
			else if (module.color > color)
				return 1;
			return 0;
		}
		
		public function concat(second:ColorData):void	
		{
			_colorTransform.concat(second.cloneColorTransform());
		}	

		/**
		 * 
		 * @param	T
		 * @return
		 */
		override public function equals(T:Object):Boolean
		{
			if (T == this)
				return true;
    		if (!(T is ColorData))
    			return false;
			var module:ColorData = T as ColorData;
			return 	module.alphaMultiplier == alphaMultiplier && 
					module.alphaOffset == alphaOffset && 
					module.blueMultiplier == blueMultiplier && 
					module.blueOffset == blueOffset && 
					module.color == color && 
					module.greenMultiplier == greenMultiplier && 
					module.greenOffset == greenOffset && 
					module.redMultiplier == redMultiplier && 
					module.redOffset == redOffset && 
					hashCode() == module.hashCode();
		}
		
		public function fromColorTransform(source:ColorTransform):ColorData
		{
			alphaMultiplier = source.alphaMultiplier;
			alphaOffset = alphaOffset;
			blueMultiplier = source.blueMultiplier; 
			blueOffset = source.blueOffset;
			color = source.color; 
			greenMultiplier = source.greenMultiplier; 
			greenOffset = source.greenOffset; 
			redMultiplier = source.redMultiplier; 
			redOffset = source.redOffset;
			return this;
		}
		
		/**
		 * 
		 * @return
		 */
		public function getTint():Object 
		{
			var tint:Object = {percent: (1 - redMultiplier)*100};
			var ratio:Number = 100/tint.percent;
			tint.color = (redOffset*ratio)<<16 | (greenOffset*ratio)<<8 | blueOffset*ratio;
			return tint;
		}
 		
		/**
		 * 
		 * @return
		 */
		public function getTintComponents():Object 
		{
			var tint:Object = {percent: (1 - redMultiplier)*100};
			var ratio:Number = 100/tint.percent;
			tint.r = redOffset * ratio;
			tint.g = greenOffset * ratio;
			tint.b = blueOffset * ratio;
			return tint;
		}

		/**
		 * 
		 * @return
		 */
		override public function hashCode():int
		{
			return super.hashCode() + color;
		}
		
		/**
		 * 
		 */
		public function invert():void 
		{
			redMultiplier = -redMultiplier;
			greenMultiplier = -greenMultiplier;
			blueMultiplier = -blueMultiplier;
			redOffset = 255 - redOffset;
			greenOffset = 255 - greenOffset;
			blueOffset = 255 - blueOffset;
		}
		
		/**
		 * 
		 * @param	rgb
		 * @param	percent
		 */
		public function setTint(rgb:int, percent:Number):void 
		{
			var r:uint = (rgb >> 16);
			var g:uint = (rgb >> 8) & 0xFF;
			var b:uint = rgb & 0xFF;
			var ratio:Number = percent/100;
			redOffset = r*ratio;
			greenOffset = g*ratio;
			blueOffset = b*ratio;
			redMultiplier = greenMultiplier = blueMultiplier = (100 - percent)/100;
		}
		
		/**
		 * 
		 * @param	r
		 * @param	g
		 * @param	b
		 * @param	percent
		 */
		public function setTintComponents(r:int, g:int, b:int, percent:Number):void 
		{
			var ratio:Number = percent/100;
			redOffset = r*ratio;
			greenOffset = g*ratio;
			blueOffset = b*ratio;
			redMultiplier = greenMultiplier = blueMultiplier = (100 - percent)/100;
		}
		
		public function get alpha():Number
		{
			return alphaOffset;
		}
		
		public function set alpha(amount:Number):void 
		{
			color = (amount << 24) | (red << 16) | (green << 8) | blue;
		}
		
		public function get alphaMultiplier():Number	
		{
			return _colorTransform.alphaMultiplier;
		}
		
		public function set alphaMultiplier(value:Number):void	
		{
			_colorTransform.alphaMultiplier = value;
		}
		
		public function get alphaOffset():Number
		{
			return _colorTransform.alphaOffset;
		}
		
		public function set alphaOffset(value:Number):void	
		{
			_colorTransform.alphaOffset = value;
		}
						
		public function get alpaPercent():Number 
		{
			return alphaMultiplier * 100;
		}
		
		public function set alpaPercent(percent:Number):void 
		{
			alphaMultiplier = percent / 100;
		}
											
		public function get blue():Number 
		{
			return blueOffset;
		}

		public function set blue(amount:Number):void 
		{
			color = (redOffset << 16 | greenOffset << 8 | amount);
		}
		
		public function get blueMultiplier():Number	
		{
			return _colorTransform.blueMultiplier;
		}
		
		public function set blueMultiplier(value:Number):void	
		{
			_colorTransform.blueMultiplier = value;
		}
		
		public function get blueOffset():Number
		{
			return _colorTransform.blueOffset;
		}
		
		public function set blueOffset(value:Number):void	
		{
			_colorTransform.blueOffset = value;
		}
						
		public function get bluePercent():Number 
		{
			return blueMultiplier*100;
		}	
		
		public function set bluePercent(percent:Number):void 
		{
			blueMultiplier = percent/100;
		}
				
		public function get brightness():Number 
		{
			return (redOffset)*100 ? (1 - redMultiplier) * 100 : (redMultiplier - 1) * 100;
		}
		
		public function set brightness(bright:Number):void 
		{
			redMultiplier = greenMultiplier = blueMultiplier = 1 - Math.abs(bright/100);
			redOffset = greenOffset = blueOffset = (bright/100 > 0) ? bright/100 * 256 : 0;
		}
				
		public function get brightOffset():Number 
		{
			return redOffset;
		}
		
		public function set brightOffset(offset:Number):void 
		{
			redOffset = greenOffset = blueOffset = offset;
		}
				
		public function get color():uint 
		{
			return _colorTransform.color;
		}
		
		public function set color(value:uint):void 
		{
			_colorTransform.color = value;
		}
						
		public function get green():Number 
		{
			return greenOffset;
		}

		public function set green(amount:Number):void 
		{
			color = (redOffset << 16 | amount << 8 | blueOffset);
		}
		
		public function get greenMultiplier():Number	
		{
			return _colorTransform.greenMultiplier;
		}
		
		public function set greenMultiplier(value:Number):void	
		{
			_colorTransform.greenMultiplier = value;
		}
		
		public function get greenOffset():Number
		{
			return _colorTransform.greenOffset;
		}
		
		public function set greenOffset(value:Number):void	
		{
			_colorTransform.greenOffset = value;
		}
						
		public function get greenPercent():Number 
		{
			return greenMultiplier*100;
		}
		
		public function set greenPercent(percent:Number):void 
		{
			greenMultiplier = percent/100;
		}
		
		public function get negative():Number 
		{
			return redOffset * (100/255);
		}
	
		public function set negative(percent:Number):void 
		{
			redMultiplier = greenMultiplier = blueMultiplier = 100 - 2 * percent;
			redOffset = greenOffset = blueOffset = percent * (255/100);
		}
				
		public function get red():Number 
		{
			return redOffset;
		}
		
		public function set red(amount:Number):void 
		{
			color = (amount << 16 | greenOffset << 8 | blueOffset);
		}
		
		public function get redMultiplier():Number	
		{
			return _colorTransform.redMultiplier;
		}
		
		public function set redMultiplier(value:Number):void	
		{
			_colorTransform.redMultiplier = value;
		}
		
		public function get redOffset():Number
		{
			return _colorTransform.redOffset;
		}
		
		public function set redOffset(value:Number):void	
		{
			_colorTransform.redOffset = value;
		}
					
		public function get redPercent():Number 
		{
			return redMultiplier*100;
		}
		
		public function set redPercent(percent:Number):void 
		{
			redMultiplier = percent/100;
		}
				
		public function get rgb():int 
		{ 
			return (red << 16 | green << 8 | blue); 
		}
				
		public function get tintOffset():int 
		{
			return (redOffset)<<16 | (greenOffset)<<8 | (blueOffset);
		}
		
		public function set tintOffset(value:int):void 
		{
			var r:uint = (value >> 16) ;
			var g:uint = (value >> 8) & 0xFF;
			var b:uint = value & 0xFF;
			redOffset=r; 
			greenOffset=g; 
			blueOffset = b;
		}
		
		/**
		 * 
		 * @return
		 */
		override protected function getInitializer():Object
		{
			var o:Object = {};
			getClass().accessors.forEach(function(el:*, i:int, arr:Array):void {
				switch(el.name) {
					case "redMultiplier" : 
					case "greenMultiplier" : 
					case "blueMultiplier" : 
					case "alphaMultiplier" : 
						o[el.name] = 1;
						break;
					case "redOffset" :
					case "greenOffset" :
					case "blueOffset" :
					case "alphaOffset" :
						o[el.name] = 0;
						break;
				}
			}, this);
			return o;
		}
		
		/**
		 * 
		 * @param	source
		 */
		override protected function setup(source:Object):void
		{
			_colorTransform = new ColorTransform();
			super.setup(source);		
		}
		
		private var _colorTransform:ColorTransform;
	}
}