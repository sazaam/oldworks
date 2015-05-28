var __dependancies__ = [
	{name:'jquery', url:'./jquery-1.7.1.min.js'},
	{name:'naja', url:'./naja.js'},
	{name:'betweenjs', url:'./betweenjs.js'}
] ;

var win = window, doc = document, html = document.documentElement, body = document.body ;
var ww = $(win) ;
var dd = $(doc.body) ;
var trans = 1.25 ;

var tw ;


var Slides = Class('naja.slides::Slides', {
	constructor:function Slides(arr){
		var zoneleft = $('.left .pages') ;
		var zoneright = $('.right .pages') ;
		
		arr = arr.map(function(i, el){
			
			return new Command(i, function(){
				
				if(!! tw && tw.isPlaying) tw.stop() ;
				
				tw = BetweenJS.parallel(
					BetweenJS.to(zoneleft, {'top::%':-((i)*100)}, .25, Expo.easeOut),
					BetweenJS.to(zoneright, {'bottom::%':-((i)*100)}, .25, Expo.easeOut)
				).play() ;
				
				
			}) ;
		}).toArray() ;
		
		
		Slides.base.apply(this, [arr]) ;
		this.looping = false ;
		return this ;
	},
	to:function(n){
		
		
	}
}, Cyclic) ;

var Toggler = Class('net.utils::Toggler', {
	opened:false,
	constructor:function Toggler(closure){
		this.opened = false ;
		this.closure = closure ;
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
	var pages = $('.left .page') ;
	
	var up = $('.up a') ;
	var down = $('.down a') ;
	
	var slides = new Slides(pages) ;
	slides.next() ;
	
	up.bind('click', function(e){
		e.preventDefault() ;
		slides.prev() ;
	})
	
	down.bind('click', function(e){
		e.preventDefault() ;
		slides.next() ;
	})
	
	var toggletw ;
	var toggler = new Toggler(function(cond){
		if(!! toggletw && toggletw.isPlaying) toggletw.stop().update(.9) ;
		if(cond){
			toggletw = BetweenJS.to(all, {'left::%':17, 'right::%':17, 'bottom::%':17, 'top::%':17}, .25, Expo.easeOut).play() ;
		}else{
			toggletw = BetweenJS.to(all, {'left::%':0, 'right::%':0, 'bottom::%':0, 'top::%':0}, .25, Expo.easeOut).play() ;
		}
	}) ;
	
	
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
			case 37:
				// if(!!proj && !!proj.data('pageswitch'))
				// proj.data('pageswitch')(k === 39) ;
			break;
			case 32:
				toggler.toggle() ;
			break;
			default:
				//alert(e.keyCode)
			break;
		}
	})
})



