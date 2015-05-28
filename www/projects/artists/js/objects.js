var Grid = NS(Class.$extend({
	__classvars__:{
		ns:'test::Grid',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(id, arr){
		this.initGrid(id, arr) ;
		return this ;
	},
	initGrid : function(id, arr){
		var tg = this.tg = $(id) ;
		var items = this.items = $(arr) ;
		this.maxX = parseInt(tg.width() / 155) ;
		this.maxY = 3 ;
		var uid;
		var grid = this ;
		var cq = new CommandQueue() ;
		var requests = [] ;
		var elems = items.toArray() ;
		var entered = false ;
		var selected = [] ;
		
		cq.addAll(items.map(function(i, el){
			var elem = $(el) ;
			var sm = elem.children('.small') ;
			var sm_url = sm.attr('href') ;
			var lg = elem.children('.large') ;
			var lg_url = lg.attr('href') ;
			
			return new Command(el, function(n){
				elem.addClass('waiting');
				var c = $(this) ;
				var req = new Request(n, sm_url, function(jxhr){
					var r = this ;
					var img = $('<span>').addClass('centered').css({'background-image': 'url('+sm_url+')'}).appendTo(elem) ;
					img.hide(0) ;
					img.fadeIn('fast') ;
					elem.removeClass('waiting');
					var dispatch = _.bind(c.trigger, c);
					elem.css({'opacity':'.3'}) ;
					
					n = i ;
					elem.bind('click', function(e){
						var totalblocks = elem.attr('numblocks') || grid.maxX * grid.maxY ;
						if(!entered){
							items.css({'visibility':'hidden'}) ;
							var totalspaces = 10 * grid.maxY / 2 ;
							
							var pos = n % grid.maxX ;
							var min = -pos;
							var max = grid.maxX - pos - 1 ;
							for(var j = 0 ; j < totalblocks ; j ++){
								var o = {"margin-right":"0", "opacity":"1"} ;
								var lMargin = 5 * (grid.maxX/2) + (5 * (grid.maxX % 2)) ;
								if(j % grid.maxX == 0) o["margin-left"] = lMargin +"px" ;
								var indY = parseInt(j / grid.maxX) ;
								var tMargin = 5 * (grid.maxY/2) + (5 * (grid.maxY % 2)) ;
								if(indY == 0) o["margin-top"] = (totalspaces-5) + "px" ;
								if(indY == grid.maxY - 1){
									o["margin-bottom"] = (totalspaces+5) + "px" ;
								} 
								else o["margin-bottom"] = 0 + "px" ;
								trace(n, min , j) ;
								var sel = selected[selected.length] = $(items[n + min + j]) ;
								sel.children('img').fadeOut('fast') ;
								sel.css({'visibility':'visible','opacity':'1'}).addClass('enabled').animate(o, 'fast') ;
							}
							var lgReq = new Request(0, lg_url, function(jxhr){
								trace(jxhr)
								for(var j = 0 ; j < totalblocks ; j ++){
									
									var sel = selected[j] ;
									var sp = sel.find('span') ; 
									sp.css({'background-image':'url('+lg_url+')'}) ;
									
									
									var numW = - ((j % grid.maxX)* 155) ;
									var numH = - (parseInt(j / grid.maxX) * 155) ;
									sp.css({'background-position': numW +'px '+ numH+'px'})
								}
							}) ;
							lgReq.load() ;
						}else{
							items.css({'visibility':'visible'}) ;
							var pos = n % grid.maxX ;
							var min = -pos;
							var max = grid.maxX - pos - 1 ;
							for(var j = 0 ; j < totalblocks ; j ++){
								var o = {"margin-right":"10px", "opacity":".3"} ;
								if(j % grid.maxX == 0) o["margin-left"] = "0px" ;
								o['margin-bottom'] = "10px" ;
								o['margin-top'] = "0" ;
								var sel = selected[j] ;
								sel.children('img').fadeIn('fast') ;
								sel.removeClass('enabled').animate(o, 'fast', function(){
									this.style.backgroundImage = '' ;
								}) ;
							}
							selected = [] ;
						}
						entered = !entered ;
					}) ;
					elem.bind('mouseover', function(e){
						if(! elem.hasClass('enabled')){
							elem.animate({'opacity':'1'}, 'fast') ;
						}
					})
					elem.bind('mouseout', function(e){
						if(!elem.hasClass('enabled')){
							elem.animate({'opacity':'.3'}, 'fast') ;
						}
					})
					_.delay(dispatch, 0, '$');
				}) ;
				
				return req.load() ;
			}, i) ;
		}).toArray()) ;
		cq.execute() ;
		
		
		$(window).bind('resize', function(e){
			grid.maxX = parseInt(tg.width() / 155) ;
		})
		
	},
	launch : function(arr){
		
		
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
})) ;