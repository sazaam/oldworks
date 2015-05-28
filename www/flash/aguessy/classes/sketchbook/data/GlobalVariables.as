package sketchbook.data
{
	import flash.utils.Dictionary;
	
	/**
	 * as2における _global を表現したクラスです。
	 **/
	public class GlobalVariables
	{
		private var dataDictionary:Dictionary
		private var finalDictionary:Dictionary	
		private static var _instance:GlobalVariables
		
		public function GlobalVariables()
		{
			dataDictionary = new Dictionary()
			finalDictionary = new Dictionary()
		}
		
		
		/**
		 * GlobalVariablesインスタンスを返します。 
		 * 
		 * @return インスタンス。
		 */
		public static function getInstance():GlobalVariables
		{
			if(_instance==null)
				_instance = new GlobalVariables()
			return _instance
		}
		
		
		/**
		 * 指定IDで登録されたデータを取り出します。
		 * 
		 * @param id 登録時に使ったID
		 * 
		 * @return IDと対応するオブジェクト
		 */
		public function getData(id:String):*
		{
			return dataDictionary[id]
		}
		
		
		/**
		 * idをキーにオブジェクトを登録します。
		 * <br/>すでに存在するIDに値を登録する場合、前の値は上書きされます。
		 * 
		 * @param id 登録につかうID
		 * @param value 登録したい値
		 * @param isFinal 上書きをできなくするかどうかのフラグ
		 */
		public function setData(id:String, value:*, isFinal:Boolean=false):void
		{
			if( dataDictionary[id] == value ) return
			
			if(isFinal==true){
				if(finalDictionary[id]==undefined){
					dataDictionary[id] = value
					finalDictionary[id] = true
				}else{
					throw new Error("GlobalVariables.setData"+ id + " is already used as final")
				}
			}else{
				dataDictionary[id] = value
			}
		}
		
		
		/**
		 * 配列で指定したidのデータを内包したオブジェクトを返します。
		 * <p>この関数は特定のデータを切り出してSharedObjectに保存したり、サーバーに送るときなどに有効です。</p>
		 * 
		 * @param dataNames 取得したデータと対応するidの配列
		 * 
		 * @return 指定したidと対応するデータを格納したオブジェクト
		 */
		public function getDatas(dataNames:Array):Object
		{
			var result:Object
			
			for(var i:int=0; i<dataNames.length; i++)
			{
				var id:String = dataNames[i];
				result[id] = getData(id);
			}
			
			return result
		}
		
		
		/**
		 * オブジェクトのプロパティ名をidに全てのデータを登録します。
		 * 
		 * @param dataObj 登録したいデータをid名のプロパティに格納したオブジェクト
		 */
		public function setDatas(dataObj:Object):void
		{
			for(var prop:String in dataObj)
			{
				setData(prop, dataObj[prop]);
			}
		}
	}
}