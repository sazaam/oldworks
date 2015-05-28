<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getDocumentList");
$query->setAction("select");
$query->setPriority("");
if(isset($args->module_srl)) {
${'module_srl7_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'in');
${'module_srl7_argument'}->checkFilter('number');
${'module_srl7_argument'}->createConditionValue();
if(!${'module_srl7_argument'}->isValid()) return ${'module_srl7_argument'}->getErrorMessage();
} else
${'module_srl7_argument'} = NULL;if(${'module_srl7_argument'} !== null) ${'module_srl7_argument'}->setColumnType('number');
if(isset($args->exclude_module_srl)) {
${'exclude_module_srl8_argument'} = new ConditionArgument('exclude_module_srl', $args->exclude_module_srl, 'notin');
${'exclude_module_srl8_argument'}->checkFilter('number');
${'exclude_module_srl8_argument'}->createConditionValue();
if(!${'exclude_module_srl8_argument'}->isValid()) return ${'exclude_module_srl8_argument'}->getErrorMessage();
} else
${'exclude_module_srl8_argument'} = NULL;if(${'exclude_module_srl8_argument'} !== null) ${'exclude_module_srl8_argument'}->setColumnType('number');
if(isset($args->category_srl)) {
${'category_srl9_argument'} = new ConditionArgument('category_srl', $args->category_srl, 'in');
${'category_srl9_argument'}->createConditionValue();
if(!${'category_srl9_argument'}->isValid()) return ${'category_srl9_argument'}->getErrorMessage();
} else
${'category_srl9_argument'} = NULL;if(${'category_srl9_argument'} !== null) ${'category_srl9_argument'}->setColumnType('number');
if(isset($args->s_is_notice)) {
${'s_is_notice10_argument'} = new ConditionArgument('s_is_notice', $args->s_is_notice, 'equal');
${'s_is_notice10_argument'}->createConditionValue();
if(!${'s_is_notice10_argument'}->isValid()) return ${'s_is_notice10_argument'}->getErrorMessage();
} else
${'s_is_notice10_argument'} = NULL;if(${'s_is_notice10_argument'} !== null) ${'s_is_notice10_argument'}->setColumnType('char');
if(isset($args->member_srl)) {
${'member_srl11_argument'} = new ConditionArgument('member_srl', $args->member_srl, 'equal');
${'member_srl11_argument'}->checkFilter('number');
${'member_srl11_argument'}->createConditionValue();
if(!${'member_srl11_argument'}->isValid()) return ${'member_srl11_argument'}->getErrorMessage();
} else
${'member_srl11_argument'} = NULL;if(${'member_srl11_argument'} !== null) ${'member_srl11_argument'}->setColumnType('number');
if(isset($args->statusList)) {
${'statusList12_argument'} = new ConditionArgument('statusList', $args->statusList, 'in');
${'statusList12_argument'}->createConditionValue();
if(!${'statusList12_argument'}->isValid()) return ${'statusList12_argument'}->getErrorMessage();
} else
${'statusList12_argument'} = NULL;if(${'statusList12_argument'} !== null) ${'statusList12_argument'}->setColumnType('varchar');
if(isset($args->division)) {
${'division13_argument'} = new ConditionArgument('division', $args->division, 'more');
${'division13_argument'}->createConditionValue();
if(!${'division13_argument'}->isValid()) return ${'division13_argument'}->getErrorMessage();
} else
${'division13_argument'} = NULL;if(${'division13_argument'} !== null) ${'division13_argument'}->setColumnType('number');
if(isset($args->last_division)) {
${'last_division14_argument'} = new ConditionArgument('last_division', $args->last_division, 'below');
${'last_division14_argument'}->createConditionValue();
if(!${'last_division14_argument'}->isValid()) return ${'last_division14_argument'}->getErrorMessage();
} else
${'last_division14_argument'} = NULL;if(${'last_division14_argument'} !== null) ${'last_division14_argument'}->setColumnType('number');
if(isset($args->s_title)) {
${'s_title15_argument'} = new ConditionArgument('s_title', $args->s_title, 'like');
${'s_title15_argument'}->createConditionValue();
if(!${'s_title15_argument'}->isValid()) return ${'s_title15_argument'}->getErrorMessage();
} else
${'s_title15_argument'} = NULL;if(${'s_title15_argument'} !== null) ${'s_title15_argument'}->setColumnType('varchar');
if(isset($args->s_content)) {
${'s_content16_argument'} = new ConditionArgument('s_content', $args->s_content, 'like');
${'s_content16_argument'}->createConditionValue();
if(!${'s_content16_argument'}->isValid()) return ${'s_content16_argument'}->getErrorMessage();
} else
${'s_content16_argument'} = NULL;if(${'s_content16_argument'} !== null) ${'s_content16_argument'}->setColumnType('bigtext');
if(isset($args->s_user_name)) {
${'s_user_name17_argument'} = new ConditionArgument('s_user_name', $args->s_user_name, 'like');
${'s_user_name17_argument'}->createConditionValue();
if(!${'s_user_name17_argument'}->isValid()) return ${'s_user_name17_argument'}->getErrorMessage();
} else
${'s_user_name17_argument'} = NULL;if(${'s_user_name17_argument'} !== null) ${'s_user_name17_argument'}->setColumnType('varchar');
if(isset($args->s_user_id)) {
${'s_user_id18_argument'} = new ConditionArgument('s_user_id', $args->s_user_id, 'like');
${'s_user_id18_argument'}->createConditionValue();
if(!${'s_user_id18_argument'}->isValid()) return ${'s_user_id18_argument'}->getErrorMessage();
} else
${'s_user_id18_argument'} = NULL;if(${'s_user_id18_argument'} !== null) ${'s_user_id18_argument'}->setColumnType('varchar');
if(isset($args->s_nick_name)) {
${'s_nick_name19_argument'} = new ConditionArgument('s_nick_name', $args->s_nick_name, 'like');
${'s_nick_name19_argument'}->createConditionValue();
if(!${'s_nick_name19_argument'}->isValid()) return ${'s_nick_name19_argument'}->getErrorMessage();
} else
${'s_nick_name19_argument'} = NULL;if(${'s_nick_name19_argument'} !== null) ${'s_nick_name19_argument'}->setColumnType('varchar');
if(isset($args->s_email_address)) {
${'s_email_address20_argument'} = new ConditionArgument('s_email_address', $args->s_email_address, 'like');
${'s_email_address20_argument'}->createConditionValue();
if(!${'s_email_address20_argument'}->isValid()) return ${'s_email_address20_argument'}->getErrorMessage();
} else
${'s_email_address20_argument'} = NULL;if(${'s_email_address20_argument'} !== null) ${'s_email_address20_argument'}->setColumnType('varchar');
if(isset($args->s_homepage)) {
${'s_homepage21_argument'} = new ConditionArgument('s_homepage', $args->s_homepage, 'like');
${'s_homepage21_argument'}->createConditionValue();
if(!${'s_homepage21_argument'}->isValid()) return ${'s_homepage21_argument'}->getErrorMessage();
} else
${'s_homepage21_argument'} = NULL;if(${'s_homepage21_argument'} !== null) ${'s_homepage21_argument'}->setColumnType('varchar');
if(isset($args->s_tags)) {
${'s_tags22_argument'} = new ConditionArgument('s_tags', $args->s_tags, 'like');
${'s_tags22_argument'}->createConditionValue();
if(!${'s_tags22_argument'}->isValid()) return ${'s_tags22_argument'}->getErrorMessage();
} else
${'s_tags22_argument'} = NULL;if(${'s_tags22_argument'} !== null) ${'s_tags22_argument'}->setColumnType('text');
if(isset($args->s_member_srl)) {
${'s_member_srl23_argument'} = new ConditionArgument('s_member_srl', $args->s_member_srl, 'equal');
${'s_member_srl23_argument'}->createConditionValue();
if(!${'s_member_srl23_argument'}->isValid()) return ${'s_member_srl23_argument'}->getErrorMessage();
} else
${'s_member_srl23_argument'} = NULL;if(${'s_member_srl23_argument'} !== null) ${'s_member_srl23_argument'}->setColumnType('number');
if(isset($args->s_readed_count)) {
${'s_readed_count24_argument'} = new ConditionArgument('s_readed_count', $args->s_readed_count, 'more');
${'s_readed_count24_argument'}->createConditionValue();
if(!${'s_readed_count24_argument'}->isValid()) return ${'s_readed_count24_argument'}->getErrorMessage();
} else
${'s_readed_count24_argument'} = NULL;if(${'s_readed_count24_argument'} !== null) ${'s_readed_count24_argument'}->setColumnType('number');
if(isset($args->s_voted_count)) {
${'s_voted_count25_argument'} = new ConditionArgument('s_voted_count', $args->s_voted_count, 'more');
${'s_voted_count25_argument'}->createConditionValue();
if(!${'s_voted_count25_argument'}->isValid()) return ${'s_voted_count25_argument'}->getErrorMessage();
} else
${'s_voted_count25_argument'} = NULL;if(${'s_voted_count25_argument'} !== null) ${'s_voted_count25_argument'}->setColumnType('number');
if(isset($args->s_blamed_count)) {
${'s_blamed_count26_argument'} = new ConditionArgument('s_blamed_count', $args->s_blamed_count, 'less');
${'s_blamed_count26_argument'}->createConditionValue();
if(!${'s_blamed_count26_argument'}->isValid()) return ${'s_blamed_count26_argument'}->getErrorMessage();
} else
${'s_blamed_count26_argument'} = NULL;if(${'s_blamed_count26_argument'} !== null) ${'s_blamed_count26_argument'}->setColumnType('number');
if(isset($args->s_comment_count)) {
${'s_comment_count27_argument'} = new ConditionArgument('s_comment_count', $args->s_comment_count, 'more');
${'s_comment_count27_argument'}->createConditionValue();
if(!${'s_comment_count27_argument'}->isValid()) return ${'s_comment_count27_argument'}->getErrorMessage();
} else
${'s_comment_count27_argument'} = NULL;if(${'s_comment_count27_argument'} !== null) ${'s_comment_count27_argument'}->setColumnType('number');
if(isset($args->s_trackback_count)) {
${'s_trackback_count28_argument'} = new ConditionArgument('s_trackback_count', $args->s_trackback_count, 'more');
${'s_trackback_count28_argument'}->createConditionValue();
if(!${'s_trackback_count28_argument'}->isValid()) return ${'s_trackback_count28_argument'}->getErrorMessage();
} else
${'s_trackback_count28_argument'} = NULL;if(${'s_trackback_count28_argument'} !== null) ${'s_trackback_count28_argument'}->setColumnType('number');
if(isset($args->s_uploaded_count)) {
${'s_uploaded_count29_argument'} = new ConditionArgument('s_uploaded_count', $args->s_uploaded_count, 'more');
${'s_uploaded_count29_argument'}->createConditionValue();
if(!${'s_uploaded_count29_argument'}->isValid()) return ${'s_uploaded_count29_argument'}->getErrorMessage();
} else
${'s_uploaded_count29_argument'} = NULL;if(${'s_uploaded_count29_argument'} !== null) ${'s_uploaded_count29_argument'}->setColumnType('number');
if(isset($args->s_regdate)) {
${'s_regdate30_argument'} = new ConditionArgument('s_regdate', $args->s_regdate, 'like_prefix');
${'s_regdate30_argument'}->createConditionValue();
if(!${'s_regdate30_argument'}->isValid()) return ${'s_regdate30_argument'}->getErrorMessage();
} else
${'s_regdate30_argument'} = NULL;if(${'s_regdate30_argument'} !== null) ${'s_regdate30_argument'}->setColumnType('date');
if(isset($args->s_last_update)) {
${'s_last_update31_argument'} = new ConditionArgument('s_last_update', $args->s_last_update, 'like_prefix');
${'s_last_update31_argument'}->createConditionValue();
if(!${'s_last_update31_argument'}->isValid()) return ${'s_last_update31_argument'}->getErrorMessage();
} else
${'s_last_update31_argument'} = NULL;if(${'s_last_update31_argument'} !== null) ${'s_last_update31_argument'}->setColumnType('date');
if(isset($args->s_ipaddress)) {
${'s_ipaddress32_argument'} = new ConditionArgument('s_ipaddress', $args->s_ipaddress, 'like_prefix');
${'s_ipaddress32_argument'}->createConditionValue();
if(!${'s_ipaddress32_argument'}->isValid()) return ${'s_ipaddress32_argument'}->getErrorMessage();
} else
${'s_ipaddress32_argument'} = NULL;if(${'s_ipaddress32_argument'} !== null) ${'s_ipaddress32_argument'}->setColumnType('varchar');
if(isset($args->start_date)) {
${'start_date33_argument'} = new ConditionArgument('start_date', $args->start_date, 'more');
${'start_date33_argument'}->createConditionValue();
if(!${'start_date33_argument'}->isValid()) return ${'start_date33_argument'}->getErrorMessage();
} else
${'start_date33_argument'} = NULL;if(${'start_date33_argument'} !== null) ${'start_date33_argument'}->setColumnType('date');
if(isset($args->end_date)) {
${'end_date34_argument'} = new ConditionArgument('end_date', $args->end_date, 'less');
${'end_date34_argument'}->createConditionValue();
if(!${'end_date34_argument'}->isValid()) return ${'end_date34_argument'}->getErrorMessage();
} else
${'end_date34_argument'} = NULL;if(${'end_date34_argument'} !== null) ${'end_date34_argument'}->setColumnType('date');

${'page37_argument'} = new Argument('page', $args->{'page'});
${'page37_argument'}->ensureDefaultValue('1');
if(!${'page37_argument'}->isValid()) return ${'page37_argument'}->getErrorMessage();

${'page_count38_argument'} = new Argument('page_count', $args->{'page_count'});
${'page_count38_argument'}->ensureDefaultValue('10');
if(!${'page_count38_argument'}->isValid()) return ${'page_count38_argument'}->getErrorMessage();

${'list_count39_argument'} = new Argument('list_count', $args->{'list_count'});
${'list_count39_argument'}->ensureDefaultValue('20');
if(!${'list_count39_argument'}->isValid()) return ${'list_count39_argument'}->getErrorMessage();

${'sort_index35_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index35_argument'}->ensureDefaultValue('list_order');
if(!${'sort_index35_argument'}->isValid()) return ${'sort_index35_argument'}->getErrorMessage();

${'order_type36_argument'} = new SortArgument('order_type36', $args->order_type);
${'order_type36_argument'}->ensureDefaultValue('asc');
if(!${'order_type36_argument'}->isValid()) return ${'order_type36_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_documents`', '`documents`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`module_srl`',$module_srl7_argument,"in")
,new ConditionWithArgument('`module_srl`',$exclude_module_srl8_argument,"notin", 'and')
,new ConditionWithArgument('`category_srl`',$category_srl9_argument,"in", 'and')
,new ConditionWithArgument('`is_notice`',$s_is_notice10_argument,"equal", 'and')
,new ConditionWithArgument('`member_srl`',$member_srl11_argument,"equal", 'and')
,new ConditionWithArgument('`status`',$statusList12_argument,"in", 'and')))
,new ConditionGroup(array(
new ConditionWithArgument('`list_order`',$division13_argument,"more", 'and')
,new ConditionWithArgument('`list_order`',$last_division14_argument,"below", 'and')),'and')
,new ConditionGroup(array(
new ConditionWithArgument('`title`',$s_title15_argument,"like")
,new ConditionWithArgument('`content`',$s_content16_argument,"like", 'or')
,new ConditionWithArgument('`user_name`',$s_user_name17_argument,"like", 'or')
,new ConditionWithArgument('`user_id`',$s_user_id18_argument,"like", 'or')
,new ConditionWithArgument('`nick_name`',$s_nick_name19_argument,"like", 'or')
,new ConditionWithArgument('`email_address`',$s_email_address20_argument,"like", 'or')
,new ConditionWithArgument('`homepage`',$s_homepage21_argument,"like", 'or')
,new ConditionWithArgument('`tags`',$s_tags22_argument,"like", 'or')
,new ConditionWithArgument('`member_srl`',$s_member_srl23_argument,"equal", 'or')
,new ConditionWithArgument('`readed_count`',$s_readed_count24_argument,"more", 'or')
,new ConditionWithArgument('`voted_count`',$s_voted_count25_argument,"more", 'or')
,new ConditionWithArgument('`blamed_count`',$s_blamed_count26_argument,"less", 'or')
,new ConditionWithArgument('`comment_count`',$s_comment_count27_argument,"more", 'or')
,new ConditionWithArgument('`trackback_count`',$s_trackback_count28_argument,"more", 'or')
,new ConditionWithArgument('`uploaded_count`',$s_uploaded_count29_argument,"more", 'or')
,new ConditionWithArgument('`regdate`',$s_regdate30_argument,"like_prefix", 'or')
,new ConditionWithArgument('`last_update`',$s_last_update31_argument,"like_prefix", 'or')
,new ConditionWithArgument('`ipaddress`',$s_ipaddress32_argument,"like_prefix", 'or')),'and')
,new ConditionGroup(array(
new ConditionWithArgument('`last_update`',$start_date33_argument,"more", 'and')
,new ConditionWithArgument('`last_update`',$end_date34_argument,"less", 'and')),'and')
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index35_argument'}, $order_type36_argument)
));
$query->setLimit(new Limit(${'list_count39_argument'}, ${'page37_argument'}, ${'page_count38_argument'}));
return $query; ?>