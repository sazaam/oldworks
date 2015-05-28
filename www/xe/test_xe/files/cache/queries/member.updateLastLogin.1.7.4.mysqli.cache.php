<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateLastLogin");
$query->setAction("update");
$query->setPriority("");

${'member_srl3_argument'} = new Argument('member_srl', $args->{'member_srl'});
${'member_srl3_argument'}->checkFilter('number');
${'member_srl3_argument'}->checkNotNull();
if(!${'member_srl3_argument'}->isValid()) return ${'member_srl3_argument'}->getErrorMessage();
if(${'member_srl3_argument'} !== null) ${'member_srl3_argument'}->setColumnType('number');

${'last_login4_argument'} = new Argument('last_login', $args->{'last_login'});
${'last_login4_argument'}->ensureDefaultValue(date("YmdHis"));
${'last_login4_argument'}->checkNotNull();
if(!${'last_login4_argument'}->isValid()) return ${'last_login4_argument'}->getErrorMessage();
if(${'last_login4_argument'} !== null) ${'last_login4_argument'}->setColumnType('date');

${'member_srl5_argument'} = new ConditionArgument('member_srl', $args->member_srl, 'equal');
${'member_srl5_argument'}->checkFilter('number');
${'member_srl5_argument'}->checkNotNull();
${'member_srl5_argument'}->createConditionValue();
if(!${'member_srl5_argument'}->isValid()) return ${'member_srl5_argument'}->getErrorMessage();
if(${'member_srl5_argument'} !== null) ${'member_srl5_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`member_srl`', ${'member_srl3_argument'})
,new UpdateExpression('`last_login`', ${'last_login4_argument'})
));
$query->setTables(array(
new Table('`xe_member`', '`member`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`member_srl`',$member_srl5_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>