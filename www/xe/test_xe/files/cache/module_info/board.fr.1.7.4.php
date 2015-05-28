<?php if(!defined("__XE__")) exit();
$info = new stdClass;
$info->default_index_act = 'dispBoardContent';
$info->setup_index_act='dispBoardAdminInsertBoard';
$info->simple_setup_index_act='getBoardAdminSimpleSetup';
$info->admin_index_act = 'dispBoardAdminContent';
$info->grant = new stdClass;
$info->grant->list = new stdClass;
$info->grant->list->title='';
$info->grant->list->default='guest';
$info->grant->view = new stdClass;
$info->grant->view->title='';
$info->grant->view->default='guest';
$info->grant->write_document = new stdClass;
$info->grant->write_document->title='';
$info->grant->write_document->default='guest';
$info->grant->write_comment = new stdClass;
$info->grant->write_comment->title='';
$info->grant->write_comment->default='guest';
$info->permission = new stdClass;
$info->permission->dispBoardAdminInsertBoard = 'manager';
$info->permission->dispBoardAdminBoardInfo = 'manager';
$info->permission->dispBoardAdminExtraVars = 'manager';
$info->permission->dispBoardAdminBoardAdditionSetup = 'manager';
$info->permission->dispBoardAdminSkinInfo = 'manager';
$info->permission->procBoardAdminInsertBoard = 'manager';
$info->permission->procBoardAdminUpdateBoardFroBasic = 'manager';
$info->permission->procBoardAdminSaveCategorySettings = 'manager';
$info->permission->getBoardAdminSimpleSetup = 'manager';
$info->menu = new stdClass;
$info->menu->board = new stdClass;
$info->menu->board->title='Board';
$info->menu->board->type='all';
$info->action = new stdClass;
$info->action->dispBoardContent = new stdClass;
$info->action->dispBoardContent->type='view';
$info->action->dispBoardContent->grant='guest';
$info->action->dispBoardContent->standalone='true';
$info->action->dispBoardContent->ruleset='';
$info->action->dispBoardContent->method='';
$info->action->dispBoardNoticeList = new stdClass;
$info->action->dispBoardNoticeList->type='view';
$info->action->dispBoardNoticeList->grant='guest';
$info->action->dispBoardNoticeList->standalone='true';
$info->action->dispBoardNoticeList->ruleset='';
$info->action->dispBoardNoticeList->method='';
$info->action->dispBoardContentList = new stdClass;
$info->action->dispBoardContentList->type='view';
$info->action->dispBoardContentList->grant='guest';
$info->action->dispBoardContentList->standalone='true';
$info->action->dispBoardContentList->ruleset='';
$info->action->dispBoardContentList->method='';
$info->action->dispBoardContentView = new stdClass;
$info->action->dispBoardContentView->type='view';
$info->action->dispBoardContentView->grant='guest';
$info->action->dispBoardContentView->standalone='true';
$info->action->dispBoardContentView->ruleset='';
$info->action->dispBoardContentView->method='';
$info->action->dispBoardCatogoryList = new stdClass;
$info->action->dispBoardCatogoryList->type='view';
$info->action->dispBoardCatogoryList->grant='guest';
$info->action->dispBoardCatogoryList->standalone='true';
$info->action->dispBoardCatogoryList->ruleset='';
$info->action->dispBoardCatogoryList->method='';
$info->action->dispBoardContentCommentList = new stdClass;
$info->action->dispBoardContentCommentList->type='view';
$info->action->dispBoardContentCommentList->grant='guest';
$info->action->dispBoardContentCommentList->standalone='true';
$info->action->dispBoardContentCommentList->ruleset='';
$info->action->dispBoardContentCommentList->method='';
$info->action->dispBoardContentFileList = new stdClass;
$info->action->dispBoardContentFileList->type='view';
$info->action->dispBoardContentFileList->grant='guest';
$info->action->dispBoardContentFileList->standalone='true';
$info->action->dispBoardContentFileList->ruleset='';
$info->action->dispBoardContentFileList->method='';
$info->action->dispBoardTagList = new stdClass;
$info->action->dispBoardTagList->type='view';
$info->action->dispBoardTagList->grant='guest';
$info->action->dispBoardTagList->standalone='true';
$info->action->dispBoardTagList->ruleset='';
$info->action->dispBoardTagList->method='';
$info->action->dispBoardWrite = new stdClass;
$info->action->dispBoardWrite->type='view';
$info->action->dispBoardWrite->grant='guest';
$info->action->dispBoardWrite->standalone='false';
$info->action->dispBoardWrite->ruleset='';
$info->action->dispBoardWrite->method='';
$info->action->dispBoardDelete = new stdClass;
$info->action->dispBoardDelete->type='view';
$info->action->dispBoardDelete->grant='guest';
$info->action->dispBoardDelete->standalone='false';
$info->action->dispBoardDelete->ruleset='';
$info->action->dispBoardDelete->method='';
$info->action->dispBoardWriteComment = new stdClass;
$info->action->dispBoardWriteComment->type='view';
$info->action->dispBoardWriteComment->grant='guest';
$info->action->dispBoardWriteComment->standalone='false';
$info->action->dispBoardWriteComment->ruleset='';
$info->action->dispBoardWriteComment->method='';
$info->action->dispBoardReplyComment = new stdClass;
$info->action->dispBoardReplyComment->type='view';
$info->action->dispBoardReplyComment->grant='guest';
$info->action->dispBoardReplyComment->standalone='false';
$info->action->dispBoardReplyComment->ruleset='';
$info->action->dispBoardReplyComment->method='';
$info->action->dispBoardModifyComment = new stdClass;
$info->action->dispBoardModifyComment->type='view';
$info->action->dispBoardModifyComment->grant='guest';
$info->action->dispBoardModifyComment->standalone='false';
$info->action->dispBoardModifyComment->ruleset='';
$info->action->dispBoardModifyComment->method='';
$info->action->dispBoardDeleteComment = new stdClass;
$info->action->dispBoardDeleteComment->type='view';
$info->action->dispBoardDeleteComment->grant='guest';
$info->action->dispBoardDeleteComment->standalone='false';
$info->action->dispBoardDeleteComment->ruleset='';
$info->action->dispBoardDeleteComment->method='';
$info->action->dispBoardDeleteTrackback = new stdClass;
$info->action->dispBoardDeleteTrackback->type='view';
$info->action->dispBoardDeleteTrackback->grant='guest';
$info->action->dispBoardDeleteTrackback->standalone='false';
$info->action->dispBoardDeleteTrackback->ruleset='';
$info->action->dispBoardDeleteTrackback->method='';
$info->action->dispBoardMessage = new stdClass;
$info->action->dispBoardMessage->type='view';
$info->action->dispBoardMessage->grant='guest';
$info->action->dispBoardMessage->standalone='true';
$info->action->dispBoardMessage->ruleset='';
$info->action->dispBoardMessage->method='';
$info->action->procBoardInsertDocument = new stdClass;
$info->action->procBoardInsertDocument->type='controller';
$info->action->procBoardInsertDocument->grant='guest';
$info->action->procBoardInsertDocument->standalone='false';
$info->action->procBoardInsertDocument->ruleset='insertDocument';
$info->action->procBoardInsertDocument->method='';
$info->action->procBoardDeleteDocument = new stdClass;
$info->action->procBoardDeleteDocument->type='controller';
$info->action->procBoardDeleteDocument->grant='guest';
$info->action->procBoardDeleteDocument->standalone='false';
$info->action->procBoardDeleteDocument->ruleset='';
$info->action->procBoardDeleteDocument->method='';
$info->action->procBoardVoteDocument = new stdClass;
$info->action->procBoardVoteDocument->type='controller';
$info->action->procBoardVoteDocument->grant='guest';
$info->action->procBoardVoteDocument->standalone='false';
$info->action->procBoardVoteDocument->ruleset='';
$info->action->procBoardVoteDocument->method='';
$info->action->procBoardInsertComment = new stdClass;
$info->action->procBoardInsertComment->type='controller';
$info->action->procBoardInsertComment->grant='guest';
$info->action->procBoardInsertComment->standalone='false';
$info->action->procBoardInsertComment->ruleset='';
$info->action->procBoardInsertComment->method='';
$info->action->procBoardDeleteComment = new stdClass;
$info->action->procBoardDeleteComment->type='controller';
$info->action->procBoardDeleteComment->grant='guest';
$info->action->procBoardDeleteComment->standalone='false';
$info->action->procBoardDeleteComment->ruleset='';
$info->action->procBoardDeleteComment->method='';
$info->action->procBoardDeleteTrackback = new stdClass;
$info->action->procBoardDeleteTrackback->type='controller';
$info->action->procBoardDeleteTrackback->grant='guest';
$info->action->procBoardDeleteTrackback->standalone='false';
$info->action->procBoardDeleteTrackback->ruleset='';
$info->action->procBoardDeleteTrackback->method='';
$info->action->procBoardVerificationPassword = new stdClass;
$info->action->procBoardVerificationPassword->type='controller';
$info->action->procBoardVerificationPassword->grant='guest';
$info->action->procBoardVerificationPassword->standalone='true';
$info->action->procBoardVerificationPassword->ruleset='';
$info->action->procBoardVerificationPassword->method='';
$info->action->procBoardDeleteFile = new stdClass;
$info->action->procBoardDeleteFile->type='controller';
$info->action->procBoardDeleteFile->grant='guest';
$info->action->procBoardDeleteFile->standalone='false';
$info->action->procBoardDeleteFile->ruleset='';
$info->action->procBoardDeleteFile->method='';
$info->action->procBoardUploadFile = new stdClass;
$info->action->procBoardUploadFile->type='controller';
$info->action->procBoardUploadFile->grant='guest';
$info->action->procBoardUploadFile->standalone='false';
$info->action->procBoardUploadFile->ruleset='';
$info->action->procBoardUploadFile->method='';
$info->action->procBoardDownloadFile = new stdClass;
$info->action->procBoardDownloadFile->type='controller';
$info->action->procBoardDownloadFile->grant='guest';
$info->action->procBoardDownloadFile->standalone='false';
$info->action->procBoardDownloadFile->ruleset='';
$info->action->procBoardDownloadFile->method='';
$info->menu->board->index='dispBoardAdminContent';
$info->menu->board->acts[0]='dispBoardAdminContent';
$info->action->dispBoardAdminContent = new stdClass;
$info->action->dispBoardAdminContent->type='view';
$info->action->dispBoardAdminContent->grant='guest';
$info->action->dispBoardAdminContent->standalone='true';
$info->action->dispBoardAdminContent->ruleset='';
$info->action->dispBoardAdminContent->method='';
$info->menu->board->acts[1]='dispBoardAdminBoardInfo';
$info->action->dispBoardAdminBoardInfo = new stdClass;
$info->action->dispBoardAdminBoardInfo->type='view';
$info->action->dispBoardAdminBoardInfo->grant='guest';
$info->action->dispBoardAdminBoardInfo->standalone='true';
$info->action->dispBoardAdminBoardInfo->ruleset='';
$info->action->dispBoardAdminBoardInfo->method='';
$info->menu->board->acts[2]='dispBoardAdminExtraVars';
$info->action->dispBoardAdminExtraVars = new stdClass;
$info->action->dispBoardAdminExtraVars->type='view';
$info->action->dispBoardAdminExtraVars->grant='guest';
$info->action->dispBoardAdminExtraVars->standalone='true';
$info->action->dispBoardAdminExtraVars->ruleset='';
$info->action->dispBoardAdminExtraVars->method='';
$info->menu->board->acts[3]='dispBoardAdminBoardAdditionSetup';
$info->action->dispBoardAdminBoardAdditionSetup = new stdClass;
$info->action->dispBoardAdminBoardAdditionSetup->type='view';
$info->action->dispBoardAdminBoardAdditionSetup->grant='guest';
$info->action->dispBoardAdminBoardAdditionSetup->standalone='true';
$info->action->dispBoardAdminBoardAdditionSetup->ruleset='';
$info->action->dispBoardAdminBoardAdditionSetup->method='';
$info->menu->board->acts[4]='dispBoardAdminInsertBoard';
$info->action->dispBoardAdminInsertBoard = new stdClass;
$info->action->dispBoardAdminInsertBoard->type='view';
$info->action->dispBoardAdminInsertBoard->grant='guest';
$info->action->dispBoardAdminInsertBoard->standalone='true';
$info->action->dispBoardAdminInsertBoard->ruleset='';
$info->action->dispBoardAdminInsertBoard->method='';
$info->menu->board->acts[5]='dispBoardAdminDeleteBoard';
$info->action->dispBoardAdminDeleteBoard = new stdClass;
$info->action->dispBoardAdminDeleteBoard->type='view';
$info->action->dispBoardAdminDeleteBoard->grant='guest';
$info->action->dispBoardAdminDeleteBoard->standalone='true';
$info->action->dispBoardAdminDeleteBoard->ruleset='';
$info->action->dispBoardAdminDeleteBoard->method='';
$info->menu->board->acts[6]='dispBoardAdminSkinInfo';
$info->action->dispBoardAdminSkinInfo = new stdClass;
$info->action->dispBoardAdminSkinInfo->type='view';
$info->action->dispBoardAdminSkinInfo->grant='guest';
$info->action->dispBoardAdminSkinInfo->standalone='true';
$info->action->dispBoardAdminSkinInfo->ruleset='';
$info->action->dispBoardAdminSkinInfo->method='';
$info->menu->board->acts[7]='dispBoardAdminMobileSkinInfo';
$info->action->dispBoardAdminMobileSkinInfo = new stdClass;
$info->action->dispBoardAdminMobileSkinInfo->type='view';
$info->action->dispBoardAdminMobileSkinInfo->grant='guest';
$info->action->dispBoardAdminMobileSkinInfo->standalone='true';
$info->action->dispBoardAdminMobileSkinInfo->ruleset='';
$info->action->dispBoardAdminMobileSkinInfo->method='';
$info->menu->board->acts[8]='dispBoardAdminGrantInfo';
$info->action->dispBoardAdminGrantInfo = new stdClass;
$info->action->dispBoardAdminGrantInfo->type='view';
$info->action->dispBoardAdminGrantInfo->grant='guest';
$info->action->dispBoardAdminGrantInfo->standalone='true';
$info->action->dispBoardAdminGrantInfo->ruleset='';
$info->action->dispBoardAdminGrantInfo->method='';
$info->menu->board->acts[9]='dispBoardAdminCategoryInfo';
$info->action->dispBoardAdminCategoryInfo = new stdClass;
$info->action->dispBoardAdminCategoryInfo->type='view';
$info->action->dispBoardAdminCategoryInfo->grant='guest';
$info->action->dispBoardAdminCategoryInfo->standalone='true';
$info->action->dispBoardAdminCategoryInfo->ruleset='';
$info->action->dispBoardAdminCategoryInfo->method='';
$info->action->procBoardAdminInsertBoard = new stdClass;
$info->action->procBoardAdminInsertBoard->type='controller';
$info->action->procBoardAdminInsertBoard->grant='guest';
$info->action->procBoardAdminInsertBoard->standalone='true';
$info->action->procBoardAdminInsertBoard->ruleset='insertBoard';
$info->action->procBoardAdminInsertBoard->method='';
$info->action->procBoardAdminDeleteBoard = new stdClass;
$info->action->procBoardAdminDeleteBoard->type='controller';
$info->action->procBoardAdminDeleteBoard->grant='guest';
$info->action->procBoardAdminDeleteBoard->standalone='true';
$info->action->procBoardAdminDeleteBoard->ruleset='';
$info->action->procBoardAdminDeleteBoard->method='';
$info->action->procBoardAdminUpdateBoardFroBasic = new stdClass;
$info->action->procBoardAdminUpdateBoardFroBasic->type='controller';
$info->action->procBoardAdminUpdateBoardFroBasic->grant='guest';
$info->action->procBoardAdminUpdateBoardFroBasic->standalone='true';
$info->action->procBoardAdminUpdateBoardFroBasic->ruleset='insertBoardForBasic';
$info->action->procBoardAdminUpdateBoardFroBasic->method='';
$info->action->procBoardAdminSaveCategorySettings = new stdClass;
$info->action->procBoardAdminSaveCategorySettings->type='controller';
$info->action->procBoardAdminSaveCategorySettings->grant='guest';
$info->action->procBoardAdminSaveCategorySettings->standalone='true';
$info->action->procBoardAdminSaveCategorySettings->ruleset='saveCategorySettings';
$info->action->procBoardAdminSaveCategorySettings->method='';
$info->action->getBoardAdminSimpleSetup = new stdClass;
$info->action->getBoardAdminSimpleSetup->type='model';
$info->action->getBoardAdminSimpleSetup->grant='guest';
$info->action->getBoardAdminSimpleSetup->standalone='true';
$info->action->getBoardAdminSimpleSetup->ruleset='';
$info->action->getBoardAdminSimpleSetup->method='';
$info->action->dispBoardCategory = new stdClass;
$info->action->dispBoardCategory->type='mobile';
$info->action->dispBoardCategory->grant='guest';
$info->action->dispBoardCategory->standalone='true';
$info->action->dispBoardCategory->ruleset='';
$info->action->dispBoardCategory->method='';
$info->action->getBoardCommentPage = new stdClass;
$info->action->getBoardCommentPage->type='mobile';
$info->action->getBoardCommentPage->grant='guest';
$info->action->getBoardCommentPage->standalone='true';
$info->action->getBoardCommentPage->ruleset='';
$info->action->getBoardCommentPage->method='';
return $info;