<?php
$lang->editor_now='현재 설정 상태';
$lang->editor_component='Editor Component';
$lang->main_editor='Main editor';
$lang->comment_editor='Comment editor';
$lang->editor_option='Editor Option';
$lang->guide_choose_main_editor='Main editor.';
$lang->guide_set_height_main_editor='Height of the main editor.';
$lang->guide_choose_comment_editor='Comment editor.';
$lang->guide_set_height_comment_editor='Height of the comment editor.';
$lang->guide_choose_text_formatting='Text formatting';
$lang->guide_choose_font_body='Font body';
$lang->guide_choose_font_size_body='Size body';
$lang->font_preview='The quick brown fox jumps over the lazy dog.
いろはにほへと / ちりぬるを / わかよたれそ / つねならむ / うゐのおくやま / けふこえて / あさきゆめみし / ゑひもせす
키스의 고유 조건은 입술끼리 만나야 하고 특별한 기술은 필요치 않다.';
$lang->msg_avail_easy_update='There is new version for this item.';
$lang->msg_do_you_like_update='Would you like to update?';
$lang->msg_font_too_big='The font is too big.';
$lang->editor='Tel-tel Editeur';
$lang->component_name='Composant';
$lang->component_version='Version';
$lang->component_author='Développeur';
$lang->component_link='Lien';
$lang->component_date='Jour de Création';
$lang->component_license='Licence';
$lang->component_history='Histoire';
$lang->component_description='Description';
$lang->component_extra_vars='Variables d\'Option';
$lang->component_grant='Configuration de la Permission';
$lang->content_style='Content Style';
$lang->content_font='Content Font';
$lang->content_font_size='Content Font Size';
$lang->about_component='Sur le Composant';
$lang->about_component_mid='Vous pouvez désigner les objectifs auquels les composants s\'appliquent(Tous les objectifs auront la Permission quand rien n\'est choisi.)';
$lang->msg_component_is_not_founded='Ne peut pas trouver Composant %s';
$lang->msg_component_is_inserted='Composant choisi est déjà entré';
$lang->msg_component_is_first_order='Composant choisi est localisé à la première position';
$lang->msg_component_is_last_order='Composant choisi est localisé à la position dernière';
$lang->msg_load_saved_doc='Il y a un article conservé automatiquement. Voulez-vous le réstaurer? L\'esquisse conservé automatiquement va être débarrasser après conserver l\'article courant.';
$lang->msg_auto_saved='Conservé automatiquement';
$lang->cmd_disable='Invalider';
$lang->cmd_enable='Valider';
$lang->editor_skin='Habillage de l\'Editeur';
$lang->upload_file_grant='Permission de télécharger(téléverser) ';
$lang->enable_default_component_grant='Permission d\'utiliser les Composants Par Défaut';
$lang->enable_extra_component_grant='Permission d\'utiliser des composants';
$lang->enable_html_grant='Permission d\'utiliser HTML';
$lang->enable_autosave='Valider à conserver automatiquement';
$lang->height_resizable='Permettre de remettre l\'hauteur';
$lang->editor_height='Hauteur de l\'Editeur';
$lang->about_content_font='콤마(,)로 여러 폰트를 지정할 수 있습니다.';
$lang->about_content_font_size='12px, 1em등 단위까지 포함해서 입력해주세요.';
$lang->about_enable_autosave='Vous pouvez valider la fonction à Conserver Automatiquement pendant écrire des articles.';
if(!is_object($lang->edit)){
	$lang->edit = new stdClass();
}
$lang->edit->fontname='Police de caractères';
$lang->edit->fontsize='Mesure';
$lang->edit->use_paragraph='Fonctions sur Paragraphe';
if(!is_array($lang->edit->fontlist)){
	$lang->edit->fontlist = array();
}
$lang->edit->fontlist['arial']='Arial, Helvetica, sans-serif';
$lang->edit->fontlist['tahoma']='Tahoma, Geneva, sans-serif';
$lang->edit->fontlist['verdana']='Verdana, Geneva, sans-serif';
$lang->edit->fontlist['sans-serif']='Sans-serif';
$lang->edit->fontlist['georgia']='Georgia, \'Times New Roman\', Times, serif';
$lang->edit->fontlist['palatinoLinotype']='\'Palatino Linotype\', \'Book Antiqua\', Palatino, serif';
$lang->edit->fontlist['timesNewRoman']='\'Times New Roman\', Times, serif';
$lang->edit->fontlist['serif']='Serif';
$lang->edit->fontlist['courierNew']='\'Courier New\', Courier, monospace';
$lang->edit->fontlist['lucidaConsole']='\'Lucida Console\', Monaco, monospace';
$lang->edit->fontlist['meiryo']='\'メイリオ\', \'Meiryo\', Arial, Helvetica, sans-serif';
$lang->edit->fontlist['hiragino']='\'ヒラギノ角ゴ Pro\', \'Hiragino Kaku Gothic Pro\', Arial, Helvetica, sans-serif';
$lang->edit->fontlist['ms_pgothic']='\'ＭＳ Ｐゴシック\', \'MS PGothic\', Arial, Helvetica, sans-serif';
$lang->edit->header='Style';
if(!is_array($lang->edit->header_list)){
	$lang->edit->header_list = array();
}
$lang->edit->header_list['h1']='Titre 1';
$lang->edit->header_list['h2']='Titre 2';
$lang->edit->header_list['h3']='Titre 3';
$lang->edit->header_list['h4']='Titre 4';
$lang->edit->header_list['h5']='Titre 5';
$lang->edit->header_list['h6']='Titre 6';
$lang->edit->submit='Soumettre';
$lang->edit->fontcolor='Text Color';
$lang->edit->fontbgcolor='Background Color';
$lang->edit->bold='Bold';
$lang->edit->italic='Italic';
$lang->edit->underline='Underline';
$lang->edit->strike='Strikethrough';
$lang->edit->sup='Super';
$lang->edit->sub='Sub';
$lang->edit->redo='Redo';
$lang->edit->undo='Undo';
$lang->edit->align_left='Align Left';
$lang->edit->align_center='Align Center';
$lang->edit->align_right='Align Right';
$lang->edit->align_justify='Align Justify';
$lang->edit->add_indent='Indent';
$lang->edit->remove_indent='Outdent';
$lang->edit->list_number='Orderd List';
$lang->edit->list_bullet='Unordered List';
$lang->edit->remove_format='Style Remover';
$lang->edit->help_remove_format='Supprimer les balises dans l\'endroit sélectionné';
$lang->edit->help_strike_through='Représenter la ligne d\'annulation sur les lettres.';
$lang->edit->help_align_full='Aligner pleinement selon largeur';
$lang->edit->help_fontcolor='Désigner la couleur de la Police de caractères';
$lang->edit->help_fontbgcolor='Désigner la couleur de l\'arrière-plan de la Police de caractères.';
$lang->edit->help_bold='Caractère gras';
$lang->edit->help_italic='Caractère italique';
$lang->edit->help_underline='Caractère souligné';
$lang->edit->help_strike='Caractère biffé';
$lang->edit->help_sup='Sup';
$lang->edit->help_sub='Sub';
$lang->edit->help_redo='Réfaire';
$lang->edit->help_undo='Annuler';
$lang->edit->help_align_left='Aligner à gauche';
$lang->edit->help_align_center='Aligner centr';
$lang->edit->help_align_right='Aligner  droite';
$lang->edit->help_align_justify='Align justity';
$lang->edit->help_add_indent='Ajouter un Rentré';
$lang->edit->help_remove_indent='Enlever un Rentré';
$lang->edit->help_list_number='Appliquer la liste numroté';
$lang->edit->help_list_bullet='Appliquer la liste à puces';
$lang->edit->help_use_paragraph='Appuyez Ctrl+Enter pour séparer les paragraphe. (Appuyez Alt+S pour conserver)';
$lang->edit->url='URL';
$lang->edit->blockquote='Blockquote';
$lang->edit->table='Table';
$lang->edit->image='Image';
$lang->edit->multimedia='Video';
$lang->edit->emoticon='Emoticon';
$lang->edit->upload='Attacher';
$lang->edit->upload_file='Attacher un(des) Fichier(s)';
$lang->edit->link_file='Insérer dans le Texte';
$lang->edit->delete_selected='Delete Selected';
$lang->edit->icon_align_article='Occuper un paragraphe';
$lang->edit->icon_align_left='Placer à gauche du texte';
$lang->edit->icon_align_middle='Placer au centre';
$lang->edit->icon_align_right='Placer à droite du texte';
$lang->edit->rich_editor='Rich Text Editor';
$lang->edit->html_editor='HTML Editor';
$lang->edit->extension='Extension Components';
$lang->edit->help='Help';
$lang->edit->help_command='Help Hotkeys';
$lang->edit->lineheight='Line Height';
$lang->edit->fontbgsampletext='ABC';
$lang->edit->hyperlink='Hyperlink';
$lang->edit->target_blank='새창으로';
$lang->edit->quotestyle1='Left Solid';
$lang->edit->quotestyle2='Quote';
$lang->edit->quotestyle3='Solid';
$lang->edit->quotestyle4='Solid + Background';
$lang->edit->quotestyle5='Bold Solid';
$lang->edit->quotestyle6='Dotted';
$lang->edit->quotestyle7='Dotted + Background';
$lang->edit->quotestyle8='Cancel';
$lang->edit->jumptoedit='Skip Edit Toolbox';
$lang->edit->set_sel='Set Cell Count';
$lang->edit->row='Row';
$lang->edit->col='Column';
$lang->edit->add_one_row='1행추가';
$lang->edit->del_one_row='1행삭제';
$lang->edit->add_one_col='1열추가';
$lang->edit->del_one_col='1열삭제';
$lang->edit->table_config='Table Properties';
$lang->edit->border_width='Border Width';
$lang->edit->border_color='Border Color';
$lang->edit->add='Add';
$lang->edit->del='Sub';
$lang->edit->search_color='색상찾기';
$lang->edit->table_backgroundcolor='Table Background Color';
$lang->edit->special_character='Special Characters';
$lang->edit->insert_special_character='Insert Special Characters';
$lang->edit->close_special_character='Close Special Characters Layer';
$lang->edit->symbol='Symbols';
$lang->edit->number_unit='Numbers and Units';
$lang->edit->circle_bracket='원,괄호';
$lang->edit->korean='Korean';
$lang->edit->greece='Greek';
$lang->edit->Latin='Latin';
$lang->edit->japan='Japanese';
$lang->edit->selected_symbol='Selected Symbols';
$lang->edit->search_replace='Find/Replace';
$lang->edit->close_search_replace='Close Find/Replace Layer';
$lang->edit->replace_all='모두바꾸기';
$lang->edit->search_words='찾을단어';
$lang->edit->replace_words='바꿀단어';
$lang->edit->next_search_words='다음찾기';
$lang->edit->edit_height_control='Set Edit Form Size';
$lang->edit->edit_height_auto='Auto-resize editor';
$lang->edit->merge_cells='Merge Table Cells';
$lang->edit->split_row='Split Row';
$lang->edit->split_col='Split Column';
$lang->edit->toggle_list='Fold/Unfold';
$lang->edit->minimize_list='Minimize';
$lang->edit->refresh='Refresh';
$lang->edit->materials='글감보관함';
$lang->edit->temporary_savings='임시저장목록';
$lang->edit->paging_prev='Prev';
$lang->edit->paging_next='Next';
$lang->edit->paging_prev_help='Move to previous page.';
$lang->edit->paging_next_help='Move to next page.';
$lang->edit->toc='Table of Contents';
$lang->edit->close_help='Close Help';
$lang->edit->confirm_submit_without_saving='There are paragraphs which were not saved.\nProceed anyway?';
$lang->edit->image_align='Image Alignment';
$lang->edit->attached_files='Attachments';
$lang->about_dblclick_in_editor='Vous pouvez configurer en détail des composants par double-clic sur un arrière-plan, un texte, une image ou une citation';
