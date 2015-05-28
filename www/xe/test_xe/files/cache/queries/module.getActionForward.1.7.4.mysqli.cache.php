<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getActionForward");
$query->setAction("select");
$query->setPriority("");
if(isset($args->act)) {
${'act16_argument'} = new ConditionArgument('act', $args->act, 'equal');
${'act16_argument'}->createConditionValue();
if(!${'act16_argument'}->isValid()) return ${'act16_argument'}->getErrorMessage();
} else
${'act16_argument'} = NULL;if(${'act16_argument'} !== null) ${'act16_argument'}->setColumnType('varchar');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_action_forward`', '`action_forward`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`act`',$act16_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>