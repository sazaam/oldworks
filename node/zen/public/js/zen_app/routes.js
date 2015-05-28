
// what steps are going to do graphically , extracted from './graphics.js'
// on toggle (both opening / closing) and focus events

var graphics = require('./graphics') ;
var toggle = graphics.toggle ;
var focus = graphics.focus ;


// hierarchy sections descriptor object written as in 'exports' object

/////////// HOME
exports.home = function home(req, res){
	return res ;
} ;
exports.home['@toggle'] = toggle ;
exports.home['@focus'] = focus ;

/////////// ROOMS
exports.zen = function zen(req, res){
	return res ;
} ;
exports.zen['@toggle'] = toggle ;
exports.zen['@focus'] = focus ;

/////////// ROOMS
exports.rooms = function rooms(req, res){
	return res ;
} ;
exports.rooms['@toggle'] = toggle ;
exports.rooms['@focus'] = focus ;

/////////// BOOKING
exports.booking = function booking(req, res){
	return res ;
} ;
exports.booking['@toggle'] = toggle ;
exports.booking['@focus'] = focus ;

/////////// MAP
exports.map = function map(req, res){
	return res ;
} ;
exports.map['@toggle'] = toggle ;
exports.map['@focus'] = focus ;
