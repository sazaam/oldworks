<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getNewestCommentList");
$query->setAction("select");
$query->setPriority("");
if(isset($args->status)) {
${'status40_argument'} = new ConditionArgument('status', $args->status, 'equal');
${'status40_argument'}->createConditionValue();
if(!${'status40_argument'}->isValid()) return ${'status40_argument'}->getErrorMessage();
} else
${'status40_argument'} = NULL;if(${'status40_argument'} !== null) ${'status40_argument'}->setColumnType('number');
if(isset($args->module_srl)) {
${'module_srl41_argument'} = new ConditionArgument('module_srl', $args->module_srl, 'in');
${'module_srl41_argument'}->checkFilter('number');
${'module_srl41_argument'}->createConditionValue();
if(!${'module_srl41_argument'}->isValid()) return ${'module_srl41_argument'}->getErrorMessage();
} else
${'module_srl41_argument'} = NULL;if(${'module_srl41_argument'} !== null) ${'module_srl41_argument'}->setColumnType('number');

${'list_count43_argument'} = new Argument('list_count', $args->{'list_count'});
${'list_count43_argument'}->ensureDefaultValue('20');
if(!${'list_count43_argument'}->isValid()) return ${'list_count43_argument'}->getErrorMessage();

${'sort_index42_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index42_argument'}->ensureDefaultValue('list_order');
if(!${'sort_index42_argument'}->isValid()) return ${'sort_index42_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_comments`', '`comments`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`status`',$status40_argument,"equal", 'and')
,new ConditionWithArgument('`module_srl`',$module_srl41_argument,"in", 'and')))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index42_argument'}, "asc")
));
$query->setLimit(new Limit(${'list_count43_argument'}));
return $query; ?>