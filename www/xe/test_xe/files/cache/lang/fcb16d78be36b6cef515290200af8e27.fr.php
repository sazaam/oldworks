<?php
$lang->cmd_sync_member='Synchroniser';
$lang->cmd_continue='Continuer';
$lang->preprocessing='On est en train de préparer pour transférer les données.';
$lang->importer='Transférer les Données du XE';
$lang->source_type='Sorte de la Source';
$lang->type_member='Données des Membres';
$lang->type_message='Données des Messages';
$lang->type_ttxml='TTXML';
$lang->type_module='Données des Articles';
$lang->type_syncmember='Synchroniser les Données des Membres';
$lang->target_module='Module objectif';
$lang->xml_file='Fichier en XML';
if(!is_array($lang->import_step_title)){
	$lang->import_step_title = array();
}
$lang->import_step_title['1']='Pas 1. Choisir l\'objet à transférer';
$lang->import_step_title['12']='Pas 1-2. Choisir le module à transférer';
$lang->import_step_title['13']='Pas 1-3. Choisir la catégorie à transférer';
$lang->import_step_title['2']='Pas 2. Télécharger fichier en XML';
$lang->import_step_title['3']='Pas 2. Synchroniser données des membres et des articles';
$lang->import_step_title['99']='Trensférer des données';
if(!is_array($lang->import_step_desc)){
	$lang->import_step_desc = array();
}
$lang->import_step_desc['1']='Choisissez la sorte du fichier en XML que vous voulez transférer.';
$lang->import_step_desc['12']='Choisissez le module objectif dans lequel vous voulez tranférer les données.';
$lang->import_step_desc['121']='Posts:';
$lang->import_step_desc['122']='Guestbook:';
$lang->import_step_desc['13']='Choisissez la catégorie objective dans laquelle vous voulez transférer les données.';
$lang->import_step_desc['2']='Entrez le chemin du fichier en XML pour transférer les données.
S\'il est localisé dans le même compte, entréz le chemin absolut ou relatif. Sinon, entrez l\'URL commençant avec http://..';
$lang->import_step_desc['3']='Les données des membres et ceux des articles peuvent ne pas s\'accorder après la transfèrement. Dans ce cas, synchronisez S.V.P. Ça arrangera les données en étant basé sur le compte d\'utilisateur.';
$lang->import_step_desc['99']='En train de transférer';
$lang->xml_path='Please enter the path of XML file.';
$lang->data_destination='Select the destination of data.';
$lang->document_destination='ドキュメントデータの目的地を選択してください。';
$lang->guestbook_destination='Select the destination of guestbook data.';
$lang->msg_sync_member='On commencera à synchroniser les données des membres et des articles quand vous cliquez le bouton de synchroniser.';
$lang->found_xml_file='found XML file';
$lang->not_found_xml_file='Can not found XML file';
$lang->cannot_allow_fopen_in_phpini='Can not found XML file';
$lang->cannot_url_file='Can not found XML file';
$lang->cmd_check_path='Check the path';
$lang->msg_exist_xml_file='Found the XML file.';
$lang->msg_no_xml_file='On ne peut pas trouver le fichier de XML. Vérifiez le chemin encore une fois, S.V.P.';
$lang->msg_invalid_xml_file='Ce fichier de XML est invalide.';
$lang->msg_importing='On écrit %d données sur %d. (Si c\'est arrêté longtemps, cliquez le bouton "Continuer")';
$lang->msg_import_finished='%d/%d données sont entrées complètement. En dépendant sur la situation, il y aura quelques données qui n\'ont pas été entrées.';
$lang->msg_sync_completed='On a terminé de synchroniser les données des membres, des articles et des commentaires.';
$lang->about_type_member='Choisissez cette option si vous voulez transférer les informations des membres';
$lang->about_type_message='Choisissez cette option si vous voulez transférer les informations des messages';
$lang->about_type_ttxml='Choisissez cette option si vous voulez transférer les informations des TTXML(textcube)';
$lang->about_ttxml_user_id='Entrez le compte d\'utilisateur pour déclarer comme l\'auteur. (Le compte d\'utilisateur doit être déjà inscrit)';
$lang->about_type_module='Choisissez cette option si vous voulez transférer les informations des panneaux ou des articles.';
$lang->about_type_syncmember='Choisissez cette option si vous voulez synchroniser les informations des membres après le transfér des informations des membres et des articles.';
$lang->about_importer='Vous pouvez transférer les données de Zeroboard4, de Zeroboard5 Beta ou d\'autres logiciels aux données de XE.
Pour transférer, vous devez utiliser <a href="http://www.xpressengine.com/index.php?mid=download&category_srl=18324038" target="_blank">Exporteur de XML</a> pour convertir les données en fichier de XML, et puis téléchargez-le.';
$lang->about_target_path='Pour obtenir les attachés de Zeroboard4, Entrez l\'adresse où Zeroboard4 est installé.
Si elle se trouve dans le même serveur, entrez le chemin comme \'/home/USERID/public_html/bbs\'
Si elle ne se trouve pas dans le même serveur, entrez l\'adresse où Zeroboard4 est installé comme \'http://Domain/bbs\'';
