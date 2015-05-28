/* ALL HIERARCHY STEPS AND CORE BEHAVIOR */

/* 
 * Spill for FONDATION CARTIER POUR L'ART CONTEMPORAIN 
 * 2011-2012
 * @author saz aka True -> sazaam(at)gmail.com
 * 
 */

var win = window, doc = document, html = document.documentElement, body = document.body ;

// INITIALIZE ALL

AddressHierarchy.parameters = {
   home:'home/',
   base:location.protocol + '//'+ location.host + location.pathname ,
   useLocale:true
}

var content = $('#frameInside') ;
//content.animate({'opacity':0}, 0) ;


// PAGE LOAD
$(win).bind('load', function()
{
    // Fondation Cartier
    trace('SAMUAE v 1.0') ;
    
    if(AddressHierarchy.isReady()){
    	
    	new AddressHierarchy(Unique) ;
		
    }else{
    	// reload to base path
    }
})


var Cyclic = NS('Cyclic', NS('naja.collections::Cyclic', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class Cyclic]' ;
        }
    },
    __init__:function(arr)
    {
        var cy = this ;
        var commands = cy.commands = [] ;
        var startAngle = cy.startAngle = 0 ;
        cy.playhead = NaN ;
        
    },
    push:function(command){
       var cy = this ;
       var commands = cy.commands ;
       
       var l = commands.push(command) ;
       var i = l - 1 ;
       
       cy[i] = function(){
          var unit = cy.unit.index ;
          var sa = cy.startAngle ;
          return {index:i, deg: (unit * 360 * i) + sa, rad: (unit * Math.PI * 2 * i) + (sa /180 * Math.PI)} ;
       } ;
       var div = 1/l ;
       cy.unit = {index:div, deg:div * 360, rad:div * Math.PI * 2} ;
       return l ;
    },
    getPrev:function(n){
       var cy = this ;
       if(n === undefined) n = -1 ;
       n = -(Math.abs(n)) ;
       if(isNaN(cy.playhead)){
          cy.playhead = 0 ;
       }
       var neo = cy.playhead + (n * cy.unit.rad) ;
       neo = neo % (Math.PI * 2) ;
       
       return this.seek(neo) ;
    },
    prev:function(n){
       var cy = this ;
       var item = cy.getPrev(n) ;
       var ind = item.index ;
       var c = cy.commands[ind].execute() ;
       
       cy.playhead = item.rad ;
       cy.index = ind ;
       return c ;
    },
    getNext:function(n){
       var cy = this ;
       
       if(n === undefined) n = 1 ;
       n = Math.abs(n) ;
       if(isNaN(cy.playhead)){
          cy.playhead = -cy.unit.rad ;
       }
       var neo = cy.playhead + (n * cy.unit.rad) ;
       neo = neo % (Math.PI * 2) ;
       return this.seek(neo) ;
    },
    next:function(n){
       var cy = this ;
       var item = cy.getNext(n) ;
       var ind = item.index ;
       var c = cy.commands[ind].execute() ;
       
       cy.playhead = item.rad ;
       cy.index = ind ;
       return c ;
    },
    seek:function(rad){ // relative deg (degree) as relative position index in Array
       var cy = this ;
       var rad, ind ; 
       var pi2 = Math.PI * 2 ;
       var l = cy.commands.length ;
       
       if(rad < 0 ){
          rad = pi2 + rad ;
       }
       if(rad > pi2 || pi2 - rad < cy.unit.rad / 2 ){
          rad = 0 ;
       }
       
       ind = (rad % pi2) / Math.PI / 2 * l ; // ind is the exact SAFE position in Array, without notions of numerous circles
       
       return {index: Math.round(ind), rad: rad} ;
       
    },
    toString:function()
    {
        var cy = this ;
        return '[object Cyclic]' ;
    }
}))) ;

// FOUNDATION CLASSES
var Foundation = NS('Foundation', NS('pro.fcartier::Foundation', Class.$extend({
    __classvars__:{version:'0.0.1',
        toString:function()
        {
            return '[class Foundation]' ;
        }
    },
    absolute:new RegExp(window.location.protocol + '//'),
    external:new RegExp(window.location.protocol + '//' + window.location.host),
    __init__:function()
    {
       window.isSafariMobile = $(document.documentElement).hasClass('Mobile Safari') || $(document.documentElement).hasClass('android') ||  $(document.documentElement).hasClass('ios');
    },
    update:function(step, cond){
       if(cond === undefined) cond = true ;
       
       var level = step.depth ;
       var index = step.index ;
       var indicator = $('#indicnav ol') ;
       
       var li, a, strong, href = step.path.replace(/^\//i, '');
       
       indicator.find('.current').removeClass('current sizeXXLg').addClass('sizeM') ;
       
       if(cond){
       		li = $('<li class="navitem">') ;
       		strong = $('<strong class="Rmargin">'+ '&gt;' +'</strong>') ;
       		
       		a = $('<a href="' + href + '">'+ step.id.replace(/\//gi, '').toUpperCase() +'</a>').appendTo(li) ;
       		a.prepend(strong) ;
       		a.bind('click', function(e){
       			e.preventDefault() ;
       			
       			hierarchy.changer.setValue('/' + hierarchy.changer.locale + href) ;
       		}) ;
       		
       		li.appendTo(indicator) ;
       		li.addClass('current sizeXXLg') ;
       		
       }else{
       		var ch = indicator.children() ;
       		li = $(ch[level-1]) ;
       		li.remove() ;
       		$(ch[level-2]).removeClass('sizeM').addClass('current sizeXXLg') ;
       		
       }
       
       
       
    },
    detectNav:function(step, cond){
        var nn = this ;
        
        if(cond === undefined) cond = true ;
        
        var hidden = step.id === 'home' ? $('.sidenav ul li') : step.userData.cont.find('.hiddennav ul li') ;
        var div, canvasdiv;
        var arrowclosure, wheelclosure , touchstartclosure, touchmoveclosure, touchendclosure, resizeclosure, orientationclosure, mousedownclosure,
        mousestartclosure, mousemoveclosure, mouseendclosure;
        var cont = step.userData.cont ;
        
        
        
        if(cond){
           
           
           var w = cont.width() ;
           var h = cont.height() ;
           
           var arr = [] ;
           
           var max = 16 ;
           var cyclic = window.cyclic = new Cyclic() ;
           cyclic.startAngle = -90 ;
           
           for(var i = 0 ; i < max ; i++){
              var node = $('<div class="circle">'+i+'</div>') ;
              cyclic.push(new Command(node, function(m){
              	
              	var c = this ;
              	trace('formulating command > ', m) ;
              	
              	
              	organize(m) ;
              	
              	
              }, i)) ;
           }
           
           var radius = 250 ;
           var once = true ;
           function organize(n){
           	  
           	  
           	  
              for(var i = 0 ; i < max ; i++){
              	
              	  
	              var ind = n > cyclic.index ? cyclic.getNext(i) : cyclic.getPrev(i) ;
	              var rad = cyclic.unit.rad ;
	              var node = cyclic.commands[ind.index].context ;
	              
	              if(ind.index == n){
	              	node.addClass("black") ;
	              	
	              }else{
	              	node.removeClass("black") ;
	              }
	              if(once === true){
	              	
	              	node.css({'margin-top':(Math.sin(ind.rad) * radius) - 25, 'margin-left': (Math.cos(ind.rad) * radius) - 50}) ;
	              
	              node.appendTo(cont)
	              	
	              }
	              
	              
	              
	          }
	          once = false ;
           }
           
           cyclic.next() ;
           
           $(window).bind('keydown', function(e){
              //e.preventDefault() ;
              
              if (e.keyCode == 37) {
                  e.preventDefault() ;
                   trace( "left pressed" );
                   
                   trace(cyclic.prev()) ;
                }
                if (e.keyCode == 38) {
                  e.preventDefault() ;
                   trace( "up pressed" );
                   
                   //if(parent !== undefined) parenta.trigger('click') ;
                }
                if (e.keyCode == 39) {
                  e.preventDefault() ;
                   trace( "right pressed" );
                   
                   trace(cyclic.next()) ;
                }
                if (e.keyCode == 40) {
                  e.preventDefault() ;
                   trace( "down pressed" );
                   
                   //enter.trigger('click') ;
                }
              
              
           })
           
           
           
        }else{
           
        }
        
        
        	
        
    },
    spinners:function(step, cond){
    	
    	
        var cont = step.userData.cont ;

    	if(cond === true){
			if(step.id === 'home'){
    			window.spinner = new Spinner3D('#canvas', '#FFFFFF', .3, step.parentStep.children.length - 1, 70, 'thinplane', 'lambert').start() ;
    		}else{
    			window.timemachine = new Spinner('#canvas', '#A40133').start() ;
    			window.spinner = new Spinner3D('#canvas', '#A40133' , .6, step.children.length, 70, step.depth > 1 ? 'thickplane' : 'cube', 'basic').start() ;
    		}
    	}else{
    		
    		if(window.spinner !== undefined) {
              	if(window.timemachine !== undefined) {
              		
              		window.timemachine.stop().canvas.remove() ;
              		window.timemachine = undefined ;
              		delete window.timemachine ;
              	}
              	
              	window.spinner.stop().canvas.remove() ;
              	window.spinner = undefined ;
              	delete window.spinner ;
              	
            }
    	}
    },
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
})));

var BaseStep = NS('BaseStep', NS('pro::BaseStep', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class BaseStep]' ;
        }
    },
    status: '' ,
    looping: true ,
    __init__:function(id, label, url)
    {
        this.$super(id, new Command(this, this.onStep), new Command(this, this.onStep, false)) ;
        this.label = label ;
        this.url = url ;
    },
    onStep:function(cond){
        if(cond === undefined) cond = true ;
        var c = this ;
        var step = c.context ;
       
        
        var hh = window.hierarchy ;
        var cont ;
        var url = step.path.replace(/^\//i, '') ;
        
        
        if(cond){
            
            //window.foundation.update(step) ;
            
            $(document.documentElement).addClass(step.id) ;
            
            new AjaxCommand('./content/' + hierarchy.changer.locale + url, function(jxhr){
            	
            	cont = step.userData.cont = $('<div class="rel">').appendTo(content).addClass('dispNone fullH') ;
            	cont.append(jxhr.responseText) ;
            	
            	if(step.id !== 'home') cont.find('.content').addClass('fullH') ;
            	
            	
            	
            	var block = cont.find('.blocImg').addClass('foggy fullH fullBg') ;
            	
            	
            	cont.animate({'opacity':0}, 0) ;
            	
            	step.addSteps(cont) ;
            	
            	step.addEL('focusIn', step.userData.focusIn = function(e){
            		cont.removeClass('dispNone') ;
            		
            		window.foundation.detectNav(step) ;
            		
            		cont.animate({'opacity':1}, 'fast', undefined, function(){
            		
		              	//step.dispatchClearedIn() ;
		            }) ; 
            	}) ;
            	
            	step.addEL('focusOut', step.userData.focusOut = function(e){
            		cont.animate({'opacity':0}, 'fast', undefined, function(){
	                  cont.addClass('dispNone') ;
	                  
	                  window.foundation.detectNav(step, false) ;
	                  step.dispatchClearedOut() ;
	               }) ;
            	}) ;
            	
            	setTimeout(function(){
	               trace('step opened', step.label)
	                c.dispatchComplete() ;
	            }, 1) ;
            	
            }).execute() ;
            if(step.id !== 'home') window.current = undefined ;
        }else{
        	
       		//window.foundation.update(step, false) ;
            
            cont = step.userData.cont ;
            cont.remove() ;
            
            
            step.removeEL('focusIn', step.userData.focusIn) ;
            step.removeEL('focusOut', step.userData.focusOut) ;
            
            setTimeout(function(){
               
               if(step.id !== 'home') window.current = (step.parentStep === step.ancestor) ? step.index - 1 : step.index ;
               $(document.documentElement).removeClass(step.id) ;
               step.empty(true) ; // remove loaded steps
               trace('step closed', step.label)
               c.dispatchComplete() ;
               
            }, 1) ;

        }
        
        return this ;
    },
    addSteps:function(cont){
       var st = this ;
       var nodes = cont.find('.ajaxian a') ;
       
       nodes.each(function(i, el){
       		var a = $(el) ;
        	var href = a.attr('href') ;
        	var path = href.replace(window.hierarchy.changer.locale, '') ;
        	var label = a.attr('title').toLowerCase() ;
        	
        	var step = st.add(new BaseStep(label, path)) ;
       }) ;
    },
    toString:function()
    {
        var st = this ;
        return '[BaseStep >>> id:'+ st.id+' , path: '+st.path +' , label: '+st.label + ' , ' + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
    }
}))) ;

var Unique = NS('Unique', NS('pro::Unique', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        instance:undefined,
        getInstance:function(){ return Unique.instance || new Unique() },
        toString:function()
        {
            return '[class Unique]' ;
        }
    },
    __init__:function()
    {
        this.$super('', new Command(this, this.onStep)) ;
        Unique.instance = this ;
        
        window.foundation = new Foundation() ;
        
        trace('UNIQUE INSTANCIATED...') ;
    },
    onStep:function(){
        trace('UNIQUE STEP OPENING') ;
        
        
        var c = this ;
        var u = c.context ;
        
        u.addSteps() ;
        
        setTimeout(function(){
            c.dispatchComplete() ;
        }, 0);
        
        
        return this ;
    },
    addressComplete:function(e){
       trace('command complete') ;
    },
    addSteps:function(){
    	
        var st = this ;
        
        var toplinks = $('#sidenav .ajaxian a') ;
        trace(toplinks) 
        toplinks.each(function(i, el){
        	var a = $(el) ;
        	var href = a.attr('href').replace(/^\/i/, '') ;
        	var path = href.replace(window.hierarchy.changer.locale, '') ;
        	var label = a.attr('title').toLowerCase() ;
        	
        	var step = st.add(new BaseStep(label, path)) ;
        	
        	a.bind('click', function(e){
        		e.preventDefault() ;
        		
        		hierarchy.changer.setValue(href.replace(/^\//i, '/')) ;
        	}) ;
        	
        }) 
        
        trace('Steps should have been added...')
    },
    toString:function()
    {
        var st = this ;
        return '[Unique >>> id:'+ st.id+' , path: '+ st.path + ((st.children.length > 0) ? '[\n'+ st.dumpChildren() + '\n]' + ']' : ']') ;
    }
}))) ;






// HELPERS FUNCTIONS
function hideContent(cond){
   
   if(cond === undefined) cond = true ;
   
   if(cond){
      $('#all').addClass('dispNone') ;
      window.homeContent = window.homeContent || $('#content').children().remove() ;
   }else{
      $('#all').removeClass('dispNone') ;
   }
}

function loadJSON(url, cb){
   $.ajax({
        url: url,
        dataType: 'json',
        success: cb
   });
}
function simulateJSON(url, cb){
   trace('SimulatingJSON > '+url) ;
   var obj = {} ;
   var navitems = $('#sidenav .ajaxian a') ;
   navitems.each(function(i, el){
   	 var a = $(el) ;
   	 var href = a.attr('href').replace(window.hierarchy.changer.locale, '') ;
   	 var label = a.attr('rel') ;
   	 obj[label] = href ;
   })
   
   setTimout(function(){cb(obj)}, 500) ;
   
}


