/**
* ...
* @author Default
* @version 0.1
*/
package geeks.fx
{

	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.DataEvent;
	import flash.text.Font;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.geom.Matrix;
	
	public class Typographeur extends Sprite{
		
		//pixel, text, box, dot, string
		public static const PIXEL:String = "pixel" ;
		public static const TEXT:String = "text" ;
		public static const BOX:String = "dot" ;
		public static const DOT:String = "box" ;
		public static const STRING:String = "string" ;
		//of course un gros malin l'avait déja fait :
		//donc au debut je me servais d'une string et d'un CharAt() (comme eux)
		//http://livedocs.adobe.com/flash/9.0_fr/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts_bak&file=00000086.html
		// voila sa palette
		//public var valeurs:String = "@#$%&8BMW*mwqpdbkhaoQ0OZXYUJCLtfjzxnuvcr[]{}1()|/?Il!i><+_~-;,.";
		
		// puis j'ai opte pour un tableau d'index
		//et c'est vachement mieux:
		public var valeurs:Array = [0,160,46,180,183,96,175,168,58,95,44,39,126,184,94,172,215,92,47,173,166,45,176,59,185,124,61,43,62,60,247,186,179,34,33,161,178,170,164,305,177,105,187,171,236,237,63,114,191,118,299,116,239,238,40,41,297,35,383,301,341,115,106,303,42,125,108,123,49,343,122,121,320,99,355,345,322,357,73,102,314,309,347,120,74,55,380,267,253,101,316,304,378,263,353,349,205,204,318,351,188,111,248,255,91,93,97,51,302,53,375,382,76,207,189,279,265,231,206,298,233,232,117,296,84,190,162,308,300,243,110,321,242,52,281,235,224,225,54,234,283,313,57,70,275,163,246,354,359,261,249,250,90,244,48,315,50,277,333,226,229,324,312,337,245,371,257,335,252,119,227,181,317,251,326,367,319,259,356,379,363,67,89,240,107,328,361,377,86,369,98,113,365,69,80,241,83,65,112,266,104,169,381,100,85,262,167,221,36,278,373,165,201,273,311,56,200,376,346,103,193,37,268,264,222,192,374,199,280,203,217,339,218,260,282,230,202,196,197,223,329,352,348,274,289,194,293,350,271,220,256,370,276,71,195,366,219,358,362,258,291,254,360,368,79,364,307,88,331,285,288,174,109,198,287,82,182,210,211,66,78,284,75,295,290,214,216,286,72,212,332,68,306,340,213,336,334,323,342,272,208,325,310,344,81,327,38,209,292,270,64,338,87,330,372,294,77,269,228] ;
		
		public var type:String = 'text' ;// différentes valeurs pour le rendu : pixel, text, box, dot, string
		
		public var fontName:String ;		// spécifie la typo utilisée
		public var monochrome:Boolean = false ;		// savoir si on colore les lettres
		public var couleur:uint = 0xFFFFFF ;			//couleur de la typo 
		public var background:uint = 0x000000 ;		//couleur de l'arrière plan
		
		public var outPutString:String ;
		
		
		private var matrix:Matrix ;
		public var scaleSource:Number ;
		public var scaleDestination:Number ;
		
		public var fontMini:Number = 1 ;
		public var fontMaxi:Number = 10 ;
		public var threshold:Number = 256 ;
		
		public var source:BitmapData ;
		public var bmp:Bitmap ;
		private var destination:BitmapData ;
		
		private var request:URLRequest ;
		public var loader:Loader ;
		
		public var progres:int = 0 ;
		
		public function Typographeur(_fontName:String,_str:String = null) 
		{
			fontName = _fontName ;
			//convertit les valeurs Numeriques en graphemes
			var t:Array = [] ;
			var i:int  = 0 ;
			if(_str!= null) {
				while ( ++i < _str.length ) {
					t.push( _str.charAt( i ) ) ;
					//trace(_str.charAt( i ))
				}
				valeurs = t ;
			}else {
				while( ++i < valeurs.length )t.push( String.fromCharCode( valeurs[ i ] ) ) ;
				valeurs = t ;
			}
		}
	  
		public function fromFile( 	url:String,
									scaleSource:Number=1, 
									scaleDestination:Number=1, 
									fontMini:Number = 0, 
									fontMaxi:Number = 0
									):void
		{
			this.scaleSource = scaleSource ;
			this.scaleDestination = scaleDestination ;
			this.fontMini = fontMini ;
			this.fontMaxi = fontMaxi ;
			request = new URLRequest( url ) ;
			loader = new Loader() ;
			loader.load( request )//, new LoaderContext( true ) );
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler) ; 
			
		}
		
		public function completeHandler( e:Event ):void
		{
			e.target.removeEventListener(Event.COMPLETE, arguments.callee) ;
			if (hasEventListener(DataEvent.UPLOAD_COMPLETE_DATA)) {
				var dE:DataEvent = new DataEvent(DataEvent.UPLOAD_COMPLETE_DATA) ;
				//dE.data = e.target.content.bitmapData ;
				dispatchEvent(dE) ;
			}else {
				prepare( e.target.content.bitmapData ) ;
				process() ;
			}
		}
			
		public function fromBitmap( bmpd:BitmapData, 
									scaleSource:Number=1, 
									scaleDestination:Number=1, 
									fontMini:Number = 0, 
									fontMaxi:Number = 0,
									refresh:Boolean = false
									):void
		{
			this.scaleSource = scaleSource ;
			this.scaleDestination = scaleDestination ;
			this.fontMini = fontMini ;
			this.fontMaxi = fontMaxi ;
			if( !source || refresh ) prepare( bmpd ) ; 
		}
		
		
		/*
		 * crée la source du motif
		 * @param	bmpd:	un bitmapData
		 */
		public function prepare( bmpd:BitmapData ):void
		{
			if( source )source.dispose() ;
			var w:int = bmpd.width ;
			var h:int = bmpd.height ;
			matrix = new Matrix() ;
			matrix.scale( scaleSource, scaleSource ) ;
			source = new BitmapData( int( w * matrix.a ), int( h * matrix.d ), false, 0x000000) ;
			source.draw( bmpd, matrix ) ;			
			matrix.scale( scaleDestination, scaleDestination ) ;
			if ( destination ) destination.dispose() ;
			destination = new BitmapData( source.width * matrix.a, source.height * matrix.d, false, background ) ;
			bmp = new Bitmap( destination, "auto", true ) ;
			this.addChild( bmp ) ;
		}
		public function process():void
		{
			if( !source ) return ;
			
			destination.fillRect( destination.rect, background );
			var col:int = 0 ;
			var val:Number = 0 ;
			var char:String = new String() ;
			var tf:TextFormat = new TextFormat() ;
			var sp:Sprite = new Sprite() ;
			outPutString = new String() ;
			var w:int = fontMaxi ;
			var h:int = fontMaxi ;
			//spritede dessin
			var elements:Sprite = new Sprite() ;
			this.addChild( elements ) ;
			var x:int = source.width ;
			while( x-- )
			{
				var y:int = source.height ;
				while( y-- )
				{
					col = source.getPixel( x, y ) ;
					//rapporte la valeur du pixel sur 1
					val =( 	( col >>> 16  & 0xFF )/( threshold + 1 ) + 
							( col >>> 8   & 0xFF )/( threshold + 1 ) + 
							( col 		  & 0xFF )/( threshold + 1 ) ) / 3 ; 
					char = valeurs[ int( val * valeurs.length ) ]//String.fromCharCode( valeurs[ int( val * valeurs.length ) ] );
					switch( type ) 
					{
						//dessine le pixel
						case 'pixel':
							destination.setPixel( x * matrix.a, y * matrix.d, col ) ;
						break;
						//carrés
						case 'box':		
							sp.graphics.beginFill( col ) ;
							sp.graphics.drawRect( x * matrix.a, y * matrix.d, (fontMini + w) * val, (fontMini + h) * val ) ;
							elements.addChild( sp ) ;
						break;
						//cercles
						case 'dot':
							sp.graphics.beginFill( col ) ;
							sp.graphics.drawCircle( ( x * matrix.a ) + (fontMini + fontMaxi) / 2, (y * matrix.d) + (fontMini + fontMaxi) / 2, ( ( fontMini + fontMaxi ) * val  ) + 1 ) ;
							elements.addChild( sp ) ;
						break;
						//texte
						case 'text':
							var txt:TextField = new TextField() ;
							//choisit le caractère correspondant à val dan le tableau de caractères
							txt.text	= char ;
							//txt.embedFonts = true ;
							txt.x 	= x * matrix.a  - ( val * fontMaxi )/2 ;
							txt.y 	= y * matrix.d 	- ( val * fontMaxi )/2 ;
							//assigne la couleur
							tf.color = ( monochrome ) ? couleur : col ;
							//et la taillle
							tf.size = fontMini + val * fontMaxi ;
							//et la typo
							tf.font = fontName ;
							txt.setTextFormat( tf ) ;
							elements.addChild( txt ) ;
						break;
					}
					outPutString += char ;
				}	
				destination.draw( elements ) ;//, null, null, 'add' ); // marche pour des images sombres :)
				while( elements.numChildren > 0) elements.removeChildAt(0) ; 
			}
			removeChild( elements ) ;
			if(hasEventListener(DataEvent.DATA)) dispatchEvent(new DataEvent(DataEvent.DATA)) ;
		}
		
		public function flipValues():void
		{
			valeurs.reverse() ;
			/*
			 * c'était quand j'utilisais une String et un CharAt(i), ça inverse une String 
			*/
			/*
			var New:String = new String();
			var i:int = valeurs.length;
			while( i-- ) New +=	valeurs.charAt( i );
			valeurs = New;
			*/
		}
	}
}
