<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getTodayStatus");
$query->setAction("select");
$query->setPriority("");

${'regdate8_argument'} = new ConditionArgument('regdate', $args->regdate, 'equal');
${'regdate8_argument'}->checkNotNull();
${'regdate8_argument'}->createConditionValue();
if(!${'regdate8_argument'}->isValid()) return ${'regdate8_argument'}->getErrorMessage();
if(${'regdate8_argument'} !== null) ${'regdate8_argument'}->setColumnType('number');

$query->setColumns(array(
new SelectExpression('count(*)', '`count`')
));
$query->setTables(array(
new Table('`xe_counter_status`', '`counter_status`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`regdate`',$regdate8_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>