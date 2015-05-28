package saz.helpers.core.exec 
{
	
	/**
	 * ...
	 * @author saz
	 */
	
	/*		var added:Array = [] ;
			added.push([SitePathes.toXML + "datas/data_sections.xml", "main_data_sections"]) ;
			added.push([SitePathes.toIMG + "skash/motif.png", "back_motif"]) ;
			added.push([SitePathes.toSWF + "library/arial.swf","Arial",true]) ;
			added.push([SitePathes.toSWF + "library/neo_tech_dacia_regular.swf","NeoTechDaciaRegular",true]) ;
			added.push([SitePathes.toSWF + "library/library_items.swf", "clips"]) ;
			Executer.execute(AllLoader, "add []", added) ;
	 */
	
	
	public class Executer 
	{
		
		static public function execute(refObj:*,__closure:String,argsObj:* = null):*
		{
			if (refObj) {
				var _splitted:Array = __closure.split(" ");
				var s:String = _splitted[0] ;
				var l:int = _splitted.length ;
				switch(l) {
					case 0:
						trace("is null") ;
					break ;
					case 1:
						return $try(refObj,_splitted[0]) ;
						//trace("is one method accessor") ;
					break ;
					case 2:
						var s2:String = _splitted[1] ;
						switch(s2) {
							case '[]' :
								if (!Boolean(argsObj is Array) || (argsObj as Array).length < 1) throw(new ArgumentError("Expecting an Array as third argument")) ;
								var l2:int = (argsObj as Array).length ;
								for ( var i:int = 0 ;  i < l2 ; i++) 
								{
									$try(refObj,_splitted[0]).apply(refObj,[].concat((argsObj as Array)[i])) ;
								}
							break ;
						}
						//trace("is one method accessor") ;
					break ;
				}
			}
		}
		
		static private function $try(o:Object,s:String):*
		{
			try 
			{
				return o[s] ;
			}catch (e:Error)
			{
				throw(e) ;
			}
		}
	}
}