<?php
$lang->cmd_comment_do='Vous voudriez';
$lang->comment_list='Liste des Commentaires';
$lang->cmd_toggle_checked_comment='Renverser les choisis';
$lang->cmd_delete_checked_comment='Supprimer les choisis';
$lang->trash='Recycle Bin';
$lang->cmd_trash='Move to Recycle Bin';
$lang->comment_count='Limite de Commentaires';
$lang->about_comment_count='Quand il y a plus de commentaires, ils seront bougés sur le liste.';
$lang->msg_cart_is_null='Choisissez un article à supprimer, S.V.P.';
$lang->msg_checked_comment_is_deleted='%d commentaire(s) est(sont) supprimé(s) avec succés.';
if(!is_array($lang->search_target_list)){
	$lang->search_target_list = array();
}
$lang->search_target_list['content']='Contenu';
$lang->search_target_list['user_id']='Compte';
$lang->search_target_list['user_name']='Nom';
$lang->search_target_list['nick_name']='Surnom';
$lang->search_target_list['member_srl']='Numéro de Série du Membre';
$lang->search_target_list['email_address']='Mél';
$lang->search_target_list['homepage']='Page d\'Accueil';
$lang->search_target_list['regdate']='Jour';
$lang->search_target_list['last_update']='Mise à Jour';
$lang->search_target_list['ipaddress']='Adresse IP';
$lang->search_target_list['is_secret']='Status';
$lang->no_text_comment='No text in this comment.';
if(!is_array($lang->secret_name_list)){
	$lang->secret_name_list = array();
}
$lang->secret_name_list['Y']='Secret';
$lang->secret_name_list['N']='Public';
if(!is_array($lang->published_name_list)){
	$lang->published_name_list = array();
}
$lang->published_name_list['Y']='Published';
$lang->published_name_list['N']='Unpublished';
$lang->comment_manager='Manage Selected Comment';
$lang->selected_comment='Selected Comment';
$lang->cmd_comment_validation='Use comment validation';
$lang->about_comment_validation='If you want to use comment validation before displaying on your module frontend select USE, otherwise select NOT USE.';
$lang->published='Publish status';
$lang->cmd_publish='Publish';
$lang->cmd_unpublish='Unpublish';
$lang->select_module='Select Module';
$lang->page='Page';
$lang->msg_not_selected_comment='There are no selected comment.';
