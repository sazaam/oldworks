/* ALL HIERARCHY STEPS AND CORE BEHAVIOR */

/* 
 * Spill for FONDATION CARTIER POUR L'ART CONTEMPORAIN 
 * 2011-2012
 * @author saz aka True -> sazaam(at)gmail.com
 * 
 */

var win = window, doc = document, html = document.documentElement, body = document.body ;

/*
body.addEventListener('touchstart', function(e){ e.preventDefault(); document.dispatchEvent(e) });
body.addEventListener('touchmove', function(e){ e.preventDefault(); document.dispatchEvent(e) });
*/
// INITIALIZE ALL

AddressHierarchy.parameters = {
   home:'home/',
   base:location.protocol + '//'+ location.host + location.pathname ,
   useLocale:true
}

var content = $('#frameInside') ;
//content.animate({'opacity':0}, 0) ;


// PAGE LOAD
$(win).bind('load', function()
{
    // Fondation Cartier
    trace('SAMUAE v 1.0') ;
    
    if(AddressHierarchy.isReady()){
    	
    	new AddressHierarchy(Unique) ;
		
    }else{
    	// reload to base path
    }
})

var Cyclic = NS('Cyclic', NS('naja.collections::Cyclic', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class Cyclic]' ;
        }
    },
    __init__:function(arr)
    {
        var cy = this ;
        var commands = cy.commands = [] ;
        cy.playhead = NaN ;
        cy.index = -1 ;
    },
    add:function(){
       var cy = this ;
       var commands = cy.commands ;
       var args = [].slice.call(arguments) ;
       var len = args.length ;
       for(var i = 0 ; i < len ; i++){
          var arg = args[i] ;
          if(arg[0] !== undefined && arg[0] instanceof Command){
             l = cy.push.apply(cy, arg) ;
          }else{
             l = cy.push.apply(cy, [arg]) ;
          }
       }
       return l ;
    },
    remove:function(){
       var cy = this ;
       var commands = cy.commands ;
       var args = [].slice.call(arguments) ;
       var len = args.length ;
       for(var i = 0 ; i < len ; i++){
          var arg = args[i] ;
          if(isNaN(arg) && arg instanceof Command){
             var n = cy.indexOf(arg) ;
             cy.splice(n, 1) ;
          }else{
             cy.splice(arg, 1) ;
          }
       }
       var l = commands.length ;
       return l ;
    },
    indexOf:function(el){
       var cy = this ;
       var commands = cy.commands ;
       
       if(Array.prototype['indexOf'] !== undefined){
          return commands.indexOf(el) ;
       }else{
          var l = commands.length ;
          for(var i = 0 ; i < l ; i++){
             if(commands[i] === el) return i ;
          }
       }
    },
    splice:function(){
       var cy = this ;
       var commands = cy.commands ;
       var r = commands.splice.apply(commands, [].slice.call(arguments)) ;
       var l = commands.length ;
       var div = 1/l ;
       cy.unit = {index:div, deg:div * 360, rad:div * Math.PI * 2} ;
       return r ;
    },
    push:function(){
       var cy = this ;
       var commands = cy.commands ;
       var l = commands.push.apply(commands, [].slice.call(arguments)) ;
       var div = 1/l ;
       cy.unit = {index:div, deg:div * 360, rad:div * Math.PI * 2} ;
       return l ;
    },
    unshift:function(){
       var cy = this ;
       var commands = cy.commands ;
       var l = commands.unshift.apply(commands, [].slice.call(arguments)) ;
       var div = 1/l ;
       cy.unit = {index:div, deg:div * 360, rad:div * Math.PI * 2} ;
       return l ;
    },
    pop:function(){
       var cy = this ;
       var commands = cy.commands ;
       var command = commands.pop() ;
       var l = commands.length ;
       var div = 1/l ;
       cy.unit = {index:div, deg:div * 360, rad:div * Math.PI * 2} ;
       return command ;
    },
    shift:function(){
       var cy = this ;
       var commands = cy.commands ;
       var command = commands.shift() ;
       var l = commands.length ;
       var div = 1/l ;
       cy.unit = {index:div, deg:div * 360, rad:div * Math.PI * 2} ;
       return command ;
    },
    getPrev:function(n){
       var cy = this ;
       if(n === undefined) n = 1 ;
       n = -n ;
       
       if(isNaN(cy.playhead)){
          cy.playhead = 0 ;
       }
       var neo = cy.playhead + (n * cy.unit.rad) ;
       neo = neo % (Math.PI * 2) ;
       var s = this.seek(neo) ;
       s.dif = n ;
       return s ;
    },
    prev:function(n){
       var cy = this ;
       
       cy.ascend = !Boolean(n === undefined || n > 0) ;
       
       var item = cy.getPrev(n) ;
       var ind = item.index ;
       cy.increment = item.dif ;
       var c = cy.commands[ind].execute() ;
       
       cy.playhead = item.rad ;
       cy.index = ind ;
       return c ;
    },
    getNext:function(n){
       var cy = this ;
       
       if(n === undefined) n = 1 ;
       if(isNaN(cy.playhead)){
          cy.playhead = -cy.unit.rad ;
       }
       
       var neo = cy.playhead + (n * cy.unit.rad) ;
       neo = neo % (Math.PI * 2) ;
       var s = this.seek(neo) ;
       s.dif = n ;
       return s ;
    },
    next:function(n){
       var cy = this ;
       
       cy.ascend = Boolean(n === undefined || n > 0) ;
       
       var item = cy.getNext(n) ;
       var ind = item.index ;
       cy.increment = item.dif ;
       var c = cy.commands[ind].execute() ;
       cy.playhead = item.rad ;
       cy.index = ind ;
       return c ;
    },
    seek:function(rad){ // relative deg (degree) as relative position index in Array
       var cy = this ;
       var rad, ind ; 
       var pi2 = Math.PI * 2 ;
       var l = cy.commands.length ;
       
       if(rad < 0 ){
          rad = pi2 + rad ;
       }
       if(rad > pi2 || pi2 - rad < cy.unit.rad / 2 ){
          rad = 0 ;
       }
       
       ind = (rad % pi2) / Math.PI / 2 * l ; // ind is the exact SAFE position in Array, without notions of numerous circles
       
       return {index: Math.round(ind), rad: rad} ;
       
    },
    launch:function(ind){
    	var cy =  this ;
    	
    	cy.next(ind - cy.index) ;
    },
    toString:function()
    {
        var cy = this ;
        return '[object Cyclic]' ;
    }
}))) ;
// FOUNDATION CLASSES
var Foundation = NS('Foundation', NS('pro.fcartier::Foundation', Class.$extend({
    __classvars__:{version:'0.0.1',
        toString:function()
        {
            return '[class Foundation]' ;
        }
    },
    absolute:new RegExp(window.location.protocol + '//'),
    external:new RegExp(window.location.protocol + '//' + window.location.host),
    __init__:function()
    {
       //window.isSafariMobile = $(document.documentElement).hasClass('Mobile Safari') || $(document.documentElement).hasClass('android') ||  $(document.documentElement).hasClass('ios');
       window.isSafariMobile = /(Ip(hone|od))|Android|BlackBerry/gi.test(navigator.userAgent) ;
       
    },
    update:function(step, cond){
       if(cond === undefined) cond = true ;
       
       var level = step.depth ;
       var index = step.index ;
       var indicator = $('#indicnav ol') ;
       
       var li, a, strong, href = step.path.replace(/^\//i, '');
       
       indicator.find('.current').removeClass('current sizeXXLg').addClass('sizeM') ;
       
       if(cond){
       		li = $('<li class="navitem">') ;
       		strong = $('<strong class="Rmargin">'+ '&gt;' +'</strong>') ;
       		
       		a = $('<a href="' + href + '">'+ step.id.replace(/\//gi, '').toUpperCase() +'</a>').appendTo(li) ;
       		a.prepend(strong) ;
       		a.bind('click', function(e){
       			e.preventDefault() ;
       			
       			hierarchy.changer.setValue('/' + hierarchy.changer.locale + href) ;
       		}) ;
       		
       		li.appendTo(indicator) ;
       		li.addClass('current sizeXXLg') ;
       		
       }else{
       		var ch = indicator.children() ;
       		li = $(ch[level-1]) ;
       		li.remove() ;
       		$(ch[level-2]).removeClass('sizeM').addClass('current sizeXXLg') ;
       		
       }
       
       
       
    },
    detectNav:function(step, cond){
        var nn = this ;
        
        if(cond === undefined) cond = true ;
        
        var hidden = step.id === 'home' ? $('.sidenav ul li') : step.userData.cont.find('.hiddennav ul li') ;
        
        var div, canvasdiv;
        var arrowclosure, wheelclosure , touchstartclosure, touchmoveclosure, touchendclosure, resizeclosure, orientationclosure, mousedownclosure,
        mousestartclosure, mousemoveclosure, mouseendclosure;
        var cont = step.userData.cont ;
        if(cond){
           
           
           
           
           
           
           
        	if(Toolkit.Qexists(hidden)){
        		
        		var ppath = ((step.parentStep === step.ancestor)? '/home/' : step.parentStep.path).replace(/^\//i, '') ;
        		var levelized = (step.depth+1)*10 ;
        		var started = levelized - 1 ;
        		var ended ;
        		
        		div = step.userData.div = $('<div id="'+ step.path +'" class="navdiv shadow">').appendTo(step.userData.cont.find('.blocImg')) ;
        		var arrows = $('<div class="steparrows txtC">').appendTo(div) ;
        		var nav = step.userData.nav = $('<ul class="navstep txtC">').appendTo(div) ;
        		
        		
        		if(step.id !== 'home') {
        			var parent = $('<li class="topstep hierarchical" >').appendTo(nav) ;
        			var parenta = $('<a class="sizeXXLg" tabIndex="'+ parseInt(started - 1) +'">').appendTo(parent).attr({'href':ppath}).html('^') ;
        		}
        		
        		
        		var links = [] ;
        		
        		var unitH ;
        		
        		hidden.each(function(i, el){
        			var li = $(el).clone().addClass('navstepitem floatL sizeXXLg') ;
        			
        			
        			
        			var a = li.children('a').addClass('floatL') ;
        			
        			var title = a.html() ;
        			
        			ended = levelized + i ;
        			var href = a.attr('href').replace(/^\//i, '') ;
        			a.attr({'href':href}).attr({'tabIndex':ended}) ;
        			
        			if(i == 0) outgoing = href ;
        			if(i <  hidden.size()-1) li.append('<span class="floatL dispBlock">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>') ;
        			nav.append(li) ;
        			
        			a.html('&nbsp;') ;
        			unitH = a.height() ;
        			
        			a.html(title) ;
        			
        			var totH = a.height() ;
        			a.data('h', totH) ;
        			var indH = totH / unitH ;
        			
        			if(indH > 1) a.css({'top':-((indH-1) * .5)+'em'})
        			
        			a.bind('click', function(e){        				
        				e.preventDefault() ;
        				
        				hierarchy.changer.setValue('/'+ href) ;
        			}) ;
        			
        			links.push(li) ;
        		})
        		
        		
        		var next = $('<a class="steparrow stepnext dispBlock txtR sizeXXLg" tabIndex="'+ (ended+1) +'">').appendTo(arrows).attr({'href':ppath}).html('&gt;') ;
        		var prev = $('<a class="steparrow stepprev dispBlock txtL sizeXXLg" tabIndex="'+ started +'">').appendTo(arrows).attr({'href':ppath}).html('&lt;') ;
        		
        		if(step.id !== 'home')parenta.bind('click', function(e){
    				e.preventDefault() ;
    				hierarchy.changer.setValue('/'+hierarchy.changer.locale + parenta.attr('href')) ;
    			}) ;
        		
        		var loop = new Cyclic() ;
        		
        		var curLi ;
        		loop.add(
		            links.map(function(el, i){
		                var li = $(el) ;
		                
		                return new Command(li, function(n){
		                    	var c = this ;
		                    	
		                    	var index = loop.indexOf(c) ;
		                    	
		                    	if(curLi !== undefined) {
		                    		curLi.children('a').removeClass('HpaddingXXLg') ;
		                    		
		                    		if(window.desc !== undefined){
		                    			
		                    			window.desc.remove() ;
		                    			window.desc = undefined ;
		                    		}
		                    		
		                    	}
		                    	
		                    	var a = li.children('a') ;
		                    	var halfa = a.outerWidth() >> 1 ;
			                    	
									var curX = li.position().left + 40 + halfa ;
									a.addClass('HpaddingXXLg')[0].focus() ;
									
					        		nav.css({'left':-curX}) ;
					        		$('#frameInside').scrollLeft(0) ;
					        		
					        		var indH = a.data('h')  ;
					        		
					        		if(enter !== undefined) enter.css({'left':curX - 15, 'bottom':-(indH * .5)+'px' }) ;
		                    	if(parent !== undefined) parent.css({'left':curX - 15, 'top':-(indH * .5)+'px' }) ;
		                    	
		                    	arrows.css({width:(halfa*2)+'px', left:-(halfa)+'px'})
		                    	
		                    	curLi = li ;
		                    	
		                    	
		                    	
		                    	
		                    	var desc = li.children('.desc') ;
		                    	//if(0){
		                    	if(Toolkit.Qexists(desc)){
		                    		
		                    		window.desc = desc.clone().appendTo(cont).removeClass('dispNone') ;
		                    		
		                    	}
		                    	
		                    	if(window.spinner !== undefined) {
	                    			window.spinner.adapt(loop.increment, loop.ascend, index) ;
		                    	}
	                    	
	                    }, i)
		            })
		        ) ;
        		
        		
        		var enter = $('<li class="enterstep hierarchical">').appendTo(nav) ;
        		var entera = $('<a class="sizeXXLg" tabIndex="'+ parseInt(ended + 2) +'">').appendTo(enter).attr({'href':outgoing}).html('^').animate({'rotate':'180deg'}, 0) ;
        		
        		
        		if(window.isSafariMobile){

        			document.addEventListener('touchstart', touchstartclosure = function(e){
	        			
	        			
	        			var indixStartX = 0, curIndX = -1 , indixEndX = 0;
	        			

	        			
	        			var evStart = e ;
						var l = evStart.touches.length ;
						//var wereMoved = false ;
						
						if(l == 1){
						   //e.preventDefault();
							var tch = evStart.touches[0] ;
							indixStartX = tch.pageX ;
							
							document.addEventListener('touchmove', touchmoveclosure = function(e){
							   
							   
			        			var evMove = e ;
								var l = evMove.touches.length ;
								
								if(l == 1){
								   e.preventDefault();
									var tch = evMove.touches[0] ;
									curIndX = tch.pageX ;
								
			        			
				        			
			        			}
			        		}, false ) ;
			        		document.addEventListener('touchend', touchendclosure = function(e){
			        			
			        			var evEnd = e ;
								var l = evEnd.touches.length ;
			        			
			        			if(curIndX == -1){
			        				
			        			}else if(curIndX == indixStartX){
			        				
			        			} else if(curIndX < indixStartX){
			        				loop.next() ;
			        			}else{
			        				loop.prev() ;
			        			}
			        			
			        			
			        			document.removeEventListener('touchend', touchendclosure) ;
			        			document.removeEventListener('touchmove', touchmoveclosure) ;
			        			
			        		}, false ) ;
		        		}
		        		
		        		
	        		}, false ) ;
	        		
	        		
        		$(window).bind('orientationchange', orientationclosure = function(e){
        			
        			$(window).trigger('resizestart') ;
					$(window).trigger('resizeend') ;
	                
        		}) ;
	        		
        		}else{
        			/*
        			$(document).bind('mousedown', mousestartclosure = function(e){
        			
	        			if(e.target.tagName !== 'CANVAS') {
	        				e.preventDefault() ;
	        				return ;
	        			}
	        			
	        			var hacked = false ;
	        			var indixStartX = e.originalEvent.pageX, curIndX = -1 , indixEndX = 0;
	        			var unitX = (window.innerWidth) / loop.loopables.length ;
	    				
	    				$(document).bind('mousemove', mousemoveclosure = function(e){
	        				hacked = true ;
	        				
	        				var curIndX = e.originalEvent.pageX ;
	        				var dif = curIndX - indixStartX ;
	        				
	        				if(dif > unitX){
	        					lopen.next() ;
	        					indixStartX += unitX ;
	        				}else if (dif < -unitX) {
	        					loop.prev() ;
	        					indixStartX -= unitX ;
	        				}else{
	        					
	        				}
	        			}) ;
		        		
		        		$(document).bind('mouseup', mouseendclosure = function(e){
		        			if(hacked){
		        				e.preventDefault() ;
		        			}
		        			
		        			$(document).unbind('mouseup', mouseendclosure) ;
		        			$(document).unbind('mousemove', mousemoveclosure) ;
		        			
		        		}) ;
	        			
	        		}) ;
	        		*/
        		}
        		
        		
        		enter.bind('click', function(e){
        			e.preventDefault() ;
        			
        			
        			
        			links[loop.index].children('a').trigger('click') ;
        		})
        		
        		
        		
        		next.bind('click', function(e){
        			e.preventDefault() ;
        			
        			loop.next() ;
        			
        		})
        		
        		
        		prev.bind('click', function(e){
        			e.preventDefault() ;
        			
        			loop.prev() ;
        		})
        		
        		
        		$(document).bind('keydown', arrowclosure = function(e){
        			
        			
				    if (e.keyCode == 37) {
				    	e.preventDefault() ;
				       trace( "left pressed" );
				       
				       loop.prev() ;
				    }
				    if (e.keyCode == 38) {
				    	e.preventDefault() ;
				       trace( "up pressed" );
				       
				       if(parent !== undefined) parenta.trigger('click') ;
				    }
				    if (e.keyCode == 39) {
				    	e.preventDefault() ;
				       trace( "right pressed" );
				       
				       loop.next() ;
				    }
				    if (e.keyCode == 40) {
				    	e.preventDefault() ;
				       trace( "down pressed" );
				       
				       enter.trigger('click') ;
				    }
				});

        		$(document).bind('mousewheel', wheelclosure = function(e, delta){
        			e.preventDefault() ;
        			
				   if (delta > 0) {
				    	loop.prev() ;
				   }else if(delta < 0){
				    	loop.next() ;
				   }
				});
        		
        		
        		$(window).bind('resizestart', resizeclosure = function(e){
        			
        			var okspinners = false ;
        			
        			
        			if(window.spinner !== undefined) {
	                  	okspinners = true ;
	                  	nn.spinners(step, false) ;
	                }
	                
	                $(window).bind('resizeend', function(e){
	                	$(window).unbind('resizeend', arguments.callee) ;
	                	
        				if(okspinners === true) {
		                  	nn.spinners(step, true) ;
		                }
		                
		                loop.next(0) ;
	        		}) ;
	                
        		}) ;
        		
        		$(document).bind('click', mousedownclosure = function(e) {
					
					if(e.target.tagName === "A") return ;
					if(window.spinner !== undefined){
						var ind = window.spinner.detectClick(e) ;
						
						if(ind !== -1) {
							
							trace(ind, loop.index)
							
							loop.launch(ind) ;
						}
					}
					
				} );
				
				
            	step.userData.canvasdiv = $('<div class="abs fullW fullH" id="canvas"><!-- --></div>').appendTo(cont.find('.content')) ;
        		
            	step.userData.uidTimeout = setTimeout(function(){
            		step.userData.uidTimeout = -1 ;
            		nn.spinners(step, true) ;
            		
            		
            		if(window.current !== undefined) {
            			//alert(loop.commands[window.current])
            			try{
            				loop.launch(window.current) ;
            			}catch(e){
            				alert(e)
            			}
            			
            		}else {
            			loop.next() ;
            		}
        			
            	}, 15) ;
            	
        	}
        }else{
        	if(Toolkit.Qexists(hidden)){
        		
				if(window.desc !== undefined){
					window.desc.remove() ;
					window.desc = undefined ;
				}
				
        		if(step.userData.uidTimeout !== -1){
        			clearTimeout(step.userData.uidTimeout)
        		}else{
	        		nn.spinners(step, false) ;
	        		
        		}
        		step.userData.canvasdiv.remove() ;
        		
        		div = step.userData.div ;
        		div.remove() ;
        		
        		$(document).unbind('keydown', arrowclosure) ;
        		$(document).unbind('mousewheel', wheelclosure) ;
        		$(window).unbind('resizestart', resizeclosure) ;
        		$(document).unbind('click', mousedownclosure) ;
        		
        		if(window.isSafariMobile){
        			$(window).unbind('orientationchange', orientationclosure) ;
        			document.removeEventListener('touchstart', touchstartclosure) ;
        		}else{
        			//$(document).unbind('mousedown', mousestartclosure) ;
        		}
        		 
        	}
        	
        	
        }
    },
    spinners:function(step, cond){
    	
        var cont = step.userData.cont ;

    	if(cond === true){
    		var id = step.id ;
    		switch(id){
    			case 'home' :
    				window.spinner = new Spinner3D('#canvas', '#FFFFFF', .3, step.parentStep.children.length - 1, 70, 'thinplane', 'lambert').start() ;
    			break;
    			default :
    				window.timemachine = new Spinner('#canvas', '#A40133', .3).start() ;
    				window.spinner = new Spinner3D('#canvas', '#A40133' , .6, step.children.length, 70, step.depth > 1 ? 'thickplane' : 'cube', 'basic').start() ;
    			break;
    		}
    		
    	}else{
    		
    		if(window.spinner !== undefined) {
              	if(window.timemachine !== undefined) {
              		
              		window.timemachine.stop().canvas.remove() ;
              		window.timemachine = undefined ;
              		delete window.timemachine ;
              	}
              	
              	window.spinner.stop().canvas.remove() ;
              	window.spinner = undefined ;
              	delete window.spinner ;
              	
            }
    	}
    },
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
})));

var BaseStep = NS('BaseStep', NS('pro::BaseStep', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class BaseStep]' ;
        }
    },
    status: '' ,
    looping: true ,
    __init__:function(id, label, layout)
    {
        this.$super(id, new Command(this, this.onStep), new Command(this, this.onStep, false)) ;
        this.label = label ;
        this.userData.layout = '' ;
    },
    onStep:function(cond){
        if(cond === undefined) cond = true ;
        var c = this ;
        var step = c.context ;
       
        
        var hh = window.hierarchy ;
        var cont ;
        var url = step.path.replace(/^\//i, '') ;
        
        
        
        switch(step.userData.layout){
        	case 'final' :
        	     
        	break ;
        	default :
        		
        		
        		if(cond){
            
		            //window.foundation.update(step) ;
		            
		            $(document.documentElement).addClass(step.id) ;
		            
		            new AjaxCommand('./content/' + hierarchy.changer.locale + url, function(jxhr){
		            	
		            	cont = step.userData.cont = $('<div class="rel">').appendTo(content).addClass('dispNone fullH') ;
		            	cont.append(jxhr.responseText) ;
		            	
		            	
		            	
		            	
		            	var block = cont.find('.blocImg').addClass('fullH fullBg') ;
		            	
		            	
		            	cont.animate({'opacity':0}, 0) ;
		            	
		            	step.addSteps(cont) ;
		            	
		            	step.addEL('focusIn', step.userData.focusIn = function(e){
		            		cont.removeClass('dispNone') ;
		            		
		            		//window.foundation.detectNav(step) ;
		            		cont.animate({'opacity':1}, 'fast', undefined, function(){
		            		
				              	//step.dispatchClearedIn() ;
				            }) ; 
		            	}) ;
		            	
		            	step.addEL('focusOut', step.userData.focusOut = function(e){
		            		cont.animate({'opacity':0}, 'fast', undefined, function(){
			                  cont.addClass('dispNone') ;
			                  
			                  //window.foundation.detectNav(step, false) ;
			                  step.dispatchClearedOut() ;
			               }) ;
		            	}) ;
		            	
		            	setTimeout(function(){
			               trace('step opened', step.label)
			                c.dispatchComplete() ;
			            }, 1) ;
		            	
		            	
		            	
		            }).execute() ;
		            
		            
		            
		            
		        }else{
		        	
		       		//window.foundation.update(step, false) ;
		            
		            cont = step.userData.cont ;
		            cont.remove() ;
		            
		            
		            step.removeEL('focusIn', step.userData.focusIn) ;
		            step.removeEL('focusOut', step.userData.focusOut) ;
		            
		            setTimeout(function(){
		               
		               $(document.documentElement).removeClass(step.id) ;
		               step.empty(true) ; // remove loaded steps
		               trace('step closed', step.label)
		               c.dispatchComplete() ;
		               
		            }, 1) ;
					
		        }
        		
        		
        		
        	break;
        }
        
        
        
        
        return this ;
    },
    addSteps:function(cont){
       var st = this ;
       var nodes = cont.find('.ajaxian a') ;
       
       nodes.each(function(i, el){
       		var a = $(el) ;
        	var href = a.attr('href') ;
        	var path = href.replace(window.hierarchy.changer.locale, '') ;
        	var label = a.attr('title').toLowerCase() ;
        	var layout = a.attr('rel') ;
        	
        	var step = st.add(new BaseStep(label, path, layout)) ;
       }) ;
    },
    toString:function()
    {
        var st = this ;
        return '[BaseStep >>> id:'+ st.id+' , path: '+st.path +' , label: '+st.label + ' , ' + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
    }
}))) ;

var Unique = NS('Unique', NS('pro::Unique', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        instance:undefined,
        getInstance:function(){ return Unique.instance || new Unique() },
        toString:function()
        {
            return '[class Unique]' ;
        }
    },
    __init__:function()
    {
        this.$super('', new Command(this, this.onStep)) ;
        Unique.instance = this ;
        
        window.foundation = new Foundation() ;
        
        trace('UNIQUE INSTANCIATED...') ;
    },
    onStep:function(){
        trace('UNIQUE STEP OPENING') ;
        
        
        var c = this ;
        var u = c.context ;
        
        u.addSteps() ;
        
        setTimeout(function(){
            c.dispatchComplete() ;
        }, 0);
        
        
        return this ;
    },
    addressComplete:function(e){
       trace('command complete') ;
    },
    addSteps:function(){
    	
        var st = this ;
        
        var toplinks = $('#sidenav .ajaxian a') ;
        trace(toplinks) 
        toplinks.each(function(i, el){
        	var a = $(el) ;
        	var href = a.attr('href').replace(/^\/i/, '') ;
        	var path = href.replace(window.hierarchy.changer.locale, '') ;
        	var label = a.attr('title').toLowerCase() ;
        	var layout = a.attr('rel') ;
        	var step = st.add(new BaseStep(label, path, layout)) ;
        	
        	a.bind('click', function(e){
        		e.preventDefault() ;
        		
        		hierarchy.changer.setValue(href.replace(/^\//i, '/')) ;
        	}) ;
        	
        }) 
        
        trace('Steps should have been added...')
    },
    toString:function()
    {
        var st = this ;
        return '[Unique >>> id:'+ st.id+' , path: '+ st.path + ((st.children.length > 0) ? '[\n'+ st.dumpChildren() + '\n]' + ']' : ']') ;
    }
}))) ;


/* GEEKS*/

var Spinner = NS('Spinner', NS('test::Spinner', Class.$extend({
    __classvars__ : {
        version:'0.0.1',
        toString:function(){
            return '[class Spinner]' ;
        }
    },
    __init__ : function(id, color, alpha) {
    	var sp = this ;
        var tg = sp.tg = $(id) ;
        var color = color || "DodgerBlue" ;
        var alpha = alpha || 1 ;
        var canvas =  document.createElement('canvas') ;
        sp.canvas = $(canvas).addClass('abs top0 left0');
        var __w = canvas.width = tg.width() ;
        var __h = canvas.height = tg.height() ;
        var PiDiv3 = Math.PI*2/3;
        var PiDiv5 = Math.PI*2/5;
        var midW = __w >> 1 ;
        var midH = __h >> 1 ;
        
        
        
        var radius = 140 ;
        var thickness = 2 ;
        
        var ctx = canvas.getContext('2d') ;
        
        tg.append(canvas) ;
        
        
        ctx.strokeStyle = color ;
        ctx.globalAlpha = alpha ;
        
        var startrandom = Math.random() * (Math.PI*2);
        
        var rotation = {x:startrandom} ;
        
        var uid = -1 ;
        
        ctx.translate(midW,midH) ;
        ctx.save() ;
        
        
        var render = sp.render = function (){
        	
        	rotation.x += (Math.PI*2)/60 ;
        	
            ctx.clearRect ( -midW , -midH , __w , __h);
            
            var x = rotation.x ;
            
            fillArc(thickness * 6 , radius *.9, -x+5, 15, -1) ;
            fillArc(thickness * 3 , radius , x, PiDiv3, 1) ;
            fillArc(thickness * 2 , radius *.75, -(x*2), PiDiv3, 1) ;
            fillArc(thickness * 4 , radius, x+Math.PI, PiDiv5, 1) ;
            
            fillArc(thickness , radius/2, x+Math.PI/45, PiDiv3, -1) ;
            fillArc(thickness * 3 , radius/2, x-Math.PI/78, PiDiv5, 1) ;
            
            //ctx.restore() ;
        }
        function fillArc(thickness, rad, start, stop , direction){
            
            var angle = start + (stop * direction);
            
            ctx.beginPath() ;
            ctx.lineWidth  = thickness ;
            
            ctx.arc(0, 0, rad, start, angle) ;
			
            ctx.stroke() ;
            ctx.closePath() ;
        } ;
        
        return this ;
    },
    start : function(){
    	var sp = this ;
    	sp.render() ;
    	var dur = 1000 ;
    	window.interval2 = setInterval(function(){
    		sp.render() ;
        	
        }, dur) ;
    	
        return this ;
    },
    stop : function(){
    	var sp = this ;
        
        clearInterval(window.interval2) ;
        
        return this ;
    },
    getElement : function(){
        return this.tg ;
    },
    getCanvas : function(){
        return this.canvas ;
    },
    toString : function(){
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;
var Spinner2 = NS('Spinner2', NS('test::Spinner2', Class.$extend({
    __classvars__ : {
        version:'0.0.1',
        toString:function(){
            return '[class Spinner2]' ;
        }
    },
    __init__ : function(id, color) {
    	var sp = this ;
        var tg = sp.tg = $(id) ;
        var color = color || "DodgerBlue" ;
        var canvas =  document.createElement('canvas') ;
        sp.canvas = $(canvas).addClass('abs top0 left0') ;
        var __w = canvas.width = tg.width() ;
        var __h = canvas.height = tg.height() ;
        var PiDiv3 = Math.PI*2/3;
        var PiDiv5 = Math.PI*2/5;
        var midW = __w >> 1 ;
        var midH = __h >> 1 ;
        
        
        
        var radius = 140 ;
        var thickness = 2 ;
        
        var ctx = canvas.getContext('2d') ;
        
        tg.append(canvas) ;
        
        ctx.strokeStyle = color ;
        
        var startrandom = Math.random() * (Math.PI*2);
        
        var rotation = {x:startrandom} ;
        
        var uid = -1 ;
        
        ctx.translate(midW,midH) ;
        ctx.save() ;
        
        
        var render = sp.render = function (){
        	
        	rotation.x += (Math.PI*2)/60 ;
        	
            ctx.clearRect ( -midW , -midH , __w , __h);
            
            var x = rotation.x ;
            
            fillArc(thickness * 6 , radius *.9, -x+5, 15, -1) ;
            fillArc(thickness * 3 , radius , x, PiDiv3, 1) ;
            fillArc(thickness * 2 , radius *.75, -(x*2), PiDiv3, 1) ;
            fillArc(thickness * 4 , radius, x+Math.PI, PiDiv5, 1) ;
            
            fillArc(thickness , radius/2, x+Math.PI/45, PiDiv3, -1) ;
            fillArc(thickness * 3 , radius/2, x-Math.PI/78, PiDiv5, 1) ;
            
            //ctx.restore() ;
        }
        function fillArc(thickness, rad, start, stop , direction){
            
            var angle = start + (stop * direction);
            
            ctx.beginPath() ;
            ctx.lineWidth  = 8 ;
            
            ctx.dottedArc(0, 0, rad, start, angle) ;
            
            
            ctx.stroke() ;
            ctx.closePath() ;
        } ;
        
        
        
        return this ;
    },
    start : function(){
    	var sp = this ;
    	sp.render() ;
    	var dur = 1000 ;
    	window.interval2 = setInterval(function(){
    		sp.render() ;
        	
        }, dur) ;
    	
        return this ;
    },
    stop : function(){
    	var sp = this ;
    	
    	clearInterval(window.interval2) ;
    	
        return this ;
    },
    getElement : function(){
        return this.tg ;
    },
    getCanvas : function(){
        return this.canvas ;
    },
    toString : function(){
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;
var Spinner3D = NS('Spinner3D', NS('test::Spinner3D', Class.$extend({
    __classvars__ : {
        version:'0.0.1',
        toString:function(){
            return '[class Spinner3D]' ;
        }
    },
    __init__ : function(id, color, alpha, max,  factor, geom, shader) {
    	var sp = this ;
        var tg = sp.tg = $(id) ;
        var color = sp.color = ('0x'+color.replace(/#/, '')) || "0xFFFFFF" ;
        
        var alpha = sp.alpha = alpha || .5 ;
        var factor = factor || 2000 ;
        
        
        ////////////////////////
			var container;
			var camera, scene, projector, renderer;
			var particleMaterial;

			var objects = sp.objects = [];

			
			container = tg ;
			

			camera = sp.camera = new THREE.PerspectiveCamera( factor, window.innerWidth / window.innerHeight, 1, 10000 );
			camera.position.set( 0, 300, 500);

			scene = sp.scene = new THREE.Scene();

			scene.add( camera );
			
			if(!window.isSafariMobile){
				var directionalLight = sp.directionalLight =  new THREE.DirectionalLight( 0xffffff , 1);
				//directionalLight.position.x = Math.random() - 0.5;
				directionalLight.position.x = 0;
				// directionalLight.position.y = Math.random() - 0.5;
				directionalLight.position.y = 0;
				// directionalLight.position.z = Math.random() - 0.5;
				directionalLight.position.z = 400;
				directionalLight.position.normalize();
				scene.add( directionalLight );
				
				var pointLight = sp.pointLight =  new THREE.PointLight( 0xFFFFFF, 1 );
				pointLight.position.z = -450;
				pointLight.position.y = 250;
				scene.add( pointLight );
			
				
			}
			
			//var geometry = new THREE.CubeGeometry( 100, 100, tick );
			
			
			
			
			        
                    
                    
                    
                    
                    
                    var geometry ;
                    switch(geom){
                    	
                    	case 'star' :
	                    	var californiaPts = [new THREE.Vector2 ( 31, -95)];
					        
					        var intersections = 10 ;
					        
					        for(var j = 0 ; j < intersections ; j++){
					        	
					        	var rand = Math.random() * 50 ;
					        	var ind = (j)/intersections ;
					        	
					        	var dia = 100 + ((j % 2 == 0)? 0: -60) ;
					        	
					        	var rX = Math.cos((Math.PI * 2) * ind) * dia ;
					        	var rY = Math.sin((Math.PI * 2) * ind)  * dia;
					        	
					        	var pX = Math.round(rX) ;
					        	var pY = Math.round(rY) ;
					        	trace(j, pX, pY, dia)
					        	
					        	
					        	californiaPts.push( new THREE.Vector2 ( pX, pY) );
					        	
					        }
		                    
		                    var star = new THREE.Shape( californiaPts );
                    		var geometry = new THREE.ExtrudeGeometry(star, {amount:6, bevelEnabled:false});
                    	break;
                    	case 'plane' :
                    		var geometry = new THREE.CubeGeometry( 100, 100, 1);
                    	break;
                    	case 'thickplane' :
                    		var geometry = new THREE.CubeGeometry( 100, 100, 10);
                    	break;
                    	case 'thinplane' :
                    		var geometry = new THREE.CubeGeometry( 100, 100, 2);
                    	break;
                    	case 'cube' :
                    		var geometry = new THREE.CubeGeometry( 100, 100, 100);
                    	break;
                    	
                    }
			
			
			for ( var i = 0; i < max; i ++ ) {
				
				var mat ;
				if(window.isSafariMobile || shader !== 'lambert'){
					mat = new THREE.MeshBasicMaterial({color:color, opacity:alpha }) ;
				}else{
					mat = new THREE.MeshLambertMaterial( {opacity:alpha, shading:THREE.FlatShading, color:color }) ;
				}
				
				var object = new THREE.Mesh( geometry, mat );
				
				var rad = 250 ;
				var ind = i/max ;
				
				var x = Math.cos(ind * Math.PI * 2) * rad ;
				var y = Math.sin(ind * Math.PI * 2) * rad ;
				var z = 0 ;//Math.cos(ind * Math.PI * 2) * rad ;
				
				object.position.x = x ;
				object.position.y = y ;
				object.position.z = x ;

				object.scale.x = Math.random() * 2 + 1;
				object.scale.y = Math.random() * 2 + 1;
				object.scale.z = Math.random() * 2 + 1;
				
				object.rotation.x = ( Math.random() * 360 ) * Math.PI / 180;
				object.rotation.y = ( Math.random() * 360 ) * Math.PI / 180;
				//object.rotation.z = ( Math.random() * 360 ) * Math.PI / 180;

				object.hover =  function(cond){
					var n = this ;
					if(cond){
						n.originalAlpha = n.material.opacity ;
						//n.originalColor = n.material.color.getHex() ;
						n.material.opacity = n.originalAlpha + .4 ;
						//n.material.color.setHex('0xA40133') ;
						n.overed = true ;
					}else{
						if(n.originalAlpha !== undefined ){
							n.material.opacity = n.originalAlpha ;
							//n.material.color.setHex(n.originalColor) ;
							n.originalAlpha = undefined ;
							//n.originalColor = undefined ;
							n.overed = false ;
						}
					}
				}
				/**/
				/*
				object.position.x = Math.random() * 800 - 400;
				object.position.y = Math.random() * 800 - 400;
				object.position.z = Math.random() * 800 - 400;

				object.scale.x = Math.random() * 2 + 1;
				object.scale.y = Math.random() * 2 + 1;
				object.scale.z = Math.random() * 2 + 1;

				object.rotation.x = ( Math.random() * 360 ) * Math.PI / 180;
				object.rotation.y = ( Math.random() * 360 ) * Math.PI / 180;
				object.rotation.z = ( Math.random() * 360 ) * Math.PI / 180;
				*/
				
				
				scene.add( object );

				objects.push( object );

			}

			projector = sp.projector = new THREE.Projector();

			renderer = new THREE.CanvasRenderer();
			renderer.setSize( tg.width(), tg.height());
			
			sp.canvas = $(renderer.domElement).addClass('abs top0 left0') ;
			
			sp.canvas.appendTo(container) ;


			

			//

			function animate() {

				requestAnimationFrame( animate );
				render();

			}
			var radius = 1200 ;
			if(window.isSafariMobile){
	    		radius = 600 ;
	    	}
	    	
			var theta = sp.theta = 0;
			var ind = sp.ind =  1 ;
			var speed = sp.speed = 0 ;
			
			sp.old = -1 ;
			
			
			var ctx = sp.canvas.context.getContext('2d') ;
			ctx.strokeStyle = "#A40133" ;
			
			var render = sp.render = function() {
				ctx.clearRect ( 0 , 0, window.innerWidth, window.innerHeight);
				if(sp.speed > 0) sp.speed *= .8 ;
				else if(sp.speed < 0) sp.speed *= .8 ;
				else{
					sp.speed = 0 ;
				}
				
				sp.theta += (0.2 + sp.speed) * sp.ind;
				
				
				var l = sp.objects.length ;
				
				for ( var i = 0; i < l; i ++ ) {
					
					var o = sp.objects[i] ;
					
					o.rotation.x += (Math.random() * 100)/36000 ;
					o.rotation.y += (Math.random() * 100)/36000 ;
					
				}
				
				
				
				
				camera.position.x = radius * Math.sin( sp.theta * Math.PI / 360 );
				camera.position.y = radius * Math.sin( sp.theta * Math.PI / 360 );
				camera.position.z = radius * Math.cos( sp.theta * Math.PI / 360 );
				
				
				
				sp.camera.lookAt( sp.scene.position );
				if(!window.isSafariMobile){
					sp.directionalLight.position = sp.scene.position ;
					sp.directionalLight.lookAt(sp.camera.position) ;
					
					sp.pointLight.position = sp.camera.position ;
					sp.pointLight.lookAt(sp.scene.position) ;
				}
				
				renderer.render( sp.scene, camera );
				
				
				
				
				if(window.desc !== undefined){
					
					var item = sp.cur ;
					var	p3D = new THREE.Vector3(item.position.x, item.position.y, item.position.z) ;
					var p2D = projector.projectVector(p3D, camera);
					//p3D = projector.unprojectVector(p2D, camera);
					
					//need extra steps to convert p2D to window's coordinates
					p2D.x = (p2D.x + 1)/2 * window.innerWidth;
					p2D.y = - (p2D.y - 1)/2 * window.innerHeight;
					
					
					ctx.beginPath() ;
		            ctx.lineWidth = 2 ;
		            
					var indic = window.desc.find('.indicator') ;
					var spr = window.desc.find('.t1') ;
					var left = spr.position().left ;
					var top = spr.position().top ;
		            var x = left + indic.position().left + (indic.width() >> 1) ;
					var y = top + indic.position().top + (indic.height() >> 1) ;
		            //var y = window.desc.position().top + window.desc.outerHeight() ;
		            
					
		            //ctx.moveTo(x - 150, y) ;
		            //ctx.lineTo(x + 150, y ) ;
		            ctx.moveTo(x, y) ;
		            ctx.lineTo(p2D.x , p2D.y ) ;
		            
		            //trace(ctx.drawCircle)
		            
		            
		            ctx.stroke() ;
		            ctx.closePath() ;
					
					
				}
				/**/
			}
			
			
			sp.once = true ;
			
        
    },
    adapt : function(n, ascend, ind){
      
    	var sp = this ;
    	var nuspeed = 20 ;
    	var objs = sp.objects ;
    	
    	
    	var item = objs[ind] ;
    	var speed = sp.speed ;
    	
    	var max = nuspeed * 3;
    	
    	if(ascend === true){
			sp.ind = 1 ;
			sp.speed += nuspeed * n;
    	}else if(ascend === false){
			sp.ind = - 1 ;
			sp.speed -= nuspeed * n;
    	}
    	
    	if(sp.speed > max) {
    		//trace('reached max up')
    		sp.speed = max ;
    	}
    	if(sp.speed < -max) {
    		//trace('reached max down')
    		sp.speed = -max ;
    	}
    	
    	//trace(sp.speed)
    	//alert(ind)
    	var l = objs.length ;
    	for(var i = 0 ; i < l ; i++){
    		var o = objs[i] ;
    		if(i == ind){
    			if(o.overed !== true) o.hover(true) ;
    		}else{
    			if(o.overed === true) o.hover(false) ;
    		}
    	}
    	sp.cur = item ;
    	//var vector = new THREE.Vector3( ( item.position.x / window.innerWidth ) * 2 - 1, - ( item.position.y / window.innerHeight ) * 2 + 1, 0.5 );
		
		
		
		
		
		
		//trace(p2D.x, p2D.y)
		
		
		
		
		
    	
    },
    detectClick:function(e){
    	var sp = this ;
    	
    	var cam = sp.camera ;
    	var objs = sp.objects ;
    	var l = objs.length ;
    	
    	var vector = new THREE.Vector3( ( e.clientX / window.innerWidth ) * 2 - 1, - ( e.clientY / window.innerHeight ) * 2 + 1, 0.5 );
		sp.projector.unprojectVector( vector, cam );
	
		var pos = cam.position ;
		
		var ray = new THREE.Ray( pos, vector.subSelf(pos).normalize() );
	
		var intersects = ray.intersectObjects( objs );
		
		var ind = -1 ;
		
		
		if ( intersects.length > 0 ) {
			var tch = intersects[ 0 ] ;
			var obj = tch.object ;
			
			for(var i = 0 ; i < l ; i ++){
				var o = objs[i] ;
				
				if(o === obj){
					return i ;
				}
			}
		}
		return -1 ;
    },
    start : function(){
    	var sp = this ;
    	
    	var dur = window.isSafariMobile ? 10 : 5 ;
    	window.interval = setInterval(function(){
    		sp.render() ;
        }, dur) ;
    	
        return this ;
    },
    stop : function(){
    	var sp = this ;
     	
    	clearInterval(window.interval) ;
    	
        return this ;
    },
    getElement : function(){
        return this.tg ;
    },
    getCanvas : function(){
        return this.canvas ;
    },
    toString : function(){
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;

// HELPERS FUNCTIONS
function hideContent(cond){
   
   if(cond === undefined) cond = true ;
   
   if(cond){
      $('#all').addClass('dispNone') ;
      window.homeContent = window.homeContent || $('#content').children().remove() ;
   }else{
      $('#all').removeClass('dispNone') ;
   }
}

function loadJSON(url, cb){
   $.ajax({
        url: url,
        dataType: 'json',
        success: cb
   });
}
function simulateJSON(url, cb){
   trace('SimulatingJSON > '+url) ;
   var obj = {} ;
   var navitems = $('#sidenav .ajaxian a') ;
   navitems.each(function(i, el){
   	 var a = $(el) ;
   	 var href = a.attr('href').replace(window.hierarchy.changer.locale, '') ;
   	 var label = a.attr('rel') ;
   	 obj[label] = href ;
   })
   
   setTimout(function(){cb(obj)}, 500) ;
   
}


