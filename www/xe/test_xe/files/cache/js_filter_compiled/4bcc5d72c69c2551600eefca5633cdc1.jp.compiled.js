function widget_logout(form){ return legacy_filter('widget_logout', form, 'member', 'procMemberLogout', filterAlertMessage, ['error','message'], '', {}) };
(function($){
	var v=xe.getApp('validator')[0];if(!v)return false;
	v.cast("ADD_FILTER", ["widget_logout", {}]);
	
	v.cast('ADD_MESSAGE',['isnull','%sに値を入力してください。']);
	v.cast('ADD_MESSAGE',['outofrange','%sの文字の長さを合わせてください。']);
	v.cast('ADD_MESSAGE',['equalto','%sが正しくありません。']);
	v.cast('ADD_MESSAGE',['invalid','%sの値が正しくありません。']);
	v.cast('ADD_MESSAGE',['invalid_email','%sのメール形式が正しくありません。(例: developers@xepressengine.com)']);
	v.cast('ADD_MESSAGE',['invalid_userid','%sの形式が正しくありません。半角の英数字と記号「_」を組み合わせて入力してください。頭文字は半角英文字でなければなりません。']);
	v.cast('ADD_MESSAGE',['invalid_user_id','%sの形式が正しくありません。半角の英数字と記号「_」を組み合わせて入力してください。頭文字は半角英文字でなければなりません。']);
	v.cast('ADD_MESSAGE',['invalid_homepage','%sの形式が正しくありません。(例: http://www.xepressengine.com)']);
	v.cast('ADD_MESSAGE',['invalid_url','%sの形式が正しくありません。例) http://xpressengine.com/']);
	v.cast('ADD_MESSAGE',['invalid_korean','%sの形式が正しくありません。ハングルで入力してください。']);
	v.cast('ADD_MESSAGE',['invalid_korean_number','%sの形式が正しくありません。ハングルと半角数字で入力してください。']);
	v.cast('ADD_MESSAGE',['invalid_alpha','%sの形式が正しくありません。半角英字で入力してください。']);
	v.cast('ADD_MESSAGE',['invalid_alpha_number','%sの形式が正しくありません。半角英数字で入力してください。']);
	v.cast('ADD_MESSAGE',['invalid_mid','%sの形式が正しくありません。 最初の文字は英文から始め、「英文＋数字＋_」組合せで入力が必要です。']);
	v.cast('ADD_MESSAGE',['invalid_number','%sの形式が正しくありません。半角数字で入力してください。']);
})(jQuery);