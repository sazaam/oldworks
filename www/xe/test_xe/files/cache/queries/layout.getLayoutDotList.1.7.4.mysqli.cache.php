<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getLayoutDotList");
$query->setAction("select");
$query->setPriority("");

${'site_srl8_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl8_argument'}->checkFilter('number');
${'site_srl8_argument'}->ensureDefaultValue('0');
${'site_srl8_argument'}->checkNotNull();
${'site_srl8_argument'}->createConditionValue();
if(!${'site_srl8_argument'}->isValid()) return ${'site_srl8_argument'}->getErrorMessage();
if(${'site_srl8_argument'} !== null) ${'site_srl8_argument'}->setColumnType('number');

${'layout_type9_argument'} = new ConditionArgument('layout_type', $args->layout_type, 'equal');
${'layout_type9_argument'}->ensureDefaultValue('P');
${'layout_type9_argument'}->createConditionValue();
if(!${'layout_type9_argument'}->isValid()) return ${'layout_type9_argument'}->getErrorMessage();
if(${'layout_type9_argument'} !== null) ${'layout_type9_argument'}->setColumnType('char');

${'layout10_argument'} = new ConditionArgument('layout', $args->layout, 'like');
${'layout10_argument'}->ensureDefaultValue('.');
${'layout10_argument'}->createConditionValue();
if(!${'layout10_argument'}->isValid()) return ${'layout10_argument'}->getErrorMessage();
if(${'layout10_argument'} !== null) ${'layout10_argument'}->setColumnType('varchar');

${'sort_index11_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index11_argument'}->ensureDefaultValue('layout_srl');
if(!${'sort_index11_argument'}->isValid()) return ${'sort_index11_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_layouts`', '`layouts`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl8_argument,"equal")
,new ConditionWithArgument('`layout_type`',$layout_type9_argument,"equal", 'and')
,new ConditionWithArgument('`layout`',$layout10_argument,"like", 'and')))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index11_argument'}, "desc")
));
$query->setLimit();
return $query; ?>