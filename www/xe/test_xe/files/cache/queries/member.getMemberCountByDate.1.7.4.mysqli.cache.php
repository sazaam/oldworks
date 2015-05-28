<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getMemberCountByDate");
$query->setAction("select");
$query->setPriority("");
if(isset($args->regDate)) {
${'regDate3_argument'} = new ConditionArgument('regDate', $args->regDate, 'like_prefix');
${'regDate3_argument'}->createConditionValue();
if(!${'regDate3_argument'}->isValid()) return ${'regDate3_argument'}->getErrorMessage();
} else
${'regDate3_argument'} = NULL;if(${'regDate3_argument'} !== null) ${'regDate3_argument'}->setColumnType('date');

$query->setColumns(array(
new SelectExpression('count(*)', '`count`')
));
$query->setTables(array(
new Table('`xe_member`', '`member`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`regdate`',$regDate3_argument,"like_prefix")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>