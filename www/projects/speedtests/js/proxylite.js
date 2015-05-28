/* 
	ProxyLite Version 1.0
	
	@author saz aka True
	API Inspired by Classy (http://classy.pocoo.org)
*/
'use strict' ;
var Proxy = Proxy || (function(){
	var ns = {}, __global__ = window, returnValue = function(val, name){return val },
	toStringReg = /^\[|object ?|class ?|\]$/g ,
	DOMClass = function (obj) {
		if(obj.constructor !== undefined && obj.constructor.prototype !== undefined) return obj.constructor ;
		var tname = obj.tagName, kl, trans = { // Prototype.js' help here
		  "OPTGROUP": "OptGroup", "TEXTAREA": "TextArea", "P": "Paragraph","FIELDSET": "FieldSet", "UL": "UList", "OL": "OList", "DL": "DList","DIR": "Directory", "H1": "Heading", "H2": "Heading", "H3": "Heading","H4": "Heading", "H5": "Heading", "H6": "Heading", "Q": "Quote","INS": "Mod", "DEL": "Mod", "A": "Anchor", "IMG": "Image", "CAPTION":"TableCaption", "COL": "TableCol", "COLGROUP": "TableCol", "THEAD":"TableSection", "TFOOT": "TableSection", "TBODY": "TableSection", "TR":"TableRow", "TH": "TableCell", "TD": "TableCell", "FRAMESET":"FrameSet", "IFRAME": "IFrame", 'DIV':'Div', 'DOCUMENT':'Document', 'HTML':'Html', 'WINDOW':'Window'
		};
		if(tname === undefined)	if(obj === window) tname = 'WINDOW' ; else if(obj === document) tname = 'DOCUMENT' ; else if(obj === document.documentElement) tname = 'HTML' ;
		if(trans[tname] !== undefined) kl = (tname == 'WINDOW') ? trans[tname] : 'HTML' + trans[tname] + 'Element' ;
		if(__global__[kl] === undefined) { 
			__global__[kl] = { } ;
			__global__[kl].prototype = document.createElement(tname)['__proto__'] ;
			__global__[kl].toString = function(){ return '[object '+kl+']' } ;
		}
		return window[kl] ;
	},
	getPropertyClosure = function(val, name, obj){
		var type = typeof val ;
		switch(type){
			case 'null': case 'undefined': case 'number': case 'string': case 'boolean':
				return function(){ return (arguments.length > 0 ) ? (obj[name] = arguments[0]) : obj[name] } ; break ;
			case 'object' :
				return function(o, o2){
					if(o !== undefined ){
						var tt = typeof o, ob = obj[name] ;
						if(tt == 'string' || tt == 'number') return (o2 === undefined) ? ob[o] : (ob[o] = o2) ;
						for(var s in o)
							ob[s] = o[s] ;
						return obj[name] ;
					}else return obj[name] ;
				} ; break ;
			case 'function' : return function(){ return obj[name].apply(obj, arguments) } ; break ;
			default : return val ; break ;
		}
	},
	Proxy = function(target, override, toClass){
		var obj = target, cl = target.constructor, withoutnew = (this === __global__), tobecached = false, clvars, ret, func ;
		tobecached = (withoutnew) ? true : false ;
		cl = (cl === undefined) ? DOMClass(target).toString().replace(toStringReg, '') : cl.toString().replace(toStringReg, '') ;
		(toClass === true) && (tobecached = true) && (cl = cl + 'Proxy' ) ;
		if(ns[cl] !== undefined && tobecached === true) ret = ns[cl] ;
		else{
			func = function(tar, over){
				if(this === __global__) return new (arguments.callee)(tar) ;
				if(tar === undefined) {tar = target ; over = override}
				else if (tar !== target) {over = tar ; tar = target}
				else if(over === undefined){over = override}
				var el = (this.target = tar, this.target['__proxy__'] = this , this.$original = {}, this) ;
				for(var i in over) el[i] = returnValue(over[i], i) ;
				for(var i in tar) if(i != 'toString' && i != 'constructor' && i != '__proxy__') (i in el) ? el.$original[i] = getPropertyClosure(tar[i], i , tar) : el[i] = getPropertyClosure(tar[i], i , tar) ;
				el.bypassScope = function(meth, scope){ return function(){ return meth.apply(scope || el, arguments) } }
				return ('__init__' in el) ? el.__init__.apply(el, arguments) : el ;
			} ;
			ret = (tobecached === true) ? (ns[cl] = func) : func ;
		}
		if(tobecached || !withoutnew){
			ret.prototype.toString = function(){ return '[object '+ this.constructor.toString().replace(toStringReg, '') + ']' }
			ret.toString = function(){ return '[object Proxy::'+cl.replace(toStringReg, '')+']' } ;
			if(override !== undefined && (!!(clvars = override['__classvars__'])) && delete override['__classvars__'])
				for(var s in clvars) ret[s] = clvars[s] ;
		}
		ret.prototype.$super = override ;
		if('__static__' in ret  &&  ret.cored === undefined  && (ret.cored = true)) ret.__static__() ;
		return (toClass) ? ret : new ret(target) ;
	} ;
	Proxy.getProxy = function(target){ return target['__proxy__'] }
	Proxy.Class = function(t, o){return new Proxy(t, o, true) }
	return Proxy ;
})() ;