<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("isExistsModuleName");
$query->setAction("select");
$query->setPriority("");

${'site_srl2_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl2_argument'}->ensureDefaultValue('0');
${'site_srl2_argument'}->checkNotNull();
${'site_srl2_argument'}->createConditionValue();
if(!${'site_srl2_argument'}->isValid()) return ${'site_srl2_argument'}->getErrorMessage();
if(${'site_srl2_argument'} !== null) ${'site_srl2_argument'}->setColumnType('number');

${'mid3_argument'} = new ConditionArgument('mid', $args->mid, 'equal');
${'mid3_argument'}->checkNotNull();
${'mid3_argument'}->createConditionValue();
if(!${'mid3_argument'}->isValid()) return ${'mid3_argument'}->getErrorMessage();
if(${'mid3_argument'} !== null) ${'mid3_argument'}->setColumnType('varchar');

${'module_srl4_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'notequal');
${'module_srl4_argument'}->ensureDefaultValue('0');
${'module_srl4_argument'}->checkNotNull();
${'module_srl4_argument'}->createConditionValue();
if(!${'module_srl4_argument'}->isValid()) return ${'module_srl4_argument'}->getErrorMessage();
if(${'module_srl4_argument'} !== null) ${'module_srl4_argument'}->setColumnType('number');

$query->setColumns(array(
new SelectExpression('count(*)', '`count`')
));
$query->setTables(array(
new Table('`xe_modules`', '`modules`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl2_argument,"equal")
,new ConditionWithArgument('`mid`',$mid3_argument,"equal", 'and')
,new ConditionWithArgument('`module_srl`',$module_srl4_argument,"notequal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>