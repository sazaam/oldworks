package {
	
	import flash.display.Sprite;
	import flash.display.BitmapData
	import flash.events.Event;
		import flash.system.ApplicationDomain;
		import flash.utils.getDefinitionByName;
		import modules.foundation.Type; 

		
		
		
	import modules.coreData.geoms.Box;
	import modules.coreData.geoms.ColorData;
	import modules.coreData.geoms.Dimension;
	import modules.coreData.geoms.Location;
	import modules.coreData.geoms.MatrixData;
	import modules.coreData.views.CoreBitmapData;
	import modules.foundation.Type;
	import modules.foundation.events.ModuleEventDispatcher;
	import modules.foundation.langs.JSType;
	import modules.patterns.Singleton;
	import modules.patterns.Creation;
	import modules.patterns.proxies.DynamicProxy;
	import modules.patterns.proxies.Handler;
	import saz.helpers.core.toClass;
	
	public class Test extends Sprite 
	{
		
		public var dispatcher:ModuleEventDispatcher;
		public var proxy:DynamicProxy;
		
		public function Test()
		{
			trace('Instanciation :', this);
			proxy = DynamicProxy.getProxyInstance(new Handler(new ModuleEventDispatcher(this)));
			proxy.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
/*
			trace("Dimension __________________________________");
			
			var d0:Dimension = new Dimension(new XML("<instance><type class='modules.coreData.geoms.Dimension' width='800' height='800'/></instance>"));
			var d1:Dimension = new Dimension({width:200, height:400});
			var d2:Dimension = new Dimension(d0);
			var d3:Dimension = d0.clone() as Dimension;
			trace(d0);
			trace(d1);
			trace(d2);
			trace(d3);
			
			trace("ColorData __________________________________");
			
			var col0:ColorData = new ColorData(new XML("<instance><type class='modules.coreData.geoms.ColorData' red='255' blue='125' green='25'/></instance>"));
			var col1:ColorData = new ColorData({red:200, green:45, blue:125});
			var col2:ColorData = new ColorData(col0);
			var col3:ColorData = col0.clone() as ColorData;
			trace(col0);
			trace(col1);
			trace(col2);
			trace(col3);
			
			trace("Location __________________________________");
			
			var loc0:Location = new Location(new XML("<instance><type class='modules.coreData.geoms.Location' x='255' y='125'/></instance>"));
			var loc1:Location = new Location({x:200, y:45});
			var loc2:Location = new Location(loc0);
			var loc3:Location = loc2.clone() as Location;	
			//trace(loc0);
			//trace(loc1);
			//trace(loc2);
			trace(loc3);
			
			trace("Box __________________________________");
			
			var box0:Box = new Box(new XML("<instance><type class='modules.coreData.geoms.Box' x='255' y='125' width='100' height='100'/></instance>"));
			var box1:Box = new Box({x:200, y:45, width:345, height:500});
			var box2:Box = new Box(box1);
			var box3:Box = box0.clone() as Box;
			//trace(box0);
			//trace(box1);
			//trace(box2);
			trace(box3);
			
			trace("MatrixData __________________________________");
			
			var matrix0:MatrixData = new MatrixData(new XML("<instance><type class='modules.coreData.geoms.MatrixData' a='1' b='1' c='1' d='1' tx='1' ty='1'/></instance>"));
			var matrix1:MatrixData = new MatrixData({a:1, b:1, c:0, d:0});
			var matrix2:MatrixData = new MatrixData(matrix1);
			var matrix3:MatrixData = matrix0.clone() as MatrixData;
			trace(matrix3);			
*/			

            /*
			var Test:Function = function(s:String):void
			{
				this.print = function(s:String):void
				{
					trace(s);
				}
				this.print(s);
			}
			var SubClass:Function = JSType.promote().extend(Test);
			var instance:Object = new SubClass("blaaaaa");
			
			var created1:Creation = Singleton.getInstance(Creation) as Creation;
			var created2:Creation = Singleton.getInstance(Creation) as Creation;			
			trace("created1 : ", created1, created2);
			trace("equals : ", created1 === created2);
			*/
			
			
			//
			
			
			//trace(toClass(new BitmapData(100,100))) ;
			
			//trace() ;
			//trace(getDefinitionByName("BitmapData")) ;
			
			//<instance><toto controler="new saz.geeks.Appear(new CoreBitmap(),15,"sazaam")" />
			//var pattern:* = ;
			//var regExp:RegExp = new RegExp(pattern) ;
			
			
			
			var s:String = "new saz.helpers.Sazaam(new flash.display.BitmapData(0x0,100,100),szzef,new flash.display.BitmapData(),new flash.display.BitmapData(0x0,new flash.display.Sprite(function(el:Sprite){trace(caca)},100),pierre)" ;
			//var s:String = "function(prout){trace(new Index() ;)}"
			
			//   check if starts by a className
			/*
			if(s.search(/^ ?new /) !=-1)
			{
				var fullClassNamePattern:RegExp = /(?<=new )(\w)+([.](\w)+)+[^(](?=\((.*)\))/i ;
				var fullClassName:String = fullClassNamePattern.exec(s)[0] ;
				var params:String = fullClassNamePattern.exec(s)[4] ;
				var simpleParams:String = params.match(/new [\w.]+\((?:[^()]++|\((?R)*\))*\)/gi).join(',') ;
				var levelOneParams:String = params.match(/new [\w.]+\(((?:[^()]++|\((?R)*\)))?\)/gi).join(',') ;
				
				trace(levelOneParams) ;
				
				//var p:Array = params.match(/[\w\d\s.]+/gi) ;
				//var p:Array = params.match(/([\w\d.;{}\s]+[^()]|ptoujk)/gi) ;
				//var reg:RegExp = /(?:[^()]+|\((?R)\))/gi ;
				var reg:RegExp = /(?:new [\w.]+\(((?:[^()]++|\((?R)\)))?\)|function\([\w\d:]*\)\{(?:[^{}]++|\{(?R)\})\})/gi ;
				var p:Array = params.match(reg) ;
				
				var resultP:Array = [] ;
				p.forEach(function(el:String,i:int,arr:Array):void{
					trace(i,"  :  ",el) ;
				})
				//var ps:String = params.replace(reg,"") ;
				//trace(ps)
				
				
				
				
			}
			*/
						
			
			/*
			//trace(s.indexOf("new")) ;
			//trace(s.match(new RegExp("new ","gi"))) ;
			var paramsToString:String = s.match(/(?<=[(]).*[^)]/g)[0] ;
			//var params:Array = paramsToString.match(/((?<=[(])+[^,]+(?![)]),)/g) ;
			//var params:Array = paramsToString.match(/((?=[^ 0-9A-Z,])([^)]|(?<=[(])[^)])+)/g) ;			
			
			var params:Array = paramsToString.match(/[)]+/g) ;			
			
			
			//var params:Array = paramsToString.match(/(condParentheseOuverte && condVirguleAvant ==> juska parentheses )(condpas parentheses ==> juska virgule)+/gi) ;

			//var params:Array = paramsToString.match(/(?=[^ 0-9A-Z])[^,)]+/g) ;
			trace(paramsToString)
			params.forEach(function(el,i,arr):void{trace(i,"  :  ",el)})
			*/
			//trace("PARAMS  : " + params) ;
			//trace(s.match(/new [^)]*/g)) ;
			
			/*OLD TEST*/
			
			
			var s:String = "new saz.helpers.Sazaam(new flash.display.BitmapData(0x0,100,100),szzef,new flash.display.BitmapData(),pierre)" ;
			
			//   check if starts by a className
			var fullClassNamePattern:RegExp = /(?<=new )(\w)+([.](\w)+)+[^(]/gi ;
			//var fullClassNameSearch:int = s.search(fullClassNamePattern) ;
			//var fullClassNamed:Boolean = Boolean(fullClassNameSearch!=-1);
			var result = fullClassNamePattern.exec(s) ;
			if(result is Object){
                var fullClassName = String(result[0]) ;
                trace("FULL CLASSNAME : "+fullClassName) ;
                //  get multi-classnames
                //trace(s.match(fullClassNamePattern)) ;
                
                //  get params
                var paramsPattern:RegExp = /(?<=[(])[\w\d ,.(){}]+(?=[)])/gi ;
                var resultParams:Object = paramsPattern.exec(s) ;
                var params:String = resultParams[0] ;
                trace("PARAMETERS :" +params) ;
                
                var paramsArrayPattern:RegExp = /([\w\d .{}()]+([(]([\w\d ,.]*([\w\d,.(){}])*)[)])?)/gi ;
                //var parameters:Array = paramsArrayPattern.exec(params) ;
                var parameters:Array = params.match(paramsArrayPattern) ;
                //trace(params.match(paramsArrayPattern)) ;
    			var realParams:Array = [] ;
    			var currentParam:String = "" ;
    			parameters.forEach(function(el:String,i:int,arr:Array):void{
                    trace(i,"  :  ",el) ;
                    //currentParam += (currentParam == "") ? el : ","+el ;
                    //trace("YO :"+currentParam) ;
                    //if(el.charAt(el.length-1)==")"){
                        //trace(currentParam)
                        //realParams.push(currentParam) ;
                        //currentParam = "" ; 
                    //}else{
                        //if(params.lastIndexOf(currentParam) == params.length-(currentParam.length))
                    //}
                    
    			})
    			
    		
    			
    			
    			//trace("======================= RESULTS ===================")
                //realParams.forEach(function(el:String,i:int,arr:Array):void{
                  //  trace(i,"  :  ",el) ;
                //})
                
			}
			
			
			
			
		}
		
	}
}
