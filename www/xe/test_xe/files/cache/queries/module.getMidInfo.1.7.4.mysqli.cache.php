<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getMidInfo");
$query->setAction("select");
$query->setPriority("");
if(isset($args->mid)) {
${'mid14_argument'} = new ConditionArgument('mid', $args->mid, 'equal');
${'mid14_argument'}->createConditionValue();
if(!${'mid14_argument'}->isValid()) return ${'mid14_argument'}->getErrorMessage();
} else
${'mid14_argument'} = NULL;if(${'mid14_argument'} !== null) ${'mid14_argument'}->setColumnType('varchar');
if(isset($args->module_srl)) {
${'module_srl15_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'equal');
${'module_srl15_argument'}->createConditionValue();
if(!${'module_srl15_argument'}->isValid()) return ${'module_srl15_argument'}->getErrorMessage();
} else
${'module_srl15_argument'} = NULL;if(${'module_srl15_argument'} !== null) ${'module_srl15_argument'}->setColumnType('number');
if(isset($args->site_srl)) {
${'site_srl16_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl16_argument'}->createConditionValue();
if(!${'site_srl16_argument'}->isValid()) return ${'site_srl16_argument'}->getErrorMessage();
} else
${'site_srl16_argument'} = NULL;if(${'site_srl16_argument'} !== null) ${'site_srl16_argument'}->setColumnType('number');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_modules`', '`modules`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`mid`',$mid14_argument,"equal")
,new ConditionWithArgument('`module_srl`',$module_srl15_argument,"equal", 'and')
,new ConditionWithArgument('`site_srl`',$site_srl16_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>