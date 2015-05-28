<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getMenuByTitle");
$query->setAction("select");
$query->setPriority("");

${'title12_argument'} = new ConditionArgument('title', $args->title, 'in');
${'title12_argument'}->checkNotNull();
${'title12_argument'}->createConditionValue();
if(!${'title12_argument'}->isValid()) return ${'title12_argument'}->getErrorMessage();
if(${'title12_argument'} !== null) ${'title12_argument'}->setColumnType('varchar');

${'site_srl13_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl13_argument'}->ensureDefaultValue('0');
${'site_srl13_argument'}->createConditionValue();
if(!${'site_srl13_argument'}->isValid()) return ${'site_srl13_argument'}->getErrorMessage();
if(${'site_srl13_argument'} !== null) ${'site_srl13_argument'}->setColumnType('number');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_menu`', '`menu`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`title`',$title12_argument,"in")
,new ConditionWithArgument('`site_srl`',$site_srl13_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>