(function(name, definition){
	
	if ('function' === typeof define){ // AMD
		define(definition) ;
	} else if ('undefined' !== typeof module && module.exports) { // Node.js
		module.exports = ('function' === typeof definition) ? definition() : definition ;
	} else {
		if(definition !== undefined) this[name] = ('function' === typeof definition) ? definition() : definition ;
	}
	
})('routes', function(){
	
	// what steps are going to do graphically , extracted from './graphics.js'
	// on toggle (both opening / closing) and focus events

	var graphics = require('./graphics') ;
	var toggle = graphics.toggle ;
	var focus = graphics.focus ;

	// Express.app.set('liveautoremove', true) ; // erases live-generated regexp steps on close

	// hierarchy sections descriptor object written as in 'exports' object

	
	return {
		index : (function(){
			
			var index = function index (req, res){
				if(res.opening){
					res.userData.urljade = '/jade/artists/index.jade' ;
					res.userData.urljson = 'json/index' ;
					res.userData.parameters = {response:res.parentStep} ;
				}
				return res ;
			} ;
			
			index['@focus'] = focus ;
			index['@toggle'] = toggle ;
			
			return index ;
		})(),
		/////////// ABOUT
		about : (function(){
			
			var about = function about (req, res){ return res.ready() } ;
			
				about.index = function about_index(req, res){
					if(res.opening){
						res.userData.urljade = '/jade/artists/section_desc.jade' ;
						res.userData.urljson = 'json/section' ;
						res.userData.parameters = {response:res.parentStep} ;
					}
					return res ;
				} ;
				about.index['@focus'] = focus ;
				about.index['@toggle'] = toggle ;
				
				about.intro = function about_intro(req, res){
					if(res.opening){
						res.userData.urljade = '/jade/artists/section.jade' ;
						res.userData.urljson = 'json/section' ;
						res.userData.parameters = {response:res} ;
					}
					return res ;
				} ;
				about.intro['@focus'] = focus ;
				about.intro['@toggle'] = toggle ;
				
			
			return about ;
		})(),
		docs : (function(){
			
			var docs = function docs (req, res){ return res.ready() } ;
			
				docs.index = function docs_index(req, res){
					if(res.opening){
						res.userData.urljade = '/jade/artists/section.jade' ;
						res.userData.urljson = 'json/section' ;
						res.userData.parameters = {response:res.parentStep} ;
					}
					return res ;
				} ;
				docs.index['@focus'] = focus ;
				docs.index['@toggle'] = toggle ;
				
				docs.guide = function docs_guide(req, res){
					if(res.opening){
						res.userData.urljade = '/jade/artists/section.jade' ;
						res.userData.urljson = 'json/section' ;
						res.userData.parameters = {response:res} ;
					}
					return res ;
				} ;
				docs.guide['@focus'] = focus ;
				docs.guide['@toggle'] = toggle ;

				docs.api = function docs_api(req, res){
					if(res.opening){
						res.userData.urljade = '/jade/artists/section.jade' ;
						res.userData.urljson = 'json/section' ;
						res.userData.parameters = {response:res} ;
					}
					return res ;
				} ;
				docs.api['@focus'] = focus ;
				docs.api['@toggle'] = toggle ;
				
				
				docs.examples = function docs_examples(req, res){ return res.ready() } ;
				
					docs.examples.index = function docs_examples_index(req, res){
						if(res.opening){
							res.userData.urljade = '/jade/artists/section_choose_item.jade' ;
							res.userData.urljson = 'json/section_choose_item' ;
							res.userData.parameters = {response:res} ;
						}
						return res ;
					} ;
					docs.examples.index['@focus'] = focus ;
					docs.examples.index['@toggle'] = toggle ;

					
					docs.examples[/[0-9]+/] = function docs_examples_numeric(req, res){ return res.ready() } ;
						
						docs.examples[/[0-9]+/].index = function docs_examples_numeric_index(req, res){
							if(res.opening){
								res.userData.autoremove = true ;
								res.userData.urljade = '/jade/artists/section_item_numeric.jade' ;
								res.userData.urljson = 'json/section' ;
								res.userData.parameters = {response:res} ;
							}
							return res ;
						} ;
						docs.examples[/[0-9]+/].index['@focus'] = focus ;
						docs.examples[/[0-9]+/].index['@toggle'] = toggle ;
						
						docs.examples[/[0-9]+/].detail = function docs_examples_numeric_detail(req, res){ return res.ready() } ;
					
							docs.examples[/[0-9]+/].detail.index = function docs_examples_numeric_detail_index(req, res){
								if(res.opening){
									res.userData.urljade = '/jade/artists/section_choose_item.jade' ;
									res.userData.urljson = 'json/section_choose_item' ;
									res.userData.parameters = {response:res} ;
								}
								return res ;
							} ;
							docs.examples[/[0-9]+/].detail.index['@focus'] = focus ;
							docs.examples[/[0-9]+/].detail.index['@toggle'] = toggle ;

							docs.examples[/[0-9]+/].detail[/[0-9]+/] = function docs_examples_numeric_deep(req, res){ return res.ready() } ;
								
								docs.examples[/[0-9]+/].detail[/[0-9]+/].index = function docs_examples_numeric_deep_index(req, res){
									if(res.opening){
										res.userData.urljade = '/jade/artists/section.jade' ;
										res.userData.urljson = 'json/section' ;
										res.userData.parameters = {response:res} ;
									}
									return res ;
								} ;
								docs.examples[/[0-9]+/].detail[/[0-9]+/].index['@focus'] = focus ;
								docs.examples[/[0-9]+/].detail[/[0-9]+/].index['@toggle'] = toggle ;

			return docs ;
		})(),
		download : (function(){
			
			var download = function download(req, res){ return res.ready() } ;
				
				download.index = function download_index(req, res){
					if(res.opening){
						res.userData.urljade = '/jade/artists/section.jade' ;
						res.userData.urljson = 'json/section' ;
						res.userData.parameters = {response:res.parentStep} ;
					}
					return res ;
				} ;
				
				download.index['@focus'] = focus ;
				download.index['@toggle'] = toggle ;
			
			return download ;
		})()
	
	} ;

}) ;