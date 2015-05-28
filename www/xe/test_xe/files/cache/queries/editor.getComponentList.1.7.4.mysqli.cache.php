<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getComponentList");
$query->setAction("select");
$query->setPriority("");
if(isset($args->enabled)) {
${'enabled5_argument'} = new ConditionArgument('enabled', $args->enabled, 'equal');
${'enabled5_argument'}->createConditionValue();
if(!${'enabled5_argument'}->isValid()) return ${'enabled5_argument'}->getErrorMessage();
} else
${'enabled5_argument'} = NULL;if(${'enabled5_argument'} !== null) ${'enabled5_argument'}->setColumnType('char');

${'sort_index6_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index6_argument'}->ensureDefaultValue('list_order');
if(!${'sort_index6_argument'}->isValid()) return ${'sort_index6_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_editor_components`', '`editor_components`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`enabled`',$enabled5_argument,"equal")))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index6_argument'}, "asc")
));
$query->setLimit();
return $query; ?>