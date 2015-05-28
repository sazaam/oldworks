package begin.type.utility {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author aime
	 */
	public class ClassBytes extends ByteArray {
		
		/**
		 * 
		 */
		public static const SWF_TAG : String = 'FWS';
		
		/**
		 * 
		 */
		public static const SWF_TAG_COMPRESSED : String = 'CWS';
		
		/**
		 * 
		 */
		public function ClassBytes() {
			super();
			super.endian = Endian.LITTLE_ENDIAN;
		}
		
		/**
		 * 
		 * @return
		 */
		public function readASInt() : int {
			var pos : uint = super.position;
			var out : int = 0;
			var i : uint = 0;
			var byte : uint = this[pos];
			if (byte < 0x80) {
				super.position = pos + 1;
				return byte;
			}			
			pos += 1;
			while (byte >= 0x80) {
				out += (byte - 0x80) << (i * 7);
				i += 1;
				byte = this[pos];
				pos += 1;
			}
			out += (byte << (i * 7)); 
			super.position = pos;
			return out;
		}
		
		/**
		 * 
		 * @return
		 */
		public function readSignedInt24() : int {
			var pos : uint = super.position;
			var out : int = (this[pos] << 16);
			out += (this[pos += 1] << 8);
			out += this[pos += 1]; 	
			if (out >= 0x808080) {
				out -= 0xFFFFFF;
			}
			super.position = pos + 1;
			return out;
		}
		
		/**
		 * 
		 * @return
		 */
		public function readString() : String {
			var i : uint = super.position;
			var n : uint = this[i];
			while (n && (i += 1)) {
				n = this[i];
			}
			var str : String = super.readUTFBytes(i - super.position);
			super.position = i + 1; 
			return str;
		}
		
		/**
		 * 
		 * @return
		 */
		public function readUnsignedInt64() : Number {
			var n1 : Number = super.readUnsignedInt();
			var n2 : Number = super.readUnsignedInt();
			return n2 * 0x100000000 + n1;	
		}
		
		/**
		 * 
		 * @param	array
		 * @return
		 */
		public function traceArray(array : ByteArray) : String {
			// for debug 
			var out : String = '';
			var pos : uint = array.position;
			array.position = 0;
			while (array.bytesAvailable) {
				var str : String = array.readUnsignedByte().toString(16).toUpperCase();
				str = str.length < 2 ? '0' + str : str;
				out += str + ' ';
			}
			array.position = pos;
			return out;
		}
		
		/**
		 * 
		 * @param	bytesHexString
		 */
		public function writeBytesFromString(bytesHexString : String) : void {
			var length : uint = bytesHexString.length;	
			for (var i : uint = 0;i < length;i += 2) {
				var hexByte : String = bytesHexString.substr(i, 2);
				var byte : uint = parseInt(hexByte, 16);
				writeByte(byte);
			}
		}
	}
}
