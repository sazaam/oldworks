

var win = window, doc = document, html = document.documentElement, body = document.body ;
var ww = $(win) ;
var dd = $(doc.body) ;
var trans = 1.25 ;
var ease = Quint.easeOut ;


ww.bind('load', function(e){
	
	if(Toolkit.Qexists('.project')){
		
		var all = $('#all') ;
		var projects = $('.project') ;
		
		dd.addClass('movable') ;
		
		var prevproject = $('.prevproj') ;
		var nextproject = $('.nextproj').removeClass('dispNone') ;
		var proj ;
		var projecttw, pagetw ;
		var infotwin, infotwout ;
		var projectindex = 0, projectl = projects.size() ;
		
		all.data('projectswitch', function(forward){
			
			if(forward === undefined) forward = true ;
			
			if(forward){
				if(projectindex >= projectl - 1) return ;
				if(!!projecttw && projecttw.isPlaying) projecttw.stop().update(trans) ;
				projecttw = BetweenJS.to(all, {'top::%':-(projectindex + 1 ) * 100}, .65, Expo.easeInOut).play() ;
				if(!!proj && !!proj.data('reset')) proj.data('reset')() ;
				projectindex++ ;
				all.data('projectcheck')(projectindex) ;
				proj = $(projects[projectindex]) ;
			}else{
				if(projectindex < 1) return ;
				if(!!projecttw && projecttw.isPlaying) projecttw.stop().update(trans) ;
				projecttw = BetweenJS.to(all, {'top::%':-( projectindex - 1) * 100}, .65, Expo.easeInOut).play() ;
				if(!!proj && !!proj.data('reset')) proj.data('reset')() ;
				projectindex-- ;
				all.data('projectcheck')(projectindex) ;
				proj = $(projects[projectindex]) ;
			}
			
		}) ;
		
		all.data('projectcheck', function(n){
			
			if(n == 0) {
				nextproject.children('a').addClass('momocolor') ;
				prevproject.addClass('dispNone') ;
			}else {
				nextproject.children('a').removeClass('momocolor') ;
				if(prevproject.hasClass('dispNone')) prevproject.removeClass('dispNone') ;
			}
			
			if(n == projectl - 1) nextproject.addClass('dispNone') ;
			else if(nextproject.hasClass('dispNone'))  nextproject.removeClass('dispNone') ;
			
		}) ;
		
		all.data('projectcheck')(0) ;
		
		
		
		var infotweens = [] ;
		var infoblocks = $('.info') ;
		var imgblocks = $('.imghold') ;
		var centerblocks = $('.centerblock, .projectarr') ;
		
		projects.each(function(i, el){
			var project = $(el) ;
			var projectinside = project.find('.projectinside') ;
			var pages = project.find('.page') ;
			
			var index = 0 ;
			var l = pages.size() ;
			
			project.data('length', l) ;
			
			var projectinfo = project.find('.read') ;
			var contblock = project.find('.contblock') ;
			
			var contblockinsides = contblock.children() ;
			// si contient plusieurs pages
			if(l > 1){
				var pageprev = project.find('.prev') ;
				var pagenext = project.find('.next') ;
				
				project.data('updatableinfos', contblockinsides.size() > 1) ;
				
				
				project.data('pageswitch', function(forward){
					if(forward === undefined) forward = true ;
					
					if(forward){
						if(index >= l - 1) return ;
						if(!!pagetw && pagetw.isPlaying && (index < l - 1)){
							pagetw.stop().update(pagetw.time)
						}
						pagetw = BetweenJS.to(projectinside, {'left::%':-(index + 1 ) * 100}, .25, Expo.easeOut) ;
						if(project.data('updatableinfos')){
							pagetw = BetweenJS.serial(
								BetweenJS.func(function(){
									contblockinsides.removeClass('hidden') ;
								}),
								BetweenJS.parallel(
									BetweenJS.delay(pagetw, .01), 
									BetweenJS.to(contblock, {'left::%':-(index + 1 ) * 100}, .65, Expo.easeInOut)
								),
								BetweenJS.func(function(){
									contblockinsides.each(function(indx, ell){
										if(indx != index) $(ell).addClass('hidden') ;
									})
								})
							) ;
						}
						pagetw.play() ;
						index++ ;
						all.data('pageindex', index) ;
						project.data('pagecheck')(index) ;
					}else{
						if(index < 1) return ;
						if(!!pagetw && pagetw.isPlaying && (index > 0)){
							pagetw.stop().update(pagetw.time) ;
						}
						pagetw = BetweenJS.to(projectinside, {'left::%':-( index - 1) * 100}, .25, Expo.easeOut) ;
						if(project.data('updatableinfos')){
							pagetw = BetweenJS.serial(
								BetweenJS.func(function(){
									contblockinsides.removeClass('hidden') ;
								}),
								BetweenJS.parallel(
									BetweenJS.delay(pagetw, .01),
									BetweenJS.to(contblock, {'left::%':-(index - 1 ) * 100}, .65, Expo.easeInOut)
								),
								BetweenJS.func(function(){
									contblockinsides.each(function(indx, ell){
										if(indx != index) $(ell).addClass('hidden') ;
									})
								})
							) ;
						}
						pagetw.play() ;
						index-- ;
						all.data('pageindex', index) ;
						project.data('pagecheck')(index) ;
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
					var len = index ;
					while(index > 0){
						project.data('pageswitch')(false) ;
					}
				}) ;
				
				
				pagenext.bind('mousedown', function(e){
					e.preventDefault() ;
					e.stopPropagation() ;
					project.data('pageswitch')() ;
				})

				pageprev.bind('mousedown', function(e){
					e.preventDefault() ;
					e.stopPropagation() ;
					project.data('pageswitch')(false) ;
				})
			}

			projectinfo.bind('mousedown', function(e){
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
			var pagetweens = [] ;
			
			infopages.each(function(k, lm){
				var infopage = $(lm) ;
				var lets = infopage.find('.letter') ;
				var l = lets.size() ;
				
				var lettertweens = lets.map(function(j, elem){
					return BetweenJS.to(elem, {'left':0}, .05 + (.25/l*(Math.random()*l-1)), Expo.easeOut)
				}).toArray() ;
				
				var IN = BetweenJS.serial(
					BetweenJS.func(function(){
						lets.css({left:1000})
						infoblocks.css({'width':0+'%'}).removeClass('dispNone') ;
						imgblocks.css({'top':600+'px', 'bottom':600+'px'}) ;
					}, [], true, function(){
						lets.css({left:0}) ;
						infoblocks.css({'width':0+'%'}).addClass('dispNone') ;
						imgblocks.css({'top':600+'px', 'bottom':600+'px'}) ;
					}),
					BetweenJS.parallel(
						BetweenJS.tween(centerblocks, {'right::%':50}, {'right::%':0}, .25, Expo.easeInOut),
						BetweenJS.to(infoblocks, {'width::%':50}, .25, Expo.easeOut)
					),
					BetweenJS.serial(
						BetweenJS.to(imgblocks, {'top::px':130,'bottom::px':130}, .35, Expo.easeOut),
						BetweenJS.parallelTweens(lettertweens)
					),
					BetweenJS.func(function(){
						if(project.data('updatableinfos')) {
							contblockinsides.each(function(indx, ell){
								if(indx != index) $(ell).addClass('hidden') ;
							})
						}
					}, [], true, function(){
						if(project.data('updatableinfos')) {
							contblockinsides.removeClass('hidden') ;
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
			var pageindex = all.data('pageindex') || 0;
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
			
			
			if(!!proj && !!proj.data('pageswitch')) proj.data('pageswitch')(e.distance > 0) ;
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
		
		
			ww.bind('OStouchstart', function(e){
				var div = $(e.originalEv.target) ;
				if(div.hasClass('clickbox')){
					
					div.data('enabled', true) ;
					
					ww.bind('OStouchmovestart', moveclos = function(e){
						ww.unbind('OStouchmovestart', moveclos) ;
						//dd.addClass('movable') ;
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
				/* dd.removeClass('movable') ; */
				
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
							project.data('pageswitch')() ;
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
					if(!!proj && !!proj.data('pageswitch'))
					proj.data('pageswitch')(k === 39) ;
				break;
				case 32:
					all.data('infos')(!all.data('hasInfos')) ;
				break;
				default:
					//alert(e.keyCode)
				break;
			}
		})

		nextproject.bind('click', function(e){
			e.preventDefault() ;
			e.stopPropagation() ;
			all.data('projectswitch')() ;
		})

		prevproject.bind('click', function(e){
			e.preventDefault() ;
			e.stopPropagation() ;
			all.data('projectswitch')(false) ;
		})
		
		
	}
})


