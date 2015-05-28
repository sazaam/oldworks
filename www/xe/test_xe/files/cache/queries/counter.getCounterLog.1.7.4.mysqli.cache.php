<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getCounterLog");
$query->setAction("select");
$query->setPriority("");

${'site_srl9_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl9_argument'}->ensureDefaultValue('0');
${'site_srl9_argument'}->createConditionValue();
if(!${'site_srl9_argument'}->isValid()) return ${'site_srl9_argument'}->getErrorMessage();
if(${'site_srl9_argument'} !== null) ${'site_srl9_argument'}->setColumnType('number');
if(isset($args->ipaddress)) {
${'ipaddress10_argument'} = new ConditionArgument('ipaddress', $args->ipaddress, 'equal');
${'ipaddress10_argument'}->createConditionValue();
if(!${'ipaddress10_argument'}->isValid()) return ${'ipaddress10_argument'}->getErrorMessage();
} else
${'ipaddress10_argument'} = NULL;if(${'ipaddress10_argument'} !== null) ${'ipaddress10_argument'}->setColumnType('varchar');

${'regdate11_argument'} = new ConditionArgument('regdate', $args->regdate, 'like_prefix');
${'regdate11_argument'}->checkNotNull();
${'regdate11_argument'}->createConditionValue();
if(!${'regdate11_argument'}->isValid()) return ${'regdate11_argument'}->getErrorMessage();
if(${'regdate11_argument'} !== null) ${'regdate11_argument'}->setColumnType('date');

$query->setColumns(array(
new SelectExpression('count(*)', '`count`')
));
$query->setTables(array(
new Table('`xe_counter_log`', '`counter_log`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl9_argument,"equal", 'and')
,new ConditionWithArgument('`ipaddress`',$ipaddress10_argument,"equal", 'and')
,new ConditionWithArgument('`regdate`',$regdate11_argument,"like_prefix", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>