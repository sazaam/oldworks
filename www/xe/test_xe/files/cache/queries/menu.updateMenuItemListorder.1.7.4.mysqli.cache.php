<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateMenuItemListorder");
$query->setAction("update");
$query->setPriority("");

${'listorder4_argument'} = new Argument('listorder', NULL);
${'listorder4_argument'}->setColumnOperation('-');
${'listorder4_argument'}->ensureDefaultValue(1);
if(!${'listorder4_argument'}->isValid()) return ${'listorder4_argument'}->getErrorMessage();
if(${'listorder4_argument'} !== null) ${'listorder4_argument'}->setColumnType('number');

${'menu_srl5_argument'} = new ConditionArgument('menu_srl', $args->menu_srl, 'equal');
${'menu_srl5_argument'}->checkFilter('number');
${'menu_srl5_argument'}->checkNotNull();
${'menu_srl5_argument'}->createConditionValue();
if(!${'menu_srl5_argument'}->isValid()) return ${'menu_srl5_argument'}->getErrorMessage();
if(${'menu_srl5_argument'} !== null) ${'menu_srl5_argument'}->setColumnType('number');

${'parent_srl6_argument'} = new ConditionArgument('parent_srl', $args->parent_srl, 'equal');
${'parent_srl6_argument'}->checkFilter('number');
${'parent_srl6_argument'}->checkNotNull();
${'parent_srl6_argument'}->createConditionValue();
if(!${'parent_srl6_argument'}->isValid()) return ${'parent_srl6_argument'}->getErrorMessage();
if(${'parent_srl6_argument'} !== null) ${'parent_srl6_argument'}->setColumnType('number');

${'listorder7_argument'} = new ConditionArgument('listorder', $args->listorder, 'less');
${'listorder7_argument'}->checkFilter('number');
${'listorder7_argument'}->checkNotNull();
${'listorder7_argument'}->createConditionValue();
if(!${'listorder7_argument'}->isValid()) return ${'listorder7_argument'}->getErrorMessage();
if(${'listorder7_argument'} !== null) ${'listorder7_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`listorder`', ${'listorder4_argument'})
));
$query->setTables(array(
new Table('`xe_menu_item`', '`menu_item`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`menu_srl`',$menu_srl5_argument,"equal")
,new ConditionWithArgument('`parent_srl`',$parent_srl6_argument,"equal", 'and')
,new ConditionWithArgument('`listorder`',$listorder7_argument,"less", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>