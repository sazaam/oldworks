<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getLangListByLangcode");
$query->setAction("select");
$query->setPriority("");

${'site_srl1_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl1_argument'}->checkFilter('number');
${'site_srl1_argument'}->checkNotNull();
${'site_srl1_argument'}->createConditionValue();
if(!${'site_srl1_argument'}->isValid()) return ${'site_srl1_argument'}->getErrorMessage();
if(${'site_srl1_argument'} !== null) ${'site_srl1_argument'}->setColumnType('number');
if(isset($args->langCode)) {
${'langCode2_argument'} = new ConditionArgument('langCode', $args->langCode, 'in');
${'langCode2_argument'}->createConditionValue();
if(!${'langCode2_argument'}->isValid()) return ${'langCode2_argument'}->getErrorMessage();
} else
${'langCode2_argument'} = NULL;if(${'langCode2_argument'} !== null) ${'langCode2_argument'}->setColumnType('varchar');
if(isset($args->search_keyword)) {
${'search_keyword3_argument'} = new ConditionArgument('search_keyword', $args->search_keyword, 'like');
${'search_keyword3_argument'}->createConditionValue();
if(!${'search_keyword3_argument'}->isValid()) return ${'search_keyword3_argument'}->getErrorMessage();
} else
${'search_keyword3_argument'} = NULL;if(${'search_keyword3_argument'} !== null) ${'search_keyword3_argument'}->setColumnType('text');
if(isset($args->name)) {
${'name4_argument'} = new ConditionArgument('name', $args->name, 'equal');
${'name4_argument'}->createConditionValue();
if(!${'name4_argument'}->isValid()) return ${'name4_argument'}->getErrorMessage();
} else
${'name4_argument'} = NULL;if(${'name4_argument'} !== null) ${'name4_argument'}->setColumnType('varchar');

${'page7_argument'} = new Argument('page', $args->{'page'});
${'page7_argument'}->ensureDefaultValue('1');
if(!${'page7_argument'}->isValid()) return ${'page7_argument'}->getErrorMessage();

${'page_count8_argument'} = new Argument('page_count', $args->{'page_count'});
${'page_count8_argument'}->ensureDefaultValue('10');
if(!${'page_count8_argument'}->isValid()) return ${'page_count8_argument'}->getErrorMessage();

${'list_count9_argument'} = new Argument('list_count', $args->{'list_count'});
${'list_count9_argument'}->ensureDefaultValue('20');
if(!${'list_count9_argument'}->isValid()) return ${'list_count9_argument'}->getErrorMessage();

${'sort_index5_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index5_argument'}->ensureDefaultValue('list_order');
if(!${'sort_index5_argument'}->isValid()) return ${'sort_index5_argument'}->getErrorMessage();

${'order_type6_argument'} = new SortArgument('order_type6', $args->order_type);
${'order_type6_argument'}->ensureDefaultValue('asc');
if(!${'order_type6_argument'}->isValid()) return ${'order_type6_argument'}->getErrorMessage();

$query->setColumns(array(
new SelectExpression('`name`')
,new SelectExpression('`value`')
));
$query->setTables(array(
new Table('`xe_lang`', '`lang`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl1_argument,"equal")
,new ConditionWithArgument('`lang_code`',$langCode2_argument,"in", 'and')
,new ConditionWithArgument('`value`',$search_keyword3_argument,"like", 'and')
,new ConditionWithArgument('`name`',$name4_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index5_argument'}, $order_type6_argument)
));
$query->setLimit(new Limit(${'list_count9_argument'}, ${'page7_argument'}, ${'page_count8_argument'}));
return $query; ?>