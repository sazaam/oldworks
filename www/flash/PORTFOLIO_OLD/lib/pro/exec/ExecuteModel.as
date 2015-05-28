package pro.exec 
{
	import of.app.Root;
	/**
	 * ...
	 * @author saz
	 */
	public class ExecuteModel 
	{
		
		public function ExecuteModel() 
		{
			sectionsXML = Root.user.data.loaded['XML']["sections"] ;
			simpleNavLogoXML = Root.user.data.loaded['XML']["elements"].child('svgs').*[0] ;
			simpleNavXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[0] ;
		}
		public var minFrame:Object = {
			id:'minFrame',
			width : 650,
			height : 550
		}
		public var frame:Object = {
			id:'frame',
			width : 850,
			height : 550,
			arrows: {
				margin:20,
				size:50,
				color:0x2A2A2A,
				colorOver:0xFF0000,
				left: {
					id:'arrow_left'
				},
				right: {
					id:'arrow_right'
				}
			}
		}
		public var simpleNav:Object = {
			id:'simpleNav',
			x:40,
			y: -10,
			margin:20,
			item: {
				name:'simpleNav_item_',
				tf: { 
					name:'simpleNav_item_TF_',
					color:'0x2A2A2A',
					colorOver:'0xFF0000'
				}
			},
			logo: {
				id:'logo',
				width:34,
				height:30,
				shoeX:3,
				shoeY:2
			}
		}
		public var spaceNav:Object = {
			id:'spaceNav'
		}
		public var simpleNavXML:XML;
		public var sectionsXML:XML;
		public var simpleNavLogoXML:XML;
	}

}