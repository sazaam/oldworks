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

package naja.tools.commands.I
{
	
	/**
	 * The ICommands interface is part of the Naja Commands API.
	 * 
	 * @see	naja.tools.commands.CommandQueue
	 * @see	naja.tools.commands.Commands
	 * 
     * @version 1.0.0
	 */
	
	public interface ICommands
	{
		/**
		 * Adds a command to the internal commamd Array
		 * 
		 * @param	command ICommand
		 * @return ICommands
		 */
		function add(command:ICommand):ICommands ;
		/**
		 * Removes a command to the internal commamd Array
		 * 
		 * @param	command ICommand
		 * @return ICommands
		 */
		function remove(command:ICommand):ICommands ;
	}
	
}