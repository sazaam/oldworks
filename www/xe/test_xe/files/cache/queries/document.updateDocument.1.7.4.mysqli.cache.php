<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateDocument");
$query->setAction("update");
$query->setPriority("LOW");

${'module_srl6_argument'} = new Argument('module_srl', $args->{'module_srl'});
${'module_srl6_argument'}->checkFilter('number');
${'module_srl6_argument'}->ensureDefaultValue('0');
if(!${'module_srl6_argument'}->isValid()) return ${'module_srl6_argument'}->getErrorMessage();
if(${'module_srl6_argument'} !== null) ${'module_srl6_argument'}->setColumnType('number');

${'category_srl7_argument'} = new Argument('category_srl', $args->{'category_srl'});
${'category_srl7_argument'}->checkFilter('number');
${'category_srl7_argument'}->ensureDefaultValue('0');
if(!${'category_srl7_argument'}->isValid()) return ${'category_srl7_argument'}->getErrorMessage();
if(${'category_srl7_argument'} !== null) ${'category_srl7_argument'}->setColumnType('number');

${'is_notice8_argument'} = new Argument('is_notice', $args->{'is_notice'});
${'is_notice8_argument'}->ensureDefaultValue('N');
${'is_notice8_argument'}->checkNotNull();
if(!${'is_notice8_argument'}->isValid()) return ${'is_notice8_argument'}->getErrorMessage();
if(${'is_notice8_argument'} !== null) ${'is_notice8_argument'}->setColumnType('char');

${'title9_argument'} = new Argument('title', $args->{'title'});
${'title9_argument'}->checkNotNull();
if(!${'title9_argument'}->isValid()) return ${'title9_argument'}->getErrorMessage();
if(${'title9_argument'} !== null) ${'title9_argument'}->setColumnType('varchar');

${'title_bold10_argument'} = new Argument('title_bold', $args->{'title_bold'});
${'title_bold10_argument'}->ensureDefaultValue('N');
if(!${'title_bold10_argument'}->isValid()) return ${'title_bold10_argument'}->getErrorMessage();
if(${'title_bold10_argument'} !== null) ${'title_bold10_argument'}->setColumnType('char');

${'title_color11_argument'} = new Argument('title_color', $args->{'title_color'});
${'title_color11_argument'}->ensureDefaultValue('N');
if(!${'title_color11_argument'}->isValid()) return ${'title_color11_argument'}->getErrorMessage();
if(${'title_color11_argument'} !== null) ${'title_color11_argument'}->setColumnType('varchar');

${'content12_argument'} = new Argument('content', $args->{'content'});
${'content12_argument'}->checkNotNull();
if(!${'content12_argument'}->isValid()) return ${'content12_argument'}->getErrorMessage();
if(${'content12_argument'} !== null) ${'content12_argument'}->setColumnType('bigtext');

${'uploaded_count13_argument'} = new Argument('uploaded_count', $args->{'uploaded_count'});
${'uploaded_count13_argument'}->ensureDefaultValue('0');
if(!${'uploaded_count13_argument'}->isValid()) return ${'uploaded_count13_argument'}->getErrorMessage();
if(${'uploaded_count13_argument'} !== null) ${'uploaded_count13_argument'}->setColumnType('number');
if(isset($args->password)) {
${'password14_argument'} = new Argument('password', $args->{'password'});
if(!${'password14_argument'}->isValid()) return ${'password14_argument'}->getErrorMessage();
} else
${'password14_argument'} = NULL;if(${'password14_argument'} !== null) ${'password14_argument'}->setColumnType('varchar');
if(isset($args->nick_name)) {
${'nick_name15_argument'} = new Argument('nick_name', $args->{'nick_name'});
if(!${'nick_name15_argument'}->isValid()) return ${'nick_name15_argument'}->getErrorMessage();
} else
${'nick_name15_argument'} = NULL;if(${'nick_name15_argument'} !== null) ${'nick_name15_argument'}->setColumnType('varchar');
if(isset($args->member_srl)) {
${'member_srl16_argument'} = new Argument('member_srl', $args->{'member_srl'});
if(!${'member_srl16_argument'}->isValid()) return ${'member_srl16_argument'}->getErrorMessage();
} else
${'member_srl16_argument'} = NULL;if(${'member_srl16_argument'} !== null) ${'member_srl16_argument'}->setColumnType('number');
if(isset($args->user_id)) {
${'user_id17_argument'} = new Argument('user_id', $args->{'user_id'});
if(!${'user_id17_argument'}->isValid()) return ${'user_id17_argument'}->getErrorMessage();
} else
${'user_id17_argument'} = NULL;if(${'user_id17_argument'} !== null) ${'user_id17_argument'}->setColumnType('varchar');

${'user_name18_argument'} = new Argument('user_name', $args->{'user_name'});
${'user_name18_argument'}->ensureDefaultValue('');
if(!${'user_name18_argument'}->isValid()) return ${'user_name18_argument'}->getErrorMessage();
if(${'user_name18_argument'} !== null) ${'user_name18_argument'}->setColumnType('varchar');
if(isset($args->email_address)) {
${'email_address19_argument'} = new Argument('email_address', $args->{'email_address'});
${'email_address19_argument'}->checkFilter('email');
if(!${'email_address19_argument'}->isValid()) return ${'email_address19_argument'}->getErrorMessage();
} else
${'email_address19_argument'} = NULL;if(${'email_address19_argument'} !== null) ${'email_address19_argument'}->setColumnType('varchar');
if(isset($args->homepage)) {
${'homepage20_argument'} = new Argument('homepage', $args->{'homepage'});
${'homepage20_argument'}->checkFilter('homepage');
if(!${'homepage20_argument'}->isValid()) return ${'homepage20_argument'}->getErrorMessage();
} else
${'homepage20_argument'} = NULL;if(${'homepage20_argument'} !== null) ${'homepage20_argument'}->setColumnType('varchar');

${'tags21_argument'} = new Argument('tags', $args->{'tags'});
${'tags21_argument'}->ensureDefaultValue('');
if(!${'tags21_argument'}->isValid()) return ${'tags21_argument'}->getErrorMessage();
if(${'tags21_argument'} !== null) ${'tags21_argument'}->setColumnType('text');
if(isset($args->extra_vars)) {
${'extra_vars22_argument'} = new Argument('extra_vars', $args->{'extra_vars'});
if(!${'extra_vars22_argument'}->isValid()) return ${'extra_vars22_argument'}->getErrorMessage();
} else
${'extra_vars22_argument'} = NULL;if(${'extra_vars22_argument'} !== null) ${'extra_vars22_argument'}->setColumnType('text');
if(isset($args->regdate)) {
${'regdate23_argument'} = new Argument('regdate', $args->{'regdate'});
if(!${'regdate23_argument'}->isValid()) return ${'regdate23_argument'}->getErrorMessage();
} else
${'regdate23_argument'} = NULL;if(${'regdate23_argument'} !== null) ${'regdate23_argument'}->setColumnType('date');

${'last_update24_argument'} = new Argument('last_update', $args->{'last_update'});
${'last_update24_argument'}->ensureDefaultValue(date("YmdHis"));
if(!${'last_update24_argument'}->isValid()) return ${'last_update24_argument'}->getErrorMessage();
if(${'last_update24_argument'} !== null) ${'last_update24_argument'}->setColumnType('date');

${'ipaddress25_argument'} = new Argument('ipaddress', $args->{'ipaddress'});
${'ipaddress25_argument'}->ensureDefaultValue($_SERVER['REMOTE_ADDR']);
if(!${'ipaddress25_argument'}->isValid()) return ${'ipaddress25_argument'}->getErrorMessage();
if(${'ipaddress25_argument'} !== null) ${'ipaddress25_argument'}->setColumnType('varchar');
if(isset($args->list_order)) {
${'list_order26_argument'} = new Argument('list_order', $args->{'list_order'});
if(!${'list_order26_argument'}->isValid()) return ${'list_order26_argument'}->getErrorMessage();
} else
${'list_order26_argument'} = NULL;if(${'list_order26_argument'} !== null) ${'list_order26_argument'}->setColumnType('number');

${'update_order27_argument'} = new Argument('update_order', $args->{'update_order'});
${'update_order27_argument'}->ensureDefaultValue('0');
if(!${'update_order27_argument'}->isValid()) return ${'update_order27_argument'}->getErrorMessage();
if(${'update_order27_argument'} !== null) ${'update_order27_argument'}->setColumnType('number');

${'allow_trackback28_argument'} = new Argument('allow_trackback', $args->{'allow_trackback'});
${'allow_trackback28_argument'}->ensureDefaultValue('Y');
if(!${'allow_trackback28_argument'}->isValid()) return ${'allow_trackback28_argument'}->getErrorMessage();
if(${'allow_trackback28_argument'} !== null) ${'allow_trackback28_argument'}->setColumnType('char');

${'notify_message29_argument'} = new Argument('notify_message', $args->{'notify_message'});
${'notify_message29_argument'}->ensureDefaultValue('N');
if(!${'notify_message29_argument'}->isValid()) return ${'notify_message29_argument'}->getErrorMessage();
if(${'notify_message29_argument'} !== null) ${'notify_message29_argument'}->setColumnType('char');

${'status30_argument'} = new Argument('status', $args->{'status'});
${'status30_argument'}->ensureDefaultValue('PUBLIC');
if(!${'status30_argument'}->isValid()) return ${'status30_argument'}->getErrorMessage();
if(${'status30_argument'} !== null) ${'status30_argument'}->setColumnType('varchar');

${'commentStatus31_argument'} = new Argument('commentStatus', $args->{'commentStatus'});
${'commentStatus31_argument'}->ensureDefaultValue('ALLOW');
if(!${'commentStatus31_argument'}->isValid()) return ${'commentStatus31_argument'}->getErrorMessage();
if(${'commentStatus31_argument'} !== null) ${'commentStatus31_argument'}->setColumnType('varchar');

${'document_srl32_argument'} = new ConditionArgument('document_srl', $args->document_srl, 'equal');
${'document_srl32_argument'}->checkFilter('number');
${'document_srl32_argument'}->checkNotNull();
${'document_srl32_argument'}->createConditionValue();
if(!${'document_srl32_argument'}->isValid()) return ${'document_srl32_argument'}->getErrorMessage();
if(${'document_srl32_argument'} !== null) ${'document_srl32_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`module_srl`', ${'module_srl6_argument'})
,new UpdateExpression('`category_srl`', ${'category_srl7_argument'})
,new UpdateExpression('`is_notice`', ${'is_notice8_argument'})
,new UpdateExpression('`title`', ${'title9_argument'})
,new UpdateExpression('`title_bold`', ${'title_bold10_argument'})
,new UpdateExpression('`title_color`', ${'title_color11_argument'})
,new UpdateExpression('`content`', ${'content12_argument'})
,new UpdateExpression('`uploaded_count`', ${'uploaded_count13_argument'})
,new UpdateExpression('`password`', ${'password14_argument'})
,new UpdateExpression('`nick_name`', ${'nick_name15_argument'})
,new UpdateExpression('`member_srl`', ${'member_srl16_argument'})
,new UpdateExpression('`user_id`', ${'user_id17_argument'})
,new UpdateExpression('`user_name`', ${'user_name18_argument'})
,new UpdateExpression('`email_address`', ${'email_address19_argument'})
,new UpdateExpression('`homepage`', ${'homepage20_argument'})
,new UpdateExpression('`tags`', ${'tags21_argument'})
,new UpdateExpression('`extra_vars`', ${'extra_vars22_argument'})
,new UpdateExpression('`regdate`', ${'regdate23_argument'})
,new UpdateExpression('`last_update`', ${'last_update24_argument'})
,new UpdateExpression('`ipaddress`', ${'ipaddress25_argument'})
,new UpdateExpression('`list_order`', ${'list_order26_argument'})
,new UpdateExpression('`update_order`', ${'update_order27_argument'})
,new UpdateExpression('`allow_trackback`', ${'allow_trackback28_argument'})
,new UpdateExpression('`notify_message`', ${'notify_message29_argument'})
,new UpdateExpression('`status`', ${'status30_argument'})
,new UpdateExpression('`comment_status`', ${'commentStatus31_argument'})
));
$query->setTables(array(
new Table('`xe_documents`', '`documents`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`document_srl`',$document_srl32_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>