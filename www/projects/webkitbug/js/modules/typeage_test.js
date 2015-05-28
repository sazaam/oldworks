
var Sazaam = Type.inherit('js.utils::Sazaam', {
	statics:{
		initialize:function initialize(domain){
			trace('initializing ' ,  Sazaam, domain)
		}
	},
	constructor:function Sazaam(ind){
		trace(ind)
		trace(this)
	},
	fuckit:function fuckit(){
		trace('Fuck It !!!')
	}
}) ;

var Smart = Type.inherit('js.utils::Smart', {
	constructor:function Smart(ind){
		Smart.base.apply(this, [ind]) ;
		this.fuckit() ;
	}
}, Sazaam) ;

var SmartAss = Type.inherit('js.utils::SmartAss', {
	constructor:function SmartAss(ind){
		this.fuckit() ;
	},
	fuckit:function(){
		trace('toto fucked it too...')
	},
	cinit:function cinit(domain){
		trace('INITIALIZING PROTOTYPE', SmartAss, domain)
	}
}, undefined, [Sazaam]) ;

var saz = new Sazaam(45) ;
var abs = new Smart(22) ;
var toto = new SmartAss(22) ;

trace(Type.getDefinitionByName(Type.getType(saz)))
trace(Type.getConstructorName(saz))

trace(abs instanceof Object)
trace(abs instanceof Smart)
trace(abs instanceof Sazaam)
trace(saz instanceof Smart)

trace(Type.getType(saz))
trace(Type.getType(abs))

// trace(Smart.prototype)
// trace(Smart.prototype.constructor.prototype)