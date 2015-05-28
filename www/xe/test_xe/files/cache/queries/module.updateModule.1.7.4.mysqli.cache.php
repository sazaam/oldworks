<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateModule");
$query->setAction("update");
$query->setPriority("");

${'module5_argument'} = new Argument('module', $args->{'module'});
${'module5_argument'}->checkNotNull();
if(!${'module5_argument'}->isValid()) return ${'module5_argument'}->getErrorMessage();
if(${'module5_argument'} !== null) ${'module5_argument'}->setColumnType('varchar');
if(isset($args->module_category_srl)) {
${'module_category_srl6_argument'} = new Argument('module_category_srl', $args->{'module_category_srl'});
if(!${'module_category_srl6_argument'}->isValid()) return ${'module_category_srl6_argument'}->getErrorMessage();
} else
${'module_category_srl6_argument'} = NULL;if(${'module_category_srl6_argument'} !== null) ${'module_category_srl6_argument'}->setColumnType('number');
if(isset($args->layout_srl)) {
${'layout_srl7_argument'} = new Argument('layout_srl', $args->{'layout_srl'});
if(!${'layout_srl7_argument'}->isValid()) return ${'layout_srl7_argument'}->getErrorMessage();
} else
${'layout_srl7_argument'} = NULL;if(${'layout_srl7_argument'} !== null) ${'layout_srl7_argument'}->setColumnType('number');
if(isset($args->skin)) {
${'skin8_argument'} = new Argument('skin', $args->{'skin'});
if(!${'skin8_argument'}->isValid()) return ${'skin8_argument'}->getErrorMessage();
} else
${'skin8_argument'} = NULL;if(${'skin8_argument'} !== null) ${'skin8_argument'}->setColumnType('varchar');

${'is_skin_fix9_argument'} = new Argument('is_skin_fix', $args->{'is_skin_fix'});
${'is_skin_fix9_argument'}->ensureDefaultValue('N');
if(!${'is_skin_fix9_argument'}->isValid()) return ${'is_skin_fix9_argument'}->getErrorMessage();
if(${'is_skin_fix9_argument'} !== null) ${'is_skin_fix9_argument'}->setColumnType('char');
if(isset($args->mskin)) {
${'mskin10_argument'} = new Argument('mskin', $args->{'mskin'});
if(!${'mskin10_argument'}->isValid()) return ${'mskin10_argument'}->getErrorMessage();
} else
${'mskin10_argument'} = NULL;if(${'mskin10_argument'} !== null) ${'mskin10_argument'}->setColumnType('varchar');

${'is_mskin_fix11_argument'} = new Argument('is_mskin_fix', $args->{'is_mskin_fix'});
${'is_mskin_fix11_argument'}->ensureDefaultValue('N');
if(!${'is_mskin_fix11_argument'}->isValid()) return ${'is_mskin_fix11_argument'}->getErrorMessage();
if(${'is_mskin_fix11_argument'} !== null) ${'is_mskin_fix11_argument'}->setColumnType('char');
if(isset($args->menu_srl)) {
${'menu_srl12_argument'} = new Argument('menu_srl', $args->{'menu_srl'});
${'menu_srl12_argument'}->checkFilter('number');
if(!${'menu_srl12_argument'}->isValid()) return ${'menu_srl12_argument'}->getErrorMessage();
} else
${'menu_srl12_argument'} = NULL;if(${'menu_srl12_argument'} !== null) ${'menu_srl12_argument'}->setColumnType('number');

${'mid13_argument'} = new Argument('mid', $args->{'mid'});
${'mid13_argument'}->checkNotNull();
if(!${'mid13_argument'}->isValid()) return ${'mid13_argument'}->getErrorMessage();
if(${'mid13_argument'} !== null) ${'mid13_argument'}->setColumnType('varchar');

${'browser_title14_argument'} = new Argument('browser_title', $args->{'browser_title'});
${'browser_title14_argument'}->checkNotNull();
if(!${'browser_title14_argument'}->isValid()) return ${'browser_title14_argument'}->getErrorMessage();
if(${'browser_title14_argument'} !== null) ${'browser_title14_argument'}->setColumnType('varchar');

${'description15_argument'} = new Argument('description', $args->{'description'});
${'description15_argument'}->ensureDefaultValue('');
if(!${'description15_argument'}->isValid()) return ${'description15_argument'}->getErrorMessage();
if(${'description15_argument'} !== null) ${'description15_argument'}->setColumnType('text');

${'is_default16_argument'} = new Argument('is_default', $args->{'is_default'});
${'is_default16_argument'}->ensureDefaultValue('N');
${'is_default16_argument'}->checkNotNull();
if(!${'is_default16_argument'}->isValid()) return ${'is_default16_argument'}->getErrorMessage();
if(${'is_default16_argument'} !== null) ${'is_default16_argument'}->setColumnType('char');
if(isset($args->content)) {
${'content17_argument'} = new Argument('content', $args->{'content'});
if(!${'content17_argument'}->isValid()) return ${'content17_argument'}->getErrorMessage();
} else
${'content17_argument'} = NULL;if(${'content17_argument'} !== null) ${'content17_argument'}->setColumnType('bigtext');
if(isset($args->mcontent)) {
${'mcontent18_argument'} = new Argument('mcontent', $args->{'mcontent'});
if(!${'mcontent18_argument'}->isValid()) return ${'mcontent18_argument'}->getErrorMessage();
} else
${'mcontent18_argument'} = NULL;if(${'mcontent18_argument'} !== null) ${'mcontent18_argument'}->setColumnType('bigtext');

${'open_rss19_argument'} = new Argument('open_rss', $args->{'open_rss'});
${'open_rss19_argument'}->ensureDefaultValue('Y');
${'open_rss19_argument'}->checkNotNull();
if(!${'open_rss19_argument'}->isValid()) return ${'open_rss19_argument'}->getErrorMessage();
if(${'open_rss19_argument'} !== null) ${'open_rss19_argument'}->setColumnType('char');

${'header_text20_argument'} = new Argument('header_text', $args->{'header_text'});
${'header_text20_argument'}->ensureDefaultValue('');
if(!${'header_text20_argument'}->isValid()) return ${'header_text20_argument'}->getErrorMessage();
if(${'header_text20_argument'} !== null) ${'header_text20_argument'}->setColumnType('text');

${'footer_text21_argument'} = new Argument('footer_text', $args->{'footer_text'});
${'footer_text21_argument'}->ensureDefaultValue('');
if(!${'footer_text21_argument'}->isValid()) return ${'footer_text21_argument'}->getErrorMessage();
if(${'footer_text21_argument'} !== null) ${'footer_text21_argument'}->setColumnType('text');
if(isset($args->mlayout_srl)) {
${'mlayout_srl22_argument'} = new Argument('mlayout_srl', $args->{'mlayout_srl'});
if(!${'mlayout_srl22_argument'}->isValid()) return ${'mlayout_srl22_argument'}->getErrorMessage();
} else
${'mlayout_srl22_argument'} = NULL;if(${'mlayout_srl22_argument'} !== null) ${'mlayout_srl22_argument'}->setColumnType('number');

${'use_mobile23_argument'} = new Argument('use_mobile', $args->{'use_mobile'});
${'use_mobile23_argument'}->ensureDefaultValue('N');
if(!${'use_mobile23_argument'}->isValid()) return ${'use_mobile23_argument'}->getErrorMessage();
if(${'use_mobile23_argument'} !== null) ${'use_mobile23_argument'}->setColumnType('char');

${'site_srl24_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl24_argument'}->checkFilter('number');
${'site_srl24_argument'}->ensureDefaultValue('0');
${'site_srl24_argument'}->checkNotNull();
${'site_srl24_argument'}->createConditionValue();
if(!${'site_srl24_argument'}->isValid()) return ${'site_srl24_argument'}->getErrorMessage();
if(${'site_srl24_argument'} !== null) ${'site_srl24_argument'}->setColumnType('number');

${'module_srl25_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'equal');
${'module_srl25_argument'}->checkFilter('number');
${'module_srl25_argument'}->checkNotNull();
${'module_srl25_argument'}->createConditionValue();
if(!${'module_srl25_argument'}->isValid()) return ${'module_srl25_argument'}->getErrorMessage();
if(${'module_srl25_argument'} !== null) ${'module_srl25_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`module`', ${'module5_argument'})
,new UpdateExpression('`module_category_srl`', ${'module_category_srl6_argument'})
,new UpdateExpression('`layout_srl`', ${'layout_srl7_argument'})
,new UpdateExpression('`skin`', ${'skin8_argument'})
,new UpdateExpression('`is_skin_fix`', ${'is_skin_fix9_argument'})
,new UpdateExpression('`mskin`', ${'mskin10_argument'})
,new UpdateExpression('`is_mskin_fix`', ${'is_mskin_fix11_argument'})
,new UpdateExpression('`menu_srl`', ${'menu_srl12_argument'})
,new UpdateExpression('`mid`', ${'mid13_argument'})
,new UpdateExpression('`browser_title`', ${'browser_title14_argument'})
,new UpdateExpression('`description`', ${'description15_argument'})
,new UpdateExpression('`is_default`', ${'is_default16_argument'})
,new UpdateExpression('`content`', ${'content17_argument'})
,new UpdateExpression('`mcontent`', ${'mcontent18_argument'})
,new UpdateExpression('`open_rss`', ${'open_rss19_argument'})
,new UpdateExpression('`header_text`', ${'header_text20_argument'})
,new UpdateExpression('`footer_text`', ${'footer_text21_argument'})
,new UpdateExpression('`mlayout_srl`', ${'mlayout_srl22_argument'})
,new UpdateExpression('`use_mobile`', ${'use_mobile23_argument'})
));
$query->setTables(array(
new Table('`xe_modules`', '`modules`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl24_argument,"equal")
,new ConditionWithArgument('`module_srl`',$module_srl25_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>