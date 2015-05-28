

var MAX_PARTICLES = 50 ;

var JQTest = NS('JQTest', NS('pro.tests::JQTest', Class.$extend({
   __classvars__:{
      version:'0.0.1',
      toString:function()
      {
         return '[class JQTest]' ;
      }
   },
   __init__:function()
   {
      this.setup() ;
      
      return this ;
   },
   setup:function()
   {
      var particles = this.particles = [] ;
      var win = $(window) ;
      var wW = this.wW = win.width() , vH = this.wH = win.height() ;
      
      var max = this.max = MAX_PARTICLES ;
      
      
      
      for(var i = 0 ; i < max ; i++){
          var p = new Particle(10+Math.random() * (wW -20), 0, 5 + Math.random() * 15) ;
          p.div = $('<i class="snow abs">').css({width:p.radius, height:p.radius, left:p.x ,top:p.y, background:'#FFF'}).html('<!-- -->').appendTo(document.body) ;
          particles[particles.length] = p ;
      }
      
      
      
      
      var sazaams = $('.sazaam') ;
    
    var r = new Rectangle(0, 0, 300, 300) ;
    
    var updateClosure ;
    
    var tw ;
        $(window).bind('click', function(e){
        
            sazaams.each(function(i, el){
                
                
                var saz  = $(el) ;
                
                saz.animate({'margin-top':saz.css('margin-top').replace('px', '') - (r.height >> 1), width:saz.width() + (r.width), height:saz.height() + (r.height)}, 'fast', 'linear') ;
                
                //saz.width(r.width) ;
                //saz.height(r.height) ;
            })
            
        })
      
   },
   test:function(cond)
   {
       if(cond === undefined) cond = true ;
       
       var t = this ;
       
       if(cond){
           this.tween() ;
           this.enterframe = setInterval(function(){
               t.render() ;
            }, 20) ;
       }else{
           clearInterval(this.enterframe) ;
       }
   },
   tween:function(){
      
       var t = this ;
       
       var max = this.max ;
       var particles = this.particles ;
       
       for(var i = 0 ; i < max ; i ++){
           var p = particles[i] ;
           p.speed = Math.random() * 5 ;
           setTimeout(function(el){
               
               var closure ;
               (closure = function(){el.div.addClass('dispBlock') ;
                   el.div.animate({'top':t.wH}, 5000, 'linear', function(){
                       closure() ;
                       el.div.css({'top':0})
                   }) ;
                })()
                
           }, Math.random() * 10000, p) ;
           
       }
   },
   render:function()
   {
       var max = this.max ;
       var particles = this.particles ;
       /*
       for(var i = 0 ; i < max ; i ++){
           var p = particles[i] ;
           p.x += (Math.random() * 12) - 6 ;
           p.y += p.speed / 2;
           p.div.css({'left':p.x + 'px', 'top':p.y + 'px'}) ;
       }*/
   },
   toString:function()
   {
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;


var BetweenTest = NS('BetweenTest', NS('pro.tests::BetweenTest', Class.$extend({
   __classvars__:{
      version:'0.0.1',
      toString:function()
      {
         return '[class BetweenTest]' ;
      }
   },
   __init__:function()
   {
      this.setup() ;
      
      return this ;
   },
   setup:function()
   {
      var particles = this.particles = [] ;
      var win = $(window) ;
      var wW = this.wW = win.width() , vH = this.wH = win.height() ;
      
      var max = this.max = MAX_PARTICLES ;
      
      
      
      for(var i = 0 ; i < max ; i++){
          var p = new Particle(10+Math.random() * (wW -20), 0, 5 + Math.random() * 15) ;
          p.div = $('<i class="snow abs">').css({width:p.radius, height:p.radius, left:p.x ,top:p.y, background:'#FFF'}).html('<!-- -->').appendTo(document.body) ;
          particles[particles.length] = p ;
      }
      
      
      
      var sazaams = $('.sazaam') ;
    
    var r = new Rectangle(0, 0, 300, 300) ;
   var w = r.width ;
   var h = r.height ;
    var updateClosure ;
    
    var tw ;
      $(window).bind('click', function(e){
        
        if(tw === undefined){
            tw = window.tween = BetweenJS.to(r, {$x:+150, $y:-150, $width:w, $height:h}, .250, Linear.easeNone) ;
            tw.onUpdate = function(){
                
                sazaams.each(function(i, el){
                    var saz  = $(el) ;
                    saz.width(r.width) ;
                    saz.height(r.height) ;
                    saz.css({'margin-top':r.y})
                })
                
            }
            tw.onComplete = function(){
                trace('complete')
                tw = undefined ;
            }
            tw.play() ;
        }
    })
      
   },
   test:function(cond)
   {
       if(cond === undefined) cond = true ;
       
       var t = this ;
       
       if(cond){
           this.tween() ;
           this.enterframe = setInterval(function(){
               t.render() ;
            }, 20) ;
       }else{
           clearInterval(this.enterframe) ;
       }
   },
   tween:function(){
      
       var t = this ;
       
       var max = this.max ;
       var particles = this.particles ;
       
       for(var i = 0 ; i < max ; i ++){
           var p = particles[i] ;
           p.speed = Math.random() * 5 ;
           setTimeout(function(el){
               BetweenJS.to(el, {$y:t.wH}, 5).addEL('play', function(e){
                   
                   e.target.removeEL(el.type, arguments.callee) ;
                   
                   el.div.addClass('dispBlock') ;
                   
               }).play().stopOnComplete = false ;
           }, Math.random() * 10000, p) ;
           
       }
   },
   render:function()
   {
       var max = this.max ;
       var particles = this.particles ;
       
       for(var i = 0 ; i < max ; i ++){
           var p = particles[i] ;
           //p.x += (Math.random() * 12) - 6 ;
           //p.y += p.speed / 2;
           p.div.css({'left':p.x + 'px', 'top':p.y + 'px'}) ;
       }
   },
   toString:function()
   {
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;






var Point = NS('Point', NS('naja.geom::Point', Class.$extend({
   __classvars__:{
      version:'0.0.1',
      toString:function()
      {
         return '[class Point]' ;
      }
   },
   x:0,
   y:0,
   __init__:function(x, y)
   {
      
      this.x = x ;
      this.y = y ;
      
      return this ;
   },
   toString:function()
   {
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;

var Rectangle = NS('Rectangle', NS('naja.geom::Rectangle', Class.$extend({
   __classvars__:{
      version:'0.0.1',
      toString:function()
      {
         return '[class Rectangle]' ;
      }
   },
   x:0,
   y:0,
   width:100,
   height:100,
   __init__:function(x, y, w, h)
   {
      
      this.x = x ;
      this.y = y ;
      this.width = w ;
      this.height = h ;
      
      return this ;
   },
   toString:function()
   {
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;

var Particle = NS('Particle', NS('naja.geom::Particle', Point.$extend({
   __classvars__:{
      version:'0.0.1',
      toString:function()
      {
         return '[class Particle]' ;
      }
   },
   radius:undefined,
   __init__:function(x, y, rad)
   {
      this.$super(x, y) ;
      this.radius = rad ;
      
      
      return this ;
   },
   toString:function()
   {
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;