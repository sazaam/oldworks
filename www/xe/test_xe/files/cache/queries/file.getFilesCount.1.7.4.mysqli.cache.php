<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getFilesCount");
$query->setAction("select");
$query->setPriority("");
if(isset($args->upload_target_srl)) {
${'upload_target_srl3_argument'} = new ConditionArgument('upload_target_srl', $args->upload_target_srl, 'equal');
${'upload_target_srl3_argument'}->checkFilter('number');
${'upload_target_srl3_argument'}->createConditionValue();
if(!${'upload_target_srl3_argument'}->isValid()) return ${'upload_target_srl3_argument'}->getErrorMessage();
} else
${'upload_target_srl3_argument'} = NULL;if(${'upload_target_srl3_argument'} !== null) ${'upload_target_srl3_argument'}->setColumnType('number');
if(isset($args->regDate)) {
${'regDate4_argument'} = new ConditionArgument('regDate', $args->regDate, 'like_prefix');
${'regDate4_argument'}->createConditionValue();
if(!${'regDate4_argument'}->isValid()) return ${'regDate4_argument'}->getErrorMessage();
} else
${'regDate4_argument'} = NULL;if(${'regDate4_argument'} !== null) ${'regDate4_argument'}->setColumnType('date');

$query->setColumns(array(
new SelectExpression('count(*)', '`count`')
));
$query->setTables(array(
new Table('`xe_files`', '`files`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`upload_target_srl`',$upload_target_srl3_argument,"equal")
,new ConditionWithArgument('`regdate`',$regDate4_argument,"like_prefix", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>