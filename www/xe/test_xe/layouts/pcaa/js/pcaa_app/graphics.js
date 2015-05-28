var coltw ;
var tw, tw2 ;



exports.menudisplay = function(srl, cond){
	var a = $('#'+srl) ;
	
	if(cond){
		$('.menulink').removeClass('active') ;
		if(!!a.attr('rel')){
			var rel = a.attr('rel') ;
			arguments.callee(rel, cond) ;
		}
		a.addClass('active') ;
	}else{
		
		
	}
	
}



exports.navfold = function(srl, cond){
	
	if(srl != ''){
		var nested = $('#'+srl+'nested') ;
		
		if(nested.size() == 0) return ;
		if(cond){
			
			if(!nested.hasClass('opened')) nested.data('twin').play() ;
			nested.addClass('opened') ;
			
		}else{
			var future = AddressHierarchy.instance.changer.getTemporaryPath() ;
			var nested = $('#'+srl+'nested') ;
			if(nested.find('a[href="#/'+ future +'/"]').size() > 0 ) return ;
			
			if(nested.hasClass('opened')) nested.data('twout').play() ;
			nested.removeClass('opened') ;
			
		}
	}
}

exports.focus = function(e){
	
	var res = e.target ;
	if(e.type == 'focusIn'){
	}else{
	}
	
}

exports.toggle = function(e){
	
	var res = e.target ;
	var a = $('#'+res.userData.srl) ;
	
	if(res.opening){
		
		exports.navfold(a.attr('rel'), true) ;
		exports.menudisplay(res.userData.srl, true) ;
		
		// Page Opening In & Out Tweens 
		if(res.id != '')
			res.renderHTML(res.userData.urlHTML, '.content')
				.appendTo('#'+res.userData.srl+'container') ;
		else
			res.renderHTML(res.userData.urlHTML, '.content')
				.prependTo('.nav') ;
		
		var cont = $('.curtainall')[0]
		var p = $('.curtain')[0] ;
		
		
		tw = BetweenJS.serial(
			BetweenJS.timeout(1),
			BetweenJS.to(p, {'left::%':100}, .29, Expo.easeOut),
			BetweenJS.removeFromParent(cont)
		) ;
		tw.onComplete = function(){
			res.ready() ;
		} ;
		tw.play()
		
		
	}else{

		exports.navfold(a.attr('rel'), false) ;
		exports.menudisplay(res.userData.srl, false) ;
		
		// Page Opening In & Out Tweens 
		tw2 = BetweenJS.reverse(tw) ;
		tw2.onComplete = function(){
			res.template.remove() ;
			res.ready() ;
		}
		tw2.play()
		
	}
}
