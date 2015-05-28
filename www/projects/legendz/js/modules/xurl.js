trace = console.log ;

var XUrl = (function(){
	var addressreg = /^(((http|ftp)s?:)\/\/([\w\d.-]+(:(\d+))?))?\/(([a-z0-9-]{2,}\/)*)?([#]\/|)?([a-z\/]{2}\/)?([^?]*)([?].+)?$/i ;
	var specialreg = /^[.]*(\/)/ ;
	var doublereg = /[.]{2,}\//g ;
	var slashreg = /^\// ;
	var absreg = /http(s)?:\/\// ;

	var URL = function(str){
		
		var u = this ;
		
		u.go = function(str){
			
			if(!!u.absolute){
				
				if(!specialreg.test(str) && !absreg.test(str)) str = './'+str ;
				if(specialreg.test(str)){
					var t = slashreg.test(str) ? u.originroot : u.absoluteroot ;
					if(doublereg.test(str)){
						str = str.replace(doublereg, function(){
							t = t.replace(/[^\/]+\/$/g, '') ;
							return '' ;
						})
						str = t + '' + str.replace(slashreg, '') ;
					}else{
						str = t + '' + str.replace(specialreg, '') ;
					}
				}else{
					
				}		
			}
			
			if(!absreg.test(str) && !!u.originroot){
				str = u.originroot + str ;
			}
			u.absolute = str ;
				u.path = str.replace(addressreg, function(){
				var $$ = [].slice.call(arguments) ;
				u.base = ($$[1] || '') + '/' ;
				u.protocol = $$[3] || '' ;
				u.host = $$[4] || '' ;
				u.port = $$[6] || '' ;


				u.qs = $$[12] || '' ;
				u.loc = $$[10] || '';
				u.hash = $$[9] || '';
				u.root = ($$[7] || '')  ;
				u.absoluteroot = u.absolute.replace(''+u.path+'', '') ;

				return $$[11] || '' ;
			}) ;
			
		}
		
		u.go(str) ;
		
		u.originroot = u.absoluteroot ;
		
		u.toString = function()
		{
			return this.absolute ;
		}
	}
	
	return function(target){
		switch(true){
			case typeof(target) == 'string' :
				// REMAINS A STRING
			break ;
			case target === undefined :
			case target === window :
				target = window.location.href ;
			break ;
			case !!target.nodeName && target.nodeName == 'A' && !!target.href :
				target = target.href ;
			break ;
		}
		return new URL(target) ;
	};
	
})() ;


