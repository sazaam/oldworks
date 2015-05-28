/**
 * @author True
 */

// in order to maintain template system clean ;
$('link').remove() ; 
$('script').each(function(i, el){
	el.setAttribute('class', 'xload') ;
	el.setAttribute('source', el.getAttribute('src')) ;
	
}) ;

var ALLCSS 	= ['./css/default.css','./css/base.css','./css/all.css', './css/mq.css'] ;
var ALLJS	 	= ['./js/objects.js'] ;
var test ;
var saz ;
NS('XLoader').css(ALLCSS, function(){
	NS('XLoader').js(ALLJS,  function(){
		
		// new TestCommandQueue() ;
		// new TestRequest() ;
		// new TestRequestCommand() ;
		// new TestAjax() ;
		new Navigation() ;
	}) ;
}) ;