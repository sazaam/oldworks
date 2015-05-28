﻿// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
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

package frocessing.text 
{
	import flash.utils.ByteArray;
	
	/**
	* Font のユーティリティ
	* @author nutsu
	* @version 0.2
	*/
	public class FontUtil 
	{
		
		/**
		 * Five3Dのフォントデータを、FFont用の ByteArray に変換します.
		 * <p>five3d 2.0.1 typography</p>
		 * @param	dat
		 */
		public static function convertFive3DTypo( dat:Object ):ByteArray
		{
			if ( dat.__initialized == false )
				dat.initialize();
			
			var i:int;
			var m:int;
			
			var version_ma:int = 2;
			var version_mi:int = 0;
			var version_pa:int = 1;
			
			var widthDat:Object = dat.__widths;
			var motifDat:Object = dat.__motifs;
			var height:Number   = ( dat.__height ) ? dat.__height : dat.__heights;
			var size:Number     = 100;
			
			//ascent and descent ?
			var ascent:Number  = 100 / height;
			var descent:Number = (height - 100) / height;
			
			//char count
			var charCount:int = 0;
			
			//include chars
			var chars:Array   = [];
			
			//char codes
			var codes:Array   = [];
			
			//char layout width
			var width:Array   = [];
			
			for ( var char:String in widthDat )
			{
				chars.push( char );
				codes.push( char.charCodeAt(0) );
				width.push( widthDat[char] );
				charCount ++;
			}
			
			//draw commond(byte) length of char
			var cmdcount:Array  = [];
			
			//draw path coordinates(float) length of char
			var pathcount:Array = [];
			
			var pathDat:ByteArray = new ByteArray();
			for ( i = 0; i < charCount ; i++ )
			{
				var motif:Array = motifDat[ chars[i] ];
				var coordinates:Array = [];
				var count:int = 0;
				for ( m = 0; m < motif.length; m++ )
				{
					var command:String = motif[m][0];
					coordinates.push.apply( null, motif[m][1] );
					count ++;
					switch( command )
					{
						case "M": pathDat.writeByte( 1 ); break;
						case "L": pathDat.writeByte( 2 ); break;
						case "C": pathDat.writeByte( 3 ); break;
						default:  pathDat.writeByte( 0 ); break;
					}
				}
				
				for ( m = 0; m < coordinates.length; m++ )
				{
					pathDat.writeFloat( coordinates[m] );
				}
				
				cmdcount[i]  = count;
				pathcount[i] = coordinates.length;
			}
			pathDat.position = 0;
			
			//WRITE BYTE ARRAY ------------------------------
			var _dat:ByteArray = new ByteArray();
			
			//count
			_dat.writeInt( charCount );
			
			//version
			_dat.writeInt( version_ma << 18 | version_mi << 8 | version_pa );
			
			//size
			_dat.writeInt( size );
			_dat.writeInt( height );
			
			//ascent, descent
			_dat.writeFloat( ascent );
			_dat.writeFloat( descent );
			
			for ( i = 0; i < charCount ; i++ )
			{
				//char code
				_dat.writeInt( codes[i] );
				//width
				_dat.writeInt( width[i] );
				//command count
				_dat.writeInt( cmdcount[i] );
				//coordinates count
				_dat.writeInt( pathcount[i] );
			}
			
			_dat.writeBytes( pathDat, 0, pathDat.length );
			
			_dat.position = 0;
			
			return _dat;
		}
		
	}
	
}