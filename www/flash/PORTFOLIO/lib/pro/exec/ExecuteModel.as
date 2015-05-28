package pro.exec 
{
	import flash.display.Bitmap;
	import of.app.Root;
	/**
	 * ...
	 * @author saz
	 */
	public class ExecuteModel 
	{
		
		public function ExecuteModel() 
		{
			// XML
			sectionsXML = Root.user.data.loaded['XML']["sections"] ;
			// XML TEMPLATES
			simpleNavXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[0] ;
			titleTFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[1] ;
			fakeTitleTFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[2] ;
			centerTitleTFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[3] ;
			accrocheTFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[4] ;
			fakeAccrocheTFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[5] ;
			linkTFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[6] ;
			simpleLinkTFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[7] ;
			numberItem_TFXML = Root.user.data.loaded['XML']["elements"].child('textfields').*[8] ;
			layer404_XML = Root.user.data.loaded['XML']["elements"].child('sprites').*[0] ;
			
			
			
			// BMP
			simpleNavLogoPNG = Root.user.data.loaded['IMG']["shoe"] ;
			testPNG = Root.user.data.loaded['IMG']["home"] ;
			screenPNG = Root.user.data.loaded['IMG']["screen"] ;
		}
		public var project:Object = {
			margin : 10,
			tf: {
				color:0xCCCCCC
			}
		}
		public var grid:Object = {
			id:'grid',
			margin : 10,
			rows:3,
			cols:3
		}
		public var selection:Object = {
			thickness:10,
			corner:30
		}
		public var minFrame:Object = {
			id:'minFrame',
			width : 650,
			height : 550
		}
		public var colors:Object = {
			defaultMain:0x555555,
			defaultExtraColorOver:0xC8003e,
			main :0x555555,
			mainOver :0xFFFFFF,
			extra:0x2a2a2a,
			extraOver:0xC8003e
		}
		public var frame:Object = {
			id:'frame',
			width : 850,
			height : 550,
			arrows: {
				margin:20,
				size:50,
				color:0x555555,
				colorOver:0xFFFFFF,
				topWidth:175,
				left: {
					id:'arrow_left'
				},
				right: {
					id:'arrow_right'
				}
			}
		}
		public var depthNav:Object = {
			id:'depthNav',
			item: {
				height:25,
				name:'depthNav_item_',
				tf: { 
					name:'depthNav_item_TF_'
				}
			}
		}
		public var simpleNav:Object = {
			id:'simpleNav',
			x: 0,
			y: 0,
			margin:0,
			item: {
				name:'simpleNav_item_',
				tf: { 
					name:'simpleNav_item_TF_',
					color:0x0,
					colorOver:0xe42322
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
		public var background:Object = {
			id:'background'
		}
		public var all:Object = {
			id:'content'
		}
		public var simpleNavXML:XML;
		public var sectionsXML:XML;
		public var simpleNavLogoXML:XML;
		public var simpleNavLogoPNG:Bitmap;
		public var screenPNG:Bitmap;
		public var testPNG:Bitmap;
		public var titleTFXML:XML;
		public var accrocheTFXML:XML;
		public var fakeTitleTFXML:XML;
		public var centerTitleTFXML:XML;
		public var fakeAccrocheTFXML:XML;
		public var linkTFXML:XML;
		public var simpleLinkTFXML:XML;
		public var numberItem_TFXML:XML;
		public var layer404_XML:XML;
	}
}