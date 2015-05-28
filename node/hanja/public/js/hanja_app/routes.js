
// what steps are going to do graphically , extracted from './graphics.js'
// on toggle (both opening / closing) and focus events

var graphics = require('./graphics') ;
var toggle = graphics.toggle ;
var focus = graphics.focus ;

// hierarchy sections descriptor object written as in 'exports' object

/////////// INDEX
exports.index = function index(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/index.jade' ;
		res.userData.urljson = 'json/index' ;
		res.userData.parameters = {response:res.parentStep} ;
	}
	return res ;
} ;
exports.index['@focus'] = focus ;
exports.index['@toggle'] = toggle ;

/////////// ABOUT
exports.about = function index(req, res){
	return res.ready() ;
} ;
exports.about.index = function about_index(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_desc.jade' ;
		res.userData.urljson = 'json/section' ;
		res.userData.parameters = {response:res} ;
	}else{
		
	}
	return res ;
} ;
exports.about.index['@focus'] = focus ;
exports.about.index['@toggle'] = toggle ;

exports.about['intro'] = function about_intro(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_item.jade' ;
		res.userData.urljson = 'json/section' ;
		res.userData.parameters = {response:res} ;
	}else{
		
	}
	return res ;
} ;
exports.about['intro']['@focus'] = focus ;
exports.about['intro']['@toggle'] = toggle ;

/////////// DOCS
exports.docs = function docs(req, res){
	
	return res.ready() ;
} ;
exports.docs.index = function docs_index(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section.jade' ;
		res.userData.urljson = 'json/section' ;
		res.userData.parameters = {response:res.parentStep} ;
	}else{
		
	}
	return res ;
} ;
exports.docs.index['@focus'] = focus ;
exports.docs.index['@toggle'] = toggle ;

exports.docs.guide = function docs_guide(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_item.jade' ;
		res.userData.urljson = 'json/section_item' ;
		res.userData.parameters = {response:res} ;
	}
	return res ;
} ;
exports.docs.guide['@focus'] = focus ;
exports.docs.guide['@toggle'] = toggle ;

exports.docs.api = function docs_api(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_item.jade' ;
		res.userData.urljson = 'json/section_item' ;
		res.userData.parameters = {response:res} ;
	}
	return res ;
} ;
exports.docs.api['@focus'] = focus ;
exports.docs.api['@toggle'] = toggle ;


exports.docs.examples = function docs_examples(req, res){
	return res.ready() ;
} ;
exports.docs.examples.index = function docs_examples_index(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_choose_item.jade' ;
		res.userData.urljson = 'json/section_choose_item' ;
		res.userData.parameters = {response:res} ;
	}
	return res ;
} ;
exports.docs.examples.index['@focus'] = focus ;
exports.docs.examples.index['@toggle'] = toggle ;

exports.docs.examples[/[0-9]+/] = function docs_examples_numeric(req, res){
	return res.ready() ;
} ;
exports.docs.examples[/[0-9]+/].index = function docs_examples_numeric_index(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_item_numeric.jade' ;
		res.userData.urljson = 'json/section' ;
		res.userData.parameters = {response:res} ;
	}
	return res ;
} ;
exports.docs.examples[/[0-9]+/].index['@focus'] = focus ;
exports.docs.examples[/[0-9]+/].index['@toggle'] = toggle ;


exports.docs.examples[/[0-9]+/].detail = function docs_examples_numeric_detail(req, res){
	return res.ready() ;
} ;
exports.docs.examples[/[0-9]+/].detail.index = function docs_examples_numeric_detail_index(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_choose_item.jade' ;
		res.userData.urljson = 'json/section_item' ;
		res.userData.parameters = {response:res} ;
	}
	return res ;
} ;
exports.docs.examples[/[0-9]+/].detail.index['@focus'] = focus ;
exports.docs.examples[/[0-9]+/].detail.index['@toggle'] = toggle ;

exports.docs.examples[/[0-9]+/].detail[/[0-9]+/] = function docs_examples_numeric_deep(req, res){
	return res.ready() ;
} ;
exports.docs.examples[/[0-9]+/].detail[/[0-9]+/].index = function docs_examples_numeric_deep_index(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_item.jade' ;
		res.userData.urljson = 'json/section_item' ;
		res.userData.parameters = {response:res} ;
	}
	return res ;
} ;
exports.docs.examples[/[0-9]+/].detail[/[0-9]+/].index['@focus'] = focus ;
exports.docs.examples[/[0-9]+/].detail[/[0-9]+/].index['@toggle'] = toggle ;

/////////// DOWNLOAD
exports.download = function download(req, res){
	if(res.opening){
		res.userData.urljade = '/jade/hanja/section_item.jade' ;
		res.userData.urljson = 'json/section' ;
		res.userData.parameters = {response:res} ;
	}else{
		
	}
	return res ;
} ;
exports.download['@focus'] = focus ;
exports.download['@toggle'] = toggle ;
