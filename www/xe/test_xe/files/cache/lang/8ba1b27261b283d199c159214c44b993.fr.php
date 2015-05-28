<?php
$lang->page='Page';
$lang->none_content='This is empty page.';
$lang->cmd_manage_selected_page='Manage Selected Page';
$lang->about_page='C\'est un module qui peut créer une page complet. Vous pouvez créer une page dynamique en utilisant des gadgets des Documents derniers ou d\'autres. Vous pouvez aussi créer une page avec variété par le composant d\'editeur. L\'URL d\'accès est égal celui d\'autre module comme mid=module. Si c\'est choisi par défaut, ce sera la première page du site.';
$lang->cmd_page_modify='Modifier';
$lang->cmd_page_create='Create a Page';
$lang->cmd_page_article_create='Create an Article';
$lang->page_caching_interval='Temps de antémémoire';
$lang->about_page_caching_interval='L\'unité est minute, et ça exposera des données conservées temporairement pendant le temps assigné. Il est recommandé d\'utiliser l\'antémémoire pendant le temps convenable si beaucoup de ressource est nécessaire pour représenter les données ou l\'information d\'autre serveur. La valeur 0 signifie de ne pas utiliser antémémoire.';
$lang->about_mcontent='This is the page for the mobile view. If you do not write this page, the mobile view display reoragnized PC view\'s page.';
$lang->page_type='Page Type';
$lang->click_choice='Select';
if(!is_array($lang->page_type_name)){
	$lang->page_type_name = array();
}
$lang->page_type_name['ARTICLE']='Article Page';
$lang->page_type_name['WIDGET']='Widget Page';
$lang->page_type_name['OUTSIDE']='External Page';
$lang->about_page_type='Select Page Type to build a page. <ol><li>Widget: Create multiple widgets.</li><li>Article: Create articles with titles, contents and tags for posting page. </li><li>External Page: Use external HTML or PHP files in XE.</li></ol>';
$lang->opage_path='Location of External Document';
$lang->about_opage='This module enables to use external html or php files in XE. It allows absolute or relative path, and if the url starts with \'http://\' , it can display the external page of the server.';
$lang->about_opage_path='Please enter the location of external document. Both absolute path such as \'/path1/path2/sample.php\' or relative path such as \'../path2/sample.php\' can be used. If you input the path like \'http://url/sample.php\', the result will be received and then displayed. This is current XE\'s absolute path. ';
$lang->opage_mobile_path='Location of External Document for Mobile View';
$lang->about_opage_mobile_path='Please enter the location of external document for mobile view. If not inputted, it uses the external document specified above. Both absolute path such as \'/path1/path2/sample.php\' or relative path such as \'../path2/sample.php\' can be used. If you input the path like \'http://url/sample.php\', the result will be received and then displayed. This is current XE\'s absolute path. ';
$lang->page_management='Manage of page';
$lang->page_delete_warning='If you delete a page, the files of the page will be removed also.';
$lang->msg_not_selected_page='선택한 페이지가 없습니다.';
