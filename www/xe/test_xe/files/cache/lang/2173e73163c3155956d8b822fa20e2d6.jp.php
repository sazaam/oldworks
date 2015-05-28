<?php
$lang->communication='コミュニケーション';
$lang->about_communication='会員間でメッセージや友達管理などコミュニティ機能を提供するモジュールです。';
$lang->allow_message='メッセージの受信';
if(!is_array($lang->allow_message_type)){
	$lang->allow_message_type = array();
}
$lang->allow_message_type['Y']='すべて受信';
$lang->allow_message_type['N']='すべて受信しない';
$lang->allow_message_type['F']='友達からのみ受信する';
if(!is_array($lang->message_box)){
	$lang->message_box = array();
}
$lang->message_box['R']='メッセージ受信箱';
$lang->message_box['S']='メッセージ送信箱';
$lang->message_box['T']='保存箱';
$lang->readed_date='開封時間';
$lang->sender='送信者';
$lang->receiver='受信者';
$lang->friend_group='友達グループ';
$lang->default_friend_group='グループ未指定';
$lang->cmd_send_message='メッセージ送信';
$lang->cmd_reply_message='メッセージ返信';
$lang->cmd_view_friend='友達リスト';
$lang->cmd_add_friend='友達登録';
$lang->cmd_message_box='メッセージ';
$lang->cmd_view_message_box='メッセージ';
$lang->cmd_store='保存';
$lang->cmd_add_friend_group='友達グループ追加';
$lang->cmd_rename_friend_group='友達グループ名変更';
$lang->msg_no_message='メッセージがありません。';
$lang->msg_cannot_send_to_yourself='自分自身へのメッセージ送信はできません。';
$lang->message_received='メッセージが届きました。';
$lang->msg_title_is_null='メッセージのタイトルを入力してください。';
$lang->msg_content_is_null='内容を入力してください。';
$lang->msg_allow_message_to_friend='友達からのみメッセージを受信できるように設定したユーザーであるため、送信できませんでした。';
$lang->msg_disallow_message='メッセージの受信を拒否している受信者であるため、送信できませんでした。';
$lang->about_allow_message='メッセージを受信するか設定します。';
$lang->message_notice='作成者にメッセージを送信し、知らせます。作成しなければ送信されません。';
$lang->friends_page_does_not_support='モバイル環境では友達リストページをサポートしません。PC画面へ移動してください。';
