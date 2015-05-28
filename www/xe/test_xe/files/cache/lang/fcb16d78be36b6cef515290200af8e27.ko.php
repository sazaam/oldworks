<?php
$lang->cmd_sync_member='동기화';
$lang->cmd_continue='계속 진행';
$lang->preprocessing='데이터 이전을 위한 사전 준비 중입니다.';
$lang->importer='데이터 들여오기';
$lang->source_type='이전 대상';
$lang->type_member='회원 정보';
$lang->type_message='쪽지 정보';
$lang->type_ttxml='TTXML';
$lang->type_module='게시물 정보';
$lang->type_syncmember='회원정보 동기화';
$lang->target_module='대상 모듈';
$lang->xml_file='XML 파일';
if(!is_array($lang->import_step_title)){
	$lang->import_step_title = array();
}
$lang->import_step_title['1']='Step 1. 이전 대상 선택';
$lang->import_step_title['12']='Step 1-2. 대상 모듈 선택';
$lang->import_step_title['13']='Step 1-3. 대상 분류 선택';
$lang->import_step_title['2']='Step 2. XML 파일 지정';
$lang->import_step_title['3']='Step 2. 회원정보와 게시물의 정보 동기화';
$lang->import_step_title['99']='데이터 이전';
if(!is_array($lang->import_step_desc)){
	$lang->import_step_desc = array();
}
$lang->import_step_desc['1']='이전하려는 XML파일의 종류를 선택해주세요.';
$lang->import_step_desc['12']='데이터를 이전 받을 대상 모듈을 선택해 주세요.';
$lang->import_step_desc['121']='글:';
$lang->import_step_desc['122']='방명록:';
$lang->import_step_desc['13']='데이터 이전을 할 대상 분류를 선택해주세요.';
$lang->import_step_desc['2']='이전할 데이터 XML파일의 경로를 입력해주세요.
상대 또는 절대 경로를 입력하면 됩니다.';
$lang->import_step_desc['3']='게시물과 글쓴이의 회원 정보가 일치하지 않는 경우 아이디를 기반으로 게시물에 대한 글쓴이의 회원 정보를 바로잡아 줍니다.';
$lang->import_step_desc['99']='데이터 이전중입니다.';
$lang->xml_path='XML 파일의 경로를 입력하세요.';
$lang->data_destination='데이터의 목적지를 선택하세요.';
$lang->document_destination='글 데이터의 목적지를 선택하세요.';
$lang->guestbook_destination='방명록 데이터의 목적지를 선택하세요.';
$lang->msg_sync_member='동기화 버튼을 클릭하면 회원정보와 게시물 정보의 동기화를 시작합니다.';
$lang->found_xml_file='XML 파일을 찾았습니다.';
$lang->not_found_xml_file='XML 파일을 찾을 수 없습니다.';
$lang->cannot_allow_fopen_in_phpini='php.ini 환경설정에서 원격지의 파일을 열지 못하도록 되어 있습니다.';
$lang->cannot_url_file='원격지의 파일을 열지 못하였습니다.';
$lang->cmd_check_path='경로 확인';
$lang->msg_exist_xml_file='XML 파일을 찾았습니다.';
$lang->msg_no_xml_file='XML파일을 찾을 수 없습니다. 경로를 다시 확인해주세요.';
$lang->msg_invalid_xml_file='잘못된 형식의 XML 파일입니다.';
$lang->msg_importing='%d개의 데이터 중 %d개를 입력중입니다. (계속 멈추어 있으면 "계속진행" 버튼을 클릭해주세요.)';
$lang->msg_import_finished='%d/%d 개의 데이터 입력이 완료되었습니다. 상황에 따라 입력되지 못한 데이터가 있을 수 있습니다.';
$lang->msg_sync_completed='회원과 게시물, 댓글의 동기화가 완료되었습니다.';
$lang->about_type_member='데이터 이전 대상이 회원정보일 경우 선택해주세요.';
$lang->about_type_message='데이터 이전 대상이 쪽지(메시지)일 경우 선택해주세요.';
$lang->about_type_ttxml='데이터 이전 대상이 TTXML(textcube계열)일 경우 선택해주세요.';
$lang->about_ttxml_user_id='글쓴이로 설정할 사용자 아이디를 입력해주세요. (가입된 아이디만 가능)';
$lang->about_type_module='데이터 이전 대상이 게시판 등의 게시물 정보일 경우 선택해주세요.';
$lang->about_type_syncmember='회원정보와 게시물정보 등을 이전 후, 회원정보를 동기화해야 할 때 선택해주세요.';
$lang->about_importer='다른 프로그램의 데이터를 XML 형식으로 변환 후 업로드하면 XE로 이전할 수 있습니다. <a href="http://www.xpressengine.com/index.php?mid=download&category_srl=18324038" target="_blank">XML Exporter</a>를 이용하면 XML파일로 변환할 수 있습니다.';
$lang->about_target_path='첨부 파일을 받기 위해 제로보드4가 설치된 위치를 입력해주세요.
같은 서버에 있을 경우 /home/아이디/public_html/bbs 등과 같이 제로보드4의 위치를 입력하고
다른 서버일 경우 http:도메인/bbs 처럼 제로보드4가 설치된 곳의 url을 입력해주세요.';
