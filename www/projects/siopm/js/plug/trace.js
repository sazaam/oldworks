/* trace by saz */

trace = function(){
	if(window.console === undefined) return arguments[arguments.length - 1] ;
	if('apply' in console.log) console.log.apply(null, arguments) ;
	else console.log([].concat([].slice.call(arguments))) ;
	return arguments[arguments.length - 1] ;
}