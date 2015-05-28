/**
 * @author saz
 */

var css 	= ['./css/all.css'] ;

var js	 	= [] ;




$(function() {
	XLoader.css(css, function(e){
		
		// Parallax Page
		if(Toolkit.Qexists('#parallax'))
		XLoader.js(js.concat('./js/happycouples.js'),  function(e){
			new Parallax("#parallax", '.pageitem', '#navpages', '.navpagesitem') ;
		}) ;
		
		// Jackpot Page
		if(Toolkit.Qexists('#jackpot')){
			if ($(document.documentElement).hasClass('canvas')){
				XLoader.js(js.concat('./js/plugins/Three.js','./js/plugins/RequestAnimationFrame.js','./js/banglejackpot.js'),  function(e){
					new Jackpot("#jackpot", '#play', "#visual", '.patterns', '.visualitem', '#legend') ;
				}) ;
			}
		}
	}) ;
});