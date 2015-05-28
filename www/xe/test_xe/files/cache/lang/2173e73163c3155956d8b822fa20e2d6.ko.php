<?php
$lang->communication='커뮤니케이션';
$lang->about_communication='회원 간의 쪽지나 친구 관리 등 커뮤니케이션 기능을 수행합니다. 이 기능을 사용하려면 [설치된 애드온] &gt; [커뮤니케이션] 애드온을 활성화 하세요.';
$lang->allow_message='쪽지 수신 허용';
if(!is_array($lang->allow_message_type)){
	$lang->allow_message_type = array();
}
$lang->allow_message_type['Y']='전체 수신';
$lang->allow_message_type['N']='거부';
$lang->allow_message_type['F']='친구만 허용';
if(!is_array($lang->message_box)){
	$lang->message_box = array();
}
$lang->message_box['R']='받은 쪽지함';
$lang->message_box['S']='보낸 쪽지함';
$lang->message_box['T']='보관함';
$lang->readed_date='읽은 시간';
$lang->sender='보낸이';
$lang->receiver='받는이';
$lang->friend_group='친구 그룹';
$lang->default_friend_group='그룹 미지정';
$lang->cmd_send_message='쪽지 보내기';
$lang->cmd_reply_message='쪽지 답장';
$lang->cmd_view_friend='친구 보기';
$lang->cmd_add_friend='친구 등록';
$lang->cmd_message_box='쪽지함';
$lang->cmd_view_message_box='쪽지함 보기';
$lang->cmd_store='보관';
$lang->cmd_add_friend_group='친구 그룹 추가';
$lang->cmd_rename_friend_group='친구 그룹 이름 변경';
$lang->msg_no_message='쪽지가 없습니다.';
$lang->msg_cannot_send_to_yourself='자기 자신에게 쪽지를 보낼 수 없습니다.';
$lang->message_received='쪽지가 왔습니다.';
$lang->msg_title_is_null='쪽지 제목을 입력해주세요.';
$lang->msg_content_is_null='내용을 입력해주세요.';
$lang->msg_allow_message_to_friend='친구에게만 쪽지 발송을 허용한 사용자라서 쪽지 발송을 하지 못했습니다.';
$lang->msg_disallow_message='쪽지 수신을 거부한 사용자라서 쪽지 발송을 하지 못했습니다.';
$lang->about_allow_message='쪽지 수신 여부를 결정할 수 있습니다.';
$lang->message_notice='저작자에게 쪽지를 발송해서 이 사실을 알립니다. 작성하지 않으면 발송하지 않습니다.';
$lang->friends_page_does_not_support='모바일 환경에서는 친구 보기 페이지를 지원하지 않습니다. PC 화면으로 이동하세요.';
