package begin.eval {
	import flash.utils.ByteArray;

	/**
	 * @author aime
	 */
	public final class EvalSupport {

		[Embed(source="support/debug.es.abc",mimeType="application/octet-stream")]
		public static const DEBUG_ES_ABC : Class;

		[Embed(source="support/util.es.abc",mimeType="application/octet-stream")]
		public static const UTIL_ES_ABC : Class;

		[Embed(source="support/bytes-tamarin.es.abc",mimeType="application/octet-stream")]
		public static const BYTES_TAMARIN_ES_ABC : Class;

		[Embed(source="support/util-tamarin.es.abc",mimeType="application/octet-stream")]
		public static const UTIL_TAMARIN_ES_ABC : Class;

		[Embed(source="support/lex-char.es.abc",mimeType="application/octet-stream")]
		public static const LEX_CHAR_ES_ABC : Class;

		[Embed(source="support/lex-scan.es.abc",mimeType="application/octet-stream")]
		public static const LEX_SCAN_ES_ABC : Class;

		[Embed(source="support/lex-token.es.abc",mimeType="application/octet-stream")]
		public static const LEX_TOKEN_ES_ABC : Class;

		[Embed(source="support/ast.es.abc",mimeType="application/octet-stream")]
		public static const AST_ES_ABC : Class;

		[Embed(source="support/parse.es.abc",mimeType="application/octet-stream")]
		public static const PARSE_ES_ABC : Class;

		[Embed(source="support/asm.es.abc",mimeType="application/octet-stream")]
		public static const ASM_ES_ABC : Class;

		[Embed(source="support/abc.es.abc",mimeType="application/octet-stream")]
		public static const ABC_ES_ABC : Class;

		[Embed(source="support/abc-parse.es.abc",mimeType="application/octet-stream")]
		public static const ABC_PARSE_ES_ABC : Class;     

		[Embed(source="support/emit.es.abc",mimeType="application/octet-stream")]
		public static const EMIT_ES_ABC : Class;

		[Embed(source="support/cogen.es.abc",mimeType="application/octet-stream")]
		public static const COGEN_ES_ABC : Class;

		[Embed(source="support/cogen-stmt.es.abc",mimeType="application/octet-stream")]
		public static const COGEN_STMT_ES_ABC : Class;

		[Embed(source="support/cogen-expr.es.abc",mimeType="application/octet-stream")]
		public static const COGEN_EXPR_ES_ABC : Class;

		[Embed(source="support/esc-core.es.abc",mimeType="application/octet-stream")]
		public static const ESC_CORE_ES_ABC : Class;

		[Embed(source="support/esc-env.es.abc",mimeType="application/octet-stream")]
		public static const ESC_ENV_ES_ABC : Class; 

		[Embed(source="support/eval-support.es.abc",mimeType="application/octet-stream")]
		public static const EVAL_SUPPORT_ES_ABC : Class;     

		[Embed(source="support/define.es.abc",mimeType="application/octet-stream")]
		public static const DEFINE_ES_ABC : Class;            
		
		public static function getBytes() : Array {
			return [new DEBUG_ES_ABC as ByteArray,
					new UTIL_ES_ABC as ByteArray,
					new BYTES_TAMARIN_ES_ABC as ByteArray,
					new UTIL_TAMARIN_ES_ABC as ByteArray,
					new LEX_CHAR_ES_ABC as ByteArray,
					new LEX_SCAN_ES_ABC as ByteArray,
					new LEX_TOKEN_ES_ABC as ByteArray,
					new AST_ES_ABC as ByteArray,
					new PARSE_ES_ABC as ByteArray,
					new ASM_ES_ABC as ByteArray,
					new ABC_ES_ABC as ByteArray,
					new ABC_PARSE_ES_ABC as ByteArray,
					new EMIT_ES_ABC as ByteArray,
					new COGEN_ES_ABC as ByteArray,
					new COGEN_STMT_ES_ABC as ByteArray,
					new COGEN_EXPR_ES_ABC as ByteArray,
					new ESC_CORE_ES_ABC as ByteArray,
					new EVAL_SUPPORT_ES_ABC as ByteArray,
					new ESC_ENV_ES_ABC as ByteArray,
					new DEFINE_ES_ABC as ByteArray];
		}    
	}
}
