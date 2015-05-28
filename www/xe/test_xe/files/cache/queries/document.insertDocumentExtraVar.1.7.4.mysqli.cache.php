<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertDocumentExtraVar");
$query->setAction("insert");
$query->setPriority("");

${'module_srl38_argument'} = new Argument('module_srl', $args->{'module_srl'});
${'module_srl38_argument'}->checkFilter('number');
${'module_srl38_argument'}->checkNotNull();
if(!${'module_srl38_argument'}->isValid()) return ${'module_srl38_argument'}->getErrorMessage();
if(${'module_srl38_argument'} !== null) ${'module_srl38_argument'}->setColumnType('number');

${'document_srl39_argument'} = new Argument('document_srl', $args->{'document_srl'});
${'document_srl39_argument'}->checkFilter('number');
${'document_srl39_argument'}->checkNotNull();
if(!${'document_srl39_argument'}->isValid()) return ${'document_srl39_argument'}->getErrorMessage();
if(${'document_srl39_argument'} !== null) ${'document_srl39_argument'}->setColumnType('number');

${'var_idx40_argument'} = new Argument('var_idx', $args->{'var_idx'});
${'var_idx40_argument'}->checkFilter('number');
${'var_idx40_argument'}->checkNotNull();
if(!${'var_idx40_argument'}->isValid()) return ${'var_idx40_argument'}->getErrorMessage();
if(${'var_idx40_argument'} !== null) ${'var_idx40_argument'}->setColumnType('number');

${'value41_argument'} = new Argument('value', $args->{'value'});
${'value41_argument'}->checkNotNull();
if(!${'value41_argument'}->isValid()) return ${'value41_argument'}->getErrorMessage();
if(${'value41_argument'} !== null) ${'value41_argument'}->setColumnType('bigtext');
if(isset($args->lang_code)) {
${'lang_code42_argument'} = new Argument('lang_code', $args->{'lang_code'});
if(!${'lang_code42_argument'}->isValid()) return ${'lang_code42_argument'}->getErrorMessage();
} else
${'lang_code42_argument'} = NULL;if(${'lang_code42_argument'} !== null) ${'lang_code42_argument'}->setColumnType('varchar');

${'eid43_argument'} = new Argument('eid', $args->{'eid'});
${'eid43_argument'}->checkNotNull();
if(!${'eid43_argument'}->isValid()) return ${'eid43_argument'}->getErrorMessage();
if(${'eid43_argument'} !== null) ${'eid43_argument'}->setColumnType('varchar');

$query->setColumns(array(
new InsertExpression('`module_srl`', ${'module_srl38_argument'})
,new InsertExpression('`document_srl`', ${'document_srl39_argument'})
,new InsertExpression('`var_idx`', ${'var_idx40_argument'})
,new InsertExpression('`value`', ${'value41_argument'})
,new InsertExpression('`lang_code`', ${'lang_code42_argument'})
,new InsertExpression('`eid`', ${'eid43_argument'})
));
$query->setTables(array(
new Table('`xe_document_extra_vars`', '`document_extra_vars`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>