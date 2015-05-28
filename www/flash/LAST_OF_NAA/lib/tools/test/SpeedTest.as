package tools.test 
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SpeedTest 
	{
		public static function compare(...rest:Array):Object 
		{
			var l:int = rest.length ;
			var str:String = "" ;
			for (var i:int  = 0 ; i < l ; i++ )
			str += test(rest[i]).toString() + "\n" ;
			return { toString:function():String { return  str }} ;
		}
		static public function test(f:Function):Object
		{
			var time:Number = getTimer() ;
			f() ;
			var gt:Number = getTimer() - time ;
			return { toString:function():String { return dump({ellapsed : gt },"Function Tested... >>")}}
		}
		static public function dump(o:Object,str:String = ""):String
		{
			for (var i:String in o) 
				str += "\n     >>>     " + i + " >> " + o[i] ;
			return str ;
		}
	}
}