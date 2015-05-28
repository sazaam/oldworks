<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertModule");
$query->setAction("insert");
$query->setPriority("");

${'site_srl6_argument'} = new Argument('site_srl', $args->{'site_srl'});
${'site_srl6_argument'}->ensureDefaultValue('0');
${'site_srl6_argument'}->checkNotNull();
if(!${'site_srl6_argument'}->isValid()) return ${'site_srl6_argument'}->getErrorMessage();
if(${'site_srl6_argument'} !== null) ${'site_srl6_argument'}->setColumnType('number');

${'module_srl7_argument'} = new Argument('module_srl', $args->{'module_srl'});
${'module_srl7_argument'}->checkNotNull();
if(!${'module_srl7_argument'}->isValid()) return ${'module_srl7_argument'}->getErrorMessage();
if(${'module_srl7_argument'} !== null) ${'module_srl7_argument'}->setColumnType('number');

${'module_category_srl8_argument'} = new Argument('module_category_srl', $args->{'module_category_srl'});
${'module_category_srl8_argument'}->ensureDefaultValue('0');
if(!${'module_category_srl8_argument'}->isValid()) return ${'module_category_srl8_argument'}->getErrorMessage();
if(${'module_category_srl8_argument'} !== null) ${'module_category_srl8_argument'}->setColumnType('number');

${'mid9_argument'} = new Argument('mid', $args->{'mid'});
${'mid9_argument'}->checkNotNull();
if(!${'mid9_argument'}->isValid()) return ${'mid9_argument'}->getErrorMessage();
if(${'mid9_argument'} !== null) ${'mid9_argument'}->setColumnType('varchar');
if(isset($args->skin)) {
${'skin10_argument'} = new Argument('skin', $args->{'skin'});
if(!${'skin10_argument'}->isValid()) return ${'skin10_argument'}->getErrorMessage();
} else
${'skin10_argument'} = NULL;if(${'skin10_argument'} !== null) ${'skin10_argument'}->setColumnType('varchar');

${'is_skin_fix11_argument'} = new Argument('is_skin_fix', $args->{'is_skin_fix'});
${'is_skin_fix11_argument'}->ensureDefaultValue('N');
if(!${'is_skin_fix11_argument'}->isValid()) return ${'is_skin_fix11_argument'}->getErrorMessage();
if(${'is_skin_fix11_argument'} !== null) ${'is_skin_fix11_argument'}->setColumnType('char');

${'is_mskin_fix12_argument'} = new Argument('is_mskin_fix', $args->{'is_mskin_fix'});
${'is_mskin_fix12_argument'}->ensureDefaultValue('N');
if(!${'is_mskin_fix12_argument'}->isValid()) return ${'is_mskin_fix12_argument'}->getErrorMessage();
if(${'is_mskin_fix12_argument'} !== null) ${'is_mskin_fix12_argument'}->setColumnType('char');
if(isset($args->mskin)) {
${'mskin13_argument'} = new Argument('mskin', $args->{'mskin'});
if(!${'mskin13_argument'}->isValid()) return ${'mskin13_argument'}->getErrorMessage();
} else
${'mskin13_argument'} = NULL;if(${'mskin13_argument'} !== null) ${'mskin13_argument'}->setColumnType('varchar');

${'browser_title14_argument'} = new Argument('browser_title', $args->{'browser_title'});
${'browser_title14_argument'}->checkNotNull();
if(!${'browser_title14_argument'}->isValid()) return ${'browser_title14_argument'}->getErrorMessage();
if(${'browser_title14_argument'} !== null) ${'browser_title14_argument'}->setColumnType('varchar');
if(isset($args->layout_srl)) {
${'layout_srl15_argument'} = new Argument('layout_srl', $args->{'layout_srl'});
if(!${'layout_srl15_argument'}->isValid()) return ${'layout_srl15_argument'}->getErrorMessage();
} else
${'layout_srl15_argument'} = NULL;if(${'layout_srl15_argument'} !== null) ${'layout_srl15_argument'}->setColumnType('number');
if(isset($args->description)) {
${'description16_argument'} = new Argument('description', $args->{'description'});
if(!${'description16_argument'}->isValid()) return ${'description16_argument'}->getErrorMessage();
} else
${'description16_argument'} = NULL;if(${'description16_argument'} !== null) ${'description16_argument'}->setColumnType('text');
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

${'module19_argument'} = new Argument('module', $args->{'module'});
${'module19_argument'}->checkNotNull();
if(!${'module19_argument'}->isValid()) return ${'module19_argument'}->getErrorMessage();
if(${'module19_argument'} !== null) ${'module19_argument'}->setColumnType('varchar');

${'is_default20_argument'} = new Argument('is_default', $args->{'is_default'});
${'is_default20_argument'}->ensureDefaultValue('N');
${'is_default20_argument'}->checkNotNull();
if(!${'is_default20_argument'}->isValid()) return ${'is_default20_argument'}->getErrorMessage();
if(${'is_default20_argument'} !== null) ${'is_default20_argument'}->setColumnType('char');
if(isset($args->menu_srl)) {
${'menu_srl21_argument'} = new Argument('menu_srl', $args->{'menu_srl'});
${'menu_srl21_argument'}->checkFilter('number');
if(!${'menu_srl21_argument'}->isValid()) return ${'menu_srl21_argument'}->getErrorMessage();
} else
${'menu_srl21_argument'} = NULL;if(${'menu_srl21_argument'} !== null) ${'menu_srl21_argument'}->setColumnType('number');

${'open_rss22_argument'} = new Argument('open_rss', $args->{'open_rss'});
${'open_rss22_argument'}->ensureDefaultValue('Y');
${'open_rss22_argument'}->checkNotNull();
if(!${'open_rss22_argument'}->isValid()) return ${'open_rss22_argument'}->getErrorMessage();
if(${'open_rss22_argument'} !== null) ${'open_rss22_argument'}->setColumnType('char');
if(isset($args->header_text)) {
${'header_text23_argument'} = new Argument('header_text', $args->{'header_text'});
if(!${'header_text23_argument'}->isValid()) return ${'header_text23_argument'}->getErrorMessage();
} else
${'header_text23_argument'} = NULL;if(${'header_text23_argument'} !== null) ${'header_text23_argument'}->setColumnType('text');
if(isset($args->footer_text)) {
${'footer_text24_argument'} = new Argument('footer_text', $args->{'footer_text'});
if(!${'footer_text24_argument'}->isValid()) return ${'footer_text24_argument'}->getErrorMessage();
} else
${'footer_text24_argument'} = NULL;if(${'footer_text24_argument'} !== null) ${'footer_text24_argument'}->setColumnType('text');

${'regdate25_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate25_argument'}->ensureDefaultValue(date("YmdHis"));
if(!${'regdate25_argument'}->isValid()) return ${'regdate25_argument'}->getErrorMessage();
if(${'regdate25_argument'} !== null) ${'regdate25_argument'}->setColumnType('date');
if(isset($args->mlayout_srl)) {
${'mlayout_srl26_argument'} = new Argument('mlayout_srl', $args->{'mlayout_srl'});
if(!${'mlayout_srl26_argument'}->isValid()) return ${'mlayout_srl26_argument'}->getErrorMessage();
} else
${'mlayout_srl26_argument'} = NULL;if(${'mlayout_srl26_argument'} !== null) ${'mlayout_srl26_argument'}->setColumnType('number');

${'use_mobile27_argument'} = new Argument('use_mobile', $args->{'use_mobile'});
${'use_mobile27_argument'}->ensureDefaultValue('N');
if(!${'use_mobile27_argument'}->isValid()) return ${'use_mobile27_argument'}->getErrorMessage();
if(${'use_mobile27_argument'} !== null) ${'use_mobile27_argument'}->setColumnType('char');

$query->setColumns(array(
new InsertExpression('`site_srl`', ${'site_srl6_argument'})
,new InsertExpression('`module_srl`', ${'module_srl7_argument'})
,new InsertExpression('`module_category_srl`', ${'module_category_srl8_argument'})
,new InsertExpression('`mid`', ${'mid9_argument'})
,new InsertExpression('`skin`', ${'skin10_argument'})
,new InsertExpression('`is_skin_fix`', ${'is_skin_fix11_argument'})
,new InsertExpression('`is_mskin_fix`', ${'is_mskin_fix12_argument'})
,new InsertExpression('`mskin`', ${'mskin13_argument'})
,new InsertExpression('`browser_title`', ${'browser_title14_argument'})
,new InsertExpression('`layout_srl`', ${'layout_srl15_argument'})
,new InsertExpression('`description`', ${'description16_argument'})
,new InsertExpression('`content`', ${'content17_argument'})
,new InsertExpression('`mcontent`', ${'mcontent18_argument'})
,new InsertExpression('`module`', ${'module19_argument'})
,new InsertExpression('`is_default`', ${'is_default20_argument'})
,new InsertExpression('`menu_srl`', ${'menu_srl21_argument'})
,new InsertExpression('`open_rss`', ${'open_rss22_argument'})
,new InsertExpression('`header_text`', ${'header_text23_argument'})
,new InsertExpression('`footer_text`', ${'footer_text24_argument'})
,new InsertExpression('`regdate`', ${'regdate25_argument'})
,new InsertExpression('`mlayout_srl`', ${'mlayout_srl26_argument'})
,new InsertExpression('`use_mobile`', ${'use_mobile27_argument'})
));
$query->setTables(array(
new Table('`xe_modules`', '`modules`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>