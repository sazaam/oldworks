<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertDocument");
$query->setAction("insert");
$query->setPriority("LOW");

${'document_srl1_argument'} = new Argument('document_srl', $args->{'document_srl'});
${'document_srl1_argument'}->checkFilter('number');
${'document_srl1_argument'}->checkNotNull();
if(!${'document_srl1_argument'}->isValid()) return ${'document_srl1_argument'}->getErrorMessage();
if(${'document_srl1_argument'} !== null) ${'document_srl1_argument'}->setColumnType('number');

${'module_srl2_argument'} = new Argument('module_srl', $args->{'module_srl'});
${'module_srl2_argument'}->checkFilter('number');
${'module_srl2_argument'}->ensureDefaultValue('0');
if(!${'module_srl2_argument'}->isValid()) return ${'module_srl2_argument'}->getErrorMessage();
if(${'module_srl2_argument'} !== null) ${'module_srl2_argument'}->setColumnType('number');

${'category_srl3_argument'} = new Argument('category_srl', $args->{'category_srl'});
${'category_srl3_argument'}->checkFilter('number');
${'category_srl3_argument'}->ensureDefaultValue('0');
if(!${'category_srl3_argument'}->isValid()) return ${'category_srl3_argument'}->getErrorMessage();
if(${'category_srl3_argument'} !== null) ${'category_srl3_argument'}->setColumnType('number');

${'lang_code4_argument'} = new Argument('lang_code', $args->{'lang_code'});
${'lang_code4_argument'}->ensureDefaultValue('');
if(!${'lang_code4_argument'}->isValid()) return ${'lang_code4_argument'}->getErrorMessage();
if(${'lang_code4_argument'} !== null) ${'lang_code4_argument'}->setColumnType('varchar');

${'is_notice5_argument'} = new Argument('is_notice', $args->{'is_notice'});
${'is_notice5_argument'}->ensureDefaultValue('N');
${'is_notice5_argument'}->checkNotNull();
if(!${'is_notice5_argument'}->isValid()) return ${'is_notice5_argument'}->getErrorMessage();
if(${'is_notice5_argument'} !== null) ${'is_notice5_argument'}->setColumnType('char');

${'title6_argument'} = new Argument('title', $args->{'title'});
${'title6_argument'}->checkNotNull();
if(!${'title6_argument'}->isValid()) return ${'title6_argument'}->getErrorMessage();
if(${'title6_argument'} !== null) ${'title6_argument'}->setColumnType('varchar');

${'title_bold7_argument'} = new Argument('title_bold', $args->{'title_bold'});
${'title_bold7_argument'}->ensureDefaultValue('N');
if(!${'title_bold7_argument'}->isValid()) return ${'title_bold7_argument'}->getErrorMessage();
if(${'title_bold7_argument'} !== null) ${'title_bold7_argument'}->setColumnType('char');

${'title_color8_argument'} = new Argument('title_color', $args->{'title_color'});
${'title_color8_argument'}->ensureDefaultValue('N');
if(!${'title_color8_argument'}->isValid()) return ${'title_color8_argument'}->getErrorMessage();
if(${'title_color8_argument'} !== null) ${'title_color8_argument'}->setColumnType('varchar');

${'content9_argument'} = new Argument('content', $args->{'content'});
${'content9_argument'}->checkNotNull();
if(!${'content9_argument'}->isValid()) return ${'content9_argument'}->getErrorMessage();
if(${'content9_argument'} !== null) ${'content9_argument'}->setColumnType('bigtext');

${'readed_count10_argument'} = new Argument('readed_count', $args->{'readed_count'});
${'readed_count10_argument'}->ensureDefaultValue('0');
if(!${'readed_count10_argument'}->isValid()) return ${'readed_count10_argument'}->getErrorMessage();
if(${'readed_count10_argument'} !== null) ${'readed_count10_argument'}->setColumnType('number');

${'blamed_count11_argument'} = new Argument('blamed_count', $args->{'blamed_count'});
${'blamed_count11_argument'}->ensureDefaultValue('0');
if(!${'blamed_count11_argument'}->isValid()) return ${'blamed_count11_argument'}->getErrorMessage();
if(${'blamed_count11_argument'} !== null) ${'blamed_count11_argument'}->setColumnType('number');

${'voted_count12_argument'} = new Argument('voted_count', $args->{'voted_count'});
${'voted_count12_argument'}->ensureDefaultValue('0');
if(!${'voted_count12_argument'}->isValid()) return ${'voted_count12_argument'}->getErrorMessage();
if(${'voted_count12_argument'} !== null) ${'voted_count12_argument'}->setColumnType('number');

${'comment_count13_argument'} = new Argument('comment_count', $args->{'comment_count'});
${'comment_count13_argument'}->ensureDefaultValue('0');
if(!${'comment_count13_argument'}->isValid()) return ${'comment_count13_argument'}->getErrorMessage();
if(${'comment_count13_argument'} !== null) ${'comment_count13_argument'}->setColumnType('number');

${'trackback_count14_argument'} = new Argument('trackback_count', $args->{'trackback_count'});
${'trackback_count14_argument'}->ensureDefaultValue('0');
if(!${'trackback_count14_argument'}->isValid()) return ${'trackback_count14_argument'}->getErrorMessage();
if(${'trackback_count14_argument'} !== null) ${'trackback_count14_argument'}->setColumnType('number');

${'uploaded_count15_argument'} = new Argument('uploaded_count', $args->{'uploaded_count'});
${'uploaded_count15_argument'}->ensureDefaultValue('0');
if(!${'uploaded_count15_argument'}->isValid()) return ${'uploaded_count15_argument'}->getErrorMessage();
if(${'uploaded_count15_argument'} !== null) ${'uploaded_count15_argument'}->setColumnType('number');
if(isset($args->password)) {
${'password16_argument'} = new Argument('password', $args->{'password'});
if(!${'password16_argument'}->isValid()) return ${'password16_argument'}->getErrorMessage();
} else
${'password16_argument'} = NULL;if(${'password16_argument'} !== null) ${'password16_argument'}->setColumnType('varchar');

${'nick_name17_argument'} = new Argument('nick_name', $args->{'nick_name'});
${'nick_name17_argument'}->checkNotNull();
if(!${'nick_name17_argument'}->isValid()) return ${'nick_name17_argument'}->getErrorMessage();
if(${'nick_name17_argument'} !== null) ${'nick_name17_argument'}->setColumnType('varchar');

${'member_srl18_argument'} = new Argument('member_srl', $args->{'member_srl'});
${'member_srl18_argument'}->checkFilter('number');
${'member_srl18_argument'}->ensureDefaultValue('0');
if(!${'member_srl18_argument'}->isValid()) return ${'member_srl18_argument'}->getErrorMessage();
if(${'member_srl18_argument'} !== null) ${'member_srl18_argument'}->setColumnType('number');

${'user_id19_argument'} = new Argument('user_id', $args->{'user_id'});
${'user_id19_argument'}->ensureDefaultValue('');
if(!${'user_id19_argument'}->isValid()) return ${'user_id19_argument'}->getErrorMessage();
if(${'user_id19_argument'} !== null) ${'user_id19_argument'}->setColumnType('varchar');

${'user_name20_argument'} = new Argument('user_name', $args->{'user_name'});
${'user_name20_argument'}->ensureDefaultValue('');
if(!${'user_name20_argument'}->isValid()) return ${'user_name20_argument'}->getErrorMessage();
if(${'user_name20_argument'} !== null) ${'user_name20_argument'}->setColumnType('varchar');
if(isset($args->email_address)) {
${'email_address21_argument'} = new Argument('email_address', $args->{'email_address'});
${'email_address21_argument'}->checkFilter('email');
if(!${'email_address21_argument'}->isValid()) return ${'email_address21_argument'}->getErrorMessage();
} else
${'email_address21_argument'} = NULL;if(${'email_address21_argument'} !== null) ${'email_address21_argument'}->setColumnType('varchar');

${'homepage22_argument'} = new Argument('homepage', $args->{'homepage'});
${'homepage22_argument'}->checkFilter('homepage');
${'homepage22_argument'}->ensureDefaultValue('');
if(!${'homepage22_argument'}->isValid()) return ${'homepage22_argument'}->getErrorMessage();
if(${'homepage22_argument'} !== null) ${'homepage22_argument'}->setColumnType('varchar');
if(isset($args->tags)) {
${'tags23_argument'} = new Argument('tags', $args->{'tags'});
if(!${'tags23_argument'}->isValid()) return ${'tags23_argument'}->getErrorMessage();
} else
${'tags23_argument'} = NULL;if(${'tags23_argument'} !== null) ${'tags23_argument'}->setColumnType('text');
if(isset($args->extra_vars)) {
${'extra_vars24_argument'} = new Argument('extra_vars', $args->{'extra_vars'});
if(!${'extra_vars24_argument'}->isValid()) return ${'extra_vars24_argument'}->getErrorMessage();
} else
${'extra_vars24_argument'} = NULL;if(${'extra_vars24_argument'} !== null) ${'extra_vars24_argument'}->setColumnType('text');

${'regdate25_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate25_argument'}->ensureDefaultValue(date("YmdHis"));
if(!${'regdate25_argument'}->isValid()) return ${'regdate25_argument'}->getErrorMessage();
if(${'regdate25_argument'} !== null) ${'regdate25_argument'}->setColumnType('date');

${'last_update26_argument'} = new Argument('last_update', $args->{'last_update'});
${'last_update26_argument'}->ensureDefaultValue(date("YmdHis"));
if(!${'last_update26_argument'}->isValid()) return ${'last_update26_argument'}->getErrorMessage();
if(${'last_update26_argument'} !== null) ${'last_update26_argument'}->setColumnType('date');
if(isset($args->last_updater)) {
${'last_updater27_argument'} = new Argument('last_updater', $args->{'last_updater'});
if(!${'last_updater27_argument'}->isValid()) return ${'last_updater27_argument'}->getErrorMessage();
} else
${'last_updater27_argument'} = NULL;if(${'last_updater27_argument'} !== null) ${'last_updater27_argument'}->setColumnType('varchar');

${'ipaddress28_argument'} = new Argument('ipaddress', $args->{'ipaddress'});
${'ipaddress28_argument'}->ensureDefaultValue($_SERVER['REMOTE_ADDR']);
if(!${'ipaddress28_argument'}->isValid()) return ${'ipaddress28_argument'}->getErrorMessage();
if(${'ipaddress28_argument'} !== null) ${'ipaddress28_argument'}->setColumnType('varchar');

${'list_order29_argument'} = new Argument('list_order', $args->{'list_order'});
${'list_order29_argument'}->ensureDefaultValue('0');
if(!${'list_order29_argument'}->isValid()) return ${'list_order29_argument'}->getErrorMessage();
if(${'list_order29_argument'} !== null) ${'list_order29_argument'}->setColumnType('number');

${'update_order30_argument'} = new Argument('update_order', $args->{'update_order'});
${'update_order30_argument'}->ensureDefaultValue('0');
if(!${'update_order30_argument'}->isValid()) return ${'update_order30_argument'}->getErrorMessage();
if(${'update_order30_argument'} !== null) ${'update_order30_argument'}->setColumnType('number');

${'allow_trackback31_argument'} = new Argument('allow_trackback', $args->{'allow_trackback'});
${'allow_trackback31_argument'}->ensureDefaultValue('Y');
if(!${'allow_trackback31_argument'}->isValid()) return ${'allow_trackback31_argument'}->getErrorMessage();
if(${'allow_trackback31_argument'} !== null) ${'allow_trackback31_argument'}->setColumnType('char');

${'notify_message32_argument'} = new Argument('notify_message', $args->{'notify_message'});
${'notify_message32_argument'}->ensureDefaultValue('N');
if(!${'notify_message32_argument'}->isValid()) return ${'notify_message32_argument'}->getErrorMessage();
if(${'notify_message32_argument'} !== null) ${'notify_message32_argument'}->setColumnType('char');

${'status33_argument'} = new Argument('status', $args->{'status'});
${'status33_argument'}->ensureDefaultValue('PUBLIC');
if(!${'status33_argument'}->isValid()) return ${'status33_argument'}->getErrorMessage();
if(${'status33_argument'} !== null) ${'status33_argument'}->setColumnType('varchar');

${'commentStatus34_argument'} = new Argument('commentStatus', $args->{'commentStatus'});
${'commentStatus34_argument'}->ensureDefaultValue('ALLOW');
if(!${'commentStatus34_argument'}->isValid()) return ${'commentStatus34_argument'}->getErrorMessage();
if(${'commentStatus34_argument'} !== null) ${'commentStatus34_argument'}->setColumnType('varchar');

$query->setColumns(array(
new InsertExpression('`document_srl`', ${'document_srl1_argument'})
,new InsertExpression('`module_srl`', ${'module_srl2_argument'})
,new InsertExpression('`category_srl`', ${'category_srl3_argument'})
,new InsertExpression('`lang_code`', ${'lang_code4_argument'})
,new InsertExpression('`is_notice`', ${'is_notice5_argument'})
,new InsertExpression('`title`', ${'title6_argument'})
,new InsertExpression('`title_bold`', ${'title_bold7_argument'})
,new InsertExpression('`title_color`', ${'title_color8_argument'})
,new InsertExpression('`content`', ${'content9_argument'})
,new InsertExpression('`readed_count`', ${'readed_count10_argument'})
,new InsertExpression('`blamed_count`', ${'blamed_count11_argument'})
,new InsertExpression('`voted_count`', ${'voted_count12_argument'})
,new InsertExpression('`comment_count`', ${'comment_count13_argument'})
,new InsertExpression('`trackback_count`', ${'trackback_count14_argument'})
,new InsertExpression('`uploaded_count`', ${'uploaded_count15_argument'})
,new InsertExpression('`password`', ${'password16_argument'})
,new InsertExpression('`nick_name`', ${'nick_name17_argument'})
,new InsertExpression('`member_srl`', ${'member_srl18_argument'})
,new InsertExpression('`user_id`', ${'user_id19_argument'})
,new InsertExpression('`user_name`', ${'user_name20_argument'})
,new InsertExpression('`email_address`', ${'email_address21_argument'})
,new InsertExpression('`homepage`', ${'homepage22_argument'})
,new InsertExpression('`tags`', ${'tags23_argument'})
,new InsertExpression('`extra_vars`', ${'extra_vars24_argument'})
,new InsertExpression('`regdate`', ${'regdate25_argument'})
,new InsertExpression('`last_update`', ${'last_update26_argument'})
,new InsertExpression('`last_updater`', ${'last_updater27_argument'})
,new InsertExpression('`ipaddress`', ${'ipaddress28_argument'})
,new InsertExpression('`list_order`', ${'list_order29_argument'})
,new InsertExpression('`update_order`', ${'update_order30_argument'})
,new InsertExpression('`allow_trackback`', ${'allow_trackback31_argument'})
,new InsertExpression('`notify_message`', ${'notify_message32_argument'})
,new InsertExpression('`status`', ${'status33_argument'})
,new InsertExpression('`comment_status`', ${'commentStatus34_argument'})
));
$query->setTables(array(
new Table('`xe_documents`', '`documents`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>