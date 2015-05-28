var __dependancies__ = [
	{name:'trace', url:'./js/fw/modules/trace.js'}
] ;

var Scope = (function(){
	var Scope = function(){
		var args = [].slice.call(arguments) ;
		return Scope.$.apply(Scope, args) ;
	}
	Scope.cache = [] ;
	Scope.closures = [] ;
	Scope.$ = function(){
		var reg = /\$[0-9A-Z]+/gi ;
		var args = [].slice.call(arguments) ;
		var cache = Scope.cache ;
		var closures = Scope.closures ;
		var arg = args[0] ;
		var l = args.length ;
		var str ;
		var varname , evalstr , obj;
		if(l == 1){
			var obj = args[0] ;
			var type = typeof(obj) ;
			if(type == 'string'){
				
				if(!!closures[arg]) return eval(closures[arg]) ;
				if(!!cache[arg]) return eval(cache[arg]) ;
				
				evalstr = obj.replace(reg, function(){
					if(!!closures[arguments[0]]) return closures[arguments[0]] ;
					else return 'Scope.cache.'+arguments[0] ;
				}) ;
				return eval(evalstr) ;
			}else{
				return obj ;
			}
		}else if(l == 2){
			
			var obj = args[0] ;
			var target = args[1] ;
			var type = typeof(target) ;
			if(type == 'string'){
				evalstr = target.replace(reg, function(){
					if(!!closures[arguments[0]]) return closures[arguments[0]] ;
					else return 'Scope.cache.'+arguments[0] ;
				}) ;
				
				var res = eval(evalstr) ;
				eval('Scope.cache.'+obj+' = res') ;
				if(obj.indexOf('.') == -1) Scope.closures[obj] = evalstr ;
				return res ;
			}else{
				return eval('Scope.cache.'+obj+' = target') ;
			}
			
		}
	}
	return Scope ;
})() ;

// Scope('$sazaam',{
	// toto:{
		// arrays:[
		// [10,11,12,13],
		// function(el){
			// trace("original") ;
			// return false ;
		// },
		// function(el){
			// trace("rewrited") ;
			// return false ;
		// }
		// ,function(el){
			// trace("rewritedbis") ;
			// return false ;
		// }]
	// }
// }) ;

// Scope('$sazaam2',{
	// toto:{
		// arrays:[
		// [20,21,22,23],
		// function(el){
			// trace("original2") ;
			// return false ;
		// },
		// function(el){
			// trace("rewrited2") ;
			// return false ;
		// }
		// ,function(el){
			// trace("rewritedbis2") ;
			// return false ;
		// }]
	// }
// }) ;

// Scope('$saz', '$sazaam.toto.arrays[1]') ;
// Scope('$sazaam', '$sazaam2') ;
// Scope('$saz()') ;
// Scope('$sazaam.toto.arrays[1]', '$sazaam.toto.arrays[2]') ;
// Scope('$saz()') ;
// Scope('$sazaam.toto.arrays[1]', function(){
	// trace('rewritedbis') ;
	// return true ;
// }) ;
// Scope('$saz()')



