<?php define('__XE__', true); require_once('C:/wamp/www/xe/test_xe/config/config.inc.php'); $oContext = Context::getInstance(); $oContext->init(); header("Content-Type: text/xml; charset=UTF-8"); header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); header("Cache-Control: no-store, no-cache, must-revalidate"); header("Cache-Control: post-check=0, pre-check=0", false); header("Pragma: no-cache"); $lang_type = Context::getLangType(); $is_logged = Context::get('is_logged'); $logged_info = Context::get('logged_info'); $site_srl = 0;$site_admin = false;if($site_srl) { $oModuleModel = getModel('module');$site_module_info = $oModuleModel->getSiteInfo($site_srl); if($site_module_info) Context::set('site_module_info',$site_module_info);else $site_module_info = Context::get('site_module_info');$grant = $oModuleModel->getGrant($site_module_info, $logged_info); if($grant->manager ==1) $site_admin = true;}if($is_logged) {if($logged_info->is_admin=="Y") $is_admin = true; else $is_admin = false; $group_srls = array_keys($logged_info->group_list); } else { $is_admin = false; $group_srls = array(); } $oContext->close(); ?><root><node node_srl="172" parent_srl="0" menu_name_key='$user_lang->userLang20140310190144084' text="<?php if(true) { $_names = array("en"=>'About',"ko"=>'About',"jp"=>'About',"zh-CN"=>'$user_lang->userLang20140310190144084',"zh-TW"=>'$user_lang->userLang20140310190144084',"fr"=>'A propos',"de"=>'$user_lang->userLang20140310190144084',"ru"=>'$user_lang->userLang20140310190144084',"es"=>'$user_lang->userLang20140310190144084',"tr"=>'$user_lang->userLang20140310190144084',"vi"=>'$user_lang->userLang20140310190144084',"mn"=>'$user_lang->userLang20140310190144084',); print $_names[$lang_type]; }?>" url="<?php print(true?"Company":"")?>" href="<?php print(true?"/xe/test_xe/Company":"")?>" is_shortcut="Y" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>"><node node_srl="167" parent_srl="172" menu_name_key='$user_lang->userLang20140310133847026' text="<?php if(true) { $_names = array("en"=>'Company',"ko"=>'Company',"jp"=>'Company',"zh-CN"=>'$user_lang->userLang20140310133847026',"zh-TW"=>'$user_lang->userLang20140310133847026',"fr"=>'La Compagnie',"de"=>'$user_lang->userLang20140310133847026',"ru"=>'$user_lang->userLang20140310133847026',"es"=>'$user_lang->userLang20140310133847026',"tr"=>'$user_lang->userLang20140310133847026',"vi"=>'$user_lang->userLang20140310133847026',"mn"=>'$user_lang->userLang20140310133847026',); print $_names[$lang_type]; }?>" url="<?php print(true?"Company":"")?>" href="<?php print(true?"/xe/test_xe/Company":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /><node node_srl="170" parent_srl="172" menu_name_key='$user_lang->userLang20140310190708076' text="<?php if(true) { $_names = array("en"=>'Company',"ko"=>'Company',"jp"=>'Company',"zh-CN"=>'$user_lang->userLang20140310133847026',"zh-TW"=>'$user_lang->userLang20140310133847026',"fr"=>'La Compagnie',"de"=>'$user_lang->userLang20140310133847026',"ru"=>'$user_lang->userLang20140310133847026',"es"=>'$user_lang->userLang20140310133847026',"tr"=>'$user_lang->userLang20140310133847026',"vi"=>'$user_lang->userLang20140310133847026',"mn"=>'$user_lang->userLang20140310133847026',"en"=>'Team',"ko"=>'Team',"jp"=>'Team',"zh-CN"=>'$user_lang->userLang20140310190708076',"zh-TW"=>'$user_lang->userLang20140310190708076',"fr"=>'L\'Equipe',"de"=>'$user_lang->userLang20140310190708076',"ru"=>'$user_lang->userLang20140310190708076',"es"=>'$user_lang->userLang20140310190708076',"tr"=>'$user_lang->userLang20140310190708076',"vi"=>'$user_lang->userLang20140310190708076',"mn"=>'$user_lang->userLang20140310190708076',); print $_names[$lang_type]; }?>" url="<?php print(true?"Team":"")?>" href="<?php print(true?"/xe/test_xe/Team":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /></node><node node_srl="237" parent_srl="0" menu_name_key='$user_lang->userLang20140310190741074' text="<?php if(true) { $_names = array("en"=>'About',"ko"=>'About',"jp"=>'About',"zh-CN"=>'$user_lang->userLang20140310190144084',"zh-TW"=>'$user_lang->userLang20140310190144084',"fr"=>'A propos',"de"=>'$user_lang->userLang20140310190144084',"ru"=>'$user_lang->userLang20140310190144084',"es"=>'$user_lang->userLang20140310190144084',"tr"=>'$user_lang->userLang20140310190144084',"vi"=>'$user_lang->userLang20140310190144084',"mn"=>'$user_lang->userLang20140310190144084',"en"=>'Projects',"ko"=>'Projects',"jp"=>'Projects',"zh-CN"=>'$user_lang->userLang20140310190741074',"zh-TW"=>'$user_lang->userLang20140310190741074',"fr"=>'Projets',"de"=>'$user_lang->userLang20140310190741074',"ru"=>'$user_lang->userLang20140310190741074',"es"=>'$user_lang->userLang20140310190741074',"tr"=>'$user_lang->userLang20140310190741074',"vi"=>'$user_lang->userLang20140310190741074',"mn"=>'$user_lang->userLang20140310190741074',); print $_names[$lang_type]; }?>" url="<?php print(true?"Highlights":"")?>" href="<?php print(true?"/xe/test_xe/Highlights":"")?>" is_shortcut="Y" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>"><node node_srl="235" parent_srl="237" menu_name_key='$user_lang->userLang20140320083617087' text="<?php if(true) { $_names = array("en"=>'Highlights',"ko"=>'Highlights',"jp"=>'Highlights',"zh-CN"=>'$user_lang->userLang20140320083617087',"zh-TW"=>'$user_lang->userLang20140320083617087',"fr"=>'Essentiels',"de"=>'$user_lang->userLang20140320083617087',"ru"=>'$user_lang->userLang20140320083617087',"es"=>'$user_lang->userLang20140320083617087',"tr"=>'$user_lang->userLang20140320083617087',"vi"=>'$user_lang->userLang20140320083617087',"mn"=>'$user_lang->userLang20140320083617087',); print $_names[$lang_type]; }?>" url="<?php print(true?"Highlights":"")?>" href="<?php print(true?"/xe/test_xe/Highlights":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /><node node_srl="125" parent_srl="237" menu_name_key='2014' text="<?php if(true) { $_names = array("en"=>'Highlights',"ko"=>'Highlights',"jp"=>'Highlights',"zh-CN"=>'$user_lang->userLang20140320083617087',"zh-TW"=>'$user_lang->userLang20140320083617087',"fr"=>'Essentiels',"de"=>'$user_lang->userLang20140320083617087',"ru"=>'$user_lang->userLang20140320083617087',"es"=>'$user_lang->userLang20140320083617087',"tr"=>'$user_lang->userLang20140320083617087',"vi"=>'$user_lang->userLang20140320083617087',"mn"=>'$user_lang->userLang20140320083617087',"en"=>'2014',"ko"=>'2014',"jp"=>'2014',"zh-CN"=>'2014',"zh-TW"=>'2014',"fr"=>'2014',"de"=>'2014',"ru"=>'2014',"es"=>'2014',"tr"=>'2014',"vi"=>'2014',"mn"=>'2014',); print $_names[$lang_type]; }?>" url="<?php print(true?"MMXIV":"")?>" href="<?php print(true?"/xe/test_xe/MMXIV":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /><node node_srl="127" parent_srl="237" menu_name_key='2013' text="<?php if(true) { $_names = array("en"=>'Highlights',"ko"=>'Highlights',"jp"=>'Highlights',"zh-CN"=>'$user_lang->userLang20140320083617087',"zh-TW"=>'$user_lang->userLang20140320083617087',"fr"=>'Essentiels',"de"=>'$user_lang->userLang20140320083617087',"ru"=>'$user_lang->userLang20140320083617087',"es"=>'$user_lang->userLang20140320083617087',"tr"=>'$user_lang->userLang20140320083617087',"vi"=>'$user_lang->userLang20140320083617087',"mn"=>'$user_lang->userLang20140320083617087',"en"=>'2014',"ko"=>'2014',"jp"=>'2014',"zh-CN"=>'2014',"zh-TW"=>'2014',"fr"=>'2014',"de"=>'2014',"ru"=>'2014',"es"=>'2014',"tr"=>'2014',"vi"=>'2014',"mn"=>'2014',"en"=>'2013',"ko"=>'2013',"jp"=>'2013',"zh-CN"=>'2013',"zh-TW"=>'2013',"fr"=>'2013',"de"=>'2013',"ru"=>'2013',"es"=>'2013',"tr"=>'2013',"vi"=>'2013',"mn"=>'2013',); print $_names[$lang_type]; }?>" url="<?php print(true?"MMXIII":"")?>" href="<?php print(true?"/xe/test_xe/MMXIII":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /><node node_srl="129" parent_srl="237" menu_name_key='2012' text="<?php if(true) { $_names = array("en"=>'Highlights',"ko"=>'Highlights',"jp"=>'Highlights',"zh-CN"=>'$user_lang->userLang20140320083617087',"zh-TW"=>'$user_lang->userLang20140320083617087',"fr"=>'Essentiels',"de"=>'$user_lang->userLang20140320083617087',"ru"=>'$user_lang->userLang20140320083617087',"es"=>'$user_lang->userLang20140320083617087',"tr"=>'$user_lang->userLang20140320083617087',"vi"=>'$user_lang->userLang20140320083617087',"mn"=>'$user_lang->userLang20140320083617087',"en"=>'2014',"ko"=>'2014',"jp"=>'2014',"zh-CN"=>'2014',"zh-TW"=>'2014',"fr"=>'2014',"de"=>'2014',"ru"=>'2014',"es"=>'2014',"tr"=>'2014',"vi"=>'2014',"mn"=>'2014',"en"=>'2013',"ko"=>'2013',"jp"=>'2013',"zh-CN"=>'2013',"zh-TW"=>'2013',"fr"=>'2013',"de"=>'2013',"ru"=>'2013',"es"=>'2013',"tr"=>'2013',"vi"=>'2013',"mn"=>'2013',"en"=>'2012',"ko"=>'2012',"jp"=>'2012',"zh-CN"=>'2012',"zh-TW"=>'2012',"fr"=>'2012',"de"=>'2012',"ru"=>'2012',"es"=>'2012',"tr"=>'2012',"vi"=>'2012',"mn"=>'2012',); print $_names[$lang_type]; }?>" url="<?php print(true?"MMXII":"")?>" href="<?php print(true?"/xe/test_xe/MMXII":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /><node node_srl="131" parent_srl="237" menu_name_key='2011' text="<?php if(true) { $_names = array("en"=>'Highlights',"ko"=>'Highlights',"jp"=>'Highlights',"zh-CN"=>'$user_lang->userLang20140320083617087',"zh-TW"=>'$user_lang->userLang20140320083617087',"fr"=>'Essentiels',"de"=>'$user_lang->userLang20140320083617087',"ru"=>'$user_lang->userLang20140320083617087',"es"=>'$user_lang->userLang20140320083617087',"tr"=>'$user_lang->userLang20140320083617087',"vi"=>'$user_lang->userLang20140320083617087',"mn"=>'$user_lang->userLang20140320083617087',"en"=>'2014',"ko"=>'2014',"jp"=>'2014',"zh-CN"=>'2014',"zh-TW"=>'2014',"fr"=>'2014',"de"=>'2014',"ru"=>'2014',"es"=>'2014',"tr"=>'2014',"vi"=>'2014',"mn"=>'2014',"en"=>'2013',"ko"=>'2013',"jp"=>'2013',"zh-CN"=>'2013',"zh-TW"=>'2013',"fr"=>'2013',"de"=>'2013',"ru"=>'2013',"es"=>'2013',"tr"=>'2013',"vi"=>'2013',"mn"=>'2013',"en"=>'2012',"ko"=>'2012',"jp"=>'2012',"zh-CN"=>'2012',"zh-TW"=>'2012',"fr"=>'2012',"de"=>'2012',"ru"=>'2012',"es"=>'2012',"tr"=>'2012',"vi"=>'2012',"mn"=>'2012',"en"=>'2011',"ko"=>'2011',"jp"=>'2011',"zh-CN"=>'2011',"zh-TW"=>'2011',"fr"=>'2011',"de"=>'2011',"ru"=>'2011',"es"=>'2011',"tr"=>'2011',"vi"=>'2011',"mn"=>'2011',); print $_names[$lang_type]; }?>" url="<?php print(true?"MMXI":"")?>" href="<?php print(true?"/xe/test_xe/MMXI":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /></node><node node_srl="135" parent_srl="0" menu_name_key='$user_lang->userLang20140310190911071' text="<?php if(true) { $_names = array("en"=>'About',"ko"=>'About',"jp"=>'About',"zh-CN"=>'$user_lang->userLang20140310190144084',"zh-TW"=>'$user_lang->userLang20140310190144084',"fr"=>'A propos',"de"=>'$user_lang->userLang20140310190144084',"ru"=>'$user_lang->userLang20140310190144084',"es"=>'$user_lang->userLang20140310190144084',"tr"=>'$user_lang->userLang20140310190144084',"vi"=>'$user_lang->userLang20140310190144084',"mn"=>'$user_lang->userLang20140310190144084',"en"=>'Projects',"ko"=>'Projects',"jp"=>'Projects',"zh-CN"=>'$user_lang->userLang20140310190741074',"zh-TW"=>'$user_lang->userLang20140310190741074',"fr"=>'Projets',"de"=>'$user_lang->userLang20140310190741074',"ru"=>'$user_lang->userLang20140310190741074',"es"=>'$user_lang->userLang20140310190741074',"tr"=>'$user_lang->userLang20140310190741074',"vi"=>'$user_lang->userLang20140310190741074',"mn"=>'$user_lang->userLang20140310190741074',"en"=>'Contact',"ko"=>'Contact',"jp"=>'Contact',"zh-CN"=>'$user_lang->userLang20140310190911071',"zh-TW"=>'$user_lang->userLang20140310190911071',"fr"=>'Contact',"de"=>'$user_lang->userLang20140310190911071',"ru"=>'$user_lang->userLang20140310190911071',"es"=>'$user_lang->userLang20140310190911071',"tr"=>'$user_lang->userLang20140310190911071',"vi"=>'$user_lang->userLang20140310190911071',"mn"=>'$user_lang->userLang20140310190911071',); print $_names[$lang_type]; }?>" url="<?php print(true?"Contact":"")?>" href="<?php print(true?"/xe/test_xe/Contact":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /><node node_srl="137" parent_srl="0" menu_name_key='$user_lang->userLang20140310190952062' text="<?php if(true) { $_names = array("en"=>'About',"ko"=>'About',"jp"=>'About',"zh-CN"=>'$user_lang->userLang20140310190144084',"zh-TW"=>'$user_lang->userLang20140310190144084',"fr"=>'A propos',"de"=>'$user_lang->userLang20140310190144084',"ru"=>'$user_lang->userLang20140310190144084',"es"=>'$user_lang->userLang20140310190144084',"tr"=>'$user_lang->userLang20140310190144084',"vi"=>'$user_lang->userLang20140310190144084',"mn"=>'$user_lang->userLang20140310190144084',"en"=>'Projects',"ko"=>'Projects',"jp"=>'Projects',"zh-CN"=>'$user_lang->userLang20140310190741074',"zh-TW"=>'$user_lang->userLang20140310190741074',"fr"=>'Projets',"de"=>'$user_lang->userLang20140310190741074',"ru"=>'$user_lang->userLang20140310190741074',"es"=>'$user_lang->userLang20140310190741074',"tr"=>'$user_lang->userLang20140310190741074',"vi"=>'$user_lang->userLang20140310190741074',"mn"=>'$user_lang->userLang20140310190741074',"en"=>'Contact',"ko"=>'Contact',"jp"=>'Contact',"zh-CN"=>'$user_lang->userLang20140310190911071',"zh-TW"=>'$user_lang->userLang20140310190911071',"fr"=>'Contact',"de"=>'$user_lang->userLang20140310190911071',"ru"=>'$user_lang->userLang20140310190911071',"es"=>'$user_lang->userLang20140310190911071',"tr"=>'$user_lang->userLang20140310190911071',"vi"=>'$user_lang->userLang20140310190911071',"mn"=>'$user_lang->userLang20140310190911071',"en"=>'Legal',"ko"=>'Legal',"jp"=>'Legal',"zh-CN"=>'$user_lang->userLang20140310190952062',"zh-TW"=>'$user_lang->userLang20140310190952062',"fr"=>'Legal',"de"=>'$user_lang->userLang20140310190952062',"ru"=>'$user_lang->userLang20140310190952062',"es"=>'$user_lang->userLang20140310190952062',"tr"=>'$user_lang->userLang20140310190952062',"vi"=>'$user_lang->userLang20140310190952062',"mn"=>'$user_lang->userLang20140310190952062',); print $_names[$lang_type]; }?>" url="<?php print(true?"Legal":"")?>" href="<?php print(true?"/xe/test_xe/Legal":"")?>" is_shortcut="N" open_window="N" expand="N" normal_btn="" hover_btn="" active_btn="" link="<?php if(true) {?><?php print $_names[$lang_type]; ?><?php }?>" /></root>