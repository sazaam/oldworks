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
	import flash.events.Event;
	import flash.utils.Dictionary;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.control.events.EventsRegisterer;
	import naja.model.control.loading.GraphicalLoader;
	import naja.model.control.resize.StageResizer;
	import naja.model.data.loadings.AllLoader;
	import naja.model.Root;
	import naja.tools.steps.VirtualSteps;
	
	/**
	 * The XModule class is part of the Naja X API.
	 * 
	 * @see	naja.model.Root
	 * @see	naja.model.XData
	 * @see	naja.model.XUser
	 * @see	naja.model.XModel
	 * @see	naja.model.control.context.Context
	 * @see	naja.model.control.dialog.ExternalDialoger
	 * @see	naja.model.control.events.EventsRegisterer
	 * @see	naja.model.control.loading.GraphicalLoader
	 * @see	naja.model.data.loadings.AllLoader
	 * @see	naja.model.control.resize.StageResizer
	 * @see	boa.core.evt.Query
	 * 
     * @version 1.0.0
	 */
	
	public class XModule extends XBaseModule
	{
//////////////////////////////////////////////////////// VARS
		private var __stepsOpen:VirtualSteps;
		static private var __instance:XModule;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs an XModule
		 * @param source
		 */	
		public function XModule() 
		{
			super() ;
			__instance = this ;
		}
		//////////////////////////////////////////////////////// CTOR
		/**
		 * Inits along XModel, create principal helpers
		 * such as :
		 *  - Context
		 *  - GraphicalLoader
		 *  - EventsRegisterer
		 *  - StageResizer
		 *  - ExternalDialoger
		 * @param model XModel
		 * @return XModule
		 */	
		public function initialize(model:XModel):XModule
		{
			__stepsOpen = Root.user.customizer.gates["open"] ;
			super.init(model) ;
			return this ;
		}
		public function load():void
		{
			super.loadBase() ;
		}
		public function open():void
		{
			super.openSite() ;
		}
		///////////////////////////////////////////////////////////////////////////////// GETTER & SETTERS
		static public function initialize(model:XModel):XModule	{ return instance.initialize(model) }
		static public function get instance():XModule { return __instance || new XModule() }
		static public function set instance(value:XModule):void { __instance = value }
		static public function get hasInstance():Boolean { return Boolean(__instance as XModule) }
	}
}