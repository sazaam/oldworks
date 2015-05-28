"use strict" ;

var Unit = {
	tab:'',
	Assertions:{
      assert:function(msg, value){
		 var a = value ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return value ;
      },
      assertTrue:function(msg, value){
         var a = (value === true) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertFalse:function(msg, value){
         var a = (value === false) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertEquals:function(msg, expected, actual){
         var a = (expected == actual) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNotEquals:function(msg, expected, actual){
         var a = (expected != actual) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertSame:function(msg, expected, actual){
         var a = (expected === actual) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNotSame:function(msg, expected, actual){
         var a = (expected !== actual) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNull:function(msg, value){
         var a = (value === null) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNotNull:function(msg, value){
         var a = (value !== null) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertUndefined:function(msg, value){
         var a = (value === undefined) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNotUndefined:function(msg, value){
         var a = (value !== undefined) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNaN:function(msg, number){
         var a = isNaN(number) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNotNaN:function(msg, number){
         var a = !isNaN(number) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertException:function(msg, callback, type){
         var str = msg + ' >> executing to catch exception : '+ ((type !== undefined)? type : '(please specify type of exception)') ;
         try{
            var a = callback() ;
         }catch(e){
            if(e.message.search(type) === -1) {
               str += '        unexpected exception got caught !!' ;
               trace(str) ;
               str += '\n>> false' ;
               return false ;
            } else {
               str += '        expected exception "'+type+'" got caught !!' ;
               str += '\n>> true' ;
               trace(str) ;
               return true ;
            }
         }
         str += '        no exception have been thrown' ;
         str += '\n>> false' ;
         trace(str) ;
         return false ;
      },
      assertNoException:function(msg, callback){
         var str = msg + ' >> executing to avoid any exceptions...' ;
         try{
            var a = callback() ;
         }catch(e){
            str += '        an exception have been thrown : '+ e ;
            str += '\n>> false' ;
            trace(str) ;
            return false ;
         }
         str += '        no exception(s) have been thrown...' ;
         str += '\n>> true' ;
         trace(str) ;
         return true ;
      },
      assertArray:function(msg, arrayLike){
         var a = arrayLike.hasOwnProperty('length') && arrayLike.constructor.hasOwnProperty('slice') ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertTypeOf:function(msg, type, object){
         var a = typeof(object) === type ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertBoolean:function(msg, value){
         var a = value === false || value === true ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertFunction:function(msg, value){
         var a = typeof(value) === 'function' ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNumber:function(msg, value){
         var a = typeof(value) === 'number' ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertObject:function(msg, value){
         var a = typeof(value) === 'object' ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertString:function(msg, value){
         var a = typeof(value) === 'string' ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertMatch:function(msg, pattern, string){
         var a = pattern.test(string) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNoMatch:function(msg, pattern, string){
         var a = !pattern.test(string) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertTagName:function(msg, tagName, element){
         var a = element.getAttribute('class').search(tagname) > -1 ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertClassName:function(msg, className, element){
         var a = element.getAttribute('class').search(tagname) > -1 ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertElementId:function(msg, id, element){
         var a = element.getAttribute('id') == id ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertInstanceOf:function(msg, constructor, object){
         var a = (object instanceof constructor) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      },
      assertNotInstanceOf:function(msg, constructor, object){
         var a = ! (object instanceof constructor) ;
         trace(Unit.tab + '\t' + msg);trace('>> ', a) ;
         return a ;
      }
   },
   
 /*
  * TestCase implementation
  * 
  * */
   
   TestCase:function(description, methods, deep){
      
      deep = deep || 0 ;
      var tab = Unit.tab = new Array(deep + 1).join('\t') ;
      trace('///////////////////////////////////////') ;
      trace(tab + description.toUpperCase()) ;
      trace('///////////////////////////////////////') ;
      var stp = undefined ;
      var td = undefined ;
      
      if(methods.hasOwnProperty('setup') && typeof(methods['setup']) === 'function'){
         stp = methods['setup'] ;
         delete methods['setup'] ;
      }
      if(methods.hasOwnProperty('tearDown') && typeof(methods['tearDown']) === 'function'){
         td = methods['tearDown']
         delete methods['tearDown'] ;
      }
      
      (stp !== undefined) && trace(tab + 'setting up...') && trace(tab + 'has set up >> '+ stp()) ;
      
      for(var i in methods){
         var def = i ;
         var meth = methods[i] ;
         if(typeof(meth) === 'function'){
            trace(tab + def) ;
            trace(tab + '\t' + meth()) ;
         }else{
            if(meth.slice === [].slice){
               
            }else{
               arguments.callee(def, meth, deep + 1) ;
            }
         }
      }
      
      (td !== undefined) && trace(tab + 'tearing down...') && trace(tab + 'has torn down >> ' + td()) ;
      trace(tab + '///////////////////////////////////////') ;
   }
}



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




