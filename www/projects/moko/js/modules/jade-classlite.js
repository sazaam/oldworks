//////////////// LOADING SCRIPTS
var Loader = (function(){
	var namespaces = [
		function () {return new XMLHttpRequest()},
		function () {return new ActiveXObject("Msxml2.XMLHTTP")},
		function () {return new ActiveXObject("Msxml3.XMLHTTP")},
		function () {return new ActiveXObject("Microsoft.XMLHTTP")}
	] ;
	var generateXHR = function () {
		var xhttp = false;
		var bank = namespaces ;
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
	var l = function Loader(url, complete, postData){
		var r = generateXHR() ;
		if (!r) return ;
		this.request = r ;
		this.url = url ;
		this.complete = complete ;
		this.userData = {
			post_data:postData,
			post_method:postData ? "POST" : "GET",
			ua_header:{ua:'User-Agent',ns:'XMLHTTP/1.0'},
			post_data_header: postData !== undefined ? {content_type:'Content-type',ns:'application/x-www-form-urlencoded'} : undefined 
		} ;	
	} ;
	l.prototype.destroy = function(){
		var ud = this.userData ;
		for(var n in ud){
			ud[n] = undefined ;
			delete ud[n] ;
		}

		this.userData =
		this.url =
		this.request =
		undefined ;

		delete this.userData ;
		delete this.url ;
		delete this.request ;

		return undefined ;
	}
	l.prototype.load = function(url, async){
		var r = this.request ;
		var th = this ;
		var ud = this.userData ;
		var complete = this.complete ;
		
		if(async === false){
			ud['post_method'] = 'GET' ;
			r.open(ud['post_method'], url || this.url, false) ;                             
			r.send(null) ;
			if(!!th.complete) th.complete(r, th) ;
			return this ;   
		}else{
			r.open(ud['post_method'] , url || this.url, async || true) ;
			if (ud['post_data_header'] !== undefined) r.setRequestHeader(ud['post_data_header']['content_type'],ud['post_data_header']['ns']) ;
				r.onreadystatechange = function () {
				if (r.readyState != 4) return;
				if (r.status != 200 && r.status != 304) {
				return ;
				}
				if(!!th.complete) th.complete(r, th) ;
			}
			if (r.readyState == 4) return ;
			r.send(ud['postData']) ;
			return this ;
		}
	} ;
	return l ;
})() ;



var Jade = Class('naja.jade::Jade', {
	statics:{
		root:'./jade/',
		evalstr:undefined,
		cache:{},
		esc:function esc(html){
			return String(html)
				.replace(/&(?!\w+;)/g, '&amp;')
				.replace(/</g, '&lt;')
				.replace(/>/g, '&gt;')
				.replace(/"/g, '&quot;')
		}
	},
	constructor:function Jade(url){
		Jade.base.apply(this, [Jade.root + url]) ;
		trace(this.url)
	},
	load:function(url, async, force){
		var loc = url || this.url ;
		
		if(loc in Jade.cache){
			this.response = Jade.cache[loc] ;
			return this ;
		}
		
		Jade.factory.load.apply(this, [loc, async]) ;
		this.response = Jade.cache[loc] = this.request.responseText ;
		return this ;
	},
	parse:function(locals){
		
		var str = this.response ;
		
		// DECLARING ALL STATICS REGEXPS
		var multiline_r = /^.+$\n?/gm ;
		var line_r = /^.+$\n?/m ;
		var tcs_r = /^(\t+)(.+)\n?/
		
		// HACKING ISSUE OF MISSING-ANY-TABS SPECIAL CASE
		var all = str.replace(/(\r\n)/g, '\n\t') ;
		all = '\t'+all ;
		
		// EVALUATING LITTERAL FUNCTION
		var live = function live(str){
			
			var STR = '' ;
			
			str = str.replace(/(#|\!)\{([^\}]+)\}/gi, function(){
				var dec = arguments[1] ;
				if(dec == '#'){
					return "'+"+arguments[2]+"+'" ;
				}else{
					return "'+Jade.esc(this['"+arguments[2] + "']) +'" ;
				}
			})
			
			var vars2_r = /((var )?\b\w+\b)( =(?!=)| in(?!in)) */gi ;
			str = str.replace(vars2_r, function(){
				var varname = arguments[1] ;
				if(str.charAt(arguments[4] - 1) == '.') return varname + ' = ' ;
				
				var prefix = arguments[2] ;
				var suffix = arguments[3] ;
				var isVar = !!prefix && prefix == 'var ' ;
				
				if(isVar) {
					varname = varname.replace(prefix, '') ;
				}
				return "this['"+varname + "']" + suffix ;
			}) ;
			
			STR = "return (function(){with(this) return ("+str +")}).call(this)";
			// trace(STR)
			return new Function(STR).call(locals) ;
		}
		
		
		
		/* 
		
		- [x] Must evaluate in scope > locals
		- [x] Must evaluate without vars ending global
		- [x] Must provide results if requested
		
		
		
		#[this is to be parsed as JS]
		- for(var i = 0 \/* This will become (removed:var i =) this[i] =  *\/; i < friends ; i ++){
			#[ That's the important phase to remember
			h4 You have #{i} friends
				h5 You have #{i\/* This will also become JS once *\/} friends
					h6 You have #{i} friends
			#]
		#[this too is to be parsed as JS]
		- }
		
		
		WILL THIS BLOCK ARRIVE SO OR LINE BY LINE, OR TREATED ???
		
		- Must arrive with as many block as the whole sequence needs
		(--> the next time [tabs+'- '] in unencountered)
		
		
		Step 1 cleared !!!
		
		now's todos
		
		- [ ] comments // line & blocks
		- [x] block expansion
		- [x] escaped text
		- [ ] way to transform reserved key matches into '- ' js syntax easily
			
			case + when
			
			if unless else else if :
				if foo == 'bar'
					ul
						li yay
						li foo
						li worked
				else
					p oh no! didnt work
				
				
			for :
				for user in users
					if user.role == 'admin'
						p #{user.name} is an admin
					else
						p= user.name
			
			while :
				ul
					len = 4
					while len--
						li= len
				
			each :
				- var items = ["one", "two", "three"]
				each item in items
				  li= item
				
				obj = { foo: 'bar' }
				each val, key in obj
				  li #{key}: #{val}
		
		
		*/
		
		
		var parents = [] ;
		var parent, node ;
		var top = parent = parents[0] = {children:[], index:0} ;
		var parentIndex, oldParentIndex = 0;
		
		var tag_r = /^[0-6a-z]+/ ;
		var css_r = /^(([#.])([0-9a-z-]+))+?/i ;
		var args_r = /^\((.*?)\)(?= |!?= | |$)/i ;
		var colon_r = /^: / ;
		var space_r = /^ / ;
		var pipe_r = /^\| / ;
		var equal_r = /^= / ;
		var notequal_r = /^!= / ;
		
		var rightContext = all ;
		// MAIN LINE FIND/REPLACE LOOP
		while(line_r.test(all))
		all.replace(line_r, function(){
			
			var future = '', tabs, cont ;
			var proper = all.replace(line_r, '');
			
			
			var m = arguments[0].match(tcs_r) ;
			var line = m[0] ;
			tabs = m[1] ;
			cont = m[2] ;
			
			var nnn = tabs.length ;
			
			var block_r = new RegExp('(?:\\n\\t{1,'+(nnn)+'}(?!\\t|- ))', 'm') ;
			var commentblock_r = new RegExp('(?:\\n\\t{1,'+(nnn)+'}(?!\\t))', 'm') ;
			
			var comments_r = /^(\t+)*(\/\/)/i ;
			if(comments_r.test(cont)){
				var code = rightContext.split(commentblock_r)[0] ;
				cont = '' ;
				proper = all.replace(code, '') ;
			}
			
			var include_r = /^(\t+)*(include) ([0-9a-z\/.]+)$/im ;
			if(include_r.test(cont)){
				
				var included = line.replace(include_r, function parseForIncludes(){
					
					var ttt = arguments[1] ;
					var path = arguments[3] ;
					var extreg = /[.](a-z0-9)+$/ ;
					if(!extreg.test(path)){
						path = path + '.jade' ;
					}
					var msg = new Jade(path).load(undefined, false).response.replace(/(\r\n)/g, '\n') ;
					if(include_r.test(msg)){
						msg = msg.replace(include_r, parseForIncludes)
					}
					
					return msg.replace(multiline_r, function(){
						return ttt + arguments[0] ;
					}) ; ;
				})
				
				cont = '' ;
				future = included ;
			}
			
			
			// Variables setting
			var vars_r = /^((var )?\b\w+\b) =(?!=) */i ;
			if(vars_r.test(cont)){
				live(cont) ;
				cont = '' ;
			}
			
			
			// LiveCode 
			var livecode_r = /- / ;
			if(livecode_r.test(cont)){
				
				var code = rightContext.split(block_r)[0] ;
				var start = "(function(){Jade.evalstr = '' ;" ;
				var end = "return Jade.evalstr ;}).call(this)" ;
				
				var ind = 0 ;
				var buff = code.replace(multiline_r, function(){
					var mm = arguments[0].match(tcs_r) ;
					var ttabs = mm[1] ;
					var lline = mm[2] ;
					var tt = ttabs.replace(tabs, '') ;
					
					if(livecode_r.test(lline)){
						// tracking nested tabindes
						if(lline == '- }' ) {
							do{
							ind--
							}
							while(ind > tt.length)
						} else if(tt.length >= ind) ind++ ;
						return lline.replace(livecode_r, '').replace(/\t+/, '') + '\n' ;
					}else{
						if(tt.length < ind){
							do{
								ind--
							}
							while(ind > tt.length)
						}
						var ll = lline.replace(tag_r, '');
						while(css_r.test(ll)) ll = ll.replace(css_r, '') ;
						while(args_r.test(ll)) ll = ll.replace(args_r, '') ;
						var rest = lline.replace(ll, '') ;
						if(equal_r.test(ll)){
							ll = ll.replace(equal_r, '') ;
							ll = rest + ' #{'+ ll + '}' ;
							return "Jade.evalstr +='"+ ttabs.substr(ind) + ll + "' + '\\n';\n" ;
						}else
						return "Jade.evalstr +='"+ ttabs.substr(ind) + lline + "' + '\\n';\n" ;
					}
				})
				
				var evalstr = start + buff + end ;
				
				cont = '' ;
				proper = live(evalstr).replace(/\n$/, '') + all.replace(code, '') ;
			}
			
			if(cont != ''){
				// hack passed eval values
				cont = cont.replace(/(#|\!)\{([^\}]+)\}/gi, function(){
					
					var dec = arguments[1] ;
					if(dec == '#'){
						return live(arguments[2]) ;
					}else{
						return Jade.esc(live(arguments[2])) ;
					}
				}) ;
				
				// starting HTML description
				var o = {children:[]} ;
			
				var tag = 'div';
				cont = cont.replace(tag_r, function(){
					tag = arguments[0] ;
					return '' ;
				}) ;
				o['tag'] = tag ;
				
				while(css_r.test(cont)){
					cont = cont.replace(css_r, function(){
						var sel = arguments[2] ;
						switch(sel){
							case '.' :
								o['class'] = (!!o['class'] ? o['class'] + ' ' : '' )+ arguments[3] ;
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
							var arg = args[i].replace(/^ /, '') ;
							var name ;
							var val = arg.replace(/(.+)(?= *= *)/, function(){
								name = arguments[0] ;
								return '' ;
							}).replace(/ *= */, '') ;
							o[name] = live(val.replace(/^"|"$/g, '"')) ;
						}
						return '' ;
					}) ;
				}
				
				
				if(colon_r.test(cont)){
					future = tabs + '\t' + cont.replace(colon_r, '') + '\n' ;
					cont = '' ;
				}
				
				if(space_r.test(cont)){
					cont = cont.replace(space_r, '') ;
					o['html'] = cont ;
					cont = '' ;
				}
				if(pipe_r.test(cont)){
					cont = cont.replace(pipe_r, '') ;
					o['html'] = cont ;
					o.nodeless = true ;
					cont = '' ;
				}
				
				if(equal_r.test(cont)){
					cont = cont.replace(equal_r, '') ;
					o['html'] = live(cont) ;
					cont = '' ;
				}
				
				if(notequal_r.test(cont)){
					cont = cont.replace(notequal_r, '') ;
					o['html'] = Jade.esc(live(cont)) ;
					cont = '' ;
				}
				
				parentIndex = nnn - 1 ;
				
				if(parentIndex > oldParentIndex ){
					parent = node || top ;
					parents[parents.length] = parent ;
				}else if(parentIndex < oldParentIndex){
					parent = parents[parentIndex] ;
					parents = parents.slice(0, -1) ;
				}
				parent.children[parent.children.length] = o ;
				node = o ;
				node.parent = parent ;
				node.index = parent.index + 1 ;
				oldParentIndex = parentIndex ;
			}
			
			// don't touch, rightcontext MUST remove line WITH trailing '\n'
			rightContext = proper ;
			// don't touch, permits the rewriting of the tested string
			all = future + rightContext ;
			return '' ;
		})
		Jade.evalstr = '' ;
		this.descriptor = top ;
		// trace(top)
	},
	render:function(locals){
		
		this.parse(locals) ;
		
		var excludes = {'html':1, 'tag':1, 'children':1, 'parent':1, 'index':1} ;
		var obj = this.descriptor ;
		
		return (function Cool(oo, pdiv){
			var ch = oo.children ;
			var l = ch.length ;
			for (var i = 0 ; i < l ; i++){
				var o = ch[i] ;
				if(o.nodeless === true){
					pdiv.innerHTML += o.html ;
					continue ;
				}
				var el = document.createElement(o.tag || 'div') ;
				for(var s in o){
					if(!!!(s in excludes)) {
						el.setAttribute(s, o[s]) ;
					}
				}
				if('html' in o) el.innerHTML += o['html'] ;
				pdiv.appendChild( !!o.children && o.children.length > 0 ? Cool(o, el) : el) ;
			}
			return pdiv ;
		})(obj, document.createElement('div')) ;
	}
}, Loader)