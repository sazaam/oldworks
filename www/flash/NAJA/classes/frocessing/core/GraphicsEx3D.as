// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// Frocessing drawing library
// Copyright (C) 2008-09  TAKANAWA Tomoaki (http://nutsu.com) and
//					   	  Spark project (www.libspark.org)
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
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.geom.FNumber3D;
	import frocessing.core.render3d.*;
	//import frocessing.f3d.lights.*;
	import frocessing.bmp.FBitmapData;
	
	/**
	* GraphicsEx3D.
	* 
	* <p>※将来的に再構成されなくなる予定です(frocessing.core.render3dパッケージ含む)</p>
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class GraphicsEx3D extends GraphicsEx
	{
		//constants
		private static const TASK_PATH_GRP:int = 0;
		private static const TASK_SHAPE:int    = 1;
		private static const TASK_STROKE:int   = 2;
		private static const TASK_POINT:int    = 10;
		private static const TASK_PIXEL:int    = 11;
		private static const TASK_IMAGE:int    = 20;
		private static const TASK_POLYGON:int  = 30;
		private static const TASK_POLYGON_SOLID:int = 31;
		
		private static const FILL_NO:int       = 0;
		private static const FILL_SOLID:int    = 1;
		private static const FILL_BITMAP:int   = 2;
		private static const FILL_GRADIENT:int = 3;
		
		//center coordinates
		public var centerX:Number;
		public var centerY:Number;
		
		//DRAW PATH TASK
		private var TASK_DAT:Array;
		private var task_count:uint;
		private var shape_task:RenderTask;
		private var STROKE_TASK:Array;	//IStrokeTask[]
		private var stroke_count:uint;
		private var current_stroke_index:int;
		private var current_fill_type:int;
		
		//
		private var __fill_matrix:Matrix;
		private var __fill_repeat:Boolean;
		private var __fill_smooth:Boolean;
		private var __grad_type:String;
		private var __grad_colors:Array;
		private var __grad_alphas:Array;
		private var __grad_ratios:Array
		private var __grad_spreadMethod:String;
		private var __grad_interpolationMethod:String;
		private var __grad_focalPointRatio:Number;
		
		//PATH
		private var path_start_index:int;
		private var cmd_start_index:int;
		
		private var paths:Array;
		private var path_count:int;
		private var vertex_count:int;
		
		private var commands:Array;
		private var cmd_count:int;
		
		private var path_z_sum:Number;
		
		//
		private var stroke_applyed:Boolean = false;
		private var fill_applyed:Boolean   = false;
		
		//path includes lineTo, curveTo
		private var _add_path_task:Boolean = false;
		//path render flg
		private var _render_path_task:Boolean;
		
		//
		public var perspective:Boolean;
		public var zNear:Number = 100;
		
		//
		public var backFaceCulling:Boolean;
		
		private var __texture:BitmapData;
		private var __texture_back:BitmapData;
		
		// for IFShape rendering
		private var _path_group:PathGroupTask;
		private var _path_group_za:Number;
		private var _path_group_flg:Boolean = false;
		
		
		//path status
		/** @private */
		internal var __startZ:Number = 0;
		/** @private */
		internal var __z:Number = 0;
		
		/**
		 * 
		 */
		public function GraphicsEx3D( graphics:Graphics, centerX:Number=0, centerY:Number=0, imageSmoothing:Boolean=false ) 
		{
			super(graphics);
			
			//
			this.imageSmoothing = imageSmoothing;
			imageDetail = 4;
			
			//texture
			__texture   	= null;
			__texture_back 	= null;
			backFaceCulling = true;
			
			//
			fillDo           = true;
			__stroke         = true;
			
			perspective  	= true;
			this.centerX 	= centerX;
			this.centerY 	= centerY;
			
			defaultSetting();
		}
		
		public function defaultSetting():void
		{
			TASK_DAT         = [];
			task_count       = 0;
			
			STROKE_TASK      = [];
			stroke_count     = 0;
			STROKE_TASK[stroke_count] = new NoStrokeTask();
			stroke_count++;
			
			stroke_applyed   = __stroke;
			fill_applyed	 = false;
			
			current_fill_type = FILL_NO;
			
			// path init
			path_start_index = 0;
			cmd_start_index  = 0;
			
			paths            = [];
			path_count       = 0;
			commands         = [];
			cmd_count        = 0;
			
			_render_path_task = false;
			vertex_count     = 0;
			path_z_sum       = 0;
			
			_add_path_task   = false;
			
			//
			__startX = __startY = __startZ = 0;
			__x = __y = __z = 0;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function beginDraw( perspective:Boolean=true ):void
		{
			this.perspective = perspective;
			defaultSetting();
		}
		
		/**
		 * 
		 */
		public function endDraw():void
		{
			render();
			__texture = null;
			__texture_back = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clear():void
		{
			gc.clear();
			defaultSetting();
		}
		
		//------------------------------------------------------------------------------------------------------------------- PATH
		
		/**
		 * @private
		 */
		override internal function __resetPathPoint():void {
			;//nothing
		}
		
		override public function moveTo( x:Number, y:Number ):void {
			moveTo3d( x, y, zNear );
		}
		override public function lineTo( x:Number, y:Number ):void {
			lineTo3d( x, y, zNear );
		}
		override public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void {
			curveTo3d( cx, cy, zNear, x, y, zNear );
		}
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			bezierTo3d( cx0, cy0, zNear, cx1, cy1, zNear, x, y, zNear );
		}
		override public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			splineTo3d( cx0, cy0, zNear, cx1, cy1, zNear, x, y, zNear );
		}
		override public function point(x:Number, y:Number):void {
			point3d( x, y, zNear );
		}
		override public function moveToLast():void
		{
			var x0:Number = __x;
			var y0:Number = __y;
			if ( perspective )
			{
				x0 *= __z/zNear;
				y0 *= __z/zNear;
			}
			moveTo3d( x0, y0, __z );
		}
		
		//------------------------------------------------------------------------------------------------------------------- 3D Path
		
		/**
		 * 
		 */
		public function bezierTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			var x0:Number = __x;
			var y0:Number = __y;
			var z0:Number = __z;
			if ( perspective )
			{
				x0 *= z0/zNear;
				y0 *= z0/zNear;
			}
			var k:Number = 1.0/bezierDetail;
			var t:Number = 0;
			var tp:Number;
			for ( var i:int = 1; i <= bezierDetail; i++ )
			{
				t += k;
				tp = 1.0 - t;
				lineTo3d( x0*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x*t*t*t,
						  y0*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y*t*t*t, 
						  z0*tp*tp*tp + 3*cz0*t*tp*tp + 3*cz1*t*t*tp + z*t*t*t );
			}
		}
		
		/**
		 * 
		 */
		public function splineTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			var x0:Number = __x;
			var y0:Number = __y;
			var z0:Number = __z;
			if ( perspective )
			{
				x0 *= z0/zNear;
				y0 *= z0/zNear;
			}
			var k:Number = 1.0 / splineDetail;
			var t:Number = 0;
			//convert to bezier
			var cx0:Number = x0 + __tightness * ( x - cx0 );
			var cy0:Number = y0 + __tightness * ( y - cy0 );
			var cz0:Number = z0 + __tightness * ( z - cz0 );
			var cx1:Number = x  - __tightness * ( cx1 - x0 );
			var cy1:Number = y  - __tightness * ( cy1 - y0 );
			var cz1:Number = z  - __tightness * ( cz1 - z0 );
			var tp:Number;
			for ( var i:int = 1; i <= splineDetail; i++ )
			{
				t += k;
				tp = 1.0-t;
				lineTo3d( x0*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x*t*t*t,
						  y0*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y*t*t*t, 
						  z0*tp*tp*tp + 3*cz0*t*tp*tp + 3*cz1*t*t*tp + z*t*t*t );
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// STYLE
		//-------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------------------------------- Stroke
		
		/**
		 * @inheritDoc
		 */
		override public function applyStroke():void
		{
			__stroke = true;
			stroke_applyed = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function noStroke():void
		{
			__stroke = false;
		}
		
		/**
		 * not implemented
		 */
		override public function lineGradientStyle( type:String, colors:Array, alphas:Array, ratios:Array,
										   matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb",
										   focalPointRatio:Number=0.0 ):void
		{
			;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Fill
		
		/**
		 * @inheritDoc
		 */
		override public function applyFill():void
		{
			if ( fillDo && __fill_apply_count<1 )
			{
				beginFill( fillColor, fillAlpha );
				__fill_apply_count = 1;
			}
			else
			{
				__fill_apply_count++;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginFill(color:uint, alpha:Number=1.0):void
		{
			__fill_apply_count = 1;
			terminateShapePath();
			
			fillColor = color;
			fillAlpha = alpha;
			fillDo = true;
			fill_applyed = true;
			current_fill_type = FILL_SOLID;
			
			// ------------ START PATH ------------
			startShapePath();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginBitmapFill( bitmapdata:BitmapData, matrix:Matrix=null, repeat:Boolean=true, smooth:Boolean=false ):void
		{
			__fill_apply_count = 1;
			terminateShapePath();
			
			__texture     = bitmapdata;
			__fill_matrix = ( matrix==null ) ? null : matrix.clone();
			__fill_repeat = repeat;
			__fill_smooth = smooth;
			fillDo = true;
			fill_applyed = true;
			current_fill_type = FILL_BITMAP;
			
			// ------------ START PATH ------------
			startShapePath();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginGradientFill( type:String, colors:Array, alphas:Array, ratios:Array,
										   matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb",
										   focalPointRatio:Number=0.0 ):void
		{
			__fill_apply_count = 1;
			terminateShapePath();
			
			__grad_type   = type;
			__grad_colors = colors.concat();
			__grad_alphas = alphas.concat();
			__grad_ratios = ratios.concat();
			__fill_matrix = ( matrix==null ) ? null : matrix.clone();
			__grad_spreadMethod = spreadMethod;
			__grad_interpolationMethod = interpolationMethod;
			__grad_focalPointRatio = focalPointRatio;
			fillDo = true;
			fill_applyed = true;
			current_fill_type = FILL_GRADIENT;
			
			// ------------ START PATH ------------
			startShapePath();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function endFill():void
		{
			__fill_apply_count--;
			if ( __fill_apply_count < 1 )
			{
				if ( fill_applyed )
				{
					terminateShapePath();
					current_fill_type = FILL_NO;
				}
				fill_applyed = false;
			}
		}
		
		public function beginTexture( texture:BitmapData, back_texture:BitmapData=null ):void
		{
			__texture = texture;
			__texture_back = (back_texture!=null) ? back_texture : texture;
		}
		
		public function endTexture():void
		{
			__texture = null;
			__texture_back = null;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// buffer
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * add stroke
		 */
		private function addStrokeTask():void
		{
			if ( stroke_applyed )
			{
				STROKE_TASK[stroke_count] = new StrokeTask( thickness, strokeColor, strokeAlpha, pixelHinting, scaleMode, caps, joints, miterLimit );
				stroke_count++;
				stroke_applyed = false;
			}
		}
		
		/**
		 * start shape draw session. moveTo, beginFill, beginBitmapFill, beginGradientFill
		 * @private
		 */
		private function startShapePath():void
		{
			//start indexes
			path_start_index = path_count;
			cmd_start_index  = cmd_count;
			
			//current shape parameters
			_render_path_task = true;
			vertex_count = 0;
			path_z_sum   = 0;
			
			//stroke
			if ( __stroke )
			{
				addStrokeTask();
				current_stroke_index = stroke_count - 1;
			}
			else
			{
				current_stroke_index = 0;
			}
		}
		
		/**
		 * terminate shape draw session.
		 * @private
		 */
		private function terminateShapePath():void
		{
			if ( _add_path_task && _render_path_task )
			{
				if ( current_fill_type == FILL_SOLID )
				{
					shape_task = new RenderTask( TASK_SHAPE, path_start_index, cmd_start_index, path_z_sum/vertex_count, cmd_count - cmd_start_index );
					shape_task.fillColor = fillColor;
					shape_task.fillAlpha = fillAlpha;
					shape_task.fillDo = true;
				}
				else if ( current_fill_type == FILL_BITMAP )
				{
					shape_task = new RenderBitmapTask( TASK_SHAPE, path_start_index, cmd_start_index, path_z_sum / vertex_count, cmd_count - cmd_start_index );
					RenderBitmapTask(shape_task).setParameters( __texture, __fill_matrix, __fill_repeat, __fill_smooth );
					shape_task.fillDo = true;
				}
				else if ( current_fill_type == FILL_GRADIENT )
				{
					shape_task = new RenderGradientTask( TASK_SHAPE, path_start_index, cmd_start_index, path_z_sum / vertex_count, cmd_count - cmd_start_index );
					RenderGradientTask(shape_task).setParameters( __grad_type, __grad_colors, __grad_alphas, __grad_ratios, __fill_matrix,
																  __grad_spreadMethod, __grad_interpolationMethod, __grad_focalPointRatio );
					shape_task.fillDo = true;
				}
				else//FILL_NO
				{
					shape_task = new RenderTask( TASK_STROKE, path_start_index, cmd_start_index, path_z_sum/vertex_count, cmd_count - cmd_start_index );	
				}
				shape_task.stroke_index = current_stroke_index;
				if ( !_path_group_flg )
				{
					TASK_DAT[task_count] = shape_task;
					task_count++;
				}
				else
				{
					_path_group.tasks.push( shape_task );
					_path_group.za += shape_task.za;
				}
			}
			_add_path_task = false;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// Shape TASK
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function moveTo3d( x:Number, y:Number, z:Number ):void
		{
			// not start shape session, while fill continue.
			if ( !fill_applyed )
			{
				terminateShapePath();
				// ------------ START TASK_STROKE ------------
				current_fill_type = FILL_NO;
				startShapePath();
			}
			
			if ( perspective )
			{	
				x *= zNear/z;
				y *= zNear/z;
			}
			
			__startX = __x = x;
			__startY = __y = y;
			__startZ = __z = z;
			
			// check out of render
			if ( z > 0 )
			{
				// path coordinates
				paths[ path_count ] = __startX + centerX;
				path_count++;
				paths[ path_count ] = __startY + centerY;
				path_count++;
				// commands
				commands[cmd_count] = 1; //MOVE_TO
			}
			else
			{
				_render_path_task = !fill_applyed;
				commands[cmd_count] = -1; //SKIP
			}
			
			// current shape parameter
			vertex_count++;
			path_z_sum += z;
			
			// global draw command count
			cmd_count++;
		}
		
		/**
		 * 
		 */
		public function lineTo3d( x:Number, y:Number, z:Number ):void
		{
			if ( perspective )
			{
				x *= zNear/z;
				y *= zNear/z;
			}
			
			__x = x;
			__y = y;
			__z = z;
			
			// check out of render
			if ( z > 0 )
			{
				// path coordinates
				paths[ path_count ] = x + centerX;
				path_count++;
				paths[ path_count ] = y + centerY;
				path_count++;
				// commands
				commands[cmd_count] = 2; //LINE_TO
			}
			else
			{
				_render_path_task = !fill_applyed;
				commands[cmd_count] = -1; //SKIP
			}
			
			// current shape parameter
			vertex_count++;
			path_z_sum += z;
			
			// global draw command count
			cmd_count++;
			
			//add flag
			_add_path_task = true;
		}
		
		/**
		 * 
		 */
		public function curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			if ( perspective )
			{
				cx *= zNear/cz;
				cy *= zNear/cz;
				x  *= zNear/z;
				y  *= zNear/z;
			}
			
			__x = x;
			__y = y;
			__z = z;
			
			// check out of render
			if ( z > 0 && cz > 0 )
			{
				// path coordinates
				paths.push( cx + centerX, cy + centerY, x + centerX,  y + centerY );
				path_count += 4;
				// commands
				commands[cmd_count] = 3; //CURVE_TO
			}
			else
			{
				_render_path_task = !fill_applyed;
				commands[cmd_count] = -1; //SKIP
			}
			
			// current shape parameter
			vertex_count++;
			path_z_sum += z;
			
			// global draw command count
			cmd_count++;
			
			//add flag
			_add_path_task = true;
		}
		
		/**
		 * 
		 */
		override public function closePath():void
		{
			__x = __startX;
			__y = __startY;
			__z = __startZ;
			
			if ( __z > 0 )
			{
				// path coordinates
				paths[ path_count ] = __startX + centerX;
				path_count++;
				paths[ path_count ] = __startY + centerY;
				path_count++;
				// commands
				commands[cmd_count] = 2; //LINE_TO
			}
			else
			{
				commands[cmd_count] = -1; //SKIP
			}
			
			// global draw command count
			cmd_count++;
		}
		
		/**
		 * for IFShape rendering
		 */
		internal function pathGroupStart():void
		{
			_path_group_flg = true;
			_path_group = new PathGroupTask();
		}
		internal function pathGroupEnd():void
		{
			_path_group_flg = false;
			var len:int = _path_group.tasks.length;
			if ( len > 0 )
			{
				_path_group.za /= len;
				TASK_DAT[task_count] = _path_group;
				task_count++;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// Other TASK
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function point3d( x:Number, y:Number, z:Number ):void
		{
			terminateShapePath();
			
			// check out of render			
			if ( z > 0 )
			{
				if ( perspective )
				{
					x *= zNear/z;
					y *= zNear/z;
				}
				__x = __startX = x;
				__y = __startY = y;
				__z = __startZ = z;
				
				// add task
				var task:PointTask = new PointTask( x + centerX, y + centerY, z, strokeColor, strokeAlpha );
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		/**
		 * 
		 */
		public function pixel3d( x:Number, y:Number, z:Number ):void
		{
			terminateShapePath();
			
			// check out of render
			if ( z > 0 )
			{
				if ( perspective )
				{
					x *= zNear/z;
					y *= zNear/z;
				}
				__x = __startX = x;
				__y = __startY = y;
				__z = __startZ = z;
				
				// add task
				var task:PixelTask = new PixelTask( x + centerX, y + centerY, z, uint(strokeAlpha*0xff)<<24 | strokeColor  );
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function bitmap( x:Number, y:Number, z:Number, w:Number, h:Number, center:Boolean ):void
		{
			terminateShapePath();
			
			__x = __startX = x;
			__y = __startY = y;
			__z = __startZ = z;
			
			// check out of render
			if ( z > 0 )
			{
				if ( perspective )
				{
					x *= zNear/z;
					y *= zNear/z;
					w *= zNear/z;
					h *= zNear/z;
				}
				if ( center )
				{
					x -= w * 0.5;
					y -= h * 0.5;
				}
				
				// add task
				var task_i:ImageTask = new ImageTask( __texture, x + centerX, y + centerY, z, w, h );
				if ( __stroke )
				{
					addStrokeTask();
					task_i.stroke_index = stroke_count-1;
				}
				TASK_DAT[task_count] = task_i;
				task_count++;
			}
		}
		
		/**
		 * 
		 */
		public function polygonSolid( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number ):void
		{
			terminateShapePath();
			
			__x = __startX = x0;
			__y = __startY = y0;
			__z = __startZ = z0;
			
			// check out of render
			if ( z0 > 0 && z1 >0 && z2 > 0 )
			{
				if ( perspective )
				{
					x0 *= zNear/z0;
					y0 *= zNear/z0;
					x1 *= zNear/z1;
					y1 *= zNear/z1;
					x2 *= zNear/z2;
					y2 *= zNear/z2;
				}
				
				var v0x:Number = x1 - x0; 
				var v0y:Number = y1 - y0;
				var v1x:Number = x2 - x0;
				var v1y:Number = y2 - y0;
				var cross_value:Number = v0x * v1y - v0y * v1x;
				if ( backFaceCulling && cross_value<=0)
					return;
				
				//light test
				//var fillColor_:uint;
				//light.fillColor = fillColor;
				//fillColor_ = light.getShadedColor( v0x, v0y, z1 - z0, v1x, v1y, z2 - z0 );
				
				//
				x0 += centerX;
				y0 += centerY;
				x1 += centerX;
				y1 += centerY;
				x2 += centerX;
				y2 += centerY;
				
				// add task
				var task:PolygonTask;
				if ( current_fill_type == FILL_SOLID )
				{
					task = new PolygonColorTask( x0, y0, z0, x1, y1, z1, x2, y2, z2 );
					PolygonColorTask( task ).setParameters( fillColor, fillAlpha );
				}
				else if ( current_fill_type == FILL_BITMAP )
				{
					task = new PolygonBitmapTask( x0, y0, z0, x1, y1, z1, x2, y2, z2 );
					PolygonBitmapTask(task).setParameters( __texture, __fill_matrix, __fill_repeat, __fill_smooth );
				}
				else if ( current_fill_type == FILL_GRADIENT )
				{
					task = new PolygonGradientTask( x0, y0, z0, x1, y1, z1, x2, y2, z2 );
					PolygonGradientTask(task).setParameters( __grad_type, __grad_colors, __grad_alphas, __grad_ratios, __fill_matrix,
															 __grad_spreadMethod, __grad_interpolationMethod, __grad_focalPointRatio );
				}
				else
				{
					task = new PolygonTask( x0, y0, z0, x1, y1, z1, x2, y2, z2 );
				}
				if ( __stroke )
				{
					addStrokeTask();
					task.stroke_index = stroke_count-1;
				}
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		/**
		 * 
		 */
		public function plane( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void
		{
			terminateShapePath();
			
			__x = __startX = x0;
			__y = __startY = y0;
			__z = __startZ = z0;
			
			// check out of render
			if ( z0 > 0 && z1 >0 && z2 > 0 && z3 > 0 )
			{
				if ( perspective )
				{
					x0 *= zNear/z0;
					y0 *= zNear/z0;
					x1 *= zNear/z1;
					y1 *= zNear/z1;
					x2 *= zNear/z2;
					y2 *= zNear/z2;
					x3 *= zNear/z3;
					y3 *= zNear/z3;
				}
				
				var v0x:Number = x1 - x0; 
				var v0y:Number = y1 - y0;
				var v1x:Number = x2 - x0;
				var v1y:Number = y2 - y0;
				var cross_value:Number = v0x * v1y - v0y * v1x;
				if ( backFaceCulling && cross_value<=0)
					return;
				
				//
				x0 += centerX;
				y0 += centerY;
				x1 += centerX;
				y1 += centerY;
				x2 += centerX;
				y2 += centerY;
				x3 += centerX;
				y3 += centerY;
				
				// add task
				var task:QuadTask;
				if ( current_fill_type == FILL_SOLID )
				{
					task = new QuadColorTask( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3 );
					QuadColorTask( task ).setParameters( fillColor, fillAlpha );
				}
				else if ( current_fill_type == FILL_BITMAP )
				{
					task = new QuadBitmapTask( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3 );
					PolygonBitmapTask(task).setParameters( __texture, __fill_matrix, __fill_repeat, __fill_smooth );
				}
				else if ( current_fill_type == FILL_GRADIENT )
				{
					task = new QuadGradientTask( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3 );
					PolygonGradientTask(task).setParameters( __grad_type, __grad_colors, __grad_alphas, __grad_ratios, __fill_matrix,
															 __grad_spreadMethod, __grad_interpolationMethod, __grad_focalPointRatio );
				}
				else
				{
					task = new QuadTask( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3 );
				}
				if ( __stroke )
				{
					addStrokeTask();
					task.stroke_index = stroke_count-1;
				}
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		/**
		 * 
		 */
		public function polygon( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number,
								 u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			terminateShapePath();
			
			__x = __startX = x0;
			__y = __startY = y0;
			__z = __startZ = z0;
			
			// check out of render
			if ( z0 > 0 && z1 >0 && z2 > 0 )
			{
				if ( perspective )
				{
					x0 *= zNear/z0;
					y0 *= zNear/z0;
					x1 *= zNear/z1;
					y1 *= zNear/z1;
					x2 *= zNear/z2;
					y2 *= zNear/z2;
				}
				
				var v0x:Number = x1 - x0; 
				var v0y:Number = y1 - y0; 
				var v1x:Number = x2 - x0; 
				var v1y:Number = y2 - y0; 
				var cross_value:Number = v0x * v1y - v0y * v1x;
				if ( backFaceCulling && cross_value<=0)
					return;
				
				// add task
				var task:PolygonTextureTask = new PolygonTextureTask(
					x0 + centerX, y0 + centerY, z0,
					x1 + centerX, y1 + centerY, z1,
					x2 + centerX, y2 + centerY, z2,
					u0, v0, u1, v1, u2, v2
				);
				task.bitmapdata = (cross_value>0) ? __texture : __texture_back;
				if ( __stroke )
				{
					addStrokeTask();
					task.stroke_index = stroke_count-1;
				}
				TASK_DAT[task_count] = task;
				task_count++;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function image( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number,
							   u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void
		{			
			var u:Number;
			var v:Number;
			
			var v0x0:Number = x0;
			var v0y0:Number = y0;
			var v0z0:Number = z0;
			var v0x1:Number = x1;
			var v0y1:Number = y1;
			var v0z1:Number = z1;
			var v1x0:Number;
			var v1y0:Number;
			var v1z0:Number;
			var v1x1:Number;
			var v1y1:Number;
			var v1z1:Number;
			
			var v0u0:Number = u0;
			var v0v0:Number = u0;
			var v0u1:Number = u1;
			var v0v1:Number = v1;
			var v1u0:Number;
			var v1v0:Number;
			var v1u1:Number;
			var v1v1:Number;
			
			var h0x0:Number; 
			var h0y0:Number;
			var h0z0:Number;
			var h0x1:Number;
			var h0y1:Number;
			var h0z1:Number;
			var h1x0:Number;
			var h1y0:Number;
			var h1z0:Number;
			var h1x1:Number;
			var h1y1:Number;
			var h1z1:Number;
			
			var h0u0:Number;
			var h0v0:Number;
			var h0u1:Number;
			var h0v1:Number;
			var h1u0:Number;
			var h1v0:Number;
			var h1u1:Number;
			var h1v1:Number;
			
			var d:Number = 1 / imageDetail;
			for( var i:int=1; i<=imageDetail; i++ )
			{
				v = i * d;
				v1x0 = x0 + (x3 - x0) * v;
				v1y0 = y0 + (y3 - y0) * v;
				v1z0 = z0 + (z3 - z0) * v;
				v1x1 = x1 + (x2 - x1) * v;
				v1y1 = y1 + (y2 - y1) * v;
				v1z1 = z1 + (z2 - z1) * v;
				v1u0 = u0 + (u3 - u0) * v;
				v1v0 = v0 + (v3 - v0) * v;
				v1u1 = u1 + (u2 - u1) * v;
				v1v1 = v1 + (v2 - v1) * v;
				
				h0x0 = v0x0; h0y0 = v0y0; h0z0 = v0z0;
				h0x1 = v1x0; h0y1 = v1y0; h0z1 = v1z0;
				h0u0 = v0u0; h0v0 = v0v0;
				h0u1 = v1u0; h0v1 = v1v0;
				
				for ( var j:int = 1; j <=imageDetail; j++ )
				{
					u = j * d;
					h1x0 = v0x0 + (v0x1 - v0x0) * u;
					h1y0 = v0y0 + (v0y1 - v0y0) * u;
					h1z0 = v0z0 + (v0z1 - v0z0) * u;
					h1x1 = v1x0 + (v1x1 - v1x0) * u;
					h1y1 = v1y0 + (v1y1 - v1y0) * u;
					h1z1 = v1z0 + (v1z1 - v1z0) * u;
					h1u0 = v0u0 + (v0u1 - v0u0) * u;
					h1v0 = v0v0 + (v0v1 - v0v0) * u;
					h1u1 = v1u0 + (v1u1 - v1u0) * u;
					h1v1 = v1v0 + (v1v1 - v1v0) * u;
					
					polygon( h0x0, h0y0, h0z0,  h1x0, h1y0, h1z0,  h0x1, h0y1, h0z1,
							 h0u0, h0v0, h1u0, h1v0, h0u1, h0v1 );
					
					polygon( h1x0, h1y0, h1z0,  h1x1, h1y1, h1z1,  h0x1, h0y1, h0z1,
							 h1u0, h1v0, h1u1, h1v1, h0u1, h0v1 );
					
					h0x0 = h1x0; h0y0 = h1y0; h0z0 = h1z0;
					h0x1 = h1x1; h0y1 = h1y1; h0z1 = h1z1; 
					h0u0 = h1u0; h0v0 = h1v0;
					h0u1 = h1u1; h0v1 = h1v1;
				}
				
				v0x0 = v1x0; v0y0 = v1y0; v0z0 = v1z0;
				v0x1 = v1x1; v0y1 = v1y1; v0z1 = v1z1;
				v0u0 = v1u0; v0v0 = v1v0;
				v0u1 = v1u1; v0v1 = v1v1;
			}
		}
		
		/**
		 * 
		 * @param	vertices
		 * @param	indices
		 * @param	uvData
		 */
		public function drawTriangles( vertices:Array, indices:Array, uvData:Array=null ):void
		{			
			var i:int = 0;
			var len:int = indices.length;
			
			var i0:int;
			var i1:int;
			var i2:int;
			var i0y:int;
			var i0z:int;
			var i1y:int;
			var i1z:int;
			var i2y:int;
			var i2z:int;
			
			if ( __texture!=null )
			{
				var u0:int;
				var u1:int;
				var u2:int;
				var v0:int;
				var v1:int;
				var v2:int;
				for ( i = 0; i < len; i++ )
				{
					i0 = indices[i]; i++;
					i1 = indices[i]; i++;
					i2 = indices[i];
					u0 = i0 * 2;  v0 = u0 + 1;
					u1 = i1 * 2;  v1 = u1 + 1;
					u2 = i2 * 2;  v2 = u2 + 1;
					i0 *= 3;
					i1 *= 3;
					i2 *= 3;
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					polygon( vertices[i0], vertices[i0y], vertices[i0z],
							 vertices[i1], vertices[i1y], vertices[i1z],
							 vertices[i2], vertices[i2y], vertices[i2z],
							 uvData[u0], uvData[v0],
							 uvData[u1], uvData[v1],
							 uvData[u2], uvData[v2] );
				}
			}
			else
			{
				for ( i = 0; i < len; i++ )
				{
					i0 = 3 * indices[i]; i++;
					i1 = 3 * indices[i]; i++;
					i2 = 3 * indices[i];
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					polygonSolid( vertices[i0], vertices[i0y], vertices[i0z],
								  vertices[i1], vertices[i1y], vertices[i1z],
								  vertices[i2], vertices[i2y], vertices[i2z] );
				}
			}
		}
		
		/**
		 * 
		 * @param	vertices
		 * @param	faces
		 * @param	uvData
		 */
		public function drawMesh( vertices:Array, faces:Array, uvData:Array=null ):void
		{			
			var i:int = 0;
			var len:int = faces.length;
			
			var i0:int;
			var i1:int;
			var i2:int;
			var i0y:int;
			var i0z:int;
			var i1y:int;
			var i1z:int;
			var i2y:int;
			var i2z:int;
			
			if ( __texture!=null )
			{
				var u0:Number;
				var u1:Number;
				var u2:Number;
				var v0:Number;
				var v1:Number;
				var v2:Number;
				for ( i = 0; i < len; i++ )
				{
					i0 = faces[i]; 
					u0 = uvData[i * 2];
					v0 = uvData[i * 2 + 1];
					i++;
					i1 = faces[i]; 
					u1 = uvData[i * 2];
					v1 = uvData[i * 2 + 1];
					i++;
					i2 = faces[i];
					u2 = uvData[i * 2];
					v2 = uvData[i * 2 + 1];
					i0 *= 3;
					i1 *= 3;
					i2 *= 3;
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					polygon( vertices[i0], vertices[i0y], vertices[i0z],
							 vertices[i1], vertices[i1y], vertices[i1z],
							 vertices[i2], vertices[i2y], vertices[i2z],
							 u0, v0, u1, v1, u2, v2 );
				}
			}
			else
			{
				for ( i = 0; i < len; i++ )
				{
					i0 = 3 * faces[i]; i++;
					i1 = 3 * faces[i]; i++;
					i2 = 3 * faces[i];
					i0y = i0 + 1;  i0z = i0 + 2;
					i1y = i1 + 1;  i1z = i1 + 2;
					i2y = i2 + 1;  i2z = i2 + 2;
					polygonSolid( vertices[i0], vertices[i0y], vertices[i0z],
								  vertices[i1], vertices[i1y], vertices[i1z],
								  vertices[i2], vertices[i2y], vertices[i2z] );
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// render
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function _renderTaskShape( task:RenderTask ):void
		{
			var cmd_start:int = task.command_start;
			var cmd_num:int   = task.command_num;
			var xi:int = task.path_start;
			var yi:int = xi + 1;
			
			gc.moveTo( 0, 0 );
			task.applyFill( gc );			
			gc.moveTo( paths[xi], paths[yi] );
			xi += 2;
			yi += 2;
			for ( var c:int=1; c<cmd_num; c++ )
			{
				cmd_start++;
				var cmd_type:int = commands[cmd_start];
				if ( cmd_type == 1 )
				{
					gc.moveTo( paths[xi], paths[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( cmd_type == 2 )
				{
					gc.lineTo( paths[xi], paths[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( cmd_type == 3 )
				{
					gc.curveTo( paths[xi], paths[yi], paths[uint(xi+2)], paths[uint(yi+2)] );
					xi += 4;
					yi += 4;
				}
			}
			gc.endFill();
		}
		
		/**
		 * @private
		 */
		private function _renderStrokeTask( task:RenderTask ):void
		{
			var cmd_start:int = task.command_start;
			var cmd_num:int   = task.command_num;
			var xi:int = task.path_start;
			var yi:int = xi + 1;
			var skip:Boolean = false;
			
			var cmd_type:int = commands[cmd_start];
			if ( cmd_type == 1 )
			{
				gc.moveTo( paths[xi], paths[yi] );
				xi += 2;
				yi += 2;
			}
			else
			{
				skip = true;
			}
			for ( var c:int=1; c<cmd_num; c++ )
			{
				cmd_start++;
				cmd_type = commands[cmd_start];
				if ( cmd_type == 2 )
				{
					if ( skip )
					{
						gc.moveTo( paths[xi], paths[yi] );
						skip = false;
					}
					else
					{
						gc.lineTo( paths[xi], paths[yi] );
					}
					xi += 2;
					yi += 2;
				}
				else if ( cmd_type == 3 )
				{
					if ( skip )
					{
						gc.moveTo( paths[uint(xi+2)], paths[uint(yi+2)] );
						skip = false;
					}
					else
					{
						gc.curveTo( paths[xi], paths[yi], paths[uint(xi+2)], paths[uint(yi+2)] );
					}
					xi += 4; 
					yi += 4;
				}
				else
				{
					skip = true;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function render():void
		{
			// add last buffer
			terminateShapePath();
			
			TASK_DAT.sortOn("za", Array.DESCENDING | Array.NUMERIC );
			
			//
			var _task:RenderTaskObject;
			var tmp_stroke_index:uint = 0;
			var stroke_index:uint;
			
			gc.lineStyle();
			
			for ( var i:int = 0; i < task_count; i++ )
			{	
				_task = RenderTaskObject( TASK_DAT[i] );
				var tk:int = _task.kind;
				if ( tk == TASK_PATH_GRP )
				{
					var grp_task:PathGroupTask = PathGroupTask( _task );
					var grp_tasks:Array = grp_task.tasks;
					var grp_len:int = grp_tasks.length;
					for ( var g:int = 0; g < grp_len; g++ )
					{
						_task = RenderTaskObject( grp_tasks[g] );
						tk = _task.kind;
						if ( tk == TASK_SHAPE )
						{
							stroke_index = _task.stroke_index;
							if ( tmp_stroke_index != stroke_index )
							{
								IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(gc);
								tmp_stroke_index = stroke_index;
							}
							_renderTaskShape( RenderTask(_task) );
						}
						else if ( tk == TASK_STROKE )
						{
							stroke_index = _task.stroke_index;
							if ( tmp_stroke_index != stroke_index )
							{
								IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(gc);
								tmp_stroke_index = stroke_index;
							}
							_renderStrokeTask( RenderTask(_task) );
						}
					}
				}
				if ( tk == TASK_SHAPE )
				{
					stroke_index = _task.stroke_index;
					if ( tmp_stroke_index != stroke_index )
					{
						IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(gc);
						tmp_stroke_index = stroke_index;
					}
					_renderTaskShape( RenderTask(_task) );
				}
				else if ( tk == TASK_STROKE )
				{
					stroke_index = _task.stroke_index;
					if ( tmp_stroke_index != stroke_index )
					{
						IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(gc);
						tmp_stroke_index = stroke_index;
					}
					_renderStrokeTask( RenderTask(_task) );
				}
				else if ( tk == TASK_POLYGON )
				{
					stroke_index = _task.stroke_index;
					if ( tmp_stroke_index != stroke_index )
					{
						IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(gc);
						tmp_stroke_index = stroke_index;
					}
					gc.moveTo( 0, 0 );
					PolygonTextureTask(_task).render( this );
				}
				else if ( tk == TASK_POLYGON_SOLID )
				{
					stroke_index = _task.stroke_index;
					if ( tmp_stroke_index != stroke_index )
					{
						IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(gc);
						tmp_stroke_index = stroke_index;
					}
					gc.moveTo( 0, 0 );
					IGraphicsTask(_task).render( gc );
				}
				else if ( tk == TASK_IMAGE )
				{
					stroke_index = _task.stroke_index;
					if ( tmp_stroke_index != stroke_index )
					{
						IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(gc);
						tmp_stroke_index = stroke_index;
					}
					gc.moveTo( 0, 0 );
					ImageTask(_task).render( this );
				}
				else if ( tk == TASK_POINT )
				{
					if ( tmp_stroke_index != 0 )
					{
						gc.lineStyle();
						tmp_stroke_index = 0;
					}
					gc.moveTo( 0, 0 );
					IGraphicsTask(_task).render( gc );
				}
				else if ( tk == TASK_PIXEL )
				{
					PixelTask(_task).render( pixelbitmap );
				}
			}
		}
		
	}
	
}