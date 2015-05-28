<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updatePoint");
$query->setAction("update");
$query->setPriority("");
if(isset($args->point)) {
${'point36_argument'} = new Argument('point', $args->{'point'});
if(!${'point36_argument'}->isValid()) return ${'point36_argument'}->getErrorMessage();
} else
${'point36_argument'} = NULL;if(${'point36_argument'} !== null) ${'point36_argument'}->setColumnType('number');

${'member_srl37_argument'} = new ConditionArgument('member_srl', $args->member_srl, 'equal');
${'member_srl37_argument'}->checkFilter('number');
${'member_srl37_argument'}->checkNotNull();
${'member_srl37_argument'}->createConditionValue();
if(!${'member_srl37_argument'}->isValid()) return ${'member_srl37_argument'}->getErrorMessage();
if(${'member_srl37_argument'} !== null) ${'member_srl37_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`point`', ${'point36_argument'})
));
$query->setTables(array(
new Table('`xe_point`', '`point`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`member_srl`',$member_srl37_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>