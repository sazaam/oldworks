package of.app.required.data
{
	import flash.utils.Dictionary;
	
	/**
	 * The Gates class is part of the Naja Data API.
	 * 
	 * @see	of.app.required.data.lists.Compare
	 * @see	boa.core.x.base.Foundation
	 * 
     * @version 1.0.0
	 */
	
	dynamic public class Gates extends Dictionary
	{
		//////////////////////////////////////////////////////// VARS
		private var __numeric:Array
		private var __keys:Array
		private var __references:Dictionary;
		//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs a Gates object.
		 */
		public function Gates() 
		{
			__numeric = [] ;
			__keys = [] ;
			__references = new Dictionary() ;
		}
		///////////////////////////////////////////////////////////////////////// DUMP
		public function dump():String 
		{
			var s:String = '' ;
			var a:Array = merged ;
			var l:int = a.length ;
			for (var i:int = 0 ; i < l ; i++ ) {
				var el:* = merged[i] ;
				var key:String = getKeyReference(el) ; 
				s += ' \n	';
				s += 'key :' + key + ' >> ' + ' object : ' + String(el) ;
			}
			return  s ;
		}
		///////////////////////////////////////////////////////////////////////// ADD
		/**
		 * Adds a value to this Gates object.
		 * 
		 * @param ...o *
		 * @return 
		 */
		public function add(...o:*):*
		{
			if (o.length <1)  throw(new ArgumentError("added Object is null..."))
			else if (o.length == 1) {
				return register(Object(o[0])) ;
			}else if(o.length == 2){
				return register(o[0], o[1]) ;
			}else {
				trace("trying to push...") ;
			}
		}
		///////////////////////////////////////////////////////////////////////// REGISTER
		/**
		 * Does the register work for a new Item/value to stock in this Gates object.
		 * 
		 * @param o Object - The value to stock
		 * @param ref * - The reference to stock the value with
		 */
		internal function register(o:Object, ref:* = null):*
		{
			if (ref == null) {
				//	numerical entry
				__numeric.push(o) ;
				 return register(o, __numeric.length - 1) ;
			}else if (ref is String) {
				//	String reference entry
				this[ref] = o ;
				__references[o] = o ;
				__keys.push(o) ;
			}else if (ref is int) {
				//	int reference entry
				this[ref] = o ;
				__references[o] = o ;
			}else {
				//	Object reference entry
				this[ref] = o ;
				__references[ref] = o ;
				__keys.push(o) ;
			}
			return o
		}
		///////////////////////////////////////////////////////////////////////// REMOVE
		/**
		 * Removes a value from this Gates object. Will try first to remove the Object stocked with the passed reference,
		 * then (if unfound) will try to erase the Object passed as reference.
		 * If no reference is passed, will erase the last entry of this Gates object.
		 * 
		 * @param	ref * - A reference for the Object/value to remove. 
		 * @return the removed value
		 */
		public function remove(ref:* = null):*
		{
			if (ref == null) {
				return __numeric.pop() ;
			}
			else {
				var o:Object ;
				
				if(Boolean(this[ref])) 
				{
					o = getElement(ref) ;
					clean(this, o, ref) ;
				}else
				{
					if(Boolean(__references[ref])) 
					{
						o = getElement(ref) ;
						clean(__references, o, ref) ;
						clean(this,o,$ref(this,ref)) ;
					}
				}
				if (__keys.indexOf(o)!=-1) erase(__keys, __keys.indexOf(o)) ;
				if (ref is int) erase (__numeric, ref) ;
				if (__numeric.indexOf(ref) != -1) erase(__numeric, __numeric.indexOf(ref)) ;
				return o ;
			}
		}
		public function getElement(ref:* = null):*
		{
			if (ref == null) {
				return __numeric[__numeric.length -1] ;
			}
			else {
				var o:Object ;
				
				if(Boolean(this[ref])) 
				{
					o = this[ref] ;
				}else
				{
					if(Boolean(__references[ref])) 
					{
						o = __references[ref] ;
					}
				}
				return o ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// CLEAN
		/**
		 * 
		 * 
		 * @param	d
		 * @param	o
		 * @param	ref
		 */
		internal function clean(d:Dictionary,o:*,ref:* = null):void
		{
			if (ref!=null) {
				if (Boolean(this[o])) {
					erase(this,o) ;
				}else if(Boolean(this[ref])){
					erase(this,ref) ;
				}else if(Boolean(__references[o])){
					erase(__references,o) ;
				}else if(Boolean(__references[ref])){
					erase(__references,ref) ;
				}
			}
			else {
				
			}
		}
		///////////////////////////////////////////////////////////////////////////////// ERASE
		/**
		 * Erases a value from this Gates Object
		 * 
		 * @param el *
		 * @param o *
		 */
		private function erase(el:*,o:*):void
		{
			if (el is Array) {
				el[o] = null ;
				delete el[o] ;
				if (el == __numeric) {
					__numeric = el.slice(0, o).concat(el.slice(o + 1, el.length)) ;
				}else {
					__keys = el.slice(0, o).concat(el.slice(o + 1, el.length)) ;
				}
			}else {
				el[o] = null ;
				delete el[o] ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// $REF
		/**
		 * Finds the key reference of a value in an Object (Array or Dictionary or else).
		 * 
		 * @param d Object
		 * @param value *
		 * @return The key in the Object the searched value is stocked with
		 */
		static internal function $ref(d:Object,value:*):*
		{
			for (var key:* in d)
				if (d[key] == value) return key;
		}
		///////////////////////////////////////////////////////////////////////////////// GETKEYREFERENCE
		/**
		 * Finds the key reference of a value in this Gates object.
		 * 
		 * @param value * - The stocked value, assuming the one we know
		 * @return The key reference in this Gates object the value is stocked with
		 */
		public function getKeyReference(value:*):*
		{
			return $ref(this, value) ;
		}
		///////////////////////////////////////////////////////////////////////////////// GETKEYFROMDICTIONARY
		/**
		 * Finds the key reference of a value in an Object, Array or Dictionary.
		 * 
		 * @param	d Object
		 * @param	value *
		 * @return  The key reference in the passed Object the value is stocked with
		 */
		static public function getKeyFromObject(d:Object,value:*):*
		{
			return $ref(d,value) ;
		}
		///////////////////////////////////////////////////////////////////////////////// GET ELEMENT
		/**
		 * Finds the value in a Gates object, that matches the key
		 * 
		 * @param	d Object
		 * @param	value *
		 * @return  The key reference in the passed Object the value is stocked with
		 */
		static public function getElement(g:Gates, key:*):*
		{
			return $get(g, key) ;
		}
		
		static private function $get(g:Gates,  key:*):*
		{
			return g.getElement(key) ;
		}
		
		
				///////////////////////////////////////////////////////////////////////////////// TOSTRING
		/**
		 * Returns a String decribing the instance Object
		 * 
		 * @return  The name of the instance Class, and the list of inner elements
		 */
		public function toString():String
		{
			return "[object Gates >> [" + merged +"]]" ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get merged():Array { return [].concat(__numeric).concat(__keys) }
		public function get numeric():Array { return __numeric }
		public function set numeric(value:Array):void 
		{ __numeric = value }
		public function get keys():Array { return __keys }
		public function set keys(value:Array):void 
		{ __keys = value }
		
		public function get references():Dictionary { return __references }
	}
}