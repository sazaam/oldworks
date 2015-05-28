<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertMenuItem");
$query->setAction("insert");
$query->setPriority("");

${'menu_item_srl32_argument'} = new Argument('menu_item_srl', $args->{'menu_item_srl'});
${'menu_item_srl32_argument'}->checkFilter('number');
${'menu_item_srl32_argument'}->checkNotNull();
if(!${'menu_item_srl32_argument'}->isValid()) return ${'menu_item_srl32_argument'}->getErrorMessage();
if(${'menu_item_srl32_argument'} !== null) ${'menu_item_srl32_argument'}->setColumnType('number');

${'parent_srl33_argument'} = new Argument('parent_srl', $args->{'parent_srl'});
${'parent_srl33_argument'}->checkFilter('number');
${'parent_srl33_argument'}->ensureDefaultValue('0');
if(!${'parent_srl33_argument'}->isValid()) return ${'parent_srl33_argument'}->getErrorMessage();
if(${'parent_srl33_argument'} !== null) ${'parent_srl33_argument'}->setColumnType('number');

${'menu_srl34_argument'} = new Argument('menu_srl', $args->{'menu_srl'});
${'menu_srl34_argument'}->checkFilter('number');
${'menu_srl34_argument'}->checkNotNull();
if(!${'menu_srl34_argument'}->isValid()) return ${'menu_srl34_argument'}->getErrorMessage();
if(${'menu_srl34_argument'} !== null) ${'menu_srl34_argument'}->setColumnType('number');

${'name35_argument'} = new Argument('name', $args->{'name'});
${'name35_argument'}->checkNotNull();
if(!${'name35_argument'}->isValid()) return ${'name35_argument'}->getErrorMessage();
if(${'name35_argument'} !== null) ${'name35_argument'}->setColumnType('text');
if(isset($args->url)) {
${'url36_argument'} = new Argument('url', $args->{'url'});
if(!${'url36_argument'}->isValid()) return ${'url36_argument'}->getErrorMessage();
} else
${'url36_argument'} = NULL;if(${'url36_argument'} !== null) ${'url36_argument'}->setColumnType('varchar');

${'is_shortcut37_argument'} = new Argument('is_shortcut', $args->{'is_shortcut'});
${'is_shortcut37_argument'}->ensureDefaultValue('N');
${'is_shortcut37_argument'}->checkNotNull();
if(!${'is_shortcut37_argument'}->isValid()) return ${'is_shortcut37_argument'}->getErrorMessage();
if(${'is_shortcut37_argument'} !== null) ${'is_shortcut37_argument'}->setColumnType('char');
if(isset($args->open_window)) {
${'open_window38_argument'} = new Argument('open_window', $args->{'open_window'});
if(!${'open_window38_argument'}->isValid()) return ${'open_window38_argument'}->getErrorMessage();
} else
${'open_window38_argument'} = NULL;if(${'open_window38_argument'} !== null) ${'open_window38_argument'}->setColumnType('char');
if(isset($args->expand)) {
${'expand39_argument'} = new Argument('expand', $args->{'expand'});
if(!${'expand39_argument'}->isValid()) return ${'expand39_argument'}->getErrorMessage();
} else
${'expand39_argument'} = NULL;if(${'expand39_argument'} !== null) ${'expand39_argument'}->setColumnType('char');
if(isset($args->normal_btn)) {
${'normal_btn40_argument'} = new Argument('normal_btn', $args->{'normal_btn'});
if(!${'normal_btn40_argument'}->isValid()) return ${'normal_btn40_argument'}->getErrorMessage();
} else
${'normal_btn40_argument'} = NULL;if(${'normal_btn40_argument'} !== null) ${'normal_btn40_argument'}->setColumnType('varchar');
if(isset($args->hover_btn)) {
${'hover_btn41_argument'} = new Argument('hover_btn', $args->{'hover_btn'});
if(!${'hover_btn41_argument'}->isValid()) return ${'hover_btn41_argument'}->getErrorMessage();
} else
${'hover_btn41_argument'} = NULL;if(${'hover_btn41_argument'} !== null) ${'hover_btn41_argument'}->setColumnType('varchar');
if(isset($args->active_btn)) {
${'active_btn42_argument'} = new Argument('active_btn', $args->{'active_btn'});
if(!${'active_btn42_argument'}->isValid()) return ${'active_btn42_argument'}->getErrorMessage();
} else
${'active_btn42_argument'} = NULL;if(${'active_btn42_argument'} !== null) ${'active_btn42_argument'}->setColumnType('varchar');
if(isset($args->group_srls)) {
${'group_srls43_argument'} = new Argument('group_srls', $args->{'group_srls'});
if(!${'group_srls43_argument'}->isValid()) return ${'group_srls43_argument'}->getErrorMessage();
} else
${'group_srls43_argument'} = NULL;if(${'group_srls43_argument'} !== null) ${'group_srls43_argument'}->setColumnType('text');

${'listorder44_argument'} = new Argument('listorder', $args->{'listorder'});
${'listorder44_argument'}->checkNotNull();
if(!${'listorder44_argument'}->isValid()) return ${'listorder44_argument'}->getErrorMessage();
if(${'listorder44_argument'} !== null) ${'listorder44_argument'}->setColumnType('number');

${'regdate45_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate45_argument'}->ensureDefaultValue(date("YmdHis"));
if(!${'regdate45_argument'}->isValid()) return ${'regdate45_argument'}->getErrorMessage();
if(${'regdate45_argument'} !== null) ${'regdate45_argument'}->setColumnType('date');

$query->setColumns(array(
new InsertExpression('`menu_item_srl`', ${'menu_item_srl32_argument'})
,new InsertExpression('`parent_srl`', ${'parent_srl33_argument'})
,new InsertExpression('`menu_srl`', ${'menu_srl34_argument'})
,new InsertExpression('`name`', ${'name35_argument'})
,new InsertExpression('`url`', ${'url36_argument'})
,new InsertExpression('`is_shortcut`', ${'is_shortcut37_argument'})
,new InsertExpression('`open_window`', ${'open_window38_argument'})
,new InsertExpression('`expand`', ${'expand39_argument'})
,new InsertExpression('`normal_btn`', ${'normal_btn40_argument'})
,new InsertExpression('`hover_btn`', ${'hover_btn41_argument'})
,new InsertExpression('`active_btn`', ${'active_btn42_argument'})
,new InsertExpression('`group_srls`', ${'group_srls43_argument'})
,new InsertExpression('`listorder`', ${'listorder44_argument'})
,new InsertExpression('`regdate`', ${'regdate45_argument'})
));
$query->setTables(array(
new Table('`xe_menu_item`', '`menu_item`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>