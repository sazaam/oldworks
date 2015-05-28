<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("isExistsSiteDomain");
$query->setAction("select");
$query->setPriority("");

${'domain5_argument'} = new ConditionArgument('domain', $args->domain, 'equal');
${'domain5_argument'}->checkNotNull();
${'domain5_argument'}->createConditionValue();
if(!${'domain5_argument'}->isValid()) return ${'domain5_argument'}->getErrorMessage();
if(${'domain5_argument'} !== null) ${'domain5_argument'}->setColumnType('varchar');

$query->setColumns(array(
new SelectExpression('count(*)', '`count`')
));
$query->setTables(array(
new Table('`xe_sites`', '`sites`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`domain`',$domain5_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>