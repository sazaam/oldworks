<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("deleteMenuItem");
$query->setAction("delete");
$query->setPriority("");

${'menu_item_srl2_argument'} = new ConditionArgument('menu_item_srl', $args->menu_item_srl, 'equal');
${'menu_item_srl2_argument'}->checkFilter('number');
${'menu_item_srl2_argument'}->checkNotNull();
${'menu_item_srl2_argument'}->createConditionValue();
if(!${'menu_item_srl2_argument'}->isValid()) return ${'menu_item_srl2_argument'}->getErrorMessage();
if(${'menu_item_srl2_argument'} !== null) ${'menu_item_srl2_argument'}->setColumnType('number');

$query->setTables(array(
new Table('`xe_menu_item`', '`menu_item`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`menu_item_srl`',$menu_item_srl2_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>