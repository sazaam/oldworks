<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getLang");
$query->setAction("select");
$query->setPriority("");

${'site_srl24_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl24_argument'}->checkFilter('number');
${'site_srl24_argument'}->checkNotNull();
${'site_srl24_argument'}->createConditionValue();
if(!${'site_srl24_argument'}->isValid()) return ${'site_srl24_argument'}->getErrorMessage();
if(${'site_srl24_argument'} !== null) ${'site_srl24_argument'}->setColumnType('number');
if(isset($args->name)) {
${'name25_argument'} = new ConditionArgument('name', $args->name, 'equal');
${'name25_argument'}->createConditionValue();
if(!${'name25_argument'}->isValid()) return ${'name25_argument'}->getErrorMessage();
} else
${'name25_argument'} = NULL;if(${'name25_argument'} !== null) ${'name25_argument'}->setColumnType('varchar');

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_lang`', '`lang`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`site_srl`',$site_srl24_argument,"equal")
,new ConditionWithArgument('`name`',$name25_argument,"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>