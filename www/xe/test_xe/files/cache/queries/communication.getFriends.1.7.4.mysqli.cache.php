<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getFriends");
$query->setAction("select");
$query->setPriority("");
if(isset($args->friend_group_srl)) {
${'friend_group_srl2_argument'} = new ConditionArgument('friend_group_srl', $args->friend_group_srl, 'equal');
${'friend_group_srl2_argument'}->createConditionValue();
if(!${'friend_group_srl2_argument'}->isValid()) return ${'friend_group_srl2_argument'}->getErrorMessage();
} else
${'friend_group_srl2_argument'} = NULL;if(${'friend_group_srl2_argument'} !== null) ${'friend_group_srl2_argument'}->setColumnType('number');
if(isset($args->member_srl)) {
${'member_srl3_argument'} = new ConditionArgument('member_srl', $args->member_srl, 'equal');
${'member_srl3_argument'}->createConditionValue();
if(!${'member_srl3_argument'}->isValid()) return ${'member_srl3_argument'}->getErrorMessage();
} else
${'member_srl3_argument'} = NULL;if(${'member_srl3_argument'} !== null) ${'member_srl3_argument'}->setColumnType('number');

${'page5_argument'} = new Argument('page', $args->{'page'});
${'page5_argument'}->ensureDefaultValue('1');
if(!${'page5_argument'}->isValid()) return ${'page5_argument'}->getErrorMessage();

${'page_count6_argument'} = new Argument('page_count', $args->{'page_count'});
${'page_count6_argument'}->ensureDefaultValue('10');
if(!${'page_count6_argument'}->isValid()) return ${'page_count6_argument'}->getErrorMessage();

${'list_count7_argument'} = new Argument('list_count', $args->{'list_count'});
${'list_count7_argument'}->ensureDefaultValue('10');
if(!${'list_count7_argument'}->isValid()) return ${'list_count7_argument'}->getErrorMessage();

${'sort_index4_argument'} = new Argument('sort_index', $args->{'sort_index'});
${'sort_index4_argument'}->ensureDefaultValue('friend.list_order');
if(!${'sort_index4_argument'}->isValid()) return ${'sort_index4_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_member_friend`', '`friend`')
,new Table('`xe_member`', '`member`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`friend`.`friend_group_srl`',$friend_group_srl2_argument,"equal")
,new ConditionWithArgument('`friend`.`member_srl`',$member_srl3_argument,"equal", 'and')
,new ConditionWithoutArgument('`member`.`member_srl`','`friend`.`target_srl`',"equal", 'and')))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'sort_index4_argument'}, "asc")
));
$query->setLimit(new Limit(${'list_count7_argument'}, ${'page5_argument'}, ${'page_count6_argument'}));
return $query; ?>