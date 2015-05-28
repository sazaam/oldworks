<?php
$lang->member='会員';
$lang->site='Site';
$lang->member_default_info='基本情報';
$lang->member_extend_info='追加情報';
$lang->default_group_1='準会員';
$lang->default_group_2='正会員';
$lang->default_group='デフォルトグループ';
$lang->admin_group='管理グループ';
$lang->keep_signed='次回からID入力を省略';
$lang->remember_user_id='ID保存';
$lang->already_logged='既にログインされています。';
$lang->denied_user_id='使用が禁じられているＩＤです。';
$lang->denied_nick_name='使用が禁止されたニックネームです。';
$lang->null_user_id='ユーザーIDをもう一度入力してください。';
$lang->null_password='パスワードを入力してください。';
$lang->invalid_authorization='認証できませんでした。';
$lang->invalid_email_address='Eメールアドレスと一致する会員がありません。';
$lang->invalid_user_id='存在しないユーザーIDです。';
$lang->invalid_password='無効なパスワードです。';
$lang->invalid_new_password='以前のパスワードと同じパスワードを使うことはできません。';
$lang->allow_mailing='メーリングリストに登録';
$lang->is_admin='最高管理権限';
$lang->member_group='所属グループ';
$lang->group_title='グループ名';
$lang->group_srl='グループ番号';
$lang->group_order='グループ優先順位';
$lang->group_order_change='グループ優先順位変更';
$lang->signature='署名';
$lang->profile_image='プロフィール写真';
$lang->profile_image_max_width='制限横幅サイズ';
$lang->profile_image_max_height='制限縦幅サイズ';
$lang->image_name='イメージ名';
$lang->image_name_max_width='制限横幅サイズ';
$lang->image_name_max_height='制限縦幅サイズ';
$lang->image_mark='イメージマーク';
$lang->image_mark_max_width='制限横幅サイズ';
$lang->image_mark_max_height='制限縦幅サイズ';
$lang->group_image_mark='グループ用イメージマーク';
$lang->group_image_mark_max_width='制限横幅サイズ';
$lang->group_image_mark_max_height='制限縦幅サイズ';
$lang->signature_max_height='制限署名欄の高さ';
$lang->enable_join='会員登録を許可する';
$lang->enable_confirm='メール認証機能を使用';
$lang->enable_ssl='SSL使用';
$lang->security_sign_in='セキュア（SSL）';
$lang->limit_day='一時制限期間（日）';
$lang->limit_date='制限日';
$lang->after_login_url='ログイン後、表示するページのURL';
$lang->after_logout_url='ログアウト後、表示するページのURL';
$lang->redirect_url='会員登録後、表示するページ';
$lang->agreement='会員登録規約';
$lang->accept_agreement='利用規約に同意する';
$lang->member_info='会員情報';
$lang->current_password='現在のパスワード';
$lang->allow_message='メッセージ許可';
if(!is_array($lang->allow_message_type)){
	$lang->allow_message_type = array();
}
$lang->allow_message_type['Y']='すべて許可';
$lang->allow_message_type['F']='登録した友達のみ許可';
$lang->allow_message_type['N']='すべて禁止';
$lang->about_allow_message='メッセージの許可タイプ及び対象を設定します。';
$lang->logged_users='現在ログイン中の会員';
$lang->msg_mail_authorization='Eメール認証を資料するにはウェブマスターの名前とEメールアドレスが有効でなければなりません。';
$lang->webmaster_name='ウェブマスターの名前';
$lang->webmaster_email='ウェブマスターのメールアドレス';
$lang->column_id='入力項目ID';
$lang->about_column_id='入力項目の区切り文字で使用するIDです。英文で始め、英文＋数字のみ使用できます。';
$lang->options='選択オプション';
$lang->about_keep_signed='ブラウザを閉じてもログイン状態が維持されます。\n\nログイン維持機能を利用すると、次回からログインする必要がありません。\n\nただし、インターネットカフェ、学校など公共場所で利用する場合、個人情報が流出する恐れがありますので、必ずログアウトしてください。';
$lang->about_keep_warning='ブラウザを閉じてもログイン状態が維持されます。\n\nログイン維持機能を利用すると、次回からログインする必要がありません。 ただし、インターネットカフェ、学校など公共場所で利用する場合、個人情報が流出する恐れがありますので、必ずログアウトしてください。';
$lang->about_webmaster_name='確認メール、またはサイト管理時に使用されるウェブマスターの名前を入力してください（デフォルト : webmaster）。';
$lang->about_webmaster_email='ウェブマスターのメールアドレスを入力してください。';
if(!is_array($lang->search_target_list)){
	$lang->search_target_list = array();
}
$lang->search_target_list['email_address']='メールアドレス';
$lang->search_target_list['regdate']='登録日';
$lang->search_target_list['regdate_more']='登録日(以上)';
$lang->search_target_list['regdate_less']='登録日(以下)';
$lang->search_target_list['last_login']='最終ログイン';
$lang->search_target_list['last_login_more']='最終ログイン日(以上)';
$lang->search_target_list['last_login_less']='最終ログイン日(以下)';
$lang->search_target_list['extra_vars']='拡張変数';
$lang->cmd_modify_new_auth_email_address='新規Eメールアドレスに変更後、認証メール転送';
$lang->cmd_set_design_info='デザイン';
$lang->cmd_login='ログイン';
$lang->cmd_logout='ログアウト';
$lang->cmd_signup='会員登録';
$lang->cmd_site_signup='登録';
$lang->cmd_modify_member_email_address='Eメールアドレス変更';
$lang->about_modify_member_email_address='使用するEメールアドレスを変更できます。';
$lang->cmd_modify_member_info='会員情報変更';
$lang->cmd_modify_member_password='パスワード変更';
$lang->cmd_view_member_info='会員情報確認';
$lang->cmd_leave='退会';
$lang->cmd_find_member_account='IDとパスワードのリマインダー';
$lang->cmd_find_member_account_with_email='Eメールアドレスでアカウントを探す';
$lang->cmd_find_member_account_with_email_question='質問・回答でアカウントを探す';
$lang->cmd_resend_auth_mail='認証メール再申請';
$lang->cmd_send_auth_new_emaill_address='新規Eメールアドレスで認証メール転送';
$lang->cmd_member_list='会員リスト';
$lang->cmd_module_config='基本設定';
$lang->cmd_member_group='グループ管理';
$lang->cmd_send_mail='メール送信';
$lang->cmd_manage_id='禁止ID 管理';
$lang->cmd_manage_nick_name='禁止ニックネーム管理';
$lang->cmd_manage_form='会員登録フォーム管理';
$lang->cmd_view_own_document='書き込み履歴';
$lang->cmd_manage_member_info='会員情報管理';
$lang->cmd_trace_document='書き込みの追跡';
$lang->cmd_trace_comment='コメント追跡';
$lang->cmd_view_scrapped_document='スクラップ';
$lang->cmd_view_saved_document='保存ドキュメント';
$lang->cmd_send_email='メール送信';
$lang->msg_email_not_exists='登録されたメールアドレスがありません。';
$lang->msg_alreay_scrapped='既にスクラップされたコンテンツです。';
$lang->msg_cart_is_null='対象を選択してください。';
$lang->msg_checked_file_is_deleted='%d個の添付ファイルが削除されました。';
$lang->msg_find_account_title='会員IDどパスワードの情報';
$lang->msg_find_account_info='登録された会員情報は下記の通りです。';
$lang->msg_find_account_comment='下のリンクをクリックすると上のパスワードに変更されます。<br />ログインしてからパスワードを変更してください。';
$lang->msg_confirm_account_title='確認メールです。';
$lang->title_modify_email_address='Eメールアドレス変更要求確認メールです。';
$lang->msg_confirm_account_info='作成した会員の情報';
$lang->msg_confirm_account_comment='下記のURLをクリックして会員登録手続きを完了してください。';
$lang->msg_confirm_email_address_change='下のリンクをクリックするとEメールアドレスが %sに変更されます。';
$lang->msg_auth_mail_sent='%s 宛に認証情報内容が送信されました。メールを確認してください。';
$lang->msg_confirm_mail_sent='%s 宛に確認メールを送信しました。メールを確認してください。';
$lang->msg_invalid_modify_email_auth_key='正しくないEメール変更要求です。<br />Eメール変更要求を再度行うかサイト管理者へお問い合わせください。';
$lang->msg_invalid_auth_key='正しくないアカウントの認証要求です。<br />IDとパスワードの検索を行うか、サイト管理者にアカウント情報をお問い合わせください。';
$lang->msg_success_authed='認証が正常に行われ、ログインできました。\n必ず確認メールに記載されたパスワードを利用してお好みのパスワードに変更してください。';
$lang->msg_success_confirmed='会員登録、有難うございます。';
$lang->msg_new_member='会員追加';
$lang->msg_rechecked_password='パスワード再確認';
$lang->msg_update_member='会員情報修正';
$lang->msg_leave_member='会員退会';
$lang->msg_group_is_null='登録されたグループがありません。';
$lang->msg_not_delete_default='基本項目は削除できません。';
$lang->msg_not_exists_member='存在しないユーザーIDです。';
$lang->msg_cannot_delete_admin='管理者ＩＤは削除できません。管理者権限を解除した上で削除してみてください。';
$lang->msg_exists_user_id='既に存在するユーザーIDです。他のIDを入力してください。';
$lang->msg_exists_email_address='既に存在するメールアドレスです。他のメールアドレスを入力してください。';
$lang->msg_exists_nick_name='同じニックネームがすでに登録されています。他のニックネームを入力してください。';
$lang->msg_signup_disabled='会員登録が制限されています。<br />サイト管理者にお問合せください。';
$lang->msg_already_logged='既に会員登録されています。';
$lang->msg_not_logged='ログインしていません。';
$lang->msg_insert_group_name='グループ名を入力してください。';
$lang->msg_check_group='グループを選択してください。';
$lang->msg_not_uploaded_profile_image='プロフィールイメージを登録することができません。';
$lang->msg_not_uploaded_image_name='イメージ名を登録することができません。';
$lang->msg_not_uploaded_image_mark='イメージマークを登録することができません。';
$lang->msg_not_uploaded_group_image_mark='グループ用イメージマークの登録ができません。';
$lang->msg_accept_agreement='利用規約に同意しなければなりません。';
$lang->msg_user_denied='利用が中止されているユーザIDです。';
$lang->msg_user_not_confirmed='メールでの認証が行われていません。メールを確認してください。';
$lang->msg_user_limited='入力したユーザIDは%s以前まで使用できません。';
$lang->about_rechecked_password='会員の情報を安全に保護するため、パスワードを再度確認します。';
$lang->about_user_id='ユーザーIDは、3~20文字までの英数文字にしてください。先頭文字は英字でなければなりません。';
$lang->about_password='パスワードは6~20文字にしてください。';
$lang->cmd_config_password_strength='パスワード強度';
$lang->password_strength_low='弱い';
$lang->password_strength_normal='普通';
$lang->password_strength_high='強い';
$lang->about_password_strength_config='会員がパスワードを登録する際に、パスワードが一定の強度を満たす必要があります。ただし、管理者が直接に登録する際には適用されません。';
if(!is_array($lang->about_password_strength)){
	$lang->about_password_strength = array();
}
$lang->about_password_strength['low']='パスワードは４文字以上にしてください。';
$lang->about_password_strength['normal']='パスワードは6文字以上の【半角/英数字混合】で入力してください。';
$lang->about_password_strength['high']='パスワードは8文字以上の【半角/英文字、数字、記号の混合】で入力してください。';
$lang->about_user_name='名前は2~20文字にしてください。';
$lang->about_nick_name='ニックネームは2~20文字にしてください。';
$lang->about_email_address='メールアドレスはメール認証後に、パスワード変更または検索などに使われます。';
$lang->about_homepage='ホームページがある場合は入力してください。';
$lang->about_blog_url='運用しているブログがあれば入力してください。';
$lang->about_birthday='生年月日を入力してください。';
$lang->about_allow_mailing='メーリングリストにチェックしない場合は、全体メールの送信時にメールを受け取りません。';
$lang->about_denied='チェックを入れると、ユーザーIDを使用できないようにします。';
$lang->about_is_admin='チェックを入れると最高管理者権限が取得できます。';
$lang->about_member_description='会員に対する管理者のメモ帳です。';
$lang->about_group='一つのユーザーIDは多数のグループに属することができます。';
$lang->about_column_type='追加する登録フォームのタイプを指定してください。';
$lang->about_column_name='テンプレートで使用できる英文字の名前を入力してください（変数名）。';
$lang->about_column_title='登録または情報修正・閲覧時に表示されるタイトルです。';
$lang->about_default_value='デフォルトで入力される値を指定することができます。';
$lang->about_active='有効項目にチェックを入れないと加入時に正常に表示されません。';
$lang->about_form_description='説明欄に入力すると登録時に表示されます。';
$lang->about_required='チェックを入れると会員登録時に必須入力項目として設定されます。';
$lang->about_enable_join='チェックを入れないとユーザーが会員に登録できません。';
$lang->about_enable_confirm='登録されたメールアドレスに確認メールを送信し、会員登録を確認します。';
$lang->about_enable_ssl='サーバーでSSLが可能な場合、会員登録/情報変更/ログイン等の個人情報はSSL(https)経由でサーバーにより安全に送信されます。';
$lang->about_limit_day='会員登録後一定の期間中、認証制限を行うことができます。';
$lang->about_limit_date='指定された期間まで該当ユーザーはログインできなくします。';
$lang->about_after_login_url='ログイン後表示されるページのURLを指定できます。指定のない場合、現在のページが維持されます。';
$lang->about_after_logout_url='ログアウト後表示されるページのURLを指定できます。指定のない場合、現在のページが維持されます。';
$lang->about_redirect_url='会員登録後、表示されるページのURLを指定できます。指定のない場合は会員登録する前のページに戻ります。';
$lang->about_agreement='会員登録規約がない場合は表示されません。';
$lang->about_image_name='ユーザーの名前を文字の代わりにイメージで表示させることができます。';
$lang->about_image_mark='使用者の名前の前にマークを付けることができます。';
$lang->about_group_image_mark='ユーザー名の前にグループマークを表示します。';
$lang->about_profile_image='ユーザーのプロフィールイメージが使用できるようにします。';
$lang->about_signature_max_height='署名欄の高さのサイズを制限します。 (0 もしくは空の場合は制限なし。)';
$lang->about_accept_agreement='登録規約をすべて読み、同意します。';
$lang->about_member_default='会員登録時に基本グループとして設定されます。';
$lang->about_find_member_account='ID/パスワードは登録時に登録されたメールにてお知らせします。登録時に登録したメールアドレスを入力して「IDとパスワードのリマインダー」ボタンをクリックしてください。<br />';
$lang->about_temp_password='仮パスワードが正常に発給されました。<br />ログイン後、必ずパスワードを変更してください。<br />';
$lang->about_ssl_port='基本ポート以外のSSLポートを利用する場合、入力してください。';
$lang->about_reset_auth_mail='現在登録されたEメールアドレスは %sです。Eメールアドレスを変更したい場合は、新しいEメールアドレスに会員情報の更新後認証メールを再送できます。';
$lang->about_resend_auth_mail='認証メールが届いてなかった場合、再送信の申請が可能です。<br />※申請の前に、当サイトからメールの受信ができるように設定してください。';
$lang->about_reset_auth_mail_submit='Eメールをログインアカウントに使う場合、新規メールアドレスでログインしなければなりません。';
$lang->no_article='書き込みがありません。';
$lang->find_account_question='秘密質問';
$lang->find_account_answer='秘密質問の答え';
$lang->about_find_account_question='登録した時、入力したIDとメールアドレス、秘密質問の答えで仮のパスワードをもらえる事ができます。';
if(!is_array($lang->find_account_question_items)){
	$lang->find_account_question_items = array();
}
$lang->find_account_question_items['1']='他のメールアドレスは？';
$lang->find_account_question_items['2']='私の一番大事なものは？';
$lang->find_account_question_items['3']='私の卒業した小学校は？';
$lang->find_account_question_items['4']='私の生まれた街は？';
$lang->find_account_question_items['5']='私の理想のタイプは？';
$lang->find_account_question_items['6']='母の名前は？';
$lang->find_account_question_items['7']='父の名前は？';
$lang->find_account_question_items['8']='好きな色は？';
$lang->find_account_question_items['9']='好きな食べ物は？';
$lang->temp_password='仮のパスワード';
$lang->cmd_get_temp_password='仮のパスワードをもらう';
$lang->about_get_temp_password='ログインしてから直ちにパスワードを変更してください。';
$lang->msg_question_not_exists='秘密質問を決めていません。';
$lang->msg_answer_not_matches='秘密質問の答えが正しくありません。';
$lang->change_password_date='パスワード更新周期';
$lang->about_change_password_date='設定した更新周期によってパスワード変更のお知らせがもらえます。（０に設定すると無効になる） ';
$lang->login_trial_limit1='ログイン試行回数の制限回数';
$lang->login_trial_limit2='ログイン試行回数の制限時間';
$lang->about_login_trial_limit1='決められた時間内に許可されたログイン回数を入力してください。短い時間の間に１つのIPで試行できるログイン回数に制限を置きます。';
$lang->about_login_trial_limit2='指定された回数のログインを許可する時間を決めてください。短い時間の間に１つのIPで試行できるログイン回数に制限を置きます。時間は最後のログイン試行時刻からの時間を基準で測定します。';
$lang->msg_kr_address='邑、面、洞名で検索してください。';
$lang->msg_kr_address_etc='住所を入力してください。';
$lang->cmd_search_again='再検索';
$lang->msg_select_user='管理する会員を選択してください。';
$lang->msg_delete_user='選択した会員を削除します。';
$lang->cmd_selected_user_manage='選択した会員管理';
$lang->about_change_user_group='選択した会員のグループを再設定する。';
$lang->about_send_message='会員にメッセージを送信して、知らせます。作成しなければ送信されません。';
$lang->cmd_required='必須';
$lang->cmd_optional='選択';
$lang->cmd_image_max_width='横幅制限';
$lang->cmd_image_max_height='高さ制限';
$lang->cmd_input_extend_form='会員拡張項目入力';
$lang->about_multi_type='多重または単一項目の選択値を入力してください。（改行で区別）';
$lang->msg_delete_extend_form='選択した項目を削除します。';
$lang->set_manage_id='改行で区別';
$lang->count_manage_id='<span class="_deniedIDCount">%s</span>個の禁止IDがあります。';
$lang->count_manage_nick_name='<span class="_deniedNickNameCount">%s</span>個の禁止ニックネームがあります。';
$lang->user_list='会員リスト';
$lang->cmd_show_all_member='すべての会員';
$lang->cmd_show_super_admin_member='最高管理者';
$lang->cmd_show_site_admin_member='サイト管理者';
$lang->approval='承認';
$lang->denied='拒否';
$lang->use_group_image_mark='グループイメージマーク使用';
$lang->group_image_mark='グループイメージマーク';
$lang->usable_group_image_mark_list='使用可能なグループイメージマークリスト';
$lang->add_group_image_mark='グループイメージマーク追加';
$lang->link_file_box='ファイルボックス管理';
$lang->msg_group_delete='選択グループを削除します。';
$lang->email='メール';
$lang->add_prohibited_id='禁止ID追加';
$lang->multi_line_input='複数の項目は、改行して入力してください。';
$lang->add_extend_form='ユーザー定義項目追加';
$lang->msg_null_prohibited_id='追加する禁止IDを入力してください。';
$lang->msg_null_prohibited_nick_name='追加するニックネームを入力してください。';
$lang->identifier='ログインアカウント';
$lang->about_identifier='ログインに使用するアカウントを選択してください。';
$lang->about_public_item='本人以外に他の会員にも露出される情報なのか選択します。';
$lang->use_after_save='保存後使用';
$lang->cmd_add_group='グループ追加';
$lang->msg_groups_exist='個のグループが存在します。';
$lang->cmd_member_config='会員設定';
$lang->cmd_member_sync='会員情報同期化';
$lang->about_member_sync='会員情報とコンテンツ・コメント情報を同期化します。データが多い場合、時間が長くかかる場合があります。<strong>利用者が多い場合は必ずサービスを中断して行ってください。</strong>';
$lang->msg_success_modify_email_address='Eメールアドレスが正常に変更されました。変更されたEメールアドレスでログイン可能です。';
$lang->group='グループ';
$lang->retrieve_password='パスワードを探す';
$lang->excess_ip_access_count='ログイン可能な回数を超えました。%s間、ログインできません。';
$lang->enable_login_fail_report='アカウント無限代入防止使用';
$lang->login_fail_report='ログイン失敗記録報告です。';
$lang->login_fail_report_contents='<h2>ログイン失敗記録をお知らせします。</h2>%1$s<hr /><p>＊パスワード間違いなどのことがないのにこのメッセージが表示されたら、アカウント管理に注意してください。<br />＊このメッセージはログインが成功された瞬間に累積ログイン失敗記録が多すぎる場合、ログイン成功以前の失敗記録をまとめて転送します。<br />転送時刻：%2$s</p>';
$lang->all_group='グループ全体';
$lang->msg_insert_group_name_detail='グループタイトルが空のところは反映されません。';
$lang->msg_exist_selected_module='会員登録後移動するURLの情報が存在しません。';
$lang->cmd_spammer='スパマー管理';
$lang->spammer_description='<p>指定された会員を遮断して、会員が残したコンテンツとコメントを削除します。会員が作成したコンテンツの量によって長くかかる場合があります。</p>';
$lang->btn_spammer_delete_all='すべて削除';
$lang->spammer_move_to_trash='ゴミ箱へ移動';
