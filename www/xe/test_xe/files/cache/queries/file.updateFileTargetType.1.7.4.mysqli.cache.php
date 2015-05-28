<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateFileTargetType");
$query->setAction("update");
$query->setPriority("");
if(isset($args->upload_target_type)) {
${'upload_target_type18_argument'} = new Argument('upload_target_type', $args->{'upload_target_type'});
if(!${'upload_target_type18_argument'}->isValid()) return ${'upload_target_type18_argument'}->getErrorMessage();
} else
${'upload_target_type18_argument'} = NULL;if(${'upload_target_type18_argument'} !== null) ${'upload_target_type18_argument'}->setColumnType('char');

${'file_srl19_argument'} = new ConditionArgument('file_srl', $args->file_srl, 'equal');
${'file_srl19_argument'}->checkFilter('number');
${'file_srl19_argument'}->checkNotNull();
${'file_srl19_argument'}->createConditionValue();
if(!${'file_srl19_argument'}->isValid()) return ${'file_srl19_argument'}->getErrorMessage();
if(${'file_srl19_argument'} !== null) ${'file_srl19_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`upload_target_type`', ${'upload_target_type18_argument'})
));
$query->setTables(array(
new Table('`xe_files`', '`files`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`file_srl`',$file_srl19_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>