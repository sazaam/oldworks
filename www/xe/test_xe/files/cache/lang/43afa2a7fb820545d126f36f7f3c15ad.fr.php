<?php
$lang->feed='Publish RSS Feed';
$lang->total_feed='Aggregated Feeds';
$lang->rss_disable='Invalider RSS';
$lang->feed_copyright='Copyright';
$lang->feed_document_count='Number of articles per page';
$lang->feed_image='Feed Image';
$lang->rss_type='Le Format pour imprimer RSS';
$lang->open_rss='Exposer RSS';
if(!is_array($lang->open_rss_types)){
	$lang->open_rss_types = array();
}
$lang->open_rss_types['Y']='Exposer Tout';
$lang->open_rss_types['H']='Exposer Résumé';
$lang->open_rss_types['N']='Ne pas exposer';
$lang->open_feed_to_total='Included in aggregated feed';
$lang->about_rss_disable='Si vous cochez, RSS sera invalidé.';
$lang->about_rss_type='Vous pouvez désignez le format pour inprimer RSS.';
$lang->about_open_rss='Vous pouvez exposez au publique le RSS du module courant ou non.\nN\'importe comment est la permission de l\'article, RSS sera exposé au publique selon son option.';
$lang->about_feed_description='You can enter the description on the RSS feed to be published. If you don\'t enter this, the description of each module is displayed by default.';
$lang->about_feed_copyright='You can enter copyright information on the RSS feed. If you don\'t enter this, the copyright of the entire RSS feeds is applied.';
$lang->about_feed_document_count='Number of articles to be displayed on one feed page (default: 15)';
$lang->msg_rss_is_disabled='La fonction RSS est invalidé.';
$lang->msg_rss_invalid_image_format='Invalid image format. \nOnly JPEG, GIF, and PNG files are supported.';
