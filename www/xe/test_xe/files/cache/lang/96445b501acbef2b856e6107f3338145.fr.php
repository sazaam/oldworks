<?php
$lang->integration_search='Recherche Unie';
$lang->sample_code='Code d\'échantillon';
$lang->about_target_module='Les modules choisis seulement seront les objectifs. Faites attention quand vous mettez la permission, S.V.P.';
$lang->about_sample_code='Vous pouvez utiliser la Reherche Uni si vous ajoutez le code au-dessus dans le Mise en Page etc.';
$lang->msg_no_keyword='Entrez le mot de clé à rechercher, S.V.P.';
$lang->msg_document_more_search='Click \'Search Next\' button to keep searching.';
$lang->is_result_text='Il y a <strong>%d</strong> résultat(s) pour <strong>\'%s\'</strong>';
$lang->multimedia='Images/Video';
$lang->include_search_target='Seulement dans certaines cibles ';
$lang->exclude_search_target='Recherche de la destination sélectionnée à partir de';
if(!is_array($lang->is_search_option)){
	$lang->is_search_option = array();
}
if(!is_array($lang->is_search_option['document'])){
	$lang->is_search_option['document'] = array();
}
$lang->is_search_option['document']['title_content']='Titre+Contenu';
$lang->is_search_option['document']['title']='Titre';
$lang->is_search_option['document']['content']='Contenu';
$lang->is_search_option['document']['tag']='Balise';
if(!is_array($lang->is_search_option['trackback'])){
	$lang->is_search_option['trackback'] = array();
}
$lang->is_search_option['trackback']['url']='URL objectif';
$lang->is_search_option['trackback']['blog_name']='Nom du Site objectif';
$lang->is_search_option['trackback']['title']='Titre';
$lang->is_search_option['trackback']['excerpt']='Contenu';
if(!is_array($lang->is_sort_option)){
	$lang->is_sort_option = array();
}
$lang->is_sort_option['regdate']='Enrégistré';
$lang->is_sort_option['comment_count']='Commentaires';
$lang->is_sort_option['readed_count']='Vues';
$lang->is_sort_option['voted_count']='Recommandés';
