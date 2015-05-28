

NS = function(){
	var version = 0.1 ;
	var Namespace = Class.$extend({
		__classvars__ : {
			version:version,
			ns:'__global__::Namespace'
		},
		pkg:null,
		clearNS:null,
		alias:null,
		fullQualifiedClassName:null,
		__init__:function(ns){
			if(!ns) ns =  this.__classvars__.ns ;
			var path = ns.replace(/(::|[.])/gi, ' ').split(' ') ;
			if(path.length > 1){
				this.alias = path.pop() ;
				this.pkg = path.join('.') ;
				this.clearNS = this.pkg + '::' + this.alias ;
				this.fullQualifiedClassName = this.pkg + '.' + this.alias ;
			}else{
				this.alias = path.pop() ;
				this.pkg = '' ;
				this.clearNS = this.fullQualifiedClassName = this.alias ;
			}		
		}, 
		toString:function(){
			return '[Object '+this.alias+' > ' + this.clearNS + ']' ;  
		}
	}) ;

	var Namespaces = Namespace.$extend({
		__classvars__ : {
			$ns:{},
			version:version,
			ns:'__global__::Namespaces',
			register:function(ns, obj){
				
				if(!!obj){ // object exists
					if(typeof obj === 'function'){
						obj = obj.constructor ;
						obj.constructor.ns = ns ;
					}
				}else{ // only ns given
					if(ns instanceof Class){ // prepared for Classy classes instances
						obj = ns ;
						ns = ns.$class.ns ;
					}else if(typeof ns === 'function'){
						obj = ns.constructor ;
						ns = obj.ns ;
					}else{						
						throw new Error('should give an object for namespace association...') ;
					}
				}
				
				// now working with Namespace
				ns = new Namespace(ns) ;
				ns.obj = obj ;
				
				if(ns.pkg != ''){
					var p = ns.pkg.split('.') ;
					var $parent = Namespaces.$ns ;
					for(var i = 0 , l = p.length ; i < l ; i++){
						var c = p[i] ;
						if(!$parent[c]) {
							$parent[c] = {} ;
						}
						$parent = $parent[c] ;
					}
					$parent[ns.alias] =
					Namespaces.$ns[ns.fullQualifiedClassName] =
					Namespaces.$ns[ns.clearNS] = obj ;
					
					//if(!Namespaces.$ns[ns.alias]) Namespaces.$ns[ns.alias] = obj ;
				}else{
					Namespaces.$ns[ns.alias] = obj ;
				}
				return obj ;
			},
			retrieve:function(ns){
				return Namespaces.$ns[ns] ;
			},
			toString : function(){
				return "[class " + this.ns + ' v.'+this.version ;
			}
		}
	}) ;
	
	Namespaces.register('Namespace', Namespaces.register(Namespace())) ;
	Namespaces.register('Namespaces',Namespaces.register(Namespaces())) ;
	
	return function(ns, model){
		
		if(!!model){ // model exists
			// means we want to give a namespace to a model
			return Namespaces.register(ns, model) ; 
		}else{
			// means it has given only one abstract object >> 'ns'
			if(typeof ns === 'string'){
				// means we want to call a namespace and retrieve something
				return Namespaces.retrieve(ns) ;
			}else{
				// (is a Class object)
				// or we want to initialize a predefined class
				return Namespaces.register(ns) ;
				// that already has a namespace
				// only accept Classy classes yet
				// dont know what to do here... maybe throw some...
			}
		}
	}
}() ;