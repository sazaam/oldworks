<?php if(!defined("__XE__")) exit();
$info = new stdClass;
$info->default_index_act = '';
$info->setup_index_act='';
$info->simple_setup_index_act='';
$info->admin_index_act = 'dispPointAdminConfig';
$info->menu = new stdClass;
$info->menu->point = new stdClass;
$info->menu->point->title='ポイント';
$info->menu->point->type='';
$info->action = new stdClass;
$info->menu->point->index='dispPointAdminConfig';
$info->menu->point->acts[0]='dispPointAdminConfig';
$info->action->dispPointAdminConfig = new stdClass;
$info->action->dispPointAdminConfig->type='view';
$info->action->dispPointAdminConfig->grant='guest';
$info->action->dispPointAdminConfig->standalone='true';
$info->action->dispPointAdminConfig->ruleset='';
$info->action->dispPointAdminConfig->method='';
$info->menu->point->acts[1]='dispPointAdminModuleConfig';
$info->action->dispPointAdminModuleConfig = new stdClass;
$info->action->dispPointAdminModuleConfig->type='view';
$info->action->dispPointAdminModuleConfig->grant='guest';
$info->action->dispPointAdminModuleConfig->standalone='true';
$info->action->dispPointAdminModuleConfig->ruleset='';
$info->action->dispPointAdminModuleConfig->method='';
$info->menu->point->acts[2]='dispPointAdminPointList';
$info->action->dispPointAdminPointList = new stdClass;
$info->action->dispPointAdminPointList->type='view';
$info->action->dispPointAdminPointList->grant='guest';
$info->action->dispPointAdminPointList->standalone='true';
$info->action->dispPointAdminPointList->ruleset='';
$info->action->dispPointAdminPointList->method='';
$info->action->procPointAdminInsertConfig = new stdClass;
$info->action->procPointAdminInsertConfig->type='controller';
$info->action->procPointAdminInsertConfig->grant='guest';
$info->action->procPointAdminInsertConfig->standalone='true';
$info->action->procPointAdminInsertConfig->ruleset='insertConfig';
$info->action->procPointAdminInsertConfig->method='';
$info->action->procPointAdminInsertModuleConfig = new stdClass;
$info->action->procPointAdminInsertModuleConfig->type='controller';
$info->action->procPointAdminInsertModuleConfig->grant='guest';
$info->action->procPointAdminInsertModuleConfig->standalone='true';
$info->action->procPointAdminInsertModuleConfig->ruleset='';
$info->action->procPointAdminInsertModuleConfig->method='';
$info->action->procPointAdminUpdatePoint = new stdClass;
$info->action->procPointAdminUpdatePoint->type='controller';
$info->action->procPointAdminUpdatePoint->grant='guest';
$info->action->procPointAdminUpdatePoint->standalone='true';
$info->action->procPointAdminUpdatePoint->ruleset='updatePoint';
$info->action->procPointAdminUpdatePoint->method='';
$info->action->procPointAdminInsertPointModuleConfig = new stdClass;
$info->action->procPointAdminInsertPointModuleConfig->type='controller';
$info->action->procPointAdminInsertPointModuleConfig->grant='guest';
$info->action->procPointAdminInsertPointModuleConfig->standalone='true';
$info->action->procPointAdminInsertPointModuleConfig->ruleset='';
$info->action->procPointAdminInsertPointModuleConfig->method='';
$info->action->procPointAdminApplyPoint = new stdClass;
$info->action->procPointAdminApplyPoint->type='controller';
$info->action->procPointAdminApplyPoint->grant='guest';
$info->action->procPointAdminApplyPoint->standalone='true';
$info->action->procPointAdminApplyPoint->ruleset='';
$info->action->procPointAdminApplyPoint->method='';
$info->action->procPointAdminReset = new stdClass;
$info->action->procPointAdminReset->type='controller';
$info->action->procPointAdminReset->grant='guest';
$info->action->procPointAdminReset->standalone='true';
$info->action->procPointAdminReset->ruleset='';
$info->action->procPointAdminReset->method='';
$info->action->procPointAdminReCal = new stdClass;
$info->action->procPointAdminReCal->type='controller';
$info->action->procPointAdminReCal->grant='guest';
$info->action->procPointAdminReCal->standalone='true';
$info->action->procPointAdminReCal->ruleset='';
$info->action->procPointAdminReCal->method='';
$info->action->getMembersPointInfo = new stdClass;
$info->action->getMembersPointInfo->type='model';
$info->action->getMembersPointInfo->grant='guest';
$info->action->getMembersPointInfo->standalone='true';
$info->action->getMembersPointInfo->ruleset='';
$info->action->getMembersPointInfo->method='';
return $info;