package sketchbook.utils
{
	import flash.utils.Dictionary;
	
	
	/**
	 * 音に関する定数とかいえれておこうかと思う
	 * 
	 * Aの音が440Hzこれが基準。
	 */
	public class NoteUtil
	{
		
		
		//ユニゾン
		public static const PERFECT_1ST : Number = 1;
		
		//短2度 
		//二つの音の間に半音が1つ
		public static const MINOR_2ND : Number = 1.0595;
		
		//長2度 
		//二つの音の間に半音が２つ
		public static const MAJOR_2ND : Number = 1.1225;
		
		//短3度
		//二つの音の間に半音が3つ
		public static const MINOR_3RD : Number = 1.1892;
		
		//長3度
		//二つの音の間に半音が4つ
		public static const MAJOR_3RD : Number = 1.2599;
		
		//完全4度
		//二つの音の間に半音が5つ
		public static const PERFECT_4TH : Number = 1.3348;
		
		//増4度(減5度)
		//二つの音の間に半音が6つ
		public static const ARGUMENTED_4TH : Number = 1.4142;
		public static const DIMINISHED_5TH : Number = 1.4142;
		
		//完全5度
		//二つの音の間に半音が7つ
		public static const PERFECT_5TH : Number = 1.4983;
		
		//増5度(短6度)
		//二つの音の間に半音が8つ
		public static const ARGUMENTED_5TH : Number = 1.5874;
		public static const MINOR_6TH : Number = 1.5874;
		
		//長6度
		//二つの音の間に半音が9つ
		public static const MAJOR_6TH : Number = 1.6818;
		
		//減7度
		//二つの音の間に半音が10個
		//public static const MINOR_6TH : Number = 1.7818;
		
		//長7度
		//二つの音の間に半音が11個
		public static const MAJOR_7TH : Number = 1.8877;
		
		//オクターブ
		//二つの音の間に半音が12個
		public static const PERFECT_8TH : Number = 2;
		
		
		
		private static const _INITIALIZED : Boolean = false;
		private static const _NOTE_TABLE : Dictionary = new Dictionary();
		private static const BAIRITSU_TABLE:Array = [
			1,
			2 * Math.pow(2, 1/12),
			2 * Math.pow(2, 2/12),
			2 * Math.pow(2, 3/12),
			2 * Math.pow(2, 4/12),
			2 * Math.pow(2, 5/12),
			2 * Math.pow(2, 6/12),
			2 * Math.pow(2, 7/12),
			2 * Math.pow(2, 8/12),
			2 * Math.pow(2, 9/12),
			2 * Math.pow(2, 10/12),
			2 * Math.pow(2, 11/12),
			2
		];
		
		
		//---------------------------------------------------------------
		
		/**
		 * 周波数を指定した指定半音移動した周波数を返す
		 * 
		 * @param 周波数
		 * @val 半音の数 0 でそのまま
		 */
		public static function pitchBend(hz:Number, val:Number):Number
		{
			
			
			return hz * ( Math.pow(2, val/12));
		}
		
		
		
		
		/**
		 * 音符とオクターブから音の周波数を返す
		 * 
		 * A4が440ヘルツ
		 * 
		 */
		public static function noteToHz(note:String="c", octave:Number=4):Number
		{
			var index:int = noteToIndex(note, octave);
			var aindex:int = index - 69;	// A4を0とした周波数用に変換
			
			return 440 * Math.pow(2, aindex/12);
		}
		
		
		
		/**
		* 音符を C4 を 60としたMIDI準拠のインデックス番号に変換する。
		* 
		* @param note 音符
		* @param octave 音階
		* @returns C4 を 60としたインデックス番号
		*/
		public static function noteToIndex(note:String="c", octave:int=4):int
		{
			initNoteTable();
			
			var val:int = 0;
			var tokens:Array = note.split("");
			var imax:Number = tokens.length;
			
			for(var i:int=0; i<imax; i++)
			{
				val += _NOTE_TABLE[tokens[i]];
			}
			
			val += 12 * (octave + 1)
			
			return val;
		}
		 
		
		
		private static function initNoteTable():void
		{
			if(_INITIALIZED) return;
			
			//文字を半音に置き換えるテーブル
			_NOTE_TABLE["c"] = 0;
			_NOTE_TABLE["d"] = 2;
			_NOTE_TABLE["e"] = 4;
			_NOTE_TABLE["f"] = 5;
			_NOTE_TABLE["g"] = 7;
			_NOTE_TABLE["a"] = 9;
			_NOTE_TABLE["b"] = 11;
			_NOTE_TABLE["+"] = 1;
			_NOTE_TABLE["-"] = -1;
		}
		 
		 
	}
}