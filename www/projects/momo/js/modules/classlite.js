/* 
ClassLite Version 1.0
author saz aka True | contributor Ornorm
GNU GPL-General Public License
copyright sazaam[(at)gmail.com] 2012
*/
'use strict' ;
var Class = (function(){
	var ns = {}, ks, regNS = /::|[.]/ , keep = {'constructor':1 , 'factory':1, 'base':1, 'ns':1} ;
	return ks = function(namespace, properties, extendclass){
		var xt = extendclass, path = namespace, cl , spy ;
		var sp = path.split(regNS) ;
		var $ns = path.replace(regNS, '.') ;
		var l = sp.length, p = ns, ch ;
		for(var i = 0 ; i < l ; i++)
			ch = sp[i], (i < l - 1) && (p = (!!p[ch] ? p[ch] : (p[ch] = {name:ch}))) ;
		cl = p[ch] ;
		if(properties !== undefined) cl = undefined ;
		else return p[ch] ;
		return cl || (function(){
			var sub = !! properties ? properties : {} ;
			var sup = !!xt ? xt : Object ;
			var T = function(){} ;
			T.prototype = sup.prototype ;
			if(sub.constructor == Function){
				sub.prototype = new T ;
			}else{
				sub = (function(def, t){
					var body = def, p, s, o, T = t || function T(){} ;
					body.__proto__ = def.constructor ;
					def = body.constructor ;
					def.prototype = new T ;
					for(p in body) {
						if(p == 'statics') {
							o = body['statics'] ;
							for(s in o) {
								if(o.hasOwnProperty(s) && !(s in keep)) (s == 'initialize') ? (def[s] = o[s]).call(def) : def[s] = o[s] ;
								else if(s == 'toString') def[s] = o[s] ;
							}
							delete body['statics'] ;
						}else if(p == "constructor") continue;
						else def.prototype[p] = body[p] ;
					}
					return def ;
				})(sub, T) ;
			}
			sub.ns = $ns ;
			sub.base = sup ;
			sub.factory = sup.prototype ;
			sub.prototype.constructor = sub ;
			return (p[ch] = sub) ;
		})() ;
	} ;
})() ;