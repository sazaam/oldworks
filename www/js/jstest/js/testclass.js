

/*
	
	Creates a first Base Class definition called Saz
	
	__classvars__ object will write properties onto Saz class, while others will be written on Saz's instances prototype.
	__static__ will behave as a static initialization of Saz's class(thus just once) ;
	__init__ will trigger right after instanciation of any Saz's instances.
	
*/



var Saz = Class('test.tech::Saz', {
	__classvars__:{
		medias:[1,2,3],
		__static__:function(){
			//trace('static', this.medias)
		},
		execute:function(){
			return this ;
		}
	},
	start:200,
	__init__:function(val){
		this.value = val ;
		trace('initing super...', this.constructor, this.value)
		
		this.initStage() ;
		
		trace('initing saz') ;
		return this ;
	},
	initStage:function(){
		trace('initing stage', this)
	}
}) ;


/*
	
	Creating these two Saz'z model extending classes, one from the other, to have a deep class-tree in this example with two levels of extension. 
	
	Ornorm extends Saz, keeping Saz's reference is $super.
	Tibo extends Ornorm, keeping Ornorm's reference is $super.
	
*/
var Ornorm = Class('Ornorm', {
	__classvars__:{
		medias:[321]
	},
	start:300,
	__init__:function(val){
		this.$super(val) ;
		trace('initing ornorm') ;
		return this ;
	}
}, Saz) ;
var Tibo = Class('test.tech::Tibo', {
	__classvars__:{
		medias:[456]
	},
	start:400,
	__init__:function(val){
		this.$super(val) ;
		trace('initing tibo')
		return this ;
	}
}, Ornorm) ;

window.onload = function(){
	
	
	/* 
	
	var Dummy = Class('test.core::Dummy', {
		__classvars__:{
			staticProp:NaN,
			__static__:function(){
				this.staticProp = 1024 ;
			}
		},
		charisma:200,
		living:true,
		__init__:function(param1, param2){
			
			trace(param1, param2) ; // hello, world
			
			trace(this, this instanceof Dummy) ;
			// [object test.core.Dummy], true
			trace(this.constructor, this.constructor.staticProp) ;
			// [class test.core.Dummy], 1024
			trace(this.charisma, this.living) ;
			// 200, true
			
			return this ;
		},
		doSome:function(){
			trace('doing some...', this) ;
		}
	}) ;
	
	
	
	var d = new Dummy('hello', 'world') ;
	d.doSome() ; // doing some, [object test.core.Dummy]
	
	trace('-----------extends---------------')
	
	var CoolDummy = Class('test.core::CoolDummy', {
		charisma:800,
		__init__:function(param1, param2){
			trace(this instanceof Dummy, this instanceof CoolDummy) ; // true, true
			return this.$super(param1, param2) ;
		},
		doSome:function(){
			trace('doing some cool stuff dude...', this) ;
		}
	}, Dummy) ;
	
	var cd = new CoolDummy('hello', 'cool world') ;
	cd.doSome() ; // doing some cool stuff dude..., [object test.core.Dummy]
	
	*/
	
	// return ;
	
	
	var saz = new (Class('test.tech.Saz'))(512) ;
	//trace('saz ok')
	var ornorm = new Ornorm(1024) ;
	//trace('ornorm ok')
	var tibo = new Tibo(2048) ;
	//trace('tibo ok')
	var tibo2 = new Tibo(4096) ;
	// return ;
	// trace(saz.constructor)
	//trace(ornorm.constructor)
	// trace(tibo.constructor)
	
	trace('saz instanceof Saz', saz instanceof Saz)
	trace('saz instanceof Ornorm', saz instanceof Ornorm)
	trace('saz instanceof Tibo', saz instanceof Tibo)
	trace('ornorm instanceof Ornorm', ornorm instanceof Ornorm)
	trace('ornorm instanceof Saz', ornorm instanceof Saz)
	trace('tibo instanceof Tibo', tibo instanceof Tibo)
	trace('tibo instanceof Ornorm', tibo instanceof Ornorm)
	trace('tibo instanceof Saz', tibo instanceof Saz)
	
}




