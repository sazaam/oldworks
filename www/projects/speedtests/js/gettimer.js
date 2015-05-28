var getTimer = getTimer || (function(){
	var ___d = arguments.callee.___d = new Date().getTime() ;
	return function(){
	   return new Date().getTime() - ___d ;
	} ;
})() ;