(
function( $ )
{
  var context = document ;
  var one ;
  if(!!context.createStyleSheet){
      one = one || context.createStyleSheet() ;
  }else{
      context.getElementsByTagName('head')[0].appendChild(context.createElement('style')) ;
      one = one || context.styleSheets[context.styleSheets.length - 1] ;
  }
  $.style={
      insertRule:function(selector,rules,contxt)
      {
        
        var stylesheet = one ;
        if(typeof context.styleSheets == 'object'){
          
          if(!!stylesheet.addRule){
            var l = selector.length ;
            for(var i = 0 ; i < l ; ++i){
              stylesheet.addRule(selector[i], rules) ;
            }
          }else{
            stylesheet.insertRule(selector.join(',') + '{' + rules + '}', stylesheet.cssRules.length) ;  
          }
        }
      }
    };
  }
)( jQuery );

if(/MSIE [0-8]/.test(navigator.userAgent)){
    
    $('.unselectable').each(function(i, el){
        $(el).bind('selectstart', function(e){return false}) ;
    })
}


var win = window, doc = document, html = document.documentElement, body = document.body ;

var twin, twout, reset, saz ;
// INITIALIZE ALL

// Engine initialize
   
// PAGE LOAD
$(win).bind('load', function(e)
{
	
	
	//(function(){var script=document.createElement('script');script.type='text/javascript';script.src='http://github.com/mrdoob/stats.js/raw/master/build/Stats.js';document.body.appendChild(script);eval('var interval=setInterval(function(){if(typeof Stats==\'function\'){clearInterval(interval);var stats=new Stats();stats.getDomElement().style.position=\'fixed\';stats.getDomElement().style.left=\'0px\';stats.getDomElement().style.top=\'0px\';document.body.appendChild(stats.getDomElement());setInterval(function(){stats.update();},1000/60);}},100);');})();
	
	/*
	PROPERTIES = {
	    'top':['px', '%', 'em', 'pc' ]
	}
	
	// OPACITY 1<n<100
	for(var i = 0 ; i <= 100 ; i++){
	    $.style.insertRule(['.alpha-'+ i],'opacity:'+i/100+';') ;
	    //$.style.insertRule(['.MSIE .alpha-'+ i],'filter:alpha(opacity='+i+');') ;
	}
	// COORDS >> PX 
	//     WIDTH
	//     HEIGHT
	//     TOP
	//     LEFT
	//     BOTTOM
	//     RIGHT
	//     MARGINTOP
	//     MARGINLEFT
	//     MARGINBOTTOM
	//     MARGINRIGHT
	
	for(var i = 0 ; i <= 3000 ; i++){
        $.style.insertRule(['.width-'+ i], 'width:'+i+'px !important;') ;
        $.style.insertRule(['.height-'+ i], 'height:'+i+'px !important;') ;
        $.style.insertRule(['.top-'+ (-i)], 'top:'+(-i)+'px !important;') ;
    }*/
   
   /*
    
	var r = new Rectangle(0,0,40,40) ;
	var test = $('#test') ;
	var w = 400 ;
	var h = 400 ;
	var render = function(){
	    var t = test[0] ;
        var n = r.width ;
        var n2 = r.height ;
        var pct = ((n / 300) * 50) + 50 ;
        var cl = Math.round(pct) ;
        var cl2 = Math.max(Math.round(n), 0) ;
        var cl3 = Math.max(Math.round(n2), 0) ;
        var cl4 = -Math.round(n2/2 - 20) ;
        
        t.className = t.className.replace(/( ?top-+\d+| ?alpha-+\d+| ?width-\d+| ?height-\d+)/gm, '')
        +' alpha-'+cl+' height-'+cl3 +' width-'+cl2+ ' top-'+cl4 ;
	} ;
	BetweenJS.apply(r, {'width':40, 'height':40}) ;
	render() ;
	var twin = BetweenJS.to(r, {'width':w, 'height':h},
	   .85,
	   Elastic.easeOut).addEL('update', render) ;
	var twout = BetweenJS.to(r, {'width':40, 'height':40},
	   .35, 
	   Expo.easeOut).addEL('update', render) ;
    
	$(document.body).bind('click', function(e){
	    
	    var pos ;
        if(test.data('opened') !== true){
            if(twout.isPlaying) {
                //pos = twout.position ;
                twout.stop() ;
                //twout.gotoAndStop(0) ;
                
                //twin.gotoAndPlay(twin.time - pos) ;
            }else{
               //twin.play() ; 
            }
            twin.gotoAndPlay(0) ;
            test.data('opened', true) ;
        }else{
            if(twin.isPlaying){
                //pos = twin.position ;
                twin.stop() ;
                //twin.gotoAndStop(0) ;
                
                //twout.gotoAndPlay(twin.time - pos) ;
            }else{
                //twout.play() ;
            }
            twout.gotoAndPlay(0) ;
            test.data('opened', false) ;
        }
    })
	*/
	/*
	var test = window.test = new BetweenTest() ;
	test.test() ;
	*/
	
	/*
    var test = window.test = new JQTest() ;
    test.test() ;
	*/
	/*
	var test = window.test = new BetweenTest() ;
    test.test() ;
	*/
	    saz = $('#test') ;
	    
	    reset = function(){
            window.twin.gotoAndStop(0) ;
            saz.data('opened', false) ;
        }
	
		
		
		var h = 40 ;
		var w = 40 ;
		var W = 400 ;
		var H = 600 ;
		
		var tw1 = BetweenJS.tween( saz[0], 
		   {
		       'width':W,
    		   'height':H,
    		   'borderRadius':20,
               'borderWidth':1,
               'opacity::NONE':1
	   	   },
	   	   {
               'width':w,
               'height':h,
               'borderRadius':0,
               'opacity::NONE':.4,
               'borderWidth':50
           },
	       .35,
	       Elastic.easeOut
	    ) ;
	    
	    var tw2 = BetweenJS.tween(saz[0],
           {
               'width':w,
               'height':h,
               'borderRadius':0,
               'borderWidth':50,
               'opacity::NONE':.4
           },
           {
               'width':W,
               'height':H,
               'borderRadius':20,
               'borderWidth':1,
               'opacity::NONE':1
           },
	       .35, 
           Expo.easeOut
	    )
        
		window.twin = tw1 ;
        window.twout = tw2 ;
        
        reset() ;
        
        
        var code = $('#code') ;
        $('#evaluator').bind('click', function(e){
            
            e.preventDefault() ;
            var str = code.attr('value') ;
            eval(str) ;
            
        }) ;
        
        
        code.bind('mousewheel', function(e, delta){
            //$('#code').scroll(30) ;
            code[0].scrollTop += 100 * (delta / (Math.min(delta, -delta))) ;
            trace('hey yooo', delta)
        }) ;
        
		$('#viewport').bind('click', function(e){
		    var pos ;
            if(saz.data('opened') !== true){
                if(window.twout.isPlaying) {
                    pos = window.twout.time - window.twout.position ;
                    window.twout.stop() ;
                    window.twout.gotoAndStop(0) ;
                    window.twin.gotoAndPlay(window.twout.time) ;
                }
                window.twin.play() ;
                saz.data('opened', true) ;
            }else{
                if(window.twin.isPlaying){
                    pos = twin.time - window.twin.position ;
                    window.twin.stop() ;
                    window.twin.gotoAndStop(0) ;
                    window.twout.gotoAndPlay(window.twin.time) ;
                }
                window.twout.play() ;
                saz.data('opened', false) ;
            }
		})
		/**/
		
		
		
		
		
		
})




/*
var a = new EventDispatcher(window) ;
a.addEL('tonton', function(e){
    trace(e.target)
    trace('coucou load')
})
var b = new EventDispatcher(window).copyFrom(a) ;
b.dispatch('tonton') ;
*/




/*
//   CUSTOM EVENTS TEST
var ev = new TweenEvent(TweenEvent.START);

$(window).bind(TweenEvent.START, function(e){
   
   trace(e instanceof TweenEvent) ;
   trace('received') ;
}) ;

$(window).trigger(ev) ;
*/
