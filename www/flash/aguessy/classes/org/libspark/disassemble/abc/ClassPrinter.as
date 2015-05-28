package org.libspark.disassemble.abc
{
	import flash.utils.ByteArray;
	
	import org.libspark.disassemble.ByteStream;
	
	public class ClassPrinter
	{
		public function ClassPrinter(byteCode:ByteArray)
		{
			stream = new ByteStream(byteCode);
		}
		
		private var stream:ByteStream;
		
		private var constantPool:ConstantPool;
		
		private var _methodInfos:Array;
		private var _instanceInfos:Array;
		
		public function parse():void
		{
			parseAbc();
		}
		
		private function parseAbc():void
		{
			_methodInfos = [];
			
			parseVersion();
			scanConstantPool();
			parseMethods();
			parseMetadata();
			parseClasses();
			parseScripts();
			parseMethodBodies();
		}
		
		private function parseVersion():void
		{
			var minor:uint = stream.readU16();
			var major:uint = stream.readU16();
		}
		
		private function scanConstantPool():void
		{
			constantPool = new ConstantPool(stream);
		}
		
		private function parseMethods():void
		{
			var methodEntries:uint = stream.readU32();
			_methodInfos = new Array(methodEntries);
			for (var i:uint = 0; i < methodEntries; ++i) {
				var paramCount:uint = stream.readU32();
				var type:uint = stream.readU32();
				var paramTypes:Array = new Array(paramCount);
				for (var p:uint = 0; p < paramCount; ++p) {
					var paramType:uint = stream.readU32();
					paramTypes[p] = paramType;
				}
				var nativeName:uint = stream.readU32();
				var flags:uint = stream.readU8();
				var needsArguments:Boolean = (flags & 0x01) != 0;
				var needsActivation:Boolean = (flags & 0x02) != 0;
				var needsRest:Boolean = (flags & 0x04) != 0;
				var hasOptional:Boolean = (flags & 0x08) != 0;
				var ignoreRest:Boolean = (flags & 0x10) != 0;
				var isNative:Boolean = (flags & 0x20) != 0;
				var hasParamNames:Boolean = (flags & 0x80) != 0;
				var optionals:Array = null;
				var p:uint;
				if (hasOptional) {
					var optionalCount:uint = stream.readU32();
					optionals = new Array(optionalCount);
					for (p = 0; p < optionalCount; ++p) {
						var value:uint = stream.readU32();
						var valueKind:uint = stream.readU8();
						optionals[p] = [value, valueKind];
					}
				}
				var paramNames:Array = null;
				if (hasParamNames) {
					paramNames = new Array(paramCount);
					for (p = 0; p < paramCount; ++p) {
						var paramName:uint = stream.readU32();
						paramNames[p] = paramName;
					}
				}
				
				var params:Array = new Array(paramCount);
				if (hasParamNames) {
					for (p = 0; p < paramCount; ++p) {
						params[p] = constantPool.getString(paramNames[p]) + ':' + 
							(paramTypes[p] != 0 ? constantPool.getMultiName(paramTypes[p]) : '*');
					}
				}
				else {
					for (p = 0; p < paramCount; ++p) {
						params[p] = '$' + p + ':' + 
							(paramTypes[p] != 0 ? constantPool.getMultiName(paramTypes[p]) : '*');
					}
				}
				var lastParam:uint = 1;
				if (needsRest) {
					lastParam = 2;
					params[paramCount - 1] = '...' + params[paramCount - 1];
				}
				if (hasOptional) {
					for (p = 0; p < optionalCount; ++p) {
						var v:Array = optionals[p];
						params[paramCount - (p + lastParam)] += ' = ' + constantPool.getValue(v[0], v[1]);
					}
				}
				
				var args:String = '';
				args += '(' + params.join(', ') + ')';
				if (type != 0) {
					args += ':' + constantPool.getMultiName(type);
				}
				else {
					args += ':*';
				}
				
				_methodInfos[i] = new MethodInfo(isNative, args);
			}
		}
		
		private function parseMetadata():void
		{
			var metadataEntries:uint = stream.readU32();
			for (var i:uint = 0; i < metadataEntries; ++i) {
				var nameIndex:uint = stream.readU32();
				var valueCount:uint = stream.readU32();
				for (var k:uint = 0; k < valueCount; ++k) {
					var key:uint = stream.readU32();
				}
				for (var v:uint = 0; v < valueCount; ++v) {
					var value:uint = stream.readU32();
				}
			}
		}
		
		private function parseTraits(modifier:String = '', qualified:Boolean = false):Traits
		{
			var traitsCount:uint = stream.readU32();
			var buf:String = '';
			for (var i:uint = 0; i < traitsCount; ++i) {
				var name:MultiName = constantPool.getMultiName(stream.readU32());
				var kind:uint = stream.readU8();
				var tag:uint = kind & 0x0f;
				var flags:uint = kind >>> 4;
				var type:String = '';
				switch (tag) {
					case 0: // var
						type = 'var ';
					case 6: // const
						if (tag == 6) {
							type = 'const ';
						}
						var sig:String = toPropertyName(type, name);
						var slotID:uint = stream.readU32();
						var typeId:uint = stream.readU32();
						sig += ':' + constantPool.getMultiName(typeId);
						var valueId:uint = stream.readU32();
						if (valueId != 0) {
							var valueKind:uint = stream.readU8();
							sig += ' = ' + constantPool.getValue(valueId, valueKind);
						}
						buf += modifier + sig + ";\n";
						break;
					case 1: // method
						type = 'function ';
					case 2: // getter
						if (tag == 2) {
							type += 'get ';
						}
					case 3: // setter
						if (tag == 3) {
							type += 'set ';
						}
						type = ((flags & 1) != 0 ? 'final ' : '') + type;
						type = ((flags & 2) != 0 ? 'override ' : '') + type;
						var dispID:uint = stream.readU32();
						var methodInfo:MethodInfo = _methodInfos[stream.readU32()];
						buf += modifier + methodInfo.getSignature(type, name, qualified) + ";\n";
						break;
					case 4: // class
						var slotID:uint = stream.readU32();
						var classId:uint = stream.readU32();
						break;
					case 5: // function
						var slotID:uint = stream.readU32();
						var methodInfo:MethodInfo = _methodInfos[stream.readU32()];
						break;
					default:
						break;
				}
				if ((flags & 4) != 0) {
					var metadataCount:uint = stream.readU32();
					for (var m:uint = 0; m < metadataCount; ++m) {
						var data:uint = stream.readU32();
					}
				}
			}
			return new Traits(buf);
		}
		
		private function parseClasses():void
		{
			var classEntries:uint = stream.readU32();
			_instanceInfos = new Array(classEntries);
			for (var i:uint = 0; i < classEntries; ++i) {
				var buf:String = 'public ';
				var name:uint = stream.readU32();
				var superName:uint = stream.readU32();
				var flags:uint = stream.readU8();
				var isFinal:Boolean = (flags & 2) != 0;
				var isDynamic:Boolean = (flags & 1) == 0;
				var isInterface:Boolean = (flags & 4) != 0;
				var flagList:Array = [];
				if (isFinal) buf += 'final ';
				if (isDynamic) buf += 'dynamic ';
				buf += isInterface ? 'interface ' : 'class ';
				var hasProtected:Boolean = (flags & 8) != 0;
				var mn:MultiName = constantPool.getMultiName(name);
				buf += toClassName(mn) + (superName != 0 ? ' extends ' + toClassName(constantPool.getMultiName(superName)) : '');
				if (hasProtected) {
					var protectedNamespace:uint = stream.readU32();
				}
				var interfaceCount:uint = stream.readU32();
				if (interfaceCount > 0) {
					var impls:Array = new Array(interfaceCount);
					for (var f:uint = 0; f < interfaceCount; ++f) {
						impls[i] = toClassName(constantPool.getMultiName(stream.readU32()));
					}
					buf += ' implements ' + impls.join(', ');
				}
				var iinit:uint = stream.readU32();
				var ctor:MethodInfo = _methodInfos[iinit];
				var c:String = '    public function ' + mn.name + ctor.args + "\n";
				_instanceInfos[i] = new InstanceInfo(buf, c, parseTraits('    '));
			}
			for (var i:uint = 0; i < classEntries; ++i) {
				var cinit:uint = stream.readU32();
				trace(InstanceInfo(_instanceInfos[i]).getSignature(parseTraits('    static ')));
			}
		}
		
		private function parseScripts():void
		{
			var scriptEntries:uint = stream.readU32();
			for (var i:uint = 0; i < scriptEntries; ++i) {
				var initId:uint = stream.readU32();
				trace(parseTraits('', true).value);
			}
		}
		
		private function parseMethodBodies():void
		{
			var size:uint = stream.readU32();
			for (var i:uint = 0; i < size; ++i) {
				var methodInfo:uint = stream.readU32();
				var maxStack:uint = stream.readU32();
				var maxRegisters:uint = stream.readU32();
				var scopeDepth:uint = stream.readU32();
				var maxScope:uint = stream.readU32();
				var codeLength:uint = stream.readU32();
				var endOfCode:uint = stream.position + codeLength;
				var codes:Array = parseCodes(stream, endOfCode);
				stream.seek(endOfCode);
				var exceptionCount:uint = stream.readU32();
				for (var e:uint = 0; e < exceptionCount; ++e) {
					var start:uint = stream.readU32();
					var end:uint = stream.readU32();
					var target:uint = stream.readU32();
					var type:uint = stream.readU32();
					var nameIndex:uint = stream.readU32();
				}
				parseTraits();
			}
		}
		
		private function parseCodes(stream:ByteStream, endOfCode:uint):Array
		{
			var codes:Array = [];
			
			var cp:ConstantPool = constantPool;
			
			function pushCode(name:String, ...params:Array):void
			{
				// codes.push(name + '(' + params.join(',') + ')');
			}
			
			while (stream.position < endOfCode) {
				var opCode:uint = stream.readU8();
				switch (opCode) {
					case 1:
					    pushCode('Bkpt');
					    break;
					case 2:
					    pushCode('Nop');
					    break;
					case 3:
					    pushCode('Throw');
					    break;
					case 16:
					    pushCode('Jump', stream.readU24());
					    break;
					case 9:
					    pushCode('Label');
					    break;
					case 17:
					    pushCode('IfTrue', stream.readU24());
					    break;
					case 18:
					    pushCode('IfFalse', stream.readU24());
					    break;
					case 19:
					    pushCode('IfEquals', stream.readU24());
					    break;
					case 20:
					    pushCode('IfNotEquals', stream.readU24());
					    break;
					case 21:
					    pushCode('IfLessThan', stream.readU24());
					    break;
					case 22:
					    pushCode('IfLessEquals', stream.readU24());
					    break;
					case 23:
					    pushCode('IfGreaterThan', stream.readU24());
					    break;
					case 24:
					    pushCode('IfGreaterEquals', stream.readU24());
					    break;
					case 25:
					    pushCode('IfStrictEquals', stream.readU24());
					    break;
					case 26:
					    pushCode('IfStrictNotEquals', stream.readU24());
					    break;
					case 12:
					    pushCode('IfNotLessThan', stream.readU24());
					    break;
					case 13:
					    pushCode('IfNotLessEquals', stream.readU24());
					    break;
					case 14:
					    pushCode('IfNotGreaterThan', stream.readU24());
					    break;
					case 15:
					    pushCode('IfNotGreaterEquals', stream.readU24());
					    break;
					case 27:
					    pushCode('LookupSwitch', stream.readU24());
					    var switchCases:uint = stream.readU32();
					    for (var caseIndex:uint = 0; caseIndex < switchCases; ++caseIndex) {
					        stream.readU24();
					    }
					    break;
					case 32:
					    pushCode('PushNull');
					    break;
					case 33:
					    pushCode('PushUndefined');
					    break;
					case 34:
					    pushCode('PushConstant', cp.getMultiName(stream.readU32()));
					    break;
					case 44:
					    pushCode('PushString', cp.getString(stream.readU32()));
					    break;
					case 49:
					    pushCode('PushNamespace', cp.getNamespace(stream.readU32()));
					    break;
					case 46:
					    pushCode('PushUint', cp.getUint(stream.readU32()));
					    break;
					case 47:
					    pushCode('PushDouble', cp.getDouble(stream.readU32()));
					    break;
					case 45:
					    pushCode('PushInt', cp.getInt(stream.readU32()));
					    break;
					case 36:
					    pushCode('PushByte', stream.readU8());
					    break;
					case 37:
					    pushCode('PushShort', stream.readU32());
					    break;
					case 38:
					    pushCode('PushTrue');
					    break;
					case 39:
					    pushCode('PushFalse');
					    break;
					case 40:
					    pushCode('PushNaN');
					    break;
					case 41:
					    pushCode('Pop');
					    break;
					case 42:
					    pushCode('Dup');
					    break;
					case 43:
					    pushCode('Swap');
					    break;
					case 64:
					    pushCode('NewFunction', 'func:' + stream.readU32());
					    break;
					case 88:
					    pushCode('NewClass', 'class:' + stream.readU32());
					    break;
					case 65:
					    pushCode('Call', 'size:' + stream.readU32());
					    break;
					case 66:
					    pushCode('Construct', 'size:' + stream.readU32());
					    break;
					case 68:
					    pushCode('CallStatic', 'method:' + stream.readU32(), 'argc:' + stream.readU32());
					    break;
					case 67:
					    pushCode('CallMethod', 'dispid:' + stream.readU32(), 'argc:' + stream.readU32());
					    break;
					case 69:
					    pushCode('CallSuper', cp.getMultiName(stream.readU32()), 'argc:' + stream.readU32());
					    break;
					case 73:
					    pushCode('ConstructSuper', 'argc:' + stream.readU32());
					    break;
					case 70:
					    pushCode('CallProperty', cp.getMultiName(stream.readU32()), 'argc:' + stream.readU32());
					    break;
					case 76:
					    pushCode('CallPropertyLex', cp.getMultiName(stream.readU32()), 'argc:' + stream.readU32());
					    break;
					case 74:
					    pushCode('ConstructProperty', cp.getMultiName(stream.readU32()), 'argc:' + stream.readU32());
					    break;
					case 78:
						pushCode('CallSuperVoid', cp.getMultiName(stream.readU32()), 'argc:' + stream.readU32());
						break;
					case 79:
						pushCode('CallPropertyVoid', cp.getMultiName(stream.readU32()), 'argc:' + stream.readU32());
						break;
					case 71:
					    pushCode('ReturnVoid');
					    break;
					case 72:
					    pushCode('ReturnValue');
					    break;
					case 87:
					    pushCode('NewActivation');
					    break;
					case 90:
					    pushCode('NewCatch', stream.readU32());
					    break;
					case 85:
					    pushCode('NewObject', 'size:' + stream.readU32());
					    break;
					case 86:
					    pushCode('NewArray', 'size:' + stream.readU32());
					    break;
					case 208:
						pushCode('GetLocal0');
						break;
					case 209:
						pushCode('GetLocal1');
						break;
					case 210:
						pushCode('GetLocal2');
						break;
					case 211:
					    pushCode('Getlocal3');
					    break;
					case 98:
					    pushCode('Getlocal', 'r' + stream.readU32());
					    break;
					case 212:
						pushCode('SetLocal0');
						break;
					case 213:
						pushCode('SetLocal1');
						break;
					case 214:
						pushCode('SetLocal2');
						break;
					case 215:
					    pushCode('Setlocal3');
					    break;
					case 99:
					    pushCode('Setlocal', 'r' + stream.readU32());
					    break;
					case 100:
					    pushCode('GetGlobalScope');
					    break;
					case 101:
					    pushCode('GetScopeObject', 'index:' + stream.readU8());
					    break;
					case 102:
					    pushCode('GetProperty', cp.getMultiName(stream.readU32()));
					    break;
					case 4:
					    pushCode('GetSuper', cp.getMultiName(stream.readU32()));
					    break;
					case 89:
					    pushCode('GetDescendants', cp.getMultiName(stream.readU32()));
					    break;
					case 91:
					    pushCode('DeleteDescendants', stream.readU32());
					    break;
					case 106:
					    pushCode('DeleteProperty', cp.getMultiName(stream.readU32()));
					    break;
					case 97:
					    pushCode('SetProperty', cp.getMultiName(stream.readU32()));
					    break;
					case 104:
					    pushCode('InitProperty', cp.getMultiName(stream.readU32()));
					    break;
					case 5:
					    pushCode('SetSuper', cp.getMultiName(stream.readU32()));
					    break;
					case 28:
					    pushCode('PushWith');
					    break;
					case 48:
					    pushCode('PushScope');
					    break;
					case 29:
					    pushCode('PopScope');
					    break;
					case 30:
					    pushCode('NextName');
					    break;
					case 35:
					    pushCode('NextValue');
					    break;
					case 89:
					    pushCode('Descendants');
					    break;
					case 31:
					    pushCode('HasNext');
					    break;
					case 50:
					    pushCode('HasNext2', stream.readU32(), stream.readU32());
					    break;
					case 112:
					    pushCode('Convert.s');
					    break;
					case 113:
					    pushCode('Esc.xelem');
					    break;
					case 114:
					    pushCode('Esc.xattr');
					    break;
					case 120:
					    pushCode('CheckFilter');
					    break;
					case 115:
					    pushCode('Convert.i');
					    break;
					case 116:
					    pushCode('Convert.u');
					    break;
					case 117:
					    pushCode('Convert.d');
					    break;
					case 118:
					    pushCode('Convert.b');
					    break;
					case 119:
					    pushCode('Convert.o');
					    break;
					case 128:
					    pushCode('Coerce', cp.getMultiName(stream.readU32()));
					    break;
					case 129:
						pushCode('Coerce.b');
						break;
					case 130:
					    pushCode('Coerce.o');
					    break;
					case 131:
						pushCode('Coerce.i');
						break;
					case 136:
						pushCode('Coerce.u');
						break;
					case 132:
						pushCode('Coerce.d');
						break;
					case 133:
					    pushCode('Coerce.s');
					    break;
					case 134:
					    pushCode('AsType', cp.getMultiName(stream.readU32()));
					    break;
					case 135:
					    pushCode('AsTypeLate');
					    break;
					case 144:
					    pushCode('Negate');
					    break;
					case 196:
					    pushCode('Negate.i');
					    break;
					case 145:
					    pushCode('Increment');
					    break;
					case 192:
					    pushCode('Increment.i');
					    break;
					case 146:
					    pushCode('IncLocal', 'r' + stream.readU32());
					    break;
					case 194:
					    pushCode('IncLocal.i', 'r' + stream.readU32());
					    break;
					case 147:
					    pushCode('Decrement');
					    break;
					case 193:
					    pushCode('Decrement.i');
					    break;
					case 148:
					    pushCode('DecLocal', 'r' + stream.readU32());
					    break;
					case 195:
					    pushCode('DecLocal.i', 'r' + stream.readU32());
					    break;
					case 149:
					    pushCode('Typeof');
					    break;
					case 150:
					    pushCode('Not');
					    break;
					case 160:
					    pushCode('Add');
					    break;
					case 197:
					    pushCode('Add.i');
					    break;
					case 161:
					    pushCode('Subtract');
					    break;
					case 198:
					    pushCode('Subtract.i');
					    break;
					case 162:
					    pushCode('Multiply');
					    break;
					case 199:
					    pushCode('Multiply.i');
					    break;
					case 163:
					    pushCode('Divide');
					    break;
					case 164:
					    pushCode('Modulo');
					    break;
					case 165:
					    pushCode('LeftShift');
					    break;
					case 166:
					    pushCode('RightShift');
					    break;
					case 167:
					    pushCode('URightShift');
					    break;
					case 168:
					    pushCode('BitAnd');
					    break;
					case 169:
					    pushCode('BitOr');
					    break;
					case 8:
						pushCode('Kill', 'r' + stream.readU32());
						break;
					case 6:
						pushCode('DefaultXMLNamespace', cp.getMultiName(stream.readU32()));
						break;
					case 7:
						pushCode('DefaultXMLNamespaceLate');
						break;
					case 240:
						pushCode('DebugLine', stream.readU32());
						break;
					case 241:
						pushCode('DebugFile', cp.getString(stream.readU32()));
						break;
					case 242:
						pushCode('BkptLine', stream.readU32());
						break;
					case 239:
						pushCode('Debug', 'di_local:' + stream.readU8(), stream.readU32(),
								 'slot:' + stream.readU8(), 'linenum:' + stream.readU32());
						break;
					case 151:
						pushCode('BitNot');
						break;
					case 109:
						pushCode('SetSlot', stream.readU32());
						break;
					case 111:
						pushCode('SetLocalSlot', stream.readU32());
						break;
					case 108:
						pushCode('GetSlot', stream.readU32());
						break;
					case 110:
						pushCode('GetLocalSlot', stream.readU32());
						break;
					case 94:
						pushCode('FindProperty', cp.getMultiName(stream.readU32()));
						break;
					case 93:
						pushCode('FindPropertyStrict', cp.getMultiName(stream.readU32()));
						break;
					case 95:
						pushCode('FindDef', cp.getMultiName(stream.readU32()));
						break;
					case 96:
						pushCode('GetLex', cp.getMultiName(stream.readU32()));
						break;
					case 179:
						pushCode('IsTypeLate');
						break;
					case 178:
						pushCode('IsType', cp.getMultiName(stream.readU32()));
						break;
					case 180:
						pushCode('In');
						break;
					case 177:
						pushCode('Instanceof');
						break;
					case 176:
						pushCode('GreaterEquals');
						break;
					case 175:
						pushCode('GreaterThan');
						break;
					case 174:
						pushCode('LessEquals');
						break;
					case 173:
						pushCode('LessThan');
						break;
					case 172:
						pushCode('StrictEquals');
						break;
					case 171:
						pushCode('Equals');
						break;
					case 170:
						pushCode('BitXor');
						break;
					case 243:
						pushCode('TimeStamp');
						break;
					case 83:
						pushCode('ApplyType');
						break;
					default:
						pushCode('Code:' + opCode);
						break;
				}
			}
			
			return codes;
		}
		
		private function toClassName(mn:MultiName):String
		{
			var uri:String = mn.namespace.uri;
			
			return (uri != null && uri.length > 0 ? uri + '::' : '') + mn.name + (mn.typeParameters.length > 0 ? '.<' + mn.typeParameters.join(',') + '>' : '');
		}
		
		private function toPropertyName(modifier:String, mn:MultiName, qualified:Boolean = false):String
		{
			var type:String = mn.namespace.type;
			var uri:String = qualified ? mn.namespace.uri : '';
			
			return (type != null && type.length > 0 ? type + ' ' : '') + (uri != null && uri.length > 0 ? uri + '::' : '') + modifier + mn.name;
		}
	}
}

import org.libspark.disassemble.abc.MultiName;

class MethodInfo
{
	public function MethodInfo(isNative:Boolean, args:String)
	{
		this.isNative = isNative;
		this.args = args;
	}
	
	public var isNative:Boolean;
	public var args:String;
	
	public function getSignature(modifier:String, mn:MultiName, qualified:Boolean = false):String
	{
		var type:String = mn.namespace.type;
			var uri:String = qualified ? mn.namespace.uri : '';
		
		return (type != null && type.length > 0 ? type + ' ' : '') + (isNative ? 'native ' : '') + modifier + (uri != null && uri.length > 0 ? uri + '::' : '') + mn.name + args;
	}
}

class Traits
{
	public function Traits(value:String)
	{
		this.value = value;
	}
	
	public var value:String;
}

class InstanceInfo
{
	public function InstanceInfo(header:String, ctor:String, instanceDefs:Traits)
	{
		this.header = header;
		this.ctor = ctor;
		this.instanceDefs = instanceDefs;
	}
	
	public var header:String;
	public var ctor:String;
	public var instanceDefs:Traits
	
	public function getSignature(classDefs:Traits):String
	{
		return header + "\n{\n" + classDefs.value + ctor + instanceDefs.value + "}\n";
	}
}