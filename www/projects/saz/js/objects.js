var TestCommandQueue = NS(Class.$extend({
	__classvars__:{
		ns:'test::TestCommandQueue',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(){
		this.initCQ() ;
		return this ;
	},
	initCQ : function(){
		var cq = new CommandQueue([
			new CommandQueue(
				[
					new Command('sazaam', function(){
						alert('yo tonton') ;
						var c = this ;
					}),
					new WaitCommand(500)
				]
			),
			new CommandQueue(
				[
					new WaitCommand(500),
					new WaitCommand(500)
				]
			)
		]) ;
		
		cq.addEventListener('$', function(){
			cq.removeEventListener('$', arguments.callee) ;
			alert('completely over...') ;
			cq.destroy() ;
			alert(cq.commands)
		});
		
		cq.execute() ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
})) ;

var TestRequest = NS(Class.$extend({
	__classvars__:{
		ns:'test::TestRequest',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(){
		this.initAjax() ;
		return this ;
	},
	initAjax : function(){		
		var request = new Request('./css/mq.css', function(jxhr, r){
			
			var values = ['status', 'statusText', 'responseText', 'readyState']	;
			var l = values.length ;
			for(var i = 0 ; i < l ; i++){
				trace(values[i] , ' >>> ' , jxhr[values[i]])
			}
			request = new Request('./css/base.css', function(jxhr, r){
			
				var values = ['status', 'statusText', 'responseText', 'readyState']	;
				var l = values.length ;
				for(var i = 0 ; i < l ; i++){
					trace(values[i] , ' >>> ' , jxhr[values[i]])
				}
				alert( r.url)
				
			}).load() ;
			
			
		}).load() ;
		
		
		
		
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
})) ;

var TestRequestCommand = NS(Class.$extend({
	__classvars__:{
		ns:'test::TestRequestCommand',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(){
		this.initAjax() ;
		return this ;
	},
	initAjax : function(){		
		alert('initing')
		var rc = new CommandQueue(
			new AjaxCommand('./img/1.png', function(jxhr, r){
				alert('ok 1') ;
				var c = this ;
				setTimeout(function(){
					c.dispatchComplete() ;
				}, 1000)
			}),
			new AjaxCommand('./img/1.png', function(jxhr, r){
				alert('ok 2')
				var c = this ;
				setTimeout(function(){
					c.dispatchComplete() ;
				}, 1000)
			})
		).execute() ; 
		
		
		rc.addEventListener('$', function(){
			rc.removeEventListener('$', arguments.callee) ;
			alert(rc.commands) ;
			rc.destroy() ;
			alert('cleaned up !') ;
			alert(rc.commands) ;
			
		}) ;
		
		
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
})) ;
/** Written by Peter Wilkinson of http://dynamic-tools.net Feel free to use or modify this script for any purpose. I'd appreciate you leaving this header in though. */ 

/*
function addEvent(elem, eventType, handler) {
	if (!elem.eventHandlers) elem.eventHandlers = []; 
	if (!elem.eventHandlers[eventType]) {
		elem.eventHandlers[eventType] = []; 
		if (elem['on' + eventType]) elem.eventHandlers[eventType].push(elem['on' + eventType]);
		elem['on' + eventType] = handleEvent; 
	}
	elem.eventHandlers[eventType].push(handler);
}

function removeEvent(elem, eventType, handler) { 
	var handlers = elem.eventHandlers[eventType];
	for (var i in handlers) 
	if (handlers[i] == handler) delete handlers[i]; 
}

function handleEvent(e) { 
	var returnValue = true; 
	if (!e) e = fixEvent(event); 
	var handlers = this.eventHandlers[e.type] ;
	for (var i in handlers) {
		this.$$handleEvent = handlers[i];
		returnValue = !((returnValue && this.$$handleEvent(e)) === false);
	} 
	return returnValue;
}

function fixEvent(event) { 
	// add W3C standard event methods 
	event.preventDefault = fixEvent.preventDefault;
	event.stopPropagation = fixEvent.stopPropagation;
	return event;
};

fixEvent.preventDefault = function() { 
	this.returnValue = false; 
};

fixEvent.stopPropagation = function() {
	this.cancelBubble = true;
};
*/
var TestAjax = NS(Class.$extend({
	__classvars__:{
		ns:'test::TestAjax',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(){
		this.initAjax() ;
		return this ;
	},
	initAjax : function(){		
		var t ;
		alert('ajax') ;
		var rc = new CommandQueue(
			new AjaxCommand('./test.html', function(jxhr, r){
				var c = this ;
				t = new Template(jxhr.responseText).load(function(response){
					$('#saz').append(this.response) ;
					c.dispatchComplete() ;
				}) ;
			})
		).execute() ;
		
		$(rc).bind('$', function(){
			$(rc).unbind('$', arguments.callee) ;
			rc.destroy() ;
			
			t.unload() ;
			
			
			alert('cleaned up !') ;
			
		}) ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
})) ;

var TestCSS = NS(Class.$extend({
	__classvars__:{
		ns:'test::TestCSS',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(){
		this.initCSS() ;
		return this ;
	},
	initCSS : function(){
		var test = this ;	
		var t ;
		var rc = test.commandqueue = new CommandQueue(
			new AjaxCommand('./testCanvas.html', function(jxhr, r){
				var c = this ;
				t = test.template = new Template(jxhr.responseText).load(function(){
					var r = this.response ;
					r.animate({'opacity':'0'}, 0) ;
					$('#saz').append(r) ;
					r.animate({'opacity':'1'}, 350, function(){
						
						c.dispatchComplete() ;
						var r = t.response ;
					
						t.init() ;
						
					}) ;
				}) ;
			})
		)
		var opened = false ;
		
		$(document).bind('click', function(){
			if(!!opened){
			r = t.response ;
			/*$(document).unbind('click', arguments.callee) ;
			r.animate({'opacity':'0'}, 350, function(){
				t.unload(function(){
					rc.execute() ;
				}) ;
			}) ; 
			*/	
			}else{
				$(rc).bind('$', function(){
				
					$(rc).unbind('$', arguments.callee) ;
					rc.reset()
					//.destroy() ;
					
					//t.init() ;
					
				}) ;
				
				
				rc.execute() ;
				opened = !opened ;
			}
			
		}) ;		
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
})) ;

var Navigation = NS(Class.$extend({
		__classvars__:{
			ns:'saz::Navigation',
			toString:function(){
				return '[class '+this.ns+']' ;
			}
		},
		__init__:function(){
			this.initCSS() ;
			return this ;
		},
		initCSS:function(){
			var test = this , t, rc = test.commandqueue = new CommandQueue(
				new AjaxCommand('./testCanvas.html', function(jxhr, r){
					var c = this ;
					t = test.template = new Template(jxhr.responseText).load(function(){
						var r = this.response ;
						r.animate({'opacity':'0'}, 0) ;
						$('#saz').append(r) ;
						r.animate({'opacity':'1'}, 350, function(){
							c.dispatchComplete() ;
							var r = t.response ;
							t.init() ;
						}) ;
					}) ;
				})
			) ;
			var opened = false ;
			
			$('#projectsnav ol li').bind('click', function(){
				$(rc).bind('$', function(){					
					$(rc).unbind('$', arguments.callee) ;
					rc.reset() ;
				}) ;
				rc.execute() ;
			}) ;
			
			//rc.execute() ;
			/* TEMPLATE REQUIRMENTS
				- comments
			
			
			*/
			
			/*
			$(document).bind('click', function(){
				if(!!opened){
					r = t.response ;
					
					
					
				}else{
					$(rc).bind('$', function(){
					
						$(rc).unbind('$', arguments.callee) ;
						rc.reset() ;
					}) ;
					rc.execute() ;
					opened = !opened ;
				}
			}) ;
			*/
		},
		toString : function(){
			return '[ object ' + this.$class.ns +']';
		}
})) ;