/*
Instanciate properly
*/
// var express = require('express')
	// , models = require('./models')
	// , config = require('./config')
	// , routes = require('./routes')
	//, environments = require('./environments')
	//, errors = require('./errors')
	//, hooks = require('./hooks')

	
require('naja.js') ;
require('betweenjs.js') ;
require('nodelessjade.js') ;

var app = require('WebApp') ;
var unique = require('./steps.js') ;



// PAGE LOAD

module.exports = function () {
	//console.clear() ;
	trace('APP START', app) ;
	// INITIALIZE ALL
	app
		.address({
			home:'home/',
			base:location.protocol + '//'+ location.host + location.pathname,
			useLocale:true
		})
		.uniquestep(unique) ;
	
	
	// Load Mongoose Models
	// models(app) ;
	
	// Load Expressjs config
	// config(app) ;
	
	// Load Environmental Settings
	//environments(app) ;
	// Load routes config
	
	// routes(app) ;
	// Load error routes + pages
	//errors(app) ;
	// Load hooks
	//hooks(app) ;

	return app ;

}