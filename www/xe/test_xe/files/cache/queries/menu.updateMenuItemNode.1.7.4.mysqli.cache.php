<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("updateMenuItemNode");
$query->setAction("update");
$query->setPriority("");
if(isset($args->menu_srl)) {
${'menu_srl8_argument'} = new Argument('menu_srl', $args->{'menu_srl'});
if(!${'menu_srl8_argument'}->isValid()) return ${'menu_srl8_argument'}->getErrorMessage();
} else
${'menu_srl8_argument'} = NULL;if(${'menu_srl8_argument'} !== null) ${'menu_srl8_argument'}->setColumnType('number');
if(isset($args->parent_srl)) {
${'parent_srl9_argument'} = new Argument('parent_srl', $args->{'parent_srl'});
if(!${'parent_srl9_argument'}->isValid()) return ${'parent_srl9_argument'}->getErrorMessage();
} else
${'parent_srl9_argument'} = NULL;if(${'parent_srl9_argument'} !== null) ${'parent_srl9_argument'}->setColumnType('number');
if(isset($args->listorder)) {
${'listorder10_argument'} = new Argument('listorder', $args->{'listorder'});
if(!${'listorder10_argument'}->isValid()) return ${'listorder10_argument'}->getErrorMessage();
} else
${'listorder10_argument'} = NULL;if(${'listorder10_argument'} !== null) ${'listorder10_argument'}->setColumnType('number');

${'menu_item_srl11_argument'} = new ConditionArgument('menu_item_srl', $args->menu_item_srl, 'equal');
${'menu_item_srl11_argument'}->checkFilter('number');
${'menu_item_srl11_argument'}->checkNotNull();
${'menu_item_srl11_argument'}->createConditionValue();
if(!${'menu_item_srl11_argument'}->isValid()) return ${'menu_item_srl11_argument'}->getErrorMessage();
if(${'menu_item_srl11_argument'} !== null) ${'menu_item_srl11_argument'}->setColumnType('number');

$query->setColumns(array(
new UpdateExpression('`menu_srl`', ${'menu_srl8_argument'})
,new UpdateExpression('`parent_srl`', ${'parent_srl9_argument'})
,new UpdateExpression('`listorder`', ${'listorder10_argument'})
));
$query->setTables(array(
new Table('`xe_menu_item`', '`menu_item`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`menu_item_srl`',$menu_item_srl11_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>