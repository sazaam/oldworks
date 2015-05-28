function ci(){console.info.apply(null,arguments)}
function cl(){console.log.apply(null,arguments)}
function cg(args){console.group.apply(arguments)}
function cge(args){console.groupEnd.apply(arguments)}

function InterDecimal(n){
	this.detectNumber = function(number){
		return (typeof number == 'number') ;
	}
	this.split = String(n).split('.') ;
	this.int = Number(this.split[0]) ;
	this.float = Number(this.split[1]) || NaN ;
	this.makeSafeInt = function(){
		return Number(this.split.join('')) ;
	}
	this.safe = this.makeSafeInt() ;
	this.detectDecimal = function(i){
		if(!this.detectNumber(i))
		return (n != n.safe)
		else return n!= new InterDecimal(n).safe ;
	}
	this.isDecimal = this.detectDecimal(this) ;
	this.getExp = function(id){
		return id.isDecimal ? String(id.float).length : 0 ;
	}
	this.exp = this.getExp(this) ;
	this.powTen = function(e, alreadyModified){
		if(this.isDecimal){
			var safe = this.safe ;
			var ind = alreadyModified ? e+e.this.exp : e ;
			var s = String(this.safe).split('') ;
			cl(s) ;
			cl(Number(s.slice(0,ind).concat(['.']).concat(s.slice(ind)).join('')))
			return Number(s.slice(0,ind).concat(['.']).concat(s.slice(ind)).join('')) ;
		}
		else {
			return this.int * Math.pow(10, e) ;
		}
	}
	this.pow = function(m, e){
		if(m == 10){
			if(this.isDecimal){
				return this.id.powTen(e, true) ;
			}
		}else{
			return this.num * Math.pow(m, e) ;
		}
	}
	this.format = function(n, e){
		if(!n) return this.powTen(e) ;
		if(!this.detectNumber(n)){
			if(n.isDecimal){
				return n.powTen(e) ;
			}else {
				return Number(n.int)*Math.pow(10, e) ;
			}
		}else{
		//	est à considérer en tant que chiffre
			if(this.detectDecimal(n)){
				//
			}
		}
		
	}
	this.multiply = function(){
		
		
	}
}
function Decimal(num){
	this.num = num ;
	this.id = new InterDecimal(num) ;
	for(var i in this.id)
	{
		this[i] = this.id[i] ;
	}
}




cg() ;

// cl(new Decimal(12345).pow(10, -5)) ;
var n = 2000.123456 ;
cl(n)
var safe = new Decimal(n).safe
// cl("SAFE >>>   ", safe) ;
cl("FORMAT >>>   ", new Decimal(n).format(new Decimal(.1501),2)) ;
cl("FORMAT >>>   ", new Decimal(n).format(null,2)) ;
// cl("POW TEN >>>   ", new Decimal(n).pow(10,6)) ;
// cl("POW TEN >>>   ", new Decimal(n).pow(10,-6)) ;
// cl("POW TEN >>>   ", n * Math.pow(10,6)) ;
// cl("POW TEN >>>   ", new Decimal(n).pow(10,-6)) ;



cge()
