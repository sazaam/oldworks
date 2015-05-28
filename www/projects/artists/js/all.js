/**
 * @author True
 */

var css 	= ['./css/all.css', './css/mq.css'] ;

var js	 	= ['./js/objects.js'] ;

NS('XLoader').css(css, function(e){
	NS('XLoader').js(js,  function(e){
		new Grid('#gallery', '.item');
	}) ;
}) ;