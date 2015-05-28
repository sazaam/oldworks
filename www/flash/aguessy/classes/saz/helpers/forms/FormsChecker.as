package saz.helpers.forms 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author saz
	 */
	public class FormsChecker 
	{
		public static var DEFAULT_COLOR:uint = 0x0;
		public static var ERROR_COLOR:uint = 0xCC0000;
		public static var EMAIL:String = "email";
		public static var NUM:String = "num";
		public static var ALPHANUM:String = "Alpha_Num";
		public static var ALPHA:String = "alpha";
		public static var MIN:String = "min";
		public static var MAX:String = "max";
		
		public function FormsChecker() 
		{
			
		}
		private static function quickFind(_str:String):Array
		{
			var names:Array = [] ;
			//EMAIL
			//trace("------------------------------------------------------------------------")
			
			if (_str.search(new RegExp(EMAIL))!=-1) names.push(EMAIL) ;
			if (_str.search(new RegExp(NUM)) != -1) names.push(NUM) ;
			if (_str.search(new RegExp(ALPHANUM)) != -1) names.push(ALPHANUM) ;
			if (_str.search(new RegExp(ALPHA)) != -1) names.push(ALPHA) ;
			if (_str.search(new RegExp(/min[0-9]{2}/g)) != -1) {
				//trace("OUAIS MIN.....")
				names.MIN = _str.match(new RegExp(/min[0-9]{2}/g))[0].replace(/min/,"") ;
			}
			if (_str.search(new RegExp(/max[0-9]{2}/g)) != -1) {
				//trace("OUAIS MAX.....")
				names.MAX = _str.match(new RegExp(/max[0-9]{2}/g))[0].replace(/max/, "") ;
			}
			
			//trace("------------------------------------------------------------------------")
			
			
			return names ;
		}
		public static function validate(el:TextField, requiredClassNames:String):Boolean {
			var cond:Boolean ;
			var txt:String = el.text ;
			cond = txt != "" ;
			if (cond) {
				cond = new FormsChecker().validate(el,quickFind(requiredClassNames)) ;
			}
			
			trace(requiredClassNames+" : "+cond)

			return cond ;
		}
		//sazaam@gmail.com
		private function validate(el:TextField,_classNames:Array):Boolean
		{
			var cond:Boolean ;
			for (var i:int = 0, l:int = _classNames.length; i < l ; i++ ) {
				cond = check(el, String(_classNames[i])) ;
				if (cond == false) continue ;
			}
			
			for (var s:String in _classNames)
			{
				switch(s) {
					case "MIN" :
						cond = checkMin(el, int(_classNames[s])) ;
						if (cond == false) return cond ;
					break;
					case "MAX" : 
						cond = checkMax(el, int(_classNames[s])) ;
						if (cond == false) return cond ;
					break;
				}
			}
			return cond ;
		}
		
		private function checkEl(el:TextField,_cond:Boolean):Boolean
		{
			var TF:TextFormat = el.defaultTextFormat ;
			TF.color = _cond ? DEFAULT_COLOR : ERROR_COLOR ;
			el.setTextFormat(TF) ;

			return false ;
		}
		
		private function checkMin(el:TextField,min:int):Boolean
		{
			//trace("MIN : " + min) ;
			//trace("LENGTH : " + el.text.length) ;
			return el.text.length >= min ;
		}
		private function checkMax(el:TextField,max:int):Boolean
		{
			//trace("MAX : " + max) ;
			//trace("LENGTH : " + el.text.length) ;
			//trace(el.text.length <= max) ;
			
			return el.text.length <= max ;
		}

		private function check(el:TextField,_str:String):Boolean
		{
			
			var txt:String = el.text ;
			switch(_str) {
				case FormsChecker.EMAIL :
					return (txt.search(new RegExp(/^[a-z0-9+._-]+@[a-z0-9.-]{2,}[.][a-z]{2,6}$/))!=-1) ;
				break;
				case FormsChecker.ALPHA :
					txt = txt.replace(/[\s\b]/g, "") ;
					el.text = txt;
					return (txt.search(new RegExp("[a-zA-Z]$", 'g'))!=-1) ;
				break;
				case FormsChecker.ALPHANUM :
					txt = txt.replace(/[\s\b]/g, "") ;
					el.text = txt;
					return (txt.search(new RegExp("[a-zA-Z0-9]$", 'g'))!=-1) ;
				break;
				case FormsChecker.NUM :
					txt = txt.replace(/[\s\b]/g, "") ;
					el.text = txt;
					return (!isNaN(Number(txt))) ;
				break;
			}
			
			return true ;
		}
	}
	
}