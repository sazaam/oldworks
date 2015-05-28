<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getSite");
$query->setAction("select");
$query->setPriority("");

${'site_srl14_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl14_argument'}->checkNotNull();
${'site_srl14_argument'}->createConditionValue();
if(!${'site_srl14_argument'}->isValid()) return ${'site_srl14_argument'}->getErrorMessage();
if(${'site_srl14_argument'} !== null) ${'site_srl14_argument'}->setColumnType('number');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_sites`', '`sites`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl14_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>