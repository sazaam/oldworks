<?php
$lang->cmd_sync_member='同期化';
$lang->cmd_continue='続ける';
$lang->preprocessing='データ移転のため、準備中です。';
$lang->importer='XEデータ変換';
$lang->source_type='データ変換の対象';
$lang->type_member='会員情報';
$lang->type_message='メッセージ情報';
$lang->type_ttxml='TTXML';
$lang->type_module='書き込みデータ情報';
$lang->type_syncmember='会員情報同期化';
$lang->target_module='対象モジュール';
$lang->xml_file='XMLファイル';
if(!is_array($lang->import_step_title)){
	$lang->import_step_title = array();
}
$lang->import_step_title['1']='Step 1. 移転先を選択';
$lang->import_step_title['12']='Step 1-2. 対象モジュール選択';
$lang->import_step_title['13']='Step 1-3. 対象カテゴリ選択';
$lang->import_step_title['2']='Step 2. XMLファイルアップロード';
$lang->import_step_title['3']='Step 2. 会員情報と書き込みデータの同期化';
$lang->import_step_title['99']='データ移転';
if(!is_array($lang->import_step_desc)){
	$lang->import_step_desc = array();
}
$lang->import_step_desc['1']='変換するXMLファイルの種類を選択してください。';
$lang->import_step_desc['12']='データ変換を行う対象モジュールを選択してください。';
$lang->import_step_desc['121']='書き込み:';
$lang->import_step_desc['122']='ゲストブック:';
$lang->import_step_desc['13']='データ変換を行う対象カテゴリを選択してください。';
$lang->import_step_desc['2']='データ変換を行うXMLファイルパスを入力してください。同じアカウントのサーバ上では、相対または絶対パスを、異なるサーバにアップロードされている場合は「http://アドレス..」を入力してください。';
$lang->import_step_desc['3']='会員情報と変換後の書き込みデータが一致しない場合があります。この場合は、同期化を行うと「ID」をもとに正しく動作するようになります。';
$lang->import_step_desc['99']='データを変換しています。';
$lang->xml_path='XMLファイルのパスを入力してください。';
$lang->data_destination='データの目的地を選択してください。';
$lang->document_destination='ドキュメントデータの目的地を選択してください。';
$lang->guestbook_destination='ゲストブックデータの目的地を選択してください。';
$lang->msg_sync_member='同期化ボタンをクリックすると会員情報と書き込みデータの情報の同期化が始まります。';
$lang->found_xml_file='XMLファイルが見つかりました。';
$lang->not_found_xml_file='XMLファイルが見つかりません。';
$lang->cannot_allow_fopen_in_phpini='php.iniの環境設定でリモートファイルの読み込みは禁止されています。';
$lang->cannot_url_file='リモートファイルの読み込みに失敗しました。';
$lang->cmd_check_path='パス確認';
$lang->msg_exist_xml_file='XMLファイルが見つかりました。';
$lang->msg_no_xml_file='XMLファイルが見つかりません。パスをもう一度確認してください。';
$lang->msg_invalid_xml_file='XMLファイルのフォーマットが正しくありません。';
$lang->msg_importing='%d個のデータの内、%d個を変換しています。(止まったままの場合は「続ける」ボタンをクリックしてください）。';
$lang->msg_import_finished='%d/%d個のデータ変換が完了しました。場合によって変換されていないデータがあることもあります。';
$lang->msg_sync_completed='会員情報、書き込みデータ、コメントのデータの同期化（変換）が完了しました。';
$lang->about_type_member='データ変換の対象が会員情報の場合は選択してください。';
$lang->about_type_message='データ移転対象がメッセージの場合に選択してください。';
$lang->about_type_ttxml='データ移転対象が、TTXML(textcube系列)の場合に選択してください。';
$lang->about_ttxml_user_id='TTXML移転時に投稿者として指定するユーザーIDを入力してください（すでに加入されているIDでなければなりません）。';
$lang->about_type_module='データ変換の対象が書き込みデータである場合は選択してください。';
$lang->about_type_syncmember='会員情報と書き込みデータなどの変換を行った後、会員情報を同期化する必要がある場合は、選択してください。';
$lang->about_importer='ゼロボード4、zb5betaまたは他のプログラムの書き込みデータをXEのデータに変換することができます。
変換するためには、<a href="http://www.xpressengine.com/index.php?mid=download&category_srl=18324038" target="_blank">XML Exporter</a>を利用して変換したい書き込みデータをXMLファイルで作成してアップロードしてください。';
$lang->about_target_path='添付ファイルをダウンロードするためには、ゼロボード4がインストールされた場所を入力してください。同じサーバ上にある場合は「/home/ID/public_html/bbs」のように入力し、他のサーバにある場合は、「http://ドメイン/bbs」のようにゼロボードがインストールされているURLを入力してください。';
