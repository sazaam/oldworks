<?php
$lang->cmd_layout_management='レイアウト設定';
$lang->cmd_layout_edit='レイアウト編集';
$lang->cmd_layout_copy='レイアウトコピー';
$lang->layout_name='レイアウト名';
$lang->layout_maker='レイアウト作者';
$lang->layout_license='ライセンス';
$lang->layout_history='変更内容 ';
$lang->layout_info='レイアウト情報';
$lang->layout_list='レイアウトリスト';
$lang->menu_count='メニュー数';
$lang->downloaded_list='ダウンロードリスト';
$lang->sitemap_with_homemenu='スタートメニューがあるサイトマップ';
$lang->layout_preview_content='内容が表示される部分です。';
$lang->not_support_layout_preview='スキン適用プレビューをサポートしません。';
$lang->not_apply_menu='レイアウトの一括適用';
$lang->cmd_move_to_installed_list='作成されたリスト表示';
$lang->about_downloaded_layouts='ダウンロードのレイアウトリスト';
$lang->about_title='モジュールとの連動をわかりやすく区分するためのタイトルを入力してください。';
$lang->about_not_apply_menu='チェックを入れると連動するすべてのメニューのモジュールのレイアウトを一括変更します。';
$lang->about_layout='レイアウトのモジュールはサイトのレイアウトを分かりやすく作成できるようにします。 レイアウトの設定とメニューのリンクで様々なモジュールで完成されたサイト構築ができます。 ブログまたは他のモジュールのレイアウトなどの削除・修正ができないレイアウトは、該当モジュールにて設定を行ってください。';
$lang->about_layout_code='下のレイアウトコードを修正し、保存するとサービスに反映されます。必ずプレビューで確認してから保存してください。XEのテンプレート文法は<a href="http://code.google.com/p/xe-core/wiki/TemplateSyntax" target="_blank">XEテンプレート</a>を参考してください。';
$lang->layout_export='エクスポート';
$lang->layout_btn_export='マイレイアウトをダウンロードする';
$lang->about_layout_export='カスタマイズした自分のレイアウトをエクスポートします。';
$lang->layout_import='インポート';
$lang->about_layout_import='インポートする場合、既存の修正されたレイアウトを上書きします。インポート前にエクスポートでバックアップすることをお勧めします。';
if(!is_array($lang->layout_manager)){
	$lang->layout_manager = array();
}
$lang->layout_manager['0']='レイアウトマネジャー';
$lang->layout_manager['1']='保存';
$lang->layout_manager['2']='取り消し';
$lang->layout_manager['3']='基本レイアウト';
$lang->layout_manager['4']='配列';
$lang->layout_manager['5']='整列';
$lang->layout_manager['6']='固定型レイアウト';
$lang->layout_manager['7']='可変型レイアウト';
$lang->layout_manager['8']='固定+(内容部分)可変';
$lang->layout_manager['9']='1段';
$lang->layout_manager['10']='2段 (内容左側配置)';
$lang->layout_manager['11']='2段 (内容右側配置)';
$lang->layout_manager['12']='3段 (内容左側配置)';
$lang->layout_manager['13']='3段 (内容中央配置)';
$lang->layout_manager['14']='3段 (内容右側配置)';
$lang->layout_manager['15']='左';
$lang->layout_manager['16']='中央';
$lang->layout_manager['17']='右';
$lang->layout_manager['18']='すべて';
$lang->layout_manager['19']='レイアウト';
$lang->layout_manager['20']='ウィジェット追加';
$lang->layout_manager['21']='内容 ウィジェット追加';
$lang->layout_manager['22']='属性';
$lang->layout_manager['23']='ウィジェットスタイル';
$lang->layout_manager['24']='修正';
$lang->layout_manager['25']='削除';
$lang->layout_manager['26']='整列';
$lang->layout_manager['27']='一行占め';
$lang->layout_manager['28']='左';
$lang->layout_manager['29']='右';
$lang->layout_manager['30']='横幅サイズ';
$lang->layout_manager['31']='高さ';
$lang->layout_manager['32']='外側余白';
$lang->layout_manager['33']='内側余白';
$lang->layout_manager['34']='上';
$lang->layout_manager['35']='左';
$lang->layout_manager['36']='右';
$lang->layout_manager['37']='下';
$lang->layout_manager['38']='ボーダー';
$lang->layout_manager['39']='なし';
$lang->layout_manager['40']='背景';
$lang->layout_manager['41']='色';
$lang->layout_manager['42']='画像';
$lang->layout_manager['43']='選択';
$lang->layout_manager['44']='背景画像繰り返し';
$lang->layout_manager['45']='繰り返し';
$lang->layout_manager['46']='繰り返ししない';
$lang->layout_manager['47']='横方向繰り返し';
$lang->layout_manager['48']='縦方向繰り返し';
$lang->layout_manager['49']='適用';
$lang->layout_manager['50']='取り消し';
$lang->layout_manager['51']='初期化';
$lang->layout_manager['52']='文字';
$lang->layout_manager['53']='文字フォント';
$lang->layout_manager['54']='文字の色';
$lang->layout_image_repository='レイアウトファイル保存場所';
$lang->about_layout_image_repository='選択したレイアウトに使う画像・Flashファイル等のアップロードできます。また、エクスポートする際、一緒に含まれます。';
$lang->msg_layout_image_target='gif, png, jpg, swf, flvファイルのみ可能です。';
$lang->layout_migration='レイアウトのエクスポート/インポート';
$lang->about_layout_migration='修正したレイアウトをtar形式の圧縮ファイルにエクスポートしたり、tar形式として保存されたファイルをインポートすることができます。
(まだ、faceOffレイアウトのみエクスポート/インポートが可能です。)';
if(!is_array($lang->about_faceoff)){
	$lang->about_faceoff = array();
}
$lang->about_faceoff['title']='XpressEngine FaceOff レイアウト管理ツール';
$lang->about_faceoff['description']='FaceOffレイアウト管理ツールでウェブ上で、かんたんにレイアウトを変更することができます。 下の図を参照しながら構成要素と機能を理解し、自由にレイアウトをカスタマイズしてみてください。';
$lang->about_faceoff['layout']='FaceOffは上記のようなHTML構造になっています。 この構造にてCSSを用いた「レイアウト／配列／整列」の調整が可能になり、さらにStyleを使った自由なカスタマイズができます。 ウィジェットの追加はExtension(e1、e2)と Neck、 Kneeにて可能です。 その他にもBody、Layout、Header、Body、FooterはStyleをカスタマイズができ、Contentではモジュールの内容が出力されます。';
$lang->about_faceoff['setting']='左上メニューの説明<br/><ul><li>保存 : 設定内容を保存します。</li><li>取り消し : 設定内容を保存せずに、差し戻します。</li><li>初期化 : 何の設定もない白紙状態（もしくはインストール時のデフォールト状態）に戻ります。</li><li>レイアウトタイプ : 固定／可変／固定+可変（内容）型のレイアウトを指定します。</li><li>配列 : Body部分に2つのExtensionとContentを配列します。</li><li>整列 : レイアウトの位置を整列します。</li></ul>';
$lang->about_faceoff['hotkey']='マウスを使って各領域を選択しながら、Hot Keyを利用すると、より便利なカスタマイズできます。<br/><ul><li>tabキー : ウィジェットが選択されてない場合、Header、Body、 Footer順に選択されます。ウィジェットが選択されている場合は、次のウィジェットに選択されます。</li><li>Shift + tabキー : tabキーと逆の役割をします。</li><li>Esc : 何も選択されてない場合、Escを押すとNeck、Extension(e1、e2)、Knee順に選択され、また、ウィジェットが選択されている場合は選択されたウィジェットを囲む領域が選択されます。</li><li>矢印 : ウィジェットが選択されている時、矢印キーを用いて、ウィジェットを他の領域に移せます。</li></ul>';
$lang->about_faceoff['attribute']='ウィジェットを除いた各領域はすべて背景の色・イメージ・文字のテキスト色(「a」タグを含む)の指定が可能です。';
$lang->mobile_layout_list='モバイルレイアウトリスト';
$lang->mobile_downloaded_list='ダウンロードしたモバイルレイアウト';
$lang->apply_mobile_view='モバイルスキン使用';
$lang->about_apply_mobile_view='チェックを入れると、繋がっているすべてのモジュールでモバイルスキンが適用されます。';
$lang->installed_layout='インストールされているレイアウト';
$lang->instance_layout='インストールされているレイアウト';
$lang->faceoff_export='Faceoffレイアウトをエクスポートする';
$lang->about_faceoff_export='FaceOffレイアウトをtarファイルでエクスポートすることができます。バックアップしたFaceOffレイアウトを一般レイアウトに変更してください。';
if(!is_array($lang->faceoff_migration)){
	$lang->faceoff_migration = array();
}
$lang->faceoff_migration['0']='FaceOffレイアウトは、サポートが中断される予定です。必ず案内に従って、FaceOffレイアウトを一般レイアウトに変更してください。';
$lang->faceoff_migration['1']='FaceOffレイアウト変更案内';
$lang->faceoff_migration['2']='使用中のFaceOffレイアウトのエクスポートを通じてレイアウトをバックアップします。';
$lang->faceoff_migration['3']='ダウンロードしたtarファイルの圧縮を解凍します。';
$lang->faceoff_migration['4']='フォルダ名を任意の名前に変更します。';
$lang->faceoff_migration['5']='FTPを通じて ./layoutsにアップロードします。';
$lang->faceoff_migration['6']='レイアウトリストでアップロードしたレイアウトを利用してレイアウトを生成します。このとき、レイアウトのパスが、アップロードしたパスであるか確認してください。ロゴイメージはなどレイアウトの設定は、改めて行ってください。';
$lang->msg_empty_origin_layout='原本レイアウトがありません。';
$lang->msg_empty_target_layout='コピーするレイアウトが指定されていません。';
$lang->msg_at_least_one_layout='該当レイアウトの最後１個のレイアウトは削除できません。';
$lang->use_site_default_layout='サイトデフォルトレイアウト使用';
$lang->msg_unabled_preview='該当メニュータイプのページが１つもないため、プレビューが不可能です。';
$lang->article_preview_title='ドキュメントのタイトルです。';
$lang->article_preview_content='だるまさんがころんだ。';
