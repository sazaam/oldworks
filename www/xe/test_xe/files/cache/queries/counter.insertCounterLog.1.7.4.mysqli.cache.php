<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertCounterLog");
$query->setAction("insert");
$query->setPriority("");

${'site_srl4_argument'} = new Argument('site_srl', $args->{'site_srl'});
${'site_srl4_argument'}->ensureDefaultValue('0');
${'site_srl4_argument'}->checkNotNull();
if(!${'site_srl4_argument'}->isValid()) return ${'site_srl4_argument'}->getErrorMessage();
if(${'site_srl4_argument'} !== null) ${'site_srl4_argument'}->setColumnType('number');

${'regdate5_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate5_argument'}->ensureDefaultValue(date("YmdHis"));
${'regdate5_argument'}->checkNotNull();
if(!${'regdate5_argument'}->isValid()) return ${'regdate5_argument'}->getErrorMessage();
if(${'regdate5_argument'} !== null) ${'regdate5_argument'}->setColumnType('date');

${'ipaddress6_argument'} = new Argument('ipaddress', $args->{'ipaddress'});
${'ipaddress6_argument'}->ensureDefaultValue($_SERVER['REMOTE_ADDR']);
${'ipaddress6_argument'}->checkNotNull();
if(!${'ipaddress6_argument'}->isValid()) return ${'ipaddress6_argument'}->getErrorMessage();
if(${'ipaddress6_argument'} !== null) ${'ipaddress6_argument'}->setColumnType('varchar');
if(isset($args->user_agent)) {
${'user_agent7_argument'} = new Argument('user_agent', $args->{'user_agent'});
if(!${'user_agent7_argument'}->isValid()) return ${'user_agent7_argument'}->getErrorMessage();
} else
${'user_agent7_argument'} = NULL;if(${'user_agent7_argument'} !== null) ${'user_agent7_argument'}->setColumnType('varchar');

$query->setColumns(array(
new InsertExpression('`site_srl`', ${'site_srl4_argument'})
,new InsertExpression('`regdate`', ${'regdate5_argument'})
,new InsertExpression('`ipaddress`', ${'ipaddress6_argument'})
,new InsertExpression('`user_agent`', ${'user_agent7_argument'})
));
$query->setTables(array(
new Table('`xe_counter_log`', '`counter_log`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>