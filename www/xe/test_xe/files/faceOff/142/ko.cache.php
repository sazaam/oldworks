<?php if(!defined("__XE__")) exit(); $layout_info = new stdClass;
$layout_info->site_srl = "0";
$layout_info->layout = "pcaa";
$layout_info->type = "";
$layout_info->path = "./layouts/pcaa/";
$layout_info->title = "??? ????";
$layout_info->description = "
			???? ?? ??? ???????. ? ??? ?? ? ? ???? ??? ???? ????.
		";
$layout_info->version = "1.0";
$layout_info->date = "20100000";
$layout_info->homepage = "";
$layout_info->layout_srl = $layout_srl;
$layout_info->layout_title = $layout_title;
$layout_info->license = "";
$layout_info->license_link = "";
$layout_info->layout_type = "P";
$layout_info->author = array();
$layout_info->author[0] = new stdClass;
$layout_info->author[0]->name = "??? ??";
$layout_info->author[0]->email_address = "sazaam@gmail.com";
$layout_info->author[0]->homepage = "http://sazaam.net/";
$layout_info->extra_var = new stdClass;
$layout_info->extra_var_count = "0";
$layout_info->menu_count = "1";
$layout_info->menu = new stdClass;
$layout_info->default_menu = "main_menu";
$layout_info->menu->main_menu = new stdClass;
$layout_info->menu->main_menu->name = "main_menu";
$layout_info->menu->main_menu->title = "?? ??";
$layout_info->menu->main_menu->maxdepth = "3";
$layout_info->menu->main_menu->menu_srl = $vars->main_menu;
$layout_info->menu->main_menu->xml_file = "./files/cache/menu/".$vars->main_menu.".xml.php";
$layout_info->menu->main_menu->php_file = "./files/cache/menu/".$vars->main_menu.".php";