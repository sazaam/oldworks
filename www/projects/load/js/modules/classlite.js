/* 
ClassLite Version 1.1
author saz aka True | contributor Ornorm
GNU GPL-General Public License
copyright sazaam[(at)gmail.com] 2012
*/
// var Class = (function(){
	// var NS = {}, rNS = /::|[.]/ , kp = {'factory':1, 'base':1, 'ns':1} ; 
	// var ks = function Class(namespace, properties, extendclass){
		// var xt = extendclass, props = properties, xy = namespace, cl ;
		// var sp = xy.split(rNS), ns = xy.replace(rNS, '.') ;
		// var l = sp.length, p = NS, ch ;
		// for(var i = 0 ; i < l ; i++)
			// ch = sp[i], (i < l - 1) && (p = (!!p[ch] ? p[ch] : (p[ch] = {name:ch}))) ;
		// cl = p[ch] ;
		// return ((!!!props) && (!!!xt)) ? cl : (function(){
			// var s = !! props ? props : {} ;
			// var ss = !!xt ? xt : Object ;
			// var T = function(){} ;
			// T.prototype = ss.prototype ;
			
			// this check is to have it made THE OPPOSITE WAY  (if a Function Ctor object is passed in as base obj)
			 // ---> MIXIN
			// if(s.constructor == Function) s.prototype = new T ;
			// THIS IS FOR ALL OTHER ANONYMOUS-OBJECT extends
			// else s = mk(s, T) ;
			
			// s.ns = ns ;
			// s.base = ss ;
			// s.factory = ss.prototype ;
			// s.prototype.constructor = s ;
			// return (p[ch] = s) ;
		// })() ;
	// } ;
	// var mk = ks.make = function make(o, t){
		// var b = o, p, s, k, T = t || function T(){} ;
		// if(b.hasOwnProperty('__proto__')) b.__proto__ = o.constructor.prototype ;
		
		
		// o = b.constructor ;
		
		// o.prototype = new T ;
		
		// for(p in b) {
			// if(p == 'statics') {
				// for(s in (k = b['statics']))
					// if(k.hasOwnProperty(s) && !(s in kp)) (s == 'initialize') ? (o[s] = k[s]).call(o) : o[s] = k[s] ;
					// else if(s == 'toString') o[s] = k[s] ;
				// delete b['statics'] ;
			// }else if(p == "constructor" || p == 'init') continue ;
			// else o.prototype[p] = b[p] ;
		// }
		
		// return o ;
	// }
	// return ks ;
// })() ;




var Class = function(ns, props, ext, impl, dom){
	return(Type.inherit(ns, props, ext, impl, dom)) ;
}

// throw new Error('ERRORTYPE')