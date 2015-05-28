package asSist 
{
	import flash.events.Event;
	import mx.binding.utils.ChangeWatcher;

	/**
	 * TwoWayBinding �N���X�́AActionScript ����o�����f�[�^�o�C���f�B���O���쐬
	 * ���邽�߂̐ÓI�ȃN���X�ł��B
	 *
	 * <p>�v���O��������f�[�^�o�C���f�B���O���쐬����ɂ́A�ʏ�ABindingUtils 
	 * �N���X�� <code>bindProperty</code> ���\�b�h�𗘗p���܂����A
	 * �o�����ɍ쐬����ƃX�^�b�N�I�[�o�[�t���[���Ă��܂��܂��B
	 * ���̃N���X�͑o�����̃f�[�^�o�C���f�B���O���ȒP�ɍ쐬���邽�߂�
	 *  <code>TwoWayBinding.create</code> ���\�b�h��p�ӂ��Ă��܂��B</p>
	 */
	public class TwoWayBinding
	{
		/**
		 * �o�����f�[�^�o�C���f�B���O���쐬���܂��B
		 * @param src1  �P�ڂ̃I�u�W�F�N�g���w�肵�܂��B
		 * @param prop1 �P�ڂ̃v���p�e�B���w�肵�܂��B
		 * @param src2  �Q�ڂ̃I�u�W�F�N�g���w�肵�܂��B
		 * @param prop2 �Q�ڂ̃v���p�e�B���w�肵�܂��B
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