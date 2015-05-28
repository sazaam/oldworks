
var nodes = {'./layouts/pcaa/js/test_loading/' : [
					{strawexpress:'strawexpress2.js'},
					{strawexpressutil:'strawexpress2-utils.js'},
					{strawexpressaddress:'strawexpress2-address.js'},
					{strawnodeutils:'strawnode2-utils.js'},
					{betweenjs:'betweenjs2.js'}
				],
			'./layouts/pcaa/img/' : [
					{home:'home/mtmd1nmo.png'},
					{home3:'projects/4de7d63p.png'},
					{home4:'projects/6fkvrlts.png'},
					{home5:'projects/8iuhfnwz.png'},
				]
			} ;

var XXXLoader = Type.define({
		pkg:'net',
		domain:Type.appdomain,
		statics:{
			guid:0
		},
		createNode:function createNode(src){
			var ext = src.replace(/.+\./, '') ;
			var node ;
			switch(ext){
				case 'js' :
					node = this.createJSNode(src) ;
				break ;
				case 'bmp' :
				case 'jpg' :
				case 'png' :
					node = this.createIMGNode(src) ;
				break ;
				case 'css' :
					node = this.createCSSNode(src) ;
				break ;
			}
			return node ;
		},
		createJSNode:function createNode(src){
			return $('<script type="text/javascript">require("'+src+'")</script>') ;
		},
		createIMGNode:function createIMGNode(src){
			return $('<img alt="" src="'+src+'" />') ;
		},
		constructor:XXXLoader = function XXXLoader(nodelist){
			var loader = this ;
			var listqueue = new CommandQueue() ;
			listqueue.basepath = '' ;
			
			(function(list, queue){
				
				for(var desc in list){
					var loads = list[desc] ;
					var path = queue.basepath ;
					switch(true){
						case loads instanceof Array :
							// si est un nodeconteneur
							var guid ;
							var q = new CommandQueue() ;
							q.basepath = path + desc ;
							queue.add(q) ;
							
							q.add(new Command(queue, function(){
								guid = XXXLoader.guid ++ ;
								var uid = 'loader' + guid ;
								var iframe = $('<iframe id="'+uid+'" class="dispNone abs left0 bottom0" src="about:blank" />').appendTo('.sidenav') ;
								var body = iframe.contents().find('body') ;
								
								
								// $('<script type="text/javascript">trace("COMPLETE -> ") </script>').appendTo(body) ;
							})) ;
							
							for(var i = 0 , l = loads.length ; i < l ;i++){
								arguments.callee(loads[i], q) ;
							}
							q.add(new Command(queue, function(){
								guid = XXXLoader.guid - 1;
								var uid = 'loader' + guid ;
								
								var iframe = $('#'+uid) ;
								// with(iframe[0].contentWindow){
									
								// }
								iframe.remove() ;
							})) ;
						break ;
						default :
							var guid = XXXLoader.guid ;
							// si est un pathconteneur
							var c = new Command(queue, function loadOpenCommand(){
								var uid = 'loader' + guid ;
								var iframe = $('#'+uid) ;
								var body = iframe.contents().find('body') ;
								var node = loader.createNode(queue.basepath + loads) ;
								node.appendTo(body) ;
							}) ;
							queue.add(c) ;
							
						break;
					}
					
				}
				
			
			})(nodelist, listqueue) ;
			
			// trace(listqueue) ;
			
			listqueue.bind('$', function(e){
				trace('COMPLETE')
				trace(BetweenJS2)
			}) ;
			
			listqueue.execute() ;
			
			/* 
			throw 'Error' ; */
			
				/* 
				var uid = guid + 'loader';
				var iframe = $('<iframe id="'+uid+'" class="abs left0 bottom0" />').appendTo('.sidenav') ;
				
				var head = iframe.contents().find('head') ;
				var body = iframe.contents().find('body') ;
				var test = $('<script type="text/javascript">trace(XXXLoader);$(window).load(function(){trace("COMPLETE -> '+ path +'");$("'+uid+'").remove()})</script>') ;
				test.appendTo(body) ;
				
				
				for(var i = 0, l = loads.length ; i < l ; i++){
					var obj = loads[i] ;
					var node = this.createNode(path + obj) ;
					
					node.appendTo(body) ;
				} */
		}
	}) ;

var loader = new XXXLoader(nodes) ;

// throw "" ;


















var loader = document.createElement('IFRAME') ;
	loader.setAttribute('id', 'xxxloader') ;
	loader.setAttribute('class', 'dispNone abs left bottom') ;
	loader.setAttribute('src', 'about:blank') ;
	


var req = function(uri){
	// var loader = $('<iframe id="xxxloader" class="dispNone abs left bottom" src="about:blank">') ;
	document.body.appendChild(loader) ;
	
    var val = '<scr' + 'ipt type="text/javascript">var module = {} ;</scr' + 'ipt>' ;
	val += '<scr' + 'ipt type="text/javascript" src="./layouts/pcaa/js/pcaa_app/node_modules/strawexpress.js"></scr' + 'ipt>' ;

	// get a handle on the <iframe>d document (in a cross-browser way)
	var doc, win = loader.contentWindow || loader.contentDocument;
	if (win.document) {
		doc = win.document;
	}
	
	// open, write content to, and close the document
	// doc.open();
	// doc.write(val);
	// doc.close();
	
	
	// throw '' ;
	var scr = document.createElement('SCRIPT') ;
	scr.setAttribute('src', './layouts/pcaa/js/' + uri) ;
	scr.setAttribute('async', 'false') ;
	// $(doc.body).append(scr) ;
	
	doc.body.appendChild(scr) ;
}

var sss = req('./test_loading/test.js') ;
trace('wewcwef')

throw 'END OF SCRIPT' ;

