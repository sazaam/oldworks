<?php
$lang->integration_search='통합검색';
$lang->sample_code='샘플코드';
$lang->about_target_module='선택한 페이지를 검색 대상으로 정합니다. 권한설정에 대한 주의를 바랍니다.';
$lang->about_sample_code='위 코드를 레이아웃, 스킨 등에 추가하면 통합검색이 가능합니다.';
$lang->msg_no_keyword='검색어를 입력해주세요.';
$lang->msg_document_more_search='\'계속 검색\' 버튼을 선택하면 아직 검색하지 않은 부분까지 계속 검색할 수 있습니다.';
$lang->is_result_text='<strong>\'%s\'</strong>에 대한 검색결과 <strong>%d</strong>건';
$lang->multimedia='이미지/동영상';
$lang->include_search_target='선택된 대상만 검색';
$lang->exclude_search_target='선택된 대상을 검색에서 제외';
if(!is_array($lang->is_search_option)){
	$lang->is_search_option = array();
}
if(!is_array($lang->is_search_option['document'])){
	$lang->is_search_option['document'] = array();
}
$lang->is_search_option['document']['title_content']='제목+내용';
$lang->is_search_option['document']['title']='제목';
$lang->is_search_option['document']['content']='내용';
$lang->is_search_option['document']['tag']='태그';
if(!is_array($lang->is_search_option['trackback'])){
	$lang->is_search_option['trackback'] = array();
}
$lang->is_search_option['trackback']['url']='대상 URL';
$lang->is_search_option['trackback']['blog_name']='대상 사이트 이름';
$lang->is_search_option['trackback']['title']='제목';
$lang->is_search_option['trackback']['excerpt']='내용';
if(!is_array($lang->is_sort_option)){
	$lang->is_sort_option = array();
}
$lang->is_sort_option['regdate']='등록일';
$lang->is_sort_option['comment_count']='댓글 수';
$lang->is_sort_option['readed_count']='조회 수';
$lang->is_sort_option['voted_count']='추천 수';
