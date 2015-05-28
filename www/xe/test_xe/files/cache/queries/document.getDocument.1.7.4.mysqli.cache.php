<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getDocument");
$query->setAction("select");
$query->setPriority("");

${'document_srl20_argument'} = new ConditionArgument('document_srl', $args->document_srl, 'equal');
${'document_srl20_argument'}->checkFilter('number');
${'document_srl20_argument'}->checkNotNull();
${'document_srl20_argument'}->createConditionValue();
if(!${'document_srl20_argument'}->isValid()) return ${'document_srl20_argument'}->getErrorMessage();
if(${'document_srl20_argument'} !== null) ${'document_srl20_argument'}->setColumnType('number');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_documents`', '`documents`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`document_srl`',$document_srl20_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>