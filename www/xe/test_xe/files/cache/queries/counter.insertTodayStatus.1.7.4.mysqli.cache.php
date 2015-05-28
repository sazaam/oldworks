<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertTodayStatus");
$query->setAction("insert");
$query->setPriority("");

${'regdate1_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate1_argument'}->ensureDefaultValue('0');
${'regdate1_argument'}->checkNotNull();
if(!${'regdate1_argument'}->isValid()) return ${'regdate1_argument'}->getErrorMessage();
if(${'regdate1_argument'} !== null) ${'regdate1_argument'}->setColumnType('number');

${'unique_visitor2_argument'} = new Argument('unique_visitor', $args->{'unique_visitor'});
${'unique_visitor2_argument'}->ensureDefaultValue('0');
if(!${'unique_visitor2_argument'}->isValid()) return ${'unique_visitor2_argument'}->getErrorMessage();
if(${'unique_visitor2_argument'} !== null) ${'unique_visitor2_argument'}->setColumnType('number');

${'pageview3_argument'} = new Argument('pageview', $args->{'pageview'});
${'pageview3_argument'}->ensureDefaultValue('0');
if(!${'pageview3_argument'}->isValid()) return ${'pageview3_argument'}->getErrorMessage();
if(${'pageview3_argument'} !== null) ${'pageview3_argument'}->setColumnType('number');

$query->setColumns(array(
new InsertExpression('`regdate`', ${'regdate1_argument'})
,new InsertExpression('`unique_visitor`', ${'unique_visitor2_argument'})
,new InsertExpression('`pageview`', ${'pageview3_argument'})
));
$query->setTables(array(
new Table('`xe_counter_status`', '`counter_status`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>