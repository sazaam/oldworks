

(function(name, definition){
	
	if ('function' === typeof define){ // AMD
		define(definition) ;
	} else if ('undefined' !== typeof module && module.exports) { // Node.js
		module.exports = ('function' === typeof definition) ? definition() : definition ;
	} else {
		if(definition !== undefined) this[name] = ('function' === typeof definition) ? definition() : definition ;
	}

})('app', (function(){
	
	// necessary for full app feature
	var express = require('Express') ;
	var routes = require('./routes') ;
	var graphics = require('./graphics') ;

	// PAGE LOAD
	var app = express() ;
		
		app
			// .configure(function(){
				// app
					// .set('address', {
						// home:'momoko',
						// base:'undefined' !== typeof __parameters ? __parameters.base : location.protocol + '//' + location.host + location.pathname,
						// useLocale:false
					// }) ;
			// })
		// PAGE LOAD
		.listen('load', function(e){
			app.discard('load', arguments.callee) ;
			// WHEN REALLY STARTS
			
			graphics.start() ;
			
			// app.isReady() &&
			
				// app
					// .createClient()
					// .get('/', routes)
					// .initJSAddress() ;
				
				// app.configure(graphics.init) ;
			
			
		})
		.listen('unload', function siteunload(e){
			// PAGE UNLOAD
			// app.discard('load', siteunload) ;
			app.destroy() ;
		}) ;
	
	return app ;
})()) ;