<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getReceivedMessages");
$query->setAction("select");
$query->setPriority("");

${'member_srl1_argument'} = new ConditionArgument('member_srl', $args->member_srl, 'equal');
${'member_srl1_argument'}->checkNotNull();
${'member_srl1_argument'}->createConditionValue();
if(!${'member_srl1_argument'}->isValid()) return ${'member_srl1_argument'}->getErrorMessage();
if(${'member_srl1_argument'} !== null) ${'member_srl1_argument'}->setColumnType('number');

${'message_type2_argument'} = new ConditionArgument('message_type', $args->message_type, 'equal');
${'message_type2_argument'}->ensureDefaultValue('R');
${'message_type2_argument'}->createConditionValue();
if(!${'message_type2_argument'}->isValid()) return ${'message_type2_argument'}->getErrorMessage();
if(${'message_type2_argument'} !== null) ${'message_type2_argument'}->setColumnType('char');

${'page4_argument'} = new Argument('page', $args->{'page'});
${'page4_argument'}->ensureDefaultValue('1');
if(!${'page4_argument'}->isValid()) return ${'page4_argument'}->getErrorMessage();

${'page_count5_argument'} = new Argument('page_count', $args->{'page_count'});
${'page_count5_argument'}->ensureDefaultValue('10');
if(!${'page_count5_argument'}->isValid()) return ${'page_count5_argument'}->getErrorMessage();

${'list_count6_argument'} = new Argument('list_count', $args->{'list_count'});
${'list_count6_argument'}->ensureDefaultValue('20');
if(!${'list_count6_argument'}->isValid()) return ${'list_count6_argument'}->getErrorMessage();

${'sort_index3_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index3_argument'}->ensureDefaultValue('message.list_order');
if(!${'sort_index3_argument'}->isValid()) return ${'sort_index3_argument'}->getErrorMessage();

$query->setColumns(array(
new SelectExpression('`message`.*')
,new SelectExpression('`member`.`user_id`')
,new SelectExpression('`member`.`member_srl`')
,new SelectExpression('`member`.`nick_name`')
,new SelectExpression('`member`.`user_name`')
));
$query->setTables(array(
new Table('`xe_member_message`', '`message`')
,new Table('`xe_member`', '`member`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`message`.`receiver_srl`',$member_srl1_argument,"equal")
,new ConditionWithArgument('`message`.`message_type`',$message_type2_argument,"equal", 'and')
,new ConditionWithoutArgument('`message`.`sender_srl`','`member`.`member_srl`',"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index3_argument'}, "asc")
));
$query->setLimit(new Limit(${'list_count6_argument'}, ${'page4_argument'}, ${'page_count5_argument'}));
return $query; ?>