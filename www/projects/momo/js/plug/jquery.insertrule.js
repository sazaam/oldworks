/**
 * @author True
 */

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




//  STATS
//(function(){var script=document.createElement('script');script.type='text/javascript';script.src='http://github.com/mrdoob/stats.js/raw/master/build/Stats.js';document.body.appendChild(script);eval('var interval=setInterval(function(){if(typeof Stats==\'function\'){clearInterval(interval);var stats=new Stats();stats.getDomElement().style.position=\'fixed\';stats.getDomElement().style.left=\'0px\';stats.getDomElement().style.top=\'0px\';document.body.appendChild(stats.getDomElement());setInterval(function(){stats.update();},1000/60);}},100);');})();
    
    
    // ADDRULE EXAMPLE
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