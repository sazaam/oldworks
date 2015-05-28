require('formsvalidator.js') ;
require('strawexpress-utils.js') ;


(function(){

	var toplinks = $('.nav li a') ;
	toplinks.each(function(i, el){
		var link = $(el) ;
		var url = link.attr('href') ;
		link.attr('href', AddressChanger.hashEnable(url)) ;
	})

})() ;

exports.highlightnav = function highlightnav(res, cond){
	if(!!!cond) cond = true ;
	
	$('.nav li').each(function(i, el){
		var li = $(el) ;
		cond ? (i == res.index - 1) ? li.addClass('active') : li.removeClass('active') : li.removeClass('active') ;
	}) ;
	
}


exports.tweenIn = function tweenIn(res, cb){
	
	var pages = $('.page') ;
	
	var slashes = $('.slash') ;
	
	var twsin = [] ;
	var twsout = [] ;
	var serials = [] ;
	var l = slashes.size() ;
	
	$('.slashes').removeClass('dispNone') ;
	
	slashes.each(function(i, el){
		var slash = $(el) ;
		if(res.parentStep.way != 'backward'){
			twsin[twsin.length] = 
				BetweenJS.delay(
					BetweenJS.tween(slash, {'left::%':0}, {'left::%':150}, .3, Expo.easeOut)
				, .05 * i) ;
			twsout[twsout.length] = 
				BetweenJS.delay(
					BetweenJS.tween(slash, {'left::%':-150}, {'left::%':0}, .3, Expo.easeInOut)
				, .05 * (l - 1 - i)) ;
		}else{
			twsin[twsin.length] = 
				BetweenJS.delay(
					BetweenJS.tween(slash, {'left::%':-0}, {'left::%':-150}, .3, Expo.easeOut)
				, .05 * i) ;
			twsout[twsout.length] = 
				BetweenJS.delay(
					BetweenJS.tween(slash, {'left::%':150}, {'left::%':-0}, .3, Expo.easeInOut)
				, .05 * (l - 1 - i)) ;
			
			
		}
		
		
	}) ;
	
	serials[serials.length] = BetweenJS.parallelTweens(twsin) ;
	
	serials[serials.length] = BetweenJS.func(function(){
		pages.each(function(i, el){
			var page = $(el) ;
			i == res.index ? page.removeClass('dispNone') : page.addClass('dispNone') ;
		}) ;
	}) ;
	
	serials[serials.length] = BetweenJS.parallelTweens(twsout) ;
	serials[serials.length] = BetweenJS.func(function(){
		
		$('.slashes').addClass('dispNone') ;
		cb() ;
		
	}) ;
	
	var tw = BetweenJS.serialTweens(serials) ;
	tw.play() ;
	
}

exports.customs = function customs(res, cond, clos){
	var app = require('Express').app,
		Cyclic = Pkg.definition('org.libspark.straw.collection::Cyclic'),
		Command = Pkg.definition('org.libspark.straw.command::Command'),
		CommandQueue = Pkg.definition('org.libspark.straw.command::CommandQueue') ;
	
	// if slideshow page
	var slides = app.Qexists(res.userData.page, '.slide') ;
	// if booking contacts form page
	var bookingform = app.Qexists(res.userData.page, '.bookingform') ;
	
	if(!!slides){
		
		var show = app.Qexists('.slides') ;
		var slideshow = app.Qexists('.slideshow') ;
		var cyclic ;
		
		if(cond){
			
			if(!!! res.userData.cyclic){
				
				var arr = [] ;
				slides.each(function(i, el){
					var li = $(el) ;
					var a = $(li.children('a')[0]) ;
					arr[arr.length] = new Command(i, function(){
						var c = this ;
						if(a.attr('href')!== ''){
							a.css({'background-image':'url("'+a.attr('href')+'")'}) ;
							a.attr({'href':''}) ;
						}
						
						BetweenJS.to(show, {'left::%':-(this.context*100)}, .25, Expo.easeInOut).play() ;
						
						if(i == arr.length - 1) nexta.addClass('inactive') ;
						else nexta.removeClass('inactive') ;
						
						if(i == 0) preva.addClass('inactive') ;
						else preva.removeClass('inactive') ;
						
						return this ;
					}) ;
				}) ;
				
				cyclic = res.userData.cyclic = new Cyclic(arr) ;
				cyclic.looping = false ;
				var preva = app.Qexists('.prev') ;
				var nexta = app.Qexists('.next') ;
				
				preva.bind('click', function(e){
					e.preventDefault() ;
					cyclic.prev() ;
				}) ;
				
				nexta.bind('click', function(e){
					e.preventDefault() ;
					cyclic.next() ;
				}) ;
				cyclic.next() ;
			}
			
			var twin = BetweenJS.delay(BetweenJS.tween(slideshow, {'margin-top::%':0},{'margin-top::%':100}, .25, Expo.easeOut), .35, .15).play() ;
			twin.onComplete = function(){clos()} ;
			
		}else{
			
			var twout = BetweenJS.delay(BetweenJS.tween(slideshow, {'margin-top::%': 100},{'margin-top::%':0}, .25, Expo.easeIn), .15, .35).play() ;
			twout.onComplete = function(){clos()} ;
			
		}
		
		return ;
		
	}else if(!!bookingform){
		
		var FormsValidator = Pkg.definition('org.libspark.straw.forms::FormsValidator') ;
		
		FormsValidator.createClient('http://sazaam.net/demos/momo/', function(s){
			trace(s) ;
		}) ;
		
		var send = app.Qexists(bookingform, '.sendbtn') ;
		var clear = app.Qexists(bookingform, '.clearbtn') ;
		var validzone = app.Qexists(res.userData.page, '.validzone') ;
		var errorzone = app.Qexists(res.userData.page, '.errorzone') ;
		var validretry = app.Qexists(validzone, '.retry') ;
		var errorretry = app.Qexists(errorzone, '.retry') ;
		
		validretry.bind('click', function(e){
			//e.preventDefault() ;
			FormsValidator.reset() ;
			validzone.addClass('dispNone') ;
		})
		errorretry.bind('click', function(e){
			e.preventDefault() ;
			
			errorzone.addClass('dispNone') ;
		})
		
		if(cond){
			
			if(res.userData.sendclosure === undefined){
				FormsValidator.initForms($('#bookingform')) ;
				send.bind('click', res.userData.sendclosure || (res.userData.sendclosure = function(e){
					e.preventDefault() ;
					var valid = FormsValidator.validate(function(s){
						var nn = true ;
						s.validators.each(function(i, v){
							v.success = function(el){
								$(el).parent().addClass('success') ;
								$(el).parent().removeClass('failure') ;
							}
							v.failure = function(el){
								$(el).parent().removeClass('success') ;
								$(el).parent().addClass('failure') ;
							}
							nn = nn & v.check() ;
						}) ;
						
						return nn ;
					}) ;
					
					if(valid){
						// case 1 validate returns true, 
						// send mail
						// display post succes screen
						
						validzone.removeClass('dispNone') ;
						errorzone.addClass('dispNone') ;
						
						
						
					}else{
						// display error message
						
						validzone.addClass('dispNone') ;
						errorzone.removeClass('dispNone') ;
						
						
					}
					
				})) ;
				
				clear.bind('click', res.userData.clearclosure || ( res.userData.clearclosure = function(e){
					e.preventDefault() ;
					
					FormsValidator.reset() ;
					
				})) ;
				
			}
			
			
			
		}
		
		
		clos() ;
		
		
	}else{
		
		clos() ;
		
	}
	
}

exports.focus = function(e){
	var res = e.target ;
	return res.focusReady() ;
}
exports.toggle = function(e){
	
	var res = e.target ;
	
	if(res.opening){
		res.userData.page = res.userData.page || $($('.page')[res.index]) ;
		exports.highlightnav(res, true) ;
		
		exports.tweenIn(res, function(){
			exports.customs(res, true, function(){
				res.ready() ;
			})
		})
		
	}else{
		exports.highlightnav(res, false) ;
		
		exports.customs(res, false,  function(){
			res.ready() ;
		})
		
		
		res.ready() ;
	}
}