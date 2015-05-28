<?php
$lang->cmd_comment_do='このコメントを…';
$lang->comment_list='コメントリスト';
$lang->cmd_toggle_checked_comment='選択項目の反転';
$lang->cmd_delete_checked_comment='選択項目削除';
$lang->trash='ゴミ箱';
$lang->cmd_trash='ゴミ箱へ移動';
$lang->comment_count='コメント数';
$lang->about_comment_count='コメントを指定した数だけ表示し、それ以上はリスト化します。';
$lang->msg_cart_is_null='削除するコメントを選択してください。';
$lang->msg_checked_comment_is_deleted='%d個のコメントを削除しました。';
if(!is_array($lang->search_target_list)){
	$lang->search_target_list = array();
}
$lang->search_target_list['content']='内容';
$lang->search_target_list['user_id']='ユーザID';
$lang->search_target_list['user_name']='名前';
$lang->search_target_list['nick_name']='ニックネーム';
$lang->search_target_list['member_srl']='会員番号';
$lang->search_target_list['email_address']='メールアドレス';
$lang->search_target_list['homepage']='ホームページURL';
$lang->search_target_list['regdate']='登録日';
$lang->search_target_list['last_update']='最終更新日 ';
$lang->search_target_list['ipaddress']='IPアドレス';
$lang->search_target_list['is_secret']='状態';
$lang->no_text_comment='テキストがないコメントです。';
if(!is_array($lang->secret_name_list)){
	$lang->secret_name_list = array();
}
$lang->secret_name_list['Y']='非公開';
$lang->secret_name_list['N']='公開';
if(!is_array($lang->published_name_list)){
	$lang->published_name_list = array();
}
$lang->published_name_list['Y']='発行完了';
$lang->published_name_list['N']='発行待機';
$lang->comment_manager='選択したコメントを管理';
$lang->selected_comment='選択したコメント';
$lang->cmd_comment_validation='承認後公開';
$lang->about_comment_validation='管理者承認後コメントを公開します。';
$lang->published='発行状態';
$lang->cmd_publish='発行';
$lang->cmd_unpublish='発行中止';
$lang->select_module='モジュール選択';
$lang->page='ページ';
$lang->msg_not_selected_comment='選択したコメントがありません。';
