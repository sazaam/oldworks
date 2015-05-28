/*
 *
 * BETWEENJS Tweening Engine for Javascript
 * 
 * V 0.95
 * 
 * Dependancies : 
 * 	jQuery 1.6.1+ (required for event handling)
 * 
 * Highly Inspired by Yossi (up to the name)
 * yossi(at)be-interactive.org
 * 
 * author saz aka True
 * 
 * licensed under GNU GPL-General Public License
 * copyright sazaam[(at)gmail.com]
 * 2011-2012
 * 
 */

'use strict' ;
// REQUESTANIMATIONFRAME implementation BY PAUL IRISH
(function() {
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame = 
          window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
    }
 
    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); }, 
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };
 
    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
})() ;

if(Class === undefined){
	
	/* 
		ClassLite Version 1.0

		@author saz aka True
		API Inspired by Classy (http://classy.pocoo.org)
	*/
	var Class = (function(){
		var ns = {}, ks, no_ctor = false, regNS = /::/ , keep = {'__static__':1 , '$ns':1, '$pkg':1, '$classname':1, 'toString':1} ;
		return ks = function(namespace, properties, extendclass){
			var xt = extendclass, path = namespace, obj = properties , cl , spy ;
			if(regNS.test(path)) return ks(path.replace(regNS, '.'), obj, xt) ;
			var sp = path.split('.') ;
			var l = sp.length, p = ns, ch ;
			for(var i = 0 ; i < l ; i++)
				ch = sp[i], (i < l - 1) && (p = (!!p[ch] ? p[ch] : (p[ch] = {name:ch}))) ;
			cl = p[ch] ;
			if(obj !== undefined) cl = undefined ;
			return cl || (function(){
				var kl = function(){return (no_ctor)? this : '__init__' in this ? this['__init__'].apply(this, arguments) : this } ;
				kl.$ns = path.replace(/((.*)[.])*([^.]+)$/i, function($0, $1, $2, $3){return kl.$pkg = $2, kl.$classname = $3, $0 }) ;
				kl.toString = function(){ return '[object ' + path + ']' } ;
				if(!!xt) {
					spy = xt.prototype, kl.$super = xt;
					kl.prototype = (function(el) { return no_ctor = true, el = new xt, no_ctor = false, el })() ;
					for(var i in xt) if(!!!kl[i] && !(i in keep)) kl[i] = xt[i] ;
				}
				kl.prototype.constructor = kl.prototype.$class = kl ;
				if('__classvars__' in obj){
					for(var i in obj['__classvars__']) kl[i] = obj['__classvars__'][i] ;
					delete obj['__classvars__'] ;
				}
				kl.prototype.toString = function(){	return '[object ' +  path + ']' }
				for(var s in obj)
					kl.prototype[s] =
						(!!xt && typeof obj[s] == 'function') ?
						(function(meth, name, nn, old_super) {return function() {return (old_super = this.$super, this.$super = spy[name] , nn = meth.apply(this, arguments), this.$super = old_super , nn)}})(obj[s], s) 
						: obj[s] ;
				('__static__' in kl) && kl.__static__.apply(kl) ;
				return (p[ch] = kl) ;
			})() ;
		} ;
	})() ;
	
	
}

if(Class('naja.net::IEvent') === undefined){ // Forcing Writing Naja evt implementation
	
	var IEvent = Class('naja.net::IEvent', {
	   __init__:function(type, data)
	   {
		  if(type instanceof jQuery.Event) {
			 for(var s in type){
				this[s] = type[s] ;
			 }
		  }else{
			 this.type = type ;
			 for(var s in data){
				this[s] = data[s] ;
			 }
		  }
		  
		  return this ;
	   }
	}, jQuery.Event) ;
	
	var EventDispatcher = Class('naja.event::EventDispatcher', {
		__init__:function(el)
		{
			this.setDispatcher(el || this) ;
		},
		setDispatcher:function(el) // @return void
		{
			this.dispatcher = $(el) ;
			this.target = (typeof(el) == 'string') ? this.dispatcher[0] : el ;
		},
		hasEL:function(type) // @return Boolean
		{
			var dataEvents = this.dispatcher.data('events') ;
			if(dataEvents !== undefined) {
				return type in dataEvents ;
			}
			return false ;
		},
		willTrigger:function(type) // @return Boolean
		{
			var dataEvents = this.dispatcher.data('events') ;
			if(dataEvents !== undefined) {
				return type in dataEvents ;
			}
			return false ;
		},
		dispatch:function(e) // @return void
		{
			if(this.dispatcher !== undefined)
			this.dispatcher.trigger(e) ;
		},
		addEL:function(type, closure) // @return Boolean
		{
			if(this.dispatcher !== undefined){
				this.dispatcher.bind(type, closure) ;
			}
			return this ;
		},
		bind:function(type, closure){
			return this.addEL(type, closure) ;
		},
		removeEL:function(type, closure) // @return Boolean
		{
			if(this.dispatcher !== undefined)
			this.dispatcher.unbind(type, closure) ;
			return this ;
		},
		unbind:function(type, closure){
			return this.removeEL(type, closure) ;
		},
		copyFrom:function(source)
		{
			if(!source instanceof EventDispatcher) {
				trace('wrong input for EventDispatcher CopyFrom...');
				return ;
			}
			if(source.dispatcher !== undefined) this.setDispatcher(source.target) ;
			var listeners = source.dispatcher.data('events') ;
			if(listeners !== undefined){
				for (var type in listeners) {
					var list = listeners[type] ;
					var l = list.length;
					for (var i = 0; i < l; ++i) {
						var data = list[i] ;
						this.addEL(type, data.listener);
					}
				}
			}
			return this ;
		}
	}) ;
	
}

var BetweenJS = (function(){
	// GetTimer Implementation
	
	var getTimer = getTimer || function(){
	   return new Date().getTime() - ___d ;
	} , ___d = new Date().getTime() ;
	// will need that...
	function concat(p){
		return (CSSPropertyMapper.isIE && p === undefined) ? [] : p ;
	}
	
	/* BETWEENJS 
		Main class, all methods considerated static, needless instantiation
		BetweenJS.core() method supposed to be executed ok after script evaluation
	*/
	var BetweenJS = Class('org.libspark.betweenJS::BetweenJS', {
		__classvars__:{
			ticker:undefined, // main and unique ticker, see class EnterFrameTicker
			getTimer:getTimer, // points towards shortened-scope getTimer method
			updaterFactory:undefined, // all in the name, generated updaters are intermede objects between tweens and their target
			/*
				Core (static-like init), where 
				main Ticker instance created & launched, 
				(also set to tick forever from start, to disable, @see BetweenJS.ticker.stop())
			*/
			core:function(){
				var cored = BetweenJS.cored ;
				if(cored === true) return ;
				
				CSSPropertyMapper.core() ;
				
				BetweenJS.ticker = new EnterFrameTicker() ;
				BetweenJS.ticker.start() ;
				
				BetweenJS.updaterFactory = new UpdaterFactory() ;
				BetweenJS.cored = true ;
			},
			/*
				tween
				
				Creates a regular tween object.
				Takes in a target object, any object. Values in target such as numerals or other objects with numerals, will be able to tween.
				Passing in a 'to' and a 'from' object will set source and destination values for the tween.
				time is the duration of the tween.
				set an easing for the tween in the set of provided easings, or custom one @see CustomFunctionEasing
				
				@param target Object/HtmlDomElement
				@param to Object
				@param from Object
				@param time Float (default : 1.0)
				@param easing Easing (default : Linear.easeNone)
				
				@return TweenLike Object
			*/
			tween:function(target, to, from, time, easing){
				var tween = new ObjectTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.create(target, to, from) ;
				tween.time = time || 1.0 ;
				tween.easing = easing || Linear.easeNone ;
				return tween ;
			},
			/*
				to
				
				@param target Object/HtmlDomElement
				@param to Object
				@param time Float (default : 1.0)
				@param easing Easing (default : Linear.easeNone)
				
				@return TweenLike Object
			*/
			to:function(target, to, time, easing){
				var tween = new ObjectTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.create(target, to, undefined) ;
				tween.time = time || 1.0 ;
				tween.easing = easing || Linear.easeNone ;
				return tween ;
			},
			/*
				from
				
				@param target Object/HtmlDomElement
				@param from Object
				@param time Float (default : 1.0)
				@param easing Easing (default : Linear.easeNone)
				
				@return TweenLike Object
			*/
			from:function(target, from, time, easing){
				var tween = new ObjectTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.create(target, undefined, from) ;
				tween.time = time || 1.0 ;
				tween.easing = easing || Linear.easeNone ;
				return tween ;
			},
			/*
				apply
				
				@param target Object/HtmlDomElement
				@param to Object
				@param from Object
				@param time Float (default : 1.0)
				@param applyTime Float (default : 1.0)
				@param easing Easing (default : Linear.easeNone)
				
				@return TweenLike Object
			*/
			apply:function(target, to, from, time, applyTime, easing){
				var tween = new ObjectTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.create(target, to, from) ;
				tween.time = time || 1.0 ;
				tween.easing = easing || Linear.easeNone ;
				tween.update(applyTime || tween.time) ;
				return tween ;
			},
			/*
				bezier
				
				@param target Object/HtmlDomElement
				@param to Object
				@param from Object
				@param controlPoint Object
				@param time Float (default : 1.0)
				@param easing Easing (default : Linear.easeNone)
				
				@return TweenLike Object
			*/
			bezier:function(target, to, from, controlPoint, time, easing){
				var tween = new ObjectTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.createBezier(target, to, from, controlPoint) ;
				tween.time = time || 1.0 ;
				tween.easing = easing || Linear.easeNone ;
				return tween ;
			},
			/*
				bezierTo
				
				@param target Object/HtmlDomElement
				@param to Object
				@param controlPoint Object
				@param time Float (default : 1.0)
				@param easing Easing (default : Linear.easeNone)
				
				@return TweenLike Object
			*/
			bezierTo:function(target, to, controlPoint, time, easing){
				var tween = new ObjectTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.createBezier(target, to, undefined, controlPoint) ;
				tween.time = time || 1.0 ;
				tween.easing = easing || Linear.easeNone ;
				return tween ;
			},
			/*
				bezierFrom
				
				@param target Object/HtmlDomElement
				@param from Object
				@param controlPoint Object
				@param time Float (default : 1.0)
				@param easing Easing (default : Linear.easeNone)
				
				@return TweenLike Object
			*/
			bezierFrom:function(target, from, controlPoint, time, easing){
				var tween = new ObjectTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.createBezier(target, undefined, from, controlPoint) ;
				tween.time = time || 1.0 ;
				tween.easing = easing || Linear.easeNone ;
				return tween ;
			},
			/*
				physical
				
				@param target Object/HtmlDomElement
				@param to Object
				@param from Object
				@param easing Easing (default : Physical.exponential())
				
				@return TweenLike Object
			*/
			physical:function(target, to, from, easing){
				var tween = new PhysicalTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.createPhysical(target, to, from, easing || Physical.exponential()) ;
				return tween ;
			},
			/*
				physicalTo
				
				@param target Object/HtmlDomElement
				@param to Object
				@param easing Easing (default : Physical.exponential())
				
				@return TweenLike Object
			*/
			physicalTo:function(target, to, easing){
				var tween = new PhysicalTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.createPhysical(target, to, undefined, easing || Physical.exponential()) ;
				return tween ;
			},
			/*
				physicalFrom
				
				@param target Object/HtmlDomElement
				@param from Object
				@param easing Easing (default : Physical.exponential())
				
				@return TweenLike Object
			*/
			physicalFrom:function(target, from, easing){
				var tween = new PhysicalTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.createPhysical(target, undefined, from, easing || Physical.exponential()) ;
				return tween ;
			},
			/*
				physicalApply
				
				@param target Object/HtmlDomElement
				@param to Object
				@param from Object
				@param applyTime Float (default : 1.0)
				@param easing Easing (default : Physical.exponential())
				
				@return TweenLike Object
			*/
			physicalApply:function(target, to, from, applyTime, easing){
				var tween = new PhysicalTween(BetweenJS.ticker) ;
				tween.updater = BetweenJS.updaterFactory.createPhysical(target, to, from, easing || Physical.exponential()) ;
				tween.update(applyTime || 1.0) ;
				return tween ;
			},
			/*
				parallel
				
				@param [tween TweenLike, ...]
				
				@return TweenLike Object
			*/
			parallel:function(tween){
				return BetweenJS.parallelTweens([].slice.call(arguments)) ;
			},
			/*
				parallelTweens
				
				@param tweens Array[TweenLike]
				
				@return TweenLike Object
			*/
			parallelTweens:function(tweens){
				return new ParallelTween(tweens, BetweenJS.ticker, 0) ;
			},
			/*
				serial
				
				@param [tween TweenLike, ...]
				
				@return TweenLike Object
			*/
			serial:function(tween){
				return BetweenJS.serialTweens([].slice.call(arguments)) ;
			},
			/*
				serialTweens
				
				@param tweens Array[TweenLike]
				
				@return TweenLike Object
			*/
			serialTweens:function(tweens){
				return new SerialTween(tweens, BetweenJS.ticker, 0) ;
			},
			/*
				reverse
				
				@param tween TweenLike
				@param reversePosition Float (default : 0.0)
				
				@return TweenLike TweenDecorator Object
			*/
			reverse:function(tween, reversePosition){
				if(reversePosition === undefined) reversePosition = false ;
				var pos = reversePosition !== undefined ? tween.time - tween.position : 0.0 ;
				if (tween instanceof ReversedTween) {
					return new TweenDecorator(tween.baseTween, pos) ;
				}
				if (tween instanceof TweenDecorator) {
					tween = tween.baseTween ;
				}
				return new ReversedTween(tween, pos) ;
			},
			/*
				repeat
				
				@param tween TweenLike
				@param repeatCount Integer (default : 2)
				
				@return TweenLike TweenDecorator Object
			*/
			repeat:function(tween, repeatCount){
				return new RepeatedTween(tween, repeatCount) ;
			},
			/*
				repeat
				
				@param tween TweenLike
				@param scale Float (percent, default : 1)
				
				@return TweenLike TweenDecorator Object
			*/
			scale:function(tween, scale){
				return new ScaledTween(tween, scale) ;
			},
			/*
				slice
				
				@param tween TweenLike
				@param begin Float (default : 0)
				@param end Float (default : 1)
				@param isPercent Boolean (default : false)
				
				@return TweenLike TweenDecorator Object
			*/
			slice:function(tween, begin, end, isPercent){
				if(begin === undefined) begin = 0 ;
				if(end === undefined) end = 1 ;
				if(isPercent === undefined) isPercent = false ;
				if(isPercent){
					begin = tween.time * begin ;
					end = tween.time * end ;
				}
				if (begin > end) {
					return new ReversedTween(new SlicedTween(tween, end, begin), 0) ;
				}
				return new SlicedTween(tween, begin, end) ;
			},
			/*
				delay
				
				@param tween TweenLike
				@param delay Float (default : 0)
				@param postDelay Float (default : 0)
				
				@return TweenLike TweenDecorator Object
			*/
			delay:function(tween, delay, postDelay){
				return new DelayedTween(tween, delay || 0, postDelay || 0) ;
			},
			/*
				addChild
				
				@param target HtmlDomElement
				@param parent HtmlDomElement
				
				@return TweenLike AbstactActionTween Object
			*/
			addChild:function(target, parent){
				return new AddChildAction(BetweenJS.ticker, target, parent) ;
			},
			/*
				removeFromParent
				
				@param target HtmlDomElement
				@param parent HtmlDomElement
				
				@return TweenLike AbstactActionTween Object
			*/
			removeFromParent:function(target){
				return new RemoveFromParentAction(BetweenJS.ticker, target) ;
			},
			/*
				func
				
				@param func Function
				@param params Array
				@param useRollback Boolean
				@param rollbackFunc Function
				@param rollbackParams Array
				
				@return TweenLike AbstactActionTween Object
			*/
			func:function(func, params, useRollback, rollbackFunc, rollbackParams){
				return new FunctionAction(BetweenJS.ticker, func, params, useRollback, rollbackFunc, rollbackParams) ;
			},
			/*
				timeout
				
				@param duration Float
				@param func Function
				@param params Array
				
				@return TweenLike AbstactActionTween Object
			*/
			timeout:function(duration, func, params){
				return new TimeoutAction(BetweenJS.ticker, duration, func, params) ;
			},
			/*
				interval
				
				@param timer Integer
				@param func Function
				@param params Array
				
				@return TweenLike AbstactActionTween Object
			*/
			interval:function(timer, func, params){
				return new IntervalAction(BetweenJS.ticker, timer, func, params) ;
			}
		},
		__init__:function(){
		   trace('Not meant to be instanciated...') ;
		}
	}) ;

	var CSSPropertyMapper = Class('org.libspark.betweenJS::CSSPropertyMapper', {
		__classvars__:{
			core:function(){
				var cored = this.cored ;
				
				if(cored === true) return ;
				
				var comp = window.getComputedStyle ;
				CSSPropertyMapper.hasComputedStyle = comp !== undefined && typeof(comp) == 'function';
				CSSPropertyMapper.isIE = /MSIE/.test(navigator.userAgent) ;
				CSSPropertyMapper.isIEunder9 = /MSIE [0-8]/.test(navigator.userAgent) ;
				CSSPropertyMapper.isIEunder8 = /MSIE [0-7]/.test(navigator.userAgent) ;
				
				this.cored = true ;
			},
			formats:{
				'positionprop':/scroll(left|top)?/gi,
				'separatorprop':/-/,
				'extendedprop':/^./,
				'colorextprop':/((border|background)?color|background)[^:]*$/gi,
				'colorprop':/::(rgba?|hsba?|#)$/,
				'complexprop':/^./
			},
			cache:{},
			getScroll:function(target, name, unit) {
			  return (target === window || target === document) ?
			  (
				this[(name == 'scrollTop') ? 'pageYOffset' : 'pageXOffset'] ||
				(CSSPropertyMapper.isIEunder9 && document.documentElement[name]) ||
				document.body[name]
			  ) :
			  target[name] ;
			},
			setScroll:function(target, name, unit, val) {
			  if(target === window || target === document){
				try{
					this[(name == 'scrollTop') ? 'pageYOffset' : 'pageXOffset'] = parseInt(val) ;
				}catch(e){
					if(!CSSPropertyMapper.isIEunder8) document.documentElement[name] = parseInt(val) ;
					else document.body[name] = parseInt(val) ;
				}
			  }else{
				target[name] = parseInt(val) ;
			  }
			},
			cssHackGet:function(el, name){
				if (el.currentStyle) {
					if (/backgroundcolor/i.test(name)) {
					  return (function (elm) { // get a rgb based color on IE
						var oRG = document.body.createTextRange() ;
						oRG.moveToElementText(elm) ;
						var iClr = oRG.queryCommandValue("BackColor") ;
						  return "rgb(" + (iClr & 0xFF) + "," + ((iClr & 0xFF00) >> 8) + "," + ((iClr & 0xFF0000) >> 16) + ")" ;
					  })(el) ;
					}
					return el.currentStyle[name] ;
				}
			},
			cssSimpleGet:function(target, pname, unit){
				var str = target['style'][pname] ;
				if(str == '') str = CSSPropertyMapper.hasComputedStyle ? 
					window.getComputedStyle (target, '')[pname] :
					target.currentStyle[pname] ;
				
				return Number(unit == '' ? str : str.replace(new RegExp(unit+'.*$'), ''))
			},
			cssColorGet:function(target, pname, unit){
				var val ;
				if(CSSPropertyMapper.hasComputedStyle){
					var shortreg = /(border)(width|color)/gi ;
					if(shortreg.test(pname)){
						pname = pname.replace(shortreg, '$1Top$2') ;
					}
					val = (target.style[pname] !== '') ? target.style[pname] : window.getComputedStyle (target, '')[pname] ;
				}else{
					val = pname == 'backgroundColor' ? target.currentStyle[pname] : CSSPropertyMapper.cssHackGet(target, pname)
				}
				
				if(val == '') val = 'transparent' ;
				
				switch(true){
					case (/^#/.test(val)) :
						var hex = val.replace(/^#/, '') ;
						if(hex.length == 3){
							hex = hex.charAt(0) + hex.charAt(0) + hex.charAt(1) + hex.charAt(1) + hex.charAt(2) + hex.charAt(2) ;
						}
						n = parseInt('0x'+hex) ;
					break ;
					
					case (/rgb/i.test(val)) :
						var str = val.replace(/(rgb\(|\)| )/gi, '') ;
						
						var p = str.split(',') ;
						var r = (p[0] & 0xFF), 
						g = (p[1] & 0xFF), 
						b = (p[2] & 0xFF) ;
						return {r:r,g:g,b:b} ;
					break ;
				}
				return {r:(n & 0xFF0000) >> 16,g:(n & 0xFF00) >> 8,b:(n & 0xFF)} ;
			},
			cssColorSet:function(target, pname, unit, val){
				var n , hex;
				switch(true){
					case !isNaN(hex = parseInt(val)) :
						target['style'][pname] = '#' + hex.toString(16) ;
					break ;
					case isNaN(val) && typeof(val) != 'string':
						var r = parseInt(val.r), 
						g = parseInt(val.g), 
						b = parseInt(val.b) ;
						target['style'][pname] = 'rgb('+r+','+g+','+b+')'  ;
					break ;
					case (/^#/.test(val)) :
						hex = val.replace(/^#/, '') ;
						if(hex.length == 3){
							hex = hex.charAt(0) + hex.charAt(0) + hex.charAt(1) + hex.charAt(1) + hex.charAt(2) + hex.charAt(2) ;
						}
						n = parseInt('0x'+hex) ;
					break ;
					
					case (/rgb/i.test(val)) :
						var str = val.replace(/(rgb\(|\)| )/gi, '') ;
						
						var p = str.split(',') ;
						var r = (p[0] & 0xFF).toString(16), 
						g = (p[1] & 0xFF).toString(16), 
						b = (p[2] & 0xFF).toString(16) ;
						
						if(r.length == 1) r += r ;
						if(g.length == 1) g += g ; 
						if(b.length == 1) b += b ; 
						
						n = parseInt('0x'+ r + g + b) ;
					break ;
				}
			},
			cssSimpleSet:function(target, pname, unit, val){
				target['style'][pname] = val + unit ;
			},
			cssScrollPositionGet:function(target, pname, unit){
				return CSSPropertyMapper.getScroll(target, pname, unit) ;
			},
			cssScrollPositionSet:function(target, pname, unit, val){
				CSSPropertyMapper.setScroll(target, pname, unit, val) ;
			},
			check:function(name){
				var formats = CSSPropertyMapper.formats ;
				var cache = CSSPropertyMapper.cache ;
				
				if(name in cache) {return cache[name] } ;
				
				var o ;
				switch(true){
					case formats['positionprop'].test(name) :
						o = {
							cssprop:name,
							cssget:CSSPropertyMapper.cssScrollPositionGet,
							cssset:CSSPropertyMapper.cssScrollPositionSet
						} ;
					break ;
					case formats['separatorprop'].test(name) :
						return (cache[name] = CSSPropertyMapper.check(name.replace(/-(\w)/g, function($0, $1){return $1.toUpperCase()}))) ;
					break ;
					case formats['colorextprop'].test(name) :
						return (cache[name] = CSSPropertyMapper.check(name + '::#')) ;
					break ;
					case formats['colorprop'].test(name) :
						o = {
							cssprop:name.replace(formats['colorprop'], ''),
							cssget:CSSPropertyMapper.cssColorGet,
							cssset:CSSPropertyMapper.cssColorSet
						} ;
					break ;
					default :
						o = {
							cssprop:name,
							cssget:CSSPropertyMapper.cssSimpleGet,
							cssset:CSSPropertyMapper.cssSimpleSet
						}
					break ;
				}
				cache[name] = o ;
				return o ;
			}
		},
		__init__:function(){
		   trace('Not meant to be instanciated...') ;
		}
	}) ;

	// CORE.UPDATERS
	var UpdaterFactory = Class('org.libspark.betweenJS.core.updaters::UpdaterFactory', {
		__classvars__:{
			instance:undefined,
			getInstance:function(){
				return UpdaterFactory.instance || (UpdaterFactory.instance = new UpdaterFactory()) ;
			}
		},
		poolIndex:0,
		mapPool:[],
		listPool:[],
		__init__:function(){
		   return this ;
		},
		create:function(target, dest, source){
			var map, updaters, name, value, isRelative, parent, child, updater ;
			var units ;
			if (this.poolIndex > 0) {
				--this.poolIndex ;
				map = this.mapPool[this.poolIndex] ;
				updaters = this.listPool[this.poolIndex] ;
			}
			else {
				map = {} ;
				updaters = [] ;
			}
			
			if (source !== undefined) {
				
				
				source = this.checkStringObj(source) ;
				
				for (name in source) {
					if (typeof(value = source[name]) == "number") {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1) ;
						}
						this.getUpdaterFor(target, name, map, updaters).setSourceValue(name, parseFloat(value), isRelative) ;
					}
					else {
						parent = this.getUpdaterFor(target, name, map, updaters) ;
						child = this.create(parent.getObject(name), dest !== undefined ? dest[name] : undefined, value) ;
						updaters.push(new UpdaterLadder(parent, child, name));
					}
				}
			}
			if (dest !== undefined) {
				
				dest = this.checkStringObj(dest) ;
				
				for (name in dest) {
					if (typeof(value = dest[name]) == "number") {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1) ;
						}
						this.getUpdaterFor(target, name, map, updaters).setDestinationValue(name, parseFloat(value), isRelative) ;
					} else {
					
						if (!(source !== undefined && name in source)) {
							parent = this.getUpdaterFor(target, name, map, updaters) ;
							child = this.create(parent.getObject(name), value, source !== undefined ? source[name] : undefined) ;
							updaters.push(new UpdaterLadder(parent, child, name)) ;
						}
					}
				}
			}
			var l = updaters.length ;
			
			if (l == 1) {
				updater = updaters[0] ;
			}else if (l > 1) {
				updater = new CompositeUpdater(target, updaters) ;
			}
			
			for (var p in map) {
				delete map[p] ;
			}
			
			updaters.length = 0 ;
			
			this.mapPool[this.poolIndex] = map ;
			this.listPool[this.poolIndex] = updaters ;
			++this.poolIndex ;
			
			return updater ;
		},
		createBezier:function(target, dest, source, controlPoint){
			var map, updaters, name, value, isRelative, parent, child, updater, cp ;
			var units ;
			if (this.poolIndex > 0) {
				--this.poolIndex ;
				map = this.mapPool[this.poolIndex] ;
				updaters = this.listPool[this.poolIndex] ;
			}
			else {
				map = {} ;
				updaters = [] ;
			}
			
			if (source !== undefined) {
			
				source = this.checkStringObj(source) ;
				
				for (name in source) {
					if (typeof(value = source[name]) == "number") {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1) ;
						}
						this.getUpdaterFor(target, name, map, updaters, 'bezier').setSourceValue(name, parseFloat(value), isRelative) ;
					}
					else {
						parent = this.getUpdaterFor(target, name, map, updaters, 'bezier') ;
						child = this.createBezier(parent.getObject(name), dest !== undefined ? dest[name] : undefined, value, controlPoint !== undefined ? controlPoint[name] : undefined) ;
						updaters.push(new UpdaterLadder(parent, child, name));
					}
				}
				
			}
			if (dest !== undefined) {
				
				dest = this.checkStringObj(dest) ;
				
				for (name in dest) {
					if (typeof(value = dest[name]) == "number") {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1) ;
						}
						this.getUpdaterFor(target, name, map, updaters, 'bezier').setDestinationValue(name, parseFloat(value), isRelative) ;
					} else {
						if (!(source !== undefined && name in source)) {
							parent = this.getUpdaterFor(target, name, map, updaters, 'bezier') ;
							child = this.createBezier(parent.getObject(name), value, source !== undefined ? source[name] : undefined, controlPoint !== undefined ? controlPoint[name] : undefined) ;
							updaters.push(new UpdaterLadder(parent, child, name)) ;
						}
					}
				}
			}
			
			if (controlPoint !== undefined) {
				
				controlPoint = this.checkStringObj(controlPoint) ;
				
				for (name in controlPoint) {
					if (typeof(value = controlPoint[name]) == 'number') {
						value = [value] ;
					}
					if (value.constructor == Array) {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1) ;
						}
						cp = value ;
						l = cp.length ;
						for (var i = 0 ; i < l ; ++i) {
							this.getUpdaterFor(target, name, map, updaters, 'bezier').addControlPoint(name, cp[i], isRelative) ;
						}
					} else {
						if (map[name] !== true) {
							var bezierUpdater = this.getUpdaterFor(target, name, map, updaters, 'bezier') ;
							child = this.createBezier(bezierUpdater.getObject(name), dest !== undefined ? dest[name] : undefined, source !== undefined ? source[name] : undefined, value) ;
							updaters.push(new UpdaterLadder(bezierUpdater, child, name)) ;
							map[name] = true ;
						}
					}
				}
			}
			
			var l = updaters.length ;
			
			if (l == 1) {
				updater = updaters[0] ;
			}else if (l > 1) {
				updater = new CompositeUpdater(target, updaters) ;
			}
			
			for (var p in map) {
				delete map[p] ;
			}
			
			updaters.length = 0 ;
			
			this.mapPool[this.poolIndex] = map ;
			this.listPool[this.poolIndex] = updaters ;
			++this.poolIndex ;
			
			return updater ;
			
		},
		createPhysical:function(target, dest, source, easing){
			var map, updaters, name, value, isRelative, parent, child, updater ;
			var units ;
			if (this.poolIndex > 0) {
				--this.poolIndex ;
				map = this.mapPool[this.poolIndex] ;
				updaters = this.listPool[this.poolIndex] ;
			}
			else {
				map = {} ;
				updaters = [] ;
			}
			
			if (source !== undefined) {
				
				source = this.checkStringObj(source) ;
				
				for (name in source) {
					if (typeof(value = source[name]) == "number") {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1) ;
						}
						this.getUpdaterFor(target, name, map, updaters, 'physical', easing).setSourceValue(name, parseFloat(value), isRelative) ;
					}
					else {
						parent = this.getUpdaterFor(target, name, map, updaters, 'physical', easing) ;
						child = this.createPhysical(parent.getObject(name), dest !== undefined ? dest[name] : undefined, value, easing) ;
						updaters.push(new PhysicalUpdaterLadder(parent, child, name));
					}
				}
				
			}
			if (dest !== undefined) {
				
				dest = this.checkStringObj(dest) ;
				
				for (name in dest) {
					if (typeof(value = dest[name]) == "number") {
						if ((isRelative = /^\$/.test(name))) {
							name = name.substr(1) ;
						}
						this.getUpdaterFor(target, name, map, updaters, 'physical', easing).setDestinationValue(name, parseFloat(value), isRelative) ;
					} else {
						if (!(source !== undefined && name in source)) {
							parent = this.getUpdaterFor(target, name, map, updaters, 'physical', easing) ;
							child = this.createPhysical(parent.getObject(name), value, source !== undefined ? source[name] : undefined, easing) ;
							updaters.push(new PhysicalUpdaterLadder(parent, child, name)) ;
						}
					}
				}
			}
			
			var l = updaters.length ;
			
			if (l == 1) {
				updater = updaters[0] ;
			}else if (l > 1) {
				updater = new CompositePhysicalUpdater(target, updaters) ;
			}
			
			for (var p in map) {
				delete map[p] ;
			}
			
			updaters.length = 0 ;
			
			this.mapPool[this.poolIndex] = map ;
			this.listPool[this.poolIndex] = updaters ;
			++this.poolIndex ;
			
			return updater ;
		},
		getUpdaterFor:function(target, propertyName, map, list, mode, easing){
			var updaterClass ;
			switch(mode){
				case 'bezier' :
					updaterClass = BezierUpdater.$ns ;
				break ;
				case 'physical' :
					updaterClass = PhysicalUpdater.$ns ;
				break ;
				default:
					updaterClass = ObjectUpdater.$ns ;
				break ;
			}
			if (updaterClass !== undefined) {
				var updater = map[updaterClass] ;
				if (updater === undefined) {
					updater = new (Class(updaterClass))() ;
					updater.setTarget(target, easing) ;
					
					map[updaterClass] = updater ;
					if (list !== undefined) {
						list.push(updater) ;
					}
				}
				return updater ;
			}
			return undefined ;
		},
		checkStringObj:function(o){
			
			if(typeof(o) != 'string') return o ;
			var n ;
			var hex = o.replace(/^(0x|#)/, '') ;
			if(hex.length == 3){
				hex = hex.charAt(0) + hex.charAt(0) + hex.charAt(1) + hex.charAt(1) + hex.charAt(2) + hex.charAt(2) ;
			}

			n = parseInt('0x'+hex) ;

			return {r:(n & 0xFF0000) >> 16,g:(n & 0xFF00) >> 8,b:(n & 0xFF)} ;
		}
	});

	var AbstractUpdater = Class('org.libspark.betweenJS.core.updaters::AbstractUpdater', {
		isResolved:false,
		target:undefined,
		__init__:function(){ 
		   this.isResolved = false ;
		   return this ;
		},
		setTarget:function(target){
			this.target = target ;
		},
		setSourceValue:function(propertyName, value, isRelative){},
		setDestinationValue:function(propertyName, value, isRelative){},
		getObject:function(propertyName){},
		setObject:function(propertyName, value){},
		update:function(factor){
			if (this.isResolved === false) {
				this.resolveValues() ;
				this.isResolved = true ;
			}
			this.updateObject(factor) ;
		},
		resolveValues:function(){},
		updateObject:function(){},
		clone:function(){
			var instance = this.newInstance();
			if (instance !== undefined) {
				instance.copyFrom(this) ;
			}
			return instance ;
		},
		newInstance:function(){
			return undefined ;
		},
		copyFrom:function(){
			// Do NOT copy _isResolved property.
		}
	}) ;

	var ObjectUpdater = Class('org.libspark.betweenJS.core.updaters::ObjectUpdater', {
		target:undefined,
		source:undefined,
		destination:undefined,
		relativeMap:undefined,
		__init__:function(){
			this.source = {} ;
			this.destination = {} ;
			this.relativeMap = {} ;
			return this ;
		},
		setTarget:function(target, easing){
			
			this.$super(target, easing) ;
			var ctor = target.constructor ;
			
			if(easing !== undefined) this.easing = easing ;
			
			switch(true){
				
				case (/HTML[a-zA-Z]+Element/.test(ctor)) :
				case ctor === undefined : // IE 7-
					this.units = {} ;
				break ;
				
				case ctor === Class :
				case ctor === Date :
				case ctor === Number :
				case ctor === String :
				case ctor === Function :
				case ctor === Object :
				default:
					
				break ;
			}
		},
		setSourceValue:function(propertyName, value, isRelative){
			if(isRelative === undefined) isRelative = false ;
			
			if(this.units === undefined){
				this.source[propertyName] = value ;
				this.relativeMap['source.' + propertyName] = isRelative ;
			}else{
				propertyName = this.retrieveUnits(propertyName) ;
				this.source[propertyName] = value ;
				this.relativeMap['source.' + propertyName] = isRelative ;
			}
		},
		setDestinationValue:function(propertyName, value, isRelative){
			if(isRelative === undefined) isRelative = false ;
			
			if(this.units === undefined){
				this.destination[propertyName] = value ;
				this.relativeMap['dest.' + propertyName] = isRelative ;
			}else{
				propertyName = this.retrieveUnits(propertyName) ;
				this.destination[propertyName] = value ;
				this.relativeMap['dest.' + propertyName] = isRelative ;
			}
		},
		getObject:function(propertyName){
			if(this.units === undefined){
				return this.target[propertyName] ;
			}else{
				propertyName = this.retrieveUnits(propertyName) ; // here check for unit in string
				
				var props = CSSPropertyMapper.check(propertyName) ;
				var pname = props.cssprop ;
				var pget = props.cssget ;
				
				var n = pget(this.target, pname, this.units[propertyName]) ; // here wil apply special treatment upon checks in CSSPropertyMapper.check() method
				return n ;
			}
		},
		setObject:function(propertyName, value){
			if(this.units === undefined){
				this.target[propertyName] = value ;
			}else{
				propertyName = this.retrieveUnits(propertyName) ;
				var props = CSSPropertyMapper.check(propertyName) ;
				var pname = props.cssprop ;
				var pset = props.cssset ;
				pset(this.target, pname, this.units[propertyName], isNaN(value) ? value : Number(value).toFixed(2)) ;
			}
		},
		retrieveUnits:function(propertyName){
			
			if(this.units[propertyName] !== undefined) {
				return this.units[propertyName] == '' ? propertyName : propertyName.replace(new RegExp(this.units[propertyName]+'$', 'gi')) ;
			}
			
			var regPX = /::PX$/i,
			regEM = /::EM$/i,
			regPCT = /::%$/,
			regPC = /::PC$/i,
			regNONE = /::NONE$/ ;
			
			switch(true){
				case (regNONE.test(propertyName)) :
					propertyName = propertyName.replace(regNONE, '') ;
					this.units[propertyName] = '' ;
				break ;
				case (regPC.test(propertyName)) :
					propertyName = propertyName.replace(regPC, '') ;
					this.units[propertyName] = 'pc' ;
				break ;
				case (regPCT.test(propertyName)) :
					propertyName = propertyName.replace(regPCT, '') ;
					this.units[propertyName] = '%' ;
				break ;
				case (regEM.test(propertyName)) :
					propertyName = propertyName.replace(regEM, '') ;
					this.units[propertyName] = 'em' ;
				break ;
				case (regPX.test(propertyName)) :
					propertyName = propertyName.replace(regPX, '') ;
				default :
					this.units[propertyName] = 'px' ;
				break ;
			}
			return propertyName ;
		},
		resolveValues:function(){
			
			var key, target = this.target, source = this.source, dest = this.destination, rMap = this.relativeMap ;
			
			for (key in source) {
				if (dest[key] === undefined) {
					dest[key] = this.getObject(key) ;
				}
				if (!!rMap['source.' + key]) {
					source[key] += this.getObject(key) ;
				}
			}
			for (key in dest) {
				if (source[key] === undefined) {
					source[key] = this.getObject(key) ;
				}
				if (!!rMap['dest.' + key]) {
					dest[key] += this.getObject(key) ;
				}
			}
		},
		updateObject:function(factor){
			var invert = 1.0 - factor ;
			var t = this.target ;
			var d = this.destination ;
			var s = this.source ;
			var name ;
			
			for (name in d) {
				var val = s[name] * invert + d[name] * factor ;
				if(this.units === undefined){
					this.setObject(name, val) ;
				}else{
					try{
						this.setObject(name, val) ;
					}catch(e){
						trace('heyyy cousin blarf...', e)
					}
				}
			}
		},
		newInstance:function(){
			return new ObjectUpdater() ;
		},
		copyFrom:function(source){
			this.$super(source) ;
			var obj = source ;
			
			this.target = obj.target ;
			this.units = obj.units ;
			this.copyObject(this.source, obj.source) ;
			this.copyObject(this.destination, obj.destination) ;
			this.copyObject(this.relativeMap, obj.relativeMap) ;
		},
		copyObject:function(to, from){
			for (var s in from) {
				to[s] = from[s] ;
			}
		}
	}, AbstractUpdater) ;

	var CompositeUpdater = Class('org.libspark.betweenJS.core.updaters::CompositeUpdater', {
		target:undefined,
		a:undefined,
		b:undefined,
		c:undefined,
		d:undefined,
		updaters:undefined,
		__init__:function(target, updaters){
			this.target = target ;
			
			var l = updaters.length ;
			if (l >= 1) {
				this.a = updaters[0] ;
				if (l >= 2) {
					this.b = updaters[1] ;
					if (l >= 3) {
						this.c = updaters[2] ;
						if (l >= 4) {
							this.d = updaters[3] ;
							if (l >= 5) {
								this.updaters = new Array(l - 4) ;
								for (var i = 4 ; i < l ; ++i) {
									this.updaters[i - 4] = updaters[i] ;
								}
							}
						}
					}
				}
			}
			return this ;
		},
		getUpdaterAt:function(index){
			switch(index){
				case '0' :
					return this.a ;
				break ;
				case '1' :
					return this.b ;
				break ;
				case '2' :
					return this.c ;
				break ;
				case '3' :
					return this.d ;
				break ;
				default :
					return this.updaters[index - 4] ;
				break ;
			}
		},
		setSourceValue:function(propertyName, value, isRelative){},
		setDestinationValue:function(propertyName, value, isRelative){},
		getObject:function(propertyName){
			return undefined ;
		},
		setObject:function(propertyName, value){},
		update:function(factor){
			if (this.a !== undefined) {
				this.a.update(factor) ;
				if (this.b !== undefined) {
					this.b.update(factor) ;
					if (this.c !== undefined) {
						this.c.update(factor) ;
						if (this.d !== undefined) {
							this.d.update(factor);
							if (this.updaters !== undefined) {
								var updaters = this.updaters ;
								var l = updaters.length ;
								for (var i = 0 ; i < l ; ++i) {
									updaters[i].update(factor) ;
								}
							}
						}
					}
				}
			}
		},
		clone:function(source){
			var updaters = [] ;
			if (this.a !== undefined) {
				updaters.push(this.a.clone()) ;
				if (this.b !== undefined) {
					updaters.push(this.b.clone()) ;
					if (this.c !== undefined) {
						updaters.push(this.c.clone()) ;
						if (this.d !== undefined) {
							updaters.push(this.d.clone()) ;
							if (this.updaters !== undefined) {
								var u = this.updaters ;
								var l = u.length ;
								for (var i = 0; i < l ; ++i) {
									updaters.push(u[i].clone()) ;
								}
							}
						}
					}
				}
			}
			
			return new CompositeUpdater(this.target, updaters) ;
		}
	}) ;

	var UpdaterLadder = Class('org.libspark.betweenJS.core.updaters::UpdaterLadder', {
		target:undefined,
		parent:undefined,
		child:undefined,
		propertyName:undefined,
		__init__:function(parent, child, propertyName){
			this.parent = parent ;
			this.child = child ;
			this.propertyName = propertyName ;
			return this ;
		},
		setSourceValue:function(propertyName, value, isRelative){},
		setDestinationValue:function(propertyName, value, isRelative){},
		getObject:function(propertyName){
			return undefined ;
		},
		setObject:function(propertyName, value){},
		resolveValues:function(){},
		update:function(factor){
			this.child.update(factor) ;
			this.parent.setObject(this.propertyName, this.child.target) ;
		},
		clone:function(source){
			return new UpdaterLadder(this.parent, this.child, this.propertyName) ;
		}
	}) ;

	var PhysicalUpdaterLadder = Class('org.libspark.betweenJS.core.updaters::PhysicalUpdaterLadder', {
		target:undefined,
		parent:undefined,
		child:undefined,
		propertyName:undefined,
		easing:undefined,
		duration:0.0,
		__init__:function(parent, child, propertyName){
			this.parent = parent ;
			this.child = child ;
			this.propertyName = propertyName ;
			this.duration = this.parent.duration ;
			return this ;
		},
		setSourceValue:function(propertyName, value, isRelative){},
		setDestinationValue:function(propertyName, value, isRelative){},
		getObject:function(propertyName){},
		setObject:function(propertyName, value){},
		resolveValues:function(){},
		update:function(factor){
			this.child.update(factor) ;
			this.parent.setObject(this.propertyName, this.child.target) ;
		},
		clone:function(source){
			return new PhysicalUpdaterLadder(this.parent, this.child, this.propertyName) ;
		}
	}) ;

	var BezierUpdater = Class('org.libspark.betweenJS.core.updaters::BezierUpdater', {
		target:undefined,
		source:undefined,
		destination:undefined,
		relativeMap:undefined,
		controlPoint:undefined,
		__init__:function(){
			this.$super() ;
			this.controlPoint = {} ;
			return this ;
		},
		addControlPoint:function(propertyName, value, isRelative){
			var controlPoint = this.controlPoint[propertyName] ;
			if (controlPoint === undefined) this.controlPoint[propertyName] = controlPoint = [] ;
			controlPoint.push(value) ;
			this.relativeMap['cp.' + propertyName + '.' + controlPoint.length] = isRelative ;
		},
		setSourceValue:function(propertyName, value, isRelative){
			this.$super(propertyName, value, isRelative) ;
		},
		setDestinationValue:function(propertyName, value, isRelative){
			this.$super(propertyName, value, isRelative) ;
		},
		getObject:function(propertyName){
			return this.$super(propertyName) ;
		},
		setObject:function(propertyName, value){
			this.$super(propertyName, value) ;
		},
		resolveValues:function(){
			this.$super() ;
			var key, target = this.target, rMap = this.relativeMap, 
			controlPoint = this.controlPoint, cpVec, l, i ;
			for (key in controlPoint) {
				cpVec = controlPoint[key] ;
				l = cpVec.length ;
				for (i = 0 ; i < l ; ++i) {
					if (rMap['cp.' + key + '.' + i]) {
						cpVec[i] += this.getObject(key) ;
					}
				}
			}
		},
		updateObject:function(factor){
			var invert = 1.0 - factor,
			t = this.target,
			d = this.destination,
			s = this.source,
			cp = this.controlPoint,
			cpVec, b, l, ip, it, p1, p2, name, val;
			
			for (name in d) {
				b = s[name] ;
				if (factor != 1.0 && (cpVec = this.controlPoint[name]) !== undefined) {
					if ((l = cpVec.length) == 1) {
						val = b + factor * (2 * invert * (cpVec[0] - b) + factor * (d[name] - b)) ;
					} else {
						ip = (factor * l) >> 0 ;
						it = (factor - (ip * (1 / l))) * l ;
						if (ip == 0) {
							p1 = b ;
							p2 = (cpVec[0] + cpVec[1]) >> 1 ;
						}
						else if (ip == (l - 1)) {
							p1 = (cpVec[ip - 1] + cpVec[ip]) >> 1 ;
							p2 = d[name] ;
						}
						else {
							p1 = (cpVec[ip - 1] + cpVec[ip]) >> 1 ;
							p2 = (cpVec[ip] + cpVec[ip + 1]) >> 1 ;
						}
						val = p1 + it * (2 * (1 - it) * (cpVec[ip] - p1) + it * (p2 - p1)) ;
					}
				} else {
					val = b * invert + d[name] * factor ;
				}
				this.setObject(name, val) ;
			}
		},
		clone:function(source){
			return this.$super(source) ;
		},
		newInstance:function(){
			return new BezierUpdater() ;
		},
		copyFrom:function(source)		{
			this.$super(source) ;
			this.copyObject(this.controlPoint, source.controlPoint) ;
		},
		copyObject:function(to, from)		{
			this.$super(to, from) ;
		}
	}, ObjectUpdater) ;

	var PhysicalUpdater = Class('org.libspark.betweenJS.core.updaters::PhysicalUpdater', {
		target:undefined,
		source:undefined,
		destination:undefined,
		relativeMap:undefined,
		easing:undefined,
		duration:undefined,
		maxDuration:0.0,
		isResolved:false,
		__init__:function(){
			this.$super() ;
			this.duration = {} ;
			this.maxDuration = 0.0 ;
			this.isResolved = false ;
			return this ;
		},
		setSourceValue:function(propertyName, value, isRelative){
			this.$super(propertyName, value, isRelative) ;
		},
		setDestinationValue:function(propertyName, value, isRelative){
			this.$super(propertyName, value, isRelative) ;
		},
		getObject:function(propertyName){
			return this.$super(propertyName) ;
		},
		setObject:function(propertyName, value){
			this.$super(propertyName, value) ;
		},
		resolveValues:function(){
			var key, target = this.target, source = this.source, dest = this.destination, rMap = this.relativeMap,
			d = this.duration, duration, maxDuration = 0.0 ;
			var val ;
			var un = this.units ;
			var noUnits = un === undefined ;
			
			for (key in source) {
				if (dest[key] === undefined) {
					dest[key] = this.getObject(key) ;
				}
				if (!!rMap['source.' + key]) {
					source[key] += this.getObject(key) ;
				}
			}
			for (key in dest) {
				if (source[key] === undefined) {
					source[key] = this.getObject(key) ;
				}
				if (!!rMap['dest.' + key]) {
					dest[key] += this.getObject(key) ;
				}
				duration = this.easing.getDuration(source[key], dest[key] - source[key]) ;
				d[key] = duration ;
				if (maxDuration < duration) {
					maxDuration = duration ;
				}
			}
			
			this.maxDuration = maxDuration ;
			this.isResolved = true ;
		},
		update:function(time){
			if (!this.isResolved) {
				this.resolveValues() ;
			}
			
			var t = this.target,
			e = this.easing,
			dest = this.destination,
			src = this.source,
			d = this.duration,
			s, name, val ;
			for (name in dest) {
				if (time >= d[name]) {
					val = dest[name] ;
				} else {
					s = src[name] ;
					val = e.calculate(time, s, dest[name] - s) ;
				}
				this.setObject(name, val) ;
			}
		},
		clone:function(source){
			return this.$super(source) ;
		},
		newInstance:function(){
			return new PhysicalUpdater() ;
		},
		copyFrom:function(source){
			this.$super(source) ;
			this.easing = source.easing ;
		},
		copyObject:function(to, from){
			this.$super(to, from) ;
		}
	}, ObjectUpdater) ;

	// CORE.TICKER
	var TickerListener = Class('org.libspark.betweenJS.core.ticker::TickerListener', {
		prevListener:undefined,
		nextListener:undefined,
		__init__:function(){
			this.$super(new EventDispatcher()) ;
			return this ;
		},
		tick:function(time){
			return false ;
		}
	}, EventDispatcher) ;

	// TICKERS
	var EnterFrameTicker = Class('org.libspark.betweenJS.tickers::EnterFrameTicker', {
		first:undefined,
		numListeners:0,
		tickerListenerPaddings:undefined,
		time:undefined,
		__init__:function(){
			this.numListeners = 0 ;
			this.tickerListenerPaddings = new Array(10) ;
			var prevListener = undefined ;
			
			for (var i = 0 ; i < 10 ; ++i ) {
				var listener = new TickerListener() ; 
				if (prevListener !== undefined) {
					prevListener.nextListener = listener ;
					listener.prevListener = prevListener ;
				}
				prevListener = listener ;
				this.tickerListenerPaddings[i] = listener ;
			}
			return this ;
		},
		addTickerListener:function(listener){
			if(listener.nextListener !== undefined || listener.prevListener !== undefined) {
				return ;
			}
			if (this.first !== undefined) {
				if (this.first.prevListener !== undefined) {
					this.first.prevListener.nextListener = listener ;
					listener.prevListener = this.first.prevListener ;
				}
				listener.nextListener = this.first ;
				this.first.prevListener = listener ;
			}
			this.first = listener ;
			
			++this.numListeners ;
		},
		removeTickerListener:function(listener){
			var l = this.first ;
			while (l !== undefined) {
				if (l == listener) {
					if (l.prevListener !== undefined) {
						l.prevListener.nextListener = l.nextListener ;
						l.nextListener = undefined ;
					}
					else {
						this.first = l.nextListener;
					}
					if (l.nextListener !== undefined) {
						l.nextListener.prevListener = l.prevListener ;
						l.prevListener = undefined ;
					}
					--this.numListeners ;
				}
				l = l.nextListener ;
			}
		},
		start:function(){
			this.time = getTimer() * .001 ;
			this.render() ;
		},
		render:function(){
			var eft = this ;
			eft.update() ;
			//eft.interval = setTimeout(function(){eft.render()}, 1000 / 60) ;
			eft.interval = window.requestAnimationFrame(function(){eft.render()}) ;
		},
		stop:function(){
			//clearTimeout(this.interval) ;
			window.cancelAnimationFrame(this.interval) ;
		},
		update:function(e){
			var t = this.time = getTimer() * .001 ;
			var n = 8 - (this.numListeners % 8) ;
			var listener = this.tickerListenerPaddings[0] ; 
			var l = this.tickerListenerPaddings[n] ;
			var ll ;
			
			if ((l.nextListener = this.first) !== undefined) {
				this.first.prevListener = l ;
			}
			
			while (listener.nextListener !== undefined) {
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
				if ((listener = listener.nextListener).tick(t)) {
					if (listener.prevListener !== undefined) {
						listener.prevListener.nextListener = listener.nextListener ;
					}
					if (listener.nextListener !== undefined) {
						listener.nextListener.prevListener = listener.prevListener ;
					}
					ll = listener.prevListener ;
					listener.nextListener = undefined ;
					listener.prevListener = undefined ;
					listener = ll ;
					--this.numListeners ;
				}
			}
			if ((this.first = l.nextListener) !== undefined) {
				this.first.prevListener = undefined ;
			}
			l.nextListener = this.tickerListenerPaddings[n + 1] ;
		}
	}) ;

	// CORE.TWEENS
	var AbstractTween = Class('org.libspark.betweenJS.core.tweens::AbstractTween', {
		__init__:function(ticker, position){
		   this.isPlaying = false ;
		   this.time = .5 ;
		   this.stopOnComplete = true ;
		   this.willTriggerFlags = 0 ;
		   this.$super(new EventDispatcher()) ;
		   this.ticker = ticker ;
		   this.position = position || 0 ;
		   
		   return this ;
		},
		ticker:undefined,
		time:.5,
		position:0,
		isPlaying:false,
		stopOnComplete:true,
		willTriggerFlags:0,
		onPlay:undefined,
		onPlayParams:undefined,
		onStop:undefined,
		onStopParams:undefined,
		onUpdate:undefined,
		onUpdateParams:undefined,
		onComplete:undefined,
		onCompleteParams:undefined,
		play:function(){
			if (!this.isPlaying) {
				if (this.position >= this.time) {
					this.position = 0 ;
				}
				var t = this.ticker.time ;
				
				this.startTime = t - this.position ;
				this.isPlaying = true ;
				
				this.ticker.addTickerListener(this) ;
				
				if ((this.willTriggerFlags & 0x01) != 0) {
				   this.dispatch(new TweenEvent(TweenEvent.PLAY, undefined, this)) ;
				}
				
				if (this.onPlay !== undefined) {
				   this.onPlay.apply(null, concat(this.onPlayParams)) ;
				}
				this.tick(t) ;
			}
			
			return this ;
		},
		firePlay:function(){
			if ((this.willTriggerFlags & 0x01) != 0) {
				this.dispatch(new TweenEvent(TweenEvent.PLAY, undefined, this)) ;
			}
			if (this.onPlay !== undefined) {
			   this.onPlay.apply(null, concat(this.onPlayParams)) ;
			}
		},
		stop:function(){
			if (this.isPlaying) {
				this.ticker.removeTickerListener(this) ;
				this.isPlaying = false ;
				if ((this.willTriggerFlags & 0x02) != 0) {
					this.dispatch(new TweenEvent(TweenEvent.STOP, undefined, this)) ;
				}
				if (this.onStop !== undefined) {
					this.onStop.apply(null, concat(this.onStopParams)) ;
				}
			}
			return this ;
		},
		fireStop:function(){
			if ((this.willTriggerFlags & 0x02) != 0) {
				this.dispatch(new TweenEvent(TweenEvent.STOP, undefined, this)) ;
			}
			if (this.onStop !== undefined) {
				this.onStop.apply(null, concat(this.onStopParams)) ;
			}
		},
		togglePause:function(){
			if (this.isPlaying) {
				this.stop() ;
			}
			else {
				this.play() ;
			}
		},
		gotoAndPlay:function(position){
			if (position < 0) {
				position = 0 ;
			}
			if (position > this.time) {
				position = this.time ;
			}
			this.position = position ;
			this.play();
		},
		gotoAndStop:function(position){
			if (position < 0) {
				position = 0 ;
			}
			if (position > this.time) {
				position = this.time ;
			}
			this.position = position ;
			this.internalUpdate(position) ;
			if ((this.willTriggerFlags & 0x04) != 0) {
				this.dispatch(new TweenEvent(TweenEvent.UPDATE, undefined, this)) ;
			}
			if (this.onUpdate !== undefined) {
				this.onUpdate.apply(null, concat(this.onUpdateParams)) ;
			}
			this.stop() ;
		},
		update:function(time){
			var isComplete = false ;
			if ((this.position < this.time && this.time <= time) || (0 < this.position && time <= 0)) {
				isComplete = true ;
			}
			
			this.position = time ;
			this.internalUpdate(time) ;
			
			if ((this.willTriggerFlags & 0x04) != 0) {
				this.dispatch(new TweenEvent(TweenEvent.UPDATE, undefined, this)) ;
			}
			if (this.onUpdate !== undefined) {
				this.onUpdate.apply(null, concat(this.onUpdateParams)) ;
			}
			
			if (isComplete) {
				if ((this.willTriggerFlags & 0x08) != 0) {
					this.dispatch(new TweenEvent(TweenEvent.COMPLETE, undefined, this)) ;
				}
				if (this.onComplete !== undefined) {
					this.onComplete.apply(null, concat(this.onCompleteParams)) ;
				}
			}
			
			return this ;
		},
		tick:function(time){
			if (this.isPlaying === false) {
				return true ;
			}
			
			var t = time - this.startTime ;
			
			this.position = t ;
			this.internalUpdate(t) ;
			
			if ((this.willTriggerFlags & 0x04) != 0) {
				this.dispatch(new TweenEvent(TweenEvent.UPDATE, undefined, this)) ;
			}
			
			if (this.onUpdate !== undefined) {
				this.onUpdate.apply(null, concat(this.onUpdateParams)) ;
			}
			
			if (this.isPlaying === true) {
				if (t >= this.time) {
					this.position = this.time ;
					if (this.stopOnComplete === true) {
						this.isPlaying = false ;
						if ((this.willTriggerFlags & 0x08) != 0) {
							this.dispatch(new TweenEvent(TweenEvent.COMPLETE, undefined, this)) ;
						}
						if (this.onComplete !== undefined) {
							this.onComplete.apply(null, concat(this.onCompleteParams)) ;
						}
						return true ;
					}else {
						if ((this.willTriggerFlags & 0x08) != 0) {
							this.dispatch(new TweenEvent(TweenEvent.COMPLETE, undefined, this)) ;
						}
						if (this.onComplete !== undefined) {
							this.onComplete.apply(null, concat(this.onCompleteParams)) ;
						}
						this.position = t - this.time ;
						this.startTime = time - this.position ;
						this.tick(time) ;
					}
				}
				return false;
			}
			return true;
		},
		internalUpdate:function(time){},
		clone:function(){
			var instance = newInstance() ;
			if (instance !== undefined) {
				instance.copyFrom(this) ;
			}
			return instance ;
		},
		newInstance:function(){
		   return undefined;
		},
		copyFrom:function(source){
			this.ticker = source.ticker ;
			this.time = source.time ;
			this.stopOnComplete = source.stopOnComplete ;
			this.copyHandlersFrom(source);
			this.willTriggerFlags = source.willTriggerFlags ;
		},
		copyHandlersFrom:function(){
			this.onPlay = source.onPlay ;
			this.onPlayParams = source.onPlayParams ;
			this.onStop = source.onStop ;
			this.onStopParams = source.onStopParams ;
			this.onUpdate = source.onUpdate ;
			this.onUpdateParams = source.onUpdateParams ;
			this.onComplete = source.onComplete ;
			this.onCompleteParams = source.onCompleteParams ; 
		},
		addEL:function(type, listener){
			this.$super(type, listener) ;
			this.updateWillTriggerFlags() ;
			return this ;
		},
		removeEL:function(type, listener){
			this.$super(type, listener) ;
			this.updateWillTriggerFlags() ;
			return this ;
		},
		dispatch:function(e){
			if (this.target !== undefined) {
				return this.target.dispatch(e);
			}
			return false ;
		},
		updateWillTriggerFlags:function(){
			if (this.willTrigger(TweenEvent.PLAY)) {
				this.willTriggerFlags |= 0x01 ;
			}
			else {
				this.willTriggerFlags &= ~0x01 ;
			}
			if (this.willTrigger(TweenEvent.STOP)) {
				this.willTriggerFlags |= 0x02 ;
			}
			else {
				this.willTriggerFlags &= ~0x02 ;
			}
			if (this.willTrigger(TweenEvent.UPDATE)) {
				this.willTriggerFlags |= 0x04 ;
			}
			else {
				this.willTriggerFlags &= ~0x04 ;
			}
			if (this.willTrigger(TweenEvent.COMPLETE)) {
				this.willTriggerFlags |= 0x08 ;
			}
			else {
				this.willTriggerFlags &= ~0x08 ;
			}
		 }
	}, TickerListener) ;

	var AbstractActionTween = Class('org.libspark.betweenJS.core.tweens::AbstractActionTween', {
		lastTime:undefined,
		__init__:function(ticker){
			this.$super(ticker, 0) ;
			this.time = 0.01 ;
			this.lastTime = -1 ;
			return this ;
		},
		internalUpdate:function(time){
			if (this.lastTime < 0.01 && time >= 0.01) {
				this.action() ;
			}else if (this.lastTime > 0 && time <= 0) {
				this.rollback() ;
			}
			this.lastTime = time ;
		},
		action:function(){},
		rollback:function(){}
	}, AbstractTween) ;

	// TWEENS
	var ObjectTween = Class('org.libspark.betweenJS.tweens::ObjectTween', {
		easing:undefined,
		updater:undefined,
		target:undefined,
		__init__:function(ticker){
		   this.$super(ticker, 0) ;
		   return this ;
		},
		internalUpdate:function(time){
		   var factor = 0.0 ;
		   if (time > 0.0) {
			   if (time < this.time) {
				   factor = this.easing.calculate(time, 0.0, 1.0, this.time) ;
			   } else {
				   factor = 1.0 ;
			   }
		   }
		   this.updater.update(factor) ;
		},
		newInstance:function(){
			return new ObjectTween(this.ticker); 
		},
		copyFrom:function(source){
			this.$super(source);
			
			this.easing = source.easing ;
			this.updater = source.updater.clone() ;
		}
	}, AbstractTween) ;

	var PhysicalTween = Class('org.libspark.betweenJS.tweens::PhysicalTween', {
		updater:undefined,
		target:undefined,
		setted:false,
		__init__:function(ticker){
			this.$super(ticker, 0) ;
			this.setted = false ;
			return this ;
		},
		settings:function(){
			if(this.updater !== undefined){
				this.time = this.updater.time ;
				this.target = this.updater.target ;
			}
		},
		internalUpdate:function(time){
			if(this.setted !== true){
				this.settings() ;
				this.setted = true ;
			}
			this.updater.update(time);
		},
		newInstance:function(){
			return new PhysicalTween(this.ticker) ;
		},
		copyFrom:function(source){
			this.$super(source) ;
			this.updater = source.updater.clone() ;
		}
	}, AbstractTween) ;

	// ACTIONS
	var FunctionAction = Class('org.libspark.betweenJS.actions::FunctionAction', {
		func:undefined,
		params:undefined,
		useRollback:false,
		rollbackFunc:undefined,
		rollbackParams:undefined,
		__init__:function(ticker, func, params, useRollback, rollbackFunc, rollbackParams){
			this.$super(ticker, 0) ;
			this.func = func ;
			this.params = params ;
			
			if (useRollback !== undefined) {
				if (rollbackFunc !== undefined) {
					this.rollbackFunc = rollbackFunc ;
					this.rollbackParams = rollbackParams ;
				} else {
					this.rollbackFunc = func ;
					this.rollbackParams = params ;
				}
			}
			return this ;
		},
		action:function(){
			if (this.func !== undefined) {
				this.func.apply(null, concat(this.params)) ;
			}
		},
		rollback:function(){
			if (this.rollbackFunc !== undefined) {
				this.rollbackFunc.apply(null, concat(this.rollbackParams)) ;
			}
		}
	}, AbstractActionTween) ;

	var TimeoutAction = Class('org.libspark.betweenJS.actions::TimeoutAction', {
		duration:0,
		func:undefined,
		params:undefined,
		__init__:function(ticker, duration, func, params){
			this.$super(ticker, 0) ;
			this.time = duration || 0 ;
			this.func = func ;
			this.params = params ;
			
			return this ;
		},
		internalUpdate:function(time){},
		action:function(){},
		rollback:function(){}
	}, AbstractActionTween) ;

	var IntervalAction = Class('org.libspark.betweenJS.actions::IntervalAction', {
		duration:0,
		func:undefined,
		params:undefined,
		__init__:function(ticker, timer, func, params, useRollback, rollbackFunc, rollbackParams){
			this.$super(ticker, 0) ;
			this.time = timer || 0 ;
			this.func = func ;
			this.count = 0 ;
			this.params = params ;
			
			if (useRollback !== undefined) {
				if (rollbackFunc !== undefined) {
					this.rollbackFunc = rollbackFunc ;
					this.rollbackParams = rollbackParams ;
				} else {
					this.rollbackFunc = func ;
					this.rollbackParams = params ;
				}
			}
			
			this.stopOnComplete = false ;
			
			return this ;
		},
		internalUpdate:function(time){
			this.globaltime = (this.count * this.time) + time ;
			if(time > this.time && this.stopOnComplete !== true){
				this.action() ;
				this.count ++ ;
			}
		},
		action:function(){
			if(this.func !== undefined){
				this.func.apply(null, concat(this.params)) ;
			}
		},
		clear:function(){
			this.stopOnComplete = true ;
			this.fireStop() ;
		},
		rollback:function(){
			if (this.rollbackFunc !== undefined) {
				this.rollbackFunc.apply(null, concat(this.rollbackParams)) ;
			}
		}
	}, AbstractActionTween) ;

	var AddChildAction = Class('org.libspark.betweenJS.actions::AddChildAction', {
		target:undefined,
		parent:undefined,
		__init__:function(ticker, target, parent){
			this.$super(ticker, 0) ;
			this.target = target ;
			this.parent = parent ;
			
			return this ;
		},
		action:function(){
			if (this.target !== undefined && this.parent !== undefined && this.target.parentNode !== this.parent) {
				this.parent.appendChild(this.target) ;
			}
		},
		rollback:function(){
			if (this.target !== undefined && this.parent !== undefined && this.target.parentNode === this.parent) {
				this.parent.removeChild(this.target) ;
			}
		}
	}, AbstractActionTween) ;

	var RemoveFromParentAction = Class('org.libspark.betweenJS.actions::RemoveFromParentAction', {
		target:undefined,
		__init__:function(ticker, target){
			this.$super(ticker, 0) ;
			
			this.target = target ;
			
			return this ;
		},
		action:function(){
			if (this.target !== undefined && this.target.parentNode !== null) {
				this.parent = this.target.parentNode ;
				this.parent.removeChild(this.target) ;
			}
		},
		rollback:function(){
			if (this.target !== undefined && this.parent !== undefined) {
				this.parent.appendChild(this.target) ;
				this.parent = undefined ;
			}
		}
	}, AbstractActionTween) ;

	// DECORATORS
	var TweenDecorator = Class('org.libspark.betweenJS.tweens::TweenDecorator', {
		baseTween:undefined,
		__init__:function(baseTween, position){
		   this.$super(baseTween.ticker, position) ;
		   
		   this.baseTween = baseTween ;
		   this.time = baseTween.time ;
		   
		   return this ;
		},
		play:function(){
			if (this.isPlaying === false) {
				
				this.baseTween.firePlay() ;
				this.$super() ;
			}
		},
		firePlay:function(){
			this.$super() ;
			this.baseTween.firePlay() ;
		},
		stop:function(){
			if (this.isPlaying === true) {
				this.$super() ;
				this.baseTween.fireStop() ;
			}
		},
		fireStop:function(){
			this.$super() ;
			this.baseTween.fireStop() ;
		},
		internalUpdate:function(time){
		   this.baseTween.update(time) ;
		}
	}, AbstractTween) ;

	var SlicedTween = Class('org.libspark.betweenJS.tweens.decorators::SlicedTween', {
		begin:0,
		end:1,
		__init__:function(baseTween, begin, end){
		   this.$super(baseTween, 0) ;
		   
		   this.end = end || 1 ;
		   this.begin = begin || 0 ;
		   this.time = this.end - this.begin ;
		   
		   return this ;
		},
		internalUpdate:function(time){
			if (time > 0) {
				if (time < this.time) {
					this.baseTween.update(time + this.begin) ;
				} else {
					this.baseTween.update(this.end) ;
				}
			} else {
				this.baseTween.update(this.begin) ;
			}
		},
		newInstance:function(){
			return new SlicedTween(this.baseTween.clone(), this.begin, this.end) ;
		}
	}, TweenDecorator) ;

	var ScaledTween = Class('org.libspark.betweenJS.tweens.decorators::ScaledTween', {
		scale:1,
		__init__:function(baseTween, scale){
		   this.$super(baseTween, 0) ;
		   
		   this.scale = scale || 1 ;
		   this.time = this.scale * baseTween.time ;
		   
		   return this ;
		},
		internalUpdate:function(time){
		   this.baseTween.update(time / this.scale) ;
		},
		newInstance:function(){
			return new ScaledTween(this.baseTween.clone(), this.scale) ;
		}
	}, TweenDecorator) ;

	var ReversedTween = Class('org.libspark.betweenJS.tweens.decorators::ReversedTween', {
		__init__:function(baseTween, position){
		   this.$super(baseTween, position) ;
		   this.time = baseTween.time ;
		   
		   return this ;
		},
		internalUpdate:function(time){
		   this.baseTween.update(this.time - time) ;
		},
		newInstance:function(){
			return new ReversedTween(this.baseTween.clone(), 0) ;
		}
	}, TweenDecorator) ;

	var RepeatedTween = Class('org.libspark.betweenJS.tweens.decorators::RepeatedTween', {
		basetime:undefined,
		repeatCount:2,
		__init__:function(baseTween, repeatCount){
		   this.$super(baseTween, 0) ;
		   this.repeatCount = repeatCount || 2 ;
		   this.basetime = baseTween.time ;
		   
		   this.time = this.repeatCount * this.basetime ;
		   return this ;
		},
		internalUpdate:function(time){
		   if (time >= 0) {
			   time -= time < this.time ? this.basetime * parseInt(time / this.basetime) : this.time - this.basetime ;
		   }
		   this.baseTween.update(time) ;
		},
		newInstance:function(){
			return new RepeatedTween(this.baseTween.clone(), this.repeatCount) ;
		}
	}, TweenDecorator) ;

	var DelayedTween = Class('org.libspark.betweenJS.tweens.decorators::DelayedTween', {
		basetime:undefined,
		preDelay:.5,
		postDelay:.5,
		__init__:function(baseTween, preDelay, postDelay){
		   this.$super(baseTween, 0) ;
		   this.preDelay = preDelay || 0 ;
		   this.postDelay = postDelay || 0 ;
		   this.time = this.preDelay + baseTween.time + this.postDelay ;
		   
		   return this ;
		},
		internalUpdate:function(time){
		   this.baseTween.update(time - this.preDelay) ;
		},
		newInstance:function(){
			return new DelayedTween(this.baseTween.clone(), this.preDelay, this.postDelay) ;
		}
	}, TweenDecorator) ;

	// GROUPS
	var ParallelTween = Class('org.libspark.betweenJS.tweens::ParallelTween', {
		a:undefined,
		b:undefined,
		c:undefined,
		d:undefined,
		targets:undefined,
		__init__:function(targets, ticker, position){
			this.$super(ticker, position) ;
				
			var l = targets.length ;
			this.time = 0 ;
			
			if (l > 0) {
				this.a = targets[0] ;
				this.time = this.a.time > this.time ? this.a.time : this.time ;
				if (l > 1) {
					this.b = targets[1] ;
					this.time = this.b.time > this.time ? this.b.time : this.time ;
					if (l > 2) {
						this.c = targets[2] ;
						this.time = this.c.time > this.time ? this.c.time : this.time ;
						if (l > 3) {
							this.d = targets[3] ;
							this.time = this.d.time > this.time ? this.d.time : this.time ;
							if (l > 4) {
								this.targets = new Array(l - 4) ;
								for (var i = 4 ; i < l ; ++i) {
									var t = targets[i] ;
									this.targets[i - 4] = t ;
									this.time = t.time > this.time ? t.time : this.time ;
								}
							}
						}
					}
				}
			}
		   return this ;
		},
		contains:function(tw){
			if (tw === undefined) return false ;
			if (this.a === tw)
				return true ;
			
			if (this.b === tw) {
				return true;
			}
			if (this.c === tw) {
				return true;
			}
			if (this.d === tw) {
				return true;
			}
			if (this.targets !== undefined) {
				return this.checkForIndex(tw) ;
			}
			return false ;
		},
		checkForIndex:function(tw){
			var l = this.targets.length , cond = false ;
			for (var i = 0 ; i < l ; i++) {
			  cond = this.targets[i] === tw ;
			  if(!!cond) return true ;
			} ;
			return false ;
		},
		getTweenAt:function(index){
			if (index < 0) {
				return undefined ;
			}
			if (index == 0) {
				return this.a ;
			}
			if (index == 1) {
				return this.b ;
			}
			if (index == 2) {
				return this.c ;
			}
			if (index == 3) {
				return this.d ;
			}
			if (this.targets !== undefined) {
				if (index - 4 < this.targets.length) {
					return this.targets[index - 4] ;
				}
			}
			return undefined ;
		},
		getTweenIndex:function(tw){
			if (tw === undefined) {
				return -1 ;
			}
			if (this.a === tw) {
				return 0 ;
			}
			if (this.b === tw) {
				return 1 ;
			}
			if (this.c === tw) {
				return 2 ;
			}
			if (this.d === tw) {
				return 3 ;
			}
			if (this.targets != null) {
				var i = this.getIndex(tw) ;
				if (i != -1) {
					return i + 4;
				}
			}
			return -1 ;
		},
		getIndex:function(tw){
			var l = this.targets.length , ind = -1 ;
			for(var i = 0 ; i < l ; i++)
				if(this.targets[i] === tw) return i ;
			return ind ;
		},
		internalUpdate:function(time){
		   if (this.a !== undefined) {
				this.a.update(time) ;
				if (this.b !== undefined) {
					this.b.update(time) ;
					if (this.c !== undefined) {
						this.c.update(time) ;
						if (this.d !== undefined) {
							this.d.update(time) ;
							if (this.targets !== undefined) {
								var targets = this.targets ;
								var l = targets.length ;
								for (var i = 0 ; i < l ; ++i)
									targets[i].update(time) ;
								
							}
						}
					}
				}
			}
		},
		newInstance:function(){
			var targets = [] ;
			if (this.a !== undefined) {
				targets.push(this.a.clone()) ;
			}
			if (this.b !== undefined) {
				targets.push(this.b.clone()) ;
			}
			if (this.c !== undefined) {
				targets.push(this.c.clone()) ;
			}
			if (this.d !== undefined) {
				targets.push(this.d.clone()) ;
			}
			if (this.targets !== undefined) {
				var t = this.targets ;
				var l = t.length;
				for (var i = 0 ; i < l ; ++i) {
					targets.push(t[i].clone()) ;
				}
			}
			return new ParallelTween(targets, this.ticker, 0) ;
		}
	}, AbstractTween) ;

	var SerialTween = Class('org.libspark.betweenJS.tweens::SerialTween', {
		a:undefined,
		b:undefined,
		c:undefined,
		d:undefined,
		targets:undefined,
		lastTime:0,
		__init__:function(targets, ticker, position){
			this.$super(ticker, position) ;
				
			var l = targets.length ;
			
			this.time = 0 ;
			this.lastTime = 0 ;
			
			if (l > 0) {
				this.a = targets[0] ;
				this.time += this.a.time ;
				if (l > 1) {
					this.b = targets[1] ;
					this.time += this.b.time ;
					if (l > 2) {
						this.c = targets[2] ;
						this.time += this.c.time ;
						if (l > 3) {
							this.d = targets[3] ;
							this.time += this.d.time ;
							if (l > 4) {
								this.targets = new Array(l - 4) ;
								for (var i = 4 ; i < l ; ++i) {
									var t = targets[i] ;
									this.targets[i - 4] = t ;
									this.time += t.time ;
								}
							}
						}
					}
				}
			}
			return this ;
		},
		contains:function(tw){
			if (tw === undefined)
				return false ;
			if (this.a === tw) 
				return true ;
			if (this.b === tw)
				return true;
			if (this.c === tw)
				return true;
			if (this.d === tw)
				return true;
			if (this.targets !== undefined)
				return this.checkForIndex(tw) ;
			return false ;
		},
		checkForIndex:function(tw){
			var l = this.targets.length , cond = false ;
			for (var i = 0 ; i < l ; i++) {
			  cond = this.targets[i] === tw ;
			  if(!!cond) return true ;
			} ;
			return false ;
		},
		getTweenAt:function(index){
			if (index < 0) {
				return undefined ;
			}
			if (index == 0) {
				return this.a ;
			}
			if (index == 1) {
				return this.b ;
			}
			if (index == 2) {
				return this.c ;
			}
			if (index == 3) {
				return this.d ;
			}
			if (this.targets !== undefined) {
				if (index - 4 < this.targets.length) {
					return this.targets[index - 4] ;
				}
			}
			return undefined ;
		},
		getTweenIndex:function(tw){
			if (tw === undefined) {
				return -1 ;
			}
			if (this.a === tw) {
				return 0 ;
			}
			if (this.b === tw) {
				return 1 ;
			}
			if (this.c === tw) {
				return 2 ;
			}
			if (this.d === tw) {
				return 3 ;
			}
			if (this.targets != null) {
				var i = this.getIndex(tw) ;
				if (i != -1) {
					return i + 4;
				}
			}
			return -1 ;
		},
		getIndex:function(tw){
			var l = this.targets.length , ind = -1 ;
			for(var i = 0 ; i < l ; i++)
				if(this.targets[i] === tw) return i ;
			return ind ;
		},
		internalUpdate:function(time){
			var d = 0, ld = 0, lt = this.lastTime, l , i , t ;
			var cur ;
			if ((time - lt) >= 0) {
				if (this.a  !== undefined) {
					if (lt <= (d += this.a.time) && ld <= time) {
						this.a.update(time - ld) ;
					}
					ld = d ;
					
					if (this.b !== undefined) {
						if (lt <= (d += this.b.time) && ld <= time) {
							this.b.update(time - ld) ;
						}
						ld = d ;
						
						if (this.c !== undefined) {
							if (lt <= (d += this.c.time) && ld <= time) {
								this.c.update(time - ld) ;
							}
							ld = d ;
							
							if (this.d !== undefined) {
								if (lt <= (d += this.d.time) && ld <= time) {
									this.d.update(time - ld) ;
								}
								ld = d ;
								
								if (this.targets !== undefined) {
									
									l = this.targets.length ;
									for (i = 0 ; i < l ; ++i) {
										t = this.targets[i];
										if (lt <= (d += t.time) && ld <= time) {
											t.update(time - ld) ;
										}
										ld = d ;
										
										
										
									}
								}
							}
						}
					}
				}
			} else {
				d = this.time ;
				ld = d ;
				if (this.targets !== undefined) {
					for (i = this.targets.length - 1 ; i >= 0 ; --i) {
						t = this.targets[i] ;
						if (lt >= (d -= t.time) && ld >= time) {
							t.update(time - d) ;
						}
						ld = d ;
					}
				}
				if (this.d !== undefined) {
					if (lt >= (d -= this.d.time) && ld >= time) {
						this.d.update(time - d) ;
					}
					ld = d ;
				}
				if (this.c !== undefined) {
					if (lt >= (d -= this.c.time) && ld >= time) {
						this.c.update(time - d) ;
					}
					ld = d ;
				}
				if (this.b !== undefined) {
					if (lt >= (d -= this.b.time) && ld >= time) {
						this.b.update(time - d) ;
					}
					ld = d ;
				}
				if (this.a !== undefined) {
					if (lt >= (d -= this.a.time) && ld >= time) {
						this.a.update(time - d) ;
					}
					ld = d ;
				}
			}
			this.lastTime = time ;
		},
		newInstance:function(){
			var targets = [] ;
			if (this.a !== undefined) {
				targets.push(this.a.clone()) ;
			}
			if (this.b !== undefined) {
				targets.push(this.b.clone()) ;
			}
			if (this.c !== undefined) {
				targets.push(this.c.clone()) ;
			}
			if (this.d !== undefined) {
				targets.push(this.d.clone()) ;
			}
			if (this.targets !== undefined) {
				var t = this.targets ;
				var l = t.length ;
				for (var i = 0 ; i < l ; ++i) {
					targets.push(t[i].clone()) ;
				}
			}
			return new SerialTween(targets, this.ticker, 0) ;
		}
	}, AbstractTween) ;
	
	return BetweenJS ;
})() ;



// EVENTS
var TweenEvent = Class('org.libspark.betweenJS.events::TweenEvent', {
   __classvars__:{
      PLAY:'play',
      STOP:'stop',
      UPDATE:'update',
      COMPLETE:'complete'
   },
   __init__:function(type, data, tween){
      this.type = type, this.data = data ;
      this.tween = tween ;
      return this ;
   }
}, IEvent) ;


/* EASINGS 
 * Thanks to Robert Penner */

// CUSTOM
var CustomFunctionEasing = function(f){
	if(typeof(f) !== 'function') throw('function parameter is not a function...(customEasing)', f ) ;
	return {calculate:function(t, b, c, d){
		return f(t, b, c, d) ;
	}} ;
}
var Custom = {
	func:function(f){
		return new CustomFunctionEasing(f) ;
	}
} ;

// EASENONE
var EaseNone = function(){
	return {calculate:function(t, b, c, d){
		return c * t / d + b ;
	}} ;
}

// LINEAR
var Linear = {linear:new EaseNone()} ;
Linear.easeNone = Linear.linear ;
Linear.easeIn = Linear.linear ;
Linear.easeOut = Linear.linear ;
Linear.easeInOut = Linear.linear ;
Linear.easeOutIn = Linear.linear ;

// BACK
var BackEaseIn = function(s){
	s = s || 1.70158 ;
	return {calculate:function(t, b, c, d){
		return c * (t /= d) * t * ((s + 1) * t - s) + b;
	}} ;
}
var BackEaseOut = function(s){
	s = s || 1.70158 ;
	return {calculate:function(t, b, c, d){
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b ;
	}} ;
}
var BackEaseInOut = function(s){
	s = s || 1.70158 ;
	return {calculate:function(t, b, c, d){
		if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s * 1.525) + 1) * t - s * 1.525)) + b ;
		else return c / 2 * ((t -= 2) * t * (((s * 1.525) + 1) * t + s * 1.525) + 2) + b ;
	}} ;
}
var BackEaseOutIn = function(s){
	s = s || 1.70158 ;
	return {calculate:function(t, b, c, d){
		if (t < d / 2) return (c / 2) * ((t = (t * 2) / d - 1) * t * ((s + 1) * t + s) + 1) + b ;
		else return (c / 2) * (t = (t * 2 - d) / d) * t * ((s + 1) * t - s) + (b + c / 2) ;
	}} ;
}
var Back = {
	easeIn:new BackEaseIn(),
	easeOut:new BackEaseOut(),
	easeInOut:new BackEaseInOut(),
	easeOutIn:new BackEaseOutIn()
} ;
Back.easeInWith = function(s){return new BackEaseIn(s || 1.70158)} ;
Back.easeOutWith = function(s){return new BackEaseOut(s || 1.70158)} ;
Back.easeInOutWith = function(s){return new BackEaseInOut(s || 1.70158)} ;
Back.easeOutInWith = function(s){return new BackEaseOutIn(s || 1.70158)} ;

// BOUNCE
var BounceEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		if ((t = (d - t) / d) < (1 / 2.75)) return c - (c * (7.5625 * t * t)) + b ;
		if (t < (2 / 2.75)) return c - (c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + b ;
		if (t < (2.5 / 2.75)) return c - (c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + b ;
		else return c - (c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) + b ;
	}} ;
}
var BounceEaseOut = function(){
	return {calculate:function(t, b, c, d){
		if ((t /= d) < (1 / 2.75)) return c * (7.5625 * t * t) + b ;
		if (t < (2 / 2.75)) return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b ;
		if (t < (2.5 / 2.75)) return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b ;
		else return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b ;
	}} ;
}
var BounceEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2) {
			if ((t = (d - t * 2) / d) < (1 / 2.75)) return (c - (c * (7.5625 * t * t))) * 0.5 + b ;
			if (t < (2 / 2.75)) return (c - (c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75))) * 0.5 + b ;
			if (t < (2.5 / 2.75)) return (c - (c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375))) * 0.5 + b ;
			else return (c - (c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375))) * 0.5 + b ;
		} else {
			if ((t = (t * 2 - d) / d) < (1 / 2.75)) return (c * (7.5625 * t * t)) * 0.5 + c * 0.5 + b ;
			if (t < (2 / 2.75)) return (c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) * 0.5 + c * 0.5 + b ;
			if (t < (2.5 / 2.75)) return (c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) * 0.5 + c * 0.5 + b ;
			else return (c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) * 0.5 + c * 0.5 + b ;
		}
	}} ;
}
var BounceEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2) {
			if ((t = (t * 2) / d) < (1 / 2.75)) return (c / 2) * (7.5625 * t * t) + b ;
			if (t < (2 / 2.75)) return (c / 2) * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b ;
			if (t < (2.5 / 2.75)) return (c / 2) * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b ;
			else return (c / 2) * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b ;
		} else {
			if ((t = (d - (t * 2 - d)) / d) < (1 / 2.75)) return (c / 2) - ((c / 2) * (7.5625 * t * t)) + (b + c / 2) ;
			if (t < (2 / 2.75)) return (c / 2) - ((c / 2) * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + (b + c / 2) ;
			if (t < (2.5 / 2.75)) return (c / 2) - ((c / 2) * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + (b + c / 2) ;
			else return (c / 2) - ((c / 2) * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) + (b + c / 2) ;
		}
	}} ;
}
var Bounce = {
	easeIn:new BounceEaseIn(),
	easeOut:new BounceEaseOut(),
	easeInOut:new BounceEaseInOut(),
	easeOutIn:new BounceEaseOutIn()
} ;

// CIRCULAR & CIRC
var CircularEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b ;
	}} ;
}
var CircularEaseOut = function(){
	return {calculate:function(t, b, c, d){
		return c * Math.sqrt(1 - (t = t / d - 1) * t) + b ;
	}} ;
}
var CircularEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b ;
		else return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b ;
	}} ;
}
var CircularEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2) return (c / 2) * Math.sqrt(1 - (t = (t * 2) / d - 1) * t) + b ;
		else return -(c / 2) * (Math.sqrt(1 - (t = (t * 2 - d) / d) * t) - 1) + (b + c / 2) ;
	}} ;
}
var Circular = {
	easeIn:new CircularEaseIn(),
	easeOut:new CircularEaseOut(),
	easeInOut:new CircularEaseInOut(),
	easeOutIn:new CircularEaseOutIn()
} ;
var Circ = Circular ;

// CUBIC
var CubicEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		return c * (t /= d) * t * t + b ;
	}} ;
}
var CubicEaseOut = function(){
	return {calculate:function(t, b, c, d){
		return c * ((t = t / d - 1) * t * t + 1) + b;
	}} ;
}
var CubicEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		return ((t /= d / 2) < 1) ? c / 2 * t * t * t + b : c / 2 * ((t -= 2) * t * t + 2) + b ;
	}} ;
}
var CubicEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		return t < d / 2 ? c / 2 * ((t = t * 2 / d - 1) * t * t + 1) + b : c / 2 * (t = (t * 2 - d) / d) * t * t + b + c / 2 ;
	}} ;
}
var Cubic = {
	easeIn:new CubicEaseIn(),
	easeOut:new CubicEaseOut(),
	easeInOut:new CubicEaseInOut(),
	easeOutIn:new CubicEaseOutIn()
} ;

// ELASTIC
var ElasticEaseIn = function(a, p){
	a = a || 0 , p = p || 0 ;
	return {calculate:function(t, b, c, d){
		if (t == 0) return b ;
		if ((t /= d) == 1) return b + c ;
		if (!p) p = d * 0.3 ;
		
		var s ;// Number
		if (!a || a < Math.abs(c)) {
			a = c ;
			s = p / 4 ;
		} else {
			s = p / (2 * Math.PI) * Math.asin(c / a) ;
		}
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b ;
	}} ;
}
var ElasticEaseOut = function(a, p){
	a = a || 0 , p = p || 0 ;
	return {calculate:function(t, b, c, d){
		if (t == 0) return b ;
		if ((t /= d) == 1) return b + c ;
		if (!p) p = d * 0.3 ;
		
		var s ;
		if (!a || a < Math.abs(c)) {
			a = c ;
			s = p / 4 ;
		} else {
			s = p / (2 * Math.PI) * Math.asin(c / a) ;
		}
		return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b ;
	}} ;
}
var ElasticEaseInOut = function(a, p){
	a = a || 0 , p = p || 0 ;
	return {calculate:function(t, b, c, d){
		if (t == 0) return b ;
		if ((t /= d / 2) == 2) return b + c ;
		if (!p) p = d * (0.3 * 1.5) ;
		
		var s ;
		if (!a || a < Math.abs(c)) {
			a = c;
			s = p / 4;
		} else {
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}
		if (t < 1) return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b ;
		else return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * 0.5 + c + b ;
	}} ;
}
var ElasticEaseOutIn = function(a, p){
	a = a || 0 , p = p || 0 ;
	return {calculate:function(t, b, c, d){
		var s ;
		c /= 2 ;
		
		if (t < d / 2) {
			if ((t *= 2) == 0) return b ;
			if ((t /= d) == 1) return b + c ;
			if (!p) p = d * 0.3 ;
			if (!a || a < Math.abs(c)) {
				a = c ;
				s = p / 4 ;
			} else {
				s = p / (2 * Math.PI) * Math.asin(c / a) ;
			}
			return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b ;
		} else {
			if ((t = t * 2 - d) == 0) return (b + c) ;
			if ((t /= d) == 1) return (b + c) + c ;
			if (!p) p = d * 0.3 ;
			if (!a || a < Math.abs(c)) {
				a = c ;
				s = p / 4 ;
			} else {
				s = p / (2 * Math.PI) * Math.asin(c / a) ;
			}
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + (b + c) ;
		}
	}} ;
}
var Elastic = {
	easeIn:new ElasticEaseIn(),
	easeOut:new ElasticEaseOut(),
	easeInOut:new ElasticEaseInOut(),
	easeOutIn:new ElasticEaseOutIn()
} ;
Elastic.easeInWith = function(a, p){return new ElasticEaseIn(a || 0, p || 0)} ;
Elastic.easeOutWith = function(a, p){return new ElasticEaseOut(a || 0, p || 0)} ;
Elastic.easeInOutWith = function(a, p){return new ElasticEaseInOut(a || 0, p || 0)} ;
Elastic.easeOutInWith = function(a, p){return new ElasticEaseOutIn(a || 0, p || 0)} ;

// EXPONENTIAL & EXPO
var ExponentialEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		return t == 0 ? b : c * Math.pow(2, 10 * (t / d - 1)) + b ;
	}} ;
}
var ExponentialEaseOut = function(){
	return {calculate:function(t, b, c, d){
		return t == d ? b + c : c * (-Math.pow(2, -10 * t / d)+1) + b;
	}} ;
}
var ExponentialEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		if (t == 0) return b ;
		if (t == d) return b + c ;
		if ((t /= d / 2.0) < 1.0) return c / 2 * Math.pow(2, 10 * (t - 1)) + b ;
		return c / 2 * (-Math.pow(2, -10 * --t)+2) + b ;
	}} ;
}
var ExponentialEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2.0) return t * 2.0 == d ? b + c / 2.0 : c / 2.0 * (-Math.pow(2, -10 * t * 2.0 / d)+1) + b ;
		else return (t * 2.0 - d) == 0 ? b + c / 2.0 : c / 2.0 * Math.pow(2, 10 * ((t * 2 - d) / d - 1)) + b + c / 2.0 ;
	}} ;
}
var Exponential = {
	easeIn:new ExponentialEaseIn(),
	easeOut:new ExponentialEaseOut(),
	easeInOut:new ExponentialEaseInOut(),
	easeOutIn:new ExponentialEaseOutIn()
} ;
var Expo = Exponential ;

// QUADRATIC & QUAD
var QuadraticEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		return c * (t /= d) * t + b ;
	}} ;
}
var QuadraticEaseOut = function(){
	return {calculate:function(t, b, c, d){
		return -c * (t /= d) * (t - 2) + b ;
	}} ;
}
var QuadraticEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		if ((t /= d / 2) < 1) return c / 2 * t * t + b ;
		else return -c / 2 * ((--t) * (t - 2) - 1) + b ;
	}} ;
}
var QuadraticEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2) return -(c / 2) * (t = (t * 2 / d)) * (t - 2) + b ;
		else return (c / 2) * (t = (t * 2 - d) / d) * t + (b + c / 2) ;
	}} ;
}
var Quadratic = {
	easeIn:new QuadraticEaseIn(),
	easeOut:new QuadraticEaseOut(),
	easeInOut:new QuadraticEaseInOut(),
	easeOutIn:new QuadraticEaseOutIn()
} ;
var Quad = Quadratic ;

// QUARTIC & QUART
var QuarticEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		return c * (t /= d) * t * t * t + b ;
	}} ;
}
var QuarticEaseOut = function(){
	return {calculate:function(t, b, c, d){
		return -c * ((t = t / d - 1) * t * t * t - 1) + b ;
	}} ;
}
var QuarticEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b ;
		else return -c / 2 * ((t -= 2) * t * t * t - 2) + b ;
	}} ;
}
var QuarticEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2) return -(c / 2) * ((t = (t * 2) / d - 1) * t * t * t - 1) + b ;
		else return (c / 2) * (t = (t * 2 - d) / d) * t * t * t + (b + c / 2) ;
	}} ;
}
var Quartic = {
	easeIn:new QuarticEaseIn(),
	easeOut:new QuarticEaseOut(),
	easeInOut:new QuarticEaseInOut(),
	easeOutIn:new QuarticEaseOutIn()
} ;
var Quart = Quartic ;

// QUINTIC & QUINT
var QuinticEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		return c * (t /= d) * t * t * t * t + b ;
	}} ;
}
var QuinticEaseOut = function(){
	return {calculate:function(t, b, c, d){
		return c * ((t = t / d - 1) * t * t * t * t + 1) + b ;
	}} ;
}
var QuinticEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b ;
		else return c / 2 * ((t -= 2) * t * t * t * t + 2) + b ;
	}} ;
}
var QuinticEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2) return (c / 2) * ((t = (t * 2) / d - 1) * t * t * t * t + 1) + b ;
		else return (c / 2) * (t = (t * 2 - d) / d) * t * t * t * t + (b + c / 2) ;
	}} ;
}
var Quintic = {
	easeIn:new QuinticEaseIn(),
	easeOut:new QuinticEaseOut(),
	easeInOut:new QuinticEaseInOut(),
	easeOutIn:new QuinticEaseOutIn()
} ;
var Quint = Quintic ;

// SINE
var SineEaseIn = function(s){
	return {calculate:function(t, b, c, d){
		return -c * Math.cos(t / d * (Math.PI / 2)) + c + b ;
	}} ;
}
var SineEaseOut = function(){
	return {calculate:function(t, b, c, d){
		return c * Math.sin(t / d * (Math.PI / 2)) + b ;
	}} ;
}
var SineEaseInOut = function(){
	return {calculate:function(t, b, c, d){
		return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b ;
	}} ;
}
var SineEaseOutIn = function(){
	return {calculate:function(t, b, c, d){
		if (t < d / 2) return (c / 2) * Math.sin((t * 2) / d * (Math.PI / 2)) + b ;
		else return -(c / 2) * Math.cos((t * 2 - d) / d * (Math.PI / 2)) + (c / 2) + (b + c / 2) ;
	}} ;
}
var Sine = {
	easeIn:new SineEaseIn(),
	easeOut:new SineEaseOut(),
	easeInOut:new SineEaseInOut(),
	easeOutIn:new SineEaseOutIn()
} ;

// PHYSICAL
var Physical = {
	defaultFrameRate:30.0,
	uniform:function(velocity, frameRate){
		return new PhysicalUniform(velocity || 10.0, isNaN(frameRate) ? Physical.defaultFrameRate : frameRate) ;
	},
	accelerate:function(acceleration, initialVelocity, frameRate){
		return new PhysicalAccelerate(initialVelocity || 0.0, acceleration || 1.0, isNaN(frameRate) ? Physical.defaultFrameRate : frameRate) ;
	},
	exponential:function(factor, threshold, frameRate){
		return new PhysicalExponential(factor || 0.2, threshold || 0.0001, isNaN(frameRate) ? Physical.defaultFrameRate : frameRate) ;
	}
} ;
var PhysicalAccelerate = Class('org.libspark.betweenJS.core.easing::PhysicalAccelerate', {
    iv:undefined,
    a:undefined,
    fps:undefined,
    __init__:function(iv, a, fps){ 
       this.iv = iv ;
       this.a = a ;
       this.fps = fps ;
       
       return this ;
    },
    getDuration:function(b, c){
        var iv = c < 0 ? - this.iv : this.iv ;
		var a = c < 0 ? - this.a : this.a ;
		
		return ((-iv + Math.sqrt(iv * iv - 4 * (a / 2.0) * -c)) / (2 * (a / 2.0))) * (1.0 / this.fps);
    },
    calculate:function(t, b, c){
		var f = c < 0 ? -1 : 1 ;
		var n = t / (1.0 / this.fps) ;
		return b + (f * this.iv) * n + ((f * this.a) * n) * n / 2.0 ;
    }
}) ;
var PhysicalExponential = Class('org.libspark.betweenJS.core.easing::PhysicalExponential', {
    f:undefined,
    th:undefined,
    fps:undefined,
    __init__:function(f, th, fps){ 
       this.f = f ;
       this.th = th ;
       this.fps = fps ;
       
       return this ;
    },
    getDuration:function(b, c){
         return (Math.log(this.th / c) / Math.log(1 - this.f) + 1) * (1.0 / this.fps) ;
    },
    calculate:function(t, b, c){
         return -c * Math.pow(1 - this.f, (t / (1.0 / this.fps)) - 1) + (b + c) ;
    }
}) ;
var PhysicalUniform = Class('org.libspark.betweenJS.core.easing::PhysicalUniform', {
    v:undefined,
    fps:undefined,
    __init__:function(v, fps){ 
       this.v = v ;
       this.fps = fps ;
       
       return this ;
    },
    getDuration:function(b, c){
         return (c / (c < 0 ? -this.v : this.v)) * (1.0 / this.fps) ;
    },
    calculate:function(t, b, c){
         return b + (c < 0 ? -this.v : this.v) * (t / (1.0 / this.fps)) ;
    }
});

BetweenJS.core() ;