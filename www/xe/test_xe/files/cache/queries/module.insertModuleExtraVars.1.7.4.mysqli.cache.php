<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertModuleExtraVars");
$query->setAction("insert");
$query->setPriority("");

${'module_srl29_argument'} = new Argument('module_srl', $args->{'module_srl'});
${'module_srl29_argument'}->checkFilter('number');
${'module_srl29_argument'}->checkNotNull();
if(!${'module_srl29_argument'}->isValid()) return ${'module_srl29_argument'}->getErrorMessage();
if(${'module_srl29_argument'} !== null) ${'module_srl29_argument'}->setColumnType('number');

${'name30_argument'} = new Argument('name', $args->{'name'});
${'name30_argument'}->checkNotNull();
if(!${'name30_argument'}->isValid()) return ${'name30_argument'}->getErrorMessage();
if(${'name30_argument'} !== null) ${'name30_argument'}->setColumnType('varchar');

${'value31_argument'} = new Argument('value', $args->{'value'});
${'value31_argument'}->checkNotNull();
if(!${'value31_argument'}->isValid()) return ${'value31_argument'}->getErrorMessage();
if(${'value31_argument'} !== null) ${'value31_argument'}->setColumnType('text');

$query->setColumns(array(
new InsertExpression('`module_srl`', ${'module_srl29_argument'})
,new InsertExpression('`name`', ${'name30_argument'})
,new InsertExpression('`value`', ${'value31_argument'})
));
$query->setTables(array(
new Table('`xe_module_extra_vars`', '`module_extra_vars`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>