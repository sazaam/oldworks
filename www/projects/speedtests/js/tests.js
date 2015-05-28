
var l ;
var s = l = [0,1,2,3] ;
var s2 = [0,1,2,3] ;

/* var step = new Step('#', new Command(null, function(){})) ;
var cq = new CommandQueue() ;
var commandClass = Command ;
*/


var und ; 
;(function(){
   var os = XTest.Assertions, testcase = XTest.TestCase ;
	testcase('speedtesting Classy vs ClassLite', 
	{
		setup:function()
		{
			var n = getTimer() ;
			
			//is.assert('should be value', Class) ;
			
			trace(n) ;
			
			
			this.max = 10000 ;
			
			//ClassLite
			this.Saz = Class('test.tech::Saz', {
				__classvars__:{
					medias:[1,2,3],
					execute:function(){
						return this ;
					}
				},
				start:200,
				__init__:function(val){
					this.value = val ;
					//trace('initing super...', this.constructor, this.value)
					
					//this.initStage() ;
					
					//trace('initing saz') ;
					return this ;
				},
				initStage:function(){
					trace('initing stage', this)
				}
			}) ;
			
			this.Ornorm = Class('Ornorm', {
				__classvars__:{
					medias:[321]
				},
				start:300,
				__init__:function(val){
					this.$super(val) ;
					//trace('initing ornorm') ;
					return this ;
				}
			}, this.Saz) ;
			this.Tibo = Class('test.tech::Tibo', {
				__classvars__:{
					medias:[456]
				},
				start:400,
				__init__:function(val){
					this.$super(val) ;
					//trace('initing tibo')
					return this ;
				}
			}, this.Ornorm) ; 
			
			
			
			  /*
			this.Saz = Class.$extend({
				__classvars__:{
					medias:[1,2,3],
					execute:function(){
						return this ;
					}
				},
				start:200,
				__init__:function(val){
					this.value = val ;
					//trace('initing super...', this.constructor, this.value)
					
					//this.initStage() ;
					
					//trace('initing saz') ;
					return this ;
				},
				initStage:function(){
					trace('initing stage', this)
				}
			}) ;
			
			this.Ornorm = this.Saz.$extend({
				__classvars__:{
					medias:[321]
				},
				start:300,
				__init__:function(val){
					this.$super(val) ;
					//trace('initing ornorm') ;
					return this ;
				}
			}) ;
			
			this.Tibo = this.Ornorm.$extend({
				__classvars__:{
					medias:[456]
				},
				start:400,
				__init__:function(val){
					this.$super(val) ;
					//trace('initing tibo')
					return this ;
				}
			}) ;
			*/
			trace('models', getTimer())
			
			
			


			/*
			is.assert('should be value', undefined) ,
			is.assertEquals('should be equal', 9+15, 24) ,
			is.assertEquals('should be equal', s, l) ,
			is.assertNotEquals('should be NOT equal', s, s2) ,
			is.assertSame('should be strictly the same', s, l),
			is.assertNotSame('should be strictly NOT the same', s, s2),
			is.assertUndefined('should be undefined', undefined),
			is.assertNotUndefined('should be defined', !undefined),
			is.assertNull('should be null', null),
			is.assertNotNull('should be NOT null', undefined),
			is.assertObject('should be type > Object', new Image()),
			is.assertTypeOf('should be typeOf "object"', "object", new Image()),
			is.assertFunction('should be type > Function', function(){}),
			is.assertTypeOf('should be typeOf "function"', "function", function(){}),
			is.assertNumber('should be type > Number', NaN),
			is.assertTypeOf('should be typeOf "Number"', "number", NaN),
			is.assertString('should be type > String', "saz"),
			is.assertTypeOf('should be typeOf "string"', "string", "helloworld"),
			is.assertArray('should be an Array', s),
			is.assertBoolean('should be a Boolean', Boolean(1)),
			is.assertTrue('should be true', Boolean(1)),
			is.assertFalse('should be false', Boolean(0)),
			is.assertTypeOf('should be typeOf "boolean"', "boolean", Boolean(0)),
			is.assertInstanceOf('should be instance of Command', Command, cq),
			is.assertNotInstanceOf('should NOT be instance of Command', Command, step),
			is.assertException('should throw an exception', function(){s['assertUnknown']()}, "s.assertUnknown is not a function"),
			is.assertNoException('should throw no exceptions', function(){s.onresize = function(){}}) ;
			*/

			return 'setup' ;
		},
		'test instanciation speed' : function()
		{
			for(var i = 0 ; i < this.max ; i++) new this.Tibo() ;
			// is.assertEquals('should be equal', 27, 20+7) ,
			//is.assertTrue('should be true', !!cq) ,
			//is.assertFalse('should be false', !cq) ,
			//is.assertNotUndefined('should be defined', cq) ,
			// is.assertNotNull('should be NOT null', und) ,
			// is.assertNotNaN('should be NOT NaN', 27+150) ,
			// is.assertNaN('should be NaN', und - 150) , 
			// is.assertSame('should be the same', s = new Array, s) ;

			return 'test complete !!'
		},
		tearDown:function()
		{
			trace('finished', getTimer())
			return 'torn down' ;
		}
   })
})() ;
