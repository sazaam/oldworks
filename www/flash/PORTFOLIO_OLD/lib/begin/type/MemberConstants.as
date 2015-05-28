package begin.type {

	/**
	 * @author aime
	 */
	public class MemberConstants {
	    /**
	     * Identifies the set of all public members of a class or interface,
	     * including inherited members.
	     * @see java.lang.SecurityManager#checkMemberAccess
	     */
	    public static const PUBLIC:int = 0;
	
	    /**
	     * Identifies the set of declared members of a class or interface.
	     * Inherited members are not included.
	     * @see java.lang.SecurityManager#checkMemberAccess
	     */
	    public static const DECLARED:int = 1;	
	}
}
