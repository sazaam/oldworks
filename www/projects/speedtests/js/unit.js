"use strict" ;
var XTest = {
   Assertions:{
      assert:function(msg, value){
         trace(msg + '\n >> ' + value) ;
         return value ;
      },
      assertTrue:function(msg, value){
         var a = (value === true) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertFalse:function(msg, value){
         var a = (value === false) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertEquals:function(msg, expected, actual){
         var a = (expected == actual) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNotEquals:function(msg, expected, actual){
         var a = (expected != actual) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertSame:function(msg, expected, actual){
         var a = (expected === actual) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNotSame:function(msg, expected, actual){
         var a = (expected !== actual) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNull:function(msg, value){
         var a = (value === null) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNotNull:function(msg, value){
         var a = (value !== null) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertUndefined:function(msg, value){
         var a = (value === undefined) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNotUndefined:function(msg, value){
         var a = (value !== undefined) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNaN:function(msg, number){
         var a = isNaN(number) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNotNaN:function(msg, number){
         var a = !isNaN(number) ;
         trace(msg + '\n >> '+ a) ;
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
               str += '\n >> false' ;
               return false ;
            } else {
               str += '        expected exception "'+type+'" got caught !!' ;
               str += '\n >> true' ;
               trace(str) ;
               return true ;
            }
         }
         str += '        no exception have been thrown' ;
         str += '\n >> false' ;
         trace(str) ;
         return false ;
      },
      assertNoException:function(msg, callback){
         var str = msg + ' >> executing to avoid any exceptions...' ;
         try{
            var a = callback() ;
         }catch(e){
            str += '        an exception have been thrown : '+ e ;
            str += '\n >> false' ;
            trace(str) ;
            return false ;
         }
         str += '        no exception(s) have been thrown...' ;
         str += '\n >> true' ;
         trace(str) ;
         return true ;
      },
      assertArray:function(msg, arrayLike){
         var a = arrayLike.hasOwnProperty('length') && arrayLike.constructor.hasOwnProperty('slice') ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertTypeOf:function(msg, type, object){
         var a = typeof(object) === type ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertBoolean:function(msg, value){
         var a = value === false || value === true ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertFunction:function(msg, value){
         var a = typeof(value) === 'function' ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNumber:function(msg, value){
         var a = typeof(value) === 'number' ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertObject:function(msg, value){
         var a = typeof(value) === 'object' ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertString:function(msg, value){
         var a = typeof(value) === 'string' ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertMatch:function(msg, pattern, string){
         var a = pattern.test(string) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNoMatch:function(msg, pattern, string){
         var a = !pattern.test(string) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertTagName:function(msg, tagName, element){
         var a = element.getAttribute('class').search(tagname) > -1 ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertClassName:function(msg, className, element){
         var a = element.getAttribute('class').search(tagname) > -1 ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertElementId:function(msg, id, element){
         var a = element.getAttribute('id') == id ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertInstanceOf:function(msg, constructor, object){
         var a = (object instanceof constructor) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      },
      assertNotInstanceOf:function(msg, constructor, object){
         var a = ! (object instanceof constructor) ;
         trace(msg + '\n >> '+ a) ;
         return a ;
      }
   },
   
 /*
  * TestCase implementation
  * 
  * */
   
   TestCase:function(description, methods, deep){
      
      var tabs = "                                                                " ;
      deep = deep || 0 ;
      var tab = tabs.substr(0,(deep *3)) ;
      trace(tab + '///////////////////////////////////////') ;
      trace(tab + description.toUpperCase()) ;
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
      
      (stp !== undefined) && stp() ;
      
      for(var i in methods){
         var def = i ;
         var meth = methods[i] ;
         if(typeof(meth) === 'function'){
            trace(tab + def.replace(/^(test)/, '$1'+'ing')) +'...' ;
            trace(tab + meth()) ;
         }else{
            if(meth.hasOwnProperty('length') && meth.constructor.hasOwnProperty('slice')){
               
            }else{
               
               arguments.callee(def, meth, deep + 1) ;
               
            }
         }
      }
      
      (td !== undefined) && td() ;
      trace(tab + '///////////////////////////////////////') ;
   }
}