<?php if(!defined("__XE__")) exit(); $layout_info = new stdClass;
$layout_info->site_srl = "";
$layout_info->layout = "xe_official";
$layout_info->type = "";
$layout_info->path = "./layouts/xe_official/";
$layout_info->title = "XE Official website layout";
$layout_info->description = "
        This layout is the Official website layout for XE.
        제작 : NAVER
    ";
$layout_info->version = "1.7";
$layout_info->date = "20131127";
$layout_info->homepage = "http://xpressengine.com/";
$layout_info->layout_srl = $layout_srl;
$layout_info->layout_title = $layout_title;
$layout_info->license = "";
$layout_info->license_link = "";
$layout_info->layout_type = "P";
$layout_info->author = array();
$layout_info->author[0] = new stdClass;
$layout_info->author[0]->name = "NAVER";
$layout_info->author[0]->email_address = "developers@xpressengine.com";
$layout_info->author[0]->homepage = "http://xpressengine.com/";
$layout_info->extra_var = new stdClass;
$layout_info->extra_var->colorset = new stdClass;
$layout_info->extra_var->colorset->group = "";
$layout_info->extra_var->colorset->title = "Colorset";
$layout_info->extra_var->colorset->type = "select";
$layout_info->extra_var->colorset->value = $vars->colorset;
$layout_info->extra_var->colorset->description = "Please select the colorset you want.";
$layout_info->extra_var->colorset->options = array();
$layout_info->extra_var->colorset->options["default"] = new stdClass;
$layout_info->extra_var->colorset->options["default"]->val = "Basic";
$layout_info->extra_var->colorset->options["black"] = new stdClass;
$layout_info->extra_var->colorset->options["black"]->val = "Black";
$layout_info->extra_var->colorset->options["white"] = new stdClass;
$layout_info->extra_var->colorset->options["white"]->val = "white";
$layout_info->extra_var->logo_image = new stdClass;
$layout_info->extra_var->logo_image->group = "";
$layout_info->extra_var->logo_image->title = "Logo image";
$layout_info->extra_var->logo_image->type = "image";
$layout_info->extra_var->logo_image->value = $vars->logo_image;
$layout_info->extra_var->logo_image->description = "Please input a logo image which will be displayed on the top of the layout. (Transparent image with height of 23px is recommended.)";
$layout_info->extra_var->logo_image_alt = new stdClass;
$layout_info->extra_var->logo_image_alt->group = "";
$layout_info->extra_var->logo_image_alt->title = "Logo image alt text";
$layout_info->extra_var->logo_image_alt->type = "text";
$layout_info->extra_var->logo_image_alt->value = $vars->logo_image_alt;
$layout_info->extra_var->logo_image_alt->description = "Please input a logo image alternative text which will be displayed on the top of the layout.";
$layout_info->extra_var->index_url = new stdClass;
$layout_info->extra_var->index_url->group = "";
$layout_info->extra_var->index_url->title = "Homepage URL";
$layout_info->extra_var->index_url->type = "text";
$layout_info->extra_var->index_url->value = $vars->index_url;
$layout_info->extra_var->index_url->description = "Please input the URL to redirect when user clicks the logo.";
$layout_info->extra_var->background_image = new stdClass;
$layout_info->extra_var->background_image->group = "";
$layout_info->extra_var->background_image->title = "Background Image";
$layout_info->extra_var->background_image->type = "image";
$layout_info->extra_var->background_image->value = $vars->background_image;
$layout_info->extra_var->background_image->description = "Please input if you want to use the background image.";
$layout_info->extra_var_count = "5";
$layout_info->menu_count = "1";
$layout_info->menu = new stdClass;
$layout_info->default_menu = "main_menu";
$layout_info->menu->main_menu = new stdClass;
$layout_info->menu->main_menu->name = "main_menu";
$layout_info->menu->main_menu->title = "Top menu";
$layout_info->menu->main_menu->maxdepth = "3";
$layout_info->menu->main_menu->menu_srl = $vars->main_menu;
$layout_info->menu->main_menu->xml_file = "./files/cache/menu/".$vars->main_menu.".xml.php";
$layout_info->menu->main_menu->php_file = "./files/cache/menu/".$vars->main_menu.".php";