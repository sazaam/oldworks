package sketchbook.generators
{
	/**
	 * 変化する値を生成するGeneratorクラスのインターフェースを提供します。
	 * <p>全てのGeneratorはこのインタフェースを実装する必要があります。</p>
	 */
	public interface IGenerator
	{
		/** 値を更新する為の関数 */
		function update():*
		/** 値を取得する為の関数 */
		function get value():*
		/** インスタンスの複製を返す為の関数 */
		function clone():IGenerator
		/** 数値型に変換したときに値を返す為の関数 */
		function valueOf():*
	}
}