<?php if(!defined('__XE__')) exit();
$query = new Query();
$query->setQueryId("getDocuments");
$query->setAction("select");
$query->setPriority("");

${'document_srls20_argument'} = new ConditionArgument('document_srls', $args->document_srls, 'in');
${'document_srls20_argument'}->checkNotNull();
${'document_srls20_argument'}->createConditionValue();
if(!${'document_srls20_argument'}->isValid()) return ${'document_srls20_argument'}->getErrorMessage();
if(${'document_srls20_argument'} !== null) ${'document_srls20_argument'}->setColumnType('number');

${'page23_argument'} = new Argument('page', $args->{'page'});
${'page23_argument'}->ensureDefaultValue('1');
if(!${'page23_argument'}->isValid()) return ${'page23_argument'}->getErrorMessage();

${'page_count24_argument'} = new Argument('page_count', $args->{'page_count'});
${'page_count24_argument'}->ensureDefaultValue('10');
if(!${'page_count24_argument'}->isValid()) return ${'page_count24_argument'}->getErrorMessage();

${'list_count25_argument'} = new Argument('list_count', $args->{'list_count'});
${'list_count25_argument'}->ensureDefaultValue('20');
if(!${'list_count25_argument'}->isValid()) return ${'list_count25_argument'}->getErrorMessage();

${'list_order21_argument'} = new Argument('list_order', $args->{'list_order'});
${'list_order21_argument'}->ensureDefaultValue('list_order');
if(!${'list_order21_argument'}->isValid()) return ${'list_order21_argument'}->getErrorMessage();

${'order_type22_argument'} = new SortArgument('order_type22', $args->order_type);
${'order_type22_argument'}->ensureDefaultValue('asc');
if(!${'order_type22_argument'}->isValid()) return ${'order_type22_argument'}->getErrorMessage();

$query->setColumns(array(
new StarExpression()
));
$query->setTables(array(
new Table('`xe_documents`', '`documents`')
));
$query->setConditions(array(
new ConditionGroup(array(
new ConditionWithArgument('`document_srl`',$document_srls20_argument,"in")))
));
$query->setGroups(array());
$query->setOrder(array(
new OrderByColumn(${'list_order21_argument'}, $order_type22_argument)
));
$query->setLimit(new Limit(${'list_count25_argument'}, ${'page23_argument'}, ${'page_count24_argument'}));
return $query; ?>