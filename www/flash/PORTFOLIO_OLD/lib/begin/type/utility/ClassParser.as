package begin.type.utility {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;

	/**
	 * @private
	 */
	public class ClassParser {

		/**
		 * 
		 * @param	bytes
		 */
		public function ClassParser(value : *) {
			super();
			if (value as LoaderInfo) {
				_loaderInfo = LoaderInfo(value);
				_loader = _loaderInfo.loader;
				_data = new ClassReader(_loaderInfo.bytes);
			} else if (value as ByteArray) {
				_data = new ClassReader(value as ByteArray);
				_loader = new Loader();
				(value as ByteArray).position = 0;
				_loader.loadBytes(value as ByteArray); 
				_loaderInfo = _loader.loaderInfo;
			} else if (value as Loader) {
				_loader = value as Loader;
				_loaderInfo = _loader.loaderInfo;
				_data = new ClassReader(_loaderInfo.bytes);
			}
		}

		/**
		 * 
		 * @param	name
		 * @return
		 */
		public function getDefinition(name : String) : * {
			if (_loaderInfo.applicationDomain.hasDefinition(name))
				return _loaderInfo.applicationDomain.getDefinition(name);
			return null;
		}

		/**
		 * 
		 * @param	name
		 * @return
		 */
		public function getDefinitionInstance(name : String, ... parameters : Array) : * {
			var c : Class = getDefinition(name);
			if (c != null) {
				var len : int = parameters.length;
				if (len) {
					switch(len) {
						case 1:
							return new c(parameters[0]);
						case 2:
							return new c(parameters[0], parameters[1]);
						case 3:
							return new c(parameters[0], parameters[1], parameters[2]);
						case 4:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3]);
						case 5:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
						case 6:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
						case 7:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
						case 8:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
						case 9:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]);
						case 10:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]);
						case 11:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10]);
						case 12:
							return new c(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[10]);
					}
				}
				return new c();
			}
			return null;
		}

		/**
		 * 
		 * @param	extended
		 * @param	linkedOnly
		 * @return
		 */
		public function getDefinitionNames(extended : Boolean = false, linkedOnly : Boolean = true, onlyPublics : Boolean = false) : Array {
			var definitions : Array = new Array();
			var tag : uint;
			var id : uint;
			var length : uint;
			var minorVersion : uint;
			var majorVersion : uint;
			var position : uint;
			var name : String;
			var index : int;
			while (this._data.bytesAvailable) {
				tag = this._data.readUnsignedShort();
				id = tag >> 6;
				length = tag & 0x3F;
				length = (length == 0x3F) ? this._data.readUnsignedInt() : length;
				position = this._data.position;
				if (linkedOnly) {
					if (id == 76) {
						var count : uint = this._data.readUnsignedShort();
						while (count--) {
							this._data.readUnsignedShort(); // Object ID
							name = this._data.readString();
							index = name.lastIndexOf('.');
							if (index >= 0) 
								name = name.substr(0, index) + '::' + name.substr(index + 1); // Fast. Simple. Cheat ;)
							definitions.push(name);
						}
					}
				} else {
					switch (id) {
						case 72:
						case 82:
							if (id == 82) {
								this._data.position += 4;
								this._data.readString(); // identifier
							}
							minorVersion = this._data.readUnsignedShort();
							majorVersion = this._data.readUnsignedShort();
							if (minorVersion == 0x0010 && majorVersion == 0x002E) 
								definitions.push.apply(definitions, getDefinitionNamesInTag(extended, onlyPublics));
							break;
					}
				}
				this._data.position = position + length;
			}
			return definitions;
		}

		public function getLoaderInfo() : LoaderInfo {
			return _loaderInfo;	
		}

		public function getLoaderInfoByDefinition(object : Object) : LoaderInfo {
			return LoaderInfo.getLoaderInfoByDefinition(object);
			/*trace("actionScriptVersion: " + loaderInfo.actionScriptVersion);
			trace("applicationDomain: " + loaderInfo.applicationDomain);
			trace("bytes: " + loaderInfo.bytes);
			trace("bytesLoaded: " + loaderInfo.bytesLoaded);
			trace("bytesTotal: " + loaderInfo.bytesTotal);
			trace("childAllowsParent: " + loaderInfo.childAllowsParent);
			trace("content: " + loaderInfo.content);
			trace("contentType: " + loaderInfo.contentType);
			trace("frameRate: " + loaderInfo.frameRate);
			trace("height: " + loaderInfo.height);
			trace("loader: " + loaderInfo.loader);
			trace("loaderURL: " + loaderInfo.loaderURL);
			trace("parameters: " + loaderInfo.parameters);
			trace("parentAllowsChild: " + loaderInfo.parentAllowsChild);
			trace("sameDomain: " + loaderInfo.sameDomain);
			trace("sharedEvents: " + loaderInfo.sharedEvents);
			trace("swfVersion: " + loaderInfo.swfVersion);
			trace("url: " + loaderInfo.url);
			trace("width: " + loaderInfo.width);*/
		}

		/**
		 * 
		 * @param	name
		 * @return
		 */
		public function hasDefinition(name : String) : * {
			return _loaderInfo.applicationDomain.hasDefinition(name);
		}

		/**
		 * @private
		 */
		private function getDefinitionNamesInTag(extended : Boolean, onlyPublics : Boolean = false) : Array {
			var classesOnly : Boolean = !extended;
			var count : int;
			var kind : uint;
			var id : uint;
			var flags : uint;
			var counter : uint;
			var ns : uint;
			var names : Array = [];
			this._stringTable = [];
			this._namespaceTable = [];
			this._multinameTable = [];	
			// int table
			count = this._data.readASInt() - 1;
			while (count > 0 && count--) {
				this._data.readASInt();
			}
			// uint table
			count = this._data.readASInt() - 1;
			while (count > 0 && count--) {
				this._data.readASInt();
			}
			// Double table
			count = this._data.readASInt() - 1;
			while (count > 0 && count--) {
				this._data.readDouble();
			}
			// String table
			count = this._data.readASInt() - 1;
			id = 1;
			while (count > 0 && count--) {
				this._stringTable[id] = this._data.readUTFBytes(this._data.readASInt());
				id++;
			}
			// Namespace table
			count = this._data.readASInt() - 1;
			id = 1;
			while (count > 0 && count--) {
				kind = this._data.readUnsignedByte();
				ns = this._data.readASInt();
				if (onlyPublics) {
					// only public
					if (kind == 0x16) 
						this._namespaceTable[id] = ns;
				} else {
					this._namespaceTable[id] = ns;
				}
				id++;
			}
			// NsSet table
			count = this._data.readASInt() - 1;
			while (count > 0 && count--) {
				counter = this._data.readUnsignedByte();
				while (counter--) 
					this._data.readASInt();
			}
			// Multiname table
			count = this._data.readASInt() - 1;
			id = 1;
			while (count > 0 && count--) {
				kind = this._data.readASInt();	
				switch (kind) {
					case 0x07:
					case 0x0D:
						ns = this._data.readASInt();
						this._multinameTable[id] = [ns, this._data.readASInt()];
						break;    
					case 0x0F:
					case 0x10:
						this._multinameTable[id] = [0, this._stringTable[this._data.readASInt()]];
						break;    
					case 0x11:
					case 0x12:
						break;    
					case 0x09:
					case 0x0E:
						this._multinameTable[id] = [0, this._stringTable[this._data.readASInt()]];
						this._data.readASInt();
						break;    
					case 0x1B:
					case 0x1C:
						this._data.readASInt();
						break;    
				}	
				id++;
			}
			// Method table
			count = this._data.readASInt();
			while (count > 0 && count--) {
				var paramsCount : int = this._data.readASInt();
				counter = paramsCount;
				this._data.readASInt();
				while (counter--) 
					this._data.readASInt();
				this._data.readASInt();
				flags = this._data.readUnsignedByte();
				if (flags & 0x08) {
					counter = this._data.readASInt();	
					while (counter--) {
						this._data.readASInt();
						this._data.readASInt();
					}
				}	
				if (flags & 0x80) {
					counter = paramsCount;
					while (counter--) this._data.readASInt();
				}
			}
			// Metadata table
			count = this._data.readASInt();
			while (count > 0 && count--) {
				this._data.readASInt();
				counter = this._data.readASInt();	
				while (counter--) {
					this._data.readASInt();
					this._data.readASInt();
				}
			}
			// Instance table
			count = this._data.readASInt();
			var classCount : uint = count;
			var name : String;
			while (count > 0 && count--) {
				id = this._data.readASInt();
				this._data.readASInt();
				flags = this._data.readUnsignedByte();
				if (flags & 0x08) 
					ns = this._data.readASInt();
				counter = this._data.readASInt();
				while (counter--) 
					this._data.readASInt();
				this._data.readASInt(); // iinit
				this.readTraits();
				if (classesOnly) {
					name = getName(id);
					if (name) 
						names.push(name);
				}
			}
			if (classesOnly) 
				return names;
			// Class table
			count = classCount;
			while (count && count--) {
				this._data.readASInt(); // cinit
				this.readTraits();
			}
			// Script table
			count = this._data.readASInt();
			var traits : Array;
			while (count && count--) {
				this._data.readASInt(); // init
				traits = this.readTraits(true);
				if (traits.length) 
					names.push.apply(names, traits);
			}
			return names;
		}

		/**
		 * @private
		 */
		private function readTraits(buildNames : Boolean = false) : Array {
			var kind : uint;
			var counter : uint;
			var id : uint;
			var traitCount : uint = this._data.readASInt();
			var names : Array;
			var name : String;
			if (buildNames) names = [];
			while (traitCount--) {
				id = this._data.readASInt(); // name
				kind = this._data.readUnsignedByte();
				var upperBits : uint = kind >> 4;
				var lowerBits : uint = kind & 0xF;
				this._data.readASInt();
				this._data.readASInt();
				switch (lowerBits) {
					case 0x00:
					case 0x06:
						if (this._data.readASInt()) this._data.readASInt();
						break;
				}
				if (buildNames) {
					name = this.getName(id);
					if (name) names.push(name);
				}	
				if (upperBits & 0x04) {
					counter = this._data.readASInt();
					while (counter--) this._data.readASInt();
				}
			}
			return names;
		}

		/**
		 * @private
		 */
		private function getName(id : uint) : String {
			var mn : Array = this._multinameTable[id];
			if (mn == null)
				return null;
			var ns : uint = mn[0] as uint;
			var name : String = this._stringTable[mn[1] as uint] as String;
			if ((ns in this._namespaceTable)) {
				var nsName : String = this._stringTable[this._namespaceTable[ns] as uint] as String;
				if (nsName) 
					name = nsName + '::' + name;
			}
			return name;
		}

		/**
		 * @private
		 */
		private var _data : ClassReader;

		/**
		 * @private
		 */
		private var _stringTable : Array;

		/**
		 * @private
		 */
		private var _namespaceTable : Array;

		/**
		 * @private
		 */
		private var _multinameTable : Array;

		private var _loaderInfo : LoaderInfo;		private var _loader : Loader;
	}
}