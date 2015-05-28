package {
	import begin.eval.Eval;
	import begin.eval.dump.Util;
	import begin.eval.evaluate;
	import begin.type.Type;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author aime
	 */
	public class Main extends Sprite {
		public function Main() {
			if (stage == null)
				addEventListener(Event.ADDED_TO_STAGE, init);
			else
				init();
		}

		private function init(evt : Event = null) : void {		
			var script : XML = <![CDATA[
				namespace core = "core";
				use namespace core;
				
				namespace display = "flash.display";
				use namespace display;				
				
				/** 
				 * section: core
				 * JS
				 * 
				 * The `JS` object is used as a namespace by the rest of the JS.Class framework, and hosts
				 * various utility methods used throughout. None of these methods should be taken as being
				 * public API, they are all 'plumbing' and may be removed or changed at any time.
				 */				
				core const JS : Object = {};
				  /**
				   * JS.extend(target, extensions) -> Object
				   * - target (Object): object to be extended
				   * - extensions (Object): object containing key/value pairs to add to target
				   *
				   * Adds the properties of the second argument to the first, and returns the first. Will not
				   * needlessly overwrite fields with identical values; if an object has inherited a property
				   * we should not add the property to the object itself.
				   */					
				JS.extend = function(target : Object, extensions : Object = null) : Object {
					extensions = extensions || {};
					for (var prop : String in extensions) {
						if (target[prop] === extensions[prop]) 
							continue;
						target[prop] = extensions[prop];
					}
					return target;
				}
									
				JS.extend(JS, {
					  /**
					   * JS.extend(target, extensions) -> Object
					   * - target (Object): object to be extended
					   * - extensions (Object): object containing key/value pairs to add to target
					   *
					   * Adds the properties of the second argument to the first, and returns the first. Will not
					   * needlessly overwrite fields with identical values; if an object has inherited a property
					   * we should not add the property to the object itself.
					   */					
					extend: function(target : Object, extensions : Object = null) : Object {
						extensions = extensions || {};
						for (var prop : String in extensions) {
							if (target[prop] === extensions[prop]) 
								continue;
							target[prop] = extensions[prop];
						}
						return target;
					},
					  /**
					   * JS.makeFunction() -> Function
					   *
					   * Returns a function for use as a constructor. These functions are used as the basis for
					   * classes. The constructor calls the object's `initialize()` method if it exists.
					   */				  	
					makeFunction: function(... parameters) : Function {
						return function(... rest) : * {
							return this.initialize ? (this.initialize.apply(this, arguments) || this) : this;
						};
					},
					  /**
					   * JS.makeBridge(klass) -> Object
					   * - klass (JS.Class): class from which you want to inherit
					   *
					   * Takes a class and returns an instance of it, without calling the class's constructor.
					   * Used for forging prototype links between objects using JavaScript's inheritance model.
					   */								  	
					makeBridge: function(klass : Object) : Object {
						var bridge : Function = new Function;
						bridge.prototype = klass.prototype;
						return new bridge();
					},
					  /**
					   * JS.bind(object, func) -> Function
					   * - object (Object): object to bind the function to
					   * - func (Function): function that the bound function should call
					   *
					   * Takes a function and an object, and returns a new function that calls the original
					   * function with `this` set to refer to the `object`. Used to implement `JS.Kernel#method`,
					   * amongst other things.
					   */
					bind: function(... parameters) : Function {
						var args : Array = JS.array(parameters);
						var method : Function = args.shift();
						var o : Object = args.shift();
						return function(... rest) : * {
							return method.apply(o, args.concat(JS.array(rest)));
						};
					},
					  /**
					   * JS.callsSuper(func) -> Boolean
					   * - func (Function): function to test for super() calls
					   *
					   * Takes a function and returns `true` iff the function makes a call to `callSuper()`.
					   * Result is cached on the function itself since functions are immutable and decompiling
					   * them is expensive. We use this to determine whether to wrap the function when it's
					   * added to a class; wrapping impedes performance and should be avoided where possible.
					   */					
					callsSuper: function(func : Object) : * {
						return func.SUPER === undefined ? func.SUPER = /\bcallSuper\b/.test(func.toString()) : func.SUPER;
					},
					  /**
					   * JS.mask(func) -> Function
					   * - func (Function): function to obfuscate
					   *
					   * Disguises a function so that we cannot tell if it uses `callSuper()`. Sometimes we don't
					   * want such functions to be wrapped by the inheritance system. Modifies the function's
					   * `toString()` method and returns the function.
					   */  					
					mask: function(func : Object) : Object {
						var string : String = func.toString().replace(/callSuper/g, 'super');
						func.toString = function() : String { return string };
						return func;
					},
					  /**
					   * JS.array(iterable) -> Array
					   * - iterable (Object): object you want to cast to an array
					   *
					   * Takes any iterable object (something with a `length` property) and returns a native
					   * JavaScript `Array` containing the same elements.
					   */					
					array: function(iterable : Object) : Array {
						if (!iterable) 
							return [];
						if (iterable.toArray) 
							return iterable.toArray();
						var length : int = iterable.length;
						var results : Array = [];
						while (length--) 
							results[length] = iterable[length];
						return results;
					},				  			
					  /**
					   * JS.indexOf(haystack, needle) -> Number
					   * - haystack (Array): array to search
					   * - needle (Object): object to search for
					   *
					   * Returns the index of the `needle` in the `haystack`, which is typically an `Array` or an
					   * array-like object. Returns -1 if no matching element is found. We need this as older
					   * IE versions don't implement `Array#indexOf`.
					   */				  	
					indexOf: function(haystack : Array, needle : *) : int {
						for (var i : int = 0, n : int = haystack.length; i < n; i++) {
							if (haystack[i] === needle) 
								return i;
						}
						return -1;
					},	
					  /**
					   * JS.isFn(object) -> Boolean
					   * - object (Object): object to test
					   *
					   * Returns `true` iff the argument is a `Function`.
					   */				  	
					isFn: function(object : Object) : Boolean {
						return object instanceof Function;
					},
					  /**
					   * JS.isType(object, type) -> Boolean
					   * - object (Object): object whose type we wish to check
					   * - type (JS.Module): type to match against
					   * 
					   * Returns `true` iff `object` is of the given `type`.
					   */  					
					isType: function(object : Object=null, val:Object=null) : Boolean {
						if (!object || !val) 
							return false;
						return (val instanceof Function && object instanceof val) || (typeof val === 'string' && typeof object === val) || (object.isA && object.isA(val));
					},
					  /**
					   * JS.ignore(key, object) -> Boolean
					   * - key (String): name of field being added to an object
					   * - object (Object): value of the given field
					   *
					   * Used to determine whether a key-value pair should be added to a class or module. Pairs
					   * may be ignored if they have some special function, like `include` or `extend`.
					   */  					
					ignore: function(key : String, object : Object) : Boolean {
						return /^(include|extend)$/.test(key) && typeof object === 'object';
					}				
				});
				
				core class MyClass extends Sprite {
					core function MyClass() {}					
				}
				
			]]>;
			/*
			var runtime : RuntimeClass = new RuntimeClass("Test", "public", "test");
			runtime.addConstructor("this._testing = value;\n", "public", "value : String = ''");			runtime.addGetter("testing", "return _testing;\n", "String");			runtime.addSetter("testing", "_testing = value;\n", "value : String");			runtime.addVariable("_testing", '"' + "test" + '"', "private", "String");
			
			trace(runtime);
			*/		
			Util;
			evaluate(script.toString(), "RubyJS", function(evt : Event) : void {
				var JS : Object = Eval(evt.target).getEvalLoader().getDefinition("core::JS");
				trace(Type.toXml(JS));
				for (var p : String in JS)
					trace("key : ", p, "value : ", JS[p]);
				var MyClass : Class = Eval(evt.target).getEvalLoader().getDefinition("core::MyClass") as Class;
				trace(Type.toXml(MyClass));
				var instance : Sprite = Sprite(addChild(new MyClass()));
				var s : Shape = new Shape();
				var g : Graphics = s.graphics;
				g.beginFill(0);				g.drawRect(0, 0, 100, 100);
				g.endFill();
				instance.addChild(s);
				
			});			
		}
	}
}
