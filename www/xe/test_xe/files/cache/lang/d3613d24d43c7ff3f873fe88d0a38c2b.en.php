<?php
$lang->cmd_comment_do='I want to';
$lang->comment_list='Comments List';
$lang->cmd_toggle_checked_comment='Invert Selection';
$lang->cmd_delete_checked_comment='Delete selected item';
$lang->trash='Recycle Bin';
$lang->cmd_trash='Move to Recycle Bin';
$lang->comment_count='Number of Comments';
$lang->about_comment_count='Display comments and if the number of them is over a specified number, move to the comment list.';
$lang->msg_cart_is_null='Please select an article to delete.';
$lang->msg_checked_comment_is_deleted='%d comment(s) is(are) successfully deleted.';
if(!is_array($lang->search_target_list)){
	$lang->search_target_list = array();
}
$lang->search_target_list['content']='Content';
$lang->search_target_list['user_id']='ID';
$lang->search_target_list['user_name']='Name';
$lang->search_target_list['nick_name']='Nickname';
$lang->search_target_list['member_srl']='Member Serial';
$lang->search_target_list['email_address']='Email';
$lang->search_target_list['homepage']='Homepage';
$lang->search_target_list['regdate']='Date';
$lang->search_target_list['last_update']='Last update';
$lang->search_target_list['ipaddress']='IP Address';
$lang->search_target_list['is_secret']='Status';
$lang->no_text_comment='No text in this comment.';
if(!is_array($lang->secret_name_list)){
	$lang->secret_name_list = array();
}
$lang->secret_name_list['Y']='Secret';
$lang->secret_name_list['N']='Public';
if(!is_array($lang->published_name_list)){
	$lang->published_name_list = array();
}
$lang->published_name_list['Y']='Published';
$lang->published_name_list['N']='Unpublished';
$lang->comment_manager='Manage Selected Comment';
$lang->selected_comment='Selected Comment';
$lang->cmd_comment_validation='Use comment validation';
$lang->about_comment_validation='If you want to use comment validation before displaying on your module frontend select USE, otherwise select NOT USE.';
$lang->published='Publish status';
$lang->cmd_publish='Publish';
$lang->cmd_unpublish='Unpublish';
$lang->select_module='Select Module';
$lang->page='Page';
$lang->msg_not_selected_comment='There are no selected comment.';
