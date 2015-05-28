package saz.helpers.xmls 
{
	/**
	 * ...
	 * @author saz
	 */
	public class E4XParser
	{
		
		
		private var _recursive:Boolean;
		private var _complexPushes:Boolean;
		private var _source:XML;
		private var _outPut:XML;
		private var _outPutList:XMLList;
		
		
		public function E4XParser(_xml:XML = null) 
		{
			_source = _xml;
			_outPut = XMLOperator.cloneEmpty(_source);
			_outPutList = new XMLList();
		}
		
		public function search(_nodeName:String,_attr:String = null):XMLList
		{
			var xml = _source;
			_outPutList = recursive ? xml.descendants(_nodeName) : xml.child(_nodeName);
			if (_attr) _outPutList = _outPutList.(hasOwnProperty("@" + _attr));
			_outPut.appendChild(_outPutList);
			return _outPutList;
		}
				//GETTER & SETTER
		public function get recursive():Boolean { return _recursive; }
		public function set recursive(value:Boolean):void {	_recursive = value;	}
		public function get complexPushes():Boolean { return _complexPushes; }
		public function set complexPushes(value:Boolean):void {	_complexPushes = value;	}
		public function get source():XML{ return _source; }
		public function set source(value:XML):void { _source = value; }
		public function get outPutList():XMLList { return _outPutList; }
		public function get outPut():XML { return _outPut; }
	}
	
}