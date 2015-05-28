<?php
$lang->poll='Enquête';
$lang->poll_stop_date='Jour d\'Expiration';
$lang->poll_join_count='Participants';
$lang->poll_checkcount='Nombre obligé à choisir';
$lang->cmd_poll_list='Voir la liste des Enquêtes';
$lang->cmd_delete_checked_poll='Supprimer l\'Enquête choisi';
$lang->cmd_apply_poll='Participer(Soumettre)';
$lang->cmd_view_result='Voir le Résultat';
$lang->success_poll='Merci pour participer.';
$lang->msg_already_poll='Vous avez déjà participé!';
$lang->msg_poll_is_null='Choisissez des Enquêtes à supprimer.';
$lang->msg_checked_poll_is_deleted='%d Enquête(s) est(sont) supprimée(s).';
$lang->confirm_poll_delete='%s개의 설문을 삭제하시겠습니까?';
$lang->msg_check_poll_item='Choisissez un des item.\n(Nombre obligé à choisir peut être différent par chaque Enquête.)';
$lang->msg_poll_not_exists='L\'Enquête choisi n\'existe pas.';
$lang->cmd_null_item='Aucune valeur à enrégistrer comme enquête n\'existe pas. Essayez encore une fois, S.V.P.';
$lang->confirm_poll_submit='Vous voulez sûrement soumettre?';
if(!is_array($lang->search_poll_target_list)){
	$lang->search_poll_target_list = array();
}
$lang->search_poll_target_list['title']='Titre';
$lang->search_poll_target_list['regdate']='Jour posté';
$lang->search_poll_target_list['ipaddress']='Adresse IP';
$lang->single_check='Single Check';
$lang->multi_check='Multi Check';
$lang->selected_poll='Selected poll';
