<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getMenuItemByUrl");
$query->setAction("select");
$query->setPriority("");

${'url26_argument'} = new ConditionArgument('url', $args->url, 'equal');
${'url26_argument'}->checkNotNull();
${'url26_argument'}->createConditionValue();
if(!${'url26_argument'}->isValid()) return ${'url26_argument'}->getErrorMessage();
if(${'url26_argument'} !== null) ${'url26_argument'}->setColumnType('varchar');
if(isset($args->is_shortcut)) {
${'is_shortcut27_argument'} = new ConditionArgument('is_shortcut', $args->is_shortcut, 'equal');
${'is_shortcut27_argument'}->createConditionValue();
if(!${'is_shortcut27_argument'}->isValid()) return ${'is_shortcut27_argument'}->getErrorMessage();
} else
${'is_shortcut27_argument'} = NULL;if(${'is_shortcut27_argument'} !== null) ${'is_shortcut27_argument'}->setColumnType('char');

${'site_srl28_argument'} = new ConditionArgument('site_srl', $args->site_srl, 'equal');
${'site_srl28_argument'}->checkNotNull();
${'site_srl28_argument'}->createConditionValue();
if(!${'site_srl28_argument'}->isValid()) return ${'site_srl28_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_menu_item`', '`MI`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`MI`.`url`',$url26_argument,"equal")
,new ConditionWithArgument('`MI`.`is_shortcut`',$is_shortcut27_argument,"equal", 'and')
,new ConditionSubquery('`MI`.`menu_srl`',new Subquery('`getSiteSrl`', array(
new SelectExpression('`menu_srl`')
), 
array(
new Table('`xe_menu`', '`M`')
),
array(
new ConditionGroup(array(
new ConditionWithArgument('`M`.`site_srl`',$site_srl28_argument,"equal")))
),
array(),
array(),
null
),"in", 'and')))
));
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>