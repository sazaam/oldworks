<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("deleteDocumentExtraKeys");
$query->setAction("delete");
$query->setPriority("");

${'module_srl12_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'equal');
${'module_srl12_argument'}->checkFilter('number');
${'module_srl12_argument'}->checkNotNull();
${'module_srl12_argument'}->createConditionValue();
if(!${'module_srl12_argument'}->isValid()) return ${'module_srl12_argument'}->getErrorMessage();
if(${'module_srl12_argument'} !== null) ${'module_srl12_argument'}->setColumnType('number');
if(isset($args->document_srl)) {
${'document_srl13_argument'} = new ConditionArgument('document_srl', $args->document_srl, 'equal');
${'document_srl13_argument'}->checkFilter('number');
${'document_srl13_argument'}->createConditionValue();
if(!${'document_srl13_argument'}->isValid()) return ${'document_srl13_argument'}->getErrorMessage();
} else
${'document_srl13_argument'} = NULL;if(isset($args->var_idx)) {
${'var_idx14_argument'} = new ConditionArgument('var_idx', $args->var_idx, 'equal');
${'var_idx14_argument'}->checkFilter('number');
${'var_idx14_argument'}->createConditionValue();
if(!${'var_idx14_argument'}->isValid()) return ${'var_idx14_argument'}->getErrorMessage();
} else
${'var_idx14_argument'} = NULL;if(${'var_idx14_argument'} !== null) ${'var_idx14_argument'}->setColumnType('number');

$query->setTables(array(
new Table('`xe_document_extra_keys`', '`document_extra_keys`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`module_srl`',$module_srl12_argument,"equal")
,new ConditionWithArgument('`document_srl`',$document_srl13_argument,"equal", 'and')
,new ConditionWithArgument('`var_idx`',$var_idx14_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>