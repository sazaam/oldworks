trace('in test') ;

var Toto ;
new (Type.define({
	inherits:EventDispatcher,
	constructor:Toto = function Toto(){
		trace('Toto is here !!!') ;
		var t = this ;
		
		var yyy = new EventDispatcher(window) ;
		var xxx = new EventDispatcher(yyy) ;
		var ttt = new EventDispatcher(xxx) ;
		
		ttt.bind('s', function(e){
			//ttt.setDispatcher() ;
			ttt.unbind('s', arguments.callee) ;
			trace('COUCOU')
		})
		
		Toto.base.apply(t, [ttt]) ;
		
		// ready as an EventListener
		t.bind('s', function(e){
			t.unbind('s', arguments.callee) ;
			trace('LOAD ORIGINAL', e.type) ;
		})
		
		t.bind('s', function(e){
			// t.unbind('load', arguments.callee) ;	
			trace('LOAD', e.type)
		})
		
		// new EventDispatcher(window).trigger('load') ;
		new EventDispatcher(window).trigger('s') ;
		new EventDispatcher(window).trigger('s') ;
		
	}
})) ;

//









/* 
var win = window ;

var mmm = new EventDispatcher() ;

var zzz = new EventDispatcher(mmm) ;

zzz.bind('load', function(e){
	trace('ZZZ', e.type) ;
	zzz.setDispatcher() ;
})

var s = new EventDispatcher(zzz) ;

s.bind('load', function(e){
	// s.unbind('load', arguments.callee) ;
	trace('S', e.type) ;
}) ;

var ppp = new EventDispatcher(s) ;

ppp.bind('load', function(e){
	trace('P', e.type)
})

var aaa = new EventDispatcher(window).bind('click', function(e){
trace('click')
	new EventDispatcher(mmm).trigger('load') ;
})


new EventDispatcher(mmm).trigger('load') ;

 */

