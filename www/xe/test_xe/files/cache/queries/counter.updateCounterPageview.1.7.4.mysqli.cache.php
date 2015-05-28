<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateCounterPageview");
$query->setAction("update");
$query->setPriority("");

${'pageview12_argument'} = new Argument('pageview', NULL);
${'pageview12_argument'}->setColumnOperation('+');
${'pageview12_argument'}->ensureDefaultValue(1);
if(!${'pageview12_argument'}->isValid()) return ${'pageview12_argument'}->getErrorMessage();
if(${'pageview12_argument'} !== null) ${'pageview12_argument'}->setColumnType('number');

${'regdate13_argument'} = new ConditionArgument('regdate', $args->regdate, 'in');
${'regdate13_argument'}->checkNotNull();
${'regdate13_argument'}->createConditionValue();
if(!${'regdate13_argument'}->isValid()) return ${'regdate13_argument'}->getErrorMessage();
if(${'regdate13_argument'} !== null) ${'regdate13_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`pageview`', ${'pageview12_argument'})
));
$query->setTables(array(
new Table('`xe_counter_status`', '`counter_status`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`regdate`',$regdate13_argument,"in")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>