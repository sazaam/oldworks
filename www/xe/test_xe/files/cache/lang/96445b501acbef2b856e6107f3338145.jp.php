<?php
$lang->integration_search='統合検索';
$lang->sample_code='サンプルコード';
$lang->about_target_module='選択されたモジュールだけを検索対象とします。各モジュールの権限設定にも注意してください。';
$lang->about_sample_code='上のコードをレイアウトなどに挿入すると統合検索が可能になります。';
$lang->msg_no_keyword='検索語を入力してください。';
$lang->msg_document_more_search='継続サーチボタンを選択すると、まだ検索結果として引っかからなかった箇所を引き続き検索を行います。';
$lang->is_result_text='<strong>\'%s\'</strong>に対する検索結果<strong>%d</strong>件';
$lang->multimedia='画像/動画';
$lang->include_search_target='選択された対象のみ';
$lang->exclude_search_target='選択した対象を検索から除外';
if(!is_array($lang->is_search_option)){
	$lang->is_search_option = array();
}
if(!is_array($lang->is_search_option['document'])){
	$lang->is_search_option['document'] = array();
}
$lang->is_search_option['document']['title_content']='タイトル+内容';
$lang->is_search_option['document']['title']='タイトル';
$lang->is_search_option['document']['content']='内容';
$lang->is_search_option['document']['tag']='タグ';
if(!is_array($lang->is_search_option['trackback'])){
	$lang->is_search_option['trackback'] = array();
}
$lang->is_search_option['trackback']['url']='対象URL';
$lang->is_search_option['trackback']['blog_name']='対象サイト（ブログ）名';
$lang->is_search_option['trackback']['title']='タイトル';
$lang->is_search_option['trackback']['excerpt']='内容';
if(!is_array($lang->is_sort_option)){
	$lang->is_sort_option = array();
}
$lang->is_sort_option['regdate']='登録日';
$lang->is_sort_option['comment_count']='コメント数';
$lang->is_sort_option['readed_count']='閲覧数';
$lang->is_sort_option['voted_count']='推奨数';
