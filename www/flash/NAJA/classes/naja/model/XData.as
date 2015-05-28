
	/*
	 * Version 1.0.0
	 * Copyright BOA 2009
	 * 
	 * 
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      3SSSSS



                    SSSSS                      ASSSSSS                                     SSSSSSA                 3ASSSSSS
        ASSSS    SSSSSSSSSSS               SSSSSSSSSSSSSSS            3SSSSS          3SSSSSSSSSSSSSS         S3SSSS SA3 3 SA3S
        ASSSS  SSSSSSSSSSSSSSS           SSSSSSSSSSSSSSSSSS           3SSSSS        SSSSSSSSSSSSSSSSSSS     SSS3SSSSSSSS3 SS S33
        ASSSS3SSSSSSA3SSSSSSSSS         SSSSSSS3    3SSSSSSS          3SSSSS        SSSSSSS     SSSSSSSS   A3ASS3SSSSSSSSASSSSSAS
        ASSSSSSSS        SSSSSS         SSS            SSSSSS         3SSSSS        SSS            SSSSS3 3SSSSSSSSSSSASA    33
        ASSSSSSS          SSSSSS                        SSSSS         3SSSSS                       SSSSSS 33SSSSSS3SSSSA
        ASSSSS             SSSSS                        SSSSS         3SSSSS                        SSSSSSS SSSSSSS3AS
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSSSSSSS 33SS3A3
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSS3SSSSSSSSSSSS
        ASSSSS             SSSSS               SSSSSSSSSSSSSS3        3SSSSS              3SSSSSSSSSSSSSSSASS SSSS
        ASSSSS             SSSSS           SSSSSSSSSSSSSSSSSS3        3SSSSS          3SSSSSSSSSSSSSSSSSSSSS3 SSSSSS3
        ASSSSS             SSSSS         SSSSSSSSSSSSSSSSSSSS3        3SSSSS        3SSSSSSSSSSSSSSSSSSSSSSS 3SSS 33
        ASSSSS             SSSSS        SSSSSS          SSSSS3        3SSSSS       SSSSSSS          SSSSSSSS   SSSS
        ASSSSS             SSSSS       SSSSSS           SSSSS3        3SSSSS       SSSSS            SSSSSS   3 SSS3
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      ASSSSS            SSSSSSA   A AA
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      SSSSSS            SSSSSS  ASA3S
        ASSSSS             SSSSS       SSSSS           SSSSSS3        3SSSSS      ASSSSS           SSSSSSS    3AS
        ASSSSS             SSSSS       SSSSSS        SSSSSSSS3        3SSSSS       SSSSSS        SSSSSSSSS    3A
        ASSSSS             SSSSS        SSSSSSSSSSSSSSSSSSSSS3        3SSSSS       ASSSSSSSSSSSSSSSSSSSSSS    S
        ASSSSS             SSSSS         SSSSSSSSSSSSSS  SSSS3        3SSSSS         SSSSSSSSSSSSSS 3SSSS
        3SSSS3             SSSSS           SSSSSSSSSS    SSSS         3SSSSS           SSSSSSSSSA    SSSS    A
                                                                      3SSSSS                             A  S
                                                                      ASSSSS                               3
                                                                      SSSSSA
                                                                      SSSSS
                                                                SSSSSSSSSSS
                                                                SSSSSSSSSS
                                                                SSSSSSSSA
                                                                   33
	 
	 * 
	 * 
	 *  
	 */

package naja.model 
{
	import flash.utils.Dictionary;
	import naja.model.control.context.Context;
	import naja.model.data.loadings.LoadedData;
	import naja.tools.lists.Gates;
	import naja.tools.lists.Compare;
	
	import naja.dns.naja_local;
	
	/**
	 * The XData class is part of the Naja X API.
	 * 
	 * @see	naja.model.XUser
	 * @see	naja.model.XModel
	 * @see	naja.model.XModule
	 * 
     * @version 1.0.0
	 */
	
	dynamic public class XData
	{
//////////////////////////////////////////////////////// VARS
		use namespace naja_local;
		naja_local var __events:Gates 							= new Gates() ;
		naja_local var __links:Object 							= { } ;
		naja_local var __loaded:Dictionary 					= new Dictionary() ;
		naja_local var __objects:Gates 							= new Gates() ;
		public static var compareArrays:Function 			= Compare.compareArrays ;
		public static var compareObjects:Function 			= Compare.compareObjects ;
		public static var copyDict:Function 					= Compare.copyDict;
		public static var copyObject:Function 				= Compare.copyObject;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs an XData
		 */	
		public function XData() 
		{
			////trace("CTOR > " + this) ;
		}
		///////////////////////////////////////////////////////////////////////////////// COMPAREDATAS
		/**
		 * Compares two XData Objects in terms of 'equality'.
		 * 
		 * @param x XData - First XData object to compare
		 * @param y XData - Second XData object to compare
		 * @return Boolean - the result of the check, if true, XData objects are equal.
		 */	
		public static function compareDatas(x:XData, y:XData):Boolean
		{
			if(!y.naja_local::__events) {
				if (x.naja_local::__events) return false ;
			}
			if(!y.naja_local::__objects) {
				if (x.naja_local::__objects) return false ;
			}
			if(!y.naja_local::__links) {
				if (x.naja_local::__links) return false ;
			}
			if(!y.naja_local::__loaded) {
				if (x.naja_local::__loaded) return false ;
			}
			if (!y.naja_local::__events.equals(x.naja_local::__events)) return false ;
			if (!y.naja_local::__objects.equals(x.naja_local::__objects)) return false ;
			return true ;
		}
		///////////////////////////////////////////////////////////////////////////////// GENERATE
		/**
		 * Self-generates an Object, that will represent the content of an XML, 
		 * and will be accessible with the name of the localName() of xml's containing node
		 * 
		 * @param xml XML - the source XML
		 */	
		public function generate(xml:XML):void
		{
			this[xml.localName()] = createFromXML(xml) ;
		}
		///////////////////////////////////////////////////////////////////////////////// CREATEFROMXML
		/**
		 * Creates an Object from an XML, recursively and based on the localName() of the nodes the reading playhead meets.
		 * 
		 * @param xml XML - the source XML
		 */	
		public static function createFromXML(xml:XML):Object
		{
			var o:Object = { } ;
			var localName:String = xml.localName() ;
			o.localName = function():String { return localName } ;
			
			for each(var child:XML in xml.*) {
				var ref:String = child.@id.toXMLString() || String(child.childIndex()) ;
				var p:Object = { } ;
				for each(var attr:XML in child.attributes()) {
					p[attr.localName()] = attr.toXMLString() ;
				}
				for each(var ch:XML in child.*) {
					var l:String = ch.localName() ;
					if (Boolean(p[l])) {
						trace("!!! Overwriting over an attribute... XData")
					}else {
						p[l] = ch.toXMLString() ;
					}
				}
				o[ref] = p ;
			}
			return o ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get events():Gates { return __events }
		public function set events(value:Gates):void 
		{ __events = value }
		public function get loaded():Dictionary { return __loaded }
		public function set loaded(d:Dictionary) 
		{ __loaded = d }
		public function get objects():Gates { return __objects }
		public function set objects(value:Gates):void 
		{ __objects = value }
	}
}