<?php
$lang->integration_search='Integrated Search';
$lang->sample_code='Sample Code';
$lang->about_target_module='Only chosen pages are the target. Please be careful on setting the permissions.';
$lang->about_sample_code='You can use integrated search by adding the above code in the layout or other things.';
$lang->msg_no_keyword='Please enter keyword to search';
$lang->msg_document_more_search='Click \'Search Next\' button to keep searching.';
$lang->is_result_text='There are <strong>%d</strong> result(s) for <strong>\'%s\'</strong>';
$lang->multimedia='Images/Video';
$lang->include_search_target='Search for selected modules';
$lang->exclude_search_target='Exclude selected modules from search';
if(!is_array($lang->is_search_option)){
	$lang->is_search_option = array();
}
if(!is_array($lang->is_search_option['document'])){
	$lang->is_search_option['document'] = array();
}
$lang->is_search_option['document']['title_content']='Subject+Content';
$lang->is_search_option['document']['title']='Subject';
$lang->is_search_option['document']['content']='Content';
$lang->is_search_option['document']['tag']='Tags';
if(!is_array($lang->is_search_option['trackback'])){
	$lang->is_search_option['trackback'] = array();
}
$lang->is_search_option['trackback']['url']='Target URL';
$lang->is_search_option['trackback']['blog_name']='Target Site Name';
$lang->is_search_option['trackback']['title']='Title';
$lang->is_search_option['trackback']['excerpt']='Excerpt';
if(!is_array($lang->is_sort_option)){
	$lang->is_sort_option = array();
}
$lang->is_sort_option['regdate']='Registered Date';
$lang->is_sort_option['comment_count']='Number of Comments';
$lang->is_sort_option['readed_count']='Number of Hits';
$lang->is_sort_option['voted_count']='Number of Votes';
