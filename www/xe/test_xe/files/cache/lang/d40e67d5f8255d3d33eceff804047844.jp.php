<?php
$lang->page='ページ';
$lang->none_content='内容がありません。';
$lang->cmd_manage_selected_page='選択したページ管理';
$lang->about_page='一枚のページを作成できるモジュールです。最新書き込みウィジェットや他のウィジェットを用いて動的なページが作成ができ、さらにエディターのコンポネントで様々なデザインもできます。接続URLは、他のモジュールと同様に、「mid=モジュール名」でアクセスし、デフォルトとして指定するとサイトにアクセスする際、メインページとして使われます。';
$lang->cmd_page_modify='ページ修正';
$lang->cmd_page_create='ページ作成';
$lang->cmd_page_article_create='Article作成';
$lang->page_caching_interval='キャッシング時間設定';
$lang->about_page_caching_interval='分単位で指定でき、設定された時間の間は、一時保存されたデータを出力します。 他のサーバの情報を出力したり、データを出力する際、リソースが多く使われるため、数分単位でキャッシングすることをお勧めします。 「0」に指定するとキャッシングされません。';
$lang->about_mcontent='モバイルスキン用のページです。作成しないとPC向けのページを再構成して表示します。';
$lang->page_type='ページタイプ';
$lang->click_choice='選択してください。';
if(!is_array($lang->page_type_name)){
	$lang->page_type_name = array();
}
$lang->page_type_name['ARTICLE']='書き込み Page';
$lang->page_type_name['WIDGET']='ウィジェット Page';
$lang->page_type_name['OUTSIDE']='外部ページ';
$lang->about_page_type='ページタイプを選択して好きな画面を構成できます。<ol><li>ウィジェット型 : いろんなウィジェットを生成して画面を構成します。</li><li>ドキュメント型 : タイトル、内容、タグのあるドキュメントを製作して、投稿形式のページを作成します。</li><li>外部ページ型 : 外部HTML、またはPHPファイルをXEで使用できます。';
$lang->opage_path='外部ドキュメントの位置';
$lang->about_opage='XEではなく、外部HTML、またはPHPファイルをXEで使用できるようにするモジュールです。 絶対パス、相対パスを利用でき、http://で開始する場合にサーバー外部のページも表示できます。';
$lang->about_opage_path='外部ドキュメントの位置を入力してください。 /path1/path2/sample.phpのような絶対パス、もしくは../path2/sample.phpのような相対パス両方とも使用できます。 http://url/sample.phpのように使用すると、該当ページをウェブへ転送し、出力します。 現在、XEがインストールされている絶対パスは、次のとおりです。 ';
$lang->opage_mobile_path='モバイル用外部ドキュメントの位置';
$lang->about_opage_mobile_path='モバイル用外部ドキュメントの位置を入力してください。入力しないと上記で指定した外部ドキュメントの位置のページを利用します。 /path1/path2/sample.phpのように絶対パス、もしくは../path2/sample.phpのような相対パス両方とも使用できます。 http://url/sample.phpのように使用すると、該当ページをウェブへ転送し、出力します。 現在、XEのインストールされている絶対パスは、次のとおりです。 ';
$lang->page_management='ページ管理]';
$lang->page_delete_warning='ページを削除する時、ファイルも一緒に削除されます。';
$lang->msg_not_selected_page='選択したページがありません。';
