<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getFiles");
$query->setAction("select");
$query->setPriority("");

${'upload_target_srl1_argument'} = new ConditionArgument('upload_target_srl', $args->upload_target_srl, 'equal');
${'upload_target_srl1_argument'}->checkFilter('number');
${'upload_target_srl1_argument'}->checkNotNull();
${'upload_target_srl1_argument'}->createConditionValue();
if(!${'upload_target_srl1_argument'}->isValid()) return ${'upload_target_srl1_argument'}->getErrorMessage();
if(${'upload_target_srl1_argument'} !== null) ${'upload_target_srl1_argument'}->setColumnType('number');
if(isset($args->isvalid)) {
${'isvalid2_argument'} = new ConditionArgument('isvalid', $args->isvalid, 'equal');
${'isvalid2_argument'}->createConditionValue();
if(!${'isvalid2_argument'}->isValid()) return ${'isvalid2_argument'}->getErrorMessage();
} else
${'isvalid2_argument'} = NULL;if(${'isvalid2_argument'} !== null) ${'isvalid2_argument'}->setColumnType('char');
if(isset($args->sort_index)) {
${'sort_index3_argument'} = new Argument('sort_index', $args->{'sort_index'});
if(!${'sort_index3_argument'}->isValid()) return ${'sort_index3_argument'}->getErrorMessage();
} else
${'sort_index3_argument'} = NULL;
$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_files`', '`files`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`upload_target_srl`',$upload_target_srl1_argument,"equal")
,new ConditionWithArgument('`isvalid`',$isvalid2_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index3_argument'}, "asc")
));
$query->setLimit();
return $query; ?>