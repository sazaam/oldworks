
// what steps are going to do graphically , extracted from './graphics.js'
// on toggle (both opening / closing) and focus events

var graphics = require('./graphics') ;
var toggle = graphics.toggle ;
var focus = graphics.focus ;
trace(graphics.focus)
var menudisplay = graphics.menudisplay ;

// hierarchy sections descriptor object written as in 'exports' object

var base = AddressHierarchy.parameters.base ;


/////////// INDEX
exports.index = function index(req, res){
	
	if(res.opening){
		res.userData.urlHTML = base ;
		res.userData.parameters = {response:res} ;
	}
	return res ;
} ;
exports.index['@focus'] = focus ;
exports.index['@toggle'] = toggle ;


$('.logo a').attr('href', '#/') ;
$('.menulink').each(function(i, el){
	var a = $(el) ;
	var id = a.attr('href').replace(/.+\/(.+)\//, '$1') ;
	var srl = a.attr('id') ;
	a.attr('href', '#/'+ id +'/') ;
	
	exports[id] = function(req, res){
		if(res.opening){
			res.userData.srl = srl ;
			res.userData.urlHTML = base + id + '/' ;
		}
		return res ;
	}
	
	var nested = $('#'+srl+'nested') ;
	if(nested.size() > 0){
		
		var l = parseInt(nested.attr('rel')) ;
		var twin = BetweenJS.tween(nested, {'height::em':l * 1.23}, {'height::em':0}, .29, Quint.easeOut) ;
		var twout = BetweenJS.reverse(twin) ;
		nested.data('twin', twin) ;
		nested.data('twout', twout) ;
		
	}
	
	
	exports[id]['@focus'] = focus ;
	exports[id]['@toggle'] = toggle ;

})

// admin
/* exports[/index\.php(.+)?/] = function admin(req, res){
	
	var qs = location.hash.match(/\?.+$/)[0] ;
	if(res.opening){
		res.userData.urlHTML = base + 'index.php' + qs ;
	}
	
	return res ;
}

exports[/index\.php(.+)?/]['@focus'] = focus ;
exports[/index\.php(.+)?/]['@toggle'] = toggle ;
 */