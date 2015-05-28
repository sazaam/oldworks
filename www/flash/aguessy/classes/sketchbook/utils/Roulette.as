package sketchbook.utils
{
	/**
	 * 一定の確率で内部に格納した変数の値を返す、変数に関数が渡されていた場合その実行結果を渡す。
	*/
	public class Roulette
	{
		protected var _items:Array	//
		protected var _probs:Array	//
		protected var _probSum:Number
		
		/**
		 * @param items 出力する値、関数を配列形式で
		 * @param probs 値の出現率を配列形式で
		*/
		public function Roulette(items:Array, probs:Array=null)
		{
			_items = items.concat();
			
			if(_probs==null){
				_probs = new Array()
				for(var i:int=0; i<items.length; i++)
					_probs.push(1);
			}else{
				if(items.length != probs.length)
					throw new Error("Roulette.constractor: length of items and probs should be same");
				_probs = probs.concat()	
			}
			
			_probSum = 0
			for(var j:int=0; j<items.length; j++){
				_probSum += _probs[j];
			}
		}
		
		public function get value():*
		{
			return execute()
		}
		
		public function get items():Array
		{
			return _items.concat()
		}
		
		public function get probs():Array
		{
			return _probs.concat()
		}
		
		public function execute():*
		{
			var value:*
			
			var rand:Number = Math.random()*_probSum
	
			var sum:Number = 0
			for(var i:int=0; i<_items.length; i++){
				sum += _probs[i];
				if( rand < sum ){
					var item:Object = _items[i]
					break
				}
			}
			
			if(item){
				if( item is Function ){
					value = item()
				}else{
					value = item
				}
			}
			return value
		}
		
		public function valeuOf():*
		{
			return execute()
		}
	}
}