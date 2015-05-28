<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getSavedDocument");
$query->setAction("select");
$query->setPriority("");
if(isset($args->module_srl)) {
${'module_srl44_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'equal');
${'module_srl44_argument'}->createConditionValue();
if(!${'module_srl44_argument'}->isValid()) return ${'module_srl44_argument'}->getErrorMessage();
} else
${'module_srl44_argument'} = NULL;if(${'module_srl44_argument'} !== null) ${'module_srl44_argument'}->setColumnType('number');
if(isset($args->member_srl)) {
${'member_srl45_argument'} = new ConditionArgument('member_srl', $args->member_srl, 'equal');
${'member_srl45_argument'}->createConditionValue();
if(!${'member_srl45_argument'}->isValid()) return ${'member_srl45_argument'}->getErrorMessage();
} else
${'member_srl45_argument'} = NULL;if(${'member_srl45_argument'} !== null) ${'member_srl45_argument'}->setColumnType('number');
if(isset($args->ipaddress)) {
${'ipaddress46_argument'} = new ConditionArgument('ipaddress', $args->ipaddress, 'equal');
${'ipaddress46_argument'}->createConditionValue();
if(!${'ipaddress46_argument'}->isValid()) return ${'ipaddress46_argument'}->getErrorMessage();
} else
${'ipaddress46_argument'} = NULL;if(${'ipaddress46_argument'} !== null) ${'ipaddress46_argument'}->setColumnType('varchar');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_editor_autosave`', '`editor_autosave`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`module_srl`',$module_srl44_argument,"equal")
,new ConditionWithArgument('`member_srl`',$member_srl45_argument,"equal", 'and')
,new ConditionWithArgument('`ipaddress`',$ipaddress46_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>