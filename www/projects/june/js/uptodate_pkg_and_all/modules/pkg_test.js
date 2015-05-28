var Particle = Pkg.write('org.sim3D.particles', function(path){
	
	var Master = Type.define({
		pkg:path,
		constructor:Master = function Master(){
			// trace(this instanceof Type.getDefinitionByHash(Type.getType(this).hashcode))
		}
	}) ;
	
	var Particle = Type.define({
		inherits:Master,
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
	
	// return [Master, Particle] ; // always pass representive class as last element of array
	// or just
	return Particle ;
	// in case you would like NOT to write master in PKG hashtable
})

trace(Type.getAllDefinitions()) ;
trace(Pkg.getAllDefinitions()) ;
