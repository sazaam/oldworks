package org.libspark.aocontainer.sample1
{
    public class HogeImpl implements Hoge
    {
        private var _fuga:Fuga;
        
        public function get fuga():Fuga
        {
            return _fuga;
        }
        
        public function set fuga(value:Fuga):void
        {
            _fuga = value;
        }
        
        public function process():void
        {
            _fuga.execute();
        }
        
    }
}