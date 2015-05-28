


var Nav = NS('Nav', NS('pro::Nav', Class.$extend({
   __classvars__ : {
      version:'0.0.1',
      toString:function(){
         return '[class Nav]' ;
      }
   },
   __init__:function(tgSel) {
      
      var nav = this ;
      nav.tg = $(tgSel) ;
      
      nav.enable() ;
      
      
   },
   enable:function(cond){
      if(cond === undefined) cond = true ;
      
      var nav = this ;
      var tg = nav.tg ;
      
      
      if(cond){
          var up, move, moved = false, y ;
          
          tg.bind('mousewheel', nav.wheel = function(e, delta){
             nav.scroll(30 * (-delta)) ;
          }) ;
          
          tg.bind('click', nav.click = function(e){
             
             if(!!moved){
                 e.preventDefault() ;
                 moved = false ;
             }
             
          }) ;
          
          tg.bind('mousedown', nav.down = function(e){
             e.preventDefault() ;
             
             y = e.pageY ;
             
             tg.bind('mouseup', up = function(e){
                 e.preventDefault() ;
                 
                 tg.unbind('mousemove', move) ;
                 tg.unbind('mouseup', up) ;
             }) ;
             
             tg.bind('mousemove', move = function(e){
                 e.preventDefault() ;
                 nav.indY = y - (y = e.pageY)  ;
                 
                 nav.scroll() ;
                 
                 if(!moved) moved = true ;
             }) ;
          }) ;
          
          
          var inners = nav.inner = nav.tg.find('.ajaxian') ;
          inners.each(function(i, el){
              
              //trace(el)
              
          })
          
          
      }else{
          
          tg.unbind('mousewheel', nav.wheel)
          .unbind('click', nav.click)
          .unbind('mousedown', nav.down) ;
          
          
          
      }
      
      return this ;
   },
   scroll:function(n){
      var nav = this ;
      var tg = nav.tg ;
      
      if(n !== undefined){
          n = tg.scrollTop() + n ;
      }else{
          n = tg.scrollTop() + nav.indY ;
      }
      tg.scrollTop(n) ;
      
      return this ;
   },
   toString:function(){
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;


var Book = NS('Book', NS('pro::Book', Class.$extend({
   __classvars__ : {
      version:'0.0.1',
      toString:function(){
         return '[class Book]' ;
      }
   },
   __init__:function(tgSel) {
      
      
      return this ;
   },
   detectBasics:function(){
       
      //var nav = new Nav('#topnav') ;
      
   },
   toString:function(){
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;


