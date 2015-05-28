
/*
	
	Proxy.Class(target, override) or new Proxy.Class(target, override)
	
	
	Creates a Proxy Class along a target's constructor's profile (recommended for native singletons, i-e window, document, etc...)
	
	Each call to Proxy.Class will create and cache a new class model.
	Each of the proxy handlers instanciated through both methods new [the concerned classmodel]() and simply [the concerned classmodel]() shall be returned modelized 
	as the source classmodel definition (first anonymous object passed in).
	
	to override the classmodel definition on-demand, pass a new anonymous object you wish to merge, and that overriding will concern just that instance
	
	@param target an object which constructor will define the class model, cannot be a class(IE7)
	@param override an object to override this new class' model's with.
	
	@return a new cached Proxy Class.
	
*/



var WindowProxy = new Proxy.Class(window, {
	__classvars__:{
		__static__:function(){
			trace('initing WindowProxy class', this) ;
			return this ;
		}
	},
	__init__:function(){
		trace('window proxy init') ;
		return this ;
	},
	addEventListener:function(type, closure, stupidbool){
		return (!!window.attachEvent) ? 
			this.target.attachEvent('on'+type, closure) :
			this.target.addEventListener(type, closure, true) ;
	},
	setTimeout:function(){
		arguments[0] = this.bypassScope(arguments[0]) ; // bypassing methods passed as parameters
		
		return 'apply' in this.target.setTimeout ?
			this.target.setTimeout.apply(this.target, arguments) :
			this.target.setTimeout(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]) ;
	}
}) ;

/* creates an instance of that class , no need to re-assign proxy's target in constructor params */
var wproxy = new WindowProxy() ;


wproxy.addEventListener('load',  function(e){ // will call wproxy's override instead
	
	trace(new Proxy(document.body))
	
	
	trace(e.type) ; // load
	
	trace(wproxy.location({hash:"#/"}));
	
	var box = document.getElementById('box') ;
	
	/*
		
		Proxy(target, override)
		
		
		Creates a semi-single-use proxy, stocking in cache the class, in case of a re-use ;
		
		Each further instance called without the 'new' keyword will call a new instance of the same cached class, 
		overrides beeing possible, within an anonymous object passed as parameters.
		Oppositely, if you call an instance with the 'new' keyword, this class would skip cache and become unique.
		
		Optionally, __classvars__ object can write classmodel static properties.
		An __init__ method can also be passed as an instanciation extra function.
		Then, make your own overrides.
		
		@param target an object to assign the proxy to.
		@param override (optional) an object to override the base methods with.
		
		@return a Proxy instance.
		
	*/
	
	var dproxy = Proxy(box, {
		__classvars__:{
			__static__:function(){
				trace('initing Proxy class', this) ;
				
			},
			hello:function(){
				trace('hello') ;
				return this ;
			}
		},
		__init__:function(){
			return this ;
		},
		addEventListener:function(type, closure, stupidbool){
			return (!!window.attachEvent) ? 
				this.target.attachEvent('on'+type, closure) :
				this.target.addEventListener(type, closure, true) ;
		},
		style:function(obj, val){
			// this.$original beeing the base proxy method of the same name, setting/returning style object.
			return this.$original.style.apply(this, arguments) ;
		}
	}) ;
	
	/* sets and returns the style CSSDeclaration object */
	trace(dproxy.style({height:'150px', background:'black'})) ;
	
	/* will trigger through the overriding method */
	dproxy.addEventListener('click', function(e){
		trace(e.type)
	})
	
	/* 
		
		Proxy.getProxy(target)
		
		
		Re-calls the last created proxy assigned to that target 
		
	*/
	var uid = Proxy.getProxy(window).setTimeout(function(){
		trace(this.location({hash:"#/js/"}));
		// same proxy called back again
		trace(Proxy(box).style({height:'50px', background:'red', color:'white'})) ;
		
		
		
		/*
			
			new Proxy(target, override)
		
			
			Creates a single-use Proxy, assigned to box, with no other overrides than the proxy's own, 
			(but would accept some within an object as second parameter)
			
			overrides are behaving as such, 
			for each known property, proxy will re-assign a function to it retrieving and/or setting that property.
			for 'method'-like properties, Proxy will re-assign them to overriding same-name method(in anonymous object), 
			or fallback by invoking the target's method.
			
			@param target an object to assign the proxy to.
			@param override (optional) an object to override the base methods with.
			
			@return an unique Proxy instance.
			
		*/
		var s = new Proxy(box, {
			__classvars__:{
				__static__:function(){
					trace('initing anonymous Proxy class', this) ;
				}
			}
		}) ;
		s.innerHTML('!!! SUCCESS !!!') ;
		
		
	}, 1000) ;
	
	/*
		
		[CustomProxyClass](override) or new [CustomProxyClass](override)
		
		
		Creates a new instance of the cached WindowProxy class that was just created.
		The instantiation process will be overriden (just for that instance) by the anonymous object passed in as first parameter
		
		@param target (optional) an object to assign the proxy to. 
		If object passed is different than the original target, this object will behave as the overriding object (like in this example).
		@param override (optional) an object to override the base methods with.
		
		@return a pre-defined ProxyClass instance.
		
	*/
	trace(WindowProxy( {
		__init__:function(){
			trace('overriden window proxy init') ;
			return this.$super.__init__.apply(this) ;
		}
	}))
	
	trace(new WindowProxy()) // no need to re-set target
	
	// clearTimeout(uid) // will work
	
}) ;
