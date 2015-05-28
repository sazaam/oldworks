'use strict' ;
var Jade = (function(){
	var bank = [
		function () {return new XMLHttpRequest()},
		function () {return new ActiveXObject("Msxml2.XMLHTTP")},
		function () {return new ActiveXObject("Msxml3.XMLHTTP")},
		function () {return new ActiveXObject("Microsoft.XMLHTTP")}
	] ;
	
	var generateXHR = function () {
		var xhttp = false;
		var l = bank.length ;
		for (var i = 0 ; i < l ; i++) {
			try {
			   xhttp = bank[i]();
			}
			catch (e) {
			   continue;
			}
			break;
		}
		return xhttp;
	} ;
	
	var Jade = function Jade(url, complete, postData){
		var r = generateXHR() ;
		if (!r) return ;
		this.request = r ;
		this.url = Jade.root + url ;
		this.complete = complete ;
		this.userData = {
			post_data:postData,
			post_method:postData ? "POST" : "GET",
			ua_header:{ua:'User-Agent',ns:'XMLHTTP/1.0'},
			post_data_header: postData !== undefined ? {content_type:'Content-type',ns:'application/x-www-form-urlencoded'} : undefined 
		} ;	
	} ;
	
	Jade.prototype.destroy = function destroy(){
		var ud = this.userData ;
		for(var n in ud){
			ud[n] = undefined ;
			delete ud[n] ;
		}
		this.descriptor =
		this.response = 
		this.userData =
		this.url =
		this.request =
		undefined ;
		
		delete this.descriptor ;
		delete this.response ;
		delete this.userData ;
		delete this.url ;
		delete this.request ;

		return undefined ;
	}
	
	Jade.prototype.load = function load(url, async, force){
		var r = this.request ;
		var th = this ;
		var ud = this.userData ;
		var complete = this.complete ;
		
		
		var loc = url || this.url ;
		
		if(loc in Jade.cache){
			this.response = Jade.cache[loc] ;
			if(async && !!th.complete) th.complete(r, th) ;
			return this ;
		}
		
		if(async === false){
			ud['post_method'] = 'GET' ;
			r.open(ud['post_method'], loc, false) ;                             
			r.send(null) ;
			this.response = Jade.cache[loc] = this.request.responseText ;
			if(!!th.complete) th.complete(r, th) ;
			return this ;   
		}else{
			r.open(ud['post_method'] , loc, async || true) ;
			if (ud['post_data_header'] !== undefined) r.setRequestHeader(ud['post_data_header']['content_type'],ud['post_data_header']['ns']) ;
				r.onreadystatechange = function () {
				if (r.readyState != 4) return;
				if (r.status != 200 && r.status != 304) {
				return ;
				}
				this.response = Jade.cache[loc] = this.request.responseText ;
				if(!!th.complete) th.complete(r, th) ;
			}
			if (r.readyState == 4) return ;
			r.send(ud['postData']) ;
			return this ;
		}
	} ;
	
	Jade.prototype.parse = function parse(locals, text){
		
		var all = text || this.response,
		
		// DECLARING ALL STATICS REGEXPS
		multiline_r = /^.+$\n?/gm,
		multitabs_r = /\t+/,
		line_r = /^.+$\n?/m,
		tcs_r = /^(\t+)(.+)\n?/,
		comments_r = /^(\t+)*(\/\/)/i,
		include_r = /^(\t+)*(include) ([0-9a-z\/.]+)$/im,
		ext_r = /[.](a-z0-9)+$/,
		vars_r = /^((var )?\b\w+\b) =(?!=) */i,
		livecode_r = /^- /,
		tag_r = /^[0-6a-z]+/,
		css_r = /^(([#.])([0-9a-z-]+))+?/i,
		args_r = /^\((.*?)\)(?= |!?= | |$)/i,
		someassignment_r = /(.+)(?= *= *)/,
		assignment_r = / *= */,
		colon_r = /^: /,
		space_r = /^ /,
		pipe_r = /^\| /,
		equal_r = /^= /,
		notequal_r = /^!= /,
		singlequote_r = /'/g,
		blank_r = /^(\t+)*(\n|$)/gm,
		expr_r = /(#|\!)\{([^\}]+)\}/gi,
		crlf_r = /(\r\n)/g,
		end_r = /\n$/,
		
		// DECLARING ALL STATICS STRINGS
		TAB = '\t',
		NL = '\n',
		NLTAB = '\n\t',
		EMPTY = '' ;
		
		// HACKING ISSUE OF MISSING-ANY-TABS SPECIAL CASE
		all = TAB + all.replace(crlf_r, NLTAB) ;
		// REMOVING ANY BLANK LINES
		all = all.replace(blank_r, EMPTY) ;
		// EVALUATING LITTERAL FUNCTION
		var live = Jade.live = function live(str){
			var STR = EMPTY ;
			str = str.replace(expr_r, function(){
				var dec = arguments[1] ;
				var sss ;
				if(dec == '#'){
					sss = arguments[2] ;
					return "'+" + sss + "+'" ;
				}else{
					var sss = arguments[2] ;
					return "'+Jade.esc(" + sss + ")+'" ;
				}
			})
			STR = "return (function(){with(this) return ("+str +")}).call(this)";
			return new Function(STR).call(locals) ;
		}
		// DECRIPTOR'S SETTINGS
		var parents = [] ;
		var parent, node ;
		var top = parent = parents[0] = {children:[], index:0} ;
		var parentIndex, oldParentIndex = 0;
		
		var allcomments_r = /^(\t+)*(\/\/)/gim ;
		if(allcomments_r.test(all)){
			all.replace(allcomments_r, function(){
				var ttt = (arguments[1] || '').length ;
				var commentblock_r = new RegExp('(?:\\n\\t{1,'+(ttt)+'}(?!\\t))', 'm') ;
				var code = all.split(commentblock_r)[0] ;
				all = all.replace(code, EMPTY) ;
			}) ;
		}
		
		var rightContext = all ;
		// MAIN LINE FIND/REPLACE LOOP
		while(line_r.test(all))
		all.replace(line_r, function(){
			
			var future = EMPTY, tabs, cont ;
			var proper = all.replace(line_r, EMPTY) ;
			// seperate tabs from actual content of line
			var m = arguments[0].match(tcs_r) ;
			
			if(m !== null) {
				var line = m[0] ;
				tabs = m[1] ;
				cont = m[2] ;
				var original = cont ;
				var nnn = tabs.length ;
				var block_r = new RegExp('(?:\\n\\t{1,'+(nnn)+'}(?!\\t|- ))', 'm') ;
				var commentblock_r = new RegExp('(?:\\n\\t{1,'+(nnn)+'}(?!\\t))', 'm') ;
				
				// comments
				if(comments_r.test(cont)){
					var code = rightContext.split(commentblock_r)[0] ;
					cont = '' ;
					proper = all.replace(code, EMPTY) ;
				}
				
				//includes
				if(include_r.test(cont)){
					var included = line.replace(include_r, function parseForIncludes(){
						var ttt = arguments[1] ;
						var path = arguments[3] ;
						
						if(!ext_r.test(path)){
							path = path + '.jade' ;
						}
						var msg = new Jade(path).load(undefined, false).response.replace(crlf_r, NL) ;
						if(include_r.test(msg)){
							msg = msg.replace(include_r, parseForIncludes)
						}
						return msg.replace(multiline_r, function(){
							return ttt + arguments[0] ;
						}) ; ;
					})
					
					cont = EMPTY ;
					future = included ;
				}
				
				// Variables setting
				if(vars_r.test(cont)){
					live(cont) ;
					cont = EMPTY ;
				}
				
				// LiveCode 
				if(livecode_r.test(cont)){
					
					var code = rightContext.split(block_r)[0] ;
					var start = "(function(){Jade.evalstr = '' ;" ;
					var end = "return Jade.evalstr ;}).call(this)" ;
					
					var ind = 0 ;
					var buff = code.replace(multiline_r, function(){
						var mm = arguments[0].match(tcs_r) ;
						var ttabs = mm[1] ;
						var lline = mm[2] ;
						var tt = ttabs.replace(tabs, EMPTY) ;
						
						// still need to remove comment
						if(comments_r.test(lline)){
							return EMPTY ;
						}
						
						if(livecode_r.test(lline)){
							// tracking nested tabindex
							if(lline == '- }' ) {
								do{
									ind--
								}
								while(ind > tt.length)
							} else if(tt.length >= ind) ind++ ;
							return lline.replace(livecode_r, EMPTY).replace(multitabs_r, EMPTY) + NL ;
						}else{
							if(tt.length < ind){
								do{
									ind--
								}
								while(ind > tt.length)
							}
							
							var ll = lline.replace(tag_r, EMPTY);
							while(css_r.test(ll)) ll = ll.replace(css_r, EMPTY) ;
							while(args_r.test(ll)) ll = ll.replace(args_r, EMPTY) ;
							var rest = lline.replace(ll, EMPTY) ;
							if(equal_r.test(ll)){
								ll = ll.replace(equal_r, EMPTY) ;
								ll = rest + ' #{'+ ll + '}' ;
								return "Jade.evalstr +='"+ ttabs.substr(ind) + ll.replace(singlequote_r, '"' ) + "' + '\\n';\n" ;
							}else if(notequal_r.test(ll)){
								ll = ll.replace(notequal_r, EMPTY) ;
								ll = rest + ' !{'+ ll + '}' ;
								return "Jade.evalstr +='"+ ttabs.substr(ind) + ll.replace(singlequote_r, '"' ) + "' + '\\n';\n" ;
							}else
							return "Jade.evalstr +='"+ ttabs.substr(ind) + lline.replace(singlequote_r, '"' ) + "' + '\\n';\n" ;
						}
					})
					
					var evalstr = start + buff + end ;
					
					cont = EMPTY ;
					proper = live(evalstr).replace(end_r, EMPTY) + all.replace(code, EMPTY) ;
				}
				
				if(cont != EMPTY){
					// hack passed eval values
					cont = cont.replace(expr_r, function(){
						
						var dec = arguments[1] ;
						if(dec == '#'){
							return live(arguments[2]) ;
						}else{
							return Jade.esc(live(arguments[2])) ;
						}
					}) ;
					
					// starting HTML description
					var o = {children:[]} ;
					
					cont = cont.replace(tag_r, function(){
						o['tag'] = arguments[0] ;
						return EMPTY ;
					}) ;
					
					
					while(css_r.test(cont)){
						cont = cont.replace(css_r, function(){
							var sel = arguments[2] ;
							switch(sel){
								case '.' :
									o['class'] = (!!o['class'] ? o['class'] + ' ' : EMPTY ) + arguments[3] ;
								break;
								case '#' :
									o['id'] = arguments[3] ;
								break;
							}
							
							
							return '' ;
						}) ;
					}
					
					
					if(args_r.test(cont)){
						cont = cont.replace(args_r, function(){
							var args = arguments[1].split(',') ;
							var len = args.length ;
							for(var i = 0 ; i < len ; i++){
								var arg = args[i].replace(space_r, EMPTY) ;
								var name ;
								var val = arg.replace(someassignment_r, function(){
									name = arguments[0] ;
									return EMPTY ;
								}).replace(assignment_r, EMPTY) ;
								o[name] = live(val) ;
							}
							return EMPTY ;
						}) ;
					}
					
					
					if(colon_r.test(cont)){
						future = tabs + TAB + cont.replace(colon_r, EMPTY) + NL ;
						cont = EMPTY ;
					}
					
					if(space_r.test(cont)){
						cont = cont.replace(space_r, EMPTY) ;
						o['html'] = cont ;
						cont = EMPTY ;
					}
					if(pipe_r.test(cont)){
						cont = cont.replace(pipe_r, EMPTY) ;
						o['html'] = cont ;
						o.nodeless = true ;
						cont = EMPTY ;
					}
					
					if(equal_r.test(cont)){
						cont = cont.replace(equal_r, EMPTY) ;
						o['html'] = live(cont) ;
						cont = EMPTY ;
					}
					
					if(notequal_r.test(cont)){
						cont = cont.replace(notequal_r, EMPTY) ;
						o['html'] = Jade.esc(live(cont)) ;
						cont = EMPTY ;
					}
					
					parentIndex = nnn - 1 ;
					if(parentIndex > oldParentIndex ){
						parent = node || top ;
						parents[parents.length] = parent ;
					}else if(parentIndex < oldParentIndex){
						while(parentIndex < oldParentIndex){
							parent = parents[parentIndex] ;
							parents = parents.slice(0, -1) ;
							oldParentIndex -- ;
						}
					}
					parent.children[parent.children.length] = o ;
					node = o ;
					node.parent = parent ;
					node.index = parent.index + 1 ;
					oldParentIndex = parentIndex ;
				}
				
			} ;
			
			// don't touch, rightcontext MUST remove line WITH trailing '\n'
			rightContext = proper ;
			// don't touch, permits the rewriting of the tested string
			all = future + rightContext ;
			return EMPTY ;
		})
		Jade.evalstr = '' ;
		
		return (this.descriptor = top) ;
	} ;
	
	Jade.prototype.render = function render(locals, text){
		
		var obj = this.parse(locals, text) ;
		var excludes = {'html':1, 'tag':1, 'children':1, 'parent':1, 'index':1} ;
		return (function createChild(oo, pdiv){
			var ch = oo.children ;
			var l = ch.length ;
			for (var i = 0 ; i < l ; i++){
				var o = ch[i] ;
				var el ;
				if(!!o.nodeless){
					pdiv.innerHTML = pdiv.innerHTML + o['html'] ;
				}else{
					el = document.createElement(o.tag || 'div') ;
					for(var s in o){
						if(!!!(s in excludes)) {
							el.setAttribute(s, o[s]) ;
						}
					}
					if('html' in o) el.innerHTML = el.innerHTML + o['html'] ;
					if(!!o.children && o.children.length > 0 ) el = createChild(o, el) ;
					pdiv.appendChild(el) ;
				}
			}
			return pdiv ;
		})(obj, document.createElement('div')) ;
		
	}
	//statics
	Jade.root = './jade/' ;
	Jade.cache = {} ;
	Jade.evalstr = '' ;
	Jade.esc = function(html){
	return String(html)
			.replace(/&(?!\w+;)/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
	}
	
	return Jade ;
})() ;