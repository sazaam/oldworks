package begin.type.utility {
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * 
	 */
	public final class ClassReader extends ClassBytes {
		/**
		 * 
		 * @param	data
		 */
		public function ClassReader(data : ByteArray = null) : void {
			super();
			var endian : String;
			var tag : String;
			if (data != null) {
				endian = data.endian;
				data.endian = Endian.LITTLE_ENDIAN;
				if (data.bytesAvailable > 26) {
					tag = data.readUTFBytes(3);
					if (tag == SWF_TAG || tag == SWF_TAG_COMPRESSED) {
						this._version = data.readUnsignedByte();
						data.readUnsignedInt();
						data.readBytes(this);
						if (tag == SWF_TAG_COMPRESSED) 
							super.uncompress();
					} else {
						throw new ArgumentError('Error #2124: Loaded file is an unknown type.');
					}
					this.readHeader();
				}
				data.endian = endian;
			}
		}
		
		/**
		 * 
		 * @return
		 */
		override public function readASInt() : int {
			var result : uint = 0;
			var i : uint = 0, byte : uint;
			do {
				byte = super.readUnsignedByte();
				result |= ( byte & 0x7F ) << ( i * 7 );
				i += 1;
			} while ( byte & 1 << 7 );
			return result;	        
		}
		
		/**
		 * 
		 * @return
		 */
		public function readRect() : Rectangle {
			var pos : uint = super.position;
			var byte : uint = this[pos];
			var bits : uint = byte >> 3;
			var xMin : Number = this.readBits(bits, 5) / 20;
			var xMax : Number = this.readBits(bits) / 20;
			var yMin : Number = this.readBits(bits) / 20;
			var yMax : Number = this.readBits(bits) / 20;
			super.position = pos + Math.ceil(((bits * 4) - 3) / 8) + 1;
			return new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);
		}
		
		/**
		 * 
		 * @param	length
		 * @param	start
		 * @return
		 */
		public function readBits(length : uint, start : int = -1) : Number {
			if (start < 0) start = this._bitIndex;
			this._bitIndex = start;
			var byte : uint = this[super.position];
			var out : Number = 0;
			var currentByteBitsLeft : uint = 8 - start;
			var bitsLeft : Number = length - currentByteBitsLeft;
			if (bitsLeft > 0) {
				super.position++;
				out = this.readBits(bitsLeft, 0) | ((byte & ((1 << currentByteBitsLeft) - 1)) << (bitsLeft));
			} else {
				out = (byte >> (8 - length - start)) & ((1 << length) - 1);
				this._bitIndex = (start + length) % 8;
				if (start + length > 7) super.position++;
			}
			return out;
		}
		
		/**
		 * 
		 */
		public function get frameRate() : Number {
			return this._frameRate;	
		}

		public function get rect() : Rectangle {
			return this._rect;
		}
		
		/**
		 * 
		 */
		public function get version() : uint {
			return this._version;
		}

		/**
		 * @private
		 */
		private function readFrameRate() : void {
			if (this._version < 8) {
				this._frameRate = super.readUnsignedShort();
			} else {
				var fixed : Number = super.readUnsignedByte() / 0xFF;
				this._frameRate = super.readUnsignedByte() + fixed;
			}
		}

		/**
		 * @private
		 */
		private function readHeader() : void {
			this._rect = this.readRect();
			this.readFrameRate();		
			super.readShort(); // num of frames
		}

		/**
		 * @private
		 */
		private var _frameRate : Number;

		/**
		 * @private
		 */
		private var _rect : Rectangle;

		/**
		 * @private
		 */
		private var _bitIndex : uint;

		/**
		 * @private
		 */
		private var _version : uint;
	}
}