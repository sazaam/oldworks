<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("deleteDocumentExtraVars");
$query->setAction("delete");
$query->setPriority("");

${'module_srl33_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'equal');
${'module_srl33_argument'}->checkFilter('number');
${'module_srl33_argument'}->checkNotNull();
${'module_srl33_argument'}->createConditionValue();
if(!${'module_srl33_argument'}->isValid()) return ${'module_srl33_argument'}->getErrorMessage();
if(${'module_srl33_argument'} !== null) ${'module_srl33_argument'}->setColumnType('number');
if(isset($args->document_srl)) {
${'document_srl34_argument'} = new ConditionArgument('document_srl', $args->document_srl, 'equal');
${'document_srl34_argument'}->checkFilter('number');
${'document_srl34_argument'}->createConditionValue();
if(!${'document_srl34_argument'}->isValid()) return ${'document_srl34_argument'}->getErrorMessage();
} else
${'document_srl34_argument'} = NULL;if(${'document_srl34_argument'} !== null) ${'document_srl34_argument'}->setColumnType('number');
if(isset($args->var_idx)) {
${'var_idx35_argument'} = new ConditionArgument('var_idx', $args->var_idx, 'equal');
${'var_idx35_argument'}->checkFilter('number');
${'var_idx35_argument'}->createConditionValue();
if(!${'var_idx35_argument'}->isValid()) return ${'var_idx35_argument'}->getErrorMessage();
} else
${'var_idx35_argument'} = NULL;if(${'var_idx35_argument'} !== null) ${'var_idx35_argument'}->setColumnType('number');
if(isset($args->lang_code)) {
${'lang_code36_argument'} = new ConditionArgument('lang_code', $args->lang_code, 'equal');
${'lang_code36_argument'}->createConditionValue();
if(!${'lang_code36_argument'}->isValid()) return ${'lang_code36_argument'}->getErrorMessage();
} else
${'lang_code36_argument'} = NULL;if(${'lang_code36_argument'} !== null) ${'lang_code36_argument'}->setColumnType('varchar');
if(isset($args->eid)) {
${'eid37_argument'} = new ConditionArgument('eid', $args->eid, 'equal');
${'eid37_argument'}->createConditionValue();
if(!${'eid37_argument'}->isValid()) return ${'eid37_argument'}->getErrorMessage();
} else
${'eid37_argument'} = NULL;if(${'eid37_argument'} !== null) ${'eid37_argument'}->setColumnType('varchar');

$query->setTables(array(
new Table('`xe_document_extra_vars`', '`document_extra_vars`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`module_srl`',$module_srl33_argument,"equal")
,new ConditionWithArgument('`document_srl`',$document_srl34_argument,"equal", 'and')
,new ConditionWithArgument('`var_idx`',$var_idx35_argument,"equal", 'and')
,new ConditionWithArgument('`lang_code`',$lang_code36_argument,"equal", 'and')
,new ConditionWithArgument('`eid`',$eid37_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>