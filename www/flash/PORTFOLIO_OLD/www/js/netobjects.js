// @uthor saz

function objToString(o){
	var str = '' , line = '\n';
	return (function(obj, src){
		for(var i in obj){
			
			var s = '' ;
			if(obj[i] instanceof Array){
				s = '{Array '+ i + line + arguments.callee(obj[i], s) +'}' ;
			}else if(obj[i] instanceof Object){	
				s = '{Object '+ i + line +arguments.callee(obj[i], s)+'}' ;
			}else{
				s = i +':'+obj[i];
			}
			src = src+s + line;
		}
		return src ;
	})(o, str)
}

function dump(o, recursive)
{
	var str = '' ;
	return (function(src, collect) {
		var s = '' ;
		for (var i in src) {
			s += '\n' + i +' >> ' + src[i] ;
			if (recursive) if(Object(src[i]).toString() == '[object Object]') s = arguments.callee(src[i], s) ;
		}
		return collect + s ;
	})(o, str) ;
}

function stringToObj(src)
{
	var RE_ALL = /.+$/mgi ;
	var RE_OPEN = /{( [\w\d]+)?/i ;
	var RE_CLOSE = /}/i ;
	
	var obj = { }, par, id, values, type, arr = src.match(RE_ALL) ;
	var l = arr.length ;
	var cur = obj ;
	
	for(var i = 0 ; i < l ; i++ ){
		var s = arr[i] ;
		if(RE_OPEN.test(s)){
			values = s.split(' ') ;
			type = values[0].replace(/{/,'') ;
			id = values[1];
			par = cur ;
			par[id] = cur = type == 'Array'? [] : {} ;
			cur.parent = par ;
		}else if(RE_CLOSE.test(s)){
			par = cur.parent ;
			cur.parent = null ;
			delete cur.parent ;
			cur = par ;
		}else{
			values = s.split(':') ;
			id = values[0] ;
			if(type == 'Array')
				cur[Number(id)] = values[1] ;
			else
				cur[id] = values[1] ;
		}
	}
	return obj ;
}