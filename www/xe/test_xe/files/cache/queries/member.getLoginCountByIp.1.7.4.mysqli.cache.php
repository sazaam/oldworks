<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getLoginCountByIp");
$query->setAction("select");
$query->setPriority("");
if(isset($args->ipaddress)) {
${'ipaddress2_argument'} = new ConditionArgument('ipaddress', $args->ipaddress, 'equal');
${'ipaddress2_argument'}->createConditionValue();
if(!${'ipaddress2_argument'}->isValid()) return ${'ipaddress2_argument'}->getErrorMessage();
} else
${'ipaddress2_argument'} = NULL;if(${'ipaddress2_argument'} !== null) ${'ipaddress2_argument'}->setColumnType('varchar');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_member_login_count`', '`member_login_count`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`ipaddress`',$ipaddress2_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>