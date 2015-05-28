

/* STEPS DECLARATIONS */

var HomeStep = NS('HomeStep', NS('pro::HomeStep', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class HomeStep]' ;
        }
    },
    __init__:function(id, label)
    {
        this.$super(id, new Command(this, this.onStep), new Command(this, this.onStep, false)) ;
        this.label = label ;
    },
    onStep:function(cond){
        if(cond === undefined) cond = true ;
        var c = this ;
        var step = c.context ;
        
        var homePage = window.homeContent ;
        
        //main container
        //var content = $('#content') ;
        
        if(cond){
            //homePage.appendTo(content) ;
            
            //$('#plusZone').data('shrink')(false) ;
            // $('#plusZone').removeClass('dispBlock') ;
            //if($('#shrinkable').hasClass('dispNone')) $('#shrinkable').data('open')() ;
            //$(window).scrollTop(0) ;
            
            
            setTimeout(function(){
                
                step.tweenIn(content, function(){
                      
                  //window.book.detectHome() ;
                   
                  trace('step opened', step.label)
                  c.dispatchComplete() ;
                   
                }) ; 
            }, 100) ;
             
        }else{
                setTimeout(function(){
                    
                    step.tweenOut(content, function(){
                   
                   
                   //homePage.remove() ;
                   
                   //$('#plusZone').addClass('dispBlock') ;
                   //$('#plusZone').data('shrink')() ;
                   //if(!$('#shrinkable').hasClass('dispNone'))$('#shrinkable').data('open')(false) ;
                   
                   
                       //trace('step closed', step.label)
                       c.dispatchComplete() ;
                    
                   
                }) ;
             
             }, 100) ;
        }
        return this ;
    },tweenIn:function(content, cb){
        
        cb() ;
        //content.animate({'opacity':1}, 'fast', undefined, function(){
         
         
      //}) ;
    },
    tweenOut:function(content, cb){
        //content.animate({'opacity':0}, 'fast', undefined, function(){
        
        cb() ;
        
      //}) ;
    },
    toString:function()
    {
        var st = this ;
        return '[HomeStep >>> id:'+ st.id+' , path: '+st.path +' , label: '+st.label + ' , ' + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
    }
}))) ;

var SearchStep = NS('SearchStep', NS('pro::SearchStep', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class SearchStep]' ;
        }
    },
    __init__:function(id, label)
    {
        this.$super(id, new Command(this, this.onStep), new Command(this, this.onStep, false)) ;
        this.label = label ;
    },
    onStep:function(cond){
        if(cond === undefined) cond = true ;
        var c = this ;
        var step = c.context ;
        
        
        
        //var homePage = window.homeContent ;
        var content = $('#content') ;
        if(cond){
            var topsearch = $('#topsearch') ;
            var reset = $('.searchreset') ;
            
            
            var query = location.hash.replace(/^[^?]+\?q=/, '') ;
            query = query.replace(/\|/gi, ' ') ;
            if(/^#/.test(query)) query = "" ;
            
            if(topsearch.attr('value') != query){
                topsearch.attr('value', query) ;
                
                $('.searchall').addClass('searched') ;
                    reset.attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + 'search/')) ;
            }
            
            if(query == ""){
                $('.searchall').removeClass('searched') ;
            }
            
            
            loadAjax(window.hierarchy.changer.locale + 'content/search/?q='+query, function(jxhr){
                
                var page = step.userData.page = $(jxhr.responseText) ;
                
                
                var ct = page.find('#results_count') ;
                var ul = page.find('.activefilters') ;
                var thumbs = page.find('.thumb') ;
                var n = 0;
                var categories = {} ;
                var results = page.find('#resultstext') ;
                
                if(thumbs.size() == 0){
                    
                    results.html(results.html().trim().replace(/s$/i, '')) ;
                    
                    
                    page.find('.noresults').addClass('dispBlock') ;
                    
                    if(query == '') page.find('.resultsloc').remove() ;
                    page.find('.thumbslist').remove() ;
                    page.appendTo('#content') ;
                    
                    return ;
                }else{
                    if(thumbs.size() == 1){
                        results.html(results.html().replace(/s$/i, '')) ;
                    }else{
                        results.html(results.html().replace(/s?$/i, 's'))
                    }
                }
                
                
                
                thumbs.each(function(i, el){
                    n ++ ;
                    var thumb = $(el) ;
                    var category = thumb.find('.category').html().trim() ;
                    if(category in categories){
                        categories[category].count ++ ;
                    }else{
                        categories[category] = {category:category, count:1} ;
                    }
                    
                    var a = thumb.find('.thumblink') ;
                    a.attr('href', window.hierarchy.changer.hashEnable(a.attr('href'))) ;
                })
                
                ct.html(n) ;
                
                var allspan = page.find('#filterall') ;
                var loc = allspan.html().trim() ;
                categories[loc] = {category:loc, count:n} ;
                
                
                for(var s in categories){
                    var cat = categories[s] ;
                    var str = '<li class="activefilter floatL Lmargin">'
                        + '<a class="filtersearchlink dispBlock HmarginSm" href="#">'
                        + '<span class="cat">' + cat.category + '</span><span>('+ cat.count +')'+'</span>'
                        + '</a>'
                        + '</li>' ;
                        var template = $(str) ;
                    
                    template.appendTo(ul) ;
                    
                }
                
                
                var involved = ul.find('.filtersearchlink') ;
                var mn = involved.size() ;
                
                involved.each(function(i, el){
                    var a = $(el) ;
                    var str = a.children('.cat').html().trim() ;
                    
                    a.bind('click', function(e){
                        e.preventDefault() ;
                        
                        thumbs.each(function(ind, elm){
                            var th = $(elm) ;
                            
                            if(i == mn - 1) return th.removeClass('dispNone') ;
                            
                            var category = th.find('.category').html().trim() ;
                            if(category == str){
                                th.removeClass('dispNone') ;
                            }else{
                                th.addClass('dispNone') ;
                            }
                            
                            
                        })
                        
                    }) ;
                    
                })
                
                page.appendTo('#content') ;
                
                
                
            })
            
            //homePage.appendTo(content) ;
            //$('#plusZone').data('shrink')(false) ;
             //$('#plusZone').removeClass('dispBlock') ;
            //if($('#shrinkable').hasClass('dispNone')) $('#shrinkable').data('open')() ;
            
            //$(window).scrollTop(0) ;
            setTimeout(function(){
                
                step.tweenIn(content, function(){
                   trace('search opening') ;
                   //window.foundation.detectHome() ;
                   
                  //trace('step opened', step.label)
                  c.dispatchComplete() ;
                   
                }) ; 
            }, 100) ;
             
        }else{
                setTimeout(function(){
                    
                    step.tweenOut(content, function(){
                   
                   step.userData.page.remove() ;
                   step.destroyObj(step.userData) ;
                   //trace('step closed', step.label)
                   c.dispatchComplete() ;
                }) ;
             
             }, 100) ;
        }
        return this ;
    },
    tweenIn:function(content, cb){
        
        content.animate({'opacity':1}, 'fast', undefined, function(){
         cb() ;
         
      }) ;
    },
    tweenOut:function(content, cb){
        content.animate({'opacity':0}, 'fast', undefined, function(){
        
        cb() ;
        
      }) ;
    },
    toString:function()
    {
        var st = this ;
        return '[SearchStep >>> id:'+ st.id+' , path: '+st.path +' , label: '+st.label + ' , ' + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
    }
}))) ;

var BaseStep = NS('BaseStep', NS('pro::BaseStep', Step.$extend({
    __classvars__:{
        version:'0.0.1',
        toString:function()
        {
            return '[class BaseStep]' ;
        }
    },
    status: '' ,
    __init__:function(id, label, url, jsonurl, name)
    {
        this.$super(id, new Command(this, this.onStep), new Command(this, this.onStep, false)) ;
        this.label = label ;
        this.url = url ;
        this.jsonurl = jsonurl ;
        this.name = name ;
    },
    onStep:function(cond){
        if(cond === undefined) cond = true ;
        var c = this ;
        var step = c.context ;
        
        var homePage = window.home ;
        var content = $('#content') ;
        
        var hh = window.hierarchy ;
        var p = hh.changer.getFuturePath() ;
        var future = '/' + p ;
        var current = step.path ;
        
        if(cond){
            
            if(step.depth == 1 && step.node !== undefined){
                step.node.addClass('active') ;
            }
            
            var url = step.url ;
            var jsonurl = step.jsonurl ;
            
            loadJSON(jsonurl, function(json){
                
               // JSON DATA
               
               var renderer = json.renderer ;
               var curNode = json.current_node_descriptor ;
               var level = json.final_node_level ;
               var finalNode = step.parentStep.userData.json !== undefined ? step.parentStep.userData.json.final_node_descriptor : json.final_node_descriptor ;
               
               step.userData.renderer = renderer ;
               
               
                switch(renderer){
                  case 'pageslide' :
                     if(step.depth == 2 && curNode.children.length == 0) ///////////////////////  ONE PAGE STEP
                     {
                        step.userData.status = 'standard' ;
                        step.addChildren(curNode) ;
                        
                     }else if(step.depth == level) /////////////////////////////////// SLIDE STEP
                     {
                        step.userData.status = 'finalchild' ;
                        //step.addChildren(curNode) ;
                        
                     }else /////////////////////////////////// INVISIBLE STEP
                     {
                        step.userData.status = undefined ;
                        step.addChildren(curNode) ;
                     }
                  break ;
                  default :
                     step.userData.status = 'standard' ; /////////////////// FALLS BACK TO ONE PAGE STEP
                     step.addChildren(curNode) ;
                  break;
               }
               
               // HACK FOR IN-DEPTH CHILD FORWARDING
               step.addEL('focusIn', function(e){
                  // checking that there is no further requested path already in the hash value 
                  if(step.path === hh.changer.getValue().replace(hh.changer.locale, '')){
                     if(step.children.length > 0 && step.userData.status !== 'standard'){ // if have children and is not basic page
                        
                        var indexDeep = (window.descending !== true) ? 0 : step.children.length - 1 ;
                        window.hierarchy.changer.setValue('/'+hierarchy.changer.locale.replace(/\/$/,'' ) + step.children[indexDeep].path) ;
                        window.descending = undefined ;
                     }
                  }
                  // LANGUAGE CHANGE
                  if(step.userData.lang !== undefined){
                     window.lang.each(function(i, el){
                        var lan = $(el) ;
                        if(lan.attr('href') !== undefined){
                           lan.attr({'href': $(step.userData.lang[i]).attr('href')}) ;
                        }
                     })
                  }
               })
               
               switch(step.userData.status){
                case 'finalchild' :
                    
                    if(window.hierarchy.state == 'descending'){
                        
                         window.scrolled === undefined ;
                      
                         window.scrollZone = $('<div id="scrollZone" class="scrollZone context">') ;
                         // resetting scroll location
                         window.scrollZone.scrollTo(20) ;
                        
                        var chunked_content_url = url.replace(/\/(\w{2}\/)?(.*)$/i,function(s,l,p) { return "/" + l + "content/" + p });
                        
                        loadAjax(chunked_content_url, function(jxhr, req){
                        
                            step.appendNav(jxhr, content) ;
                            
                            var pages = $('<div id="pages" class="pages context relative">').css({'left':'50%','margin-left':'-475px'}) ;
                            window.scrollZone.append(pages) ;
                            content.append(window.scrollZone) ;
                            
                            var pstep = step.parentStep ;
                            var l = pstep.getNumChildren() ;
                            
                            for(var i = 0 ; i < l ; i++){
                               var child = pstep.getChild(i) ;
                               pages.width(pages.width() + 950) ;
                               child.appendPage(pages, child === step, jxhr) ;
                            }
                            
                            if(pstep.getLength() > 1){
                               step.appendArrows(content) ;
                               // ACTIVE CONTENT STUFF
                               // 1. DEEP NAVIGATION BAR
                               window.foundation.detectDeepNav() ;
                            }
                            
                            $(window).bind('mousewheel', window.mouseWheelClosure = function(e){
                               if(window.scrolled === undefined)
                               window.scrolled = true ;
                            })
                            
                            step.openslidestep() ;
                            
                            setTimeout(function(){
                                
                                step.tweenIn(content, function(){
                                
                                 c.dispatchComplete() ;
                                  
                               }) ;
                               
                            }, 100) ;
                         }) ;
                        
                    }else{
                        
                        step.openslidestep() ;
                        
                        setTimeout(function(){
                                  //trace('step loaded & opened', step.label, step.userData.status) ;
                                  c.dispatchComplete() ;
                              }, 100) ;
                        
                    }
                break ;
                
                  case 'standard' :
                     loadAjax(url, function(jxhr, req){
                        
                        window.contentZone = $('<div id="contentZone" class="contentZone wrapped context">') ;
                        window.contentZone.appendTo(content) ;
                        
                        step.appendNav(jxhr, window.contentZone) ;
                        
                        
                        $(jxhr.responseText).find('.contentArea').appendTo(window.contentZone) ;
                        
                        step.userData.lang = $(jxhr.responseText).find('.lang a') ;
                        
                        step.appendArrows(window.contentZone) ;
                        
                        // ACTIVE CONTENT STUFF
                        step.checkArrows() ;
                        
                        
                        // 2. FB LIKE
                        setTimeout(function(){
                           window.foundation.detectShare() ;
                        }, 1000) ;
                        
                        // 3. SPECIAL TEMPLATES
                        if(Toolkit.Qexists('#agendas')){
                           window.foundation.detectAgenda() ;
                        }
                        
                        if(Toolkit.Qexists('#registerForms')){
                                  window.foundation.detectSubscribeForms() ;
                              }
                        setTimeout(function(){
                            
                            step.tweenIn(content, function(){
                                 c.dispatchComplete() ;
                            }) ;
                            
                        }, 100) ;
                        
                     })
                  break;
                  case 'default' :
                  default :
                     setTimeout(function(){
                         //trace('step loaded & opened', step.label, step.userData.status) ;
                         c.dispatchComplete() ;
                         
                     }, 100) ;
                     
                  break ;
               }
            })
            
        }else{ /////////////////////////////////////////////////////////////////////////// CLOSING
           
           //trace('closing >', step.userData.status)
           switch(step.userData.status){
                case 'finalchild' :
                    if(window.hierarchy.state == 'idle'){
                    
                    step.closeslidestep() ;
                    step.empty(true) ; // remove loaded steps
                    setTimeout(function(){
                         //trace('step closed', step.label, step.userData.status) ;
                         c.dispatchComplete() ;
                     }, 100) ;
                     
                    }else{
                        
                        step.closeslidestep() ;
                        
                        $(window).unbind('mousewheel', window.mouseWheelClosure) ;
                      window.scrolled = undefined ;
                      setTimeout(function(){
                        
                        step.tweenOut(content, function(){
                            
                            $('#secondnav').remove() ;
                            
                             window.scrollZone.remove() ;
                             window.scrollZone = undefined ;
                             
                             $('#arrows_navigation').remove() ;
                             
                             step.empty(true) ; // remove loaded steps
                            
                            
                            //trace('step closed', step.label, step.userData.status) ;
                            c.dispatchComplete() ;
                            
                        })
                        
                    }, 100) ; 
                    }
                    
                break ;
               case 'standard' :
                setTimeout(function(){
                    
                    step.tweenOut(content, function(){
                        step.empty(true) ; // remove loaded steps
                         window.contentZone.remove() ;     
                         
                        //trace('step closed', step.label, step.userData.status) ;
                        c.dispatchComplete() ;
                         
                      }) ;
                      
                  }, 100) ;
               break ;
               case 'default' :
               default :
                  step.empty(true) ; // remove loaded steps
                  setTimeout(function(){
                      //trace('step closed', step.label, step.userData.status) ;
                      c.dispatchComplete() ;
                  }, 100) ;
               break ;
            }
            
            
            /* video hack */
           if(step.userData.page !== undefined){
                var vblock = step.userData.page.find('#gallery_box .videoblock') ;
                if(vblock.size() > 0){
                    
                    var rightframe = vblock.find('iframe') ;
                    var pdiv = rightframe.parent() ;
                    var cloned = rightframe.clone() ;
                    
                    rightframe.remove() ;
                    cloned.appendTo(pdiv) ;
                       
                }
                
           }
            
            
            
            if(step.depth == 1 && step.node !== undefined){
                
                step.node.removeClass('active') ;
                
            }
            
            step.destroyObj(step.userData) ;
            
        }
        return this ;
    },
    tweenIn:function(content, cb){
        content.animate({'opacity':1}, 'fast', undefined, function(){
            
         cb() ;
         
      }) ;
    },
    tweenOut:function(content, cb){
        content.animate({'opacity':0}, 'fast', undefined, function(){
        
        cb() ;
        
      }) ;
    },
    appendArrows:function(content){
        var step = this ;
        var pstep = step.parentStep ;
        
        var arrows = $('<div id="arrows_navigation" class="arrows_navigation top0">') ;
      var next = $('<a href="#" id="next" class="arrownavigate arrownext absolute"><span class="tooltip"><span class="txtzone"></span></span></a>') ;
      var prev = $('<a href="#" id="prev" class="arrownavigate arrowprev absolute"><span class="tooltip"><span class="txtzone"></span></span></a>') ;
      
      var hideZoneNext = $('<div class="hideZone next">') ;
      var hideZonePrev = $('<div class="hideZone prev">') ;
      arrows.append(hideZoneNext) ;
      arrows.append(hideZonePrev) ;
      
      hideZoneNext.append(next) ;
      hideZonePrev.append(prev) ;
      
      content.prepend(arrows) ;
      
    },
    checkArrows:function(){
        var step = this ;
        
        var next = $('#next') ;
        var prev = $('#prev') ;
        
        var pstep = step.parentStep ;
        
        if(step.userData.status == 'standard'){
            
            if(pstep.hasPrev()){
            prev.removeClass('dispNone').addClass('double') ;
            prev.find('.txtzone').html(pstep.getPrev().name) ;
            prev.attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + pstep.getPrev().path))
          }else{
            prev.addClass('dispNone') ;
          }
          
          if(pstep.hasNext()){
            next.removeClass('dispNone').addClass('double') ;
                next.find('.txtzone').html(pstep.getNext().name) ;
                next.attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + pstep.getNext().path))
          }else{
                next.addClass('dispNone') ;
            }
            
        }else{
            
            if(pstep.hasPrev()){
            prev.removeClass('dispNone double') ;
            prev.attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + pstep.getPrev().path))
          }else{
            if(pstep.parentStep.hasPrev()){ // LINKS TO OTHER SECTION
                prev.removeClass('dispNone').addClass('double') ;
                prev.find('.txtzone').html(pstep.parentStep.getPrev().name) ;
                prev.attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + pstep.parentStep.getPrev().path))
            }else{
                prev.addClass('dispNone') ;
            }
          }
          
          if(pstep.hasNext()){
            next.removeClass('dispNone double') ;
            next.attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + pstep.getNext().path))
          }else{
                if(pstep.parentStep.hasNext()){ // LINKS TO OTHER SECTION
                    next.removeClass('dispNone').addClass('double') ;
                    next.find('.txtzone').html(pstep.parentStep.getNext().name) ;
                    next.attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + pstep.parentStep.getNext().path))
                }else{
                    next.addClass('dispNone') ;
                }
            }
            
        }
        
    },
    closeslidestep:function(){
        
        var step = this ;
        
        window.scrolled = undefined ;
      var idPage = step.id.replace(/[0-9]*\//, '') ;
      
      // MORE TEXT default closing behavior 
      $('#'+idPage).find('.moreTxt').addClass('dispNone') ;
      
      step.empty(true) ; // remove loaded steps
        
    },
    openslidestep:function(){
        
        var step = this ;
        var levelNav = $('.secundarynav .navbar') ;
      var prev = $('#prev') ;
      var next = $('#next') ;
      
      var s = levelNav.size() ;
      // HACK FOR WHEN THERE WILL BE MORE THAN ONE NAV CALLED NAVBAR, ALWAYS PICK THE DEEPEST (LAST)
      if(s > 1) levelNav = $(levelNav[s-1]) ;
      
      var levelLinks = levelNav.find('a') ;
      levelLinks.each(function(i, el){
         var a = $(el) ;
         if(a.attr('href').search(step.id) !== -1 ){
            a.parent().addClass('active') ;
         }else{
            a.parent().removeClass('active') ;
         }
      })
      
      // CHECK FOR ARROW DISPLAY
      step.checkArrows() ;
        
      var allpages = $('.page') ;
      var idPage = step.id.replace(/[0-9]*\//, '') ;
      
      var page = step.userData.page = $('#'+idPage).height('auto') ;
      
      allpages.each(function(i, el){
         var p1 = $(el) ;
         if(p1.attr('id') !== page.attr('id')) {
            p1.height(page.height()) ;
         }
      })
      
      var secundNav = $('.secundarynav') ;
      
      if(window.scrolled === undefined) $(document).scrollTo(0) ;
      if(window.scrollZone !== undefined ) {
        
        //window.scrollZone.scrollTo(((page.width() + 100) * step.index), secundNav.hasClass('hidden') ? 0 : 250) ;
        var r = {x:window.scrollZone.scrollLeft()} ;
        if(!secundNav.hasClass('hidden')){
            
            BetweenJS.to(r, {x:(page.width() + 100) * step.index}, .2, Expo.easeIn).addEL('update', function(e){
                window.scrollZone.scrollLeft(r.x) ;
            }).play() ;
            
        }else{
            window.scrollZone.scrollLeft((page.width() + 100) * step.index) ;
        }
        
        
      }//
      
      allpages.removeClass('hidden') ;
      
      secundNav.removeClass('hidden') ;
      
      
      // ACTIVE CONTENT STUFF
      // 1. DEEP IN-PAGE SLIDESHOW
      if(step.userData.slideshowEnabled === undefined){
        window.foundation.detectOtherSlideshow(idPage) ;
         step.userData.slideshowEnabled = true ;
      }
      
      // 2. FB LIKE
      setTimeout(function(){
         window.foundation.detectShare() ;
      }, 1000) ;
      
      // 3. SLIDE BAR HANDLING
      if(window.foundation.slidebar !== undefined && window.foundation.slidebar.active){
         window.foundation.slidebar.scrollTo(window.foundation.slidebar.pop.filter('.active')) ;
      }
      
      if(Toolkit.Qexists('#order_publication')){
        window.foundation.detectOrderForm(step) ;
       }
       
      // 4. INER LINKS
      window.foundation.detectInnerLinks(step.page) ;
      
      // 5. Subscribe page
      if(Toolkit.Qexists('#registerForms')){
          window.foundation.detectSubscribeForms() ;
      }
    },
    appendNav:function(jxhr, cont){
            var nav = $(jxhr.responseText).find('.secundarynav')
               .attr({'id':'secondnav'}).addClass('wrapped')
               .appendTo(cont) ;
         
         var navlinks = nav.find('a') ;
         
         navlinks.each(function(i, el){
            var a = $(el) ;
            a.attr('href', window.hierarchy.changer.hashEnable(a.attr('href'))) ;
         }) ;
            
    },
    appendPage:function(pages, isLoaded, jjxxhhrr){
            if(isLoaded == undefined) isLoaded = false ;
            var ch = this ;
            var freg = /[0-9]*\// ;
            var page = $('<div id="'+ ch.id.replace(freg, '')+'" class="page floatL">').css({'margin-right':'100px','width':'950px'}) ;
        page.addClass('hidden').appendTo(pages) ;
        
        
          if(isLoaded === false) {
            var sreg = /\/(\w{2}\/)?(.*)$/i ;
              var ch_chunked_content_url = ch.url.replace(sreg, function(ss, nn, pp) {
                 return "/" + nn + "content/" + pp ;
              }) ;
            loadAjax(ch_chunked_content_url, function(jxhr, req){
                 ch.userData.lang = $(jxhr.responseText).find('.lang a') ;
                 page.append($(jxhr.responseText).find('.contentArea')) ;
              })
          }else{
            new WaitCommand(150, function(){
                ch.userData.lang = $(jjxxhhrr.responseText).find('.lang a') ;
                page.append($(jjxxhhrr.responseText).find('.contentArea')) ;
                
            }).execute() ;
          }
      
    },
    addChildren:function(nodeJson){
       var step = this ;
       var nodes = nodeJson.children ;
       var l = nodes.length ;
      
       for(var i = 0 ; i < l ; i++){
         var node = nodes[i] ;
         var link = node.href ;
         var name = node.label ;
         // continue for external links
         if(/http/.test(link)) continue ;
        
         var json = link.replace(/(\/?[a-z]{2}\/)/, function($1){
            return $1+'json/';
         }) ;
        
         // IMPORTANT !!!!!
         // ID & PATH for entered steps MUST BE without lang, without first slash and without last slash
         var path = link.replace(step.path, '').replace(/\/?[a-z]{2}\//, '').replace(/\/$/, '') ;
         
         var ch ;
         
         if(node.hide_deep == 0){
            ch = new BaseStep(path, path, link, json, name) ;
         }else{
            ch = new PublicationsStep(path, path, link, json, name) ;
         }
         step.add(ch) ;
      }
    },
    toString:function()
    {
        var st = this ;
        return '[BaseStep >>> id:'+ st.id+' , path: '+st.path +' , label: '+st.label + ' , ' + ((st.children.length > 0) ? '[\n'+st.dumpChildren() +'\n]'+ ']' : ']') ;
    }
}))) ;

var PublicationsStep = NS('PublicationsStep', NS('pro::PublicationsStep', BaseStep.$extend({
    __classvars__:{
        version:'0.0.1',
        instance:undefined,
        toString:function()
        {
            return '[class PublicationsStep]' ;
        }
    },
    __init__:function(id, label, url, jsonurl, name)
    {
        this.$super(id, label, url, jsonurl, name) ;
    },
    addChildren:function(nodeJson){
          var step = this ;
          var nodes = nodeJson.children ;
          var l = nodes.length ;
          
          var hpath = '/' + window.hierarchy.changer.locale + step.path.replace(/^\//,'') + '/' ;
          var highlightsStep = new PublicationsStep('highlights', 'highlights', hpath, hpath.replace(/(\/?[a-z]{2}\/)/, function($1){
                return $1+'json/';
             }), '<strong><em>Highlights</em></strong>') ;
          
          step.add(highlightsStep) ;
          
          for(var i = 0 ; i < l ; i++){
             var node = nodes[i] ;
             var link = node.href ;
             var name = node.label ;
             
             if(i > 0){
                link = link.replace(step.children[1].id + '/', '') ;
             }
             
             var json = link.replace(/(\/?[a-z]{2}\/)/, function($1){
                return $1+'json/';
             }) ;
             
             // IMPORTANT !!!!!
             // ID & PATH for entered steps MUST BE without lang, without first slash and without last slash
             var path = link.replace(step.path, '').replace(/\/?[a-z]{2}\//, '').replace(/\/$/, '') ;
             
             var ch = new PublicationsStep(path, path, link, json, /<strong>/.test(name) ? name : '<strong><em>'+name+'</em></strong>') ;
             step.add(ch) ;
         }
    },
    onStep:function(cond){
        if(cond === undefined) cond = true ;
        
        var c = this ;
        var step = c.context ;
        
        var homePage = window.home ;
        var content = $('#content') ;
        
        var hh = window.hierarchy ;
        var p = hh.changer.getFuturePath() ;
        var future = '/' + p ;
        var current = step.path ;
        
        if(cond){
            
            var url = step.url ;
            var jsonurl = step.jsonurl ;
            
            // HIGHLIGHTS HACK
            if(jsonurl.search('highlights/') != -1){
                jsonurl = jsonurl.replace('highlights/', '') ;
            }
            
            loadJSON(jsonurl, function(json){
               // JSON DATA
               
               var renderer = json.renderer ;
               var curNode = json.current_node_descriptor ;
               var level = json.final_node_level ;
               var finalNode = step.parentStep.userData.json !== undefined ? step.parentStep.userData.json.final_node_descriptor : json.final_node_descriptor ;
               
               step.userData.renderer = renderer ;
               step.userData.layout = curNode.layout ;
               
               if(step.userData.layout === 'tagged_items_home' && step.id != 'highlights') {
                step.userData.status = 'default' ;
                
                step.userData.lockedStep = step ;
                step.addChildren(curNode) ;
               }else{
                step.userData.status = 'standard' ;
                step.userData.lockedStep = step.parentStep.userData.lockedStep ;
                //step.addChildren(curNode) ;
               }
               
               // HACK FOR IN-DEPTH CHILD FORWARDING
               step.addEL('focusIn', function(e){
                  if(step.path === hh.changer.getValue().replace(hh.changer.locale, '')){
                     if(step.children.length > 0 && step.userData.status !== 'standard'){ // if have children and is not basic page
                        var indexDeep = (window.descending !== true) ? 0 : step.children.length - 1 ;
                        window.hierarchy.changer.setValue('/'+hierarchy.changer.locale.replace(/\/$/,'' ) + step.children[indexDeep].path) ;
                        window.descending = undefined ;
                     }
                  }
                  // LANGUAGE CHANGE
                  if(step.userData.lang !== undefined){
                     window.lang.each(function(i, el){
                        var lan = $(el) ;
                        if(lan.attr('href') !== undefined){
                           lan.attr({'href': $(step.userData.lang[i]).attr('href')}) ;
                        }
                     })
                  }
               })
               
               switch(step.userData.status){
                case 'standard' :
                    
                    var chunked_content_url = url.replace(/\/(\w{2}\/)?(.*)$/i,function(s,l,p) { return "/" + l + "content/" + p });
                    
                    
                    
                    loadAjax(chunked_content_url, function(jxhr, req){
                          
                          window.contentZone = $('<div id="contentZone" class="contentZone wrapped context">') ;
                          window.contentZone.appendTo(content) ;
                          
                          step.appendNav(jxhr, window.contentZone) ;
                          
                          $(jxhr.responseText).find('.contentArea').appendTo(window.contentZone) ;
                          
                          step.userData.lang = $(jxhr.responseText).find('.lang a') ;
                          
                          step.appendArrows(window.contentZone) ;
                          
                          // ACTIVE CONTENT STUFF
                        step.checkArrows() ;
                          
                          // PUBLICATIONS TEMPLATES
                          if(Toolkit.Qexists('#publications')){
                            window.foundation.detectPublications(step) ;
                          }
                          if(Toolkit.Qexists('#allpublications')){
                            window.foundation.startPublicationsApp(window.location.hash.replace('#/', ''), step) ;
                          }
                          if(Toolkit.Qexists('#order_publication')){
                                window.foundation.detectOrderForm(step) ;
                              }
                          if(step.userData.slideshowEnabled === undefined){
                                 window.foundation.detectOtherSlideshow('contentZone') ;
                                 step.userData.slideshowEnabled = true ;
                              }
                              
                              
                              
                          window.foundation.detectInnerLinks() ;
                          
                          // 2. FB LIKE
                          setTimeout(function(){
                             window.foundation.detectShare() ;
                          }, 1000) ;
                          
                          setTimeout(function(){
                            
                            step.tweenIn(content, function(){
                                  
                                  c.dispatchComplete() ;
                                  
                             }) ;
                             
                          }, 100) ;
                          
                       })
                break ;
                
                case 'default' :
                default :
                    setTimeout(function(){
                         //trace('step loaded & opened', step.label, step.userData.status) ;
                         c.dispatchComplete() ;
                         
                     }, 100) ;
                break ;
               }
               
            })
            
            
        }else{ /////////////////////////////////////////////////////////////////////////// CLOSING
            
            switch(step.userData.status){
                case 'standard' :
                    setTimeout(function(){
                
                        step.tweenOut(content, function(){
                        step.empty(true) ; // remove loaded steps
                        if(window.publicationsApp !== undefined) window.publicationsApp.enable(false) ;
                        
                          window.contentZone.remove() ;
                          
                          //trace('step closed', step.label, step.userData.status) ;
                          c.dispatchComplete() ;
                          
                       }) ;
                       
                    }, 100) ;
                break ;
                case 'default' :
                default :
                    if(window.publicationsApp !== undefined) window.foundation.endPublicationsApp() ;
                    
                    step.empty(true) ; // remove loaded steps
                  setTimeout(function(){
                      //trace('step closed', step.label, step.userData.status) ;
                      c.dispatchComplete() ;
                  }, 100) ;
                
                break ;
            }
            
            step.destroyObj(step.userData) ;
            
        }
        return this ;
    },
    toString:function()
    {
        var st = this ;
        return '[PublicationsStep >>> id:'+ st.id+' , path: '+ st.path + ((st.children.length > 0) ? '[\n'+ st.dumpChildren() + '\n]' + ']' : ']') ;
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
        
        trace(window.book) ;
        
        trace('UNIQUE INSTANCIATED...') ;
    },
    onStep:function(){
        trace('UNIQUE STEP OPENING') ;
        
        //hideContent(false) ;
        
        var c = this ;
        var u = c.context ;
        
        u.addSteps() ;
        
        setTimeout(function(){
            c.dispatchComplete() ;
        }, 150);
        
        return this ;
    },
    addressComplete:function(e){
       trace('command complete') ;
    },
    addSteps:function(){
        var st = this ;
        
        st.add(new HomeStep('home', 'home/') ) ;
        
        
        //st.add(new SearchStep('search', 'search/')) ;
        
        
        
        
        /*
        
        
        var topNodes = window.toplevelNodes ;
        
        
        var l = topNodes.length ;
        
        
        
        for(var i = 0 ; i < l ; i++){
           var node = topNodes[i] ;
           var link = node.href ;
           // continue for external links
           var name = node.label ;
           
           if(/http/.test(link)) continue ; // if external section only
           
           if(link.search('credits') !== -1 || link.search('soon') !== -1) continue ; // CAST OUT CREDITS & SOON SECTION --> POPUPS, NOT STEPS
           
           var json = link.replace(/(\/?[a-z]{2}\/)/, function($1){
              return $1+'json/';
           }) ;
           // IMPORTANT !!!!!
           
           // ID & PATH for entered steps MUST BE without lang, without first slash and without last slash
           var path = link.replace(/\/?[a-z]{2}\//, '').replace(/\/$/, '') ;
           var child = new BaseStep(path, path, link, json, name) ;
           st.add(child) ;
           
           $('a[href*="'+path+'/'+'"]').each(function(i, el){
              
              var a = $(el) ;
              
              var href = a.attr('href') ;
              
              a.attr('href', window.hierarchy.changer.hashEnable(href)) ;
              
              if(a.attr('rel') == 'main'){
                    child.node = a.parent('li') ;
              }
              
           }) ;
        }
        
        // HREF SHORTCUTS
        
        // LANGUAGE CHANGE
        window.lang = $('.lang a') ;
        // LOGO -> HOME LINK
        $('#logo, #logofooter').attr('href', window.hierarchy.changer.hashEnable(window.hierarchy.changer.locale + AddressHierarchy.parameters.home))
        */
    },
    toString:function()
    {
        var st = this ;
        return '[Unique >>> id:'+ st.id+' , path: '+ st.path + ((st.children.length > 0) ? '[\n'+ st.dumpChildren() + '\n]' + ']' : ']') ;
    }
}))) ;



