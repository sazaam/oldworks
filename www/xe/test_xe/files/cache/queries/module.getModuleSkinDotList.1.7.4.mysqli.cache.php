<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getModuleSkinDotList");
$query->setAction("select");
$query->setPriority("");

${'skin15_argument'} = new ConditionArgument('skin', $args->skin, 'like');
${'skin15_argument'}->ensureDefaultValue('.');
${'skin15_argument'}->createConditionValue();
if(!${'skin15_argument'}->isValid()) return ${'skin15_argument'}->getErrorMessage();
if(${'skin15_argument'} !== null) ${'skin15_argument'}->setColumnType('varchar');

$query->setColumns(array(
new SelectExpression('`module`')
,new SelectExpression('`skin`')
));
$query->setTables(array(
new Table('`xe_modules`', '`modules`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`skin`',$skin15_argument,"like")))
));
$query->setGroups(array(
'`skin`' ));
$query->setOrder(array());
$query->setLimit();
return $query; ?>