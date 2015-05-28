<?php if(!defined("__XE__"))exit;?><!--#Meta:modules/page/tpl/js/page_admin.js--><?php $__tmp=array('modules/page/tpl/js/page_admin.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<div class="x_page-header">
	<h1>
		<?php echo $__Context->lang->page_management ?>
		<?php if($__Context->module_info->mid){ ?><span class="path">
			&gt; <a href="<?php echo getSiteUrl($__Context->module_info->domain,'','mid',$__Context->module_info->mid) ?>"<?php if($__Context->module=='admin'){ ?> target="_blank"<?php } ?>><?php echo $__Context->module_info->mid ?></a><?php if($__Context->module_info->is_default=='Y'){ ?>(<?php echo $__Context->lang->is_default ?>)<?php } ?>
		</span><?php } ?>
		<?php if(!$__Context->module_info->mid){ ?><a href="#aboutPage" class="x_icon-question-sign" data-toggle></a><?php } ?>
	</h1>
</div>
<?php if(!$__Context->module_info->mid){ ?><p id="aboutPage" class="x_alert x_alert-info" hidden><?php echo nl2br($__Context->lang->about_page) ?></p><?php } ?>
<?php if($__Context->act != 'dispPageAdminDelete' && $__Context->module_info){ ?><ul class="x_nav x_nav-tabs">
	<?php if($__Context->module=='admin'){ ?><li<?php if($__Context->act=='dispPageAdminContent'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act','dispPageAdminContent','module_srl','') ?>"><?php echo $__Context->lang->cmd_list ?></a></li><?php } ?>
	<?php if($__Context->module!='admin'){ ?><li><a href="<?php echo getUrl('act','','module_srl','') ?>"><?php echo $__Context->lang->cmd_back ?></a></li><?php } ?>
		<?php if($__Context->module_srl){ ?>
		<li<?php if($__Context->act=='dispPageAdminInfo'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act','dispPageAdminInfo') ?>"><?php echo $__Context->lang->module_info ?></a></li>
		<li<?php if($__Context->act=='dispPageAdminPageAdditionSetup'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act','dispPageAdminPageAdditionSetup') ?>"><?php echo $__Context->lang->cmd_addition_setup ?></a></li>
		<li<?php if($__Context->act=='dispPageAdminGrantInfo'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act','dispPageAdminGrantInfo') ?>"><?php echo $__Context->lang->cmd_manage_grant ?></a></li>
			<?php if($__Context->module_info->page_type === 'ARTICLE'){ ?>
			<li<?php if($__Context->act === 'dispPageAdminSkinInfo'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act','dispPageAdminSkinInfo') ?>"><?php echo $__Context->lang->cmd_manage_skin ?></a></li>
			<li<?php if($__Context->act === 'dispPageAdminMobileSkinInfo'){ ?> class="x_active"<?php } ?>><a href="<?php echo getUrl('act','dispPageAdminMobileSkinInfo') ?>"><?php echo $__Context->lang->cmd_manage_mobile_skin ?></a></li>
			<?php } ?>
		<?php } ?>
</ul><?php } ?>
