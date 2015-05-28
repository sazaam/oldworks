<?php if(!defined("__XE__"))exit;?><!--#Meta:modules/admin/tpl/css/admin.bootstrap.css--><?php $__tmp=array('modules/admin/tpl/css/admin.bootstrap.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/css/admin.css--><?php $__tmp=array('modules/admin/tpl/css/admin.css','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<?php if($__Context->lang_type=='ko'){ ?><!--#Meta:modules/admin/tpl/css/admin_ko.css--><?php $__tmp=array('modules/admin/tpl/css/admin_ko.css','','','');Context::loadFile($__tmp);unset($__tmp);
} ?>
<?php if($__Context->lang_type=='en'){ ?><!--#Meta:modules/admin/tpl/css/admin_en.css--><?php $__tmp=array('modules/admin/tpl/css/admin_en.css','','','');Context::loadFile($__tmp);unset($__tmp);
} ?>
<!--#Meta:modules/admin/tpl/js/admin.js--><?php $__tmp=array('modules/admin/tpl/js/admin.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/widget/tpl/js/generate_code.js--><?php $__tmp=array('modules/widget/tpl/js/generate_code.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/js/jquery.tmpl.js--><?php $__tmp=array('modules/admin/tpl/js/jquery.tmpl.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<!--#Meta:modules/admin/tpl/js/jquery.jstree.js--><?php $__tmp=array('modules/admin/tpl/js/jquery.jstree.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<script>
	xe.lang.cmd_delete = '<?php echo $__Context->lang->cmd_delete ?>';
	jQuery(document).ready(function(){
		doFillWidgetVars();
	});
</script>
<div class="x">
	<div class="x_modal-header">
		<h1><?php echo $__Context->widget_info->title ?> <?php echo $__Context->lang->cmd_generate_code ?></h1>
	</div>
	<div id="content" class="x_modal-body">
		<p><?php echo $__Context->widget_info->description ?> <?php echo $__Context->lang->about_widget_code_in_page ?></p>
		<?php if($__Context->type=='faceoff'){ ?><form class="x_form-horizontal"><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
			<input type="hidden" name="module" value="widget" />
			<input type="hidden" name="type" value="faceoff" />
			<input type="hidden" name="act" value="dispWidgetGenerateCodeInPage" />
			<input type="hidden" name="error_return_url" value="" />
			<div class="x_control-group">
				<label for="selected_widget" class="x_control-label">
					<?php echo $__Context->lang->widget ?>
				</label>
				<div class="x_controls">
					<select name="selected_widget" id="selected_widget" style="margin:0">
						<?php if($__Context->widget_list&&count($__Context->widget_list))foreach($__Context->widget_list as $__Context->list_widget_info){ ?><option value="<?php echo $__Context->list_widget_info->widget ?>"><?php echo $__Context->list_widget_info->title ?></option><?php } ?>
					</select>
					<input type="submit" value="<?php echo $__Context->lang->cmd_select ?>" class="x_btn" />
				</div>
			</div>
		</form><?php } ?>
		<form class="x_form-horizontal" action="./" method="post" id="fo_widget"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="act" value="<?php echo $__Context->act ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" /><input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
			<input type="hidden" name="module" value="widget" />
			<input type="hidden" name="module_srl" value="<?php echo $__Context->module_srl ?>" />
			<input type="hidden" name="widget_sequence" value="" />
			<input type="hidden" name="style" value="float:left;width:100%;margin:none;padding:none;" />
			<input type="hidden" name="widget_padding_left" value="" />
			<input type="hidden" name="widget_padding_right" value="" />
			<input type="hidden" name="widget_padding_top" value="" />
			<input type="hidden" name="widget_padding_bottom" value="" />
			<input type="hidden" name="selected_widget" value="<?php echo $__Context->widget_info->widget ?>" />
			<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/widget/tpl','widget_generate_code.include.html') ?>
			<div class="btnArea">
				<input type="submit" class="x_btn x_btn-primary" value="<?php echo $__Context->lang->cmd_generate_code ?>" />
			</div>
		</form>
	</div>
	<?php $__tpl=TemplateHandler::getInstance();echo $__tpl->compile('modules/module/tpl','include.filebox.html') ?>
</div>
