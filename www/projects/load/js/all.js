var __dependancies__ = [
	{name:'jquery', url:'./jquery-1.7.1.min.js'},
	{name:'naja', url:'./naja.js'},
	{name:'jade', url:'./jade.js'},
	{name:'betweenjs', url:'./betweenjs.js'}
] ;






(function(){
	
	var win = window, doc = document, html = document.documentElement, body = document.body ;
	var ww = $(win) ;
	var dd = $(doc.body) ;
	
	
	var tw, pagetw, toggletw, projectindex = -1, subslides = [] ;
	var projects;
	var tws = [] ;
	var Slides = Class('naja.slides::Slides', {
		constructor:function Slides(arr, arr2){
			var zoneleft = $('.left .pages') ;
			var zoneright = $('.right .pages') ;
			var zonebottom = $('.zonebottom .slidebottom') ;
			
			var mm = arr, mm2 = arr2 ;
			
			
			var ccc = this ;
			
			arr = arr.map(function(i, el){
				
				var page = $(el) ;
				var page2 = $(arr2[i]) ;
				var blockszone = page.find('.blocks') ;
				var blockszone2 = page2.find('.blocks') ;
				var blockszonethumbs = $(zonebottom.find('.thumbscont')[i]) ;
				var blocks = page.find('.centerblock') ;
				var blocks2 = page2.find('.centerblock') ;
				
				
				var l = blocks.size() ;
				var subslidesarr = blocks.map(function(j, elm){
					
					return new Command(j, function(){
						var c = this ;
						
						
						if(!! pagetw && pagetw.isPlaying) pagetw.stop().update(.9) ;
						
						mm.addClass('hidden') ;
						$(mm[i]).removeClass('hidden') ;
						
						pagetw = BetweenJS.parallel(
							BetweenJS.to(blockszonethumbs, {'left::%':-(j) * 100}, .25, Expo.easeOut),
							BetweenJS.to(blockszone, {'left::%':-(j)*100}, .25, Expo.easeOut),
							BetweenJS.to(blockszone2, {'left::%':-(j)*100}, .25, Expo.easeOut)
						) ;
						
						pagetw.play() ;
						
					})
					
				}).toArray() ;
				
				var cy = subslides[subslides.length] = new Cyclic(subslidesarr) ;
				cy.looping = false ;
				cy.next() ;
				
				return new Command(i, function(){
					var c = this ;
					if(!! tw && tw.isPlaying) tw.stop().update(.9) ;
					mm.removeClass('hidden') ;
					
					
					tw = BetweenJS.parallel(
						BetweenJS.to(zonebottom, {'top::%':-((i)*100)}, .65, Expo.easeInOut),
						BetweenJS.to(zoneleft, {'top::%':-((i)*100)}, .65, Expo.easeInOut),
						BetweenJS.to(zoneright, {'bottom::%':-((i)*100)}, .65, Expo.easeInOut)
					) ;
					
					tw.play() ;
					
					$(body).css({background:projects[i].styles.backgroundthumb})
					
					projectindex = i ;
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
			
			var inval = 15 ;
			var outval = 0 ;
			this.closure = function(cond){
				if(!! toggletw && toggletw.isPlaying) toggletw.stop().update(.9) ;
				if(cond){
					toggletw = BetweenJS.to(all, {'left::%':0, 'right::%':0, 'bottom::%':inval, 'top::%':0}, .25, Expo.easeOut) ;
					toggletw.onPlay = function(){
						$('.zonebottom').removeClass('hidden') ;
					}
					toggletw.play() ;
				}else{
					toggletw = BetweenJS.to(all, {'left::%':outval, 'right::%':outval, 'bottom::%':outval, 'top::%':outval}, .25, Expo.easeOut) ;
					toggletw.onComplete = function(){
						$('.zonebottom').addClass('hidden') ;
					}
					toggletw.play() ;
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
		
		
		
		
		
		
		
		
		var t = new Jade('./page.jade').load(undefined, false) ;
		var tnav = new Jade('./pagenav.jade').load(undefined, false) ;
		
		projects = [
			{
				title:'Legendary League',
				desc:'Official Candidates',
				desclabels:'Logotype',
				date:2011,
				tags:'Fictionnal, Personal',
				imglayout:'fullH',
				styles:{
					backgroundthumb:'#000',
					background:'#000',
					color:'#F3F3F3'
				},
				pages:[
					'./img/00.png',
					'./img/01.png',
					'./img/02.png',
					'./img/03.png',
					'./img/04.png',
					'./img/05.png',
					'./img/06.png',
					'./img/07.png'
					
				]
			},
			{
				title:'K4MON',
				desc:'Guests Gangs Candidates',
				desclabels:'Logotype',
				date:2011,
				tags:'Fictionnal, Personal',
				imglayout:'fullH',
				styles:{
					backgroundthumb:'#000',
					background:'#000',
					color:'#CCC'
				},
				pages:[
					'./img/mon01.png',
					'./img/mon02.png',
					'./img/mon03.png',
					'./img/mon04.png',
					'./img/mon05.png',
					'./img/mon06.png',
					'./img/mon07.png',
					'./img/mon08.png',
					'./img/mon09.png',
					'./img/mon10.png',
					'./img/mon11.png',
					'./img/mon12.png',
					'./img/mon13.png',
					'./img/mon15.png',
					'./img/mon16.png'
				]
			},
			{
				title:'K4MON ROW 2',
				desc:'The Competition',
				desclabels:'Logotype',
				date:2011,
				tags:'Fictionnal, Personal',
				imglayout:'fullH',
				styles:{
					backgroundthumb:'#000',
					background:'#000',
					color:'#F5F5F5'
				},
				pages:[
					'./img/kamon1.png',
					'./img/kamon2.png',
					'./img/kamon3.png',
					'./img/kamon4.png'
				]
			},
			{
				title:'Saints Square',
				desc:'The Competition',
				desclabels:'Typeface',
				date:2011,
				tags:'Fictionnal, Personal',
				imglayout:'fullH',
				styles:{
					backgroundthumb:'#000',
					background:'#000',
					color:'#F5F5F5'
				},
				pages:[
					'./img/ss00.png',
					'./img/ss01.png',
					'./img/ss02.png'
				]
			}
		]
		
		
		var leftpages = $(t.render({zone:'left', user:{id:"sazaam", projects:projects}})).children()
			.appendTo('.zone.left') ;
		
		var rightpages = $(t.render({zone:'right', user:{id:"sazaam", projects:projects}})).children()
			.appendTo('.zone.right') ;
			
		var bottomnav = $(tnav.render({user:{id:"sazaam", projects:projects}})).children()
			.appendTo('.zonebottom') ;
		
		var project ;
		
		
		
		// var bbtw = BetweenJS.tween($('.all'), {'border-color':{r:50,g:50,b:50}}, {'border-color':{r:40,g:40,b:40}}, 2.5, Linear.easeNone) ;
		// var bbtw2 = BetweenJS.reverse(bbtw) ;
		// var coltw = BetweenJS.serial(bbtw, bbtw2) ;
		// coltw.stopOnComplete = false ;
		// coltw.play() ;
		
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
		// toggler.toggle() ;
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
		
	})

	
	// init the Stats and append it to the Dom - performance vuemeter
	stats = new Stats();
	stats.domElement.style.position = 'absolute';
	stats.domElement.style.top = '0px';
	$(document.body)[0].appendChild( stats.domElement );
	
	
	BetweenJS.interval(0, function(){
		stats.update();
		
	}).play() ;
	
	
})()








