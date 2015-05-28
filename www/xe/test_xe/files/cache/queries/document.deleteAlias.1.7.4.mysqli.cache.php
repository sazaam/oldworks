<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("deleteAlias");
$query->setAction("delete");
$query->setPriority("");
if(isset($args->alias_srl)) {
${'alias_srl15_argument'} = new ConditionArgument('alias_srl', $args->alias_srl, 'equal');
${'alias_srl15_argument'}->checkFilter('number');
${'alias_srl15_argument'}->createConditionValue();
if(!${'alias_srl15_argument'}->isValid()) return ${'alias_srl15_argument'}->getErrorMessage();
} else
${'alias_srl15_argument'} = NULL;if(${'alias_srl15_argument'} !== null) ${'alias_srl15_argument'}->setColumnType('number');
if(isset($args->document_srl)) {
${'document_srl16_argument'} = new ConditionArgument('document_srl', $args->document_srl, 'equal');
${'document_srl16_argument'}->checkFilter('number');
${'document_srl16_argument'}->createConditionValue();
if(!${'document_srl16_argument'}->isValid()) return ${'document_srl16_argument'}->getErrorMessage();
} else
${'document_srl16_argument'} = NULL;if(${'document_srl16_argument'} !== null) ${'document_srl16_argument'}->setColumnType('number');
if(isset($args->module_srl)) {
${'module_srl17_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'equal');
${'module_srl17_argument'}->checkFilter('number');
${'module_srl17_argument'}->createConditionValue();
if(!${'module_srl17_argument'}->isValid()) return ${'module_srl17_argument'}->getErrorMessage();
} else
${'module_srl17_argument'} = NULL;if(${'module_srl17_argument'} !== null) ${'module_srl17_argument'}->setColumnType('number');

$query->setTables(array(
new Table('`xe_document_aliases`', '`document_aliases`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`alias_srl`',$alias_srl15_argument,"equal")
,new ConditionWithArgument('`document_srl`',$document_srl16_argument,"equal", 'and')
,new ConditionWithArgument('`module_srl`',$module_srl17_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>