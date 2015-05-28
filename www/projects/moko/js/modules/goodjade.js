'use strict' ;
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
		
		// evaluating
		var ev = function(arg, preval, postval){
			if(!!arg && arg != ''){
				arg = arg.replace(/(\bvar\b )?(\b\w+\b = )([^,;]+)/g, function(){
					var varst = arguments[1] ;
					if(!!varst &&  varst != ''){
						return 'var '+arguments[2]+' this.'+arguments[2] + arguments[3] ;
					}else{
						return 'this.'+arguments[2] + arguments[3] ;
					}
				}) ;
				
				// trace(locals['i'])
				
				
				// find where scope is needed with locals
				arg = arg.replace(/#\{([^\}]+)\}/gi, function(){
					trace(arg)
					return '"+'+arguments[1]+'+"' ;
				})
				
				
				if(!!postval && !!preval){
					var str = preval +'with(this){'+ arg+'} ' + postval ;
				}else{
					var str = 'with(this) return ('+arg+');'
				}
				var f = new Function(str) ;
				return f.call(locals) ;
			}else return null ;
		}
		
		
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
		
		// pre-treatments
		
			// - [ ] includes 
			// - [ ] shorthands 
				// - [ ] block expansion 
				// - [ ] trailing dot
			// - [ ] live code
			
		
		// post-treatments
		
		
		
		/*
		
			REGEXP :
			
			SPECIAL CHARACTERS MAP =
			
			[\^$.|?*+()
		
		*/
		// search for shorthands
		
		var all = str.replace(/(\r\n)/g, '\n\t') ;
		all = '\t'+all ;
		
		
		var output = '' ;
		var allreg = /^(\t*)(.+)$/mi ;
		
		while(allreg.test(all))
		all.replace(allreg, function(){
			var line = arguments[0] ;
			var block = arguments[2] ;
			// trace(line)
			// trace(block)
			
			var future = '' ;
			
			var tabs = arguments[1] ;
			var l = tabs.length ;
			// trace(line)
			// main cheks here
			
			// - comments
			// - block expansion
			var tabs_r = /^(\t*)/ ;
			var livecode_r = /^(\t*)- / ;
			var html_r = /^(([a-z1-6]+)?((\.|#)[0-9a-z-]+)*)(\(.+\))?(: ?)* ?/ ;
			// - live code eval
			// - includes
			var rightContext = all.replace(allreg, '').replace(/^\n+/, '') ;
			// or simply good to go > continue
			if(livecode_r.test(block)){
				
				block.replace(livecode_r, function(){
					
					var arr = (line+'\n'+rightContext).split(new RegExp('(?:\\n(?=\\t{1,'+(l)+'}[^\\t]))', 'g')) ;
					var max = arr.length ;
					var exec = '', 
					start = 'str = "";\n', 
					end = '\n; return str', 
					keep = '';
					var re = new RegExp(tabs+'\\t|(- )') ;
					var i , lline, llinebis;
					for(i = 0 ; i < max ; i ++){
						lline = arr[i] ;
						if(!re.test(lline)) break ;
						if(i > 0) keep += keep == '' ? lline : '\n' + lline ;
						else keep += lline.replace(/^.+\n/, '') ;
					}
					
					
					for(i = 0 ; i < max ; i++){
						lline = arr[i];
						var linedesc = lline.match(/^(.+)$/m)[1] ;
						var rest = lline.replace(linedesc + '\n', '') ;
						if(!re.test(lline)) break ;
						rest = rest.replace(/(.+)$/gm, function(){
							var nn = arguments[1].replace(/^\t/, '') ;
							if(nn.replace(/\t+/, '') == '- }') return '' ;
							return 'str+="'+nn+'"+"\\n";' ;
						})
						var corps = '{\n'+rest+'\n}' ;
						var total = lline.replace(livecode_r, '$1').match(/^(.+)$/m)[1] +'\n'+ corps ;
						exec += exec == '' ? total : '\n' + total ;
					}
					
					trace(rightContext)
					
					rightContext = rightContext.replace(keep, '') ;
					exec = exec ;
					rightContext = ev(exec, start,  end).replace(/\n$/, '') + rightContext ;
					line = '' ;
					
				})
			}
			if(/^[\/]{2}(-?)/.test(block)) trace('is commented', block)
			if(/include /.test(block)) trace('is an include', block)
			if(html_r.test(block)){
				
				// trace('is good to go', block)
				block.replace(html_r, function(){
					var exp = arguments[6] ;
					var args = arguments[5] ;
					var cont = arguments[1] ;
					
					// terse
					if(!!exp &&  exp !== '') {
						future = line.replace(cont + exp, '\t') + '\n' ;
						line = tabs + cont;
					// ready to parse
					}else{
						MassiveReplace(l, line) ;
					}
				})
			}
			output += line != '' ? '\n'+line : '' ;
			all = future + rightContext ;
			return '' ;
		})
		
		output = output.replace(/^\t/gm, '')
		// trace(output)
		str = output ;
		
		function MassiveReplace(tabs, line, ignore){
			
			var nnn = tabs ;
			// important !! will permit string loop for elements 
			var fixed = true ;
			var original = line ;
			
			line = line.replace(/\r|\n|\t/g, '') ;
			
			// ignore blank lines
			if(line == '') return '' ;
			
			// ignore comments 
			if(line.indexOf('//') != -1 ) {
				condition = addCondition( {
					type:'comment',
					cond:false,
					cost:1,
					passed:false,
					level:nnn,
					parent:parent
				} )
				return ;
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
				return ;
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
				return ;
			}
			
			
			var conds_r = /^(if|else( if)?|unless|until|while) ?/i ;
			
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
					condition.passed = !!condition.passed ? false : cond ;
					condition.tofail = true ;
				}else if(loc == 'else'){
					condition.passed = condition.passed || condition.tofail ? false : true ;
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
				return ;
			}
			// variable setting
			var vars_r = /^([0-9a-z-]+) = */gi ;
			var vars2_r = /([0-9a-z-]+) = */gi ;
			if(vars_r.test(line)){
				var mmm = line.replace(vars2_r, '$1 = ') ;
				
				ev(mmm) ;
				return ;
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
				if(condition && !condition.passed) {
					return  ;
				}
			}
			
			// normal HTMLObject creation
			var csssel_r = /[.#]([0-9a-z-]+)/gi ;
			var csssel2_r = /^[.#]([0-9a-z-]+)/gi ;
			var csstag_r = /^([0-9a-z-]+)/i ;
			var args_r = /^\((.*?)\)(?= |$)/i ;
			var space_r = /^ /gi ;
			var pipe_r = /^\| /gi ;
			var dot_r = /^\. /gi ;
			var equal_r = /^= /i ;
			
			var o = {children:[]} ;
			
			while(fixed === true){
				switch(true){
					case csstag_r.test(line) :
						line = line.replace(/^(\w|\d)+/, function(){
							o['tag'] = arguments[0] ;
							return '' ;
						}) ;
					break ;
					case csssel_r.test(line) :
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
					break ;
					case args_r.test(line) :
						line = line.replace(args_r, function(){
							var args = arguments[1] ;
							args.replace(/([0-9a-z-:]+) *= *([^,]+)(,|$)/gi, function(){
								o[arguments[1]] = ev(arguments[2]) ;
								return '' ;
							}) ;
							return '' ;
						}) ;
						line = line.length > 0 ? ' ' + line : line ;
					break ;
					case space_r.test(line) :
						line = line.replace(space_r, '') ;
						o['html'] = line ;
						line = '' ;
					break ;
					case dot_r.test(line) :
					case pipe_r.test(line) :
						line = line.replace(pipe_r, '').replace(dot_r, '') ;
						o['html'] = line ;
						o.nodeless = true ;
						line = '' ;
					break ;
					case equal_r.test(line) :
						line = line.replace(equal_r, '') ;
						o['html'] = ev(line) ;
						line = '' ;
					break ;
					default :
						fixed = false ;
					break ;
					
				}
			} ;
			
			parentIndex = nnn ;
			
			if(parentIndex > oldParentIndex ){
				parent = future || top ;
				parents[parents.length] = parent ;
			}else if(parentIndex < oldParentIndex){
				parent = parents[parentIndex] ;
				parents = parents.slice(0, -1) ;
			}
			
			parent.children[parent.children.length] = o ;
			future = o ;
			future.parent = parent ;
			future.index = parent.index + 1 ;
			oldParentIndex = parentIndex ;
			
		}
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
				pdiv.appendChild( !!o.children && o.children.length > 0 ? Cool(o, el) : el) ;
			}
			return pdiv ;
		})(obj, div) ;
	},
	append:function(str, hard){
		if(!!hard) hard = false ;
	}
}, Loader)