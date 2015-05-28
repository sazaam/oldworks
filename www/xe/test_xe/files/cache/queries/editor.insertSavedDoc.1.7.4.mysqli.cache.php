<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("insertSavedDoc");
$query->setAction("insert");
$query->setPriority("");
if(isset($args->module_srl)) {
${'module_srl1_argument'} = new Argument('module_srl', $args->{'module_srl'});
if(!${'module_srl1_argument'}->isValid()) return ${'module_srl1_argument'}->getErrorMessage();
} else
${'module_srl1_argument'} = NULL;if(${'module_srl1_argument'} !== null) ${'module_srl1_argument'}->setColumnType('number');
if(isset($args->member_srl)) {
${'member_srl2_argument'} = new Argument('member_srl', $args->{'member_srl'});
if(!${'member_srl2_argument'}->isValid()) return ${'member_srl2_argument'}->getErrorMessage();
} else
${'member_srl2_argument'} = NULL;if(${'member_srl2_argument'} !== null) ${'member_srl2_argument'}->setColumnType('number');
if(isset($args->ipaddress)) {
${'ipaddress3_argument'} = new Argument('ipaddress', $args->{'ipaddress'});
if(!${'ipaddress3_argument'}->isValid()) return ${'ipaddress3_argument'}->getErrorMessage();
} else
${'ipaddress3_argument'} = NULL;if(${'ipaddress3_argument'} !== null) ${'ipaddress3_argument'}->setColumnType('varchar');

${'document_srl4_argument'} = new Argument('document_srl', $args->{'document_srl'});
${'document_srl4_argument'}->ensureDefaultValue('0');
if(!${'document_srl4_argument'}->isValid()) return ${'document_srl4_argument'}->getErrorMessage();
if(${'document_srl4_argument'} !== null) ${'document_srl4_argument'}->setColumnType('number');
if(isset($args->title)) {
${'title5_argument'} = new Argument('title', $args->{'title'});
if(!${'title5_argument'}->isValid()) return ${'title5_argument'}->getErrorMessage();
} else
${'title5_argument'} = NULL;if(${'title5_argument'} !== null) ${'title5_argument'}->setColumnType('varchar');
if(isset($args->content)) {
${'content6_argument'} = new Argument('content', $args->{'content'});
if(!${'content6_argument'}->isValid()) return ${'content6_argument'}->getErrorMessage();
} else
${'content6_argument'} = NULL;if(${'content6_argument'} !== null) ${'content6_argument'}->setColumnType('bigtext');

${'regdate7_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate7_argument'}->ensureDefaultValue(date("YmdHis"));
if(!${'regdate7_argument'}->isValid()) return ${'regdate7_argument'}->getErrorMessage();
if(${'regdate7_argument'} !== null) ${'regdate7_argument'}->setColumnType('date');

$query->setColumns(array(
new InsertExpression('`module_srl`', ${'module_srl1_argument'})
,new InsertExpression('`member_srl`', ${'member_srl2_argument'})
,new InsertExpression('`ipaddress`', ${'ipaddress3_argument'})
,new InsertExpression('`document_srl`', ${'document_srl4_argument'})
,new InsertExpression('`title`', ${'title5_argument'})
,new InsertExpression('`content`', ${'content6_argument'})
,new InsertExpression('`regdate`', ${'regdate7_argument'})
));
$query->setTables(array(
new Table('`xe_editor_autosave`', '`editor_autosave`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>