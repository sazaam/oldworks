<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getTrigger");
$query->setAction("select");
$query->setPriority("");
if(isset($args->trigger_name)) {
${'trigger_name3_argument'} = new ConditionArgument('trigger_name', $args->trigger_name, 'equal');
${'trigger_name3_argument'}->createConditionValue();
if(!${'trigger_name3_argument'}->isValid()) return ${'trigger_name3_argument'}->getErrorMessage();
} else
${'trigger_name3_argument'} = NULL;if(${'trigger_name3_argument'} !== null) ${'trigger_name3_argument'}->setColumnType('varchar');
if(isset($args->module)) {
${'module4_argument'} = new ConditionArgument('module', $args->module, 'equal');
${'module4_argument'}->createConditionValue();
if(!${'module4_argument'}->isValid()) return ${'module4_argument'}->getErrorMessage();
} else
${'module4_argument'} = NULL;if(${'module4_argument'} !== null) ${'module4_argument'}->setColumnType('varchar');
if(isset($args->type)) {
${'type5_argument'} = new ConditionArgument('type', $args->type, 'equal');
${'type5_argument'}->createConditionValue();
if(!${'type5_argument'}->isValid()) return ${'type5_argument'}->getErrorMessage();
} else
${'type5_argument'} = NULL;if(${'type5_argument'} !== null) ${'type5_argument'}->setColumnType('varchar');
if(isset($args->called_method)) {
${'called_method6_argument'} = new ConditionArgument('called_method', $args->called_method, 'equal');
${'called_method6_argument'}->createConditionValue();
if(!${'called_method6_argument'}->isValid()) return ${'called_method6_argument'}->getErrorMessage();
} else
${'called_method6_argument'} = NULL;if(${'called_method6_argument'} !== null) ${'called_method6_argument'}->setColumnType('varchar');
if(isset($args->called_position)) {
${'called_position7_argument'} = new ConditionArgument('called_position', $args->called_position, 'equal');
${'called_position7_argument'}->createConditionValue();
if(!${'called_position7_argument'}->isValid()) return ${'called_position7_argument'}->getErrorMessage();
} else
${'called_position7_argument'} = NULL;if(${'called_position7_argument'} !== null) ${'called_position7_argument'}->setColumnType('varchar');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_module_trigger`', '`module_trigger`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`trigger_name`',$trigger_name3_argument,"equal")
,new ConditionWithArgument('`module`',$module4_argument,"equal", 'and')
,new ConditionWithArgument('`type`',$type5_argument,"equal", 'and')
,new ConditionWithArgument('`called_method`',$called_method6_argument,"equal", 'and')
,new ConditionWithArgument('`called_position`',$called_position7_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>