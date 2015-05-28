<?php
$lang->poll='Poll';
$lang->poll_stop_date='Expiration Date';
$lang->poll_join_count='Participants';
$lang->poll_checkcount='Number of required items';
$lang->cmd_poll_list='View poll list';
$lang->cmd_delete_checked_poll='Delete selected poll';
$lang->cmd_apply_poll='Apply poll';
$lang->cmd_view_result='Preview result';
$lang->success_poll='Thank you for joining the poll.';
$lang->msg_already_poll='You already polled!';
$lang->msg_poll_is_null='Please select a poll to delete.';
$lang->msg_checked_poll_is_deleted='%d poll(s) are deleted.';
$lang->confirm_poll_delete='%s개의 설문을 삭제하시겠습니까?';
$lang->msg_check_poll_item='Please select a poll item to poll.\n(Required poll item(s) may be different in each poll.)';
$lang->msg_poll_not_exists='The selected poll does not exist.';
$lang->cmd_null_item='No item value exists to post a poll. Please re-try.';
$lang->confirm_poll_submit='Confirm to submit the poll?';
if(!is_array($lang->search_poll_target_list)){
	$lang->search_poll_target_list = array();
}
$lang->search_poll_target_list['title']='Title';
$lang->search_poll_target_list['regdate']='Posting date';
$lang->search_poll_target_list['ipaddress']='IP Address';
$lang->single_check='Single Check';
$lang->multi_check='Multi Check';
$lang->selected_poll='Selected poll';
