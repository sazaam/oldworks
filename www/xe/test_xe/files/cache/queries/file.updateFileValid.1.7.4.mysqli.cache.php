<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateFileValid");
$query->setAction("update");
$query->setPriority("");

${'isvalid47_argument'} = new Argument('isvalid', $args->{'isvalid'});
${'isvalid47_argument'}->ensureDefaultValue('Y');
${'isvalid47_argument'}->checkNotNull();
if(!${'isvalid47_argument'}->isValid()) return ${'isvalid47_argument'}->getErrorMessage();
if(${'isvalid47_argument'} !== null) ${'isvalid47_argument'}->setColumnType('char');

${'upload_target_srl48_argument'} = new ConditionArgument('upload_target_srl', $args->upload_target_srl, 'equal');
${'upload_target_srl48_argument'}->checkFilter('number');
${'upload_target_srl48_argument'}->checkNotNull();
${'upload_target_srl48_argument'}->createConditionValue();
if(!${'upload_target_srl48_argument'}->isValid()) return ${'upload_target_srl48_argument'}->getErrorMessage();
if(${'upload_target_srl48_argument'} !== null) ${'upload_target_srl48_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`isvalid`', ${'isvalid47_argument'})
));
$query->setTables(array(
new Table('`xe_files`', '`files`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`upload_target_srl`',$upload_target_srl48_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>