package begin.eval.dump {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ByteLoader extends EventDispatcher {

		public function ByteLoader() {
		}

		/**
		 * The generated LoaderInfo.
		 * 
		 * @return LoaderInfo - the generated LoaderInfo.
		 */
		public function getLoaderInfo() : LoaderInfo {
			return loaderInfo;
		}
		
		/**
		 * This looks at the array header and decides what it is.
		 * (getType&1)==1 => it's  SWF
		 * (getType&2)==2 => it's  ABC
		 * (getType&4)==4)=> it's compressed
		 * 
		 * @param data ByteArray - the ByteArray to test.
		 * @return int - 4 if it's compressed, 2 if it's ABC, 1 if it's a SWF.
		 */
		public static function getType(data : ByteArray) : int {
			data.endian = "littleEndian";
			var version : uint = data.readUnsignedInt();
			switch (version) {
				case 46 << 16 | 14: //ABC
				case 46 << 16 | 15: //ABC
				case 46 << 16 | 16: //ABC
					return 2;
				case 67 | 87 << 8 | 83 << 16 | 10 << 24: //SWC10	
				case 67 | 87 << 8 | 83 << 16 | 9 << 24: // SWC9
				case 67 | 87 << 8 | 83 << 16 | 8 << 24: // SWC8
				case 67 | 87 << 8 | 83 << 16 | 7 << 24: // SWC7
				case 67 | 87 << 8 | 83 << 16 | 6 << 24: // SWC6
					return 4;
				case 70 | 87 << 8 | 83 << 16 | 10 << 24: // SWF10	
				case 70 | 87 << 8 | 83 << 16 | 9 << 24: // SWF9
				case 70 | 87 << 8 | 83 << 16 | 8 << 24: // SWF8
				case 70 | 87 << 8 | 83 << 16 | 7 << 24: // SWF7
				case 70 | 87 << 8 | 83 << 16 | 6 << 24: // SWF6
				case 70 | 87 << 8 | 83 << 16 | 5 << 24: // SWF5
				case 70 | 87 << 8 | 83 << 16 | 4 << 24: // SWF4
					return 1;
				default:
					return 0;
			}
		}
		
		/**
		 * 
		 */
		public static function isSWF(data : ByteArray) : Boolean {
			var type : int = getType(data);
			return (type & 1) == 1;
		}

		/**
		 * Load the bytecodes passed into the flash VM, using
		 * the current application domain, or a child of it.
		 *
		 * @param bytes
		 * @param inplace
		 */
		public function loadBytes(bytes : *, inplace : Boolean = false) : void {
			if (bytes is Array || (getType(bytes) == 2)) {
				if (!(bytes is Array)) {
					bytes = [bytes];
				}
				bytes = wrapInSWF(bytes);
			}
			try {
				var c : LoaderContext;
				if (inplace)
					c = new LoaderContext();
				var l : Loader = new Loader();
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);				
				l.loadBytes(bytes, c);
			} catch (e : *) {
				Util.print(e);
			} finally {
				//trace("done.");
				// darn it. the running of the bytes doesn't happen until current scripts are done. no try/catch can work
			}
		}

		/**
		 * Wraps the ABC bytecode inside the simplest possible SWF file, for
		 * the purpose of allowing the player VM to load it.
		 *  
		 * @param bytes: an ABC file
		 * @return a SWF file 
		 * 
		 */
		public static function wrapInSWF(bytes : Array) : ByteArray {
			// wrap our ABC bytecodes in a SWF.
			var out : ByteArray = new ByteArray;
			var i : int;
			var j : int;
			var abc : ByteArray;
			out.endian = Endian.LITTLE_ENDIAN;
			for (i = 0;i < swf_start.length;i++)
				out.writeByte(swf_start[i]);
			for (i = 0;i < bytes.length;i++) {
				abc = bytes[i];
				for (j = 0;j < abc_header.length;j++) {
					out.writeByte(abc_header[j]);
				}
				// set ABC length
				out.writeInt(abc.length);
				out.writeBytes(abc, 0, abc.length);
			}
			for (i = 0;i < swf_end.length;i++)
				out.writeByte(swf_end[i]);
			// set SWF length
			out.position = 4;
			out.writeInt(out.length);
			// reset
			out.position = 0;
			return out;
		}
		
		/**
		 * @private
		 */
		private function complete(evt : Event) : void {
			loaderInfo = LoaderInfo(evt.target);
			dispatchEvent(evt.clone());
		}

		/**
		 * @private
		 */
		private static var abc_header : Array = [0x3f, 0x12,/* Tag type=72 (DoABC), length=next. */
		 	/*0xff, 0xff, 0xff, 0xff 								// ABC length, not included in the copy.*/ 
		];

		// the commented out code tells the player to instance a class "test" as a Sprite. 
		private static var swf_end : Array = [/*0x09, 0x13, 0x01, 0x00, 0x00, 0x00, 0x74, 0x65, 0x73, 0x74, 0x00, */0x40, 0x00]; // Tag type=1 (ShowFrame), length=0

		private static var swf_start : Array = [0x46, 0x57, 0x53, 0x09, 								/* FWS, Version 9*/
			0xff, 0xff, 0xff, 0xff, 								/* File length */
			0x78, 0x00, 0x03, 0xe8, 0x00, 0x00, 0x0b, 0xb8, 0x00,	/* size [Rect 0 0 8000 6000] */
		 	0x00, 0x0c, 0x01, 0x00, 								/* 16bit le frame rate 12, 16bit be frame count 1 */
		 	0x44, 0x11,												/* Tag type=69 (FileAttributes), length=4  */
		 	0x08, 0x00, 0x00, 0x00];
		
		private var loaderInfo : LoaderInfo;
		 	
	}
}
