<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getDocumentCountByDate");
$query->setAction("select");
$query->setPriority("");
if(isset($args->moduleSrlList)) {
${'moduleSrlList4_argument'} = new ConditionArgument('moduleSrlList', $args->moduleSrlList, 'in');
${'moduleSrlList4_argument'}->createConditionValue();
if(!${'moduleSrlList4_argument'}->isValid()) return ${'moduleSrlList4_argument'}->getErrorMessage();
} else
${'moduleSrlList4_argument'} = NULL;if(${'moduleSrlList4_argument'} !== null) ${'moduleSrlList4_argument'}->setColumnType('number');
if(isset($args->regDate)) {
${'regDate5_argument'} = new ConditionArgument('regDate', $args->regDate, 'like_prefix');
${'regDate5_argument'}->createConditionValue();
if(!${'regDate5_argument'}->isValid()) return ${'regDate5_argument'}->getErrorMessage();
} else
${'regDate5_argument'} = NULL;if(${'regDate5_argument'} !== null) ${'regDate5_argument'}->setColumnType('date');
if(isset($args->statusList)) {
${'statusList6_argument'} = new ConditionArgument('statusList', $args->statusList, 'in');
${'statusList6_argument'}->createConditionValue();
if(!${'statusList6_argument'}->isValid()) return ${'statusList6_argument'}->getErrorMessage();
} else
${'statusList6_argument'} = NULL;if(${'statusList6_argument'} !== null) ${'statusList6_argument'}->setColumnType('varchar');

$query->setColumns(array(
new SelectExpression('count(*)', '`count`')
));
$query->setTables(array(
new Table('`xe_documents`', '`documents`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`module_srl`',$moduleSrlList4_argument,"in")
,new ConditionWithArgument('`regdate`',$regDate5_argument,"like_prefix", 'and')
,new ConditionWithArgument('`status`',$statusList6_argument,"in", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>