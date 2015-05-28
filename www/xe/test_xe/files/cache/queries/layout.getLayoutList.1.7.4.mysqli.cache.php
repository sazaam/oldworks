<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getLayoutList");
$query->setAction("select");
$query->setPriority("");

${'site_srl2_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl2_argument'}->checkFilter('number');
${'site_srl2_argument'}->ensureDefaultValue('0');
${'site_srl2_argument'}->checkNotNull();
${'site_srl2_argument'}->createConditionValue();
if(!${'site_srl2_argument'}->isValid()) return ${'site_srl2_argument'}->getErrorMessage();
if(${'site_srl2_argument'} !== null) ${'site_srl2_argument'}->setColumnType('number');

${'layout_type3_argument'} = new ConditionArgument('layout_type', $args->layout_type, 'equal');
${'layout_type3_argument'}->ensureDefaultValue('P');
${'layout_type3_argument'}->createConditionValue();
if(!${'layout_type3_argument'}->isValid()) return ${'layout_type3_argument'}->getErrorMessage();
if(${'layout_type3_argument'} !== null) ${'layout_type3_argument'}->setColumnType('char');
if(isset($args->layout)) {
${'layout4_argument'} = new ConditionArgument('layout', $args->layout, 'equal');
${'layout4_argument'}->createConditionValue();
if(!${'layout4_argument'}->isValid()) return ${'layout4_argument'}->getErrorMessage();
} else
${'layout4_argument'} = NULL;if(${'layout4_argument'} !== null) ${'layout4_argument'}->setColumnType('varchar');

${'sort_index5_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index5_argument'}->ensureDefaultValue('layout_srl');
if(!${'sort_index5_argument'}->isValid()) return ${'sort_index5_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_layouts`', '`layouts`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl2_argument,"equal")
,new ConditionWithArgument('`layout_type`',$layout_type3_argument,"equal", 'and')
,new ConditionWithArgument('`layout`',$layout4_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index5_argument'}, "desc")
));
$query->setLimit();
return $query; ?>