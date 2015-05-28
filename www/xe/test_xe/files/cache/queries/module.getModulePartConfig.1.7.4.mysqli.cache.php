<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getModulePartConfig");
$query->setAction("select");
$query->setPriority("");

${'module17_argument'} = new ConditionArgument('module', $args->module, 'equal');
${'module17_argument'}->checkNotNull();
${'module17_argument'}->createConditionValue();
if(!${'module17_argument'}->isValid()) return ${'module17_argument'}->getErrorMessage();
if(${'module17_argument'} !== null) ${'module17_argument'}->setColumnType('varchar');

${'module_srl18_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'equal');
${'module_srl18_argument'}->checkNotNull();
${'module_srl18_argument'}->createConditionValue();
if(!${'module_srl18_argument'}->isValid()) return ${'module_srl18_argument'}->getErrorMessage();
if(${'module_srl18_argument'} !== null) ${'module_srl18_argument'}->setColumnType('number');

$query->setColumns(array(
new SelectExpression('`config`')
));
$query->setTables(array(
new Table('`xe_module_part_config`', '`module_part_config`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`module`',$module17_argument,"equal")
,new ConditionWithArgument('`module_srl`',$module_srl18_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>