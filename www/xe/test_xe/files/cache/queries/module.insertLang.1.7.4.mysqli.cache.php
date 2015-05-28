<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertLang");
$query->setAction("insert");
$query->setPriority("");

${'site_srl1_argument'} = new Argument('site_srl', $args->{'site_srl'});
${'site_srl1_argument'}->checkNotNull();
if(!${'site_srl1_argument'}->isValid()) return ${'site_srl1_argument'}->getErrorMessage();
if(${'site_srl1_argument'} !== null) ${'site_srl1_argument'}->setColumnType('number');

${'name2_argument'} = new Argument('name', $args->{'name'});
${'name2_argument'}->checkNotNull();
if(!${'name2_argument'}->isValid()) return ${'name2_argument'}->getErrorMessage();
if(${'name2_argument'} !== null) ${'name2_argument'}->setColumnType('varchar');

${'lang_code3_argument'} = new Argument('lang_code', $args->{'lang_code'});
${'lang_code3_argument'}->checkNotNull();
if(!${'lang_code3_argument'}->isValid()) return ${'lang_code3_argument'}->getErrorMessage();
if(${'lang_code3_argument'} !== null) ${'lang_code3_argument'}->setColumnType('varchar');

${'value4_argument'} = new Argument('value', $args->{'value'});
${'value4_argument'}->checkNotNull();
if(!${'value4_argument'}->isValid()) return ${'value4_argument'}->getErrorMessage();
if(${'value4_argument'} !== null) ${'value4_argument'}->setColumnType('text');

$query->setColumns(array(
new InsertExpression('`site_srl`', ${'site_srl1_argument'})
,new InsertExpression('`name`', ${'name2_argument'})
,new InsertExpression('`lang_code`', ${'lang_code3_argument'})
,new InsertExpression('`value`', ${'value4_argument'})
));
$query->setTables(array(
new Table('`xe_lang`', '`lang`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>