



var win = window, doc = document, html = document.documentElement, body = document.body ;




/* ALL HIERARCHY STEPS AND CORE BEHAVIOR */

/* 
 * Spill for FONDATION CARTIER POUR L'ART CONTEMPORAIN 
 * 2011-2012
 * @author saz aka True -> sazaam(at)gmail.com
 * 
 */

// INITIALIZE ALL
/*
AddressHierarchy.parameters = {
    home:'home/',
    base:location.protocol + '//'+ location.host + location.pathname ,
    useLocale:true
} 
*/
// CACHE
window.cache = {json:{}, ajax:{}} ;
/*
// PAGE LOAD
$(win).bind('load', function()
{
    // Fondation Cartier
    trace('SIOPM v.1.2') ;
    
    var rootAddress = new Address(location.href) ;
    
    // WHEN REALLY STARTS
    if(AddressHierarchy.isReady()){
        
        //window.book = new Book() ;
        //window.book.detectBasics() ;
        
        //loadJSON(rootAddress.loc + 'json/root/', function(json){
            
            //window.toplevelNodes = json.node_descriptor.children ;
            
            
            window.hierarchy = new AddressHierarchy(Unique) ;
        //})
     }else{ // JUST HACK TO TRIM URL AND RELOAD FROM BASEPATH W/ RIGHT HASH
        new AddressHierarchy(Unique) ;
     }
})


$(win).bind('unload', function(e)
{
    Unique.instance = Unique.getInstance().destroy() ;
})
*/


var twin, twout, reset, saz ;
// INITIALIZE ALL

// Engine initialize
   
// PAGE LOAD
$(win).bind('load', function(e)
{
	    saz = $('#test') ;
	    
		reset = function(){
            window.twin.gotoAndStop(0) ;
            saz.data('opened', false) ;
        }
		
		
		var h = 0 ;
		var H = 300 ;
		var w = 320 ;
		var W = 874 ;
		
		
		var commands = [] ;
		var commands2 = [] ;
		
		var s = saz[0] ;
		var t = $('#textcont') ;
		var ornorm = $('#ornorm') ;
		var contentzone = $('#contentzone') ;
		var ul = $('#ulcont')[0] ;
		var scroll = $('#scroll')[0] ;
		var space = $('#bars') ;
		var bars = space.children('li') ;
		
		var arrowOrient = function(cond){
			if(cond === undefined) cond = true ;
			
			var lis = bars ;
			
			cond ? $('#bars').addClass('rwd') : $('#bars').removeClass('rwd') ;
			
			lis.each(function(i, el){
				var li = $(el) ;
				li.html(cond ? '&lt;' : '&gt;') ;
			})
			
		} ;
		
		
		var changeBackground = function(index){
			var lis = $('#ulcont li') ;
			
			var l = lis.size() ;
			var asc = cycle.ascend ;
			
			
			if(window.cycletw!== undefined && window.cycletw.isPlaying){
				window.cycletw.stop() ;
				window.cycletw = undefined ;
			}
			
			var p = BetweenJS.parallelTweens(lis.map(function(i, el){
				
				var bar = bars[i] ;
				
				return BetweenJS.delay(
				BetweenJS.tween(bar, {
					'margin-left': -40
				}, 
				{
					'margin-left': 0
				},
				.45,
				Expo.easeOut),
				i*.02) ;
			})) ;
			
			var p2 = BetweenJS.parallelTweens(lis.map(function(i, el){
				
				var bar = bars[i] ;
				
				return BetweenJS.delay(
				BetweenJS.tween(bar, {
					'margin-left': -260
				}, 
				{
					'margin-left': -40
				},
				.25, 
				Expo.easeOut),
				i*.02) ;
			})) ;
			
			arrowOrient(asc !== true) ;
			
			window.cycletw = BetweenJS.serial(
			p,
			BetweenJS.func(function(){
				lis.each(function(i, el){
					el.style.backgroundImage = 'url('+ lis[index].getAttribute('rel') +')' ;
				})
			}),
			p2
			).play() ;
			
			
			return this ;
		}
		
		
		
		var revtw = BetweenJS.parallelTweens($('.twCol').map(function(i, el){
			
			return BetweenJS.to(el, {
				'font-size':64,
				'color':'#171717'
			}, .15, Linear.easeIn) ;
			
		})
		);
		
		var bgChange = BetweenJS.parallelTweens($('#ornorm a').map(function(i, el){
			return BetweenJS.delay(BetweenJS.to( el, 
			   {
					'margin-left':0,
					'font-size':36,
					'left':0,
					'color':'#171717'
			   },
			   .25,
			   Linear.easeOut
			), i * .05
			) ;
			
		})) ;
	
		var bgChangerev = BetweenJS.reverse(bgChange) ;
		
		var revtw2 = BetweenJS.reverse(revtw) ;
		var tw1 = BetweenJS.serial(
			bgChange,
			BetweenJS.delay(BetweenJS.bezierTo( saz[0], 
			   {
				   'width':W,
				   'height':H
			   },
			   {
					'height':[H*1.5]
			   },
			   1,
			   Expo.easeOut
			), .5),
			BetweenJS.addChild(ul, scroll),
			BetweenJS.parallelTweens($('#ulcont').children('li').map(function(i, el){
				
				el.style.backgroundPosition = Number(-(125)*i)+'px 0px' ;
				
				
				commands.push(new Command(null, changeBackground, i)) ;
				
				return BetweenJS.delay(BetweenJS.tween( el, 
				   {
						'height':300,
						'margin-left':0
				   },
				   {
						'height':0,
						'margin-left':40
				   },
				   .25,
				   Expo.easeOut
				), i*.03
				) ;
			})),
			revtw
		) ;
		
		
		
		
		var scrollbox = $('#scrollboxinside') ;
		var boxes = $('#textcont .textbox') ;
		
		var changeText = function(index){
			
			var asc = cycle2.ascend ;
			
			if(window.cycle2tw!== undefined && window.cycle2tw.isPlaying){
				window.cycle2tw.stop() ;
				window.cycle2tw = undefined ;
			}

			var el = this.context ;
			var time = .25 ;
			if(window.unscrolled !== undefined){
				time = 0 ;
				window.unscrolled = undefined ;
			}
			window.cycle2tw = BetweenJS.to(scrollbox[0], 
			{'left':-W * index}, time, Expo.easeOut)
			.play() ;
			
			return this ;
		}
		
		var getTTWW = function(way){ 
			
			//var bbox = $(boxes[cycle2.index == -1 ? 0 : cycle2.index]) ;
			return BetweenJS.serial(BetweenJS.parallelTweens(
				$('.twCol2').map(function(ind, elm){
					return elm.getAttribute('id') != 'textcont' ? 
						BetweenJS.tween(elm, 
							{
								'color':'#ad0035'/*,
								'left':/leftArr/i.test(elm.getAttribute('class')) ? -50 : NaN,
								'right':/leftArr/i.test(elm.getAttribute('class')) ? NaN : -50*/
							},
							{
								'color':'#2A2A2A'/*,
								'left':0,
								'right':0*/
							},
							.25, Linear.easeIn
						)
					:
						BetweenJS.tween(t[0],
							{
								'top::%':0,
								'left::%':0,
								'width::%':100,
								'height::%':100
							},
							{
								'top::%':50,
								'left::%':0,
								'width::%':100,
								'height::%':0
							},
							.15,
							way !== undefined ? Expo.easeIn : Expo.easeOut
					)
				})
			),
			BetweenJS.tween(contentzone[0], 
				{
					'width':W
				},
				{
					'width':0
				},
				.5, Expo.easeOut
			)
			/*,
			BetweenJS.func(function(){
				var url = './img/wolff3.png' ;
				new AjaxCommand(url, function(jxhr){
					trace('retrieved') ;
					
					//var resp = $(jxhr.responseText) ;
					
					
					//trace(resp) ;
					
					
				}).execute() ;
				
				
			})*/
			) ;
		} ;
		
		var getTTWW2 = function(){
			return BetweenJS.reverse(getTTWW(true)) ;
		} 
		
		
		var cycle = new Cyclic() ;
		// cycle.deferred = true ;
		cycle.add(commands) ;
		
		
		var cycle2 = new Cyclic() ;
		cycle2.looping = false ;
		cycle2.deferred = true ;
		
		boxes.each(function(i, el){
			
			cycle2.push(new Command($(el).find('.titleh1'), changeText, i)) ;
		})
		
		
		var tw2 = BetweenJS.serial(
			revtw2,
			BetweenJS.func(function(){
				t.addClass('dispNone') ;
				space.data('opened', false) ;
			}),
			BetweenJS.removeFromParent(ul),
			BetweenJS.bezierTo(saz[0],
			   {
				   'width':w,
				   'height':h
			   },
			   {
					'height':[h]
			   },
			   .5,
			   Expo.easeOut
			),
			bgChangerev 
		) ;
	    
		space.data('open', function(cond){
			if(cond === undefined) cond = true ;
			if(cond){
				t.removeClass('dispNone') ;
				
				space.addClass('opened') ;
				BetweenJS.serial(
					getTTWW()
				).play().addEL('complete', function(e){
					trace('toto', e instanceof jQuery.Event)
				}) ;
				;
				space.data('opened', true) ;
			}else{
				space.removeClass('opened') ;
				
				BetweenJS.serial(
					getTTWW2()
				).play() ;
				//cycle2.index = 0 ;
				space.data('opened', false) ;
			}
			
		}) ;
		
		space.data('opened', false) ;
		// EVENTS
		space.bind('click', function(e){
			if(space.data('opened') !== true){
				space.data('open')() ;
			}else{
				space.data('open')(false) ;
			}
		})
		
		$('.LRarrow').bind('click', function(e){
			
			e.preventDefault() ;
			
			if(!$(this).hasClass('rightArr')) {
				if(space.data('opened') === false) cycle.prev() ;
				else if(!Boolean(cycle2.prev())) {
					bounceOp(false) ;
				} ;
			}else {
				if(space.data('opened') === false) cycle.next() ;
				else if(!Boolean(cycle2.next())) {
					bounceOp(true) ;
				} ;
			}
			
		})
		
		$(document).bind('keydown', arrowclosure = function(e){
			if (e.keyCode == 37) {
				e.preventDefault() ;
			    trace( "left pressed" );
			    if(space.data('opened') === false) cycle.prev() ;
				else if(!Boolean(cycle2.prev())) {
					bounceOp(false) ;
				} ;
			}
			if (e.keyCode == 39) {
				e.preventDefault() ;
			    trace( "right pressed" );
				if(space.data('opened') === false) cycle.next() ;
				else if(!Boolean(cycle2.next())) {
					bounceOp(true) ;
				} ;
			}
			if (e.keyCode == 38) {
				e.preventDefault() ;
			    trace( "up pressed" );
			   
			}
			if (e.keyCode == 40) {
				trace( "down pressed" );
				e.preventDefault() ;
			   
			}
			if (e.keyCode == 32) {
				trace( "space pressed" );
				e.preventDefault() ;
				
				if(space.data('opened') === false) {
					space.data('open')() ;
				}else{
					space.data('open')(false) ;
				}
				
			}
		});

		
		
		var bounceOp = function(cond){
			var v = -(cycle2.size()-1) * W ;
			
			trace(v, cycle2.size())
			
			BetweenJS.bezier(scrollbox[0], {
				'left':cond !== true ? 0 : v
			},
			{
				'left':cond !== true ? 0 : v
			},
			{
				'left':cond !== true ? 150 : v - 150
				
			},
			
			
			.25, Bounce.easeOut).play() ;
		} ;
		
		$(document).bind('mousewheel', wheelclosure = function(e, delta){
			e.preventDefault() ;
			
		    if (delta > 0) {
				if(space.data('opened') === false) cycle.prev() ;
				else if(!Boolean(cycle2.prev())) {
					bounceOp(false) ;
				} ;
		    }else if(delta < 0){
				if(space.data('opened') === false) cycle.next() ;
				else if(!Boolean(cycle2.next())) {
					bounceOp(true) ;
				} ;
		    }
		});
		
		
		
		
		
		/* var tw1 = BetweenJS.to( saz[0], 
		   {
		       'width':W,
    		   'height':H,
			   'opacity::NONE':1
	   	   },
	       .5,
	       Expo.easeOut
	    )
	    
		
		
		
		
		
		
		
		
		
	    var tw2 = BetweenJS.to(saz[0],
           {
               'width':w,
               'height':h,
			   'opacity::NONE':.4
           },
	       .5,
           Expo.easeOut
	    ) */
		/* 
		tw1 = BetweenJS.physicalTo(saz[0], 
			{
		       'width':W,
    		   'height':H,
			   'opacity::NONE':1
	   	   },
			Physical.uniform(10.0)) ;
		
        tw2 = BetweenJS.physicalTo(saz[0], 
			{
		       'width':w,
    		   'height':h,
			   'opacity::NONE':.4
			}, 
			Physical.uniform(10.0)) ;
		 */
		window.twin = tw1 ;
        window.twout = tw2 ;
        
        reset() ;
        
        /*
        var code = $('#code') ;
        $('#evaluator').bind('click', function(e){
            
            e.preventDefault() ;
            var str = code.attr('value') ;
            eval(str) ;
            
        }) ;
        
        
        code.bind('mousewheel', function(e, delta){
            //$('#code').scroll(30) ;
            code[0].scrollTop += 100 * (delta / (Math.min(delta, -delta))) ;
            trace('hey yooo', delta)
        }) ;
        */
		ornorm.bind('click', function(e){
		    var pos ;
            if(saz.data('opened') !== true){
                window.twin.update(0) ;
				if(window.twout.isPlaying) {
                    pos = window.twout.time - window.twout.position ;
                    window.twout.stop()
                    //window.twout.gotoAndStop(0) ;
                    window.twin.gotoAndPlay(window.twout.time) ;
                }
                window.twin.update(0).play() ;
                saz.data('opened', true) ;
            }else{
				window.twout.update(0) ;
                if(window.twin.isPlaying){
                    pos = twin.time - window.twin.position ;
                    window.twin.stop() ;
                    //window.twin.gotoAndStop(0) ;
                    window.twout.gotoAndPlay(window.twin.time) ;
                }
				
                window.twout.update(0).play() ;
                saz.data('opened', false) ;
            }
		})
		/**/
		
		
		
		
		
		
})



