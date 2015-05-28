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
	import naja.model.data.loadings.loaders.DefaultLoaderGraphics;
	import naja.model.data.loadings.loaders.I.ILoaderGraphics;
	import naja.tools.steps.VirtualSteps;
	
	/**
	 * The XModel class is part of the Naja X API.
	 * 
	 * @see	naja.model.Root
	 * @see	naja.model.XData
	 * @see	naja.model.XUser
	 * @see	naja.model.XModule
	 * @see	naja.tools.steps.VirtualSteps
	 * @see	boa.core.x.base.Base
	 * 
     * @version 1.0.0
	 */
	
	dynamic public class XModel
	{
//////////////////////////////////////////////////////// VARS
		private var __data:XData ;
		private var __module:XModule ;
		private var __config:XML ;
		private var __params:XML ;
		private var __elements:XML ;
		private var __sections:XML ;
		private var __scripts:XML ;
		private var __libraries:XML ;
		private var __links:XML ;
		private var __uniqueSteps:VirtualSteps ;
		static private var __instance:XModel ;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs an XModel
		 */	
		public function XModel() 
		{
			__instance = this ;
		}
		
		private function init():XModel
		{
			__data = new XData() ;
			__uniqueSteps = user.customizer ;
			__module = XModule.initialize(this) ;
			return this ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get data():XData { return __data }
		public function get user():XUser { return Root.user }
		public function get module():XModule { return __module }
		public function get config():XML { return __config }
		public function set config(value:XML ):void
		{ __config = value }
		
		static public function init():XModel	{ return instance.init() }
		static public function get instance():XModel { return __instance || new XModel() }
		static public function get hasInstance():Boolean { return Boolean(__instance as XModel) }
	}
}