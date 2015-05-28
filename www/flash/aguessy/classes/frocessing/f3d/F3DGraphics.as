// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// Licensed under the MIT License
//
// Frocessing drawing library
// Copyright (C) 2008  TAKANAWA Tomoaki (http://nutsu.com) and
//					   Spark project (www.libspark.org)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

package frocessing.f3d 
{
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.bmp.FBitmapData;
	import frocessing.bmp.FBitmapGraphics;
	import frocessing.geom.FMatrix2D;
	import frocessing.f3d.render.*;
	/**
	* ...
	* @author nutsu
	* @version 0.3
	*/
	public class F3DGraphics 
	{
		private static const TASK_SHAPE:int   = 1;
		private static const TASK_STROKE:int  = 2;
		private static const TASK_POINT:int   = 10;
		private static const TASK_PIXEL:int   = 11;
		private static const TASK_IMAGE:int   = 20;
		private static const TASK_POLYGON:int = 30;
		private static const TASK_POLYGON_SOLID:int = 31;
		
		private static const FILL_NO:int       = 0;
		private static const FILL_SOLID:int    = 1;
		private static const FILL_BITMAP:int   = 2;
		private static const FILL_GRADIENT:int = 3;
		
		//
		private var _gc:Graphics
		private var _bmpGC:FBitmapGraphics;
		
		public var centerX:Number;
		public var centerY:Number;
		
		//DRAW PATH TASK
		private var TASK_DAT:Array;		//
		private var task_count:uint;
		private var shape_task:RenderTask;
		private var STROKE_TASK:Array;	//IStrokeTask[]
		private var stroke_count:uint;
		private var current_stroke_index:int;
		
		//STYLES
		private var stroke_updated:Boolean;
		private var current_fill_type:int;
		
		public var stroke_do:Boolean;
		public var fill_do:Boolean;
		
		private var _strokeColor:uint;
		private var _strokeAlpha:Number;
		private var _thickness:Number;
		private var _pixelHinting:Boolean;
		private var _scaleMode:String;
		private var _caps:String;
		private var _joints:String;
		private var _miterLimit:Number;
		
		public var fillColor:uint;
		public var fillAlpha:Number;
		
		public var bitmapdata:BitmapData;
		public var bitmapdata_back:BitmapData;
		
		public var fill_matrix:Matrix;
		public var fill_repeat:Boolean;
		public var fill_smooth:Boolean;
		public var grad_type:String;
		public var grad_colors:Array;
		public var grad_alphas:Array;
		public var grad_ratios:Array
		public var grad_spreadMethod:String;
		public var grad_interpolationMethod:String;
		public var grad_focalPointRation:Number;
		
		//PATH
		private var path_start_index:int;
		private var cmd_start_index:int;
		
		private var paths:Array;
		private var path_count:int;
		private var vertex_count:int;
		
		private var commands:Array;
		private var cmd_count:int;
		
		private var do_shape_render:Boolean;
		private var path_z_sum:Number;
		private var z_out:Boolean;
		
		private var stroke_only:Boolean;
		
		//
		private var _startX:Number;
		private var _startY:Number;
		private var _startZ:Number;
		
		//
		private var add_shape_task:Boolean = false;
		
		//
		public var perspective:Boolean;
		public var zNear:Number = 100;
		
		//
		public var backFaceCulling:Boolean;
		
		//
		public var pixelbitmap:FBitmapData;
		
		/**
		 * 
		 * @param	gc
		 * @param	centerX_
		 * @param	centerY_
		 */
		public function F3DGraphics( gc:Graphics, centerX_:Number=0, centerY_:Number=0, imagesmoothing:Boolean=false ) 
		{
			// graphics
			_gc     = gc;
			
			// bitmap graphics
			_bmpGC  = new FBitmapGraphics( gc, imagesmoothing );
			
			//
			centerX = centerX_;
			centerY = centerY_;
			
			//
			perspective  = true;
			
			// stroke init
			stroke_updated = false;
			
			thickness    = 0;
			strokeColor  = 0;
			strokeAlpha  = 1;
			pixelHinting = false;
			scaleMode    = "normal";
			caps         = null;
			joints       = null;
			miterLimit   = 3;
			
			// fill init
			current_fill_type = FILL_NO;
			
			fillColor    = 0xffffff;
			fillAlpha    = 1;
			fill_matrix  = null;
			fill_repeat  = true;
			fill_smooth  = false;
			
			bitmapdata   = null;
			bitmapdata_back = null;
			backFaceCulling = true;
			
			init();
		}
		
		public function init():void
		{
			TASK_DAT         = [];
			task_count       = 0;
			
			stroke_updated   = true;
			STROKE_TASK      = [];
			stroke_count     = 0;
			STROKE_TASK[stroke_count] = new NoStrokeTask();
			stroke_count++;
			
			stroke_do        = false;
			fill_do          = false;
			current_fill_type = FILL_NO;
			
			// path init
			path_start_index = 0;
			cmd_start_index  = 0;
			
			paths            = [];
			path_count       = 0;
			commands         = [];
			cmd_count        = 0;
			
			do_shape_render  = false;
			vertex_count     = 0;
			path_z_sum       = 0;
			
			stroke_only      = false;
			
			add_shape_task   = false;
			
			//
			_startX = _startY = _startZ = 0;
		}
		
		//--------------------------------------------------------------------------------------------------- DRAW BEGIN, END
		
		/**
		 * 
		 */
		public function beginDraw( perspective_:Boolean=true ):void
		{
			perspective = perspective_;
			init();
		}
		
		/**
		 * 
		 */
		public function endDraw():void
		{
			render();
			bitmapdata = null;
			bitmapdata_back = null;
			//init();
		}
		
		public function clear():void
		{
			_gc.clear();
			init();
		}
		
		//--------------------------------------------------------------------------------------------------- STROKE
		
		public function lineStyle( thickness_:Number=0, color_:uint=0, alpha_:Number=1, pixelHinting_:Boolean=false, scaleMode_:String="normal", caps_:String=null, joints_:String=null, miterLimit_:Number=3 ):void
		{
			if ( arguments.length>0 )
			{
				stroke_updated = true;
				stroke_do    = true;
				thickness    = thickness_;
				strokeColor  = color_;
				strokeAlpha  = alpha_;
				pixelHinting = pixelHinting_;
				scaleMode    = scaleMode_;
				caps         = caps_;
				joints       = joints_;
				miterLimit   = miterLimit_;
			}
			else
			{
				stroke_do = false;
			}
		}
		
		public function applyLineStyle():void
		{
			stroke_do = true;
		}
		
		public function noLineStyle():void
		{
			stroke_do = false;
		}
		
		
		public function get strokeColor():uint { return _strokeColor; }
		public function set strokeColor(value:uint):void 
		{
			_strokeColor = value;
			stroke_updated = true;
		}
		
		public function get strokeAlpha():Number { return _strokeAlpha; }
		public function set strokeAlpha(value:Number):void 
		{
			_strokeAlpha = value;
			stroke_updated = true;
		}
		
		public function get thickness():Number { return _thickness; }
		public function set thickness(value:Number):void 
		{
			_thickness = value;
			stroke_updated = true;
		}
		
		public function get pixelHinting():Boolean { return _pixelHinting; }
		public function set pixelHinting(value:Boolean):void 
		{
			_pixelHinting = value;
			stroke_updated = true;
		}
		
		public function get scaleMode():String { return _scaleMode; }
		public function set scaleMode(value:String):void 
		{
			_scaleMode = value;
			stroke_updated = true;
		}
		
		public function get caps():String { return _caps; }
		public function set caps(value:String):void 
		{
			_caps = value;
			stroke_updated = true;
		}
		
		public function get joints():String { return _joints; }
		public function set joints(value:String):void 
		{
			_joints = value;
			stroke_updated = true;
		}
		
		public function get miterLimit():Number { return _miterLimit; }
		public function set miterLimit(value:Number):void 
		{
			_miterLimit = value;
			stroke_updated = true;
		}
		
		//--------------------------------------------------------------------------------------------------- FILL
		
		/**
		 * 
		 * @param	color
		 * @param	alpha
		 */
		public function beginFill( color:uint, alpha:Number = 1.0 ):void
		{
			fillColor = color;
			fillAlpha = alpha;
			
			fill_do = true;
			current_fill_type = FILL_SOLID;
			
			// ------------ START PATH ------------
			terminateShapePath();
			startShapePath();
		}
		
		/**
		 * 
		 */
		public function beginBitmapFill( bitmap_:BitmapData, matrix_:Matrix=null, repeat_:Boolean=true, smooth_:Boolean=false ):void
		{
			bitmapdata  = bitmap_;
			fill_matrix = ( matrix_ ) ? matrix_.clone() : null;
			fill_repeat = repeat_;
			fill_smooth = smooth_;
			
			fill_do = true;
			current_fill_type = FILL_BITMAP;
			
			// ------------ START PATH ------------
			terminateShapePath();
			startShapePath();
		}
		
		/**
		 * 
		 */
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix_:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRation:Number=0.0):void
		{
			grad_type = type;
			grad_colors = colors;
			grad_alphas = alphas;
			grad_ratios = ratios;
			fill_matrix = ( matrix_ ) ? matrix_.clone() : null;
			grad_spreadMethod = spreadMethod;
			grad_interpolationMethod = interpolationMethod;
			grad_focalPointRation = focalPointRation;
			
			fill_do = true;
			current_fill_type = FILL_GRADIENT;
			
			// ------------ START PATH ------------
			terminateShapePath();
			startShapePath();
		}
		
		/**
		 * 
		 */
		public function endFill():void
		{
			if ( fill_do )
			{
				terminateShapePath();
				current_fill_type = FILL_NO;
				fill_do = false;
			}
		}
		
		public function beginTexture( texture:BitmapData, back_texture:BitmapData=null ):void
		{
			bitmapdata = texture;
			bitmapdata_back = (back_texture) ? back_texture : texture;
		}
		
		public function endTexture():void
		{
			bitmapdata = null;
			bitmapdata_back = null;
		}
		
		//--------------------------------------------------------------------------------------------------- PATH
		
		private function addStrokeTask():void
		{
			if ( stroke_updated )
			{
				STROKE_TASK[stroke_count] = new StrokeTask( thickness, strokeColor, strokeAlpha, pixelHinting, scaleMode, caps, joints, miterLimit );
				stroke_count++;
				stroke_updated = false;
			}
		}
		
		/**
		 * start shape draw session. moveTo, lineTo, curveTo
		 * @private
		 */
		private function startShapePath():void
		{
			//start indexes
			path_start_index = path_count;
			cmd_start_index  = cmd_count;
			
			//current shape parameters
			do_shape_render = true;
			vertex_count = 0;
			path_z_sum   = 0;
		}
		
		/**
		 * terminate shape draw session.
		 * @private
		 */
		private function terminateShapePath():void
		{
			if ( add_shape_task )
			{
				if ( stroke_only )
				{
					if ( stroke_do )
					{
						shape_task = new RenderTask( TASK_STROKE, path_start_index, cmd_start_index, path_z_sum/vertex_count, cmd_count - cmd_start_index );
						addStrokeTask();
						shape_task.stroke_index = current_stroke_index;
						TASK_DAT[task_count] = shape_task;
						task_count++;
					}
					stroke_only = false;
				}
				else if ( do_shape_render )
				{
					switch( current_fill_type )
					{
						case FILL_SOLID:
							shape_task = new RenderTask( TASK_SHAPE, path_start_index, cmd_start_index, path_z_sum/vertex_count, cmd_count - cmd_start_index );
							shape_task.fillColor = fillColor;
							shape_task.fillAlpha = fillAlpha;
							break;
						case FILL_BITMAP:
							shape_task = new RenderBitmapTask( TASK_SHAPE, path_start_index, cmd_start_index, path_z_sum / vertex_count, cmd_count - cmd_start_index );
							RenderBitmapTask(shape_task).setParameters( bitmapdata, fill_matrix, fill_repeat, fill_smooth );
							break;
						case FILL_GRADIENT:
							shape_task = new RenderGradientTask( TASK_SHAPE, path_start_index, cmd_start_index, path_z_sum / vertex_count, cmd_count - cmd_start_index );
							RenderGradientTask(shape_task).setParameters( grad_type, grad_colors, grad_alphas, grad_ratios, fill_matrix,
																		  grad_spreadMethod, grad_interpolationMethod, grad_focalPointRation );
							break;
						default:
							shape_task = new RenderTask( TASK_SHAPE, path_start_index, cmd_start_index, path_z_sum/vertex_count, cmd_count - cmd_start_index );
							shape_task.fillColor = fillColor;
							shape_task.fillAlpha = fillAlpha;
							break;
					}
					shape_task.fill_do = true;
					if ( stroke_do )
					{
						addStrokeTask();
						shape_task.stroke_index = stroke_count-1;
					}
					TASK_DAT[task_count] = shape_task;
					task_count++;
				}
				add_shape_task = false;
				
				//current_fill_type = FILL_NO;
				//fill_do = false;
			}
		}
		
		//--------------------------------------------------------------------------------------------------- DRAW METHOD
		
		/**
		 * 
		 */
		public function moveTo( x:Number, y:Number, z:Number ):void
		{
			addStrokeTask();
			if ( !fill_do )
			{
				// ------------ START TASK_STROKE ------------
				terminateShapePath();
				startShapePath();
				
				stroke_only = true;
			}
			
			// check out of render
			z_out = ( z <= 0 );
			
			if ( perspective )
			{	
				x *= zNear/z;
				y *= zNear/z;
			}
			
			// path coordinates
			_startX = x + centerX;
			_startY = y + centerY;
			_startZ = z;
			paths[ path_count ] = _startX;
			path_count++;
			paths[ path_count ] = _startY;
			path_count++;
			paths[ path_count ] = _startZ;
			path_count++;
			
			// commands
			commands[cmd_count] = 1; //MOVE_TO
			
			// current shape parameter
			vertex_count++;
			path_z_sum += z;
			if( z_out ) do_shape_render = false;
			
			// global draw command count
			cmd_count++;
			current_stroke_index = 0;
		}
		
		/**
		 * 
		 */
		public function lineTo( x:Number, y:Number, z:Number ):void
		{
			// check out of render
			z_out = ( z <= 0 );
			
			if ( perspective )
			{
				x *= zNear/z;
				y *= zNear/z;
			}
			
			// path coordinates
			paths[ path_count ] = x + centerX;
			path_count++;
			paths[ path_count ] = y + centerY;
			path_count++;
			paths[ path_count ] = z;
			path_count++;
			
			// commands
			commands[cmd_count] = 2; //LINE_TO
			
			// current shape parameter
			vertex_count++;
			path_z_sum += z;
			if ( z_out ) do_shape_render = false;
			
			// global draw command count
			cmd_count++;
			
			//add flag
			add_shape_task = true;
			current_stroke_index = stroke_count-1;
		}
		
		/**
		 * 
		 */
		public function curveTo( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			// check out of render
			z_out = ( z <= 0 );
			
			if ( perspective )
			{
				cx *= zNear/cz;
				cy *= zNear/cz;
				x  *= zNear/z;
				y  *= zNear/z;
			}
			
			// path coordinates
			paths.push( cx + centerX, cy + centerY, cz,
						x + centerX,  y + centerY,  z );
			path_count += 6;
			
			// commands
			commands[cmd_count] = 3; //CURVE_TO
			
			// current shape parameter
			vertex_count++;
			path_z_sum += z;
			if ( z_out ) do_shape_render = false;
			
			// global draw command count
			cmd_count++;
			
			//add flag
			add_shape_task = true;
			current_stroke_index = stroke_count-1;
		}
		
		/**
		 * 
		 */
		public function closePath():void
		{
			// path coordinates
			paths[ path_count ] = _startX;
			path_count++;
			paths[ path_count ] = _startY;
			path_count++;
			paths[ path_count ] = _startZ;
			path_count++;
			
			// commands
			commands[cmd_count] = 2; //LINE_TO
			
			// global draw command count
			cmd_count++;
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 * @internal task
		 */
		public function point( x:Number, y:Number, z:Number, color:uint, alpha:Number ):void
		{
			terminateShapePath();
			
			// check out of render
			z_out = ( z <= 0 );
			
			if ( !z_out )
			{
				if ( perspective )
				{
					x *= zNear/z;
					y *= zNear/z;
				}
				
				//path start index
				path_start_index = path_count;
				
				//command start index
				cmd_start_index  = cmd_count;
				
				// coordinates
				paths[ path_count ] = x + centerX;
				path_count++;
				paths[ path_count ] = y + centerY;
				path_count++;
				
				// commonds
				commands[cmd_count] = 10; //POINT
				
				// TASK -----------------
				shape_task = new RenderTask( TASK_POINT, path_start_index, cmd_start_index, z, 1 );
				shape_task.fillColor = color;
				shape_task.fillAlpha = alpha;
				TASK_DAT[task_count] = shape_task;
				task_count++
				// TASK -----------------
				
				
				// global draw command count
				cmd_count++;
			}
		}
		
		public function pixel( x:Number, y:Number, z:Number, color:uint, alpha:Number ):void
		{
			terminateShapePath();
			
			// check out of render
			z_out = ( z <= 0 );
			
			if ( !z_out )
			{
				if ( perspective )
				{
					x *= zNear/z;
					y *= zNear/z;
				}
				
				//path start index
				path_start_index = path_count;
				
				//command start index
				cmd_start_index  = cmd_count;
				
				// coordinates
				paths[ path_count ] = x + centerX;
				path_count++;
				paths[ path_count ] = y + centerY;
				path_count++;
				
				// commonds
				commands[cmd_count] = 11; //PIXEL
				
				// TASK -----------------
				shape_task = new RenderTask( TASK_PIXEL, path_start_index, cmd_start_index, z, 1 );
				shape_task.fillColor = color;
				shape_task.fillAlpha = alpha;
				TASK_DAT[task_count] = shape_task;
				task_count++
				// TASK -----------------
				
				
				// global draw command count
				cmd_count++;
			}
		}
		
		/**
		 * @internal task
		 */
		public function bitmap( x:Number, y:Number, z:Number, w:Number, h:Number, center:Boolean ):void
		{
			terminateShapePath();
			
			// check out of render
			z_out = ( z <= 0 );
			
			if ( !z_out )
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
				
				//path start index
				path_start_index = path_count;
				
				//command start index
				cmd_start_index  = cmd_count;
				
				// coordinates
				paths.push( x + centerX, y + centerY, w, h );
				path_count += 4;
				
				// draw commond
				commands[cmd_count] = 20; //SPRITE_2D_IMAGE
				
				// TASK -----------------
				shape_task = new RenderTask( TASK_IMAGE, path_start_index, cmd_start_index, z, 1 );
				shape_task.bitmapdata = bitmapdata;
				if ( stroke_do )
				{
					addStrokeTask();
					shape_task.stroke_index = stroke_count-1;
				}
				TASK_DAT[task_count] = shape_task;
				task_count++
				// TASK -----------------
				
				
				// global draw command count
				cmd_count++;
			}
		}
		
		/**
		 * 
		 */
		public function polygonSolid( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number ):void
		{
			terminateShapePath();
			
			// check out of render
			z_out = ( z0 <= 0 || z1 <= 0 || z2 <= 0 );
			
			if ( !z_out )
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
				
				if ( backFaceCulling )
				{
					var v0x:Number = x1 - x0; 
					var v0y:Number = y1 - y0; 
					var v1x:Number = x2 - x0; 
					var v1y:Number = y2 - y0; 
					if ( v0x * v1y - v0y * v1x <= 0 )
						return;
				}
				
				//path start index
				path_start_index = path_count;
				
				//command start index
				cmd_start_index  = cmd_count;
				
				// path coordinates
				paths.push( x0 + centerX, y0 + centerY, z0,
							x1 + centerX, y1 + centerY, z1,
							x2 + centerX, y2 + centerY, z2 );
				path_count += 9;
				
				// draw commond
				commands[cmd_count] = 31; //POLYGON_SOLID
				
				// TASK -----------------
				if ( fill_do )
				{
					switch( current_fill_type )
					{
						case FILL_SOLID:
							shape_task = new RenderTask( TASK_POLYGON_SOLID, path_start_index, cmd_start_index, (z0 + z1 + z2)/3, 1 );
							shape_task.fillColor = fillColor;
							shape_task.fillAlpha = fillAlpha;
							break;
						case FILL_BITMAP:
							shape_task = new RenderBitmapTask( TASK_POLYGON_SOLID, path_start_index, cmd_start_index, (z0 + z1 + z2)/3, 1 );
							RenderBitmapTask(shape_task).setParameters( bitmapdata, fill_matrix, fill_repeat, fill_smooth );
							break;
						case FILL_GRADIENT:
							shape_task = new RenderGradientTask( TASK_POLYGON_SOLID, path_start_index, cmd_start_index, (z0 + z1 + z2)/3, 1 );
							RenderGradientTask(shape_task).setParameters( grad_type, grad_colors, grad_alphas, grad_ratios, fill_matrix,
																		grad_spreadMethod, grad_interpolationMethod, grad_focalPointRation );
							break;
						default:
							shape_task = new RenderTask( TASK_POLYGON_SOLID, path_start_index, cmd_start_index, (z0 + z1 + z2)/3, 1 );
							shape_task.fillColor = fillColor;
							shape_task.fillAlpha = fillAlpha;
							break;
					}
					shape_task.fill_do = true;
				}
				else
				{
					shape_task = new RenderTask( TASK_POLYGON_SOLID, path_start_index, cmd_start_index, (z0 + z1 + z2)/3, 1 );
				}
				if ( stroke_do )
				{
					addStrokeTask();
					shape_task.stroke_index = stroke_count-1;
				}
				TASK_DAT[task_count] = shape_task;
				task_count++
				// TASK -----------------
				
				// global draw command count
				cmd_count++;
			}
		}
		
		/**
		 * @internal task
		 */
		public function polygon( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number,
								 u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			terminateShapePath();
			
			// check out of render
			z_out = ( z0 <= 0 || z1 <= 0 || z2 <= 0 );
			
			if ( !z_out )
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
				
				//path start index
				path_start_index = path_count;
				
				//command start index
				cmd_start_index  = cmd_count;
				
				// path coordinates
				paths.push( x0 + centerX, y0 + centerY, z0,
							x1 + centerX, y1 + centerY, z1,
							x2 + centerX, y2 + centerY, z2 );
				path_count += 9;
				
				// draw commond
				commands[cmd_count] = 30; //POLYGON
				
				// TASK -----------------
				shape_task = new RenderTask( TASK_POLYGON, path_start_index, cmd_start_index, (z0 + z1 + z2)/3, 1 );
				shape_task.bitmapdata = (cross_value>0) ? bitmapdata : bitmapdata_back;
				shape_task.setUV( u0, v0, u1, v1, u2, v2 );
				if ( stroke_do )
				{
					addStrokeTask();
					shape_task.stroke_index = stroke_count-1;
				}
				TASK_DAT[task_count] = shape_task;
				task_count++
				// TASK -----------------
				
				// global draw command count
				cmd_count++;
			}
		}
		
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
			
			var de:int   = _bmpGC.detail;
			var d:Number = 1 / de;
			
			for( var i:int=1; i<=de; i++ )
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
				
				for ( var j:int = 1; j <=de; j++ )
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
			
			if ( bitmapdata )
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
			
			if ( bitmapdata )
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
		
		//--------------------------------------------------------------------------------------------------- RENDER
		
		/**
		 * @private
		 */
		private function render():void
		{
			// add last buffer
			terminateShapePath();
			
			//
			TASK_DAT.sortOn("za", Array.DESCENDING | Array.NUMERIC );
			
			var stk_do:Boolean = true;
			var stk_c:uint     = 0;
			var stk_a:Number   = -1;
			
			var task:RenderTask;
			var path_start:int;
			var cmd_start:int;
			var cmd_num:int;
			var c:int;
			var xi:int;
			var yi:int;
			
			_gc.lineStyle();
			var tmp_stroke_index:uint = 0;
			var stroke_index:uint;
			
			for ( var i:int = 0; i < task_count; i++ )
			{
				task = RenderTask( TASK_DAT[i] );
				path_start = task.path_start;
				xi = path_start;
				yi = xi + 1;
				
				switch( task.kind )
				{
					case TASK_SHAPE:
						cmd_start = task.command_start;
						cmd_num   = task.command_num;
						
						stroke_index = task.stroke_index;
						if ( tmp_stroke_index != stroke_index )
						{
							IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(_gc);
							tmp_stroke_index = stroke_index;
						}
						
						_gc.moveTo( 0, 0 );
						task.applyFill( _gc );
						var cmd:int;
						
						_gc.moveTo( paths[xi], paths[yi]);
						xi += 3;
						yi += 3;
						for ( c=1; c<cmd_num; c++ )
						{
							cmd_start++;
							switch( commands[cmd_start] )
							{
								case 1:
									_gc.moveTo( paths[xi], paths[yi] );
									xi += 3;
									yi += 3;
									break;
								case 2:
									_gc.lineTo( paths[xi], paths[yi] );
									xi += 3;
									yi += 3;
									break;
								case 3:
									_gc.curveTo( paths[xi], paths[yi], paths[xi+3], paths[yi+3] );
									xi += 6;
									yi += 6;
									break;
								default:
									break;
							}
						}
						_gc.endFill();
						break;
						
					case TASK_STROKE:
						cmd_start = task.command_start;
						cmd_num   = task.command_num;
						
						stroke_index = task.stroke_index;
						if ( tmp_stroke_index != stroke_index )
						{
							IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(_gc);
							tmp_stroke_index = stroke_index;
						}
						
						var zi:int = xi + 2;
						var skip:Boolean = false;
						
						if ( paths[zi]>0 )
							_gc.moveTo( paths[xi], paths[yi] );
						else
							skip = true;
						xi += 3;
						yi += 3;
						zi += 3;
						for ( c=1; c<cmd_num; c++ )
						{
							cmd_start++;
							if ( commands[cmd_start] == 2 )
							{
								if (  paths[zi]<=0 )
								{
									skip = true;
								}
								else if ( skip )
								{
									_gc.moveTo( paths[xi], paths[yi] );
									skip = false;
								}
								else
								{
									_gc.lineTo( paths[xi], paths[yi] );
								}
								xi += 3;
								yi += 3;
								zi += 3;
							}
							else
							{
								if (  paths[zi]<=0 || paths[zi+3]<=0  )
								{
									skip = true;
								}
								else if ( skip )
								{
									_gc.moveTo( paths[xi+3], paths[yi+3] );
									skip = false;
								}
								else
								{
									_gc.curveTo( paths[xi], paths[yi], paths[xi+3], paths[yi+3] );
								}
								xi += 6; 
								yi += 6;
								zi += 6;
							}
						}
						break;
						
					case TASK_POLYGON:
						
						stroke_index = task.stroke_index;
						if ( tmp_stroke_index != stroke_index )
						{
							IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(_gc);
							tmp_stroke_index = stroke_index;
						}
						
						_gc.moveTo( 0, 0 );
						_bmpGC.beginBitmap( task.bitmapdata );
						_bmpGC.drawTriangle(
							paths[xi], paths[yi], paths[xi+3], paths[yi+3], paths[xi+6], paths[yi+6],
							task.u0, task.v0, task.u1, task.v1, task.u2, task.v2 );
						break;
						
					case TASK_POLYGON_SOLID:
						
						stroke_index = task.stroke_index;
						if ( tmp_stroke_index != stroke_index )
						{
							IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(_gc);
							tmp_stroke_index = stroke_index;
						}
						
						_gc.moveTo( 0, 0 );
						if( task.fill_do ) task.applyFill( _gc );
						_gc.moveTo( paths[xi], paths[yi] );
						_gc.lineTo( paths[xi+3], paths[yi+3] );
						_gc.lineTo( paths[xi+6], paths[yi+6] );
						_gc.lineTo( paths[xi], paths[yi] );
						_gc.endFill();
						break;
						
					case TASK_IMAGE:
						
						stroke_index = task.stroke_index;
						if ( tmp_stroke_index != stroke_index )
						{
							IStrokeTask( STROKE_TASK[stroke_index] ).setLineStyle(_gc);
							tmp_stroke_index = stroke_index;
						}
						
						_gc.moveTo( 0, 0 );
						_bmpGC.beginBitmap( task.bitmapdata );
						_bmpGC.drawBitmap( paths[xi], paths[yi], paths[xi + 2], paths[yi + 2] );
						break;
						
					case TASK_POINT:
						if ( tmp_stroke_index != 0 )
						{
							_gc.lineStyle();
							tmp_stroke_index = 0;
						}
						_gc.moveTo( 0, 0 );
						task.applyFill( _gc );
						_gc.drawRect( paths[xi], paths[yi], 1, 1 );
						_gc.endFill();
						break;
						
					case TASK_PIXEL:
						pixelbitmap.drawPixel( int(paths[xi]), int(paths[yi]), task.fillColor, int(task.fillAlpha*0xff) );
						break;
							
					default:
						break;
				}
			}
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * 描画対象となる Graphics を示します.
		 */
		public function get graphics():Graphics { return _gc; }
		public function set graphics( gc:Graphics ):void
		{
			_gc = gc;
			_bmpGC.graphics = gc;
		}
		
		/**
		 * BitmapData　を描画する場合の Smoothing を設定します.
		 */
		public function get smooth():Boolean { return _bmpGC.smooth; }
		public function set smooth(value:Boolean):void 
		{
			_bmpGC.smooth = value;
		}
		
		/**
		 * BitmapData を 変形して描画する場合の 分割数 を設定します.
		 */
		public function get detail():uint {	return _bmpGC.detail; }
		public function set detail( value:uint ):void
		{
			_bmpGC.detail = value;
		}		
	}
	
}

//
