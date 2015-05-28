<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("addScrapDocument");
$query->setAction("insert");
$query->setPriority("");

${'member_srl3_argument'} = new Argument('member_srl', $args->{'member_srl'});
${'member_srl3_argument'}->checkNotNull();
if(!${'member_srl3_argument'}->isValid()) return ${'member_srl3_argument'}->getErrorMessage();
if(${'member_srl3_argument'} !== null) ${'member_srl3_argument'}->setColumnType('number');

${'document_srl4_argument'} = new Argument('document_srl', $args->{'document_srl'});
${'document_srl4_argument'}->ensureDefaultValue('0');
if(!${'document_srl4_argument'}->isValid()) return ${'document_srl4_argument'}->getErrorMessage();
if(${'document_srl4_argument'} !== null) ${'document_srl4_argument'}->setColumnType('number');
if(isset($args->title)) {
${'title5_argument'} = new Argument('title', $args->{'title'});
if(!${'title5_argument'}->isValid()) return ${'title5_argument'}->getErrorMessage();
} else
${'title5_argument'} = NULL;if(${'title5_argument'} !== null) ${'title5_argument'}->setColumnType('varchar');
if(isset($args->user_id)) {
${'user_id6_argument'} = new Argument('user_id', $args->{'user_id'});
if(!${'user_id6_argument'}->isValid()) return ${'user_id6_argument'}->getErrorMessage();
} else
${'user_id6_argument'} = NULL;if(${'user_id6_argument'} !== null) ${'user_id6_argument'}->setColumnType('varchar');
if(isset($args->user_name)) {
${'user_name7_argument'} = new Argument('user_name', $args->{'user_name'});
if(!${'user_name7_argument'}->isValid()) return ${'user_name7_argument'}->getErrorMessage();
} else
${'user_name7_argument'} = NULL;if(${'user_name7_argument'} !== null) ${'user_name7_argument'}->setColumnType('varchar');
if(isset($args->nick_name)) {
${'nick_name8_argument'} = new Argument('nick_name', $args->{'nick_name'});
if(!${'nick_name8_argument'}->isValid()) return ${'nick_name8_argument'}->getErrorMessage();
} else
${'nick_name8_argument'} = NULL;if(${'nick_name8_argument'} !== null) ${'nick_name8_argument'}->setColumnType('varchar');

${'target_member_srl9_argument'} = new Argument('target_member_srl', $args->{'target_member_srl'});
${'target_member_srl9_argument'}->ensureDefaultValue('0');
if(!${'target_member_srl9_argument'}->isValid()) return ${'target_member_srl9_argument'}->getErrorMessage();
if(${'target_member_srl9_argument'} !== null) ${'target_member_srl9_argument'}->setColumnType('number');

${'regdate10_argument'} = new Argument('regdate', $args->{'regdate'});
${'regdate10_argument'}->ensureDefaultValue(date("YmdHis"));
if(!${'regdate10_argument'}->isValid()) return ${'regdate10_argument'}->getErrorMessage();
if(${'regdate10_argument'} !== null) ${'regdate10_argument'}->setColumnType('date');

${'list_order11_argument'} = new Argument('list_order', $args->{'list_order'});
$db = DB::getInstance(); $sequence = $db->getNextSequence(); ${'list_order11_argument'}->ensureDefaultValue($sequence);
if(!${'list_order11_argument'}->isValid()) return ${'list_order11_argument'}->getErrorMessage();
if(${'list_order11_argument'} !== null) ${'list_order11_argument'}->setColumnType('number');

$query->setColumns(array(
new InsertExpression('`member_srl`', ${'member_srl3_argument'})
,new InsertExpression('`document_srl`', ${'document_srl4_argument'})
,new InsertExpression('`title`', ${'title5_argument'})
,new InsertExpression('`user_id`', ${'user_id6_argument'})
,new InsertExpression('`user_name`', ${'user_name7_argument'})
,new InsertExpression('`nick_name`', ${'nick_name8_argument'})
,new InsertExpression('`target_member_srl`', ${'target_member_srl9_argument'})
,new InsertExpression('`regdate`', ${'regdate10_argument'})
,new InsertExpression('`list_order`', ${'list_order11_argument'})
));
$query->setTables(array(
new Table('`xe_member_scrap`', '`member_scrap`')
));
$query->setConditions(array());
$query->setGroups(array());
$query->setOrder(array());
$query->setLimit();
return $query; ?>