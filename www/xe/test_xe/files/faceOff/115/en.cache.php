<?php if(!defined("__XE__")) exit(); $layout_info = new stdClass;
$layout_info->site_srl = "0";
$layout_info->layout = "simplestrap";
$layout_info->type = "";
$layout_info->path = "./layouts/simplestrap/";
$layout_info->title = "Simplestrap";
$layout_info->description = "";
$layout_info->version = "1.4.1";
$layout_info->date = "20140228";
$layout_info->homepage = "";
$layout_info->layout_srl = $layout_srl;
$layout_info->layout_title = $layout_title;
$layout_info->license = "";
$layout_info->license_link = "";
$layout_info->layout_type = "P";
$layout_info->author = array();
$layout_info->author[0] = new stdClass;
$layout_info->author[0]->name = "Wincomi";
$layout_info->author[0]->email_address = "wincomi@me.com";
$layout_info->author[0]->homepage = "http://www.wincomi.com/";
$layout_info->extra_var = new stdClass;
$layout_info->extra_var->premium = new stdClass;
$layout_info->extra_var->premium->group = "";
$layout_info->extra_var->premium->title = "";
$layout_info->extra_var->premium->type = "select";
$layout_info->extra_var->premium->value = $vars->premium;
$layout_info->extra_var->premium->description = "";
$layout_info->extra_var->premium->options = array();
$layout_info->extra_var->premium->options["N"] = new stdClass;
$layout_info->extra_var->premium->options["N"]->val = "";
$layout_info->extra_var->premium->options["Y"] = new stdClass;
$layout_info->extra_var->premium->options["Y"]->val = "";
$layout_info->extra_var->premium_desk = new stdClass;
$layout_info->extra_var->premium_desk->group = "";
$layout_info->extra_var->premium_desk->title = "";
$layout_info->extra_var->premium_desk->type = "";
$layout_info->extra_var->premium_desk->value = $vars->premium_desk;
$layout_info->extra_var->premium_desk->description = "";
$layout_info->extra_var->logo_title = new stdClass;
$layout_info->extra_var->logo_title->group = "";
$layout_info->extra_var->logo_title->title = "Website Name";
$layout_info->extra_var->logo_title->type = "text";
$layout_info->extra_var->logo_title->value = $vars->logo_title;
$layout_info->extra_var->logo_title->description = "";
$layout_info->extra_var->index_url = new stdClass;
$layout_info->extra_var->index_url->group = "";
$layout_info->extra_var->index_url->title = "Website Adress";
$layout_info->extra_var->index_url->type = "text";
$layout_info->extra_var->index_url->value = $vars->index_url;
$layout_info->extra_var->index_url->description = "";
$layout_info->extra_var->logo_img = new stdClass;
$layout_info->extra_var->logo_img->group = "";
$layout_info->extra_var->logo_img->title = "홈페이지 이미지";
$layout_info->extra_var->logo_img->type = "image";
$layout_info->extra_var->logo_img->value = $vars->logo_img;
$layout_info->extra_var->logo_img->description = "";
$layout_info->extra_var->colorset = new stdClass;
$layout_info->extra_var->colorset->group = "";
$layout_info->extra_var->colorset->title = "Colorset";
$layout_info->extra_var->colorset->type = "select";
$layout_info->extra_var->colorset->value = $vars->colorset;
$layout_info->extra_var->colorset->description = "";
$layout_info->extra_var->colorset->options = array();
$layout_info->extra_var->colorset->options["info"] = new stdClass;
$layout_info->extra_var->colorset->options["info"]->val = "(Default) Skyblue";
$layout_info->extra_var->colorset->options["primary"] = new stdClass;
$layout_info->extra_var->colorset->options["primary"]->val = "Blue (default)";
$layout_info->extra_var->colorset->options["success"] = new stdClass;
$layout_info->extra_var->colorset->options["success"]->val = "Green";
$layout_info->extra_var->colorset->options["warning"] = new stdClass;
$layout_info->extra_var->colorset->options["warning"]->val = "Yellow";
$layout_info->extra_var->colorset->options["danger"] = new stdClass;
$layout_info->extra_var->colorset->options["danger"]->val = "Red";
$layout_info->extra_var->border_radius = new stdClass;
$layout_info->extra_var->border_radius->group = "";
$layout_info->extra_var->border_radius->title = "Border radius";
$layout_info->extra_var->border_radius->type = "select";
$layout_info->extra_var->border_radius->value = $vars->border_radius;
$layout_info->extra_var->border_radius->description = "";
$layout_info->extra_var->border_radius->options = array();
$layout_info->extra_var->border_radius->options["Y"] = new stdClass;
$layout_info->extra_var->border_radius->options["Y"]->val = "(Default) Yes";
$layout_info->extra_var->border_radius->options["N"] = new stdClass;
$layout_info->extra_var->border_radius->options["N"]->val = "No";
$layout_info->extra_var->box_shadow = new stdClass;
$layout_info->extra_var->box_shadow->group = "";
$layout_info->extra_var->box_shadow->title = "Shadow";
$layout_info->extra_var->box_shadow->type = "select";
$layout_info->extra_var->box_shadow->value = $vars->box_shadow;
$layout_info->extra_var->box_shadow->description = "";
$layout_info->extra_var->box_shadow->options = array();
$layout_info->extra_var->box_shadow->options["Y"] = new stdClass;
$layout_info->extra_var->box_shadow->options["Y"]->val = "(Default) Yes";
$layout_info->extra_var->box_shadow->options["N"] = new stdClass;
$layout_info->extra_var->box_shadow->options["N"]->val = "No";
$layout_info->extra_var->bootstrap2_design = new stdClass;
$layout_info->extra_var->bootstrap2_design->group = "";
$layout_info->extra_var->bootstrap2_design->title = "Bootstrap 2";
$layout_info->extra_var->bootstrap2_design->type = "select";
$layout_info->extra_var->bootstrap2_design->value = $vars->bootstrap2_design;
$layout_info->extra_var->bootstrap2_design->description = "";
$layout_info->extra_var->bootstrap2_design->options = array();
$layout_info->extra_var->bootstrap2_design->options["N"] = new stdClass;
$layout_info->extra_var->bootstrap2_design->options["N"]->val = "(기본) No";
$layout_info->extra_var->bootstrap2_design->options["Y"] = new stdClass;
$layout_info->extra_var->bootstrap2_design->options["Y"]->val = "Yes";
$layout_info->extra_var->site_frame = new stdClass;
$layout_info->extra_var->site_frame->group = "";
$layout_info->extra_var->site_frame->title = "Frame";
$layout_info->extra_var->site_frame->type = "select";
$layout_info->extra_var->site_frame->value = $vars->site_frame;
$layout_info->extra_var->site_frame->description = "";
$layout_info->extra_var->site_frame->options = array();
$layout_info->extra_var->site_frame->options["sidebar_content"] = new stdClass;
$layout_info->extra_var->site_frame->options["sidebar_content"]->val = "(Default) Sidebar + Content";
$layout_info->extra_var->site_frame->options["content_sidebar"] = new stdClass;
$layout_info->extra_var->site_frame->options["content_sidebar"]->val = "Content + Sidebar";
$layout_info->extra_var->site_frame->options["content"] = new stdClass;
$layout_info->extra_var->site_frame->options["content"]->val = "content";
$layout_info->extra_var->site_frame_content = new stdClass;
$layout_info->extra_var->site_frame_content->group = "";
$layout_info->extra_var->site_frame_content->title = "";
$layout_info->extra_var->site_frame_content->type = "text";
$layout_info->extra_var->site_frame_content->value = $vars->site_frame_content;
$layout_info->extra_var->site_frame_content->description = "";
$layout_info->extra_var->navbar_fixed = new stdClass;
$layout_info->extra_var->navbar_fixed->group = "";
$layout_info->extra_var->navbar_fixed->title = "";
$layout_info->extra_var->navbar_fixed->type = "select";
$layout_info->extra_var->navbar_fixed->value = $vars->navbar_fixed;
$layout_info->extra_var->navbar_fixed->description = "";
$layout_info->extra_var->navbar_fixed->options = array();
$layout_info->extra_var->navbar_fixed->options["Y"] = new stdClass;
$layout_info->extra_var->navbar_fixed->options["Y"]->val = "(Default) Yes";
$layout_info->extra_var->navbar_fixed->options["N"] = new stdClass;
$layout_info->extra_var->navbar_fixed->options["N"]->val = "No";
$layout_info->extra_var->navbar_color = new stdClass;
$layout_info->extra_var->navbar_color->group = "";
$layout_info->extra_var->navbar_color->title = "Navbar color";
$layout_info->extra_var->navbar_color->type = "select";
$layout_info->extra_var->navbar_color->value = $vars->navbar_color;
$layout_info->extra_var->navbar_color->description = "";
$layout_info->extra_var->navbar_color->options = array();
$layout_info->extra_var->navbar_color->options[""] = new stdClass;
$layout_info->extra_var->navbar_color->options[""]->val = "White";
$layout_info->extra_var->navbar_color->options["inverse"] = new stdClass;
$layout_info->extra_var->navbar_color->options["inverse"]->val = "Black (inverse)";
$layout_info->extra_var->navbar_search = new stdClass;
$layout_info->extra_var->navbar_search->group = "";
$layout_info->extra_var->navbar_search->title = "";
$layout_info->extra_var->navbar_search->type = "select";
$layout_info->extra_var->navbar_search->value = $vars->navbar_search;
$layout_info->extra_var->navbar_search->description = "";
$layout_info->extra_var->navbar_search->options = array();
$layout_info->extra_var->navbar_search->options["Y"] = new stdClass;
$layout_info->extra_var->navbar_search->options["Y"]->val = "Yes";
$layout_info->extra_var->navbar_search->options["N"] = new stdClass;
$layout_info->extra_var->navbar_search->options["N"]->val = "No";
$layout_info->extra_var->socialxe_login = new stdClass;
$layout_info->extra_var->socialxe_login->group = "";
$layout_info->extra_var->socialxe_login->title = "Social Login";
$layout_info->extra_var->socialxe_login->type = "select";
$layout_info->extra_var->socialxe_login->value = $vars->socialxe_login;
$layout_info->extra_var->socialxe_login->description = "";
$layout_info->extra_var->socialxe_login->options = array();
$layout_info->extra_var->socialxe_login->options["N"] = new stdClass;
$layout_info->extra_var->socialxe_login->options["N"]->val = "No";
$layout_info->extra_var->socialxe_login->options["Y"] = new stdClass;
$layout_info->extra_var->socialxe_login->options["Y"]->val = "Yes";
$layout_info->extra_var->navbar_member_point = new stdClass;
$layout_info->extra_var->navbar_member_point->group = "";
$layout_info->extra_var->navbar_member_point->title = "";
$layout_info->extra_var->navbar_member_point->type = "select";
$layout_info->extra_var->navbar_member_point->value = $vars->navbar_member_point;
$layout_info->extra_var->navbar_member_point->description = "";
$layout_info->extra_var->navbar_member_point->options = array();
$layout_info->extra_var->navbar_member_point->options["Y"] = new stdClass;
$layout_info->extra_var->navbar_member_point->options["Y"]->val = "";
$layout_info->extra_var->navbar_member_point->options["Y2"] = new stdClass;
$layout_info->extra_var->navbar_member_point->options["Y2"]->val = "";
$layout_info->extra_var->navbar_member_point->options["N"] = new stdClass;
$layout_info->extra_var->navbar_member_point->options["N"]->val = "";
$layout_info->extra_var->navbar_sm_dropdown = new stdClass;
$layout_info->extra_var->navbar_sm_dropdown->group = "";
$layout_info->extra_var->navbar_sm_dropdown->title = "";
$layout_info->extra_var->navbar_sm_dropdown->type = "select";
$layout_info->extra_var->navbar_sm_dropdown->value = $vars->navbar_sm_dropdown;
$layout_info->extra_var->navbar_sm_dropdown->description = "";
$layout_info->extra_var->navbar_sm_dropdown->options = array();
$layout_info->extra_var->navbar_sm_dropdown->options["N"] = new stdClass;
$layout_info->extra_var->navbar_sm_dropdown->options["N"]->val = "No";
$layout_info->extra_var->navbar_sm_dropdown->options["Y"] = new stdClass;
$layout_info->extra_var->navbar_sm_dropdown->options["Y"]->val = "Yes";
$layout_info->extra_var->sb_desc = new stdClass;
$layout_info->extra_var->sb_desc->group = "";
$layout_info->extra_var->sb_desc->title = "";
$layout_info->extra_var->sb_desc->type = "";
$layout_info->extra_var->sb_desc->value = $vars->sb_desc;
$layout_info->extra_var->sb_desc->description = "";
$layout_info->extra_var->sb_col = new stdClass;
$layout_info->extra_var->sb_col->group = "";
$layout_info->extra_var->sb_col->title = "";
$layout_info->extra_var->sb_col->type = "select";
$layout_info->extra_var->sb_col->value = $vars->sb_col;
$layout_info->extra_var->sb_col->description = "";
$layout_info->extra_var->sb_col->options = array();
$layout_info->extra_var->sb_col->options["2"] = new stdClass;
$layout_info->extra_var->sb_col->options["2"]->val = "";
$layout_info->extra_var->sb_col->options["3"] = new stdClass;
$layout_info->extra_var->sb_col->options["3"]->val = "";
$layout_info->extra_var->sb_submenu = new stdClass;
$layout_info->extra_var->sb_submenu->group = "";
$layout_info->extra_var->sb_submenu->title = "";
$layout_info->extra_var->sb_submenu->type = "select";
$layout_info->extra_var->sb_submenu->value = $vars->sb_submenu;
$layout_info->extra_var->sb_submenu->description = "";
$layout_info->extra_var->sb_submenu->options = array();
$layout_info->extra_var->sb_submenu->options["Y"] = new stdClass;
$layout_info->extra_var->sb_submenu->options["Y"]->val = "";
$layout_info->extra_var->sb_submenu->options["N"] = new stdClass;
$layout_info->extra_var->sb_submenu->options["N"]->val = "";
$layout_info->extra_var->sb_post = new stdClass;
$layout_info->extra_var->sb_post->group = "";
$layout_info->extra_var->sb_post->title = "";
$layout_info->extra_var->sb_post->type = "select";
$layout_info->extra_var->sb_post->value = $vars->sb_post;
$layout_info->extra_var->sb_post->description = "";
$layout_info->extra_var->sb_post->options = array();
$layout_info->extra_var->sb_post->options["Y"] = new stdClass;
$layout_info->extra_var->sb_post->options["Y"]->val = "";
$layout_info->extra_var->sb_post->options["N"] = new stdClass;
$layout_info->extra_var->sb_post->options["N"]->val = "";
$layout_info->extra_var->sb_post_count = new stdClass;
$layout_info->extra_var->sb_post_count->group = "";
$layout_info->extra_var->sb_post_count->title = "";
$layout_info->extra_var->sb_post_count->type = "text";
$layout_info->extra_var->sb_post_count->value = $vars->sb_post_count;
$layout_info->extra_var->sb_post_count->description = "";
$layout_info->extra_var->sb_post_module = new stdClass;
$layout_info->extra_var->sb_post_module->group = "";
$layout_info->extra_var->sb_post_module->title = "";
$layout_info->extra_var->sb_post_module->type = "text";
$layout_info->extra_var->sb_post_module->value = $vars->sb_post_module;
$layout_info->extra_var->sb_post_module->description = "";
$layout_info->extra_var->sb_comm = new stdClass;
$layout_info->extra_var->sb_comm->group = "";
$layout_info->extra_var->sb_comm->title = "Recent Comments";
$layout_info->extra_var->sb_comm->type = "select";
$layout_info->extra_var->sb_comm->value = $vars->sb_comm;
$layout_info->extra_var->sb_comm->description = "";
$layout_info->extra_var->sb_comm->options = array();
$layout_info->extra_var->sb_comm->options["Y"] = new stdClass;
$layout_info->extra_var->sb_comm->options["Y"]->val = "Yes";
$layout_info->extra_var->sb_comm->options["N"] = new stdClass;
$layout_info->extra_var->sb_comm->options["N"]->val = "No";
$layout_info->extra_var->sb_comm_count = new stdClass;
$layout_info->extra_var->sb_comm_count->group = "";
$layout_info->extra_var->sb_comm_count->title = "";
$layout_info->extra_var->sb_comm_count->type = "text";
$layout_info->extra_var->sb_comm_count->value = $vars->sb_comm_count;
$layout_info->extra_var->sb_comm_count->description = "";
$layout_info->extra_var->sb_comm_module = new stdClass;
$layout_info->extra_var->sb_comm_module->group = "";
$layout_info->extra_var->sb_comm_module->title = "";
$layout_info->extra_var->sb_comm_module->type = "text";
$layout_info->extra_var->sb_comm_module->value = $vars->sb_comm_module;
$layout_info->extra_var->sb_comm_module->description = "";
$layout_info->extra_var->sb_title_icon = new stdClass;
$layout_info->extra_var->sb_title_icon->group = "";
$layout_info->extra_var->sb_title_icon->title = "";
$layout_info->extra_var->sb_title_icon->type = "select";
$layout_info->extra_var->sb_title_icon->value = $vars->sb_title_icon;
$layout_info->extra_var->sb_title_icon->description = "";
$layout_info->extra_var->sb_title_icon->options = array();
$layout_info->extra_var->sb_title_icon->options["Y"] = new stdClass;
$layout_info->extra_var->sb_title_icon->options["Y"]->val = "Yes";
$layout_info->extra_var->sb_title_icon->options["N"] = new stdClass;
$layout_info->extra_var->sb_title_icon->options["N"]->val = "No";
$layout_info->extra_var->sb_widget1 = new stdClass;
$layout_info->extra_var->sb_widget1->group = "";
$layout_info->extra_var->sb_widget1->title = "Custom widget 1";
$layout_info->extra_var->sb_widget1->type = "textarea";
$layout_info->extra_var->sb_widget1->value = $vars->sb_widget1;
$layout_info->extra_var->sb_widget1->description = "Put custom widget in the sidebar. (HTML available)";
$layout_info->extra_var->sb_widget2 = new stdClass;
$layout_info->extra_var->sb_widget2->group = "";
$layout_info->extra_var->sb_widget2->title = "Custom widget 2";
$layout_info->extra_var->sb_widget2->type = "textarea";
$layout_info->extra_var->sb_widget2->value = $vars->sb_widget2;
$layout_info->extra_var->sb_widget2->description = "";
$layout_info->extra_var->sb_widget3 = new stdClass;
$layout_info->extra_var->sb_widget3->group = "";
$layout_info->extra_var->sb_widget3->title = "Custom widget 3";
$layout_info->extra_var->sb_widget3->type = "textarea";
$layout_info->extra_var->sb_widget3->value = $vars->sb_widget3;
$layout_info->extra_var->sb_widget3->description = "";
$layout_info->extra_var->jumbotron = new stdClass;
$layout_info->extra_var->jumbotron->group = "";
$layout_info->extra_var->jumbotron->title = "";
$layout_info->extra_var->jumbotron->type = "select";
$layout_info->extra_var->jumbotron->value = $vars->jumbotron;
$layout_info->extra_var->jumbotron->description = "";
$layout_info->extra_var->jumbotron->options = array();
$layout_info->extra_var->jumbotron->options["Y"] = new stdClass;
$layout_info->extra_var->jumbotron->options["Y"]->val = "Yes";
$layout_info->extra_var->jumbotron->options["N"] = new stdClass;
$layout_info->extra_var->jumbotron->options["N"]->val = "No";
$layout_info->extra_var->jumbotron_hide_mid = new stdClass;
$layout_info->extra_var->jumbotron_hide_mid->group = "";
$layout_info->extra_var->jumbotron_hide_mid->title = "";
$layout_info->extra_var->jumbotron_hide_mid->type = "text";
$layout_info->extra_var->jumbotron_hide_mid->value = $vars->jumbotron_hide_mid;
$layout_info->extra_var->jumbotron_hide_mid->description = "";
$layout_info->extra_var->jumbotron_align = new stdClass;
$layout_info->extra_var->jumbotron_align->group = "";
$layout_info->extra_var->jumbotron_align->title = "";
$layout_info->extra_var->jumbotron_align->type = "select";
$layout_info->extra_var->jumbotron_align->value = $vars->jumbotron_align;
$layout_info->extra_var->jumbotron_align->description = "";
$layout_info->extra_var->jumbotron_align->options = array();
$layout_info->extra_var->jumbotron_align->options["center"] = new stdClass;
$layout_info->extra_var->jumbotron_align->options["center"]->val = "";
$layout_info->extra_var->jumbotron_align->options["left"] = new stdClass;
$layout_info->extra_var->jumbotron_align->options["left"]->val = "";
$layout_info->extra_var->jumbotron_align->options["right"] = new stdClass;
$layout_info->extra_var->jumbotron_align->options["right"]->val = "";
$layout_info->extra_var->footer_copyright = new stdClass;
$layout_info->extra_var->footer_copyright->group = "";
$layout_info->extra_var->footer_copyright->title = "";
$layout_info->extra_var->footer_copyright->type = "textarea";
$layout_info->extra_var->footer_copyright->value = $vars->footer_copyright;
$layout_info->extra_var->footer_copyright->description = "";
$layout_info->extra_var->footer_bottom_menu = new stdClass;
$layout_info->extra_var->footer_bottom_menu->group = "";
$layout_info->extra_var->footer_bottom_menu->title = "";
$layout_info->extra_var->footer_bottom_menu->type = "select";
$layout_info->extra_var->footer_bottom_menu->value = $vars->footer_bottom_menu;
$layout_info->extra_var->footer_bottom_menu->description = "";
$layout_info->extra_var->footer_bottom_menu->options = array();
$layout_info->extra_var->footer_bottom_menu->options["N"] = new stdClass;
$layout_info->extra_var->footer_bottom_menu->options["N"]->val = "No";
$layout_info->extra_var->footer_bottom_menu->options["Y"] = new stdClass;
$layout_info->extra_var->footer_bottom_menu->options["Y"]->val = "Yes";
$layout_info->extra_var->footer_lang = new stdClass;
$layout_info->extra_var->footer_lang->group = "";
$layout_info->extra_var->footer_lang->title = "Show language select";
$layout_info->extra_var->footer_lang->type = "select";
$layout_info->extra_var->footer_lang->value = $vars->footer_lang;
$layout_info->extra_var->footer_lang->description = "";
$layout_info->extra_var->footer_lang->options = array();
$layout_info->extra_var->footer_lang->options["N"] = new stdClass;
$layout_info->extra_var->footer_lang->options["N"]->val = "No";
$layout_info->extra_var->footer_lang->options["Y"] = new stdClass;
$layout_info->extra_var->footer_lang->options["Y"]->val = "Yes";
$layout_info->extra_var->footer_bottom = new stdClass;
$layout_info->extra_var->footer_bottom->group = "";
$layout_info->extra_var->footer_bottom->title = "";
$layout_info->extra_var->footer_bottom->type = "textarea";
$layout_info->extra_var->footer_bottom->value = $vars->footer_bottom;
$layout_info->extra_var->footer_bottom->description = "";
$layout_info->extra_var->fontawesome = new stdClass;
$layout_info->extra_var->fontawesome->group = "";
$layout_info->extra_var->fontawesome->title = "";
$layout_info->extra_var->fontawesome->type = "select";
$layout_info->extra_var->fontawesome->value = $vars->fontawesome;
$layout_info->extra_var->fontawesome->description = "";
$layout_info->extra_var->fontawesome->options = array();
$layout_info->extra_var->fontawesome->options["f3_only"] = new stdClass;
$layout_info->extra_var->fontawesome->options["f3_only"]->val = "";
$layout_info->extra_var->fontawesome->options["f4_only"] = new stdClass;
$layout_info->extra_var->fontawesome->options["f4_only"]->val = "";
$layout_info->extra_var->fontawesome->options["f3_f4"] = new stdClass;
$layout_info->extra_var->fontawesome->options["f3_f4"]->val = "";
$layout_info->extra_var->fontface = new stdClass;
$layout_info->extra_var->fontface->group = "";
$layout_info->extra_var->fontface->title = "Webfont";
$layout_info->extra_var->fontface->type = "select";
$layout_info->extra_var->fontface->value = $vars->fontface;
$layout_info->extra_var->fontface->description = "";
$layout_info->extra_var->fontface->options = array();
$layout_info->extra_var->fontface->options["N"] = new stdClass;
$layout_info->extra_var->fontface->options["N"]->val = "Don't use";
$layout_info->extra_var->fontface->options["NanumGothic"] = new stdClass;
$layout_info->extra_var->fontface->options["NanumGothic"]->val = "Nanum Gothic";
$layout_info->extra_var->fontface->options["NanumGothicBold"] = new stdClass;
$layout_info->extra_var->fontface->options["NanumGothicBold"]->val = "Nanum Gothic (Bold)";
$layout_info->extra_var->fontface->options["NanumMyeongjo"] = new stdClass;
$layout_info->extra_var->fontface->options["NanumMyeongjo"]->val = "Nanum Myeonjo";
$layout_info->extra_var->fontface->options["NanumMyeongjoBold"] = new stdClass;
$layout_info->extra_var->fontface->options["NanumMyeongjoBold"]->val = "Nanum Myeonjo (Bold)";
$layout_info->extra_var->custom = new stdClass;
$layout_info->extra_var->custom->group = "";
$layout_info->extra_var->custom->title = "Custom";
$layout_info->extra_var->custom->type = "checkbox";
$layout_info->extra_var->custom->value = $vars->custom;
$layout_info->extra_var->custom->description = "";
$layout_info->extra_var->custom->options = array();
$layout_info->extra_var->custom->options["custom_style"] = new stdClass;
$layout_info->extra_var->custom->options["custom_style"]->val = "";
$layout_info->extra_var->custom->options["custom_js"] = new stdClass;
$layout_info->extra_var->custom->options["custom_js"]->val = "";
$layout_info->extra_var->custom->options["custom_top"] = new stdClass;
$layout_info->extra_var->custom->options["custom_top"]->val = "";
$layout_info->extra_var->custom->options["custom_bottom"] = new stdClass;
$layout_info->extra_var->custom->options["custom_bottom"]->val = "";
$layout_info->extra_var->custom->options["custom_content_top"] = new stdClass;
$layout_info->extra_var->custom->options["custom_content_top"]->val = "";
$layout_info->extra_var->custom->options["custom_content_bottom"] = new stdClass;
$layout_info->extra_var->custom->options["custom_content_bottom"]->val = "";
$layout_info->extra_var->custom->options["custom_sidebar_top"] = new stdClass;
$layout_info->extra_var->custom->options["custom_sidebar_top"]->val = "";
$layout_info->extra_var->custom->options["custom_sidebar_bottom"] = new stdClass;
$layout_info->extra_var->custom->options["custom_sidebar_bottom"]->val = "";
$layout_info->extra_var->custom->options["custom_jumbotron"] = new stdClass;
$layout_info->extra_var->custom->options["custom_jumbotron"]->val = "";
$layout_info->extra_var->custom->options["custom_setting"] = new stdClass;
$layout_info->extra_var->custom->options["custom_setting"]->val = "";
$layout_info->extra_var->css3pie = new stdClass;
$layout_info->extra_var->css3pie->group = "";
$layout_info->extra_var->css3pie->title = "CSS3PIE";
$layout_info->extra_var->css3pie->type = "select";
$layout_info->extra_var->css3pie->value = $vars->css3pie;
$layout_info->extra_var->css3pie->description = "";
$layout_info->extra_var->css3pie->options = array();
$layout_info->extra_var->css3pie->options["Y"] = new stdClass;
$layout_info->extra_var->css3pie->options["Y"]->val = "Yes";
$layout_info->extra_var->css3pie->options["N"] = new stdClass;
$layout_info->extra_var->css3pie->options["N"]->val = "No";
$layout_info->extra_var->code_prettify = new stdClass;
$layout_info->extra_var->code_prettify->group = "";
$layout_info->extra_var->code_prettify->title = "Code prettify";
$layout_info->extra_var->code_prettify->type = "select";
$layout_info->extra_var->code_prettify->value = $vars->code_prettify;
$layout_info->extra_var->code_prettify->description = "";
$layout_info->extra_var->code_prettify->options = array();
$layout_info->extra_var->code_prettify->options["N"] = new stdClass;
$layout_info->extra_var->code_prettify->options["N"]->val = "No";
$layout_info->extra_var->code_prettify->options["Y"] = new stdClass;
$layout_info->extra_var->code_prettify->options["Y"]->val = "Yes";
$layout_info->extra_var->xe_css_remove = new stdClass;
$layout_info->extra_var->xe_css_remove->group = "";
$layout_info->extra_var->xe_css_remove->title = "";
$layout_info->extra_var->xe_css_remove->type = "select";
$layout_info->extra_var->xe_css_remove->value = $vars->xe_css_remove;
$layout_info->extra_var->xe_css_remove->description = "";
$layout_info->extra_var->xe_css_remove->options = array();
$layout_info->extra_var->xe_css_remove->options["script"] = new stdClass;
$layout_info->extra_var->xe_css_remove->options["script"]->val = "";
$layout_info->extra_var->xe_css_remove->options["N"] = new stdClass;
$layout_info->extra_var->xe_css_remove->options["N"]->val = "";
$layout_info->extra_var_count = "43";
$layout_info->menu_count = "2";
$layout_info->menu = new stdClass;
$layout_info->default_menu = "main_menu";
$layout_info->menu->main_menu = new stdClass;
$layout_info->menu->main_menu->name = "main_menu";
$layout_info->menu->main_menu->title = "Main Menu";
$layout_info->menu->main_menu->maxdepth = "3";
$layout_info->menu->main_menu->menu_srl = $vars->main_menu;
$layout_info->menu->main_menu->xml_file = "./files/cache/menu/".$vars->main_menu.".xml.php";
$layout_info->menu->main_menu->php_file = "./files/cache/menu/".$vars->main_menu.".php";
$layout_info->menu->footer_menu = new stdClass;
$layout_info->menu->footer_menu->name = "footer_menu";
$layout_info->menu->footer_menu->title = "Footer Menu";
$layout_info->menu->footer_menu->maxdepth = "1";
$layout_info->menu->footer_menu->menu_srl = $vars->footer_menu;
$layout_info->menu->footer_menu->xml_file = "./files/cache/menu/".$vars->footer_menu.".xml.php";
$layout_info->menu->footer_menu->php_file = "./files/cache/menu/".$vars->footer_menu.".php";