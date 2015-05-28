





'use strict' ;


trace = function(){
	if(window.console === undefined) return arguments[arguments.length - 1] ;
	if('apply' in console.log)
	console.log.apply(null, [].concat([].slice.call(arguments))) ;
	else
	console.log([].concat([].slice.call(arguments))) ;
	return arguments[arguments.length - 1] ;
}

var Namespace = function(path){
	return (function(){
		var o = {
			fullClassName:path,
			toString:function(){
				return '[object NameSpace > ' + this.fullClassName+']' ;
			}
		} ;
		return o ;
	})()
	
}
var Class = function() {};

var classes = {} ;
var Klass = function(path, obj, extend){
	
	var cl = classes[path] ;
	
	// constructor writing if absent from list
	return cl || (function(p, ob, xt){
		
		
		
		
		
		var ff = function(){
			// in object now
			var o = this ;
			
			return '__init__' in o ? o['__init__'].apply(o, [].slice.call(arguments)) : o ;
		}
		
		ff.toString = function(){
			return '[class ' + p +']' ;
		};
		
		// classvars setting
		if('__classvars__' in ob){
			var clv = ob['__classvars__'] ;
			for(var str in clv)
			ff[str] = clv[str] ;
			delete ob['__classvars__'] ;
		}
		
		if(!!xt) {
			for(var s in xt.prototype){
				ff.prototype[s] = xt.prototype[s] ;
			}
			ff.prototype.$super = xt ;
		}
		
		ff.prototype.toString = function(){
			return '[object ' + path +']' ;
		}
		
		
		for(var s in ob){
			ff.prototype[s] = ob[s] ;
		}
		
		
		// todo default settings
		
		trace('finally', ff.prototype , xt) ;
		
		return (classes[p] = ff) ;
	})(path, obj, extend) ;
	
}


var Saz = Klass('Saz', {
	__classvars__:{
		medias:[1,2,3],
		execute:function(){
			return this ;
		}
	},
	start:200,
	__init__:function(){
		trace(arguments) ;
		return this ;
	}
})

var Ornorm = Klass('Ornorm', {
	__classvars__:{
		medias:[321]
	},
	start:300
}, Saz)

var saz = new Saz(501) ;
var ornorm = new Ornorm(1024) ;

trace(saz)
trace(ornorm)

//trace(Saz.prototype == Ornorm.prototype)
trace('saz instanceof Saz', saz instanceof Saz)
trace('saz instanceof Ornorm', saz instanceof Ornorm)
trace('ornorm instanceof Ornorm', ornorm instanceof Ornorm)
trace('ornorm instanceof Saz', ornorm instanceof Saz)


/**/




window.onload = function(){



}




