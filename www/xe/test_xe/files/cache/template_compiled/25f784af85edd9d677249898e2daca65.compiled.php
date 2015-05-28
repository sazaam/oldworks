<?php if(!defined("__XE__"))exit;?><!--#Meta:modules/module/tpl/js/module_admin.js--><?php $__tmp=array('modules/module/tpl/js/module_admin.js','','','');Context::loadFile($__tmp);unset($__tmp); ?>
<div class="x_modal-header">
	<h1><?php echo $__Context->lang->module_selector ?></h1>
</div>
<form action="./" method="post" class="x_modal-body x_form-horizontal" style="max-height:none"><input type="hidden" name="error_return_url" value="<?php echo htmlspecialchars(getRequestUriByServerEnviroment(), ENT_COMPAT | ENT_HTML401, 'UTF-8', false) ?>" /><input type="hidden" name="mid" value="<?php echo $__Context->mid ?>" />
	<input type="hidden" name="module" value="module" />
	<input type="hidden" name="act" value="dispModuleSelectList" />
	<input type="hidden" name="id" value="<?php echo $__Context->id ?>" />
	<input type="hidden" name="type" value="<?php echo $__Context->type ?>" />
	<input type="hidden" name="vid" value="<?php echo $__Context->vid ?>" />
	<?php if($__Context->site_count && $__Context->logged_info->is_admin == 'Y'){ ?><div class="x_control-group">
		<label class="x_control-label" for="site_keyword"><?php echo $__Context->lang->virtual_site ?></label>
		<div class="x_controls">
			<span class="x_input-append">
				<input type="text" name="site_keyword" id="site_keyword" value="<?php echo $__Context->site_keyword ?>" />
				<input type="submit" value="<?php echo $__Context->lang->cmd_search ?>" class="x_btn" />
			</span>
			<p class="x_help-block"><?php echo $__Context->lang->about_search_virtual_site ?></p>
		</div>
	</div><?php } ?>
	<div class="x_control-group">
		<label class="x_control-label" for="selected_module"><?php echo $__Context->lang->module ?></label>
		<div class="x_controls">
			<select name="selected_module" id="selected_module">
				<?php if($__Context->mid_list&&count($__Context->mid_list))foreach($__Context->mid_list as $__Context->key=>$__Context->val){ ?><option value="<?php echo $__Context->key ?>"<?php if($__Context->selected_module == $__Context->key){ ?> selected="selected"<?php } ?>><?php echo $__Context->val->title ?></option><?php } ?>
			</select>
			<input type="submit" value="<?php echo $__Context->lang->cmd_search ?>" class="x_btn" />
		</div>
	</div>
	<table class="x_table x_table-striped x_table-hover" style="border-top:1px dotted #ddd">
		<thead>
			<tr>
				<th><?php echo $__Context->lang->mid ?></th>
				<th><?php echo $__Context->lang->browser_title ?></th>
				<th><?php echo $__Context->type=='single'?$__Context->lang->cmd_select:$__Context->lang->cmd_insert ?></th>
			<tr>
		</thead>
		<tbody>
			<?php if($__Context->module_category_exists){ ?>
			<?php if($__Context->selected_mids&&count($__Context->selected_mids))foreach($__Context->selected_mids as $__Context->key => $__Context->val){ ?>
			<tr>
				<?php  $__Context->_idx =0;  ?>
				<?php if($__Context->val&&count($__Context->val))foreach($__Context->val as $__Context->k => $__Context->v){ ?>
				<?php if($__Context->_idx >0){ ?><tr><?php } ?>
					<?php  $__Context->browser_title = str_replace("'", "\\'", htmlspecialchars($__Context->v->browser_title, ENT_COMPAT | ENT_HTML401, 'UTF-8', false));  ?>
					<td><?php echo $__Context->k ?></td>
					<td><?php echo $__Context->v->browser_title ?></td>
					<td><a href="#" onclick="insertModule('<?php echo $__Context->id ?>', <?php echo $__Context->v->module_srl ?>, '<?php echo $__Context->k ?>', '<?php echo $__Context->browser_title ?>',<?php echo $__Context->type=='single'?'false':'true' ?>); return false;" class="button green"><span><?php echo $__Context->type=='single'?$__Context->lang->cmd_select:$__Context->lang->cmd_insert ?></span></a></td>
				<?php if($__Context->_idx <count($__Context->val)){ ?></tr><?php } ?>
		<?php  $__Context->_idx ++;  ?>
		<?php } ?>
		</tr>
		<?php } ?>
		<?php }else{ ?>
		<?php if($__Context->selected_mids&&count($__Context->selected_mids))foreach($__Context->selected_mids as $__Context->key => $__Context->val){ ?>
		<?php if($__Context->val&&count($__Context->val))foreach($__Context->val as $__Context->k => $__Context->v){ ?>
		<tr>
			<td><?php echo $__Context->k ?></td>
			<td><?php echo $__Context->v->browser_title ?></td>
			<td><a href="#" onclick="insertModule('<?php echo $__Context->id ?>', <?php echo $__Context->v->module_srl ?>, '<?php echo $__Context->k ?>', '<?php echo str_replace("'","\\'",$__Context->v->browser_title) ?>',<?php echo $__Context->type=='single'?'false':'true' ?>); return false;" class="button green"><span><?php echo $__Context->type=='single'?$__Context->lang->cmd_select:$__Context->lang->cmd_insert ?></span></a></td>
		</tr>
		<?php } ?>
		<?php } ?>
		<?php } ?>
		</tbody>
	</table>
</form>
