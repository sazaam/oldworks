<?php if(!defined("__XE__")) exit();
$info = new stdClass;
$info->default_index_act = '';
$info->setup_index_act='';
$info->simple_setup_index_act='';
$info->admin_index_act = 'dispAutoinstallAdminIndex';
$info->menu = new stdClass;
$info->menu->easyInstall = new stdClass;
$info->menu->easyInstall->title='簡単インストール';
$info->menu->easyInstall->type='';
$info->action = new stdClass;
$info->menu->easyInstall->acts[0]='dispAutoinstallAdminInstall';
$info->action->dispAutoinstallAdminInstall = new stdClass;
$info->action->dispAutoinstallAdminInstall->type='view';
$info->action->dispAutoinstallAdminInstall->grant='guest';
$info->action->dispAutoinstallAdminInstall->standalone='true';
$info->action->dispAutoinstallAdminInstall->ruleset='';
$info->action->dispAutoinstallAdminInstall->method='';
$info->menu->easyInstall->acts[1]='dispAutoinstallAdminUninstall';
$info->action->dispAutoinstallAdminUninstall = new stdClass;
$info->action->dispAutoinstallAdminUninstall->type='view';
$info->action->dispAutoinstallAdminUninstall->grant='guest';
$info->action->dispAutoinstallAdminUninstall->standalone='true';
$info->action->dispAutoinstallAdminUninstall->ruleset='';
$info->action->dispAutoinstallAdminUninstall->method='';
$info->action->procAutoinstallAdminUninstallPackage = new stdClass;
$info->action->procAutoinstallAdminUninstallPackage->type='controller';
$info->action->procAutoinstallAdminUninstallPackage->grant='guest';
$info->action->procAutoinstallAdminUninstallPackage->standalone='true';
$info->action->procAutoinstallAdminUninstallPackage->ruleset='ftp';
$info->action->procAutoinstallAdminUninstallPackage->method='';
$info->menu->easyInstall->acts[2]='dispAutoinstallAdminInstalledPackages';
$info->action->dispAutoinstallAdminInstalledPackages = new stdClass;
$info->action->dispAutoinstallAdminInstalledPackages->type='view';
$info->action->dispAutoinstallAdminInstalledPackages->grant='guest';
$info->action->dispAutoinstallAdminInstalledPackages->standalone='true';
$info->action->dispAutoinstallAdminInstalledPackages->ruleset='';
$info->action->dispAutoinstallAdminInstalledPackages->method='';
$info->menu->easyInstall->index='dispAutoinstallAdminIndex';
$info->menu->easyInstall->acts[3]='dispAutoinstallAdminIndex';
$info->action->dispAutoinstallAdminIndex = new stdClass;
$info->action->dispAutoinstallAdminIndex->type='view';
$info->action->dispAutoinstallAdminIndex->grant='guest';
$info->action->dispAutoinstallAdminIndex->standalone='true';
$info->action->dispAutoinstallAdminIndex->ruleset='';
$info->action->dispAutoinstallAdminIndex->method='';
$info->action->procAutoinstallAdminUpdateinfo = new stdClass;
$info->action->procAutoinstallAdminUpdateinfo->type='controller';
$info->action->procAutoinstallAdminUpdateinfo->grant='guest';
$info->action->procAutoinstallAdminUpdateinfo->standalone='true';
$info->action->procAutoinstallAdminUpdateinfo->ruleset='';
$info->action->procAutoinstallAdminUpdateinfo->method='';
$info->action->procAutoinstallAdminPackageinstall = new stdClass;
$info->action->procAutoinstallAdminPackageinstall->type='controller';
$info->action->procAutoinstallAdminPackageinstall->grant='guest';
$info->action->procAutoinstallAdminPackageinstall->standalone='true';
$info->action->procAutoinstallAdminPackageinstall->ruleset='ftp';
$info->action->procAutoinstallAdminPackageinstall->method='';
$info->action->getAutoinstallAdminMenuPackageList = new stdClass;
$info->action->getAutoinstallAdminMenuPackageList->type='model';
$info->action->getAutoinstallAdminMenuPackageList->grant='guest';
$info->action->getAutoinstallAdminMenuPackageList->standalone='true';
$info->action->getAutoinstallAdminMenuPackageList->ruleset='';
$info->action->getAutoinstallAdminMenuPackageList->method='';
$info->action->getAutoinstallAdminLayoutPackageList = new stdClass;
$info->action->getAutoinstallAdminLayoutPackageList->type='model';
$info->action->getAutoinstallAdminLayoutPackageList->grant='guest';
$info->action->getAutoinstallAdminLayoutPackageList->standalone='true';
$info->action->getAutoinstallAdminLayoutPackageList->ruleset='';
$info->action->getAutoinstallAdminLayoutPackageList->method='';
$info->action->getAutoinstallAdminSkinPackageList = new stdClass;
$info->action->getAutoinstallAdminSkinPackageList->type='model';
$info->action->getAutoinstallAdminSkinPackageList->grant='guest';
$info->action->getAutoinstallAdminSkinPackageList->standalone='true';
$info->action->getAutoinstallAdminSkinPackageList->ruleset='';
$info->action->getAutoinstallAdminSkinPackageList->method='';
$info->action->getAutoinstallAdminIsAuthed = new stdClass;
$info->action->getAutoinstallAdminIsAuthed->type='model';
$info->action->getAutoinstallAdminIsAuthed->grant='guest';
$info->action->getAutoinstallAdminIsAuthed->standalone='true';
$info->action->getAutoinstallAdminIsAuthed->ruleset='';
$info->action->getAutoinstallAdminIsAuthed->method='';
$info->action->getAutoInstallAdminInstallInfo = new stdClass;
$info->action->getAutoInstallAdminInstallInfo->type='model';
$info->action->getAutoInstallAdminInstallInfo->grant='guest';
$info->action->getAutoInstallAdminInstallInfo->standalone='true';
$info->action->getAutoInstallAdminInstallInfo->ruleset='';
$info->action->getAutoInstallAdminInstallInfo->method='';
return $info;