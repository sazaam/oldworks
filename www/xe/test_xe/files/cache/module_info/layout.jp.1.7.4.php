<?php if(!defined("__XE__")) exit();
$info = new stdClass;
$info->default_index_act = '';
$info->setup_index_act='';
$info->simple_setup_index_act='';
$info->admin_index_act = 'dispLayoutAdminInstalledList';
$info->menu = new stdClass;
$info->menu->installedLayout = new stdClass;
$info->menu->installedLayout->title='レイアウト';
$info->menu->installedLayout->type='';
$info->action = new stdClass;
$info->action->dispLayoutInfo = new stdClass;
$info->action->dispLayoutInfo->type='view';
$info->action->dispLayoutInfo->grant='guest';
$info->action->dispLayoutInfo->standalone='true';
$info->action->dispLayoutInfo->ruleset='';
$info->action->dispLayoutInfo->method='';
$info->action->dispLayoutAdminContent = new stdClass;
$info->action->dispLayoutAdminContent->type='view';
$info->action->dispLayoutAdminContent->grant='guest';
$info->action->dispLayoutAdminContent->standalone='true';
$info->action->dispLayoutAdminContent->ruleset='';
$info->action->dispLayoutAdminContent->method='';
$info->action->dispLayoutAdminInfo = new stdClass;
$info->action->dispLayoutAdminInfo->type='view';
$info->action->dispLayoutAdminInfo->grant='guest';
$info->action->dispLayoutAdminInfo->standalone='true';
$info->action->dispLayoutAdminInfo->ruleset='';
$info->action->dispLayoutAdminInfo->method='';
$info->action->dispLayoutAdminLayoutModify = new stdClass;
$info->action->dispLayoutAdminLayoutModify->type='view';
$info->action->dispLayoutAdminLayoutModify->grant='guest';
$info->action->dispLayoutAdminLayoutModify->standalone='true';
$info->action->dispLayoutAdminLayoutModify->ruleset='';
$info->action->dispLayoutAdminLayoutModify->method='';
$info->action->dispLayoutAdminLayoutImageList = new stdClass;
$info->action->dispLayoutAdminLayoutImageList->type='view';
$info->action->dispLayoutAdminLayoutImageList->grant='guest';
$info->action->dispLayoutAdminLayoutImageList->standalone='true';
$info->action->dispLayoutAdminLayoutImageList->ruleset='';
$info->action->dispLayoutAdminLayoutImageList->method='';
$info->action->dispLayoutAdminMobileContent = new stdClass;
$info->action->dispLayoutAdminMobileContent->type='view';
$info->action->dispLayoutAdminMobileContent->grant='guest';
$info->action->dispLayoutAdminMobileContent->standalone='true';
$info->action->dispLayoutAdminMobileContent->ruleset='';
$info->action->dispLayoutAdminMobileContent->method='';
$info->menu->installedLayout->index='dispLayoutAdminInstalledList';
$info->menu->installedLayout->acts[0]='dispLayoutAdminInstalledList';
$info->action->dispLayoutAdminInstalledList = new stdClass;
$info->action->dispLayoutAdminInstalledList->type='view';
$info->action->dispLayoutAdminInstalledList->grant='guest';
$info->action->dispLayoutAdminInstalledList->standalone='true';
$info->action->dispLayoutAdminInstalledList->ruleset='';
$info->action->dispLayoutAdminInstalledList->method='';
$info->menu->installedLayout->acts[1]='dispLayoutAdminInstanceList';
$info->action->dispLayoutAdminInstanceList = new stdClass;
$info->action->dispLayoutAdminInstanceList->type='view';
$info->action->dispLayoutAdminInstanceList->grant='guest';
$info->action->dispLayoutAdminInstanceList->standalone='true';
$info->action->dispLayoutAdminInstanceList->ruleset='';
$info->action->dispLayoutAdminInstanceList->method='';
$info->menu->installedLayout->acts[2]='dispLayoutAdminAllInstanceList';
$info->action->dispLayoutAdminAllInstanceList = new stdClass;
$info->action->dispLayoutAdminAllInstanceList->type='view';
$info->action->dispLayoutAdminAllInstanceList->grant='guest';
$info->action->dispLayoutAdminAllInstanceList->standalone='true';
$info->action->dispLayoutAdminAllInstanceList->ruleset='';
$info->action->dispLayoutAdminAllInstanceList->method='';
$info->menu->installedLayout->acts[3]='dispLayoutAdminInsert';
$info->action->dispLayoutAdminInsert = new stdClass;
$info->action->dispLayoutAdminInsert->type='view';
$info->action->dispLayoutAdminInsert->grant='guest';
$info->action->dispLayoutAdminInsert->standalone='true';
$info->action->dispLayoutAdminInsert->ruleset='';
$info->action->dispLayoutAdminInsert->method='';
$info->menu->installedLayout->acts[4]='dispLayoutAdminModify';
$info->action->dispLayoutAdminModify = new stdClass;
$info->action->dispLayoutAdminModify->type='view';
$info->action->dispLayoutAdminModify->grant='guest';
$info->action->dispLayoutAdminModify->standalone='true';
$info->action->dispLayoutAdminModify->ruleset='';
$info->action->dispLayoutAdminModify->method='';
$info->menu->installedLayout->acts[5]='dispLayoutAdminEdit';
$info->action->dispLayoutAdminEdit = new stdClass;
$info->action->dispLayoutAdminEdit->type='view';
$info->action->dispLayoutAdminEdit->grant='guest';
$info->action->dispLayoutAdminEdit->standalone='true';
$info->action->dispLayoutAdminEdit->ruleset='';
$info->action->dispLayoutAdminEdit->method='';
$info->action->dispLayoutAdminCopyLayout = new stdClass;
$info->action->dispLayoutAdminCopyLayout->type='view';
$info->action->dispLayoutAdminCopyLayout->grant='guest';
$info->action->dispLayoutAdminCopyLayout->standalone='true';
$info->action->dispLayoutAdminCopyLayout->ruleset='';
$info->action->dispLayoutAdminCopyLayout->method='';
$info->action->getLayoutAdminSetInfoView = new stdClass;
$info->action->getLayoutAdminSetInfoView->type='model';
$info->action->getLayoutAdminSetInfoView->grant='guest';
$info->action->getLayoutAdminSetInfoView->standalone='true';
$info->action->getLayoutAdminSetInfoView->ruleset='';
$info->action->getLayoutAdminSetInfoView->method='';
$info->action->getLayoutAdminSetHTMLCSS = new stdClass;
$info->action->getLayoutAdminSetHTMLCSS->type='model';
$info->action->getLayoutAdminSetHTMLCSS->grant='guest';
$info->action->getLayoutAdminSetHTMLCSS->standalone='true';
$info->action->getLayoutAdminSetHTMLCSS->ruleset='';
$info->action->getLayoutAdminSetHTMLCSS->method='';
$info->action->getLayoutAdminSiteDefaultLayout = new stdClass;
$info->action->getLayoutAdminSiteDefaultLayout->type='model';
$info->action->getLayoutAdminSiteDefaultLayout->grant='guest';
$info->action->getLayoutAdminSiteDefaultLayout->standalone='true';
$info->action->getLayoutAdminSiteDefaultLayout->ruleset='';
$info->action->getLayoutAdminSiteDefaultLayout->method='';
$info->action->dispLayoutPreview = new stdClass;
$info->action->dispLayoutPreview->type='view';
$info->action->dispLayoutPreview->grant='guest';
$info->action->dispLayoutPreview->standalone='true';
$info->action->dispLayoutPreview->ruleset='';
$info->action->dispLayoutPreview->method='';
$info->action->dispLayoutPreviewWithModule = new stdClass;
$info->action->dispLayoutPreviewWithModule->type='view';
$info->action->dispLayoutPreviewWithModule->grant='guest';
$info->action->dispLayoutPreviewWithModule->standalone='true';
$info->action->dispLayoutPreviewWithModule->ruleset='';
$info->action->dispLayoutPreviewWithModule->method='';
$info->action->procLayoutAdminUpdate = new stdClass;
$info->action->procLayoutAdminUpdate->type='controller';
$info->action->procLayoutAdminUpdate->grant='guest';
$info->action->procLayoutAdminUpdate->standalone='true';
$info->action->procLayoutAdminUpdate->ruleset='updateLayout';
$info->action->procLayoutAdminUpdate->method='';
$info->action->procLayoutAdminCodeUpdate = new stdClass;
$info->action->procLayoutAdminCodeUpdate->type='controller';
$info->action->procLayoutAdminCodeUpdate->grant='guest';
$info->action->procLayoutAdminCodeUpdate->standalone='true';
$info->action->procLayoutAdminCodeUpdate->ruleset='codeUpdate';
$info->action->procLayoutAdminCodeUpdate->method='';
$info->action->procLayoutAdminUserImageUpload = new stdClass;
$info->action->procLayoutAdminUserImageUpload->type='controller';
$info->action->procLayoutAdminUserImageUpload->grant='guest';
$info->action->procLayoutAdminUserImageUpload->standalone='true';
$info->action->procLayoutAdminUserImageUpload->ruleset='imageUpload';
$info->action->procLayoutAdminUserImageUpload->method='';
$info->action->procLayoutAdminUserImageDelete = new stdClass;
$info->action->procLayoutAdminUserImageDelete->type='controller';
$info->action->procLayoutAdminUserImageDelete->grant='guest';
$info->action->procLayoutAdminUserImageDelete->standalone='true';
$info->action->procLayoutAdminUserImageDelete->ruleset='';
$info->action->procLayoutAdminUserImageDelete->method='';
$info->action->procLayoutAdminConfigImageUpload = new stdClass;
$info->action->procLayoutAdminConfigImageUpload->type='controller';
$info->action->procLayoutAdminConfigImageUpload->grant='guest';
$info->action->procLayoutAdminConfigImageUpload->standalone='true';
$info->action->procLayoutAdminConfigImageUpload->ruleset='';
$info->action->procLayoutAdminConfigImageUpload->method='';
$info->action->procLayoutAdminConfigImageDelete = new stdClass;
$info->action->procLayoutAdminConfigImageDelete->type='controller';
$info->action->procLayoutAdminConfigImageDelete->grant='guest';
$info->action->procLayoutAdminConfigImageDelete->standalone='true';
$info->action->procLayoutAdminConfigImageDelete->ruleset='';
$info->action->procLayoutAdminConfigImageDelete->method='';
$info->action->procLayoutAdminDelete = new stdClass;
$info->action->procLayoutAdminDelete->type='controller';
$info->action->procLayoutAdminDelete->grant='guest';
$info->action->procLayoutAdminDelete->standalone='true';
$info->action->procLayoutAdminDelete->ruleset='deleteLayout';
$info->action->procLayoutAdminDelete->method='';
$info->action->procLayoutAdminInsert = new stdClass;
$info->action->procLayoutAdminInsert->type='controller';
$info->action->procLayoutAdminInsert->grant='guest';
$info->action->procLayoutAdminInsert->standalone='true';
$info->action->procLayoutAdminInsert->ruleset='insertLayout';
$info->action->procLayoutAdminInsert->method='';
$info->action->procLayoutAdminCodeReset = new stdClass;
$info->action->procLayoutAdminCodeReset->type='controller';
$info->action->procLayoutAdminCodeReset->grant='guest';
$info->action->procLayoutAdminCodeReset->standalone='true';
$info->action->procLayoutAdminCodeReset->ruleset='';
$info->action->procLayoutAdminCodeReset->method='';
$info->action->procLayoutAdminUserValueInsert = new stdClass;
$info->action->procLayoutAdminUserValueInsert->type='controller';
$info->action->procLayoutAdminUserValueInsert->grant='guest';
$info->action->procLayoutAdminUserValueInsert->standalone='true';
$info->action->procLayoutAdminUserValueInsert->ruleset='';
$info->action->procLayoutAdminUserValueInsert->method='';
$info->action->procLayoutAdminUserLayoutExport = new stdClass;
$info->action->procLayoutAdminUserLayoutExport->type='controller';
$info->action->procLayoutAdminUserLayoutExport->grant='guest';
$info->action->procLayoutAdminUserLayoutExport->standalone='true';
$info->action->procLayoutAdminUserLayoutExport->ruleset='';
$info->action->procLayoutAdminUserLayoutExport->method='';
$info->action->procLayoutAdminUserLayoutImport = new stdClass;
$info->action->procLayoutAdminUserLayoutImport->type='controller';
$info->action->procLayoutAdminUserLayoutImport->grant='guest';
$info->action->procLayoutAdminUserLayoutImport->standalone='true';
$info->action->procLayoutAdminUserLayoutImport->ruleset='userLayoutImport';
$info->action->procLayoutAdminUserLayoutImport->method='';
$info->action->procLayoutAdminCopyLayout = new stdClass;
$info->action->procLayoutAdminCopyLayout->type='controller';
$info->action->procLayoutAdminCopyLayout->grant='guest';
$info->action->procLayoutAdminCopyLayout->standalone='true';
$info->action->procLayoutAdminCopyLayout->ruleset='';
$info->action->procLayoutAdminCopyLayout->method='';
$info->action->getLayoutInstanceListForJSONP = new stdClass;
$info->action->getLayoutInstanceListForJSONP->type='model';
$info->action->getLayoutInstanceListForJSONP->grant='guest';
$info->action->getLayoutInstanceListForJSONP->standalone='true';
$info->action->getLayoutInstanceListForJSONP->ruleset='';
$info->action->getLayoutInstanceListForJSONP->method='';
return $info;