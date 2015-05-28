<?php
$lang->page='페이지';
$lang->none_content='내용이 없습니다.';
$lang->cmd_manage_selected_page='선택한 페이지 관리';
$lang->about_page='하나의 완성된 페이지를 제작할 수 있습니다. 최근게시물이나 기타 위젯을 이용해서 동적인 페이지 생성이 가능하고 에디터 컴포넌트를 통해서 다양한 모습으로 꾸밀 수 있습니다. 접속 URL은 다른 페이지와 같이 mid=모듈이름 으로 접속 가능하며 기본으로 선택하면 접속 시 메인 페이지가 됩니다.';
$lang->cmd_page_modify='페이지 수정';
$lang->cmd_page_create='페이지 생성';
$lang->cmd_page_article_create='Article 생성';
$lang->page_caching_interval='캐싱 시간 설정';
$lang->about_page_caching_interval='분 단위이며 정해진 시간동안은 임시 저장한 데이터를 출력합니다. 다른 서버의 정보를 출력하거나, 데이터 출력하는데 많은 자원이 필요한 경우, 원하는 분 단위 시간 간격으로 캐싱하는 것을 추천합니다. 0 으로 하면 캐싱을 하지 않습니다.';
$lang->about_mcontent='모바일에서 보여질 페이지입니다. 만약 작성하지 않으면 기본 페이지 데이터를 재정렬해서 보여줍니다.';
$lang->page_type='페이지 타입';
$lang->click_choice='선택해 주세요.';
if(!is_array($lang->page_type_name)){
	$lang->page_type_name = array();
}
$lang->page_type_name['ARTICLE']='문서 페이지';
$lang->page_type_name['WIDGET']='위젯 페이지';
$lang->page_type_name['OUTSIDE']='외부 페이지';
$lang->about_page_type='페이지 타입을 선택하여 원하는 화면을 구성할 수 있습니다. <ol><li>위젯형 : 여러가지 위젯들을 생성하여 화면을 구성합니다.</li><li>문서형 : 제목, 내용, 태그를 갖는 문서를 제작하여 포스팅 형식의 페이지를 작성합니다. </li><li>외부페이지형 : 외부 HTML 또는 PHP 파일을 XE에서 사용할 수 있습니다.</li></ol>';
$lang->opage_path='외부 문서 위치';
$lang->about_opage='XE가 아닌 외부 HTML 또는 PHP 파일을 삽입할 수 있습니다. 절대경로, 상대경로를 이용할 수 있으며 http:// 로 시작할 경우 서버 외부의 페이지도 표시할 수 있습니다';
$lang->about_opage_path='외부문서의 위치를 입력해주세요. /path1/path2/sample.php 와 같이 절대경로나 ../path2/sample.php와 같은 상대경로 모두 사용가능합니다. http://url/sample.php 와 같이 사용하면 해당 페이지를 웹으로 전송 받아 출력 하게 됩니다. 현재 XE가 설치된 절대경로는 다음과 같습니다. ';
$lang->opage_mobile_path='모바일용 외부 문서 위치';
$lang->about_opage_mobile_path='모바일용 외부문서의 위치를 입력해주세요. 입력하지 않으면 위에서 지정한 외부문서 위치의 페이지를 이용합니다.  /path1/path2/sample.php 와 같이 절대경로나 ../path2/sample.php와 같은 상대경로 모두 사용가능합니다. http://url/sample.php 와 같이 사용하면 해당 페이지를 웹으로 전송 받아 출력 하게 됩니다. 현재 XE가 설치된 절대경로는 다음과 같습니다. ';
$lang->page_management='페이지 관리';
$lang->page_delete_warning='페이지를 삭제할 때 파일도 함께 삭제합니다';
$lang->msg_not_selected_page='선택한 페이지가 없습니다.';
