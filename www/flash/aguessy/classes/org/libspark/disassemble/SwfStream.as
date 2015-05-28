package org.libspark.disassemble
{
	import flash.utils.IDataInput;
	import flash.utils.ByteArray;
	import flash.errors.EOFError;
	import flash.utils.Endian;
	import flash.net.ObjectEncoding;
	
	public class SwfStream implements IDataInput
	{
		private var bytes:ByteArray;
		private var bitCursor:uint;
		private var endOfHeader:uint;
		private var isCompressed_:Boolean;
		private var version_:uint;
		private var height_:int;
		private var width_:int;
		private var frameRate_:uint;
		private var totalFrames_:uint;
		
		public function SwfStream(byteCode:ByteArray)
		{
			if (byteCode.length < 8) {
				throw new EOFError();
			}
			
			resetBitCursor();
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(byteCode);
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = 0;
			
			if (bytes[0] == 0x43) {
				isCompressed_ = true;
				
				var compressedBytes:ByteArray = new ByteArray();
				compressedBytes.writeBytes(bytes, 8);
				bytes.length = 8;
				compressedBytes.uncompress();
				bytes.position = 8;
				bytes.writeBytes(compressedBytes);
				compressedBytes.length = 0;
			}
			else {
				isCompressed_ = false;
			}
			
			this.bytes = bytes;
			
			parseAndValidateSwfHeader();
		}
		
		private function parseAndValidateSwfHeader():void
		{
			reset();
			var byte1:uint = readByte();
			if (byte1 != 0x46 && byte1 != 0x43) {
				throw new Error('Invalid SWF file');
			}
			if (readByte() != 0x57) {
				throw new Error('Invalid SWF file');
			}
			if (readByte() != 0x53) {
				throw new Error('Invalid SWF file');
			}
			
			version_ = readByte();
			
			if (readUnsignedInt() != length) {
				throw new Error('Invalid SWF file');
			}
			
			resetBitCursor();
			var rectNBits:uint = readUnsignedBits(5);
			readBits(rectNBits);
			width_ = readBits(rectNBits) / 20;
			readBits(rectNBits);
			height_ = readBits(rectNBits) / 20;
			
			readByte();
			readByte();
			
			frameRate_ = readByte();
			totalFrames_ = readUnsignedShort();
			
			endOfHeader = position;
		}
		
		public function get isCompressed():Boolean
		{
			return isCompressed_;
		}
		
		public function get version():uint
		{
			return version_;
		}
		
		public function get height():int
		{
			return height_;
		}
		
		public function get width():int
		{
			return width_;
		}
		
		public function get frameRate():uint
		{
			return frameRate_;
		}
		
		public function get totalFrames():uint
		{
			return totalFrames_;
		}
		
		public function get length():uint
		{
			return bytes.length;
		}
		
		public function set length(len:uint):void
		{
			bytes.length = len;
		}
		
		public function get position():uint
		{
			return bytes.position;
		}
		
		public function set position(pos:uint):void
		{
			bytes.position = pos;
		}
		
		public function get bytesAvailable():uint
		{
			return bytes.bytesAvailable;
		}
		
		public function get endian():String
		{
			return bytes.endian;
		}
		
		public function set endian(value:String):void
		{
			bytes.endian = value;
		}
		
		public function reset():void
		{
			bytes.position = 0;
		}
		
		public function seekToBody():void
		{
			bytes.position = endOfHeader;
		}
		
		public function seek(pos:uint):void
		{
			bytes.position += pos;
		}
		
		public function readBoolean():Boolean
		{
			return bytes.readBoolean();
		}
		
		public function readByte():int
		{
			return bytes.readByte();
		}
		
		public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			this.bytes.readBytes(bytes, offset, length);
		}
		
		public function readDouble():Number
		{
			return bytes.readDouble();
		}
		
		public function readFloat():Number
		{
			return bytes.readFloat();
		}
		
		public function readInt():int
		{
			return bytes.readInt();
		}
		
		public function readMultiByte(length:uint, charSet:String):String
		{
			return bytes.readMultiByte(length, charSet);
		}
		
		public function readObject():*
		{
			return bytes.readObject();
		}
		
		public function readShort():int
		{
			return bytes.readShort();
		}
		
		public function readUnsignedByte():uint
		{
			return bytes.readUnsignedByte();
		}
		
		public function readUnsignedInt():uint
		{
			return bytes.readUnsignedInt();
		}
		
		public function readUnsignedShort():uint
		{
			return bytes.readUnsignedShort();
		}
		
		public function readUTF():String
		{
			return bytes.readUTF();
		}
		
		public function readUTFBytes(length:uint):String
		{
			return bytes.readUTFBytes(length);
		}
		
		public function readBits(length:uint):int
		{
			var result:int = 0;
			var bytes_:ByteArray = bytes;
			var bitCursor_:uint = bitCursor;
			while (length > bitCursor_) {
				length -= bitCursor_;
				result += int(bytes_.readByte() & (0xff >>> (8 - bitCursor_))) << length;
				bitCursor_ = 8;
			}
			bitCursor_ = 8 - length;
			result += int(bytes_[bytes_.position] >>> (bitCursor_));
			bitCursor = bitCursor_;
			return result;
		}
		
		public function readUnsignedBits(length:uint):uint
		{
			var result:uint = 0;
			var bytes_:ByteArray = bytes;
			var bitCursor_:uint = bitCursor;
			while (length > bitCursor_) {
				length -= bitCursor_;
				result += uint(bytes_.readByte() & (0xff >>> (8 - bitCursor_))) << length;
				bitCursor_ = 8;
			}
			bitCursor_ = 8 - length;
			result += uint(bytes_[bytes_.position] >>> (bitCursor_));
			bitCursor = bitCursor_;
			return result;
		}
		
		public function resetBitCursor():void
		{
			bitCursor = 8;
		}
		
		public function get objectEncoding():uint
		{
			return ObjectEncoding.DEFAULT;
		}
		
		public function set objectEncoding(value:uint):void
		{
		}
	}
}