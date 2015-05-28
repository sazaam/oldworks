var n = Unit, is = Unit.Assertions, testcase = Unit.TestCase ;


var $doc = $(document) ;
var $win = $(window) ;



$win.bind('load', function(){
	
	

	;(function(){
		
		
		var Particle = Pkg.write('org.sim3D.particles', function(path){
			
			var Particle = Type.define({
				statics:{
					all:[],
					create:function create(x, y, z){
						var all = Particle.all, ind = all.length ;
						return (all[ind] = new Particle(x, y, z, ind)) ;
					},
					getParticleAt:function getParticleAt(index){
						var all = Particle.all ;
						return all[index] ;
					}
				},
				// in case you want checks on IE or else, etc.. overwrite or append some stuff here...
				protoinit:function(Particle, domain){ // you need to know Particle, so it comes as first argument
					trace('initializing Proto', this, Particle, domain)
				},
				x:NaN,
				y:NaN,
				z:NaN,
				w:NaN,
				h:NaN,
				constructor:function Particle(div, ind){
					Particle.base.call(this) ;
					
					this.div = div ;
					this.index = ind || NaN ;
				},
				move:function move(x, y, z){
					if(!!x) this.x = x ;
					if(!!y) this.y = y ;
					if(!!z) this.z = z ;
					
					
					return this ;
				},
				update:function(){
					var z = this.z/500 ;
					this.w = 10 * (z) ;
					this.h = 10 * (z) ;
					
					var div = this.div ;
					div.style.top = mvh + this.y +'px' ;
					div.style.left = mvw + this.x +'px' ;
					
					div.style.width = (this.w) +'px' ;
					div.style.height = (this.h) +'px' ;
					div.style.marginTop = '-'+ (this.h/2/z) +'px' ;
					div.style.marginLeft = '-'+ (this.w/2/z) +'px' ;
					
					// div.style.zIndex = this.z ;
					
					return this ;
				}
			}) ;
			
			// or just
			return Particle ;
			// in case you would like NOT to write master in PKG hashtable
		})
		
		// trace(Type.getAllDefinitions()) ;
		trace(Pkg.getAllDefinitions()) ;
		// trace(Pkg.definition('org.sim3D.particles::Particle')) ;
		
		
		var max = 30 ;
		var $viewport = $('#viewport') ;
		
		var vw = $viewport.width() ;
		var vh = $viewport.height() ;
		var mvw = vw >> 1;
		var mvh = vh >> 1;
		var parallel = [] ;
		var tw ;
		var size = 80 ;
		var color = '#' + parseInt(Math.random() * 0xFFFFFF).toString(16) ;
		var binded = false ;
		var Y = 0 ;
		var X = 0 ;
		testcase('testing BetweenJS Demo Example', {
			setup:function(){
				
				var l = max ;
				for(var i = 0 ; i < l ; i++){
					var ww = mvw - (Math.random() * vw) ;
					var hh = mvh - (Math.random() * vh) ;
				
					var x = ww ;
					var y = hh ;
					var z = parseInt(Math.random() * 500) ;
					
					var particle = Particle.create(document.createElement('div')) ;
					
					var div = particle.div ;
					div.setAttribute('class', 'particle abs') ;
					div.style.backgroundColor = '#111111' ;
					
					particle.move(x, y, z).update() ;
					
					$viewport[0].appendChild(div) ;
				}
				
				var block = document.createElement('div') ;
				block.setAttribute('id', 'block_0') ;
				block.setAttribute('class', 'block abs') ;
				
				
				return true ;
			},
			'testing :: Launch of 30 HTMLDivElements' : function launch(){
				
				
				// is.assertEquals('should be equal', 27, 20+7) ,
				// is.assertTrue('should be true', !!cq) ,
				// is.assertFalse('should be false', false) ;
				if(!!tw) tw.stop() ;
				
				if(!!parallel) {
					for(var i = 0, l = parallel.length ; i < l ; i ++){
						if(parallel[i].isPlaying) {
							parallel[i].stop()//.update(0) ;
						}
					}
				}
				parallel = [] ;
				
				var vw2 = mvw + (mvw >> 1) ;
				var vh2 = mvh + (mvh >> 1) ;
				var mvw2 = vw2 >> 1;
				var mvh2 = vh2 >> 1;
				
				var l = max ;
				
				var n = Math.floor(l / 5) ;
				var m = Math.floor(l / n) ;
				
				
				for(var i = 0 ; i < l ; i++){
					
					
					var particle = Particle.getParticleAt(i) ;
					var div = particle.div ;
					
					var indX = Math.floor(i % n) ;
					var indY = Math.floor(i / n) ;
					var ww = ( indX * size ) ;
					var hh = ( indY * size ) ;
					
					// div.style.backgroundPosition = (-ww) +'px '+ (-hh) +'px' ;
					
					var randX = mvw2 - (Math.random() * vw2) ;
					var randY = mvh2 - (Math.random() * vh2) ;
					
					
					var ind = Math.floor(l/2) ;
					if(i > ind) {
						ind = ind - (ind - (i - ind)) ;
					}else ind =  ind - i ;
					
					var rX = Math.random() * (X + 100) ;
					var rY = Math.random() * (Y + 100) ;
					
					var tp = parallel[i] = BetweenJS.parallel(
						BetweenJS.delay(BetweenJS.bezierTo(particle, 
						{
							'x': ww- (size * n/2) ,
							'y': hh- (size * m/2),
							'z': 500 * (size / 10)
						},
						{
							'x':[rX, -rX , -rX],
							'y':[rY, -rY , -rY],
							'z':[Math.random() * (Math.random() * 50) + 50, Math.random() * (Math.random() * 50) + 50]
						}
						,.75, Sine.easeOutIn), .0095 * ind),
						BetweenJS.delay(BetweenJS.to(div,
						{
							'background-color':color
						},1.5, Quint.easeOut), .005 * i)
					) ;
					
					tp.onUpdate = function(p){p.update()}
					tp.onUpdateParams = [particle] ;
					tp.play() ;
				}
				
				color = '#' + parseInt(Math.random() * 0xFFFFFF).toString(16) ;
				
				if(!binded){
					$(document).bind('click', function(e){
						X = e.pageX - mvw ;
						Y = e.pageY - mvh ;
						launch() ;
					})
					binded = true ;
				}
				return 'done testing :: Launch of 600 HTMLDivElements'
			},
			tearDown:function(){
				return 'torn down' ;
			}
		})
	})() ;
})