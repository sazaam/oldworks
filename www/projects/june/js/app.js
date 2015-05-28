var app = require('./conf')() ;

// PAGE LOAD
app.listen('load', function siteload(e){
	app.discard('load', siteload) ;
	
	// WHEN REALLY STARTS
	if(app.isReady()){
		
		app.createClient() ;
		
		setTimeout(function(){
			app.initJSAddress() ;
		}, 1500)
		
	}else{ // WHEN REAL DEEPLINK ARRIVES WITHOUT HASH, RELOAD W/ HASH
		
		app.createClient() ;
		
	}
})

// PAGE UNLOAD
.listen('unload', function siteunload(e){
	app.discard('load', siteunload) ;
	app.destroy() ;
}) ;