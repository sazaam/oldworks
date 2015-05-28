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
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.text.TextField;
	import naja.model.control.context.Context;
	
	/**
	 * The XDisplayer class is part of the Naja X API.
	 * 
	 * @see	naja.model.XModel
	 * @see	naja.model.control.context.Context
	 * @see	boa.core.x.base.Base
	 * 
     * @version 1.0.0
	 */
	
	public class XDisplayer
	{
//////////////////////////////////////////////////////// VARS
		private var __target:DisplayObjectContainer ;
		private var __stage:Stage ;
		private var __debug:TextField ;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs an XDisplayer
		 */	
		public function XDisplayer() 
		{
			//trace("CTOR > " + this)
			__target = DisplayObjectContainer(Root.root) ;
			__stage = __target.stage ;
		}
		///////////////////////////////////////////////////////////////////////////////// INITDEBUG
		/**
		 * Inits & generates debug textField, from an XML
		 * @param xml XML this XML must be formatted to fit NAJA's AS3Query ONLY !!!
		 * --> asSist.as3Query
		 * TextField in XML should be formatted this way
		<flash.text.TextField gridFitType="subpixel" sharpness="200" thickness="400" antiAliasType="advanced" alpha=".55" selectable="false" x="2" y="2" autoSize="left" multiline="true" kerning="true">
			<defaultTextFormat>
				<flash.text.TextFormat font="Arial" letterSpacing="1" align="left" size="8" bold="false"  color="0x000000" />
			</defaultTextFormat>
		</flash.text.TextField>
		 * 
		 * @return TextField
		 */
		public function initDebug(xml:XML):TextField
		{
			__debug = TextField(Context.$get(xml.*[0]).appendTo(__target)[0]) ;
			return __debug ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get target():DisplayObjectContainer { return __target }
		public function get stage():Stage { return __stage }
		
		public function get debug():TextField { return __debug }
		public function set debug(_debug:TextField):void
		{ __debug = _debug }
	}
}