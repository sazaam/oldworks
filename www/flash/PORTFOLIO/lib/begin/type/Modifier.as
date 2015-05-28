/**
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * 
 * BBBBBBBBBBBBBBB					  BBBBBBBBBBBBBB			        BBBBBBBBBBBB				
 * BBBBBBBBBBBBBBBBB			    BBBBBBBBBBBBBBBBBB			      BBBBBBBBBBBBBBBB				
 * BBBBBB	    BBBBBB			  BBBBBB		  BBBBBB		    BBBBBB	      BBBBBB	
 * BBBBBB	     BBBBBB			 BBBBBB		       BBBBBB		   BBBBBB	       BBBBBB
 * BBBBBB	    BBBBBB	   B	BBBBBB			    BBBBBB	  B	  BBBBBB	        BBBBBB
 * BBBBBBBBBBBBBBBBBB	  BBB  BBBBBB			     BBBBBB  BBB  BBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBB	  BBB  BBBBBB			     BBBBBB  BBB  BBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBB		  BBBBBB   B	BBBBBB			    BBBBBB	  B	  BBBBBB			BBBBBB
 * BBBBBB		   BBBBBB		 BBBBBB			   BBBBBB		  BBBBBB			BBBBBB
 * BBBBBB		  BBBBBB		  BBBBBB		  BBBBBB		  BBBBBB			BBBBBB
 * BBBBBBBBBBBBBBBBBBBB 			BBBBBBBBBBBBBBBBBB			  BBBBBB			BBBBBB
 * BBBBBBBBBBBBBBBBBB			      BBBBBBBBBBBBBB			  BBBBBB			BBBBBB
 * 
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 */
package begin.type {
	/**
	 * The Modifier class provides <code>static</code> methods and
	 * constants to decode class and member access modifiers.  The sets of
	 * modifiers are represented as integers with distinct bit positions
	 * representing different modifiers.  The values for the constants
	 * representing the modifiers are taken from <a
	 * href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/VMSpecTOC.doc.html"><i>The
	 * Java</i><sup><small>TM</small></sup> <i>Virtual Machine Specification, Second
	 * edition</i></a> tables 
	 * <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#75734">4.1</a>,
	 * <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#88358">4.4</a>,
	 * <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#75568">4.5</a>, and 
	 * <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#88478">4.7</a>.
	 *
	 * @see Class#getModifiers()
	 * @see Member#getModifiers()
	 *
	 * @author Nakul Saraiya
	 * @author Kenneth Russell
	 */
	public class Modifier extends Descriptor {
	    /*
	     * Access modifier flag constants from <em>The Java Virtual
	     * Machine Specification, Second Edition</em>, tables 4.1, 4.4,
	     * 4.5, and 4.7.
	     */
	
	    /**
	     * The <code>int</code> value representing the <code>public</code> 
	     * modifier.
	     */    
	    public static const PUBLIC:int = 0x00000001;
	
	    /**
	     * The <code>int</code> value representing the <code>private</code> 
	     * modifier.
	     */    
	    public static const PRIVATE:int = 0x00000002;
	
	    /**
	     * The <code>int</code> value representing the <code>protected</code> 
	     * modifier.
	     */    
	    public static const PROTECTED:int = 0x00000004;
	
	    /**
	     * The <code>int</code> value representing the <code>static</code> 
	     * modifier.
	     */    
	    public static const STATIC:int = 0x00000008;
	
	    /**
	     * The <code>int</code> value representing the <code>final</code> 
	     * modifier.
	     */    
	    public static const FINAL:int = 0x00000010;
	
	    /**
	     * The <code>int</code> value representing the <code>synchronized</code> 
	     * modifier.
	     */    
	    public static const SYNCHRONIZED:int = 0x00000020;
	
	    /**
	     * The <code>int</code> value representing the <code>volatile</code> 
	     * modifier.
	     */    
	    public static const VOLATILE:int = 0x00000040;
	
	    /**
	     * The <code>int</code> value representing the <code>transient</code> 
	     * modifier.
	     */    
	    public static const TRANSIENT:int = 0x00000080;
	
	    /**
	     * The <code>int</code> value representing the <code>native</code> 
	     * modifier.
	     */    
	    public static const NATIVE:int = 0x00000100;
	
	    /**
	     * The <code>int</code> value representing the <code>interface</code> 
	     * modifier.
	     */    
	    public static const INTERFACE:int = 0x00000200;
	
	    /**
	     * The <code>int</code> value representing the <code>abstract</code> 
	     * modifier.
	     */    
	    public static const ABSTRACT:int = 0x00000400;
	
	    /**
	     * The <code>int</code> value representing the <code>strictfp</code> 
	     * modifier.
	     */    
	    public static const STRICT:int = 0x00000800;
		
		public function Modifier(type : Type, name : String, value:int=0x00000001) {
			super(type, name);
			_value = value;
		}

		public static function defaults(isDynamic : Boolean = false, isFinal : Boolean = false, isStatic : Boolean = false) : Object {
			return {
				isDynamic:isDynamic, isFinal:isFinal, isStatic:isStatic
			};
		}
		
		/**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>public</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>public</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isPublic(mod:int):Boolean {
			return (mod & PUBLIC) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>private</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>private</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isPrivate(mod:int):Boolean {
			return (mod & PRIVATE) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>protected</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>protected</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isProtected(mod:int):Boolean {
			return (mod & PROTECTED) != 0;
	    }
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>static</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>static</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isStatic(mod:int):Boolean {
			return (mod & STATIC) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>final</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>final</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isFinal(mod:int):Boolean {
			return (mod & FINAL) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>synchronized</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>synchronized</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isSynchronized(mod:int):Boolean {
			return (mod & SYNCHRONIZED) != 0;
	    }
	    
	    /**
	     * Returns <tt>true</tt> if this constructor was declared to take
	     * a variable number of arguments; returns <tt>false</tt>
	     * otherwise.
	     *
	     * @return <tt>true</tt> if an only if this constructor was declared to
	     * take a variable number of arguments.
	     * @since 1.5
	     */
	    public static function isVarArgs(mod:int):Boolean  {
	        return (mod & VARARGS) != 0;
	    }
	        
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>volatile</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>volatile</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isVolatile(mod:int):Boolean {
			return (mod & VOLATILE) != 0;
	    }
	
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>transient</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>transient</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isTransient(mod:int):Boolean {
			return (mod & TRANSIENT) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>native</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>native</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isNative(mod:int):Boolean {
			return (mod & NATIVE) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>interface</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>interface</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isInterface(mod:int):Boolean {
			return (mod & INTERFACE) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>abstract</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>abstract</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isAbstract(mod:int):Boolean {
			return (mod & ABSTRACT) != 0;
	    }
	    
	    /**
	     * Return <tt>true</tt> if the integer argument includes the
	     * <tt>strictfp</tt> modifier, <tt>false</tt> otherwise.
	     *
	     * @param 	mod a set of modifiers
	     * @return <tt>true</tt> if <code>mod</code> includes the
	     * <tt>strictfp</tt> modifier; <tt>false</tt> otherwise.
	     */
	    public static function isStrict(mod:int):Boolean {
			return (mod & STRICT) != 0;
	    }
	    
	    /**
	     * Return a string describing the access modifier flags in
	     * the specified modifier. For example:
	     * <blockquote><pre>
	     *    public final synchronized strictfp
	     * </pre></blockquote>
	     * The modifier names are returned in an order consistent with the
	     * suggested modifier orderings given in <a
	     * href="http://java.sun.com/docs/books/jls/second_edition/html/j.title.doc.html"><em>The
	     * Java Language Specification, Second Edition</em></a> sections
	     * <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#21613">&sect;8.1.1</a>, 
	     * <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#78091">&sect;8.3.1</a>, 
	     * <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#78188">&sect;8.4.3</a>, 
	     * <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#42018">&sect;8.8.3</a>, and
	     * <a href="http://java.sun.com/docs/books/jls/second_edition/html/interfaces.doc.html#235947">&sect;9.1.1</a>.  
	     * The full modifier ordering used by this method is:
	     * <blockquote> <code> 
	     * public protected private abstract static final transient
	     * volatile synchronized native strictfp
	     * interface </code> </blockquote> 
	     * The <code>interface</code> modifier discussed in this class is
	     * not a true modifier in the Java language and it appears after
	     * all other modifiers listed by this method.  This method may
	     * return a string of modifiers that are not valid modifiers of a
	     * Java entity; in other words, no checking is done on the
	     * possible validity of the combination of modifiers represented
	     * by the input.
	     *
	     * @param	mod a set of modifiers
	     * @return	a string representation of the set of modifiers
	     * represented by <code>mod</code>
	     */
	    public static function toString(mod:int):String {
			var sb:String = "";
			var len:int;
			if ((mod & PUBLIC) != 0)	sb += "public ";
			if ((mod & PROTECTED) != 0)	sb += "protected ";
			if ((mod & PRIVATE) != 0)	sb += "private ";
		
			/* Canonical order */
			if ((mod & ABSTRACT) != 0)	sb += "abstract ";
			if ((mod & STATIC) != 0)	sb += "static ";
			if ((mod & FINAL) != 0)		sb += "final ";
			if ((mod & TRANSIENT) != 0)	sb += "transient ";
			if ((mod & VOLATILE) != 0)	sb += "volatile ";
			if ((mod & SYNCHRONIZED) != 0)	sb += "synchronized ";
			if ((mod & NATIVE) != 0)	sb += "native ";
			if ((mod & STRICT) != 0)	sb += "strictfp ";
			if ((mod & INTERFACE) != 0)	sb += "interface ";
			if ((len = sb.length) > 0)	/* trim trailing space */
			    return sb.substring(0, len-1);
			return "";
	    }  	    
	    	    	
	    // Bits not (yet) exposed in the public API either because they
	    // have different meanings for fields and methods and there is no
	    // way to distinguish between the two in this class, or because
	    // they are not Java programming language keywords
		static internal function isSynthetic(mod:int):Boolean {
      		return (mod & SYNTHETIC) != 0;
    	}
    	
	    static internal const BRIDGE:int = 0x00000040;
	    static internal const VARARGS:int = 0x00000080;
	    static internal const SYNTHETIC:int = 0x00001000;
	    static internal const ANNOTATION:int = 0x00002000;
	    static internal const ENUM:int = 0x00004000;	    	    

		public function get value() : int {
			return _value;
		}
		
		public function set value(value : int) : void {
			_value = value;
		}
			    
	    private var _value : int;
		
	}
}