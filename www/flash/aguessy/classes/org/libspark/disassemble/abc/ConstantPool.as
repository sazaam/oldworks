package org.libspark.disassemble.abc
{
	import org.libspark.disassemble.ByteStream;
	
	public class ConstantPool
	{
		private var input:ByteStream;
		
		private var intIndices:Array;
		private var uintIndices:Array;
		private var doubleIndices:Array;
		private var stringIndices:Array;
		private var namespaceIndices:Array;
		private var namespaceSetIndices:Array;
		private var multinameIndices:Array;
		
		public function ConstantPool(input:ByteStream)
		{
			this.input = input;
			
			scanConstantPool();
		}
		
		private function scanConstantPool():void
		{
			scanConstantPoolInt();
			scanConstantPoolUint();
			scanConstantPoolDouble();
			scanConstantPoolString();
			scanConstantPoolNamespace();
			scanConstantPoolNamespaceSet();
			scanConstantPoolMultiname();
		}
		
		private function scanConstantPoolInt():void
		{
			var size:uint = input.readU32();
			intIndices = new Array(size);
			for (var i:uint = 1; i < size; ++i) {
				intIndices[i] = input.position;
				input.readU32();
			}
		}
		
		private function scanConstantPoolUint():void
		{
			var size:uint = input.readU32();
			uintIndices = new Array(size);
			for (var i:uint = 1; i < size; ++i) {
				uintIndices[i] = input.position;
				input.readU32();
			}
		}
		
		private function scanConstantPoolDouble():void
		{
			var size:uint = input.readU32();
			doubleIndices = new Array(size);
			for (var i:uint = 1; i < size; ++i) {
				doubleIndices[i] = input.position;
				input.readDouble();
			}
		}
		
		private function scanConstantPoolString():void
		{
			var size:uint = input.readU32();
			stringIndices = new Array(size);
			for (var i:uint = 1; i < size; ++i) {
				stringIndices[i] = input.position;
				var length:uint = input.readU32();
				input.skip(length);
			}
		}
		
		private function scanConstantPoolNamespace():void
		{
			var size:uint = input.readU32();
			namespaceIndices = new Array(size);
			for (var i:uint = 1; i < size; ++i) {
				namespaceIndices[i] = input.position;
				input.readU8();
				input.readU32();
			}
		}
		
		private function scanConstantPoolNamespaceSet():void
		{
			var size:uint = input.readU32();
			namespaceSetIndices = new Array(size);
			for (var i:uint = 1; i < size; ++i) {
				namespaceSetIndices[i] = input.position;
				var count:uint = input.readU32();
				input.skipU32(count);
			}
		}
		
		private function scanConstantPoolMultiname():void
		{
			var size:uint = input.readU32();
			multinameIndices = new Array(size);
			for (var i:uint = 1; i < size; ++i) {
				multinameIndices[i] = input.position;
				var kind:uint = input.readU8();
				switch (kind) {
					case 7:
					case 13:
						input.readU32();
						input.readU32();
						break;
					case 15:
					case 16:
						input.readU32();
						break;
					case 9:
					case 14:
						input.readU32();
						input.readU32();
						break;
					case 27:
						input.readU32();
						break;
					case 17:
					case 18:
						break;
					case 29:
						input.readU32();
						var l:uint = input.readU32();
						for (var ti:uint = 0; ti < l; ++ti) {
							input.readU32();
						}
						break;
					default:
						throw new VerifyError('Invalid constant type:' + kind);
				}
			}
		}
		
		public function getInt(index:uint):int
		{
			if (index == 0) {
				return 0;
			}
			var pos:uint = intIndices[index];
			var current:uint = input.position;
			input.seek(pos);
			var value:int = input.readU32();
			input.seek(current);
			return value;
		}
		
		public function getUint(index:uint):uint
		{
			if (index == 0) {
				return 0;
			}
			var pos:uint = uintIndices[index];
			var current:uint = input.position;
			input.seek(pos);
			var value:uint = input.readU32();
			input.seek(current);
			return value;
		}
		
		public function getDouble(index:uint):Number
		{
			if (index == 0) {
				return 0.0;
			}
			var pos:uint = doubleIndices[index];
			var current:uint = input.position;
			input.seek(pos);
			var value:Number = input.readDouble();
			input.seek(current);
			return value;
		}
		
		public function getString(index:uint):String
		{
			if (index == 0) {
				return null;
			}
			var pos:uint = stringIndices[index];
			var current:uint = input.position;
			input.seek(pos);
			var value:String = input.readString(input.readU32());
			input.seek(current);
			return value;
		}
		
		public function getNamespace(index:uint):NS
		{
			if (index == 0) {
				return null;
			}
			var pos:uint = namespaceIndices[index];
			var current:uint = input.position;
			input.seek(pos);
			var kind:uint = input.readU8();
			var value:String;
			switch (kind) {
				case 23: // Internal Namespace
					value = 'internal';
					break;
				case 5:  // Private Namespace
					value = 'private';
					break;
				case 24: // Protected Namespace
					value = 'protected';
					break;
				case 26: // Static Protected Namespace
					value = 'static.protected';
					break;
				case 22: // Package Namespace
					value = '';
					break;
				case 25:
				case 8:  // Namespace
					value = 'public';
					break;
				default:
					throw new VerifyError('constant pool index ' + index + ' is not a Namespace type.');
			}
			var name:String = getString(input.readU32());
			input.seek(current);
			return new NS(value, name);
		}
		
		public function getNamespaceSet(index:uint):Array
		{
			if (index == 0) {
				return null;
			}
			var pos:uint = namespaceSetIndices[index];
			var current:uint = input.position;
			input.seek(pos);
			var count:uint = input.readU32();
			var value:Array = new Array(count);
			for (var i:uint = 0; i < count; ++i) {
				value[i] = getNamespace(input.readU32());
			}
			input.seek(current);
			return value;
		}
		
		public function getMultiName(index:uint):*
		{
			if (index == 0) {
				return null;
			}
			var pos:uint = multinameIndices[index];
			var current:uint = input.position;
			input.seek(pos);
			var kind:uint = input.readU8();
			switch (kind) {
				case 7:  // QName (hoge)
				case 13: // QName Attribute (@hoge)
					var namespaceIndex:uint = input.readU32();
					var nameIndex:uint = input.readU32();
					var valueQName:MultiName = createQName(getNamespace(namespaceIndex), getString(nameIndex));
					input.seek(current);
					return valueQName;
				case 29:
					var mn:MultiName = getMultiName(input.readU32());
					var l:uint = input.readU32();
					var paramTypes:Array = new Array(l);
					for (var ti:uint = 0; ti < l; ++ti) {
						paramTypes[ti] = getMultiName(input.readU32());
					}
					var mnt:MultiName = createMultiName(mn.name, mn.namespaces, paramTypes);
					input.seek(current);
					return mnt;
				case 9:  // Multiname (hoge)
				case 14: // Multiname Attribute (@hoge)
					var name:String = getString(input.readU32());
					var namespaces:Array = getNamespaceSet(input.readU32());
					var valueMultiName:MultiName = createMultiName(name, namespaces);
					input.seek(current);
					return valueMultiName;
				case 17: // Runtime QName Late (hoge)
					input.seek(current);
					return 'RuntimeQNameLate';
				case 18: // Runtime QName Late Attribute (@hoge)
					input.seek(current);
					return 'RuntimeQNameLateA';
				case 27: // Multiname Late (hoge)
				case 28: // Multiname Late Attribute (@hoge)
					var namespaceSetIndex:uint = input.readU32();
					var valueNamespaceSet:Array = getNamespaceSet(namespaceSetIndex);
					input.seek(current);
					return valueNamespaceSet;
				case 15: // Runtime QName (hoge)
				case 16: // Runtime QName Attribute (@hoge)
					var valueString:String = getString(input.readU32());
					input.seek(current);
					return valueString;
				default:
					input.seek(current);
					throw new VerifyError('constant pool index ' + index + ' is not a QName type (' + kind + ').');
			}
		}
		
		public function getValue(index:uint, kind:uint):*
		{
			if (index == 0) {
				return null;
			}
			switch (kind) {
				case 1:  // Constant UTF8
					return getString(index);
				case 3:  // Constant Integenr
					return getInt(index);
				case 4:  // Constant Unsigned Integner
					return getUint(index);
				case 6:  // Constant Double
					return getDouble(index);
				case 5:  // Private Namespace
				case 8:  // Namespace
				case 22: // Package Namespace
				case 23: // Internal Namespace
				case 24: // Protected Namespace
				case 25:
				case 26: // Static Protected Namespace
					return getNamespace(index);
				case 7:  // QName
				case 13: // QName Attribute
				case 29: // TypeName
				case 9:  // Multiname
				case 14: // Multiname Attribute
				case 15: // Runtime QName
				case 16: // Runtime QName Attribute
					return getMultiName(index);
				case 10: // Constant False
					return false;
				case 11: // Constant True
					return true;
				case 12: // Constant Null
					return null;
				case 17: // Runtime QName Late
					return 'RuntimeQNameLate';
				case 18: // Runtime QName Late Attribute
					return 'RuntimeQNameLateA';
				case 27: // Multiname Late
					return getNamespaceSet(getInt(index));
				case 28: // Multiname Late Attribute
					return getNamespaceSet(getInt(index));
				case 21:
					return getNamespaceSet(index);
				default:
					throw new Error('Undefined constant type:' + kind);
			}
		}
		
		private function createQName(ns:NS, name:String):MultiName
		{
			return createMultiName(name, [ns]);
		}
		
		private function createMultiName(name:String, namespaces:Array, typeParams:Array = null):MultiName
		{
			return new MultiName(name, namespaces, typeParams);
		}
	}
}