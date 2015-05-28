<?php if(!defined("__XE__")) exit();
$info = new stdClass;
$info->default_index_act = '';
$info->setup_index_act='';
$info->simple_setup_index_act='';
$info->admin_index_act = 'dispCommentAdminList';
$info->permission = new stdClass;
$info->permission->procCommentAdminAddCart = 'manager';
$info->permission->procCommentGetList = 'manager';
$info->menu = new stdClass;
$info->menu->comment = new stdClass;
$info->menu->comment->title='コメント';
$info->menu->comment->type='';
$info->action = new stdClass;
$info->action->getCommentMenu = new stdClass;
$info->action->getCommentMenu->type='model';
$info->action->getCommentMenu->grant='guest';
$info->action->getCommentMenu->standalone='true';
$info->action->getCommentMenu->ruleset='';
$info->action->getCommentMenu->method='';
$info->menu->comment->index='dispCommentAdminList';
$info->menu->comment->acts[0]='dispCommentAdminList';
$info->action->dispCommentAdminList = new stdClass;
$info->action->dispCommentAdminList->type='view';
$info->action->dispCommentAdminList->grant='guest';
$info->action->dispCommentAdminList->standalone='true';
$info->action->dispCommentAdminList->ruleset='';
$info->action->dispCommentAdminList->method='';
$info->menu->comment->acts[1]='dispCommentAdminDeclared';
$info->action->dispCommentAdminDeclared = new stdClass;
$info->action->dispCommentAdminDeclared->type='view';
$info->action->dispCommentAdminDeclared->grant='guest';
$info->action->dispCommentAdminDeclared->standalone='true';
$info->action->dispCommentAdminDeclared->ruleset='';
$info->action->dispCommentAdminDeclared->method='';
$info->action->procCommentVoteUp = new stdClass;
$info->action->procCommentVoteUp->type='controller';
$info->action->procCommentVoteUp->grant='guest';
$info->action->procCommentVoteUp->standalone='true';
$info->action->procCommentVoteUp->ruleset='';
$info->action->procCommentVoteUp->method='';
$info->action->procCommentVoteDown = new stdClass;
$info->action->procCommentVoteDown->type='controller';
$info->action->procCommentVoteDown->grant='guest';
$info->action->procCommentVoteDown->standalone='true';
$info->action->procCommentVoteDown->ruleset='';
$info->action->procCommentVoteDown->method='';
$info->action->procCommentDeclare = new stdClass;
$info->action->procCommentDeclare->type='controller';
$info->action->procCommentDeclare->grant='guest';
$info->action->procCommentDeclare->standalone='true';
$info->action->procCommentDeclare->ruleset='';
$info->action->procCommentDeclare->method='';
$info->action->getCommentVotedMemberList = new stdClass;
$info->action->getCommentVotedMemberList->type='model';
$info->action->getCommentVotedMemberList->grant='guest';
$info->action->getCommentVotedMemberList->standalone='true';
$info->action->getCommentVotedMemberList->ruleset='';
$info->action->getCommentVotedMemberList->method='';
$info->action->procCommentInsertModuleConfig = new stdClass;
$info->action->procCommentInsertModuleConfig->type='controller';
$info->action->procCommentInsertModuleConfig->grant='guest';
$info->action->procCommentInsertModuleConfig->standalone='true';
$info->action->procCommentInsertModuleConfig->ruleset='insertCommentModuleConfig';
$info->action->procCommentInsertModuleConfig->method='';
$info->action->procCommentAdminDeleteChecked = new stdClass;
$info->action->procCommentAdminDeleteChecked->type='controller';
$info->action->procCommentAdminDeleteChecked->grant='guest';
$info->action->procCommentAdminDeleteChecked->standalone='true';
$info->action->procCommentAdminDeleteChecked->ruleset='deleteChecked';
$info->action->procCommentAdminDeleteChecked->method='';
$info->action->procCommentAdminChangeStatus = new stdClass;
$info->action->procCommentAdminChangeStatus->type='controller';
$info->action->procCommentAdminChangeStatus->grant='guest';
$info->action->procCommentAdminChangeStatus->standalone='true';
$info->action->procCommentAdminChangeStatus->ruleset='';
$info->action->procCommentAdminChangeStatus->method='';
$info->action->procCommentAdminChangePublishedStatusChecked = new stdClass;
$info->action->procCommentAdminChangePublishedStatusChecked->type='controller';
$info->action->procCommentAdminChangePublishedStatusChecked->grant='guest';
$info->action->procCommentAdminChangePublishedStatusChecked->standalone='true';
$info->action->procCommentAdminChangePublishedStatusChecked->ruleset='';
$info->action->procCommentAdminChangePublishedStatusChecked->method='';
$info->action->isModuleUsingPublishValidation = new stdClass;
$info->action->isModuleUsingPublishValidation->type='controller';
$info->action->isModuleUsingPublishValidation->grant='guest';
$info->action->isModuleUsingPublishValidation->standalone='true';
$info->action->isModuleUsingPublishValidation->ruleset='';
$info->action->isModuleUsingPublishValidation->method='';
$info->action->procCommentAdminCancelDeclare = new stdClass;
$info->action->procCommentAdminCancelDeclare->type='controller';
$info->action->procCommentAdminCancelDeclare->grant='guest';
$info->action->procCommentAdminCancelDeclare->standalone='true';
$info->action->procCommentAdminCancelDeclare->ruleset='';
$info->action->procCommentAdminCancelDeclare->method='';
$info->action->procCommentAdminAddCart = new stdClass;
$info->action->procCommentAdminAddCart->type='controller';
$info->action->procCommentAdminAddCart->grant='guest';
$info->action->procCommentAdminAddCart->standalone='true';
$info->action->procCommentAdminAddCart->ruleset='';
$info->action->procCommentAdminAddCart->method='';
$info->action->procCommentGetList = new stdClass;
$info->action->procCommentGetList->type='controller';
$info->action->procCommentGetList->grant='guest';
$info->action->procCommentGetList->standalone='true';
$info->action->procCommentGetList->ruleset='';
$info->action->procCommentGetList->method='';
return $info;