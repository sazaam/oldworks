package sketchbook.generators
{
	import sketchbook.generators.IGenerator;

	/**
	 * Generatorのアブストラクトなベースクラス
	 * 
	 * <p>このクラスはGeneratorの基底クラスとして用いられ、実際に作成されることはありません。</p>
	 */
	public class Generator implements IGenerator
	{
		/** 生成された値のキャッシュ */
		protected var _value:*
		
		/** 
		 * 生成された値を返します。update()が呼ばれるまで値は変化しません。 
		 * 
		 * @return 最後に更新した値。
		 */
		public function get value():*
		{
			return _value;
		}
		
		/** インスタンスの複製を返します */
		public function clone():IGenerator
		{
			throw new Error("Generator.clone(): this method should be implemented in subclasses");
			return null;
		}
		
		/** 
		 * 生成する値を更新します。
		 * 
		 * <p>サブクラスを作る場合は、基本的にここには手をいれません。updateCounter, updateValueをオーバーライドしてください。<p>
		 * 
		 * @return 新しい値
		 */
		public function update():*
		{
			updateCounter();
			updateValue();
			return _value
		}
		
		/** 値に変換する */
		public function valueOf():*
		{
			return _value
		}
		
		//アップデートごとに進むカウンターのようなものがある場合、ここで変化させる。サブクラスでオーバーライドすること
		protected function updateCounter():void
		{
		}
		
		//実際に値をアップデートする関数。サブクラスでオーバーライドすること
		protected function updateValue():void
		{
		}
	}
}