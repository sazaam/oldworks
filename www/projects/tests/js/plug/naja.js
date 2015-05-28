
/*
* 
* Base Framework For DeepLinking
* author saz
* copyright sazaam(at)gmail.com
* 2011 All Rights Reserved
* 
* Framework licensed under GNU-extended License
* 
* 
* In the process of creating Base Toolkit for Spill, 
* used by Spill 
* courtesy of the author
* All Paternity Rights Reserved (saz) 2011-2012
* 
* 
* 
* 
* Base Core Classes for easier scripting Hash-enhancement in Javascript Web-apps
* 
* 
* 
* (No Package)
* > NS (namespaces enabling (packages) for JS Objects)
* 
* 
* pkg(spill.events::)
* > EventDispatcher
* 
* 
* pkg(spill.command::)
* > Command
* > CommandQueue
* > WaitCommand
* > AjaxCommand
* 
* 
* pkg(spill.step::)
* > Step 
* > Hierarchy
* > HierarchyChanger
* > AddressHierarchy extends Hierarchy
* > AddressChanger extends HierarchyChanger
* 
* 
* pkg(spill.detect::)
* > Kompat (Tool for easier browser-sniffing while developping) // still can improve
* 
* 
* pkg(spill.load::)
* > XLoader
* 
* 
* pkg(spill.net::)
* > Request  // still can improve
* > Template  // still can improve
* 
* 
* 
*  Dependancies  [
*     Classy
*     Jquery
*     Jquery-ba-hashchange (only for Hash-enabled Web-Apps)
*     Sugar, waiting for IE to implement Javascript 1.8
*  ]
* 
* 
* */

/* TRACE*/
cl = trace = function(){
   // alert(window.console)
   // presence of console namespace
   if(window.console && console){
      if(this.opera){ // OP
         opera.postError.apply(opera, [].slice.call(arguments)) ;
      }else if(console.firebug !== undefined){ // FF
         arguments.length > 1 ? console.log([].slice.call(arguments)) : console.log.apply(console, arguments) ;
      }else if(console.profiles) { // CHR
         console.log.apply(console, [].slice.call(arguments)) ;
      }else{// IE
         console.log([].slice.call(arguments)) ;
      }
   }else{
      // uncomment if you really wish alerts 
      // alert([].slice.call(arguments)) ;
   }
} ;

/* KOMPAT */
var Kompat = NS('Kompat', NS('spill.detect::Kompat', Class.$extend({
   __classvars__ : {
      version:0.1,
      kompat:null,
      namespaces:{
         ie: /MSIE [\d.]+/i,
         chr : /Chrome.[\d.]+/i,
         ff : /Firefox.[\d.]+/i,
         /*ios : /iP[ao]d|iPhone/i,*/
         safmob: /[\d.]+ Mobile Safari/i,
         saf : /[\d.]+ Safari/i,
         op : /Opera/i
      },
      workspaces:{
         win: /WINDOWS(?= NT ([\d.]+))/i,
         ios : /iP[ao]d|iPhone/i,
         mac : /Mac OS/,
         chr : /CrOS/,
         android : /Android/,
         blackberry : /BlackBerry(?= ([\d.]+))/i ,
         linux : /Linux/
      },
      test:function(){
         return NS('Kompat').kompat = NS('Kompat').kompat || function(){
            var kompat = NS('Kompat').kompat = NS('Kompat').kompat || NS('Kompat')() ;
            var ua = navigator.userAgent ;
            var arr, p, version, name, os, osversion, ns, x, y;
            var namespaces = NS('Kompat').namespaces ;
            for(var s in namespaces){
               x = namespaces[s] ;
               if(arr = x.exec(ua)){
                  p = arr[0].replace('/', ' ') ;
                  version = p.replace(/[ A-Z]*/gi, '') ;
                  if(version === ''){
                  var vtest = /Version\/([\d.]+$)/ ;
                     if(vtest.test(ua)){
                        ua.replace(vtest, function($1, $2, $3){
                           version = $2 ;
                        });
                     }else version = "unknown" ;
                  }
                  name = p.replace(version, '').replace(' ', '') ;
                  ns = s ;
                  break ;
               }
            }
            kompat.ns = ns ;
            kompat.name = name ;
            kompat.version = version ;
            var workspaces = NS('Kompat').workspaces ;
            for(var w in workspaces){
               y = workspaces[w] ;
               if(y.test(ua)){
                  ua.replace(y, function($1, $2, $3){
                     if($2) osversion = $2 ;
                     os = $1 ;
                  });
                  break;
               }
            }
            if(!os) os = "unknown" ;
            if(!osversion) osversion = "unknown" ;
            kompat.os = os ;
            kompat.osversion = osversion ;
            NS('Kompat')[os] = NS('Kompat')[w] = true ;
            NS('Kompat')[ns] = NS('Kompat')[name] = true ;
            var locals = name +' '+ w ;
            
            
            document.documentElement.className = document.documentElement.className === '' ? locals : document.documentElement.className +' '+ locals ;
            return kompat ;
         }()
      }, 
      getName: function(){return NS('Kompat').kompat.name},
      getVersion: function(){return NS('Kompat').kompat.version},
      getOs: function(){return NS('Kompat').kompat.os},
      getOsVersion: function(){
         return NS('Kompat').kompat.osversion
      },
      toString:function(){
         return "[class "+this.ns +"]" ;
      }
   },
   __init__:function(){
      this.ns = '' ;
      this.name = '' ;
      this.version = '' ;
      return this ;
   },
   toString : function(){
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;
/* XLOADER */
var XLoader = NS('XLoader', NS('spill.load::XLoader', Class.$extend(function(){
   var d = document ;
   var brows, head,
   pending = {},
   pCnt = 0,
   q = {css: [], js: []},
   sheets = d.styleSheets;
   return {
      __classvars__ : {
         version:0.1,
         fileSupport:{
            'javascript':/[.]js$/i,
            'css':/[.]css$/i
         },
         detectFileExt:function(ns){
            var o = NS('XLoader').fileSupport ;
            for(var s in o){
               if(o[s].test(ns)) return s ;
            }
            throw new Error('extension is not supported folr loading...') ;
         },
         loadjscssfile:function(ns, callback){
            var file =  NS('XLoader').createjscssfile(ns) ;
            document.getElementsByTagName("head")[0].appendChild(file) ;
            
            switch(file.getAttribute('ext')){
               case 'css':
                  if(NS('Kompat').MSIE){
                     file.attachEvent("onreadystatechange", function(e){
                        file.detachEvent(e.type, arguments.callee) ;
                        var el = e ;
                        e.target = e.srcElement;
                        callback(e);
                     }) ;
                  }else if(NS('Kompat').Chrome || NS('Kompat').Safari){
                     
                  }else if (NS('Kompat').Firefox){
                     
                  }
               break;
               case 'javascript':
                  if(NS('Kompat').MSIE){
                     file.attachEvent("onreadystatechange", function(e){
                        file.detachEvent(e.type, arguments.callee) ;
                        var el = e ;
                        e.target = e.srcElement;
                        callback(e);
                     }) ;
                  }else{
                     file.onload = callback ;
                  }
               break;
            }
            return file ;
         },
         createjscssfile:function(ns){
            var ext = NS('XLoader').detectFileExt(ns) ;
            var file ;
            if (ext == 'javascript'){
               file = document.createElement('script') ;
               file.setAttribute("type","text/javascript") ;
               file.setAttribute("src", ns) ;
            }
            else if (ext == "css"){
               file = document.createElement("link") ;
               file.setAttribute("rel", "stylesheet") ;
               file.setAttribute("type", "text/css") ;
               file.setAttribute("href", ns) ;
            }
            file.setAttribute('ext', ext) ;
            return file ;
         },
         createNode:function(name, ats) {
            var n = d.createElement(name), a;
            for (a in ats) {
              if (ats.hasOwnProperty(a)) {
               n.setAttribute(a, ats[a]);
              }
            }
            return n;
         },
         finish:function(t) {
            var p = pending[t], cb, urls ;
            if (p) {
               cb = p.callback;
               urls = p.urls;
               
               urls.shift();
               pCnt = 0;
               
               if (!urls.length) {
                  cb && cb.call(p.context, p.obj);
                  pending[t] = null;
                  q[t].length && this.load(t);
               }
            }
         },
         getBrows:function () {
            if (brows) { return; }

            var ua = navigator.userAgent;

            brows = {
               async: d.createElement('script').async === true
            };

            (brows.webkit = /AppleWebKit\//.test(ua))
            || (brows.ie = /MSIE/.test(ua))
            || (brows.opera = /Opera/.test(ua))
            || (brows.gecko = /Gecko\//.test(ua))
            || (brows.unknown = true);
         },
         load:function(t, urls, cb, obj, context) {
            var _finish = function () { 
               NS('XLoader').finish(t); 
            },
            isCSS = t === 'css' ,i, l, n, p, pendingUrls, u;
            
            NS('XLoader').getBrows();

            if (urls) {
               urls = typeof urls === 'string' ? [urls] : urls.concat();
               if (isCSS || brows.async || brows.gecko || brows.opera) {
                  q[t].push({
                     urls    : urls,
                     callback: cb,
                     obj     : obj,
                     context : context
                  });
               } else {
                  for (i = 0, l = urls.length; i < l; ++i) {
                     q[t].push({
                        urls    : [urls[i]],
                        callback: i === l - 1 ? cb : null,
                        obj     : obj,
                        context : context
                     });
                  }
               }
            }

            if (pending[t] || !(p = pending[t] = q[t].shift())) return;

            head || (head = d.head || d.getElementsByTagName('head')[0]);
            pendingUrls = p.urls;

            for (i = 0, l = pendingUrls.length ; i < l ; ++i) {
               u = pendingUrls[i];

               if (isCSS) {
                  n = brows.gecko ? NS('XLoader').createNode('style') : NS('XLoader').createNode('link', {
                     href: u,
                     rel : 'stylesheet'
                  });
               } else {
                  n = NS('XLoader').createNode('script', {src: u});
                  n.async = false;
               }

               n.className = 'xload';
               n.setAttribute('charset', 'utf-8');
               n.setAttribute('source', u) ;
               if (brows.ie && !isCSS) {
                  n.onreadystatechange = function () {
                     if (/loaded|complete/.test(n.readyState)) {
                        n.onreadystatechange = null;
                        _finish();
                     }
                  };
               } else if (isCSS && (brows.gecko || brows.webkit)) {
                  if (brows.webkit) {
                     p.urls[i] = n.href;
                     NS('XLoader').pWebKit();
                  } else {
                     n.innerHTML = '@import "' + u + '";';
                     NS('XLoader').pGecko(n);
                  }
               } else {
                  n.onload = n.onerror = _finish;
               }
               head.appendChild(n);
            }
         },
         pGecko: function (n) {
            try {
               n.sheet.cssRules;
            } catch (ex) {
               pCnt += 1;

               if (pCnt < 200) {
                  setTimeout(function () { NS('XLoader').pGecko(n); }, 50);
               } else {
                  NS('XLoader').finish('css');
               }

               return;
            }
            NS('XLoader').finish('css');
         },
         pWebKit: function() {
            var css = pending.css, i;

            if (css) {
               i = sheets.length;
               while (i && --i) {
                  if (sheets[i].href === css.urls[0]) {
                     NS('XLoader').finish('css');
                     break;
                  }
               }

               pCnt += 1;

               if (css) {
                  if (pCnt < 50) {
                     setTimeout(NS('XLoader').pWebKit, 50);
                  } else {
                     NS('XLoader').finish('css');
                  }
               }
            }
         },
         css: function (urls, callback, obj, context) {
            NS('XLoader').load('css', urls, callback, obj, context);
         },
         js: function (urls, callback, obj, context) {
            NS('XLoader').load('js', urls, callback, obj, context);
         },
         toString:function(){
            return "[class "+this.ns+"]" ;
         }
      },
      init:function(){
         return this ;
      }
   } // END OF OBJECT
}()))) ;
/* NET */
var Request = NS('Request', NS('spill.net::Request', Class.$extend({
   __classvars__ : {
      version:'0.0.2',
      namespaces : [
         function () {return new XMLHttpRequest()},
         function () {return new ActiveXObject("Msxml2.XMLHTTP")},
         function () {return new ActiveXObject("Msxml3.XMLHTTP")},
         function () {return new ActiveXObject("Microsoft.XMLHTTP")}
      ],
      generateXHR:function () {
         var xhttp = false;
         var bank = NS('spill.net::Request').namespaces ;
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
      },
      toString:function(){
         return '[class Request]' ;
      }
   },
   __init__ : function(url, complete, postData) {
      var r = this.__classvars__.generateXHR();    
      if (!r) return;
      this.request = r ;
      this.url = url ;
      this.complete = complete ;
      this.userData = {
         post_data:postData,
         post_method:postData ? "POST" : "GET",
         ua_header:{ua:'User-Agent',ns:'XMLHTTP/1.0'},
         post_data_header: postData !== undefined ? {content_type:'Content-type',ns:'application/x-www-form-urlencoded'} : undefined 
      } ;
   },
   load : function(url){
      var r = this.request ;
      var th = this ;
      var ud = this.userData ;
      var complete = this.complete ;
      r.open(ud['post_method'] , url || this.url, true);
      r.setRequestHeader(ud['ua_header']['ua'],ud['ua_header']['ns']);
      if (ud['post_data_header'] !== undefined) r.setRequestHeader(ud['post_data_header']['content_type'],ud['post_data_header']['ns']);
      r.onreadystatechange = function () {
         if (r.readyState != 4) return;
         if (r.status != 200 && r.status != 304) {
            return;
         }
         th.complete(r, th);
      }
      if (r.readyState == 4) return ;
      r.send(ud['postData']);
      return this ;
   },
   destroy : function(){
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
   },
   toString : function(){
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;

/* EVENTS */
var EventDispatcher = NS('EventDispatcher', NS('spill.event::EventDispatcher', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        dependancies:[jQuery],
        toString:function()
        {
            return '[class EventDispatcher]' ;
        }
    },
    __init__:function(el)
    {
        this.setDispatcher(el || this) ;
    },
    setDispatcher:function(el) // @return void
    {
        this.dispatcher = $(el) ;
    },
    hasEL:function(type) // @return Boolean
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
        if(this.dispatcher !== undefined)
        this.dispatcher.bind(type, closure) ;
    },
    removeEL:function(type, closure) // @return Boolean
    {
        if(this.dispatcher !== undefined)
        this.dispatcher.unbind(type, closure) ;
    },
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;

/* COMMANDS */
var Command = NS('Command', NS('spill.command::Command', EventDispatcher.$extend({
   __classvars__ : {
      version:'0.0.2',
      toString:function(){
         return '[class Command]' ;
      }
   },
   __init__ : function(thisObj, closure, params) {
      
      this.setDispatcher(this) ;
      
      var args = [].slice.call(arguments) ;
      this.context = args.shift() ;
      this.closure = args.shift() ;
      this.params = args ;
      this.depth = '$' ;
      
      return this ;
      
   },
   execute : function(){
      var r = this.closure.apply(this, [].concat(this.params)) ;
      if(r !== null && r !== undefined) {
         if(r !== this) this.setDispatcher(this) ;
         return this ;
      }
   },
   cancel:function(){ // @return Command
       trace('cancelling') ;
        return this.destroy() ;
    },
   dispatchComplete : function(){
      this.dispatch(this.depth) ;
   },
   destroy : function(){
       
      this.params =
      this.context =
      this.closure =
      this.depth =
      this.dispatcher =
      
      undefined ;
      
      delete this.params ;
      delete this.context ;
      delete this.closure ;
      delete this.depth ;
      delete this.dispatcher ;
      
      return undefined ;
   },
   toString : function(){
      return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
   }
}))) ;

var CommandQueue = NS('CommandQueue', NS('spill.command::CommandQueue', Command.$extend({
   __classvars__ : {
      version:'0.0.2',
      toString:function(){
         return '[class CommandQueue]' ;
      }
   },
   __init__ : function() {
       
        this.setDispatcher(this) ;

       
      this.commands = [] ;
      this.commandIndex = -1 ;
      this.depth = '$' ;
      
      var cq = this ;
      
      this.add = function(){
         var args = arguments ;
         var l = args.length ;
         switch(l)
         {
            case 0:
               throw new Error('cannot add an null object, ...commandQueue') ;
            break;
            case 1:
               var arg = args[0] ;
               var isCommand = arg instanceof Command ;
               if(isCommand){
                   cq.commands[cq.commands.length] = arg ;
               }else{ // must be an array of commands
                   if(0 in arg) arguments.callee.apply(null, arg) ;
               }
            break;
            default :
               for(var i = 0 ; i < l ; i++ ){
                  arguments.callee(args[i]) ;
               }
            break;
         }
         
      }
      
      if(arguments.length > 0 ) this.add(arguments[0]) ;
      
      return this ;
   },
   reset : function(){
      if(this.commands !== undefined){
         var commands = this.commands ;
         var l = commands.length ;
         while (l--) {
            var comm = commands[l];
            if(comm instanceof CommandQueue) comm.commandIndex = -1 ;
         }
      }
      this.commandIndex = -1 ;
      return this ;
   },
    cancel:function(){ // @return Command
        return this.destroy() ;
    },
   next : function(){
      var cq = this ;
      var ind = this.commandIndex ;
      ind ++ ;
      
      var c = this.commands[ind] ;
      if(c === undefined){
         trace('commandQueue did not found command and will return, since command stack is empty...') ;
         setTimeout(function(){cq.dispatchComplete()}, 0) ; 
         return this ;
      }
      
      c.depth = this.depth + '$' ;
      
      var r = c.execute() ;
      
      if(r === undefined || r === null){
         this.commandIndex = ind ;
         if(ind == this.commands.length - 1){
            this.dispatchComplete() ;
         }else{
            this.next() ;
         }
      }else{
         var type = c.depth ;
         r.addEL(type, function(){
            r.removeEL(type, arguments.callee) ;
            cq.commandIndex = ind ;
            if(ind == cq.commands.length - 1){
               cq.dispatchComplete() ;
            }else{
               cq.next() ;
            }
         })
      }           
      
      return this ;
   },
   execute : function(){
      return this.next() ;
   },
   destroy : function(){
       
      if(this.commands !== undefined){
         var commands = this.commands ;
         var l = commands.length ;
         while (l--) {
            commands.pop().destroy() ;
         }
         this.commands = this.commandIndex = undefined ;
         delete this.commands ;
         delete this.commandIndex ;
      }
      
      this.next =
      this.add =
      this.dispatcher =
      this.depth =
      
      undefined ;
      
      delete this.next ;
      delete this.add ;
      delete this.dispatcher ;
      delete this.depth ;
      
      return undefined ;
   },
   toString : function(){
      return '[ object CommandQueue ]';
   }
}))) ;

var WaitCommand = NS('WaitCommand', NS('spill.command::WaitCommand', Command.$extend({
   __classvars__ : {
      version:'0.0.1',
      toString:function(){
         return '[class WaitCommand]' ;
      }
   },
   __init__ : function(time, initclosure) {
       this.setDispatcher(this) ;
       
      this.time = time ;
      this.depth = '$' ;
      this.uid = -1 ;
      this.initclosure = initclosure ;
      
      return this ;
   },
   execute : function(){
      var w = this ;
      
      if(w.initclosure !== undefined) {
      	
      	var co = new Command(w, w.initclosure) ;
      	var o = co.execute() ;
      	
      	if(o !== undefined){
      		
      		co.addEL('$', function(e){
      			co.removeEL('$', arguments.callee) ;
      			
      			this.uid = setTimeout(function(){
			    	w.dispatchComplete() ;
			    	this.uid = -1 ;
			    }, this.time) ;
      		}) ;
      		
      		
      	}else{
      		this.uid = setTimeout(function(){
		    	w.dispatchComplete() ;
		    	this.uid = -1 ;
		    }, this.time) ;
      	}
      	
      }else{
      	this.uid = setTimeout(function(){
	    	w.dispatchComplete() ;
	    	this.uid = -1 ;
	    }, this.time) ;
      }
      
      
      return this ;
   },
   destroy : function(){
      
      if(this.uid !== -1){
         clearTimeout(this.uid) ;
         this.uid = -1 ;
      }
      this.uid =
      this.time =
      this.depth =
      undefined ;
      delete this.uid ;
      delete this.time ;
      delete this.depth ;
      return undefined ;
   },
   toString : function(){
      return '[ object WaitCommand ]';
   }
}))) ;

var AjaxCommand = NS('AjaxCommand', NS('spill.commands::AjaxCommand', Command.$extend({
   __classvars__ : {
      version:'0.0.2',
      toString:function(){
         return '[class AjaxCommand]' ;
      }
   },
   __init__ : function(url, success, postData, init) {
      if(postData === null) postData = undefined ;
       this.setDispatcher(this) ;
       
      this.url = url ;
      this.success = success ;
      this.postData = postData ;
      this.depth = '$' ;
      
      
      this.initclosure = init ;
      
      return this ;
   },
   execute : function(){
      var w = this ;
        if(w.request !== undefined) return w.success.apply(w, [w.jxhr, w.request]) ;
      w.request = new Request(w.url, function(jxhr, r){
         w.jxhr = jxhr ;
         w.success.apply(w, [jxhr, r]) ;
      }, w.postData) ;
      
      if(w.initclosure !== undefined) w.initclosure.apply(w, [w.request]) ;
      if(w.toCancel !== undefined) {
          setTimeout(function(){
              w.dispatchComplete() ;
          }, 10) ;
          return w;
      }
      setTimeout(function(){w.request.load()}, 0) ;
      return this ;
   },
   destroy : function(){
      if(this.request) this.request.destroy() ;
      
      this.request =
      this.success =
      this.jxhr =
      this.url =
      this.postData =
      this.depth =
      this.dispatcher =
      
      undefined ;
      
      delete this.request ;
      delete this.success ;
      delete this.jxhr ;
      delete this.url ;
      delete this.postData ;
      delete this.depth ;
      delete this.dispatcher ;
      
      return undefined ;
   },
   toString : function(){
      return '[ object AjaxCommand > ' + this.url + ' ]';
   }
}))) ;

/* LOOP */
var Loop = NS('Loop', NS('naja.collection::Loop', Class.$extend({
    __classvars__:{version:'0.0.1',
        toString:function()
        {
            return '[class Loop]' ;
        }
    },
    __init__:function()
    {
        var loopables = this.loopables =  [] ;
        var playhead = this.playhead = -1 ;
    },
    add:function(c)
    {
        var loopables = this.loopables ;
        var what = Object.prototype.toString ;
        if(c[0] !== undefined && c[0] instanceof CommandQueue){
            
            var l = c.length ;
            
            for(var i = 0 ; i < l ; i++){
                loopables[loopables.length] = c[i] ;
            }
        }else{
            loopables[loopables.length] = c ;
        }
    },
    launch:function(n, force)
    {
        var lp = this;
        var loopables = lp.loopables, playhead = lp.playhead ;
		
		
		
        if(loopables[n] === undefined) throw 'error finding the right commandqueue';
        if(n == lp.playhead && force !== true) return ;
        
        lp.index = n ;
        var cq = loopables[n] ;
        
        
    	$(cq).bind('$', function(e){
            $(cq).unbind('$', arguments.callee) ;
            lp.playhead = n ;
            cq = cq.reset() ;
        }) ;
        
        return cq.execute() ;
    },
    prev:function()
    {
        return this.launch(this.getPrevIndex()) ;
    },
    getPrevIndex:function(num) // enter as -1, -2, -3
    {
        var lp = this;
        var l = lp.loopables.length ;
        var n = num !== undefined ? lp.playhead + num : lp.playhead - 1 ;
        
        if(n < 0) n = n + l ;
        return n ;
    },
    next:function()
    {
        return this.launch(this.getNextIndex()) ;
    },
    getNextIndex:function(num)
    {
        var lp = this;
        var l = lp.loopables.length ;
        var n = num !== undefined ? lp.playhead + num : lp.playhead + 1 ;
        
        if(n > l - 1) n = n - l ;
        return n ;
    },
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
})));

/* STEP */
var Step = NS('Step', NS('spill.step::Step', EventDispatcher.$extend({
    __classvars__:{
        version:'0.0.1',
        dependancies:[Command, EventDispatcher], // Command-type classes
        // STATIC VARS
        hierarchies:{},
        getHierarchies:function (){ return Step.hierarchies },
        // STATIC CONSTANTS
        SEPARATOR:'/',
        STATE_OPENED:"opened",
        STATE_CLOSED:"closed",
        
        toString:function()
        {
            return '[class Step]' ;
        }
    },
    commandOpen:undefined,
    commandClose:undefined,
    id:'',
    path:'',
    depth:NaN,
    index:NaN,
    parentStep:undefined,
    ancestor:undefined,
    hierarchyLinked:false,
    children:[],
    opened:false,
    opening:false,
    closing:false,
    playhead:NaN,
    looping:false,
    isFinal:false,
    way:'forward',
    state:'',
    userData:undefined,
    loaded:false,
    
    // CTOR
    __init__:function(id, commandOpen, commandClose)
    {
        this.$super() ;
        this.id = id ;
        this.commandOpen = commandOpen ;
        this.commandClose = commandClose ;
        this.children = [] ;
        this.alphachildren = [] ;
        this.depth = 0 ;
        this.index = -1 ;
        this.playhead = -1 ;
        this.userData = { } ;
        this.isFinal = false ;
    },
    reload:function(){
    	var st = this ;
    	var c = st.commandClose ;
    	
    	
    	c.addEL('$', function(e){
    		c.removeEL('$', arguments.callee) ;
    		
    		
    		s.open() ;
    		
    	}) ;
    	
    	
    	st.close() ;
    },
    // STEP FUNCTIONNAL
    //  OPEN, CLOSE
    //  CHECKINGS AND DISPATCHES
    open:function()
    {
        var st = this ;
        
        if( st.opened && !st.closing) throw new Error('currently trying to open an already-opened step ' + st.path + ' ...')
        st.opening = true ;
        
        if (st.isOpenable()) {
            var o = st.commandOpen.execute() ;
            if (!!o){
                if(!o instanceof EventDispatcher) throw new Error('supposed-to-be eventDispatcher is not one...', o) ;
                o.addEL(st.commandOpen.depth, function(e){
                    o.removeEL(st.commandOpen.depth, arguments.callee) ;
                    st.checkOpenNDispatch() ;
                }) ;
            }else st.checkOpenNDispatch() ;
        }else st.checkOpenNDispatch() ;
    },
    close:function()
    {
        var st = this ;
        if ( !st.opened && !st.opening) throw new Error('currently trying to close a non-opened step ' + st.path + ' ...')
        st.closing = true ;
        
        if (st.isCloseable()) {
            var o = st.commandClose.execute() ;
            if (!!o) {
                 if(!o instanceof EventDispatcher) throw new Error('supposed-to-be eventDispatcher is not one...', o) ;
                 o.addEL(st.commandClose.depth, function(e){
                    e.target.removeEL(st.commandClose.depth, arguments.callee) ;
                    st.checkCloseNDispatch() ;
                 }) ;
            }else st.checkCloseNDispatch() ;
        }else st.checkCloseNDispatch() ;
    },
    checkOpenNDispatch:function(){ this.opened = true ; this.opening = false ; if (this.hasEL('step_open')) this.dispatchOpen() }, 
    checkCloseNDispatch:function(){ this.opened = false ; this.closing = false ; if (this.hasEL('step_close')) this.dispatchClose() },
    dispatchOpen:function(){ this.dispatch('step_open') },
    dispatchClose:function(){ this.dispatch('step_close') },
    dispatchOpenComplete:function(){ this.dispatch(this.commandOpen.depth) },
    dispatchCloseComplete:function(){ this.dispatch(this.commandClose.depth) },
    dispatchFocusIn:function(){ if(this.hasEL('focusIn')) this.dispatch('focusIn') },
    dispatchFocusOut:function(){ if(this.hasEL('focusOut')) this.dispatch('focusOut') },
    dispatchClearedIn:function(){ if(this.hasEL('focusClearedIn')) this.dispatch('focusClearedIn') },
    dispatchClearedOut:function(){ if(this.hasEL('focusClearedOut')) this.dispatch('focusClearedOut') },
    
    // DATA DESTROY HANDLING
        
    destroy:function()
    {
        var st = this ;
        if (st.parentStep instanceof Step && st.parentStep.hasChild(st)) st.parentStep.remove(st) ;
        
        if (st.isOpenable) st.commandOpen = st.destroyCommand(st.commandOpen) ;
        if (st.isCloseable) st.commandClose = st.destroyCommand(st.commandClose) ;
        
        if (st.userData !== undefined) st.userData = st.destroyObj(st.userData) ;
        
        if (st.children.length != 0) st.children = st.destroyChildren() ;
        if (st.ancestor instanceof Step && st.ancestor == st) {
            if (st.id in Step.hierarchies) st.unregisterAsAncestor() ;
        }
        
        st.id = undefined ;
        st.parentStep = undefined ;
        st.ancestor = undefined ;
        st.depth = 0 ;
        st.index = -1 ;
        st.path = undefined ;
        return null ;
    },
    destroyCommand:function(c){ return c.destroy() },
    destroyChildren:function(){ if (this.getLength() > 0) this.empty(true) ; return undefined },
    destroyObj:function(o)
    {
        for (var s in o) {
            o[s] = undefined ;
            delete o[s] ;
        }
        return undefined ;
    },
    
    setId:function(value){ this.id = value },
    getId:function(){ return this.id},
    getIndex:function(){ return this.index},
    getPath:function(){ return this.path },
    getDepth:function(){ return this.depth },
    // OPEN/CLOSE-TYPE (SELF) CONTROLS
    isOpenable:function(){ return this.commandOpen instanceof Command},
    isCloseable:function(){ return this.commandClose instanceof Command},
    getCommandOpen:function(){ return this.commandOpen },
    setCommandOpen:function(value){ this.commandOpen = value },
    getCommandClose:function(){ return this.commandClose },
    setCommandClose:function(value){ this.commandClose = value },
    getOpening:function(){ return this.opening },
    getClosing:function(){ return this.closing },
    getOpened:function(){ return this.opened },
    // CHILD/PARENT REFLECT
    getParentStep:function(){ return this.parentStep },
    getAncestor:function(){ return (this.ancestor instanceof Step)? this.ancestor : this },
    getChildren:function(){ return this.children },
    getNumChildren:function(){ return this.children.length },
    getLength:function(){ return this.getNumChildren() },
    //HIERARCHY REFLECT
    getHierarchies:function(){ return Step.hierarchies},
    getHierarchy:function(){ return Step.hierarchies[id] },
    
    // PLAY-TYPE (CHILDREN) CONTROLS
    getPlayhead:function(){ return this.playhead },
    getLooping:function(){ return this.looping },
    setLooping:function(value){ this.looping = value },
    getWay:function(){ return this.way },
    setWay:function(value){ this.way = value },
    getState:function(){ return this.state },
    setState:function(value){ this.state = value },
    // USER DATA
    getUserData:function(){ return this.userData },
    setUserData:function(value){ this.userData = value },
    
    getLoaded:function(){ return this.loaded },
    setLoaded:function(value){ this.loaded = value },
    getIsFinal:function(){ return this.isFinal },
    setIsFinal:function(value){ this.isFinal = value },
    
    // CHILDREN HANDLING
    //  GETCHILD
    //  HASCHILD
    //  ADD, REMOVE
    //  EMPTY
    
    hasChild:function(ref){
        if(ref instanceof Step)
        return this.children.indexOf(child) != -1 ;
        else if (typeof(ref) === 'string') return ref in this.alphachildren ;
        else return ref in this.children() ;
    },
    getChild:function(ref) // returns Step
    {
        var st = this ;
        if(ref === undefined) ref = null ;
        var child ;
        if (ref == null)  // REF IS NOT DEFINED
            child = st.children[st.children.length - 1] ;
        else if (ref instanceof Step) { // HERE REF IS A STEP OBJECT
            child = ref ;
            if (!st.hasChild(child)) throw new Error('step "'+child.id+'" is not a child of step "'+st.id+'"...') ;
        }else if (typeof(ref) === 'string') { // is STRING ID
            child = st.alphachildren[ref]   ;
        }else { // is INT ID
            if(ref == -1) child = st.children[st.children.length - 1] ;
            else child = st.children[ref] ;
        }
        if (! child instanceof Step)  throw new Error('step "' + ref + '" was not found in step "' + st.id + '"...') ;
        
        return child ;
    },
    add:function(child, childId) // returns Step
    {
        var st = this ;
        if(childId === undefined) childId = null ;
        var l = st.children.length ;
        
        if (!!childId) {
            child.id = childId ;
        }else {
            if(child.id === undefined) 
            child.id = l ;
            else {
                childId = child.id ;
            }
        }
        st.children[l] = child ; // write L numeric entry
        
        
        if (typeof(childId) === 'string') { // write Name STRING Entry
            st.alphachildren[childId] = child ;
        }
        return st.register(child) ;
    },
    remove:function(ref) // returns Step
    {
        var st = this ;
        if(ref === undefined) ref = -1 ;
        var child = st.getChild(ref) ;
        var n = st.children.indexOf(child) ;
        if (typeof(child.id) === 'string'){
            st.alphachildren[child.id] = null ;
            delete st.alphachildren[child.id] ;
        }
        
        st.children.splice(n, 1) ;
        if (st.playhead == n) st.playhead -- ;
        
        return st.unregister(child) ;
    },
    empty:function(destroyChildren) // returns void
    {
        if(destroyChildren === undefined) destroyChildren = true ;
        var l = this.getLength() ;
        while (l--) destroyChildren ? this.remove().destroy() : this.remove() ;
    },
    
    // REGISTRATION HANDLING + ANCESTOR GENEALOGY
    register:function(child, cond) // returns Step
    {
        var st = this , ancestor;
        if(cond === undefined) cond = true ;
        
        if (cond) {
            child.index = st.children.length - 1 ;
            child.parentStep = st ;
            child.depth = st.depth + 1 ;
            ancestor = child.ancestor = st.getAncestor() ;
            child.path = (st.path !== undefined ? st.path : st.id ) + Step.SEPARATOR + child.id ;
            
            if(child.label !== undefined) child.labelPath = (st.labelPath !== undefined ? st.labelPath : st.path ) + Step.SEPARATOR + child.label ;
            if (Step.hierarchies[ancestor.id] !== undefined) {
                Step.hierarchies[ancestor.id][child.path] = child ;
                if(child.label !== undefined) Step.hierarchies[ancestor.id][child.labelPath] = child ;
            }
            
        }else {
            ancestor = child.ancestor ;
            
            
            if (Step.hierarchies[ancestor.id] !== undefined) {
                Step.hierarchies[ancestor.id][child.path] = undefined ;
                delete Step.hierarchies[ancestor.id][child.path] ;
                if(child.label !== undefined) {
                    Step.hierarchies[ancestor.id][child.labelPath] = undefined ;
                    delete Step.hierarchies[ancestor.id][child.labelPath] ;
                }
            }
            
            child.index = - 1 ;
            child.parentStep = undefined ;
            child.ancestor = undefined ;
            child.depth = 0 ;
            child.path = undefined ;
        }
        return child ;
    },
    unregister:function(child) // returns Step
    { return this.register(child, false) },
    registerAsAncestor:function(cond)// returns Step
    {
        var st = this ;
        if (cond === undefined) cond = true ;
        if (cond) {
            Step.hierarchies[st.id] = { } ;
            st.ancestor = st ;
        }else {
            if (st.id in Step.hierarchies) {
                Step.hierarchies[st.id] = null ;
                delete Step.hierarchies[st.id] ;
            }
            st.ancestor = null ;
        }
        return st ;
    },
    unregisterAsAncestor:function(){ 
       return this.registerAsAncestor(false) 
    },
    linkHierarchy:function(h){
       this.hierarchyLinked = true ;
       this.hierarchy = h ;
       return this ;
    },
    unlinkHierarchy:function(h){
       this.hierarchyLinked = false ;
       this.hierarchy = undefined ;
       delete this.hierarchy ;
       return this ;
    },
    // PLAYHEAD HANDLING
    play:function(ref) //returns int
    {
        var st = this ;
        if(ref === undefined) ref = '$$playhead' ;
        var child ;
        if (ref == '$$playhead') {
            child = st.getChild(st.playhead) ;
        }else {
            child = st.getChild(ref) ;
        }
                
        var n = st.children.indexOf(child) ;
        
        if (n == st.playhead) {
            if(n == -1){ 
                trace('requested step "' + ref + '" is not child of parent... '+st.path) ;
            }else{
                trace('requested step "' + ref + '" is already opened... '+st.path) ;
            }
            
            return n ;
        }else {
            var curChild = st.children[st.playhead] ;
            if (!(curChild instanceof Step)) {
                st.playhead = n ;
                child.open() ;
            }else {
                if (curChild.opened) {
                    curChild.addEL('step_close', function(e){
                        e.target.removeEL(e, arguments.callee) ;
                        child.open() ;
                        st.playhead = n ;
                    }) ;
                    curChild.close() ;
                }else {
                    child.open() ;
                    st.playhead = n ;
                }
            }
        }
        return n ;
    },
    
    kill:function(ref) // returns int 
    {
        var st = this ;
        if(ref === undefined) ref = '$$current' ;
        
        var child;
        if (st.playhead == -1) return st.playhead ;
        
        if (ref == '$$current') {
            child = st.getChild(st.playhead) ;
        }else {
            child = st.getChild(ref) ;
        }
        var n = st.children.indexOf(child) ;
        
        child.close() ;
        st.playhead = -1 ;
        return n ;
    },
    // ORIENTATION INSIDE STEP CHILDREN
    //  NEXT PREV, 
    //  GETTERS AND CHECKERS
    
    next:function() // returns int
    {
        this.way = 'forward' ;
        if (this.hasNext()) return this.play(this.getNext()) ;
        else return -1 ;
    },
    prev:function() // returns int
    {
        this.way = 'backward' ;
        if (this.hasPrev()) return this.play(this.getPrev()) ;
        else return -1 ;
    },
    getNext:function() // returns Step
    {
        var s = this.children[this.playhead + 1] ;
        return this.looping ? s instanceof Step ? s : this.children[0] : s ;
    },
    getPrev:function() // returns Step
    {
        var s = this.children[this.playhead - 1] ;
        return this.looping? s instanceof Step ? s : this.children[this.getLength() - 1] : s ;
    },
    hasNext:function()// returns Boolean 
    { return this.getNext() ?  true : this.looping },
    hasPrev:function()// returns Boolean 
    { return this.getPrev() ?  true : this.looping },
    
    dumpChildren:function(str) // returns String
    {
        if(str === undefined) str = '' ;
        var chain = '                                                                            ' ;
        this.children.forEach(function(el, i, arr){
            str += chain.slice(0, el.depth) ;
            str += el ;
            if(parseInt(i+1) in arr) str += '\n' ;
        })
        return str ;
    },
    
    // TO STRING
    toString:function()
    {
        var st = this ;
        return '[Step >>> id:'+ st.id+' , path: '+st.path + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
    }
}))) ;

var Address = NS('Address', NS('naja.net::Address', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class Address]' ;
        }
    },
    __init__:function(str)
    {
        var u = this ;
        u.absolute = str ;
        
        u.path = str.replace(/^(((http|ftp)s?:)\/\/([\w\d.-]+(:(\d+))?))?\/(([a-z0-9-]{3,}\/)*)?([#]\/|)?([a-z\/]{2}\/)?([^?]*)([?].+)?$/i, function(){
           var $$ = [].slice.call(arguments) ;

           u.base = $$[1] || '' ;
           u.protocol = $$[3] || '' ;
           u.host = $$[4] || '' ;
           u.port = $$[6] || '' ;
           u.root = $$[7] || '' ;
           
           u.qs = $$[12] || '' ;
           u.loc = $$[10] || '';
           u.hash = $$[9] || '';
           
           return $$[11] || '' ;
        }) ;
    },
    toString:function()
    {
        var st = this ;
        return this.absolute ;
    }
}))) ;

var HierarchyChanger =  NS('HierarchyChanger', NS('spill.step::HierarchyChanger', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        dependancies:[Hierarchy],
        DEFAULT_PREFIX:'#' ,
        SEPARATOR:Step.SEPARATOR ,
        __re_doubleSeparator:/(\/){2,}/ ,
        __re_qs:/\?.*$/ ,
        __re_path:/^[^?]+/ ,
        __re_endSlash:/\/$/ ,
        __re_startSlash:/^\// ,
        __re_hash:/^\/#\// ,
        toString:function()
        {
            return '[class HierarchyChanger]' ;
        }
    },
    __hierarchy:undefined,
    __value:'',
    __currentPath:'',
    __home:'',
    __temporaryPath:undefined,
    __futurePath:'',    
    __init__:function()
    {
        ///
        trace(this.__value)
    },
    setFuturePath:function(path) 
    {
        this.__futurePath = path ;
    },
    setHierarchy:function(val){ this.__hierarchy = val },
    getHierarchy:function(){ return this.__hierarchy },
    setHome:function(val){ this.__home = val.replace(HierarchyChanger.__re_endSlash, '') },
    getHome:function(){ return this.__home = __home.replace(HierarchyChanger.__re_endSlash, '') },
    getValue:function(){ return this.__value = this.__value.replace(HierarchyChanger.__re_endSlash, '') },
    setValue:function(newVal){ this.hierarchy.redistribute(this.__value = newVal.replace(HierarchyChanger.__re_endSlash, '')) },
    getCurrentPath:function(){ return this.__currentPath = this.__currentPath.replace(HierarchyChanger.__re_endSlash, '') },
    setCurrentPath:function(val){ this.__currentPath = val.replace(HierarchyChanger.__re_endSlash, '')  },
    getFuturePath:function(){ return this.__futurePath = this.__futurePath.replace(HierarchyChanger.__re_endSlash, '') },
    getAvailable:function(){ return true },
    getTemporaryPath:function(){ return (this.__temporaryPath !== undefined) ? this.__temporaryPath = this.__temporaryPath.replace(HierarchyChanger.__re_endSlash, '') : undefined },
    setTemporaryPath:function(value){ this.__temporaryPath = value },
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;

var Hierarchy =  NS('Hierarchy', NS('spill.step::Hierarchy', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        dependancies:[Step, EventDispatcher, Command, CommandQueue, HierarchyChanger],
        // STATIC CONSTANTS
        toString:function()
        {
            return '[class Hierarchy]' ;
        }
    },
    idTimeout:-1 ,
    idTimeoutFocus:-1 ,
    idTimeoutFocusParent:-1 ,
    root:undefined , // Step
    currentStep:undefined , // Step
    changer:undefined ,// HierarchyChanger;
    exPath:'',
    command:undefined ,// Command;
    // CTOR
    __init__:function()
    {
        //
    },
    setAncestor:function(s, changer)
    {
        var hh = this ;
        hh.root = s ;
        hh.root.registerAsAncestor() ;
        hh.root.linkHierarchy(this) ;
        
        hh.currentStep = hh.root ;
        
        hh.changer = changer || new HierarchyChanger() ;
        hh.changer.hierarchy = hh ;
        
        return s ;
    },
    add:function(step, at)
    {
        return (typeof at === 'string') ?  this.getDeep(at).add(step) : this.root.add(step) ;
    },
    remove:function(id, at)
    {
        return (typeof at === 'string') ? this.getDeep(at).remove(id) : this.root.remove(id) ;
    },
    getDeep:function(path)
    {
        var h = Step.hierarchies[this.root.id] ;
        return (path === this.root.id) ? this.root : h[HierarchyChanger.__re_startSlash.test(path)? path : HierarchyChanger.SEPARATOR + path] ;
    },
    getDeepAt:function(referenceHierarchy, path)
    {
        return Step.hierarchies[referenceHierarchy][path] ;
    },
    redistribute:function(path)
    {
        if (this.isStillRunning()) {
            this.changer.setTemporaryPath(path) ;
            return ;
        }else {
            this.changer.setTemporaryPath(undefined) ;
            this.launchDeep(path) ;
        }
    },
    launchDeep:function(path) 
    {
        var hh = this ;
        
        if (path == hh.changer.getCurrentPath()) return ;
        
        
        // ici que l'on doit changer qqch
        hh.command = new CommandQueue(hh.formulate(path)) ;
        
        

        if(hh.command === undefined) {
           trace('consider nothing has happened') ;
           return ;
        }
        
        hh.command.addEL('$', hh.onCommandComplete) ;
        hh.command.caller = hh ;
        
        if (hh.currentStep.hasEL('focusOut')) {
            hh.currentStep.dispatchFocusOut() ;
            hh.currentStep.addEL('focusClearedOut', function(e) {
                hh.currentStep.removeEL('focusClearedOut', arguments.callee) ;
                hh.command.execute() ;
            })
        }else {
            hh.command.execute() ;
        }
    },
    onCommandComplete:function(e)
    {
        
        var hh = this.caller ;
        hh.command.removeEL('$', arguments.callee) ;
        if(hh.root.addressComplete !== undefined && typeof(hh.root.addressComplete) == "function")
        hh.root.addressComplete(e) ;
        hh.clear() ;
    },
    clear:function()
    {
        var hh = this ;
        
        if(hh.command instanceof Command) hh.command = hh.command.cancel() ;
        //clearTimeout(hh.idTimeoutParent) ;
        clearTimeout(hh.idTimeout) ;
    },
    formulate:function(path)
    {
        var hh = this ;
        trace('formulating >> '+path) ;
        var commands = [] ;
        var command ;
        
        if(hh.command === undefined) {
           hh.changer.setFuturePath(path) ;
        }
        
        var cur = hh.currentStep ;
        var single ;
        var checking = true ;
        var absolute = HierarchyChanger.SEPARATOR + path ;
        
        if(cur !== cur.ancestor){ // forced to be else than root
           command = hh.createCommandClose(cur.path) ;
        }
        
        // checking for addables
        var l = cur.getLength() ;
        for(var i  = 0 ; i < l ; i++){
           var child = cur.getChild(i) ;
           
           var presence_re = new RegExp("^"+child.path) ;
           
           if(presence_re.test(absolute)){
              absolute.replace(presence_re, function($0){
                 single = $0 ;
                 return '' ;
              })
              command = hh.createCommandOpen(single) ;
              break ;
           }
        }
        
        if(command === undefined){
           hh.clear() ;
           throw new Error('No step was actually found with path ' + path) ;
        }
        return command ;
    },
    createCommandOpen:function(path)
    {
        var c = new Command(this, this.openCommand) ;
        c.params = [path, c] ;
        return c ;
    },
    openCommand:function(path, c)
    {
        var hh = c.context ;
        var st = hh.getDeep(path) ;
        clearTimeout(hh.idTimeoutFocus) ;

        st.addEL('step_open', function(e){
            st.removeEL('step_open', arguments.callee) ;
            hh.changer.setCurrentPath(path) ;
            
            var val = hh.changer.getValue() ;
            var cur = hh.changer.getCurrentPath().replace(/^\//i, '') ;
            var future = hh.changer.getFuturePath() ;
            
            hh.currentStep = st ;
            hh.currentStep.state = Step.STATE_OPENED ;
            
            if(cur === future){
            	hh.idTimeoutFocus = setTimeout(function() {
                    hh.currentStep.dispatchFocusIn() ;
                }, 20) ;
            }else{
            	
            	if(hh.isStillRunning()){
            		hh.command.add(hh.formulate(future)) ;
            	}else{
            		hh.redistribute(future) ;
            	}
            	
            }
            c.dispatchComplete() ;
        }) ;
        
        st.parentStep.play(st.id) ;
        
        return st ;
    },
    createCommandClose:function(path)
    {
        var c = new Command(this, this.closeCommand) ;
        c.params = [path, c] ;
        return c ;
    },
    closeCommand:function(path, c)
    {
        var hh = c.context ;
        var st = hh.getDeep(path) ;
        
        clearTimeout(hh.idTimeoutFocusParent) ;
        
        st.addEL('step_close', function(e){
            st.removeEL('step_close', arguments.callee) ;
            st.state = Step.STATE_CLOSED ;
            
            hh.changer.setCurrentPath(st.parentStep.path) ;
            
            var val = hh.changer.getValue() ;
            var cur = hh.changer.getCurrentPath().replace(/^\//i, '') ; ;
            var future = hh.changer.getFuturePath() ;
            
            hh.currentStep = st.parentStep ;
            
            
            if(cur === future){
            	hh.idTimeoutFocusParent = setTimeout(function() {
	                hh.currentStep.dispatchFocusIn() ;
	            }, 20) ;
            }else{
            	
            	if(hh.isStillRunning()){
            		hh.command.add(hh.formulate(future)) ;
            	}else{
            		hh.redistribute(future) ;
            	}
               
            }
            c.dispatchComplete() ;
        })  
        st.parentStep.kill() ;
        return st ;
    },
    isStillRunning:function(){ return this.command instanceof Command},
    getRoot:function(){ return this.root },
    getCurrentStep:function(){ return this.currentStep },
    getChanger:function(){ return this.changer },
    getCommand:function(){ return this.command },
    
    // TO STRING
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
})))

var AddressHierarchy = NS('AddressHierarchy', NS('spill.net::AddressHierarchy', Hierarchy.$extend({
    __classvars__:{
        version:'0.0.1',
        dependancies:[jQuery, jQuery.fn.hashchange], // Jquery, Jquery-ba-hashchange
        parameters:{
            home:'home/',
            base:location.protocol + '//'+ location.host + location.pathname ,
            useLocale:true,
        },
        isReady:function(){
        	var address = new Address(window.location.href) ;
        	var base = address.base + '/' + address.root ;
        	
        	
        	return base == AddressHierarchy.parameters.base ;
        },
        toString:function()
        {
            return '[class AddressHierarchy]' ;
        }
    },
    __init__:function(s)
    {
        this.changer = new AddressChanger() ;
        AddressHierarchy.instance = window.hierarchy = this ;
        this.initAddress(s) ;
        
        
    },
    sliceLocale:function(value)
    {
        var changer = this.changer ,
        startSlash = HierarchyChanger.__re_startSlash ,
        endSlash = HierarchyChanger.__re_endSlash ,
        path = '' ,
        lang = '' ;
        
        path = value.replace(/^[a-z]{2}\//i, function($0, $1){
          lang = $1 ;
          return '' ;
        }) ;
        
        return path.replace(endSlash, '').replace(startSlash, '') ;
    },
    initAddress:function(s)
    {
        this.changer.enable(location, this, s) ;// supposed to init the SWFAddress Stuff
        trace('address inited') ;
    },
    redistribute:function(value)
    {
        var hh = this ;
        value = hh.sliceLocale(value) ;
        
        var barpath = hh.changer.getCurrentPath() ;
        var cpath = hh.currentStep.path ;
        
        if (hh.isStillRunning()) {
            hh.changer.setFuturePath(value) ;
            trace('>> still running...')
        }else {
            hh.changer.setFuturePath(undefined) ;
            hh.launchDeep(value) ;
        }
    },
    toString:function()
    {
        return '[ object AddressHierarchy ]';
    }
}))) ;

var AddressChanger = NS('AddressChanger', NS('spill.net::AddressChanger', HierarchyChanger.$extend({
    __classvars__:{
        version:'0.0.1',
        dependancies:[jQuery, jQuery.fn.hashchange], // Jquery, Jquery-ba-hashchange
        toString:function()
        {
            return '[class AddressChanger]' ;
        }
    },
    __init__:function(){
        // NOTHING HERE
        return this ;
    },
    enable:function(loc, hierarchy, uniqueClass)
    {
        var u = this ;
        var hh = u.hierarchy = hierarchy ;
        // character stocking ONCE and for ALL
        
        var hashChar = '#' ,
        separator = HierarchyChanger.SEPARATOR ,
        hashReg = new RegExp(hashChar) ,
        doubledSeparatorReg = HierarchyChanger.__re_doubleSeparator ,
        startSlashReg = HierarchyChanger.__re_startSlash ,
        endSlashReg = HierarchyChanger.__re_endSlash ,
        initLocale = document.documentElement.getAttribute('lang'),
        
        // base location object stuff
        href =  loc.href , // -> http://dark:13002/#/fr/unsubscribe/
        protocol =  loc.protocol , // -> http:
        hostname =  loc.hostname , // -> dark
        port =  loc.port , // -> 13002
        host =  loc.host , // -> dark:13002
        pathname =  loc.pathname , // -> /
        hash = loc.hash , // -> #/fr/unsubscribe/
        search = loc.search ; // -> (empty string)
        
        var a = new Address(href) ;
        
        var weretested = false ;
        
        if(!hashReg.test(a.absolute)) { // means it never has been hashchanged, so need to reset hash...
            
            weretested = true ;
            u.locale = (a.loc !== '' ? a.loc : initLocale + separator ) ;
            // resetting AJAX via Hash
            
            if(a.path === '' && a.loc === '') {
            	var p = hashChar + separator + u.locale + a.path + a.qs ;
            	location.hash = p ;
            	
            	//window.location.reload() ;
            }else{
            	loc.href = separator + a.root + hashChar + separator + u.locale + a.path + a.qs ;
            }
        }//else{  // comes in here second time after redirection to hashed URL
            u.locale = u.locale || a.loc ;
            
            hh.setAncestor(uniqueClass.getInstance(), u) ;
            // INIT HASHCHANGE EVENT WHETHER ITS THE FIRST OR SECOND TIME CALLED
            // (in case there was nothing in url, home page was requested, hashchange wont trigger a page reload anyway)
            $(window).bind('hashchange', function(e){
                // need to debug if comes such as
                //   -  '#'
                //  -  '#/'
                // 
                if(u.skipHashChange !== undefined) {
                   u.skipHashChange = undefined ;
                   return ;
                }
                
                var h = location.hash ;
                
                // if multiple unnecessary separators
                if(doubledSeparatorReg.test(h)){
                    location.hash = h.replace(doubledSeparatorReg, separator) ;
                    return ;
                }
                a = new Address(separator + h) ;
                
                if(a.loc === ''){ // if Locale is missing
                   location.hash = separator + u.locale + a.path + a.qs ;
                   return ;
                }
                
                if(a.path === ''){ // if path is absent
                   location.hash = a.hash + a.loc + AddressHierarchy.parameters.home + a.qs ;
                   return ;
                }
                
                
                if(!endSlashReg.test(a.path)){ // if last slash is missing
                   location.hash = a.hash + a.loc + a.path + separator + a.qs ;
                   return ;
                   
                }
                
                hh.changer.__value = separator + a.loc + a.path ;
                hh.redistribute(a.loc + a.path) ;
                
                return ;
            })
            
            // OPENS UNIQUE STEP FOR REAL, THEN SET THE FIRST HASCHANGE
            hh.root.addEL('step_open', function(e){
                hh.root.removeEL('step_open', arguments.callee) ;
                setTimeout(function(){
                    if(!weretested)
                    $(window).trigger('hashchange') ;
                }, 1000) ;
            })
            
            hh.root.open() ;
            
            return ;
        //}
    },
    setValue:function(newVal, cond){
       if(cond == undefined) cond = true ;
       if(!cond) this.skipHashChange = true ;
       
       window.location.hash = (this.__value = newVal.replace(HierarchyChanger.__re_endSlash, '')+'/') ;
    },
    toString:function()
    {
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;

var EventEnhancer = NS('EventEnhancer', NS('naja.event::EventEnhancer', Class.$extend({
    __classvars__:{
        version:'0.0.1',
        enhance:function(){
    		var cl = NS('EventEnhancer') ;
    		var ee = cl.instance = new NS('EventEnhancer')() ;
    	},
        toString:function()
        {
            return '[class EventEnhancer]' ;
        }
    },
    __init__:function(str)
    {
        
        var started = false ;
        var ended = false ;
        var moved = false ;
        
        var uid ;
        var closure ;
        $(window).bind('resize', closure = function(e){
        	
        	var dur = moved == true ? 600 : 100 ;
        	
        	if(uid !== undefined) clearTimeout(uid) ;
        	if(started == false){
        		$(window).trigger('resizestart') ;
        		started = true ;
        	}else{
        		moved = true ;
        		$(window).trigger('resizemove') ;
        	}
        	uid = setTimeout(function(){
    			uid = undefined ;
    			started = false ;
    			moved = false ;
    			$(window).trigger('resizeend') ;
    			
    		}, dur) ;
        })
        
    },
    toString:function()
    {
        var ee = this ;
        return '[Object EventEnhancer]' ;
    }
}))) ;



/* MAIN SPILL TOOLKIT */
var Toolkit = NS('Toolkit', NS('spill.toolKit::Toolkit', Class.$extend({
    __classvars__ : {
        version:'0.0.1', 
        Qexists : function(sel) {
            sel = sel instanceof $ ? sel : $(sel) ;
            return (sel.length > 0) ;
        },
        toString:function(){
            return '[class Toolkit]' ;
        }
    },
    __init__ : function() {
        NS('Kompat').test() ;
        NS('EventEnhancer').enhance() ;
        
        return this ;
    },
    toString : function(){
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;

new Toolkit() ;