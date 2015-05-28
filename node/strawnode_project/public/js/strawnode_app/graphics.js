(function(name, definition){
	
	if ('function' === typeof define){ // AMD
		define(definition) ;
	} else if ('undefined' !== typeof module && module.exports) { // Node.js
		module.exports = ('function' === typeof definition) ? definition() : definition ;
	} else {
		if(definition !== undefined) this[name] = ('function' === typeof definition) ? definition() : definition ;
	}

})('graphics', function(){
	
	
	var container = '.zoneall' ;
	var coltw ;

	return {
		focus : function(e){
			var res = e.target ;
			
			var color = res.userData.color ;
			
			if(!! coltw && coltw.isPlaying) coltw.stop() ;
			
			if(e.type == 'focusIn'){
				coltw = BetweenJS.to($('.coloraddict'), {'background-color':color}, .25, Linear.easeOut) ;
			}else{
				coltw = BetweenJS.to($('.coloraddict'), {'background-color':'0x111111'}, .25, Linear.easeOut) ;
				coltw.onComplete = function(){
					res.focusReady() ;
				}
			}
			coltw.play() ;
		},
		toggle : function(e){
			var res = e.target ;
			var color = res.userData.color = res.userData.color || {h:Math.random() * 360,s:100,v:60} ;
			
			var dims = res.userData.dims = res.userData.dims || {
				start:{ 'margin-top':150},
				end:{'margin-top':0}
			} ;
			
			if(res.opening){
				BetweenJS.tween(
					res.render(res.userData.urljade, res.fetch(res.userData.urljson, res.userData.parameters))
						.addClass('zindex'+(10 - res.depth)).css(dims.start)
						.appendTo(container)
					,dims.end, dims.start, .15, Expo.easeOut
				).play().onComplete = function(){
					res.ready() ;
				} ;
				
			}else{
				BetweenJS.tween(
					res.template
					,dims.start, dims.end, .15, Expo.easeIn
				).play().onComplete = function(){
					res.template.remove() ;
					res.ready() ;
				} ;
			}
		}
	}


}) ;