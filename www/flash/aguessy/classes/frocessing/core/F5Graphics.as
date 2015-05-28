// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// This library is based on Processing. 
// Copyright (c) 2001-04 Massachusetts Institute of Technology
// Copyright (c) 2004-07 Ben Fry and Casey Reas
// http://processing.org
//
// Frocessing drawing library
// Copyright (C) 2008  TAKANAWA Tomoaki (http://nutsu.com) and
//					   Spark project (www.libspark.org)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// contact : face(at)nutsu.com
//

package frocessing.core {
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import frocessing.f5internal;
	import frocessing.color.ColorMode;
	import frocessing.color.FColorMode;
	import frocessing.color.FColor;
	import frocessing.color.IFColor;
	import frocessing.color.IColor;
	import frocessing.color.FColorUtil;
	import frocessing.math.FMath;
	import frocessing.geom.FMatrix2D;
	import frocessing.text.IFont;
	import frocessing.bmp.BitmapTintCache;
	
	use namespace f5internal;
	
	/**
	* F5Graphics クラスは、Processing の描画メソッドを実装したクラスです.
	* 
	* @author nutsu
	* @version 0.2
	*/
	public class F5Graphics extends GraphicsEx
	{
		//Constants
		public static const RGB        :String = ColorMode.RGB;
		public static const HSB        :String = ColorMode.HSB;
		public static const HSV        :String = ColorMode.HSV;
		public static const CORNER        :int = DrawPosMode.CORNER;
		public static const CORNERS       :int = DrawPosMode.CORNERS;
		public static const RADIUS        :int = DrawPosMode.RADIUS;
		public static const CENTER        :int = DrawPosMode.CENTER;
		public static const NONE_SHAPE    :int = DrawMode.NONE_SHAPE;
		public static const POINTS        :int = DrawMode.POINTS;
		public static const LINES         :int = DrawMode.LINES; 
		public static const TRIANGLES     :int = DrawMode.TRIANGLES;
		public static const TRIANGLE_FAN  :int = DrawMode.TRIANGLE_FAN;
		public static const TRIANGLE_STRIP:int = DrawMode.TRIANGLE_STRIP;
		public static const QUADS         :int = DrawMode.QUADS;
		public static const QUAD_STRIP    :int = DrawMode.QUAD_STRIP;
		public static const POLYGON       :int = DrawMode.POLYGON;
		public static const OPEN      :Boolean = PathCloseMode.OPEN;
		public static const CLOSE     :Boolean = PathCloseMode.CLOSE;
		
		public static const PI         :Number = FMath.PI;
		public static const TWO_PI     :Number = FMath.TWO_PI;
		public static const HALF_PI    :Number = FMath.HALF_PI;
		
		//Size
		protected var _width:uint;
		protected var _height:uint;
		
		//Setting
		protected var color_mode:FColorMode;
		protected var _fill:FColor;
		protected var _stroke:FColor;
		protected var _background:FColor;
		
		protected var _fill_do:Boolean;
		
		//Shape Attributes
		protected var rect_mode:int;	//@default CORNER
		protected var ellipse_mode:int;	//@default CENTER
		protected var shape_mode:int;	//@default NONE_SHAPE
		protected var shape_mode_polygon:Boolean;
		
		//Image
		protected var image_mode:int;	//@default CORNER
		protected var _tint_do:Boolean;
		protected var _tint_color:uint;
		protected var tintImageCache:BitmapTintCache;
		
		//Vertex
		protected var vertexsX:Array;
		protected var vertexsY:Array;
		protected var vertexCount:uint;
		protected var splineVertexX:Array;
		protected var splineVertexY:Array;
		protected var splineVertexCount:uint;
		
		//Texture
		protected var texture_mode:Boolean;
		protected var vertexsU:Array;
		protected var vertexsV:Array;
		
		//Typograph
		protected var _typoGC:F5Typographics;
		private  var typobmp_detail:uint;
		
		/**
		 * 新しい F5Graphics クラスのインスタンスを生成します.
		 * 
		 * @param	gc	描画対象となる Graphics を指定します
		 */
		public function F5Graphics( gc:Graphics ) {
			super(gc);
			
			_width         = 0;
			_height        = 0;
			
			_fill_do       = true;
			_fill_color    = 0xffffff;
			_fill_alpha    = 1.0;
			_stroke_do     = true;
			_stroke_color  = 0x000000;
			_stroke_alpha  = 1.0;
			
			color_mode     = new FColorMode();
			_fill          = new FColor( _fill_color, _fill_alpha );
			_stroke        = new FColor( _stroke_color,_stroke_alpha );
			_background    = new FColor( 0xcccccc );
			lineStyle( 0, _stroke_color, _stroke_alpha );
			
			rect_mode      = CORNER;
			ellipse_mode   = CENTER;
			shape_mode     = NONE_SHAPE;
			shape_mode_polygon = false;
			
			image_mode     = CORNER;
			_tint_color    = 0xffffffff;
			_tint_do       = false;
			tintImageCache = new BitmapTintCache();
			
			texture_mode   = false;
			
			_typoGC        = new F5Typographics( this );
			typobmp_detail = 1;
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * F5Graphics が保持する幅を示します.
		 */
		public function get width():uint { return _width; }
		/**
		 * F5Graphics が保持する高さを示します.
		 */
		public function get height():uint{ return _height; }
		
		/**
		 * 幅と高さを設定します. width, height は background() メソッド以外には使用されません.
		 */
		public function size( width_:uint, height_:uint ):void
		{
			_width  = width_;
			_height = height_;
		}
		
		/**
		 * 描画を開始するときに実行します.このメソッドは、F5Graphics2D,F5Graphics3D など　F5Graphicsの拡張クラスで意味を持ちます. 
		 */
		public function beginDraw():void {
			clear();
			applyLineStyle();
		}
		
		/**
		 * 描画を終了するときに実行します.このメソッドは、F5Graphics2D,F5Graphics3D など　F5Graphicsの拡張クラスで意味を持ちます. 
		 */
		public function endDraw():void { ; }
		
		/**
		 * @inheritDoc
		 */
		override public function clear():void
		{
			super.clear();
			tintImageCache.dispose();
		}
		
		//--------------------------------------------------------------------------------------------------- COLOR
		
		// Setting
		
		/**
		 * カラーモードを指定します.
		 * @see frocessing.color.ColorMode
		 * @see frocessing.color.FColorMode
		 */
		public function colorMode( mode:String, range1_:Number=NaN, range2_:Number=NaN, range3_:Number=NaN, range4_:Number=NaN ):void
		{
			color_mode.colorMode( mode, range1_, range2_, range3_, range4_ );
		}
		
		/**
		 * 背景を描画します.このメソッドを実行すると、現在の描画内容がクリアされます.
		 * @param	c1
		 * @param	c2
		 * @param	c3
		 * @param	c4
		 */
		public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			color_mode.setColor( _background, c1, c2, c3, c4 );
			if( _width>0 && _height>0 )
			{
				_gc.clear();
				_gc.beginFill( _background.value, _background.alpha );
				_gc.drawRect( 0, 0, _width, _height );
				_gc.endFill();
				applyLineStyle();
			}
		}
		
		/**
		 * 線の色、透明度を指定します.
		 * このメソッドにより lineStyle　が実行され線のスタイルが適用されます.
		 * @param	c1
		 * @param	c2
		 * @param	c3
		 * @param	c4
		 */
		public function stroke( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			color_mode.setColor( _stroke, c1, c2, c3, c4 );
			_stroke_color = _stroke.value;
			_stroke_alpha = _stroke.alpha;
			super.applyLineStyle();
		}
		
		/**
		 * 塗りの色、透明度を指定します.
		 * @param	c1
		 * @param	c2
		 * @param	c3
		 * @param	c4
		 */
		public function fill( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			color_mode.setColor( _fill, c1, c2, c3, c4 );
			_fill_color = _fill.value;
			_fill_alpha = _fill.alpha;
			_fill_do    = true;
		}
		
		/**
		 * 線が描画されないようにします.
		 */
		public function noStroke():void
		{
			noLineStyle();
		}
		
		/**
		 * 塗りが描画されないようにします.
		 */
		public function noFill():void
		{
			_fill_do = false;
		}
		
		// Creating & Reading
		
		/**
		 * @copy frocessing.color.FColorMode#color
		 * @see frocessing.color.FColorMode
		 */
		public function color( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):FColor
		{
			return color_mode.color( c1, c2, c3, c4 );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#color32
		 * @see frocessing.color.FColorMode
		 */
		public function color32( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint
		{
			return color_mode.color32( c1, c2, c3, c4 );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#color24
		 * @see frocessing.color.FColorMode
		 */
		public function color24( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint
		{
			return color_mode.color24( c1, c2, c3, c4 );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#red
		 * @see frocessing.color.FColorMode
		 */
		public function red( c:IFColor ):Number
		{
			return color_mode.red( c );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#green
		 * @see frocessing.color.FColorMode
		 */
		public function green( c:IFColor ):Number
		{
			return color_mode.green( c );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#blue
		 * @see frocessing.color.FColorMode
		 */
		public function blue( c:IFColor ):Number
		{
			return color_mode.blue( c );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#hue
		 * @see frocessing.color.FColorMode
		 */
		public function hue( c:IFColor ):Number
		{
			return color_mode.hue( c );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#saturation
		 * @see frocessing.color.FColorMode
		 */
		public function saturation( c:IFColor ):Number
		{
			return color_mode.saturation( c );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#brightness
		 * @see frocessing.color.FColorMode
		 */
		public function brightness( c:IFColor ):Number
		{
			return color_mode.brightness( c );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#alpha
		 * @see frocessing.color.FColorMode
		 */
		public function alpha( c:IFColor ):Number
		{
			return color_mode.alpha( c );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#lerpColor
		 * @see frocessing.color.FColorMode
		 */
		public function lerpColor( c1:IFColor, c2:IFColor, amt:Number ):FColor
		{
			return color_mode.lerpColor( c1, c2, amt );
		}
		
		/**
		 * @copy frocessing.color.FColorMode#blendColor
		 * @see frocessing.color.ColorBlend
		 */
		public function blendColor( c1:IColor, c2:IColor, blend_mode:String ):FColor
		{
			return FColorMode.blendColor( c1, c2, blend_mode );
		}
		
		//--------------------------------------------------------------------------------------------------- Shape Attribute
		
		/**
		 * 線の太さを指定します.有効な値は 0～255 です.
		 * このメソッドにより lineStyle　が実行され線のスタイルが適用されます.
		 * @param	thickness
		 */
		public function strokeWeight( thickness_:Number ):void
		{
			_thickness = thickness_;
			super.applyLineStyle();
		}
		
		/**
		 * 線の角で使用する接合点の外観の種類を指定します.
		 * このメソッドにより lineStyle　が実行され線のスタイルが適用されます.
		 * @see	flash.display.JointStyle
		 */
		public function strokeJoin( jointStyle:String ):void
		{
			_joints = jointStyle;
			super.applyLineStyle();
		}
		
		/**
		 * 線の終端のキャップの種類を指定します.
		 * このメソッドにより lineStyle　が実行され線のスタイルが適用されます.
		 * @see	flash.display.CapsStyle
		 */
		public function strokeCap( capsStyle:String ):void
		{
			_caps = capsStyle;
			super.applyLineStyle();
		}
		
		/**
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 * @see frocessing.core.DrawPosMode
		 */
		public function rectMode( mode:int ):void
		{
			rect_mode = mode;
		}
		
		/**
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 * @see frocessing.core.DrawPosMode
		 */
		public function ellipseMode( mode:int ):void
		{
			ellipse_mode = mode;
		}
		
		//--------------------------------------------------------------------------------------------------- Image
		
		/**
		 *  @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 * @see frocessing.core.DrawPosMode
		 */
		public function imageMode( mode:int ):void
		{
			image_mode = mode;
		}
		
		/**
		 * 画像を描画します.
		 * 
		 * <p>
		 * image()メソッドの引数は、imageMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CORNER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CORNER  : image( bitmapdata, left, top, width, height )</li>
		 * <li>mode CORNERS ： image( bitmapdata, left, top, right, bottom )</li>
		 * <li>mode CENTER  : image( bitmapdata, center x, center y, width, height )</li>
		 * <li>mode RADIUS  : image( bitmapdata, center x, center y, radius x, radius y )</li>
		 * </ul>
		 * 
		 * <p>w、h を省略した場合は、bitmapdata の width と hight が適用されます.</p>
		 */
		public function image( img:BitmapData, x:Number, y:Number, w:Number = NaN, h:Number = NaN ):void
		{
			if ( isNaN(w) || isNaN(h) )
			{
				w = img.width;
				h = img.height;
				if( image_mode==RADIUS || image_mode==CENTER )
				{
					x -= w * 0.5;
					y -= h * 0.5;
				}
			}
			else
			{
				switch( image_mode )
				{
					case CORNERS:
						w  -= x;
						h  -= y;
						break;
					case RADIUS:
						x -= w;
						y -= h;
						w *= 2;
						h *= 2;
						break;
					case CENTER:
						x -= w * 0.5;
						y -= h * 0.5;
						break;
				}
			}
			
			if ( _tint_do )
				drawBitmapRect( tintImageCache.getTintImage( img, _tint_color ), x, y, w, h );
			else
				drawBitmapRect( img, x, y, w, h );
			
		}
		
		/**
		 * Tint Color を指定します.
		 * @param	c1
		 * @param	c2
		 * @param	c3
		 * @param	c4
		 */
		public function tint( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			_tint_color = color_mode.color32( c1, c2, c3, c4 );
			_tint_do    = ( _tint_color != 0xffffffff );
		}
		
		/**
		 * Tint を無効にします.
		 */
		public function noTint():void
		{
			_tint_color = 0xffffffff;
			_tint_do    = false;
		}
		
		/**
		 * Tint Color を 32bit Color で示します.
		 */
		public function get tintColor():uint{ return _tint_color; }
		public function set tintColor( value:uint ):void
		{
			_tint_color = value;
			_tint_do    = ( _tint_color != 0xffffffff );
		}
		
		//--------------------------------------------------------------------------------------------------- 2D Primitives
		
		/**
		 * 点を描画します.点を描画する色は、線の色が適用されます.
		 */
		public function point( x:Number, y:Number ):void
		{
			drawPoint( x, y, _stroke_color, _stroke_alpha );
		}
		
		/**
		 * 現在の線のスタイルを適用し、直線を描画します.
		 */
		public function line( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			drawLine( x0, y0, x1, y1 );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、三角形を描画します.
		 */
		public function triangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			applyFill();
			drawTriangle( x0, y0, x1, y1, x2, y2 ); 
			endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、四角形を描画します.
		 */
		public function quad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			applyFill();
			drawQuad( x0, y0, x1, y1, x2, y2, x3, y3 );
			endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円弧を描画します.
		 */
		public function arc( x:Number, y:Number, width_:Number, height_:Number, start_radian:Number, stop_radian:Number ):void
		{
			applyFill();
			drawArc( x, y, width_*0.5, height_*0.5, start_radian, stop_radian );
			endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円を描画します.
		 */
		public function circle( x:Number, y:Number, size:Number ):void
		{
			arc( x, y, size, size, 0.0, TWO_PI );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、楕円を描画します.
		 * 
		 * <p>
		 * ellipse()メソッドの引数は、ellipseMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CENTER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CENTER  : ellipse( center x, center y, width, height )</li>
		 * <li>mode CORNERS ： ellipse( left, top, right, bottom )</li>
		 * <li>mode CORNER  : ellipse( left, top, width, height )</li>
		 * <li>mode RADIUS  : ellipse( center x, center y, radius x, radius y )</li>
		 * </ul>
		 */
		public function ellipse( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			var w:Number;
			var h:Number;
			switch( ellipse_mode )
			{
				case CORNERS:
					w  = (x1 - x0);
					h  = (y1 - y0);
					x0 += w*0.5;
					y0 += h*0.5;
					break;
				case CORNER:
					w  = x1;
					h  = y1;
					x0 += w*0.5;
					y0 += h*0.5;
					break;
				case RADIUS:
					w  = x1*2;
					h  = y1*2;
					break;
				case CENTER:
					w  = x1;
					h  = y1;
					break;
			}
			arc( x0, y0, w, h, 0.0, TWO_PI );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、矩形を描画します.
		 * 
		 * <p>
		 * rect()メソッドの引数は、rectMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CORNER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CORNER  : rect( left, top, width, height )</li>
		 * <li>mode CORNERS ： rect( left, top, right, bottom )</li>
		 * <li>mode RADIUS  : rect( center x, center y, radius x, radius y )</li>
		 * <li>mode RADIUS  : rect( center x, center y, width, height )</li>
		 * </ul>
		 */
		public function rect( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			var rx:Number;
			var ry:Number;
			switch( rect_mode )
			{
				case CORNERS:
					break;
				case CORNER:
					x1 += x0;
					y1 += y0;
					break;
				case RADIUS:
					rx = x1;
					ry = y1;
					x1 = x0 + rx;
					y1 = y0 + ry;
					x0 -= rx;
					y0 -= ry;
					break;
				case CENTER:
					rx = x1*0.5;
					ry = y1*0.5;
					x1 = x0 + rx;
					y1 = y0 + ry;
					x0 -= rx;
					y0 -= ry;
					break;
			}
			quad( x0, y0, x1, y0, x1, y1, x0, y1 );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、roundRectを描画します.
		 *
		 * <p>
		 * roundrect()メソッドの引数は、rectMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CORNER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CORNER  : roundrect( left, top, width, height )</li>
		 * <li>mode CORNERS ： roundrect( left, top, right, bottom )</li>
		 * <li>mode RADIUS  : roundrect( center x, center y, radius x, radius y )</li>
		 * <li>mode RADIUS  : roundrect( center x, center y, width, height )</li>
		 * </ul>
		 */
		public function roundrect( x0:Number, y0:Number, x1:Number, y1:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number ):void
		{
			var w:Number;
			var h:Number;
			switch( rect_mode )
			{
				case CORNERS:
					w  = x1 - x0;
					h  = y1 - y0;
					break;
				case CORNER:
					w  = x1;
					h  = y1;
					break;
				case RADIUS:
					w  = x1;
					h  = y1;
					x0 -= w;
					y0 -= h;
					w  *= 2;
					h  *= 2; 
					break;
				case CENTER:
					w  = x1;
					h  = y1;
					x0 -= w*0.5;
					y0 -= h*0.5;
					break;
			}
			
			applyFill();
			drawRoundRectComplex( x0, y0, w, h, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
			endFill();
		}
		
		//--------------------------------------------------------------------------------------------------- CURVES
		
		/**
		 * 現在の塗りと線のスタイルを適用し、3次ベジェ曲線を描画します.
		 */
		public function bezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			applyFill();
			drawBezier( x0, y0, cx0, cy0, cx1, cy1, x1, y1 );
			endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、スプライン曲線を描画します.
		 */
		public function curve( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			applyFill();
			splineInit( x0, y0, x1, y1, x2, y2 );
			splineTo( x3, y3 );
			endFill();
		}
		
		//--------------------------------------------------------------------------------------------------- VERTEX
		
		/**
		 * 
		 * @param	mode
		 * @see frocessing.core.DrawMode
		 */
		public function beginShape( mode:int=99 ):void
		{
			shape_mode    = mode;
			vertexsX      = [];
			vertexsY      = [];
			splineVertexX = [];
			splineVertexY = [];
			vertexsU      = [];
			vertexsV      = [];
			
			vertexCount = 0;
			splineVertexCount = 0;
			
			if ( shape_mode_polygon = (mode == POLYGON) )
				applyFill();
		}
		
		/**
		 * vertex() で 描画する テクスチャ(画像) を設定します.
		 * <p>
		 * texture が適用されるのは、 beginShape() メソッドで以下のモードを指定した場合になります.<br/>
		 * 「　TRIANGLES　TRIANGLE_FAN　TRIANGLE_STRIP　QUADS　QUAD_STRIP 」
		 * </p>
		 * <p>
		 * また、vertex() メソッドで、　u, v 値を指定する必要があります.
		 * </p>
		 */
		public function texture( textureData:BitmapData ):void
		{
			if ( _tint_do )
				_bmpGC.beginBitmap( tintImageCache.getTintImage( textureData, _tint_color ) );
			else
				_bmpGC.beginBitmap( textureData );
			
			texture_mode = true;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	u	texture を指定している場合、u 値を画像の x 座標で指定できます
		 * @param	v	texture を指定している場合、v 値を画像の y 座標で指定できます
		 */
		public function vertex( x:Number, y:Number, u:Number=0, v:Number=0 ):void
		{
			vertexsX[vertexCount] = x;
			vertexsY[vertexCount] = y;
			vertexsU[vertexCount] = u;
			vertexsV[vertexCount] = v;
			vertexCount++;
			
			var t1:uint;
			var t2:uint;
			var t3:uint;
			
			switch( shape_mode )
			{
				case POINTS:
					super.moveTo( x, y );
					$point( x, y, _stroke_color, _stroke_alpha );
					break;
				case LINES:
					if ( vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						super.moveTo( vertexsX[t1], vertexsY[t1] );
						super.lineTo( x, y );
					}
					break;
				case TRIANGLES:
					if ( vertexCount % 3 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						if ( texture_mode )
						{
							super.moveTo( vertexsX[t2], vertexsY[t2] );
							_bmpGC.drawTriangle( _startX, _startY, vertexsX[t1], vertexsY[t1], x, y,
												 vertexsU[t2], vertexsV[t2], vertexsU[t1], vertexsV[t1], u, v );
						}
						else
						{
							applyFill();
							super.moveTo( vertexsX[t2], vertexsY[t2] );
							$lineTo( vertexsX[t1], vertexsY[t1] );
							$lineTo( x, y );
							$closePath();
							endFill();
						}
					}
					break;
				case TRIANGLE_FAN:
					if ( vertexCount >= 3 )
					{
						t1 = vertexCount - 2;
						if ( texture_mode )
						{
							super.moveTo( vertexsX[0], vertexsY[0] );
							_bmpGC.drawTriangle( _startX, _startY, vertexsX[t1], vertexsY[t1], x, y,
												 vertexsU[0], vertexsV[0], vertexsU[t1], vertexsV[t1], u, v );
						}
						else
						{
							applyFill();
							super.moveTo( vertexsX[0], vertexsY[0] );
							$lineTo( vertexsX[t1], vertexsY[t1] );
							$lineTo( x, y );
							$closePath();
							endFill();
						}
					}
					break;
				case TRIANGLE_STRIP:
					if ( vertexCount >= 3 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						if ( texture_mode )
						{
							super.moveTo( vertexsX[t2], vertexsY[t2] );
							_bmpGC.drawTriangle( x, y, vertexsX[t1], vertexsY[t1], _startX, _startY,
												 u, v, vertexsU[t1], vertexsV[t1], vertexsU[t2], vertexsV[t2] );
						}
						else
						{
							applyFill();
							super.moveTo( vertexsX[t2], vertexsY[t2] );
							$lineTo( x, y );
							$lineTo( vertexsX[t1], vertexsY[t1] );
							$closePath();
							endFill();
						}
					}
					break;
				case QUADS:
					if ( vertexCount % 4 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( texture_mode )
						{
							_gc.lineStyle();
							super.moveTo( vertexsX[t3], vertexsY[t3] );
							_bmpGC.drawQuad( _startX, _startY, vertexsX[t2], vertexsY[t2], vertexsX[t1], vertexsY[t1], x, y,
											 vertexsU[t3], vertexsV[t3], vertexsU[t2], vertexsV[t2], vertexsU[t1], vertexsV[t1], u, v );
							if ( _stroke_do )
							{
								applyLineStyle();
								super.moveTo( vertexsX[t3], vertexsY[t3] );
								$lineTo( vertexsX[t2], vertexsY[t2] );
								$lineTo( vertexsX[t1], vertexsY[t1] );
								$lineTo( x, y );
								$closePath();
							}
						}
						else
						{
							applyFill();
							super.moveTo( vertexsX[t3], vertexsY[t3] );
							$lineTo( vertexsX[t2], vertexsY[t2] );
							$lineTo( vertexsX[t1], vertexsY[t1] );
							$lineTo( x, y );
							$closePath();
							endFill();
						}
					}
					break;
				case QUAD_STRIP:
					if ( vertexCount >= 4 && vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( texture_mode )
						{
							_gc.lineStyle();
							super.moveTo( vertexsX[t3], vertexsY[t3] );
							_bmpGC.drawQuad( _startX, _startY, vertexsX[t2], vertexsY[t2], x, y, vertexsX[t1], vertexsY[t1],
											 vertexsU[t3], vertexsV[t3], vertexsU[t2], vertexsV[t2], u, v, vertexsU[t1], vertexsV[t1] );
							if ( _stroke_do )
							{
								applyLineStyle();
								super.moveTo( vertexsX[t3], vertexsY[t3] );
								$lineTo( vertexsX[t2], vertexsY[t2] );
								$lineTo( x, y );
								$lineTo( vertexsX[t1], vertexsY[t1] );
								$closePath();
							}
						}
						else
						{
							applyFill();
							super.moveTo( vertexsX[t3], vertexsY[t3] );
							$lineTo( vertexsX[t2], vertexsY[t2] );
							$lineTo( x, y );
							$lineTo( vertexsX[t1], vertexsY[t1] );
							$closePath();
							endFill();
						}
					}
					break;
				case POLYGON:
					if ( vertexCount > 1 )
						super.lineTo( x, y );
					else
						super.moveTo( x, y );
					break;
			}
		}
		
		/**
		 * 　
		 */
		public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			if ( shape_mode_polygon )
			{
				vertexsX[vertexCount] = x;
				vertexsY[vertexCount] = y;
				vertexCount++;
				super.bezierTo( cx0, cy0, cx1, cy1, x, y );
			}
		}
		
		/**
		 *　
		 */
		public function curveVertex( x:Number, y:Number ):void
		{
			if ( shape_mode_polygon )
			{
				splineVertexX[splineVertexCount] = x;
				splineVertexY[splineVertexCount] = y;
				splineVertexCount ++;
				
				if( splineVertexCount>4 )
				{
					super.splineTo( x, y );
				}
				else if ( splineVertexCount == 4 )
				{
					var t1:int = splineVertexCount - 2;
					var t2:int = splineVertexCount - 3;
					var t3:int = splineVertexCount - 4;
					if ( vertexCount > 0 )
					{
						_splineX0  = splineVertexX[t3];
						_splineY0  = splineVertexY[t3];
						_splineX1  = splineVertexX[t2];
						_splineY1  = splineVertexY[t2];
						_splineX2  = splineVertexX[t1];
						_splineY2  = splineVertexY[t1];
						super.splineTo( x, y );
					}
					else
					{
						super.splineInit( splineVertexX[t3], splineVertexY[t3],
										  splineVertexX[t2], splineVertexY[t2],
										  splineVertexX[t1], splineVertexY[t1] );
						super.splineTo( x, y );
					}
				}
			}
		}
		
		/**
		 * 
		 * @param	close_path
		 */
		public function endShape( close_path:Boolean=false ):void
		{
			if ( shape_mode_polygon )
			{
				if ( close_path )
					closePath();
				endFill();
			}
			//vertexsX      = [];
			//vertexsY      = [];
			//splineVertexX = [];
			//splineVertexY = [];
			vertexCount       = 0;
			splineVertexCount = 0;
			shape_mode        = NONE_SHAPE;
			shape_mode_polygon = false;
			
			if ( texture_mode )
			{
				texture_mode = false;
				_bmpGC.endBitmap();
			}
		}
		
		//--------------------------------------------------------------------------------------------------- Typography 
		
		/**
		 * 
		 */
		public function get fontImageDetail():uint { return typobmp_detail; }
		public function set fontImageDetail( value_:uint ):void
		{
			typobmp_detail = value_;
		}
		
		/**
		 * 
		 */
		public function get typographics():F5Typographics
		{
			return _typoGC;
		}
		
		/**
		 * 描画する font を指定します.
		 * @param	font
		 * @param	fontSize
		 */
		public function textFont( font:IFont, fontSize:Number ):void
		{
			_typoGC.setFont( font, fontSize );
		}
		
		/**
		 * text を描画します.
		 * @param	str
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		public function text( str:String, x:Number, y:Number, z:Number = 0.0 ):void
		{
			if ( _typoGC.bitmap_mode )
			{
				var tmp_detail:uint = imageDetail;
				imageDetail = typobmp_detail;
				if ( _fill_color != 0xffffff || _fill_alpha != 1.0  )
				{
					var tmp_c:uint    = _tint_color;
					var tmp_d:Boolean = _tint_do ;
					_tint_color = Math.round( _fill_alpha * 0xff ) << 24 | _fill_color;
					_tint_do    = true;
					_typoGC.drawText( str, x, y, z );
					_tint_color = tmp_c;
					_tint_do    = tmp_d;
				}
				else
				{
					_typoGC.drawText( str, x, y, z );
				}
				imageDetail = tmp_detail;
			}
			else
			{
				_typoGC.drawText( str, x, y, z );
			}
		}
		
		/**
		 * 指定した Rectangle 内に text を流し込み描画します.
		 * @param	str
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	z
		 */
		public function textArea( str:String, x:Number, y:Number, w:Number, h:Number, z:Number = 0.0 ):void
		{
			if ( _typoGC.bitmap_mode )
			{
				var tmp_detail:uint = imageDetail;
				imageDetail = typobmp_detail;
				if ( _fill_color != 0xffffff || _fill_alpha != 1.0  )
				{
					var tmp_c:uint    = _tint_color;
					var tmp_d:Boolean = _tint_do ;
					_tint_color = Math.round( _fill_alpha * 0xff ) << 24 | _fill_color;
					_tint_do    = true;
					_typoGC.drawTextRect( str, x, y, w, h, z );
					_tint_color = tmp_c;
					_tint_do    = tmp_d;
				}
				else
				{
					_typoGC.drawTextRect( str, x, y, w, h, z );
				}
				imageDetail = tmp_detail;
			}
			else
			{
				_typoGC.drawTextRect( str, x, y, w, h, z );
			}
		}
		
		/**
		 * text の　size を指定します.
		 * @param	fontSize
		 */
		public function textSize( fontSize:Number ):void
		{
			_typoGC.size = fontSize;
		}
		
		/**
		 * text の　align を指定します.
		 * @see frocessing.core.F5Typographics;
		 */
		public function textAlign( align_:String ):void
		{
			_typoGC.align = align_;
		}
		
		/**
		 * text の　行高 を指定します.
		 * @param	leading
		 */
		public function textLeading( leading:Number ):void
		{
			_typoGC.leading = leading;
		}
		
		/**
		 * 
		 * @return
		 */
		public function textAscent():Number
		{
			return _typoGC.textAscent();
		}
		
		/**
		 * 
		 * @return
		 */
		public function textDescent():Number
		{
			return _typoGC.textDescent();
		}
		
		/**
		 * 文字列の幅を取得します.
		 * @param	str
		 * @return
		 */
		public function textWidth( str:String ):Number
		{
			return _typoGC.textWidth( str );
		}
		
		/*
		public function textMode( mode_:int ):void
		{
			
		}
		*/
		//--------------------------------------------------------------------------------------------------- OVERRIDE GRAPHICS DRAW METHOD
		
		/**
		 * @inheritDoc
		 */
		override public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			drawArc( x, y, radius, radius, 0.0, TWO_PI );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawEllipse(x:Number, y:Number, width_:Number, height_:Number):void
		{
			width_  *= 0.5;
			height_ *= 0.5;
			drawArc( x+width_, y+height_, width_, height_, 0.0, TWO_PI );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawRect(x:Number, y:Number, width_:Number, height_:Number):void
		{
			drawQuad( x, y, x + width_, y, x + width_, y + height_, x, y + height_ );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawRoundRect(x:Number, y:Number, width_:Number, height_:Number, ellipseWidth:Number, ellipseHeight:Number):void
		{
			var x1:Number = x + width_;
			var y1:Number = y + height_;
			var rx:Number;
			var ry:Number;
			
			if( ellipseWidth>width_ )
				rx = width_*0.5;
			else
				rx = ellipseWidth*0.5;
			
			if( ellipseHeight>height_ )
				ry = height_*0.5;
			else
				ry = ellipseHeight*0.5;
			
			moveTo( x + rx, y );
			lineTo( x1 - rx, y );   arc_curve( x1 - rx, y + ry, rx, ry, -HALF_PI, 0.0 );
			lineTo( x1, y1 - ry );  arc_curve( x1 - rx, y1 - ry, rx, ry, 0.0, HALF_PI );
			lineTo( x + rx, y1 );   arc_curve( x + rx, y1 - ry, rx, ry, HALF_PI, PI );
			lineTo( x, y + ry );    arc_curve( x + rx, y + ry, rx, ry, -PI, -HALF_PI );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawRoundRectComplex(x:Number, y:Number, width_:Number, height_:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			var x1:Number = x + width_;
			var y1:Number = y + height_;
			var k:Number;
			if ( topLeftRadius + bottomLeftRadius > height_ )
			{
				k = height_ / (topLeftRadius + bottomLeftRadius);
				topLeftRadius *= k;
				bottomLeftRadius *= k;
			}
			if ( topRightRadius + bottomRightRadius > height_ )
			{
				k = height_ / (topRightRadius + bottomRightRadius);
				topRightRadius *= k;
				bottomRightRadius *= k;
			}
			if ( topLeftRadius + topRightRadius > width_ )
			{
				k = width_ / (topLeftRadius + topRightRadius);
				topLeftRadius *= k;
				topRightRadius *= k;
			}
			if ( bottomLeftRadius + bottomRightRadius > width_ )
			{
				k = width_ / (bottomLeftRadius + bottomRightRadius);
				bottomLeftRadius *= k;
				bottomRightRadius *= k;
			}
			moveTo( x + topLeftRadius, y );
			lineTo( x1 - topRightRadius, y );
			if ( topRightRadius > 0 )
				arc_curve( x1 - topRightRadius, y + topRightRadius, topRightRadius, topRightRadius, -HALF_PI, 0.0 );
			lineTo( x1, y1 - bottomRightRadius );
			if ( bottomRightRadius > 0 )
				arc_curve( x1 - bottomRightRadius, y1 - bottomRightRadius, bottomRightRadius, bottomRightRadius, 0.0, HALF_PI );
			lineTo( x + bottomLeftRadius, y1 );
			if ( bottomLeftRadius > 0 )
				arc_curve( x + bottomLeftRadius, y1 - bottomLeftRadius, bottomLeftRadius, bottomLeftRadius, HALF_PI, PI );
			lineTo( x, y + topLeftRadius );
			if ( topLeftRadius > 0 )
				arc_curve( x + topLeftRadius, y + topLeftRadius, topLeftRadius, topLeftRadius, -PI, -HALF_PI );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * @inheritDoc
		 */
		override public function lineStyle(thickness_:Number=0,color_:uint=0,alpha_:Number=1,pixelHinting_:Boolean=false,scaleMode_:String="normal",caps_:String=null,joints_:String=null,miterLimit_:Number=3):void
		{
			super.lineStyle( thickness_, color_, alpha_, pixelHinting_, scaleMode_, caps_, joints_, miterLimit_ );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function applyLineStyle():void
		{
			if( _stroke_do )
				super.applyLineStyle();	
		}
		
		/**
		 * @inheritDoc
		 */
		override public function noLineStyle():void
		{
			if ( _stroke_do )
				super.noLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set strokeColor(value:uint):void {
			_stroke_color = value;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set strokeAlpha(value:Number):void {
			_stroke_alpha = value;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set thickness(value_:Number):void{
			_thickness = value_;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set pixelHinting(value_:Boolean):void {
			_pixelHinting = value_;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleMode(value_:String):void {
			_scaleMode = value_;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set caps(value_:String):void {
			_caps = value_;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set joints(value_:String):void {
			_joints = value_;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set miterLimit(value_:Number):void {
			_miterLimit = value_;
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function applyFill():void {
			if ( _fill_do )
				super.applyFill();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set fillColor(value:uint):void {
			_fill_color = value;
			_fill_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set fillAlpha(value:Number):void {
			_fill_alpha = value;
			_fill_do = true;
		}
		
		//--------------------------------------------------------------------------------------------------- f5internal
		
		f5internal function f5DrawBitmapFont( img:BitmapData, x1:Number, y1:Number, x2:Number, y2:Number, z:Number=0 ):void
		{
			if ( _tint_do )
				drawBitmapRect( tintImageCache.getTintImage( img, _tint_color ), x1, y1, x2-x1, y2-y1 );
			else
				drawBitmapRect( img, x1, y1, x2-x1, y2-y1 );
		}
		
		f5internal function f5Vertex( x:Number, y:Number, z:Number, u:Number=0, v:Number=0 ):void
		{
			vertex( x, y, u, v );
		}
		
		f5internal function f5moveTo( x:Number, y:Number, z:Number ):void
		{
			moveTo( x, y );
		}
		
		f5internal function f5lineTo( x:Number, y:Number, z:Number ):void
		{
			lineTo( x, y );
		}
		
		f5internal function f5curveTo( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			curveTo( cx, cy, x, y );
		}
	}
	
}