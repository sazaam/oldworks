<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertLog");
$query->setAction("insert");
$query->setPriority("");

${'log_srl23_argument'} = new Argument('log_srl', $args->{'log_srl'});
$db = DB::getInstance(); $sequence = $db->getNextSequence(); ${'log_srl23_argument'}->ensureDefaultValue($sequence);
if(!${'log_srl23_argument'}->isValid()) return ${'log_srl23_argument'}->getErrorMessage();
if(${'log_srl23_argument'} !== null) ${'log_srl23_argument'}->setColumnType('number');
if(isset($args->module_srl)) {
${'module_srl24_argument'} = new Argument('module_srl', $args->{'module_srl'});
if(!${'module_srl24_argument'}->isValid()) return ${'module_srl24_argument'}->getErrorMessage();
} else
${'module_srl24_argument'} = NULL;if(${'module_srl24_argument'} !== null) ${'module_srl24_argument'}->setColumnType('number');
if(isset($args->document_srl)) {
${'document_srl25_argument'} = new Argument('document_srl', $args->{'document_srl'});
if(!${'document_srl25_argument'}->isValid()) return ${'document_srl25_argument'}->getErrorMessage();
} else
${'document_srl25_argument'} = NULL;if(${'document_srl25_argument'} !== null) ${'document_srl25_argument'}->setColumnType('number');
if(isset($args->title)) {
${'title26_argument'} = new Argument('title', $args->{'title'});
if(!${'title26_argument'}->isValid()) return ${'title26_argument'}->getErrorMessage();
} else
${'title26_argument'} = NULL;if(${'title26_argument'} !== null) ${'title26_argument'}->setColumnType('varchar');
if(isset($args->summary)) {
${'summary27_argument'} = new Argument('summary', $args->{'summary'});
if(!${'summary27_argument'}->isValid()) return ${'summary27_argument'}->getErrorMessage();
} else
${'summary27_argument'} = NULL;if(${'summary27_argument'} !== null) ${'summary27_argument'}->setColumnType('varchar');

${'regdate28_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate28_argument'}->ensureDefaultValue(date("YmdHis"));
${'regdate28_argument'}->checkNotNull();
if(!${'regdate28_argument'}->isValid()) return ${'regdate28_argument'}->getErrorMessage();
if(${'regdate28_argument'} !== null) ${'regdate28_argument'}->setColumnType('date');

$query->setColumns(array(
new InsertExpression('`log_srl`', ${'log_srl23_argument'})
,new InsertExpression('`module_srl`', ${'module_srl24_argument'})
,new InsertExpression('`document_srl`', ${'document_srl25_argument'})
,new InsertExpression('`title`', ${'title26_argument'})
,new InsertExpression('`summary`', ${'summary27_argument'})
,new InsertExpression('`regdate`', ${'regdate28_argument'})
));
$query->setTables(array(
new Table('`xe_syndication_logs`', '`syndication_logs`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>