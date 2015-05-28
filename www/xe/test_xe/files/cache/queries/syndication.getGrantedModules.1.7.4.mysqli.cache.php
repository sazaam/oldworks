<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getGrantedModules");
$query->setAction("select");
$query->setPriority("");

$query->setColumns(array(
new SelectExpression('`module_srl`')
));
$query->setTables(array(
new Table('`xe_module_grants`', '`module_grants`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithoutArgument('`name`',"'access','view','list'","in")))
,new ConditionGroup(array(
new ConditionWithoutArgument('`group_srl`','1',"more")
,new ConditionWithoutArgument('`group_srl`','-1',"equal", 'or')
,new ConditionWithoutArgument('`group_srl`','-2',"equal", 'or')),'and')
));
$query->setGroups(array(
'`module_srl`' ));
$query->setOrder(array());
$query->setLimit();
return $query; ?>