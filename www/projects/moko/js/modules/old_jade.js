
var Jade = Class('naja.jade::Jade', {
	statics:{
		root:'./jade/'
	},
	template:undefined,
	constructor:function Jade(url){
		Jade.base.apply(this, [Jade.root + url]) ;
		trace(this.url)
	},
	load:function(url, async){
		
		Jade.factory.load.apply(this, [url, async]) ;
		this.response = this.request.responseText ;
		
		return this ;
	},
	parse:function(locals){
		
		var str = this.response ;
		
		// search for variables name
		
		
		var linereg = /(\t+)*([^\t\n]+)\t*/gim ;   // CRLF and CR are converted to LF before parsing.
		var includesreg = /^(\t+)*(include) ([0-9a-z\/.]+)$/im ;   // CRLF and CR are converted to LF before parsing.
		
		var parents = [] ;
		var parent, future, np ;
		var top = parent = parents[0] = {children:[], index:0} ;
		
		
		var conditions = [] ;
		var addCondition = function(cond){
			var l = cond.index = conditions.length ;
			conditions[l] = cond ;
			cond.totalcost = cond.cost ;
			var prevcond = conditions[l-1] ;
			if(!! prevcond) {
				cond.totalcost = cond.cost + prevcond.totalcost;
			}
			return cond ;
		}
		var removeCondition = function(cond){
			cond = undefined ;
			conditions = conditions.slice(0, -1) ;
			return conditions[conditions.length -1] ;
		}
		
		
		var condition;
		var parentIndex, oldParentIndex = 0;
		
		
		// search for includes
		str = (function parseForIncludes(txt){
			if(includesreg.test(txt)){
				txt = txt.replace(includesreg, function(){
					var tabs = arguments[1] ;
					var path = arguments[3] ;
					var extreg = /[.](a-z0-9)+$/ ;
					if(!extreg.test(path)){
						path = path + '.jade' ;
					}
					var msg = new Jade(path).load(undefined, false).response ;
					msg = msg.replace(linereg, function(){
						return tabs + arguments[0] ;
					}) ;
					if(includesreg.test(msg)){
						msg = parseForIncludes(msg) ;
					}
					return msg ;
				})
			}
			return txt ;
		})(str) ;
		
		
		// var m;
		// var reg = /((\t+)*- )([^\t\n]+)\t*/gim ;
		// var reg = /^(([\t]*)- ).+([^\t\n]+)\t*$/gim ;
		
		// str.replace(reg, function(){
			
			// trace(arguments)
			// var l = arguments[2].length ;
			// var tt = new RegExp('\\t\{'+l+'\}') ;
			// trace('hehe', RegExp.rightContext.match(tt))
			// return '' ;
		// })
		
		// while(m = reg.exec(str)){
			
			// trace(m[2].length)
			// trace(RegExp.rightContext)
			
			
			
			
			// str = str.replace(m[0], '') ;
		// }
		
		
		str.replace(linereg, function MassiveReplace($$0, $$1, $$2){
			var tabs = $$1, line = $$2 ;
			var nnn = (!!tabs) ? tabs.length : 0 ;
			
			// important !! will permit string loop for elements 
			var fixed = true ;
			
			trace(RegExp.rightContext)
			
			
			// trim 4 clean
			line = line.replace(/\r|\n/g, '') ;
			
			// ignore blank lines
			if(line.replace(/\n|\t/g, '') == '') return '' ;
			// ignore comments 
			
			var original = line ;
			
			var ev = function(arg){
				with(locals) return eval(arg) ;
			}

			
			if(line.indexOf('//') != -1 ) {
				condition = addCondition( {
					type:'comment',
					cond:false,
					cost:1,
					passed:false,
					level:nnn,
					parent:parent
				} )
				return '' ;
			}
			
			// specialcases
			// switch case
			
			var case_r = /^(case) / ;
			if(case_r.test(line)){
				// if(!!condition && condition.passed !==  true) condition.ignore = true ;
				
				condition = addCondition( {
					type:'case',
					cond:ev(line.replace(case_r, '')),
					level:nnn,
					cost:2,
					parent:parent
				} ) ;
				return '' ;
			}
			
			var when_r = /^(when|default) */ ;
			if(when_r.test(line)){
				// if(!!condition && condition.passed !==  true) condition.ignore = true ;
				
				if(!!condition && condition.type == 'case' ){
					var newcond = ev(line.replace(when_r, '')) ;
					if(condition.cond == newcond) condition.passed = true ;
					else if(/^default/.test(line)){
						if(condition.passed !== true) condition.passed = true ;
						else condition.passed = false ;
					}
					return '' ;
				}else{
					// trace(condition)
					throw new Error('when or default statement encounter without case declaration') ;
				}
				return '' ;
			}
			
			
			
			
			var conds_r = /^(if|else( if)?|unless|until|while) ?/i ;
			
			// - livecode if/... conditionals
			// todo
			var live_r = /^(- )(.*)$/ ;
			if(live_r.test(line)){
				line.replace(live_r, function(){
					var st = arguments[2] ;
					
					if(conds_r.test(st)){
						var loc ;
						var cond = ev(st.replace(conds_r, '')) ;
						st.replace(conds_r, function(){
							loc = arguments[1] ;
						})
						if(loc == 'if'){
							condition = addCondition( {
								type:'if',
								cond:cond,
								cost:1,
								passed:cond,
								level:nnn,
								parent:parent
							} )
						}else if(loc == 'else if'){
							condition.passed = cond ;
						}else if(loc == 'else'){
							condition.passed = condition.passed ? false : true ;
						}else if(loc == 'unless'){
							condition = addCondition( {
								type:'if',
								cond:!cond,
								cost:1,
								passed:!cond,
								level:nnn,
								parent:parent
							} )
						}
						return '' ;
					}
				})
				return '' ;
			}
			
			
			
			if(conds_r.test(line)){
				
				var loc ;
				var cond = ev(line.replace(conds_r, '')) ;
				
				line.replace(conds_r, function(){
					loc = arguments[1] ;
				}) ;
				
				if(loc == 'if'){
					condition = addCondition( {
						type:'if',
						cond:cond,
						cost:1,
						passed:cond,
						level:nnn,
						parent:parent
					} )
				}else if(loc == 'else if'){
					condition.passed = cond ;
				}else if(loc == 'else'){
					condition.passed = condition.passed ? false : true ;
				}else if(loc == 'unless'){
					condition = addCondition( {
						type:'if',
						cond:!cond,
						cost:1,
						passed:!cond,
						level:nnn,
						parent:parent
					} )
				}
				return '' ;
			}
			
			// variable setting
			var vars_r = /^([0-9a-z-]+) = */gi ;
			var vars2_r = /([0-9a-z-]+) = */gi ;
			if(vars_r.test(line)){
				var mmm = line.replace(vars2_r, 'locals.$1 = ')
				ev(mmm) ;
				return '' ;
			}
			
			// find where scope is needed with locals
			line = line.replace(/#\{([^\}]+)\}/gi, function(){
				return ev(arguments[1]) ;
			})
			
			if(!!condition){
				
				if(nnn <= condition.level){
					var climb = function(){
						condition = removeCondition(condition) ;
						if(condition && nnn <= condition.level) climb() ;
					}
					climb() ;
				}else{
					
				}
				nnn = nnn - (condition ? condition.totalcost : 0) ;
				if(condition && !condition.passed) return '' ;
			}
			
			
			// normal HTMLObject creation
			var csssel_r = /[.#]([0-9a-z-]+)/gi ;
			var csssel2_r = /^[.#]([0-9a-z-]+)/gi ;
			var csstag_r = /^([0-9a-z-]+)/i ;
			var args_r = /^\((.*)\)( |$)/gi ;
			var space_r = /^ /gi ;
			var pipe_r = /^\| /gi ;
			var dot_r = /^\. /gi ;
			var equal_r = /^= /i ;
			
			var o = {children:[]} ;
			
			
			
			while(fixed === true){
				if(csstag_r.test(line)){
					line = line.replace(/^(\w|\d)+/, function(){
						o['tag'] = arguments[0] ;
						return '' ;
					}) ;
				}else if(csssel_r.test(line)){
					line = line.replace(csssel_r, function(){
						var spaceind = line.indexOf(' ') ;
						if(spaceind !== -1 && spaceind < arguments[2]) return ''+ arguments[0] ;
						var nn = arguments[0].replace(arguments[1], '') ;
						switch(nn){
							case '.' :
								o['class'] = (!!o['class'] ? o['class'] + ' ' : '' )+ arguments[1] ;
							break;
							case '#' :
								o['id'] = arguments[1] ;
							break;
						}
						return '' ;
					}) ;
					csssel_r = csssel2_r ;
				}else if(args_r.test(line)){
					line = line.replace(args_r, function(){
						var args = arguments[1] ;
						args.replace(/([0-9a-z-:]+) *= *([^,]+)(,|$)/gi, function(){
							o[arguments[1]] = ev(arguments[2]) ;
							return '' ;
						}) ;
						return '' ;
					}) ;
					line = '' ;
				}else if(space_r.test(line)){
					line = line.replace(space_r, '') ;
					o['html'] = line ;
					line = '' ;
				}else if(dot_r.test(line) || pipe_r.test(line)){
					line = line.replace(pipe_r, '').replace(dot_r, '') ;
					o['html'] = line ;
					o.nodeless = true ;
					line = '' ;
				}else if(equal_r.test(line)){
					line = line.replace(equal_r, '') ;
					o['html'] = ev(line) ;
					line = '' ;
				}else{
					fixed = false ;
				}
			} ;
			
			parentIndex = nnn ;
			
			// trace(parentIndex, oldParentIndex)
			
			if(parentIndex > oldParentIndex ){
				// trace('downwards')
				parent = future || top ;
				parents[parents.length] = parent ;
			}else if(parentIndex < oldParentIndex){
				// trace('upwards')
				parent = parents[parentIndex] ;
				parents = parents.slice(0, -1) ;
			}else{
				// trace("same level, don't seek") ;
			}
			
			parent.children[parent.children.length] = o ;
			future = o ;
			future.parent = parent ;
			future.index = parent.index + 1 ;
			
			oldParentIndex = parentIndex ;
			if(!!condition && !!condition.persistent && condition.farted === true){
				
				try{
					return '' ;
				}
				finally{
					condition.farted === false ;
					condition.stack = undefined ;
					condition.persistent = false ;
				}
		
			}else
			return '' ;
		})
		
		this.descriptor = top ;
	},
	render:function(locals){
		this.parse(locals) ;
		var excludes = {'html':1, 'tag':1, 'children':1, 'parent':1, 'index':1} ;
		var obj = this.descriptor ;
		var div = document.createElement('div') ;
		
		return (function Cool(oo, pdiv){
			var ch = oo.children ;
			var l = ch.length ;
			for (var i = 0 ; i < l ; i++){
				var o = ch[i] ;
				var el = document.createElement(o.tag || 'div') ;
				if(o.nodeless === true){
					pdiv.innerHTML += o.html ;
					continue ;
				}
				for(var s in o){
					if(!!!(s in excludes)) el.setAttribute(s, o[s]) ;
				}
				if('html' in o) el.innerHTML += o['html'] ;
				if(o.commented === true){
					var b = !!o.children && o.children.length > 0 ? Cool(o, el) : el ;
					pdiv.innerHTML += b.outerHTML;
				}else
					pdiv.appendChild( !!o.children && o.children.length > 0 ? Cool(o, el) : el) ;
			}
			return pdiv ;
		})(obj, div) ;
	},
	append:function(str, hard){
		if(!!hard) hard = false ;
	}
	
	
	
	
}, Loader)