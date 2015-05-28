<?php
$lang->introduce_title='Installation du XE ';
$lang->enviroment_gather='Agreement on gathering installation environment information';
$lang->input_dbinfo_by_dbtype='Input %s info';
if(!is_array($lang->install_progress_menu)){
	$lang->install_progress_menu = array();
}
$lang->install_progress_menu['language']='Select language';
$lang->install_progress_menu['condition']='Check the installation conditions';
$lang->install_progress_menu['ftp']='Input FTP information';
$lang->install_progress_menu['dbSelect']='Choose database type';
$lang->install_progress_menu['dbInfo']='Input Database information';
$lang->install_progress_menu['configInfo']='Settings';
$lang->install_progress_menu['adminInfo']='Enter Administrator information';
$lang->install_condition_enable='You can Install.';
$lang->install_details='Details';
$lang->install_simply='Simply';
$lang->advanced_setup='Advanced Setup';
$lang->install_ftp_reason='Reason of FTP info is needed.';
if(!is_array($lang->install_checklist_title)){
	$lang->install_checklist_title = array();
}
$lang->install_checklist_title['php_version']='Version de PHP';
$lang->install_checklist_title['permission']='Autorisation';
$lang->install_checklist_title['xml']='Bibliothèque de XML';
$lang->install_checklist_title['iconv']='Bibliothèque de ICONV';
$lang->install_checklist_title['gd']='Bibliothèque de GD';
$lang->install_checklist_title['session']='Configuration de Session.auto_start';
$lang->install_checklist_title['db']='DB';
if(!is_array($lang->install_checklist_desc)){
	$lang->install_checklist_desc = array();
}
$lang->install_checklist_desc['php_version']='[Required] XE supports only PHP Version 5.2.4 or higher';
$lang->install_checklist_desc['php_version_warning']='[Recommend] XE recommends only PHP Version 5.3.10 or higher';
$lang->install_checklist_desc['permission']='[Obligatoire] Chemin de l\'installation de XE ou la permission de  répertoire de ./files doit être 707';
$lang->install_checklist_desc['xml']='[Obligatoire] La bibliothèque de XML est nécessaire pour la communication de XML';
$lang->install_checklist_desc['session']='[Obligatoire] \'Session.auto_start\' dans le fichier de configuration pour PHP (php.ini) doit être égal à zéro car XE utilise la session';
$lang->install_checklist_desc['iconv']='Iconv doit être installé afin de convertir UTF-8 et des autres assortiments des  langues';
$lang->install_checklist_desc['gd']='La bibliothèque de GD doit être installé afin d\'utiliser la fonction à convertir des images';
$lang->install_checklist_xml='Installation la bibliothèque de XML';
$lang->install_without_xml='La bibliothèque de XML n\'est pas installée';
$lang->install_checklist_gd='Installation la bibliothèque de  GD';
$lang->install_without_gd='La bibliothèque de GD pour convertir des images n\'est pas installée';
$lang->install_without_iconv='La bibliothèque d\'Iconv pour traiter les caractères  n\'est pas installée';
$lang->install_session_auto_start='Des problèmes possibles peuvent avoir lieu car  session.auto_start==1 dans la configuration de PHP';
$lang->install_permission_denied='La permission du chemin d\'installation n\'est pas égale à 707';
$lang->install_notandum='All form must be filled, but you can modify all of settings after finish the installation.';
$lang->cmd_install_fix_checklist='J\'ai corrigé les conditions obligatoires.';
$lang->cmd_install_next='Continuer à  installer';
$lang->cmd_ignore='Ignore';
if(!is_array($lang->db_desc)){
	$lang->db_desc = array();
}
$lang->db_desc['mysql']='Utilisera fonction mysql*() pour utiliser la base de données de mysql.<br />La transaction sera invalidé parce que le fichier de Base de Données est créé par myisam.';
$lang->db_desc['mysqli_innodb']='Utilisera innodb pour utiliser Base de Données de mysql.<br />La transaction sera validé pour innodb';
$lang->db_desc['mysqli']='Utilisera fonction mysqli*() pour utiliser la base de données de mysql.<br />La transaction sera invalidé parce que le fichier de Base de Données est créé par myisam.';
$lang->db_desc['mysql_innodb']='Utilisera innodb pour utiliser Base de Données de mysql.<br />La transaction sera validé pour innodb';
$lang->db_desc['cubrid']='Utiliser la Base de Données de CUBRID.  <a href="http://www.cubrid.org/wiki_tutorials/entry/cubrid-installation-instructions" target="_blank">Manual</a>';
$lang->db_desc['mssql']='Utiliser la Base de Données de MSSQL.';
$lang->can_use_when_installed='You can use when it has installed.';
$lang->form_title='Entrer des informations de Base de données et Administrateur';
$lang->db_title='Entrez l\'information de Base de Données, S.V.P.';
$lang->db_type='Sorte de Base de Données';
$lang->select_db_type='Choisissez la Base de Données que vous voulez utiliser.';
$lang->db_hostname='Hostname(Nom de l\'ordinateur central) de Base de Données (LOCALHOST généralement)';
$lang->db_port='Port de Base de Données';
$lang->db_userid='Compte(ID) pour le Base de Données';
$lang->db_password='Mot de passe pour le Base de Données';
$lang->db_name='DB Nom';
$lang->db_database_file='Fichier de Base de Données';
$lang->db_table_prefix='En-tête de la table';
$lang->db_info_desc='<p>Please check <strong>database information</strong> to server master.</p>';
$lang->db_prefix_desc='<p>Please check <strong>database information</strong> to server master.</p><p>You can modify database <strong>table prefix</strong>, and can use small letters(small letter is recommended), and numbers, but you can not use special letters.</p>';
$lang->admin_title='Informations d\'Administrateur';
$lang->env_title='Settings';
$lang->use_optimizer='Valider Optimiseur';
$lang->about_optimizer='Si l\'optimiseur est validé, utilisateur peut accéder rapidement ce site parce que plusieurs fichiers de CSS / JS sont reliés ensemble et comprimés avant transmission. <br /> Néanmoins, cette optimisation peut arriver problématique selong CSS ou JS. Si vous l\'invalidez, ça marchera correctement pourtant il marchera plus lentement.';
$lang->use_rewrite='Utiliser mode de récrire(rewrite mod)';
$lang->use_sso='<abbr title="Single Sign On">SSO</abbr>';
$lang->about_rewrite='Si le serveur de web est capable d\'utiliser le mode de récrire, URL longue comme http://murmure/?document_srl=123 peut être abrégé comme http://murmure/123';
$lang->disable_rewrite='Required module for "Friendly URL" feature is not found. Please check with the web master about <strong>rewrite_mod</strong> module support.';
$lang->about_nginx_rewrite='For using "Friendly URL" feature at Nginx, need to configure rewrites at Nginx. show  <a href="https://github.com/xpressengine/xe-core/wiki/Nginx-rewite-%EC%84%A4%EC%A0%95%ED%95%98%EA%B8%B0" target="_blank"><strong>here</strong></a>.';
$lang->time_zone='Fuseau horaire';
$lang->about_time_zone='Si l\'heure de serveur et celle de votre emplacement ne s\'accordent pas,  vous pouvez remettre l\'heure comme le même heure de votre lieu en configurant le fuseau horaire ';
$lang->qmail_compatibility='Compatible avec Qmail';
$lang->about_qmail_compatibility='Le mél sera envoyé en MTA qui ne peut pas reconnaître le CRLF comme délimiteur des lignes comme le Qmail.';
$lang->about_database_file='Sqlite conserve des données dans le fichier. Vous devez placer le fichier de la base de données où l\'on ne peut pas accéder par web.<br/><span style="color:red">Le fichier des Donées doit être en dedans la permission 707.</span>';
$lang->success_installed='Installation s\'est complété';
$lang->msg_cannot_proc='Environnement d\'Installation n\'est pas équipé à procéder.';
$lang->msg_already_installed='XE est déjà installé';
$lang->msg_dbconnect_failed='Erreur a lieu en essayant connecter à la Base de Données. Vérifiez encore une fois les informations sur la Base de Données, S.V.P.';
$lang->msg_table_is_exists='La Table est déjà créée dans la Base de Données. Le fichier de Configuration est recréé.';
$lang->msg_install_completed='Installation a complété. Merci pour choisir XE';
$lang->msg_install_failed='Une erreur a lieu en créant le fichier d\'installation.';
$lang->ftp_get_list='Get List';
$lang->install_env_agreement='Agreement on gathering installation environment information';
$lang->install_env_agreement_desc='Information on \'<strong>web server, DBMS, PHP version and extension, XE modules and addons</strong>\' is sent to the XE statistics collection server. This information is collected anonymously and used to improve our software only. <strong>You don\'t have to agree to this.</strong>';
$lang->ftp_form_title='FTP 정보 입력';
$lang->ftp='FTP';
$lang->ftp_host='FTP hostname';
$lang->ftp_port='FTP port';
$lang->about_ftp_password='FTP password will not be stored.';
$lang->cmd_check_ftp_connect='Check FTP Connection';
$lang->msg_safe_mode_ftp_needed='PHP의 safe_mode가 On일 경우 FTP 정보를 꼭 입력해야 XE의 설치 및 사용이 가능합니다';
$lang->msg_safe_mode_ftp_needed2='Easy installation or update of module is enabled.';
$lang->msg_safe_mode_ftp_config='This information is stored in <strong>files/config/ftp.config.php</strong>. You can add, change or delete this on the Settings page after the installation.';
$lang->msg_ftp_not_connected='localhost로의 FTP 접속 오류가 발생하였습니다. ftp 포트 번호를 확인하거나 ftp 서비스가 가능한지 확인해주세요';
$lang->msg_ftp_invalid_auth_info='입력한 FTP 정보로 로그인을 하지 못했습니다. FTP정보를 확인해주세요';
$lang->msg_ftp_mkdir_fail='FTP를 이용한 디렉토리 생성 명령을 실패하였습니다. FTP 서버의 설정을 확인해주세요';
$lang->msg_ftp_chmod_fail='FTP를 이용한 디렉토리의 속성 변경을 실패하였습니다. FTP 서버의 설정을 확인해주세요';
$lang->msg_ftp_connect_success='FTP 접속 및 인증 성공하였습니다';
$lang->ftp_path_title='FTP Path Information';
$lang->msg_ftp_installed_realpath='Absolute Path of XE';
$lang->msg_ftp_installed_ftp_realpath='설치된 XE의 FTP 절대경로';
$lang->db_config_php_validation='Validation of db.config.php';
$lang->msg_possible_only_file='You can upload files only.';