

(function(name, definition){
	
	if ('function' === typeof define){ // AMD
		define(definition) ;
	} else if ('undefined' !== typeof module && module.exports) { // Node.js
		module.exports = ('function' === typeof definition) ? definition() : definition ;
	} else {
		if(definition !== undefined) this[name] = ('function' === typeof definition) ? definition() : definition ;
	}
	
})('routes', function(){
	
	var graphics = require('./graphics') ;
	var focus = graphics.focus ;
	var toggle = graphics.toggle ;
	var togglepanel = graphics.togglepanel ;
	var focuspanel = graphics.focuspanel ;
	
	return {
		momoko : (function(){
			
			var momoko = function momoko (req, res){
				
				return res ;
			} ;
			
			momoko['@focus'] = focus ;
			momoko['@toggle'] = toggle ;
			return momoko ;
		})(),
		ookimenotai : (function(){
			var ookimenotai = function ookimenotai (req, res){ return res }
			ookimenotai['@focus'] = focus ;
			ookimenotai['@toggle'] = toggle ;
			
			ookimenotai[1] = function(res, req){ return res }
			ookimenotai[1]['@toggle'] = togglepanel ;
			ookimenotai[1]['@focus'] = focuspanel ;
			
			ookimenotai[2] = function(res, req){ return res }
			ookimenotai[2]['@toggle'] = togglepanel ;
			ookimenotai[2]['@focus'] = focuspanel ;
			
			ookimenotai[3] = function(res, req){ return res }
			ookimenotai[3]['@toggle'] = togglepanel ;
			ookimenotai[3]['@focus'] = focuspanel ;
			
			ookimenotai[4] = function(res, req){ return res }
			ookimenotai[4]['@toggle'] = togglepanel ;
			ookimenotai[4]['@focus'] = focuspanel ;
			
			ookimenotai[5] = function(res, req){ return res }
			ookimenotai[5]['@toggle'] = togglepanel ;
			ookimenotai[5]['@focus'] = focuspanel ;
			
			return ookimenotai ;
		})(),
		cactus : (function(){
			var cactus = function cactus (req, res){ return res }
			cactus['@focus'] = focus ;
			cactus['@toggle'] = toggle ;
			
			cactus[1] = function(res, req){ return res }
			cactus[1]['@toggle'] = togglepanel ;
			cactus[1]['@focus'] = focuspanel ;
			
			cactus[2] = function(res, req){ return res }
			cactus[2]['@toggle'] = togglepanel ;
			cactus[2]['@focus'] = focuspanel ;
			
			cactus[3] = function(res, req){ return res }
			cactus[3]['@toggle'] = togglepanel ;
			cactus[3]['@focus'] = focuspanel ;
			
			cactus[4] = function(res, req){ return res }
			cactus[4]['@toggle'] = togglepanel ;
			cactus[4]['@focus'] = focuspanel ;
			
			cactus[5] = function(res, req){ return res }
			cactus[5]['@toggle'] = togglepanel ;
			cactus[5]['@focus'] = focuspanel ;
			
			return cactus ;
		})(),
		trump : (function(){
			var trump = function trump (req, res){ return res }
			trump['@focus'] = focus ;
			trump['@toggle'] = toggle ;
			
			trump[1] = function(res, req){ return res }
			trump[1]['@toggle'] = togglepanel ;
			trump[1]['@focus'] = focuspanel ;
			
			trump[2] = function(res, req){ return res }
			trump[2]['@toggle'] = togglepanel ;
			trump[2]['@focus'] = focuspanel ;
			
			trump[3] = function(res, req){ return res }
			trump[3]['@toggle'] = togglepanel ;
			trump[3]['@focus'] = focuspanel ;
			
			trump[4] = function(res, req){ return res }
			trump[4]['@toggle'] = togglepanel ;
			trump[4]['@focus'] = focuspanel ;
			
			return trump ;
		})(),
		nekodearu : (function(){
			var nekodearu = function nekodearu (req, res){ return res }
			nekodearu['@focus'] = focus ;
			nekodearu['@toggle'] = toggle ;
			
			nekodearu[1] = function(res, req){ return res }
			nekodearu[1]['@toggle'] = togglepanel ;
			nekodearu[1]['@focus'] = focuspanel ;
			
			nekodearu[2] = function(res, req){ return res }
			nekodearu[2]['@toggle'] = togglepanel ;
			nekodearu[2]['@focus'] = focuspanel ;
			
			nekodearu[3] = function(res, req){ return res }
			nekodearu[3]['@toggle'] = togglepanel ;
			nekodearu[3]['@focus'] = focuspanel ;
			
			return nekodearu ;
		})()
	} ;

}) ;