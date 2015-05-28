<?php
$lang->feed='RSS発行';
$lang->total_feed='統合RSS';
$lang->rss_disable='RSS機能オフ';
$lang->feed_copyright='著作権';
$lang->feed_document_count='RSSコンテンツ数';
$lang->feed_image='RSSイメージ';
$lang->rss_type='出力するRSSタイプ';
$lang->open_rss='RSS配信';
if(!is_array($lang->open_rss_types)){
	$lang->open_rss_types = array();
}
$lang->open_rss_types['Y']='全文配信 ';
$lang->open_rss_types['H']='要約配信';
$lang->open_rss_types['N']='配信しない';
$lang->open_feed_to_total='統合RSSに含む';
$lang->about_rss_disable='チェックを入れるとRSSの出力を行いません。';
$lang->about_rss_type='出力するRSSタイプを指定することができます。';
$lang->about_open_rss='現在のモジュールに対して「RSS配信」を選択することができます。書き込みの内容が読める権限とは関係なくオプションによってRSSが配信されます。';
$lang->about_feed_description='発行するRSSに関する説明を入力します。未入力した場合は該当モジュールで設定された管理用説明が含まれます。';
$lang->about_feed_copyright='発行するRSSのコンテンツに対する著作権情報です。未入力の場合、全体RSS著作権の設定と同様に適用されます。';
$lang->about_feed_document_count='RSSに配信するコンテンツの数 (デフォルト : 15)';
$lang->msg_rss_is_disabled='RSS機能がロックされています。';
$lang->msg_rss_invalid_image_format='サポートしないイメージファイルです。\nJPEG, GIF, PNGファイルのみサポートします。';