
/*
 * GET Naver API requests
 */




var request = require('request') ;

// app.use('/api', function(req, res) {
  // url = apiUrl + req.url;
  
// });

exports.index = function(req, res){
	
	// console.log(req.app) ;
	
	// req.app.post('http://hanja.naver.com/ac?search=' +req.query.query, function(req, res) {
		// console.log(res) ;
		
	// }) ;
	
	// var uri = req.query.path + '?query=' + req.query.query + '&key=c1b406b32dbbbbeee5f2a36ddc14067f';
	// var uri = req.query.path + '?query=' + req.query.query + '&target=' + req.query.target + '&key=c1b406b32dbbbbeee5f2a36ddc14067f' ;
	var uri = "http://jpdic.naver.com/search_word.nhn?query=" + req.query.query ;
	
	
	
	console.log(uri) ;
	
	req.pipe( request( uri ) ).pipe( res ) ;
	
	// res.send('<h3>NAVER API REQUESTING<h3/>' + req.query.query) ;
	
} ;
