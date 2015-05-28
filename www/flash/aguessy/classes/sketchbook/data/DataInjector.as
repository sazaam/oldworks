package sketchbook.data
{
	import flash.utils.Dictionary;
	
	
	/**
	 * XMLからデータを作り出し、オブジェクトのプロパティを注入するクラス。
	 * <p>XMLによって注入するプロパティのグループを定義することで、
	 * コード内の全てのパブリックな、String, Number, Boolean肩の変数を外出しすることができます。</p>
	 * <p>将来的にはObjectやArray、Date型、クラス参照等も注入可能にする予定</p>
	 * 
	 * <objects>
	 * 	<object name="idname">
	 *    <property name="val1">1e</property>
	 *    <property name="val2">test</property>
	 * 	<object>
	 * <objects>
	 * nameをidとします。
	 */
	public class DataInjector
	{
		private static const IS_OCTAL:RegExp = /^0[0-7]+$/i
		private static const IS_NUMBER:RegExp = /^-?(([0-9]+[.]?[0-9]*)|(.[0-9]+))$/
		private static const IS_BOOLEAN:RegExp = /^((true)|(false))$/i
		private static const IS_HEX:RegExp = /^0x[0-9a-f]+$/i
		
		
		private var xml:XML
		private var dataCache:Dictionary
		private static var instance:DataInjector
		
		/**
		 * This class should be used as a Singleton
		 */
		public function DataInjector():void
		{
			dataCache = new Dictionary()
		}
		
		/**
		 * DataInjectorクラスのインスタンス(シングルトン)を取得します。
		 * 
		 * @return DataInjectorインスタンス。
		 */
		public static function getInstance():DataInjector
		{
			if(instance==null)
				instance = new DataInjector()
			return instance
		}
		
		/**
		 * オブジェクトに注入するデータを定義したXMLを渡します。
		 * 
		 * @param config 注入情報を記述したXML
		 */
		public function init(config:XML):void
		{
			this.xml = config
		}
		
		/** 
		 * XMLの該当するname以下の定義を対象のオブジェクトに注入します。 
		 * 
		 * @param target オブジェクトを注入する対象のインスタンス
		 * @return id 引数で渡したオブジェクト
		 */
		public function injectProp(target:Object, id:String):Object
		{
			var xmlList:XMLList = xml.object.(@name==id)	// id名のXMLノードを切り出す
			var props:XMLList = xmlList.property
			
			var infoObj:Object
			
			if(dataCache[id]==undefined){
				infoObj = {}
				for each( var x:XML in props)
				{
					var propName:String = x.attribute("name")
					var value:String = x.text()
				
					if( isOctal(value)){
						infoObj[propName] = Number(value);
					}else if( isNumber(value) ){
						infoObj[propName] = Number(value);
					}else if( isHex(value) ){
						infoObj[propName] = Number(value);
					}else if( isBoolean(value) ){
						infoObj[propName] = (value.toUpperCase()=="TRUE")? true : false;
					}else{
						infoObj[propName] = value;
					}
				}
				
				dataCache[id] = infoObj
			}else{
				infoObj = dataCache[id]
			}
			
			for (var prop:String in infoObj)
				target[prop] = infoObj[prop]
				
			return target
		}
		
		
		/*
		-----------------------------------------------------------
		internal use only
		-----------------------------------------------------------
		*/
		private function isNumber(str:String):Boolean
		{
			return IS_NUMBER.test(str)
		}
		
		private function isBoolean(str:String):Boolean
		{
			return IS_BOOLEAN.test(str)
		}
		
		private function isHex(str:String):Boolean
		{
			return IS_HEX.test(str)
		}
		
		private function isOctal(str:String):Boolean
		{
			return IS_OCTAL.test(str)
		}
	}
}