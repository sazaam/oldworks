package begin.type {
	/**
	 * Member is an interface that reflects identifying information about
	 * a single member (a field or a method) or a constructor.
	 *
	 * @see	java.lang.Class
	 * @see	Field
	 * @see	Method
	 * @see	Constructor
	 *
	 * @author Nakul Saraiya
	 */
	public interface Member {
	    /**
	     * Returns the Class object representing the class or interface
	     * that declares the member or constructor represented by this Member.
	     *
	     * @return an object representing the declaring class of the
	     * underlying member
	     */
	    function getDeclaringClass():Class;
			
	    /**
	     * Returns <tt>true</tt> if this member was introduced by
	     * the compiler; returns <tt>false</tt> otherwise.
	     *
	     * @return true if and only if this member was introduced by
	     * the compiler.
	     * @since 1.5
	     */
	    function isSynthetic():Boolean;	
	    	
	    /**
	     * Returns the simple name of the underlying member or constructor
	     * represented by this Member.
	     * 
	     * @return the simple name of the underlying member
	     */
	    function get name() : String;
		function set name(value : String) : void;
		
	    /**
	     * Returns the Java language modifiers for the member or
	     * constructor represented by this Member, as an integer.  The
	     * Modifier class should be used to decode the modifiers in
	     * the integer.
	     * 
	     * @return the Java language modifiers for the underlying member
	     * @see Modifier
	     */
	    function get modifiers() : Modifier;
		function set modifiers(modifier : Modifier) : void;
	}
}
