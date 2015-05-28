<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getCounterStatus");
$query->setAction("select");
$query->setPriority("");

${'start_date1_argument'} = new ConditionArgument('start_date', $args->start_date, 'more');
${'start_date1_argument'}->checkNotNull();
${'start_date1_argument'}->createConditionValue();
if(!${'start_date1_argument'}->isValid()) return ${'start_date1_argument'}->getErrorMessage();
if(${'start_date1_argument'} !== null) ${'start_date1_argument'}->setColumnType('number');

${'end_date2_argument'} = new ConditionArgument('end_date', $args->end_date, 'less');
${'end_date2_argument'}->checkNotNull();
${'end_date2_argument'}->createConditionValue();
if(!${'end_date2_argument'}->isValid()) return ${'end_date2_argument'}->getErrorMessage();
if(${'end_date2_argument'} !== null) ${'end_date2_argument'}->setColumnType('number');

$query->setColumns(array(
new SelectExpression('sum(`unique_visitor`)', '`unique_visitor`')
,new SelectExpression('sum(`pageview`)', '`pageview`')
));
$query->setTables(array(
new Table('`xe_counter_status`', '`counter_status`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`regdate`',$start_date1_argument,"more", 'and')
,new ConditionWithArgument('`regdate`',$end_date2_argument,"less", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>