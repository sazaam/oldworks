package org.libspark.as3bind {
	/**
	* �����������s���܂�.
	* <p>������鏑��</p>
	* bind(obj, f, ... args) // ��ʌ`
	* bind(f, ... args)		 // this �I�u�W�F�N�g�ȗ�
	* bind(obj, s, ... args) // �����𕶎����
	* bind(s, ... args)		 // this �I�u�W�F�N�g�ȗ�
	*/
	public function bind(... bindArgs:Array):Function {
		// �����`�F�b�N
		if(bindArgs.length==0) throw new ArgumentError();
		if(bindArgs[0]==_all) throw new ArgumentError("_all �� thisObject �Ɏw��ł��܂���");
		// �ȗ����ꂽ thisObject �̕ۊ�
		if (bindArgs[1] is Function) ;
		else if (bindArgs[0] is Function) bindArgs.unshift(_this);
		else if (bindArgs[1] is String) ;
		else if (bindArgs[0] is String)	bindArgs.unshift(_this);
		else throw new ArgumentError("�֐����w�肳��Ă��܂���");
		// �֐�����
		return function (... args):* {
			var newArgs:Array = bindArgs.slice();
			for(var i:int=0; i<newArgs.length; i++) {
				switch(newArgs[i]) {
					case _1: newArgs[i] = args[0]; break;
					case _2: newArgs[i] = args[1]; break;
					case _3: newArgs[i] = args[2]; break;
					case _4: newArgs[i] = args[3]; break;
					case _5: newArgs[i] = args[4]; break;
					case _6: newArgs[i] = args[5]; break;
					case _7: newArgs[i] = args[6]; break;
					case _8: newArgs[i] = args[7]; break;
					case _9: newArgs[i] = args[8]; break;
					case _this: newArgs[i] = this; break;
					case _all:
						newArgs.splice.apply(null, [i, 1].concat(args));
						i+=args.length-1;
						break;
				}
			}
			var thisObject:* = newArgs.shift();
			var func:Function = newArgs[0] is Function ? newArgs.shift() : thisObject[newArgs.shift()];
			return func.apply(thisObject, newArgs);
		};
	}
}