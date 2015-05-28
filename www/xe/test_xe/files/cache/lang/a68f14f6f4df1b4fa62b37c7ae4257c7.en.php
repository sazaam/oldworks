<?php
$lang->communication='Communication';
$lang->about_communication='This module is used for communication between members, such as exchanging messages or mamaging friends.';
$lang->allow_message='Receive Messages';
if(!is_array($lang->allow_message_type)){
	$lang->allow_message_type = array();
}
$lang->allow_message_type['Y']='Receive All';
$lang->allow_message_type['N']='Reject All';
$lang->allow_message_type['F']='Only Friends';
if(!is_array($lang->message_box)){
	$lang->message_box = array();
}
$lang->message_box['R']='Inbox';
$lang->message_box['S']='Sent';
$lang->message_box['T']='Archive';
$lang->readed_date='Read Date';
$lang->sender='From';
$lang->receiver='To';
$lang->friend_group='Friend Group';
$lang->default_friend_group='Unassigned Group';
$lang->cmd_send_message='Send Message';
$lang->cmd_reply_message='Reply Message';
$lang->cmd_view_friend='Friends';
$lang->cmd_add_friend='Add Friend';
$lang->cmd_message_box='Message Box';
$lang->cmd_view_message_box='Message Box';
$lang->cmd_store='Save';
$lang->cmd_add_friend_group='Add Friend Group';
$lang->cmd_rename_friend_group='Modify Friend Group Name';
$lang->msg_no_message='There is no message.';
$lang->msg_cannot_send_to_yourself='Cannot send a message to yourself.';
$lang->message_received='You have a new message.';
$lang->msg_title_is_null='Please enter the title of message.';
$lang->msg_content_is_null='Please enter the content.';
$lang->msg_allow_message_to_friend='Failed to send a message because the recipient accepts messages from friends only.';
$lang->msg_disallow_message='Failed to send a message because the recipient blocked receiving messages.';
$lang->about_allow_message='You can set whether to receive messages or not.';
$lang->message_notice='Send a message to the author about this. If you don\'t write a message, it is not sent.';
$lang->friends_page_does_not_support='Friends in a mobile environment is not supported. Please go to the PC page.';
