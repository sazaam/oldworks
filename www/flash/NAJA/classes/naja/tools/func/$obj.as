package naja.tools.func 
{
	import boa.core.x.def.Method;
	import boa.core.x.Type;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.describeType;
	
	
	dynamic class $obj extends Proxy {
		private var o:* ;
		private var voidMethods:Object ;
		private var props:Object ;
		private var t:Type;
		
		public function $obj(_o:*)
		{
			o = _o ;
			t = new Type(o) ;
			var c:String = t.declaringClass;
			if (c == null) throw new Error("failed to get class") ;
			voidMethods = {} ;
			var m:Array = t.methods ;
			for (var i:int = 0 ; i < m.length ; i++ ) {
				var meth:Method = Method(m[i]) ;
				if (meth.returnType == "void") {
					voidMethods[meth.name] = 1 ;
				}
			}			
		}
		flash_proxy override function callProperty(name:*, ... rest):*
		{
			if (voidMethods[name]) {
				o[name].apply(o, rest) ;
				return this ;
			}else return o[name].apply(o, rest) ;
		}
		flash_proxy override function getProperty(name:*):*
		{
			if (!o.hasOwnProperty(name)) {
				if (t.hasOwnProperty(name)) return t[name] ;
				else {
					throw(new Error("Neither class "+t.declaringClass+" nor class Type has such property...")) ;
				}
			}else return new $obj(o[name]) ;
		}
		public function obj(f:Function = null, ...rest:Array):* {
			if(Boolean(f)) $.apply(this, [f].concat(rest)) ;
			return o ;
		}
		public function $(f:Function, ...rest:Array):$obj {
			f.apply(o, rest) ;
			return this ;
		}
		public function toString():String {
			return ("[$obj >> " + t.declaringClass + " > " + o + "]") ;
		}
		public function getMethod(name:String):Method {
				var meth:Method = t.methods.filter(function(el, i, arr) { return (el.name == name) } )[0] ;
				if (!Boolean(meth)) throw(new ArgumentError("Must inform an existing " + t.declaringClass + " method")) ;
				else return meth ;
		}
	}
}