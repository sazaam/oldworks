package org.libspark.disassemble
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ByteStream
	{
		private var byteArray:ByteArray;
		
		public function ByteStream(input:ByteArray)
		{
			input.endian = Endian.LITTLE_ENDIAN;
			this.byteArray = input;
		}
		
		public function readU8():uint
		{
			return byteArray.readByte() & 0xff;
		}
		
		public function readU16():uint
		{
			return byteArray.readUnsignedShort() & 0xffff;
		}
		
		public function readU24():uint
		{
			var byte1:uint = byteArray.readByte() & 0xff;
			var byte2:uint = byteArray.readByte() & 0xff;
			var byte3:uint = byteArray.readByte() & 0xff;
			return byte1 | (byte2 << 8) | (byte3 << 16);
		}
		
		public function readU32():uint
		{
			var result:uint = readU8();
			if ((result & 0x00000080) == 0) {
				return result;
			}
			result = (result & 0x0000007f) | readU8() << 7;
			if ((result & 0x00004000) == 0) {
				return result;
			}
			result = (result & 0x00003fff) | readU8() << 14;
			if ((result & 0x00200000) == 0) {
				return result;
			}
			result = (result & 0x001fffff) | readU8() << 21;
			if ((result & 0x10000000) == 0) {
				return result;
			}
			return (result & 0x0fffffff) | readU8() << 28;
		}
		
		public function readString(length:uint):String
		{
			return byteArray.readUTFBytes(length);
		}
		
		public function readDouble():Number
		{
			return byteArray.readDouble();
		}
		
		public function seek(position:uint):void
		{
			byteArray.position = position;
		}
		
		public function skip(length:uint):void
		{
			byteArray.position += length;
		}
		
		public function skipU32(count:uint):void
		{
			for (var i:uint = 0; i < count; ++i) {
				readU32();
			}
		}
		
		public function get position():uint
		{
			return byteArray.position;
		}
		public function set position(pos:uint):void
		{
			byteArray.position = pos;
		}
	}
}