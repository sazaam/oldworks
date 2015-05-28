/* ALL HIERARCHY STEPS AND CORE BEHAVIOR */

/* 
 * Spill for FONDATION CARTIER POUR L'ART CONTEMPORAIN 
 * 2011-2012
 * @author saz aka True -> sazaam(at)gmail.com
 * 
 */

module.exports = Pkg.write('com.sazaam.steps', function(){
	
	
	var HomeStep = Type.define(function(){
		
		var Appear = Pkg.definition('org.3Dutils.fx::Appear') ;
		var appear ;
		
		return {
			pkg:'::HomeStep',
			inherits:Step,
			constructor:HomeStep = function HomeStep(id, label, color){
				HomeStep.base.apply(this, [id, new Command(this, this.onStep), new Command(this, this.onStep, false)]) ;
				this.label = label ;
				this.color = color ;
			},
			onStep:function(cond){
				if(cond === undefined) cond = true ;
				var c = this ;
				
				var step = c.context ;
				
				//main container
				var content = $('#scope') ;

				if(cond){
					
					setTimeout(function(){
						
						step.tweenIn(content, function(){
							c.dispatchComplete() ;
						}) ;
						
					}, 0) ;
					
				}else{
					
					setTimeout(function(){
						
						step.tweenOut(content, function(){
							c.dispatchComplete() ;
						}) ;
						
					}, 0) ;
				}
				return this ;
			},
			tweenIn:function(content, cb){
				
				
				
				if(appear === undefined) appear = new Appear($('#anchor'), $('#scope')) ;
				appear.open(cb, this.color) ;
				
			},
			tweenOut:function(content, cb){
				
				cb() ;
				
			},
			toString:function()
			{
				var st = this ;
				return '[HomeStep >>> id:'+ st.id+' , path: '+st.path +' , label: '+st.label + ' , ' + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
			}
		}
	}) ;
	
	var Unique = Type.define({
		pkg:'::Unique',
		inherits:Step,
		constructor:Unique = function Unique(){
			Unique.base.apply(this, ['', new Command(this, this.onSite)]) ;
			Unique.instance = this ;
			
		},
		statics:{
			instance:undefined,
			getInstance:function(){ return Unique.instance || new Unique() },
			initJSAddress:function initJSAddress(){ 
				
				Unique.getInstance().commandOpen.dispatchComplete() ;
				
			}
		},
		onSite:function(){
			trace('UNIQUE STEP OPENING') ;
			
			var c = this ;
			var u = c.context ;
			
			u.addSteps() ;
			
			// setTimeout(function(){
				// c.dispatchComplete() ;
			// }, 3050);
			
			return this ;
		},
		addressComplete:function(e){
		   trace('command complete') ;
		},
		addSteps:function(){
			var st = this ;
			
			
			// st.add(new HomeStep('home', 'home/', '#BBBBBB') ) ;
			
			var toplinks = $('.bottomnav li a') ;
			toplinks.each(function(i, el){
				var link = $(el) ;
				var url = link.attr('href') ;
				var txt = link.html().toLowerCase() ;
				var color = link.attr('rel') ;
				
				link.attr('href', AddressChanger.hashEnable(url)) ;
				
				st.add(new HomeStep(txt, txt+'/', color) ) ;
				
			})
			
			
			
			
		},
		toString:function(){
			var st = this ;
			return '[Unique >>> id:'+ st.id+' , path: '+ st.path + ((st.children.length > 0) ? '[\n'+ st.dumpChildren() + '\n]' + ']' : ']') ;
		}
	}) ;
	
	return Unique ;
	
})