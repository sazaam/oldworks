'use strict' ;

module.exports = Pkg.write('org.3Dutils', function(){
	
	
	var Particle = Type.define({
		pkg:'particles',
		statics:{
			all:[],
			create:function create(div, orX, orY){
				var all = Particle.all, ind = all.length ;
				return (all[ind] = new Particle(div, orX, orY, ind)) ;
			},
			destroy:function destroy(particle){
				var all = Particle.all, ind = particle.index ;
				particle.div.parentNode.removeChild(particle.div) ;
			},
			getParticleAt:function getParticleAt(index){
				var all = Particle.all ;
				return all[index] ;
			}
		},
		x:NaN,
		y:NaN,
		orX:NaN,
		orY:NaN,
		constructor:function Particle(div, orX, orY, ind){
			Particle.base.call(this) ;
			
			this.div = div ;
			this.orX = orX ;
			this.orY = orY ;
			this.index = ind ;
		},
		move:function move(x, y){
			this.x = x ;
			this.y = y ;
			
			return this ;
		}
	}) ;
	
	
	var Appear = Type.define(function(){
		
		var max = 48,
		$viewport,
		vw,
		vh,
		mvw,
		mvh,
		parallel,
		tw,
		sizeX = 80,
		sizeY = 80,
		indexCut = 5,
		color = '#FFFFFF',
		binded = false,
		Y = 0,
		X = 0 ;
		
		var rand = function(n, rd){
			return n -(rd >> 1) + (Math.random() * rd) ;
		}
		
		return {
			pkg:'fx',
			constructor:Appear = function Appear(anchor, scope){
				$viewport = anchor ;
				$scope = scope ;
				vw = $scope.width() ;
				vh = $scope.height() ;
				mvw = vw >> 1 ;
				mvh = vh >> 1 ;
				
				parallel = [] ;
				this.setup() ;
			},
			setup:function(){
				var l = max ;
				
				for(var i = 0 ; i < l ; i++){
					
					
					var x = 0 ;
					var y = 0 ;
					var z = parseInt(Math.random() * 500) ;
					
					var particle = Particle.create(document.createElement('div'), mvw, mvh) ;
					var div = particle.div ;
					div.setAttribute('class', 'particle abs') ;
					div.style.backgroundColor = '#BBBBBB' ;
					div.style.width = '1px' ;
					div.style.height = '1px' ;
					$viewport[0].appendChild(div) ;
					particle.move(x, y, z) ;
				}
			},
			open:function open(cb, col){
				
				if(!!tw && tw.isPlaying) tw.stop() ;
				parallel = [] ;
				
				var vw2 = mvw + (mvw >> 1) ;
				var vh2 = mvh + (mvh >> 1) ;
				var mvw2 = vw2 >> 1 ;
				var mvh2 = vh2 >> 1 ;
				
				var ww = mvw - (Math.random() * vw) ;
				var hh = mvh - (Math.random() * vh) ;
				
				var l = max ;
				
				var n = 8 ;
				var m = 6 ;
				
				sizeX = vw / n ;
				sizeY = vh / m ;
				
				var indx = 0 ;
				
				// color = {r:Math.random() * 255, g:Math.random() * 255, b:Math.random() * 255} ;
				color = col ;
				
				var cc = {r:Math.random() * 255, g:Math.random() * 255, b:Math.random() * 255}
				
				for(var i = 0 ; i < l ; i++){
					
					var randX = mvw - (Math.random() * vw) ;
					var randY = mvh - (Math.random() * vh) ;
					
					var particle = Particle.getParticleAt(i) ;
					
					var ii = particle.index ;
					var div = particle.div ;
					
					var indX = Math.floor(i % n) ;
					var indY = Math.floor(i / n) ;
					var ww = ( indX * sizeX ) ;
					var hh = ( indY * sizeY ) ;
					
					var ind = Math.floor(l/2) ;
					
					if(ii > ind) ind = ind - (ind - (ii - ind)) ;
					else ind =  ind - ii ;
					
					sizeM = 1 + Math.random() * 3 ;
					
					var arr1 = [-rand(randX, 50), -rand(0, 200), rand(randX, 200)] ;
					var arr2 = [-rand(randY, 50), -rand(0, 200), rand(randY, 200)] ;
					
					parallel[i] = BetweenJS.serial(
						BetweenJS.delay(BetweenJS.bezierTo(div,
						{
							'left': ww - (sizeX * n/2) + sizeX/2,
							'top': hh - (sizeY * m/2)+ sizeY/2,
							'margin-top':-sizeY/2,
							'margin-left':-sizeX/2,
							'width': sizeX,
							'height': sizeY,
							'background-color':col
						},
						{
							'left':arr1,
							'top':arr2,
							'margin-top':[-sizeM/2, -sizeM/2],
							'margin-left':[-sizeM/2, -sizeM/2],
							'width': [sizeM, sizeM],
							'height': [sizeM, sizeM],
							'background-color':{r:[cc.r +Math.random()*50], g:[cc.g + Math.random() * 50], b:[cc.b + Math.random() * 50]}
						},1, Expo.easeOutIn), .0055 * ind)
					);
					
					
				}
				
				tw = BetweenJS.parallelTweens(parallel) ;
				
				tw.onComplete = function(p){
					Particle.all = Particle.all.reverse() ;
					cb() ;
				}
				tw.play() ;
				
			},
			close:function close(cb){
				this.destroy(cb) ;
			},
			destroy:function(cb){
				tw = BetweenJS.reverse(tw) ;
				tw.onComplete = function(p){
					for(var i = 0, l = max ; i < l ; i++){
						Particle.destroy(Particle.getParticleAt(i)) ;
					}
					Particle.all = [] ;
					cb() ;
				}
				tw.play() ;
			}
		}
	})
	
	
	return Appear ;
})