package asSist 
{
	import flash.events.Event;
	import mx.binding.utils.ChangeWatcher;

	/**
	 * TwoWayBinding クラスは、ActionScript から双方向データバインディングを作成
	 * するための静的なクラスです。
	 *
	 * <p>プログラムからデータバインディングを作成するには、通常、BindingUtils 
	 * クラスの <code>bindProperty</code> メソッドを利用しますが、
	 * 双方向に作成するとスタックオーバーフローしてしまいます。
	 * このクラスは双方向のデータバインディングを簡単に作成するための
	 *  <code>TwoWayBinding.create</code> メソッドを用意しています。</p>
	 */
	public class TwoWayBinding
	{
		/**
		 * 双方向データバインディングを作成します。
		 * @param src1  １つ目のオブジェクトを指定します。
		 * @param prop1 １つ目のプロパティを指定します。
		 * @param src2  ２つ目のオブジェクトを指定します。
		 * @param prop2 ２つ目のプロパティを指定します。
		 */
		public static function create(src1:Object, prop1:String, src2:Object, prop2:String):void
		{
			var flag:Boolean = false;

			ChangeWatcher.watch(src1, prop1, function(event:Event):void
			{
				if(!flag)
				{
					flag = true;
					src2[prop2] = src1[prop1];
					flag = false;
				}
			});

			ChangeWatcher.watch(src2, prop2, function(event:Event):void
			{
				if(!flag)
				{
					flag = true;
					src1[prop1] = src2[prop2];
					flag = false;
				}
			});
		}
	}
}