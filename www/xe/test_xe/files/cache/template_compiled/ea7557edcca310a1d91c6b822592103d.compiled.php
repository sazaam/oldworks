<?php if(!defined("__XE__"))exit;
if($__Context->colorset=='black'){ ?><!--#Meta:widgets/login_info/skins/xe_official/css/black.css--><?php $__tmp=array('widgets/login_info/skins/xe_official/css/black.css','','','');Context::loadFile($__tmp);unset($__tmp);
} ?>
<?php if($__Context->colorset=='white'){ ?><!--#Meta:widgets/login_info/skins/xe_official/css/white.css--><?php $__tmp=array('widgets/login_info/skins/xe_official/css/white.css','','','');Context::loadFile($__tmp);unset($__tmp);
} ?>
<?php if($__Context->colorset!='black|white'){ ?><!--#Meta:widgets/login_info/skins/xe_official/css/default.css--><?php $__tmp=array('widgets/login_info/skins/xe_official/css/default.css','','','');Context::loadFile($__tmp);unset($__tmp);
} ?>
<?php require_once('./classes/xml/XmlJsFilter.class.php');$__xmlFilter=new XmlJsFilter('widgets/login_info/skins/xe_official/filter','logout.xml');$__xmlFilter->compile(); ?>
<form action="" method="post" class="login_<?php echo $__Context->colorset ?>"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="act" value="<?php echo $__Context->act ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<fieldset>
		<div class="userName">
			<a href="#popup_menu_area" class="member_<?php echo $__Context->logged_info->member_srl ?>"><?php echo $__Context->logged_info->nick_name ?></a>
			<a href="<?php echo getUrl('act','dispMemberLogout') ?>"><?php echo $__Context->lang->cmd_logout ?></a>
			<p class="latestLogin"><?php echo $__Context->lang->last_login ?>: <?php echo zDate($__Context->logged_info->last_login, "Y-m-d") ?></p>
		</div>
		<ul class="userMenu">
			<?php if($__Context->logged_info->menu_list&&count($__Context->logged_info->menu_list))foreach($__Context->logged_info->menu_list as $__Context->key=>$__Context->val){ ?><li><a href="<?php echo getUrl('', 'act',$__Context->key, 'mid', $__Context->mid, 'vid', $__Context->vid) ?>"><?php echo Context::getLang($__Context->val) ?></a></li><?php } ?>
			<?php if($__Context->logged_info->is_admin=='Y' && !$__Context->site_module_info->site_srl){ ?><li><a href="<?php echo getUrl('','module','admin') ?>"><?php echo $__Context->lang->cmd_management ?></a></li><?php } ?>
		</ul>
	</fieldset>
</form>
