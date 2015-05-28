<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateDownloadCount");
$query->setAction("update");
$query->setPriority("");

${'download_count2_argument'} = new Argument('download_count', $args->{'download_count'});
${'download_count2_argument'}->setColumnOperation('+');
${'download_count2_argument'}->ensureDefaultValue(1);
if(!${'download_count2_argument'}->isValid()) return ${'download_count2_argument'}->getErrorMessage();
if(${'download_count2_argument'} !== null) ${'download_count2_argument'}->setColumnType('number');

${'file_srl3_argument'} = new ConditionArgument('file_srl', $args->file_srl, 'equal');
${'file_srl3_argument'}->checkFilter('number');
${'file_srl3_argument'}->checkNotNull();
${'file_srl3_argument'}->createConditionValue();
if(!${'file_srl3_argument'}->isValid()) return ${'file_srl3_argument'}->getErrorMessage();
if(${'file_srl3_argument'} !== null) ${'file_srl3_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`download_count`', ${'download_count2_argument'})
));
$query->setTables(array(
new Table('`xe_files`', '`files`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`file_srl`',$file_srl3_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>