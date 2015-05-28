<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateCounterUnique");
$query->setAction("update");
$query->setPriority("");

${'unique_visitor8_argument'} = new Argument('unique_visitor', NULL);
${'unique_visitor8_argument'}->setColumnOperation('+');
${'unique_visitor8_argument'}->ensureDefaultValue(1);
if(!${'unique_visitor8_argument'}->isValid()) return ${'unique_visitor8_argument'}->getErrorMessage();
if(${'unique_visitor8_argument'} !== null) ${'unique_visitor8_argument'}->setColumnType('number');

${'pageview9_argument'} = new Argument('pageview', NULL);
${'pageview9_argument'}->setColumnOperation('+');
${'pageview9_argument'}->ensureDefaultValue(1);
if(!${'pageview9_argument'}->isValid()) return ${'pageview9_argument'}->getErrorMessage();
if(${'pageview9_argument'} !== null) ${'pageview9_argument'}->setColumnType('number');

${'regdate10_argument'} = new ConditionArgument('regdate', $args->regdate, 'in');
${'regdate10_argument'}->checkNotNull();
${'regdate10_argument'}->createConditionValue();
if(!${'regdate10_argument'}->isValid()) return ${'regdate10_argument'}->getErrorMessage();
if(${'regdate10_argument'} !== null) ${'regdate10_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`unique_visitor`', ${'unique_visitor8_argument'})
,new UpdateExpression('`pageview`', ${'pageview9_argument'})
));
$query->setTables(array(
new Table('`xe_counter_status`', '`counter_status`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`regdate`',$regdate10_argument,"in")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>