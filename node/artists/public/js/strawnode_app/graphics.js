var container = '.zoneall' ;
var coltw ;

exports.focus = function(e){
	
	var res = e.target ;
	
	var color = res.userData.color ;
	if(!! coltw && coltw.isPlaying) coltw.stop() ;
	
	if(e.type == 'focusIn'){
		coltw = BetweenJS.to($('.coloraddict'), {'background-color':color}, .4, Linear.easeOut) ;
	}else{
		coltw = BetweenJS.to($('.coloraddict'), {'background-color':'0x111111'}, .4, Linear.easeOut) ;
	}
	coltw.play() ;
}

exports.toggle = function(e){
	
	var res = e.target ;
	
	var color = res.userData.color = res.userData.color || '0x' + parseInt( 0x666666 + Math.random() * 0x666666) ;
	var color2 = res.userData.color2 = res.userData.color2 || '0x' + parseInt( 0x666666 + Math.random() * 0x666666) ;
	var dims = res.userData.dims = res.userData.dims || {
		start:{ 'margin-top':150},
		end:{'margin-top':0}
	} ;
	
	if(res.opening){
		
		BetweenJS.tween(
			res.render(res.userData.urljade, res.fetch(res.userData.urljson, res.userData.parameters))
				.addClass('rel zindex'+(10 - res.depth)).css(dims.start)
				.appendTo(container)
			,dims.end, dims.start, .25, Back.easeOut
		).play().onComplete = function(){
			res.ready() ;
		} ;
		
	}else{
		
		BetweenJS.tween(
			res.template
			,dims.start, dims.end, .25, Back.easeIn
		).play().onComplete = function(){
			
			res.template.remove() ;
			res.ready() ;
			
		} ;
		
	}
}