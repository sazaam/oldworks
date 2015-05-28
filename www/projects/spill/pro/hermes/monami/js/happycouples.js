
/**
 * @author saz
 */


var Parallax = NS('Parallax', NS(Class.$extend({
	__classvars__:{
		ns:'spill::Parallax',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(id, arr, navid, navitems){
		this.initParallax(id, arr, navid, navitems) ;
		return this ;
	},
	initParallax : function(id, arr, navid, navitems){
		var tg = this.tg = $(id) ;
		// PARALLAX SYSTEM
		var frames = this.frames = $(arr) ;
		var lazyHandle = _.debounce(function(e, delta){
			tg.scrollTo( delta > 0 ? '-=200px': '+=200px', 450);
		}, 150);
		tg.bind({
			mousewheel:function(e, delta){
				e.preventDefault() ;
				lazyHandle(e, delta);
			},
			scroll:function(e){
				e.preventDefault() ;
				var top = tg.scrollTop() ;
				var h = tg.height() ;
				var ind = parseInt(top/(h + h >> 1)) ;
				frames.each(function(i, el){
						var frame = $(el) ;
						var floated = frame.children('.floating') ;
						var frametop = top - (h*i) ;
						if(i < ind - 1 || i > ind + 1) return ;
						var indY = (frametop ) / h * 100 ;
						floated.css({'top':(indY/2 + 50)+'%'})
						var inverted = 100 - (indY) ;
						frame.css({'background-position':'0 '+ (100 + inverted * -(.5))+'%'}) ;
					}
				);
				_.once(function(){
					var fl = $('.floating') ;
					fl.animate({'opacity':'0'}, 0) ;
					setTimeout(function(){fl.animate({'opacity':'1'}, 800);}, 500) ;
				}) ;
			}
		});
		tg.trigger('scroll') ;
		
		// NAVLINKS
		var nav = $(navid) ;
		var navlinks = $(navitems) ;
		var cq = new CommandQueue() ;
		navlinks.each(function(i, el){
			var elm = $(el) ;
			elm.bind('click', function(e){
				e.preventDefault() ;
				var ind = i ;
				var frame = frames[ind] ;
				tg.scrollTo( frame, 750) ;
			}) ;
			var b = elm.children('b') ;
			
			elm.bind({
				mouseover: function(e){
					if(b.css('visibility')=='hidden') b.css({'visibility':'visible'})
					b.stop(false, true) ;
					b.animate({'opacity':'1','right':'35px'}, 150) ;
				},
				mouseout:function(e){
					b.stop(false, true) ;
					b.animate({'opacity':'0','right':'60px'}, 150) ;
				}
			}) ;
			
			cq.add(new Command(elm, function(){
				var command = this ;
				elm.trigger('mouseover') ;
				setTimeout(function(){
					elm.trigger('mouseout');
				}, 150);
				setTimeout(function(){
					command.dispatchComplete() ;
				},50);
				return this;
			})) ;
		}) ;
		trace(cq.commands)
		setTimeout(function(){
			cq.execute() ;
		}, 1500) ;
		
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
}))) ;



























