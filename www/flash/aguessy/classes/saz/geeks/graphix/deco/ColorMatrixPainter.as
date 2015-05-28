package saz.geeks.graphix.deco 
{
	import flash.filters.ColorMatrixFilter;
	
	/*
	* Class written by Xavier MARTIN (xxlm or zeflasher)
	* http://dev.webbymx.net
	* http://www.webbymx.net
	* If you are using this class, I will be glad to receive a postcard of your place :)
	* To do so please visit http://dev.webbymx.net and go in the about page to get my details...
	*/



	public class ColorMatrixPainter {

		/* ****************************************************************************
		* PRIVATE STATIC VARIABLES
		**************************************************************************** */
		//	Adobe luminance
		private static var R_LUM : Number = .3;
		private static var G_LUM : Number = .59;
		private static var B_LUM : Number = .11;
		
		private static var IDENTITY_MATRIX : Array = [1,0,0,0,0,
													  0,1,0,0,0,
													  0,0,1,0,0,
													  0,0,0,1,0];
			
			
		/* ****************************************************************************
		* PUBLIC VARS
		**************************************************************************** */	
			public var matrix : Array;

		/* ****************************************************************************
		* CONSTRUCTOR
		**************************************************************************** */	
		public function ColorMatrixPainter( mat : Array = null) {
			if( mat != null) matrix = mat
			else mat = IDENTITY_MATRIX;
		}
	
		/* ****************************************************************************
		* PUBLIC FUNCTIONS
		**************************************************************************** */
		public function ajustLuminance( rgb : Number ) : void {
			var r:Number = ( ( rgb >> 16 ) & 0xff ) / 255;
			var g:Number = ( ( rgb >> 8  ) & 0xff ) / 255;
			var b:Number = (   rgb         & 0xff ) / 255;
			var l : Number = r * .3 + g * .59 + b * .11;
			
			var mat : Array = new Array (l,l,l,0,0,
										 l,l,l,0,0,
										 l,l,l,0,0,
										 l,l,l,0,0);
										 
			concat( mat );
		}


		public function colorize( rgb : Number, percent : Number ) : void {
			var r:Number = ( ( rgb >> 16 ) & 0xff ) / 255;
			var g:Number = ( ( rgb >> 8  ) & 0xff ) / 255;
			var b:Number = (   rgb         & 0xff ) / 255;
			
			//if ( percent == null) percent = 1;
			var inv_percent : Number = 1 - percent;
			
			
			var mat:Array =  new Array ( inv_percent + percent * r * R_LUM, percent * r * G_LUM,  percent * r * B_LUM, 0, 0,
										 percent * g * R_LUM, inv_percent + percent * g * G_LUM, percent * g * B_LUM, 0, 0,
										 percent * b * R_LUM,percent * b * G_LUM, inv_percent + percent * b * B_LUM, 0, 0,
										 0 , 0 , 0 , 1, 0 );
			concat( mat );
		}


		/**
		* Multiply the matrix to get the final result
		* @param	mat
		*/
		public function concat( mat : Array) : void {
			
			var mat_res : Array = new Array ();
			var i:Number = 0;
			
			for ( var r : Number = 0; r < 4; ++r ) {
				for ( var c : Number = 0; c < 5; ++c ) {
					mat_res[ i + c ] =	mat[   i   ] * matrix[   c    ] + 
										mat[ i + 1 ] * matrix[ c + 5  ] + 
										mat[ i + 2 ] * matrix[ c + 10 ] + 
										mat[ i + 3 ] * matrix[ c + 15 ] +
										( c == 4 ? mat[ i + 4 ] : 0 );
				}
			//	go to next row
				i += 5;
			}
			matrix = mat_res;
		}

		
		/**
		* Convert the ColorMatrix to Grayscale
		* @param	Void
		*/
		public function convertToGray () : void {
			matrix = [	.33 / R_LUM / 2, .33 / G_LUM / 2, .33 / B_LUM / 2, 0, 0,
						.33 / R_LUM / 2, .33 / G_LUM / 2, .33 / B_LUM / 2, 0, 0,
						.33 / R_LUM / 2, .33 / G_LUM / 2, .33 / B_LUM / 2, 0, 0,
						  0,   0,   0, 1, 0		];
		}
		

		public function getFilter() : ColorMatrixFilter {
			return new ColorMatrixFilter( matrix );
		}
		
	
		public function paint( rgb : Number, percent:Number) : void {
			var r : Number = ( ( rgb >> 16 ) & 0xff ) > 0 ? ( ( rgb >> 16 ) & 0xff ) / 255 : 33 / 255;
			var g : Number = ( ( rgb >> 8  ) & 0xff ) > 0 ? ( ( rgb >> 8 ) & 0xff ) / 255 : 33 / 255;
			var b : Number = (   rgb         & 0xff ) > 0 ? ( ( rgb  ) & 0xff ) / 255 : 33 / 255;
			var lu : Number = (r * .3 + g * .59 + b * .11);
		
		//	convert the image to grayscale
			convertToGray();
			
		//	Add the color
			//if ( percent == -1) percent = 1;
			var inv_percent : Number = 1 - percent;
			
			var rr : Number = inv_percent + ( percent * r * R_LUM );
			var rg : Number = ( percent * r * G_LUM );
			var rb : Number = ( percent * r * B_LUM );
			var ra : Number = 0;
			var ro : Number = lu;
			var gr : Number = ( percent * g * R_LUM );
			var gg : Number = ( inv_percent + percent * g * G_LUM );
			var gb : Number = ( percent * g * B_LUM );
			var ga : Number = 0;
			var go : Number = lu;
			var br : Number = ( percent * b * R_LUM );
			var bg : Number = ( percent * b * G_LUM );
			var bb : Number = ( inv_percent + percent * b * B_LUM );
			var ba : Number = 0;
			var bo : Number = lu;
			var ar : Number = 0;
			var ag : Number = 0;
			var ab : Number = 0;
			var aa : Number = 1;
			var ao : Number = 0;
			
			var mat:Array =  new Array (rr, rg, rb, ra, ro,
										gr, gg, gb, ga, go,
										br, bg, bb, ba, bo,
										ar, ag, ab, aa, ao);
			concat( mat );		
		}

	}
}