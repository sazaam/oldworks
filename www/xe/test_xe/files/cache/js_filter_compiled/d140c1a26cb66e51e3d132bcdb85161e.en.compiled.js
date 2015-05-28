function insert_page_content(form){ return legacy_filter('insert_page_content', form, 'page', 'procPageAdminInsertContent', completeInsertPageContent, ['error','message','mid','module_srl','page'], 'Are you sure you want to submit?', {}) };
(function($){
	var v=xe.getApp('validator')[0];if(!v)return false;
	v.cast("ADD_FILTER", ["insert_page_content", {'module_srl': {required:true}}]);
	
	v.cast('ADD_MESSAGE',['module_srl','module_srl']);
	v.cast('ADD_MESSAGE',['mid','Module Name']);
	v.cast('ADD_MESSAGE',['content','Content']);
	v.cast('ADD_MESSAGE',['isnull','Please enter a value for %s']);
	v.cast('ADD_MESSAGE',['outofrange','Please try to keep the text length of %s.']);
	v.cast('ADD_MESSAGE',['equalto','The value of %s is invalid']);
	v.cast('ADD_MESSAGE',['invalid','The value of %s is invalid.']);
	v.cast('ADD_MESSAGE',['invalid_email','%s is NOT a valid email address.']);
	v.cast('ADD_MESSAGE',['invalid_userid','The %s field allows only alphabets, numbers and underscore(_). The first letter should be an alaphabet.']);
	v.cast('ADD_MESSAGE',['invalid_user_id','The %s field allows only alphabets, numbers and underscore(_). The first letter should be an alaphabet.']);
	v.cast('ADD_MESSAGE',['invalid_homepage','The format of %s is invalid. e.g.) http://xpressengine.com/']);
	v.cast('ADD_MESSAGE',['invalid_url','The format of %s is invalid. e.g.) http://xpressengine.com/']);
	v.cast('ADD_MESSAGE',['invalid_korean','The format of %s is invalid. Please enter Korean letters only.']);
	v.cast('ADD_MESSAGE',['invalid_korean_number','The format of %s is invalid. Please enter Korean letters and numbers only.']);
	v.cast('ADD_MESSAGE',['invalid_alpha','The format of %s is invalid. Please enter English alphabets only.']);
	v.cast('ADD_MESSAGE',['invalid_alpha_number','The format of %s is invalid. Please enter English alphabets and numbers only.']);
	v.cast('ADD_MESSAGE',['invalid_mid','The format of %s is invalid. Module ID should be begun with a letter. Subsequent characters may be letters, digits or underscore characters.']);
	v.cast('ADD_MESSAGE',['invalid_number','The format of %s is invalid. Please enter numbers only.']);
})(jQuery);