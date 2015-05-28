package sketchbook.generators
{
	/**
	 * Generatorの値をターゲットのプロパティに注入するクラス
	 *  
	 * <p>以下のサンプルは、Spriteのx,y座標と2つのSineGeneratorの値をバインドします。</p>
	 * 
	 * @example <listing version="3.0">
	 * //このサンプルはSpriteのX,Y座標を2つのSineGeneratorと連動させます。
	 * var xMotion:SineGenerator = new SineGenerator(100,100,10);
	 * var yMotion:SineGenerator = new SineGenerator(100,100,10);
	 * var bind:GeneratorBinder = new GeneratorBinder([this],{x:xMotion, y:yMotion});
	 * bind.update();</listing>
	 */
	public class GeneratorBinder
	{
		private var _targets:Array
		private var _propGeneratorPair:Object
		
		/**
		 * Generatorの値をターゲットのプロパティに注入するクラスです。
		 * 
		 * <p>指定した複数の対象のプロパティに対し、Generatorの値を自動で注入します。</p>
		 * 
		 * @param targets Generatorと結びつけるオブジェクトを配列で指定します。
		 * @param propGeneratorPair Generatorを対応するプロパティ名で格納した無名オブジェクト
		 */
		public function GeneratorBinder(targets:Array, propGeneratorPair:Object)
		{
			_propGeneratorPair = propGeneratorPair
			_targets = targets
			updateValue()
		}
		
		public function set propGeneratorPair(value:Object):void
		{
			_propGeneratorPair = value;
			updateValue()
		}
		
		/** Generatorを対応プロパティ名で格納した無名オブジェクト */
		public function get propGeneratorPair():Object
		{
			return _propGeneratorPair
		}
		
		
		public function set targets(targest:Array):void
		{
			_targets = targets.concat()
			updateValue()
		}
			
		/** Generatorの値を注入する対象のオブジェクトの配列 */
		public function get targets():Array
		{
			return _targets.concat();
		}
		
		/**
		 * Generatorの値を更新して、対象のオブジェクトに注入します。
		 */
		public function update():void
		{
			for each(var gen:IGenerator in propGeneratorPair)
				gen.update();
			updateValue();
		}
		
		private function updateValue():void
		{
			for each(var obj:Object in targets)
			{
				for (var prop:String in propGeneratorPair)
					obj[prop] = IGenerator(propGeneratorPair[prop]).value
			}
		}
	}
}