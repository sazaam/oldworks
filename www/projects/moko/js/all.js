var __dependancies__ = [
	{name:'jquery', url:'./jquery-1.7.1.min.js'},
	{name:'naja', url:'./naja.js'},
	{name:'jade', url:'./jade.js'},
	{name:'betweenjs', url:'./betweenjs.js'}
] ;

var win = window, doc = document, html = document.documentElement, body = document.body ;
var ww = $(win) ;
var dd = $(doc.body) ;

var tw, pagetw, toggletw, projectindex = -1, submodule = [] ;


var NNN, NNN2 ;



var CenterModule = Class('naja.modules::CenterModule', {
	
	constructor:function CenterModule(target){
		
		var tws = [] ;
		var lis = target.find('.nav ul li') ;
		var l = lis.length ;
		arr = lis.map(function(i, el){
			var props, props1, props2 ;
			var los = $('<div class="losange">') ;
			var img = $('<img class="fullW" src="./img/'+'los'+i+'.png'+'" alt=""/>').appendTo(los) ;
			
			var valout = 400 ;
			var valin = 0 ;
			
			var way = '' ;
			
			props1 = {'margin-top::px':0, 'margin-left::px':0} ;
			
			switch(i){
				case 0 :
					way = 'top' ;
					props = {'top::px':-valout, 'left::px':0, 'opacity':0} ;
					props2 = {'margin-top::px':-85, 'margin-left::px':0} ;
				break ;
				case 1 :
					way = 'right' ;
					props = {'top::px':0, 'left::px':valout, 'opacity':0} ;
					props2 = {'margin-top::px':0, 'margin-left::px':122} ;
				break ;
				case 2 :
					way = 'bottom' ;
					props = {'top::px':valout, 'left::px':0, 'opacity':0} ;
					props2 = {'margin-top::px':85, 'margin-left::px':0} ;
				break ;
				case 3 :
					way = 'left' ;
					props = {'top::px':0, 'left::px':-valout, 'opacity':0} ;
					props2 = {'margin-top::px':0, 'margin-left::px':-122} ;
				break ;
				
			}
			los.addClass(way).attr('rel', way).appendTo(target) ;
			
			
			tws[tws.length] = BetweenJS.delay(
				BetweenJS.serial(
					BetweenJS.tween(img, props2, props1, .5, Elastic.easeOut)
				),
				.05 * i
			) ;
			
			
			var c = new Command(i, function(){
				trace(i)
			})
			
			return c ;
		}).toArray() ;
		
		CenterModule.base.apply(this, [arr]) ;
		
		NNN = BetweenJS.parallelTweens(tws)//.play() ;
		NNN2 = BetweenJS.reverse(NNN) ;
	}
	
	
 }, Cyclic) ;
 
var Toggler = Class('net.utils::Toggler', {
	opened:false,
	constructor:function Toggler(closure){
		this.opened = false ;
		
		var all = $('.module'), hor = $('.hor'), ver = $('.ver') ;
		
		var ttww ;
		var ttwwrev ;
		
		this.closure = function(cond){
			var was;
			if(cond){
				if(NNN.isPlaying){
					NNN2.update(NNN2.time - NNN.stop().position) ;
					NNN.position = 0 ;
				}
				
				NNN2.play() ;
				
				$('.prout').removeClass('dispNone') ;
				hor.removeClass('dispNone') ;
				ver.removeClass('dispNone') ;
			}else{
				if(NNN2.isPlaying){
					NNN.update(NNN.time - NNN2.stop().position) ;
					NNN2.position = 0 ;
				}
				
				NNN.play() ;
				$('.prout').addClass('dispNone') ;
				hor.addClass('dispNone') ;
				ver.addClass('dispNone') ;
				
			}
		} ;
	},
	open:function(cond){
		if(cond){
			if(!this.isOpened()) this.closure(true) ;
		}else{
			if(this.isOpened()) this.closure(false) ;
		}
		this.opened = cond ;
	},
	toggle:function(){
		this.closure(this.opened = !this.opened) ;
	},
	isOpened:function(){
		return this.opened ;
	}
}) ;
 
$(document).bind('ready', function(){
	
	trace('THE CHAMP IS HERE') ;
	
	
	var t = new Jade('./testbis.jade').load(undefined, false) ;
	
	var template1 = $(t.render({user:{id:"sazaam", friends:4}}))
		.addClass('abs marginLg top0 left0 right50 bottom0 txtL')
		.appendTo('.prout') ;
	
	var template2 = $(t.render({user:{id:"ornorm", friends:3}}))
		.addClass('abs marginLg top0 left50 right0 bottom0 txtR')
		.appendTo('.prout') ;
	
	
	/* 
	var moduleholder = $('.module') ;
	
	var module = new CenterModule(moduleholder) ;
	
	var up = $('.up a') ;
	var down = $('.down a') ;
	var prev = $('.prev a') ;
	var next = $('.next a') ;
	
	
	var toggler = new Toggler() ;
	
	
	up.bind('click', function(e){
		e.preventDefault() ;
		module.prev() ;
	})
	
	down.bind('click', function(e){
		e.preventDefault() ;
		module.next() ;
	})
	
	prev.bind('click', function(e){
		e.preventDefault() ;
		if(submodule[projectindex] instanceof Cyclic) submodule[projectindex].prev() ;
	})
	next.bind('click', function(e){
		e.preventDefault() ;
		if(submodule[projectindex] instanceof Cyclic) submodule[projectindex].next() ;
	})
	
	$(window).bind('keydown', function(e){
		var k = e.keyCode ;
		
		
		switch(k){
			case 38: // up
				module.prev() ;
			break;
			case 40: // down
				module.next() ;
			break;
			case 39:
				if(submodule[projectindex] instanceof Cyclic) submodule[projectindex].next() ;
			break;
			case 37:
				if(submodule[projectindex] instanceof Cyclic) submodule[projectindex].prev() ;
			break;
			case 32:
				toggler.toggle() ;
			break;
			default:
				// alert(e.keyCode)
			break;
		}
	})
	
	$(document).bind('click', function(e){
		toggler.toggle() ;
	}) */
	/* 
	ww.bind('OStouchmoveX', function(e){
		if(e.distance > 0){
			if(submodule[projectindex] instanceof Cyclic) submodule[projectindex].next() ;
		}else{
			if(submodule[projectindex] instanceof Cyclic) submodule[projectindex].prev() ;
		}
	})
	ww.bind('OStouchmoveY', function(e){
		
		
		if(e.distance > 0){
			module.next() ;
		}else{
			module.prev() ;
		}
	}) */
})
