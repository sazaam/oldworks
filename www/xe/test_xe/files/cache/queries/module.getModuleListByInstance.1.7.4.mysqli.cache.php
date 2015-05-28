<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getModuleListByInstance");
$query->setAction("select");
$query->setPriority("");
if(isset($args->site_srl)) {
${'site_srl6_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl6_argument'}->checkFilter('number');
${'site_srl6_argument'}->createConditionValue();
if(!${'site_srl6_argument'}->isValid()) return ${'site_srl6_argument'}->getErrorMessage();
} else
${'site_srl6_argument'} = NULL;if(${'site_srl6_argument'} !== null) ${'site_srl6_argument'}->setColumnType('number');

$query->setColumns(array(
new StarExpression()
,new SelectExpression('count(`module_srl`)', '`instanceCount`')
));
$query->setTables(array(
new Table('`xe_modules`', '`modules`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl6_argument,"equal")))
));
$query->setGroups(array(
'`module`' ));
$query->setOrder(array());
$query->setLimit();
return $query; ?>