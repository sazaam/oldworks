<?php
$lang->poll='アンケート調査';
$lang->poll_stop_date='アンケート調査の終了日';
$lang->poll_join_count='参加者';
$lang->poll_checkcount='必須選択項目数';
$lang->cmd_poll_list='アンケートのリスト表示';
$lang->cmd_delete_checked_poll='選択アンケート削除';
$lang->cmd_apply_poll='アンケート調査へ参加する';
$lang->cmd_view_result='結果を見る';
$lang->success_poll='アンケート調査へのご応募ありがとうございます。';
$lang->msg_already_poll='既にアンケート調査に応募しました。';
$lang->msg_poll_is_null='削除するアンケートを選択してください。';
$lang->msg_checked_poll_is_deleted='%d個のアンケートが削除されました。';
$lang->confirm_poll_delete='%s個のアンケートを削除しますか？';
$lang->msg_check_poll_item='アンケート調査の項目を選択してください（アンケート調査ごと必須の選択項目が異なる場合があります）。';
$lang->msg_poll_not_exists='選択したアンケートは存在しません。';
$lang->cmd_null_item='アンケート調査に登録する項目がありません。 もう一度設定してください。';
$lang->confirm_poll_submit='アンケート調査に応募しますか？';
if(!is_array($lang->search_poll_target_list)){
	$lang->search_poll_target_list = array();
}
$lang->search_poll_target_list['title']='タイトル';
$lang->search_poll_target_list['regdate']='登録日';
$lang->search_poll_target_list['ipaddress']='IPアドレス';
$lang->single_check='ひとつだけ選択';
$lang->multi_check='複数選択';
$lang->selected_poll='選択したアンケート';
