function ci(){console.info.apply(null,arguments)}
function cl(){console.log.apply(null,arguments)}
function cg(args){console.group.apply(arguments)}
function cge(args){console.groupEnd.apply(arguments)}

function Decimal(num){
    this.entry = num
    if(typeof num == 'number')
        num = String(num) ;
    this.num = new InterDecimal(num) ;
	
    this.internalFormat = function(){
        var arr = this.num.internalFormat() ;
        return arr[0]*Math.pow(10,-arr[1]) ;
    }
    this.calc = function(n1, n2, e){
        var str;
        str = this.format(n1, n2) ;
		if(!e) return str ;
        return str*Math.pow(10,-e) ;
    }
	this.format = function(n1, n2){
		if(n2 == '') return Number(n1) ;
		return Number(n1+'.'+n2)
	}
    this.substract = function(dec){
        cl("fuck >> ",this.entry - dec.entry)
        var sign = this.num.int < dec.num.int ? 1 : -1 ;
        var int1 = this.num.int ;
        var int2 = dec.num.int ;
        var float1 = this.num.float ;
        var float2 = dec.num.float ;
		var s1 = float1 ;
		var s2 = float2 ;
		var s3 = s1*Math.pow(10, s1.length) + (sign*s2*Math.pow(10, s2.length)) ;
		var exp = String(s3).length ;
        var resFloat = s3*Math.pow(10, -exp) ;
		var l = String(s3).length ;
		
        return this.calc(int1-int2,s3) ;
    }
    this.multiply = function(dec){
        cl("fuck >> ",this.entry * dec.entry)
        var arr1 = this.num.internalFormat() ;
        var arr2 = dec.num.internalFormat() ;
        var sign = this.num.sign*dec.num.sign ;
        var int1 = this.num.int ;
        var int2 = dec.num.int ;
        
        var float1 = this.num.float ;
        var float2 = dec.num.float ;

        var longer = float1.length > float2.length ? arr1 : arr2 ;

        var exp = longer [1] ;
        
        return this.calc(int1 * int2+(sign*float1*(float2*Math.pow(10,-dec.num.exp))),'', 0)
        // return this.calc(int1 * int2+(sign*float1*(float2*Math.pow(10,-dec.num.exp))),'', 0)
    }

    cl("int >>",this.num.int, "   float >>",this.num.float, "   exp >>", this.num.exp)
}

function InterDecimal(num){
    var reps = num.split('.') ;
    this.int = reps[0] ;
    this.float = reps[1] || '' ;
    this.getExp = function(){
        return this.float.length ;
    }
    this.getSign = function(){
        return this.int > 0 ? 1 : -1 ;
    }
    this.sign = this.getSign() ;
    this.exp = this.getExp() ;
    this.internalFormat = function(){
        return [this.int + this.float, this.exp] ;
    }
}

cg() ;
//ci(2.12345)
//ci(0.00136*Math.pow(10,5))
//ci(0.00136*Math.pow(10,5)*Math.pow(10,-5))

//    TESTS FORMAT
cl(2.12345, ">>>>", new Decimal(2.12345).internalFormat())
cl(2, ">>>>", new Decimal(2).internalFormat())
cl(0.000002, ">>>>", new Decimal(0.000002).internalFormat())
cl(.000002, ">>>>", new Decimal(.000002).internalFormat())
cl(4000.0500, ">>>>", new Decimal(4000.0500).internalFormat())
cl('00040', ">>>>", new Decimal('00040').internalFormat())
cl(.400, ">>>>", new Decimal(.400).internalFormat())
cl('.500001', ">>>>", new Decimal('.500001').internalFormat())
cl(.500001, ">>>>", new Decimal(.500001).internalFormat())

cge() ;
cg() ;

cl(new Decimal(500.30).substract(new Decimal(1.100)))

cl(new Decimal(1.2).substract(new Decimal(1.1)))
cl(new Decimal(-1.2).substract(new Decimal(1.1)))

cl(new Decimal(4050.1).multiply(new Decimal(2.001)))
cl(new Decimal(-4050.1).multiply(new Decimal(2.001)))


cge()


