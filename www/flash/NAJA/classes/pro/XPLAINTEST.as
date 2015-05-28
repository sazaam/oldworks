package naja 
{
	
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
	
	
	/**
	 * The NAJA Project is a greffon for BOA Packages
	 * 
	 * It is based on a mix of abstract conception, mixed with utility search, in order to please users that would like
	 * to pose basis of any flash app quite fastly.
	 * 
	 * Loadings, Structure, Scopes and Dialogs been resolved so far in a simple way, with a flexibility allowing other coding habits...
	 * 
	 * 
	 * 1 . The need to understand the step functionnality
	 * 
	 * Within some measure, a 'step' is like something that happens in one's system, so actually represents everything that could occur.
	 * Or every logik phase of a plan, every part of a chain in one's development, every chunk of code as well.
	 * A step could also be representing a navigation section of a site, such as HOME or NEWS...
	 * 
	 * So far, since this concept seem regardlessly abstract, it's a good one to be chosen, helping materializing a hierarchy of events
	 * in single units.
	 * 
	 * Concretely a Step could also be a parent of Steps, which could contain respective steps too.
	 * 
	 * So until now, we have the Step dimension, that allows us to represent every event (or pack of events), and the notion
	 * of an unique hierarchy (of course that could be considered as a step, but we always need a first orphan top level !! )
	 * 
	 * The step functionality is interesting since while you think about you're app and develop it later, you'll enjoy at a high level
	 * having put the custom actions in your project and the helpfull basic actions that will re-iter through all one's site, and 
	 * especially from one site to another. 
	 * Meaning the graphics of an interface selled to a John Doe client will never be the same as the one we sold to John Smith, 
	 * but the way you'll load images on independant requests, for example, will be very similar in those two projects.
	 * 
	 * The way you'll store and construct Data, work Bitmaps, initialize PaperVision, etc...
	 * 
	 * The Step system allows you like many others to have independant 'geek/helpers' classes, but the structure of the hierarchy
	 * of the app will always appear clearly, even when at a monstruous level of depth.
	 * It is more like a method to organize what will happen to the visitor thru his visit.
	 * 
	 * A Step is good for everything or almost. A step can contain other Steps.
	 * Once you've connected everyone to everyone your hierarchy is good to go !
	 * and that's it !
	 * But they have particularities we shall examine...
	 * 
	 * - first of all, steps can have actions to execute when reached in hierarchy, is called on Step's 'OPENING'.
	 * - secundo, each Step can have actions to execute when hierarchy is closing them, as in 'CLOSING'.
	 * - finally, since they have the ability to contain other Steps, they can be asked to launch a step or another (from their childs)
	 * BUT will automatically close the last opened step (if there's any) BEFORE even trying to open the asked one.
	 * 
	 * These three rules ensure the Steps work together, when brothers or not, conflictless.
	 * 
	 * 
	 * 
	 * 2 . Why separate custom actions (client's project classes & packages exclusively) from the basic helpfull methods.
	 * 
	 * 3 . A framework way of building
	 * 
	 * 4 . The NAJA pseudo-abstract organization & main characters
	 * 
	 * 5 . FUTURE & PAST : Where is heading NAJA (semi-independantly from BOA) & influences
	 * 
	 * 
	 * 
	 * 
	 * 
     * @version 1.0.0
	 */		
	
	
	public class XPLAINTEST 
	{
		
		public function XPLAINTEST() 
		{
			
		}
		
	}
	
}