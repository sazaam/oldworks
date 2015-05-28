var __dependancies__ = [
	{name:'jquery', url:'./jquery-1.7.1.min.js'},
	{name:'naja', url:'./naja.js'},
	{name:'betweenjs', url:'./betweenjs.js'}
] ;

var win = window, doc = document, html = document.documentElement, body = document.body ;
var ww = $(win) ;
var dd = $(doc.body) ;

var tw, pagetw, toggletw, projectindex = -1, subslides = [] ;

var Slides = Class('naja.slides::Slides', {
	constructor:function Slides(arr, arr2){
		var zoneleft = $('.left .pages') ;
		var zoneright = $('.right .pages') ;
		
		arr = arr.map(function(i, el){
			
			
			var page = $(el) ;
			var page2 = $(arr2[i]) ;
			var blockszone = page.find('.blocks') ;
			var blockszone2 = page2.find('.blocks') ;
			var blocks = page.find('.centerblock') ;
			var blocks2 = page2.find('.centerblock') ;
			
			var subslidesarr = blocks.map(function(j, elm){
				
				return new Command(j, function(){
					var c = this ;
					if(!! pagetw && pagetw.isPlaying) pagetw.stop() ;
					
					pagetw = BetweenJS.parallel(
						BetweenJS.to(blockszone, {'left::%':-((j)*100)}, .25, Expo.easeOut),
						BetweenJS.to(blockszone2, {'left::%':-((j)*100)}, .25, Expo.easeOut)
					).play() ;
					pagetw.onComplete = function(){
						pagetw = undefined ;
					}
				})
				
			}).toArray() ;
			
			var cy = subslides[subslides.length] = new Cyclic(subslidesarr) ;
			cy.looping = false ;
			cy.next() ;
			
			return new Command(i, function(){
				var c = this ;
				if(!! tw && tw.isPlaying) tw.stop() ;
				
				tw = BetweenJS.parallel(
					BetweenJS.to(zoneleft, {'top::%':-((i)*100)}, .25, Expo.easeOut),
					BetweenJS.to(zoneright, {'bottom::%':-((i)*100)}, .25, Expo.easeOut)
				).play() ;
				tw.onComplete = function(){
					tw = undefined ;
				}
				
				projectindex = i ;
				//subslides[projectindex].next() ;
			})
		}).toArray() ;
		
		
		Slides.base.apply(this, [arr]) ;
		this.looping = false ;
		
		
		return this ;
	}
}, Cyclic) ;




var Toggler = Class('net.utils::Toggler', {
	opened:false,
	constructor:function Toggler(closure){
		this.opened = false ;
		
		var all = $('.all') ;
		var hor = $('.hor') ;
		var ver = $('.ver') ;
		var inval = 50 ;
		var outval = 0 ;
		this.closure = function(cond){
			if(!! toggletw && toggletw.isPlaying) toggletw.stop().update(.9) ;
			if(cond){
				// toggletw = BetweenJS.to(all, {'left::px':inval, 'right::px':inval, 'bottom::px':inval, 'top::px':inval}, .25, Expo.easeOut).play() ;
				toggletw = BetweenJS.to(all, {'left::px':outval, 'right::px':outval, 'bottom::px':inval, 'top::px':inval}, .25, Expo.easeOut).play() ;
				hor.addClass('dispNone') ;
				ver.removeClass('dispNone') ;
				
			}else{
				// toggletw = BetweenJS.to(all, {'left::px':outval, 'right::px':outval, 'bottom::px':outval, 'top::px':outval}, .25, Expo.easeOut).play() ;
				toggletw = BetweenJS.to(all, {'left::px':inval, 'right::px':inval, 'bottom::px':outval, 'top::px':outval}, .25, Expo.easeOut).play() ;
				hor.removeClass('dispNone') ;
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
	
	trace('THE CHAMP IS HERE')
	
	// trace(new Slides())
	var project ;
	var all = $('.all') ;
	// var arealeft = $('.zone.left') ;
	var arearight = $('.zone.right .pages') ;
	
	var index ;
	var leftpages = $('.left .page') ;
	var rightpages = $('.right .page') ;
	
	var up = $('.up a') ;
	var down = $('.down a') ;
	var prev = $('.prev a') ;
	var next = $('.next a') ;
	
	
	var toggler = new Toggler() ;
	toggler.toggle() ;
	var slides = new Slides(leftpages, rightpages) ;
	slides.next() ;
	
	
	up.bind('click', function(e){
		e.preventDefault() ;
		slides.prev() ;
	})
	
	down.bind('click', function(e){
		e.preventDefault() ;
		slides.next() ;
	})
	
	prev.bind('click', function(e){
		e.preventDefault() ;
		if(subslides[projectindex] instanceof Cyclic) subslides[projectindex].prev() ;
	})
	next.bind('click', function(e){
		e.preventDefault() ;
		if(subslides[projectindex] instanceof Cyclic) subslides[projectindex].next() ;
	})
	
	ww.bind('keydown', function(e){
		var k = e.keyCode ;
		
		switch(k){
			case 38: // up
				slides.prev() ;
			break;
			case 40: // down
				slides.next() ;
			break;
			case 39:
				if(subslides[projectindex] instanceof Cyclic) subslides[projectindex].next() ;
			break;
			case 37:
				if(subslides[projectindex] instanceof Cyclic) subslides[projectindex].prev() ;
			break;
			case 32:
				toggler.toggle() ;
			break;
			default:
				//alert(e.keyCode)
			break;
		}
	})
	
	
	///////// TOUCH EVENTS
	// ww.bind('OStouchmoveX', function(e){
		// if(e.distance > 0){
			// if(subslides[projectindex] instanceof Cyclic) subslides[projectindex].next() ;
		// }else{
			// if(subslides[projectindex] instanceof Cyclic) subslides[projectindex].prev() ;
		// }
	// })
	// ww.bind('OStouchmoveY', function(e){
		
		
		// if(e.distance > 0){
			// slides.next() ;
		// }else{
			// slides.prev() ;
		// }
	// })
})



