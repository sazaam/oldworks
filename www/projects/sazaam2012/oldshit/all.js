/* ALL HIERARCHY STEPS AND CORE BEHAVIOR */

/* 
 * Saz example website bootstrap
 * 2011-2012
 * @author saz aka True -> sazaam(at)gmail.com
 * 
 */

var win = window, doc = document, html = document.documentElement, body = document.body ;


/* ALL HIERARCHY STEPS AND CORE BEHAVIOR */

/* 
 * Spill for FONDATION CARTIER POUR L'ART CONTEMPORAIN 
 * 2011-2012
 * @author saz aka True -> sazaam(at)gmail.com
 * 
 */

// INITIALIZE ALL

AddressHierarchy.parameters = {
    home:'home/',
    base:location.protocol + '//'+ location.host + location.pathname,
    useLocale:true
}

var rootAddress = new Address(location.href) ;



// PAGE LOAD
$(win).bind('load', function(){
	
	
	var Unique = Pkg.definition('org.libspark.naja.step::Unique') ;
	
	// WHEN REALLY STARTS
	if(AddressHierarchy.isReady()){
		
		window.hierarchy = new AddressHierarchy(Unique).initJSAddress() ;
		
	}else{ // JUST HACK TO TRIM URL AND RELOAD FROM BASEPATH W/ RIGHT HASH
		
		new AddressHierarchy(Unique) ;
		
	}
	
})















function loadJSON(url, cb){
   $.ajax({
        url: url,
        dataType: 'json',
        success: cb
   });
}
function simulateJSON(url, cb){
   trace('SimulatingJSON > '+url) ;
   var obj = {} ;
   var navitems = $('#bottomnav .ajaxian a') ;
   trace(navitems)
   navitems.each(function(i, el){
   	 var a = $(el) ;
   	 var href = a.attr('href').replace(window.hierarchy.changer.locale, '') ;
   	 var label = a.attr('rel') ;
   	 obj[label] = href ;
   })
   
   setTimout(function(){cb(obj)}, 500) ;
   
}



$(win).bind('unload', function(e){
	
	var Unique = Pkg.definition('org.libspark.naja.step::Unique') ;
    Unique.instance = Unique.getInstance().destroy() ;
	
})
