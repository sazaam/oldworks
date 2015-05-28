

(function(name, definition){
	
	if ('function' === typeof define){ // AMD
		define(definition) ;
	} else if ('undefined' !== typeof module && module.exports) { // Node.js
		module.exports = ('function' === typeof definition) ? definition() : definition ;
	} else {
		if(definition !== undefined) this[name] = ('function' === typeof definition) ? definition() : definition ;
	}

})('graphics', function(){
	
	var increment_r = /^(\+|\-)\=/ ;
	
	var upwards = function(n){
		var current = AddressHierarchy.instance.currentStep ;
		

	}

	var downwards = function(n){
		var current = AddressHierarchy.instance.currentStep ;
		

	}

	var change = function(step){
		var changer = AddressHierarchy.instance.changer ;
		changer.setStepValue(step) ;
		
	}

	var seek = function(n){
		var current = AddressHierarchy.instance.currentStep ;
		var parent = current.parentStep ;
		var depth = current.depth ;
		var siblings = parent.getLength() ;
		if(n instanceof Step){
			return change(n) ;
		}
		
		if('string' == typeof n){
			if(increment_r.test(n)){
				var sign, num = n.replace(increment_r, function(){
					sign = arguments[1] ;
					return '' ;
				}) ;
				return seek(current.index + parseInt(sign + num)) ;
			}
			return change(parent.getChild(n)) ;
		}else if('number' == typeof n){
			
			if(n < 0){
				if(current.depth == 2) return change(parent) ;
				return false ;
			}else if(n > siblings - 1){
				return false ;
			}
			return change(parent.getChild(n)) ;
			
		}
		
	}

	var proj ;
	var ALLTW ;
	var PROJECTALLTW ;
	
	var tweenAll = function(quant){
		var all = $('#all') ;
		if(!!ALLTW && ALLTW.isPlaying) ALLTW.stop() ;
		return ALLTW = BetweenJS.to(all, {'top::%':quant}, .4, Expo.easeOut) ;
	}
	var tweenProjectAll = function(p, quant){
		
		if((!!PROJECTALLTW && PROJECTALLTW.isPlaying)) PROJECTALLTW.stop() ;
		proj = p ;
		return PROJECTALLTW = BetweenJS.to(p, {'left::%':quant}, .25, Expo.easeOut) ;
	}
	return {
		start: function(){
			var win = window, doc = document, html = document.documentElement, body = document.body ;
			var ww = $(win) ;
			var dd = $(doc.body) ;
			var trans = 1.25 ;
			var ease = Quint.easeOut ;
			
			$('#momoko .centerblock').css('background-image', 'url("./img/kamon2.png")') ;
			
			// return ;
			
			if(Express.app.Qexists('.project')){
				
				var all = $('#all') ;
				var projects = $('.project') ;
				
				dd.addClass('pointable') ;
				
				var prevproject = $('.prevproj') ;
				var nextproject = $('.nextproj').removeClass('dispNone') ;
				var proj ;
				var projecttw, pagetw ;
				var infotwin, infotwout ;
				var projectindex = 0, projectl = projects.size() ;
				
				
				var getCurrentPageIndex = function(){
					return proj.data('pageindex') ;
				}
				
				
				all.data('projectswitch', function(forward){
					
					if(forward === undefined) forward = true ;
					
					if(forward){
						if(projectindex >= projectl - 1) return ;
						if(!!projecttw && projecttw.isPlaying) projecttw.stop() ;
						projecttw = BetweenJS.to(all, {'top::%':-(projectindex + 1 ) * 100}, .55, Expo.easeInOut).play() ;
						//if(!!proj && !!proj.data('reset')) proj.data('reset')() ;
						projectindex++ ;
						all.data('projectcheck')(projectindex) ;
						proj = $(projects[projectindex]) ;
					}else{
						if(projectindex < 1) return ;
						if(!!projecttw && projecttw.isPlaying) projecttw.stop() ;
						projecttw = BetweenJS.to(all, {'top::%':-( projectindex - 1) * 100}, .55, Expo.easeInOut).play() ;
						//if(!!proj && !!proj.data('reset')) proj.data('reset')() ;
						projectindex-- ;
						all.data('projectcheck')(projectindex) ;
						proj = $(projects[projectindex]) ;
					}
					
				}) ;
				
				all.data('projectcheck', function(n){
					
					if(n == 0) {
						nextproject.children('a').addClass('momocolor') ;
						$('.help').removeClass('dispNone') ;
						prevproject.addClass('dispNone') ;
					}else {
						$('.help').addClass('dispNone') ;
						nextproject.children('a').removeClass('momocolor') ;
						if(prevproject.hasClass('dispNone')) prevproject.removeClass('dispNone') ;
					}
					
					if(n == projectl - 1) nextproject.addClass('dispNone') ;
					else if(nextproject.hasClass('dispNone'))  nextproject.removeClass('dispNone') ;
					
				}) ;
				
				all.data('projectcheck')(0) ;
				
				
				
				var infotweens = [] ;
				var infoblocks = $('.info') ;
				var helpbox = $('.helpbox') ;
				var imgblocks = $('.imghold') ;
				var centerblocks = $('.centerblock, .projectarr') ;
				
				projects.each(function(i, el){
					var project = $(el) ;
					
					var curinfoblocks = project.find('.info') ;
					var curimgblocks = project.find('.imghold') ;
					var curcenterblocks = project.find('.centerblock') ;
					var arrows = $('.projectarr') ;
					var projectinside = project.find('.projectinside') ;
					var pages = project.find('.page') ;
					
					var index = 0 ;
					var l = pages.size() ;
					
					project.data('length', l) ;
					project.data('pageindex', 0) ;
					
					var projectinfo = project.find('.read') ;
					var contblock = project.find('.contblock') ;
					
					var contblockinsides = contblock.children() ;
					// si contient plusieurs pages
					if(l > 1){
						var pageprev = project.find('.prev') ;
						var pagenext = project.find('.next') ;
						
						project.data('updatableinfos', contblockinsides.size() > 1) ;
						
						
						project.data('pageswitch', function(decal){
							
							var forward = decal - index > 0 ; 
							if(forward){
								if(decal >= l) return ;
								if(!!pagetw && pagetw.isPlaying && (decal < l)){
									pagetw.stop() ;
								}
								pagetw = BetweenJS.to(projectinside, {'left::%':-(decal) * 100}, .3, Expo.easeOut) ;
								if(project.data('updatableinfos')){
									pagetw = BetweenJS.serial(
										BetweenJS.func(function(){
											contblockinsides.removeClass('hidden') ;
										}),
										BetweenJS.parallel(
											BetweenJS.delay(pagetw, .01), 
											BetweenJS.to(contblock, {'left::%':-(decal) * 100}, .3, Expo.easeInOut)
										),
										BetweenJS.func(function(){
											contblockinsides.each(function(indx, ell){
												// if(indx != getCurrentPageIndex()) $(ell).addClass('hidden') ;
											})
										})
									) ;
								}
								pagetw.play() ;
								index = decal ;
								all.data('pageindex', index) ;
								project.data('pageindex', index) ;
								project.data('pagecheck')(index) ;
							}else{
								if(decal < 0) return ;
								if(!!pagetw && pagetw.isPlaying && (decal >= 0)){
									pagetw.stop() ;
								}
								pagetw = BetweenJS.to(projectinside, {'left::%':-(decal) * 100}, .25, Expo.easeOut) ;
								if(project.data('updatableinfos')){
									pagetw = BetweenJS.serial(
										BetweenJS.func(function(){
											contblockinsides.removeClass('hidden') ;
										}),
										BetweenJS.parallel(
											BetweenJS.delay(pagetw, .01),
											BetweenJS.to(contblock, {'left::%':-(decal) * 100}, .65, Expo.easeInOut)
										),
										BetweenJS.func(function(){
											contblockinsides.each(function(indx, ell){
												// if(indx != project.data('pageindex')) $(ell).addClass('hidden') ;
											})
										})
									) ;
								}
								pagetw.play() ;
								all.data('pageindex', decal) ;
								project.data('pageindex', decal) ;
								project.data('pagecheck')(decal) ;
							}
							
						}) ;
						
						project.data('pagecheck', function(n){
							if(n == 0) pageprev.addClass('hidden') ;
							else if(pageprev.hasClass('hidden')) pageprev.removeClass('hidden') ;
							
							if(n == l - 1) pagenext.addClass('hidden') ;
							else if(pagenext.hasClass('hidden')) pagenext.removeClass('hidden') ;
						}) ;
						
						project.data('pagecheck')(0) ;
						
						project.data('reset', function(){
							project.data('pageswitch')(0) ;
						}) ;
						
						
						pagenext.bind('click', function(e){
							e.preventDefault() ;
							e.stopPropagation() ;
							project.data('pageswitch')((project.data('pageindex')) + 1) ;
						})
						pageprev.bind('click', function(e){
							e.preventDefault() ;
							e.stopPropagation() ;
							project.data('pageswitch')((project.data('pageindex')) - 1) ;
						})
					}

					projectinfo.bind('click', function(e){
						e.preventDefault() ;
						e.stopPropagation() ;
						all.data('infos')(!all.data('hasInfos')) ;
					})
					
					
					var projind = i ;
					var clickables = project.find('.page') ;
					
					clickables.each(function(i, el){
						
						var clickable = $(el) ;
						var f ;
						var div = $('<div class="abs clickbox clickable context">')
						.html('<span class="dispBlock context" style="text-indent:-300%">&gt;&gt;&gt;&gt;&gt;</span>')
						.appendTo(clickable)
						.data('project', project)
						.data('projind', projind)
						.data('pageind', i)
						.data('enabled', false) ;
						
						
					})
					
					
					
					var pagetweens = [] ;
					var infopages = contblock.children() ;
					
					infopages.each(function(k, lm){
						var infopage = $(lm) ;
						var lets = infopage.find('.letter') ;
						var l = lets.size() ;
						
						var isImg = curimgblocks.size() > 0  && k > 0 ;
						
						var lettertweens = lets.map(function(j, elem){
							return BetweenJS.to(elem, {'left':0}, .05 + (.25/l*(Math.random()*l-1)), Expo.easeOut)
						}).toArray() ;
						var IN = BetweenJS.serial(
							BetweenJS.func(function(){
								lets.css({left:1000}) ;
								centerblocks.css({'right':0+'%'}) ;
								infoblocks.css({'width':0+'%'}).removeClass('dispNone') ;
								imgblocks.css({'top':600+'px', 'bottom':600+'px'}) ;
							}, [], true, function(){
								lets.css({left:0}) ;
								centerblocks.css({'right':0+'%'}) ;
								infoblocks.css({'width':0+'%'}).addClass('dispNone') ;
								imgblocks.css({'top':600+'px', 'bottom':600+'px'}) ;
							}),
							BetweenJS.parallel(
								BetweenJS.tween(curcenterblocks[k], {'right::%':50}, {'right::%':0}, .25, Expo.easeOut),
								BetweenJS.tween(arrows, {'right::%':50}, {'right::%':0}, .25, Expo.easeOut),
								isImg ?
									BetweenJS.parallel(
										BetweenJS.tween(curimgblocks[k-1], {'top::px':130,'bottom::px':130},{'top::px':600,'bottom::px':600}, .25, Expo.easeOut),
										BetweenJS.to(curinfoblocks[0], {'width::%':50}, .25, Expo.easeOut)
									) :
									BetweenJS.to(curinfoblocks[0], {'width::%':50}, .25, Expo.easeOut)
							),
							BetweenJS.parallelTweens(lettertweens),
							BetweenJS.func(function(){
								centerblocks.css({'right':50+'%'}) ;
								infoblocks.css({'width':50+'%'}) ;
								imgblocks.css({'top':130+'px', 'bottom':130+'px'}) ;
								if(project.data('updatableinfos')) {
									contblockinsides.each(function(indx, ell){
										// if(indx != project.data('pageindex')) $(ell).addClass('hidden') ;
										// else $(ell).removeClass('hidden') ;
									})
								}
							}, [], true, function(){
								centerblocks.css({'right':50+'%'}) ;
								infoblocks.css({'width':50+'%'}) ;
								imgblocks.css({'top':130+'px', 'bottom':130+'px'}) ;
								if(project.data('updatableinfos')) {
									// contblockinsides.removeClass('hidden') ;
								}
							})
						) ;
						
						var OUT = BetweenJS.reverse(IN) ;
						pagetweens[pagetweens.length] = {tweenin:IN, tweenout:OUT} ;
					})
					
					infotweens[infotweens.length] = pagetweens ;
				})
				
				all.data('infos', function(cond){
					if(cond === undefined) cond = true ;
					var pageindex = !!proj ? proj.data('pageindex') || 0 : 0 ;
					
					if(infotweens[projectindex].length == 1){
						infotwin = infotweens[projectindex][0].tweenin ;
						infotwout = infotweens[projectindex][0].tweenout ;
					}else{
						infotwin = infotweens[projectindex][pageindex].tweenin ;
						infotwout = infotweens[projectindex][pageindex].tweenout ;
					}
					
					if(cond) {
						if(!! infotwout && infotwout.isPlaying){
							infotwin.update(infotwin.time - infotwout.stop().position) ;
							infotwout.position = 0 ;
						}
						infotwin.play() ;
						$('#readinfofirst').addClass('light') ;
						all.data('hasInfos', true) ;
					}else{
						if(!! infotwin && infotwin.isPlaying){
							infotwout.update(infotwout.time - infotwin.stop().position) ;
							infotwin.position = 0 ;
						}
						$('#readinfofirst').removeClass('light') ;
						infotwout.play() ;
						all.data('hasInfos', false) ;
					}
				}) ;
				
				all.data('hasInfos', false) ;
				
				
				
				
				///////// TOUCH EVENTS
				ww.bind('OStouchmoveX', function(e){
					if(e.distance > 0){
						dd.removeClass('movableup') ;
						dd.removeClass('movabledown') ;
						dd.removeClass('movableleft') ;
						dd.addClass('movableright') ;
					}else{
						dd.removeClass('movableup') ;
						dd.removeClass('movabledown') ;
						dd.removeClass('movableright') ;
						dd.addClass('movableleft') ;
					}
					
					
					if(!!proj && !!proj.data('pageswitch')) {
						var ind = proj.data('pageindex') ;
						var delta = e.distance > 0 ? ind + 1 : ind - 1 ;
						proj.data('pageswitch')( delta ) ;
					}
				})
				ww.bind('OStouchmoveY', function(e){
					
					
					if(e.distance > 0){
						dd.removeClass('movableright') ;
						dd.removeClass('movabledown') ;
						dd.removeClass('movableleft') ;
						dd.addClass('movabledown') ;
					}else{
						dd.removeClass('movableleft') ;
						dd.removeClass('movabledown') ;
						dd.removeClass('movableright') ;
						dd.addClass('movableup') ;
					}
					
					all.data('projectswitch')(e.distance > 0) ;
				})
				
				var projector = $('.projector') ;
				
				ww.bind('OStouchstart', function(e){
					dd.addClass('movable') ;
					var div = $(e.originalEv.target) ;
					if(div.hasClass('clickbox')){
						
						div.data('enabled', true) ;
						
						ww.bind('OStouchmovestart', moveclos = function(e){
							ww.unbind('OStouchmovestart', moveclos) ;
							
							
							//projector.removeClass('dispNone')
							
							
							if(div.data('enabled')) div.data('enabled', false) ;
						}) ;
					}
					
				}) ;
				
				ww.bind('OStouchend', function(e){
					dd.removeClass('movableleft') ;
					dd.removeClass('movableright') ;
					dd.removeClass('movableup') ;
					dd.removeClass('movabledown') ;
					dd.removeClass('movabledown') ;
					dd.removeClass('movable') ;
					
					var div = $(e.originalEv.target) ;
					
					if(div.hasClass('clickbox')){
						var projind = div.data('projind'), pageind = div.data('pageind'), project = div.data('project');
						var projl = project.data('length') ;
					
						if(div.data('enabled')){
							ww.unbind('OStouchmovestart', moveclos) ;
							if(EventEnhancer.OSMoving) return ;
							
							if(projl == 0){
								all.data('projectswitch')() ;
							}else if(pageind == projl-1){
								all.data('projectswitch')() ;
							}else {
								project.data('pageswitch')(project.data('pageindex') + 1) ;
							}
							
						}				
						div.data('enabled', false) ;
					}
				})
				
				ww.bind('keydown', function(e){
					var k = e.keyCode ;
					
					switch(k){
						case 38: // up
						case 40: // down
							all.data('projectswitch')(k === 40) ;
						break;
						case 39:
						case 37:
							if(!!proj && !!proj.data('pageswitch')){
								var ind = proj.data('pageindex') ;
								proj.data('pageswitch')(k === 39 ? ind + 1 : ind - 1 ) ;
							}
						break;
						case 32:
							all.data('infos')(!all.data('hasInfos')) ;
						break;
						default:
							//alert(e.keyCode)
						break;
					}
				})
				
				nextproject.children('a').bind('click', function(e){
					e.preventDefault() ;
					e.stopPropagation() ;
					all.data('projectswitch')() ;
				})
				
				prevproject.children('a').bind('click', function(e){
					e.preventDefault() ;
					e.stopPropagation() ;
					all.data('projectswitch')(false) ;
				})
				
				
			}

		},
		init : function(){
			$('.prev').bind('click', function(e){
				var res = AddressHierarchy.instance.currentStep ;
				e.preventDefault() ;
				
				if(res.depth == 2)
					seek('-=1') ;
				
			})
			
			$('.next').bind('click', function(e){
				var res = AddressHierarchy.instance.currentStep ;
				e.preventDefault() ;
				if(res.depth == 2)
					seek('+=1') ;
				else
					seek(res.getChild(0)) ;
			})
			
			$(window).bind('keydown', function(e){
				var k = e.keyCode ;
				var current = AddressHierarchy.instance.currentStep ;
				if (AddressHierarchy.instance.isStillRunning()) return ;
				switch(k){
					case 38: // up
					case 40: // down
						return seek(k == 38 ? Unique.getInstance().getPrev() : Unique.getInstance().getNext() )
					break;
					case 39:
					case 37:
						if(current.depth == 2) 
							return seek(k == 39 ? '+=1' : '-=1') ;
						else
							return k == 39 ? seek(current.getChild(0)) : false ;
					break;
					case 32:
						// spacebar
						// all.data('infos')(!all.data('hasInfos')) ;
					break;
					default:
						//alert(e.keyCode)
					break;
				}
			})
			
		},
		focus : function focus(e){
			
			var res = e.target ;
			
			var projects = $('.project') ;
			var project = $(projects[res.index]) ;
			var projectall = project.find('.projectinside') ;
			
			if(e.type == 'focusIn'){
				tweenProjectAll(projectall, 0).play() ;
				
				$('.next').removeClass('dispNone') ;
				$('.prev').addClass('dispNone') ;
				
			}else{
				
			}
			return res.focusReady() ;
		},
		focuspanel : function focuspanel(e){
			
			var res = e.target ;
			
			var projects = $('.project') ;
			var project = $(projects[res.parent.index]) ;
			var projectall = project.find('.projectinside') ;
			
			
			if(e.type == 'focusIn'){
				
				
				$('.prev').removeClass('dispNone') ;
				if(res.index == res.parentStep.getLength() - 1) $('.next').addClass('dispNone') ;
				else $('.next').removeClass('dispNone') ;
				
			}else{
				
			}
			return res.focusReady() ;
		},
		toggle : function toggle(e){
			
			var res = e.target ;
			
			var projects = $('.project') ;
			var project = $(projects[res.index]) ;
			var projectall = project.find('.projectinside') ;
			
			if(res.opening){
				tweenAll(-(res.index) * 100).play() ;
			}else{
				//tweenProjectAll(projectall, 0).play() ;
			}
			
			return res.ready() ;
		},
		togglepanel : function togglepanel(e){
			
			var res = e.target ;
			
			var projects = $('.project') ;
			var project = $(projects[res.parentStep.index]) ;
			var projectall = project.find('.projectinside') ;
			
			if(res.opening){
				tweenProjectAll(projectall, -(res.index + 1) * 100).play() ;
			}else{
				
			}
			return res.ready() ;
			
		}
	}
}) ;